local L, BigWigsLoader, InternalAPI -- Retail & Forever only module
do
	local _, tbl = ...
	InternalAPI = tbl.PrivateAPI
	L = tbl.API:GetLocale("BigWigs")
	BigWigsLoader = tbl.loaderPublic
end

--------------------------------------------------------------------------------
-- Locals
--

local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local SOUND = LibSharedMedia.MediaType and LibSharedMedia.MediaType.SOUND or "sound"
local RefreshAuraSounds
local GetUnitToken, IterateGroup
local ProfileUtils = {}

--------------------------------------------------------------------------------
-- Saved Settings
--

local db
do
	local defaults = {
		sounds = {},
	}

	local validUnits = {
		player = true,
		tank = true,
		name = true,
		boss = true,
		enemy = true,
	}

	db = BigWigsLoader.db:RegisterNamespace("AuraSounds", {profile = defaults})

	local function CopyTable(settingsTable)
		local copy = {}
		for key, value in next, settingsTable do
			if type(value) == "table" then
				copy[key] = CopyTable(value)
			else
				copy[key] = value
			end
		end
		return copy
	end

	ProfileUtils.ValidateMainSettings = function()
		for k, v in next, db.profile do
			local defaultType = type(defaults[k])
			if defaultType == "nil" then
				db.profile[k] = nil
			elseif type(v) ~= defaultType then
				if defaultType == "table" then
					db.profile[k] = CopyTable(defaults[k])
				else
					db.profile[k] = defaults[k]
				end
			end
		end

		local numSounds = #db.profile.sounds
		for k in next, db.profile.sounds do
			if type(k) ~= "number" or k < 1 or k > numSounds or math.floor(k+0.5) ~= k then
				db.profile.sounds[k] = nil
			end
		end

		for soundIndex = #db.profile.sounds, 1, -1 do
			local soundInfo = db.profile.sounds[soundIndex]
			-- Not a table, or spellID is invalid | XXX temp also remove voice countdown support 12.1.5
			if type(soundInfo) ~= "table" or type(soundInfo.spellID) ~= "number" or math.floor(soundInfo.spellID+0.5) ~= soundInfo.spellID or not C_Spell.DoesSpellExist(soundInfo.spellID) or not BigWigsLoader.GetSpellName(soundInfo.spellID) or soundInfo.voice or soundInfo.duration then
				table.remove(db.profile.sounds, soundIndex)
			else
				if type(soundInfo.enabled) ~= "boolean" then
					soundInfo.enabled = true
				end
				if type(soundInfo.trigger) ~= "number" or soundInfo.trigger < 0 or soundInfo.trigger > 2 or math.floor(soundInfo.trigger+0.5) ~= soundInfo.trigger then
					soundInfo.trigger = 0
				end
				if type(soundInfo.unit) ~= "string" or not validUnits[soundInfo.unit] then
					soundInfo.unit = "player"
				end
				if soundInfo.unit ~= "name" or type(soundInfo.playerName) ~= "string" then
					soundInfo.playerName = nil
				else
					local trimmed = string.trim(soundInfo.playerName)
					soundInfo.playerName = trimmed ~= "" and trimmed or nil
				end
				if type(soundInfo.throttleSeconds) ~= "number" then
					soundInfo.throttleSeconds = 1
				elseif soundInfo.throttleSeconds > 5 then
					soundInfo.throttleSeconds = 5
				elseif soundInfo.throttleSeconds < 0 then
					soundInfo.throttleSeconds = 0
				end
			end
		end
	end
	ProfileUtils.ValidateMediaSettings = function()
		for soundIndex = 1, #db.profile.sounds do
			local soundInfo = db.profile.sounds[soundIndex]
			if type(soundInfo.sound) ~= "string" or not LibSharedMedia:IsValid("sound", soundInfo.sound) then
				soundInfo.sound = "None"
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Widgets & Events
--

do
	local raidList = {
		"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
		"raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
		"raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
		"raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
	}
	local partyList = {"player", "party1", "party2", "party3", "party4"}
	local GetNumGroupMembers, IsInRaid = GetNumGroupMembers, IsInRaid
	function IterateGroup()
		local num = GetNumGroupMembers() or 0
		local i = 0
		local size = num > 0 and num+1 or 2
		local function iter(t)
			i = i + 1
			if i < size then
				return t[i]
			end
		end
		return iter, IsInRaid() and raidList or partyList
	end
end

function GetUnitToken(playerType, playerName)
	if playerType == "tank" then
		for unit in IterateGroup() do
			if not UnitIsUnit("player", unit) and UnitGroupRolesAssigned(unit) == "TANK" then
				return unit
			end
		end
	elseif playerName and playerName ~= "" and UnitExists(playerName) then
		for unit in IterateGroup() do
			if UnitIsUnit(playerName, unit) then
				return unit
			end
		end
	end
end

do
	local IsAuraSoundRestrictionsActive
	do
		local IsAddOnRestrictionActive = C_RestrictedActions.IsAddOnRestrictionActive
		function IsAuraSoundRestrictionsActive()
			if IsAddOnRestrictionActive(1) or (IsAddOnRestrictionActive(0) and IsAddOnRestrictionActive(2)) then
				return true -- Encounter, or Combat+ChallengeMode
			end
		end
	end
	local auraSounds = {}
	local registeredUnits = {}
	local bossList = {
		"boss1", "boss2", "boss3", "boss4", "boss5",
	}
	local nameplateList = {
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
	}

	local frame = CreateFrame("Frame")
	local rosterTimer = nil
	local lastRosterCheck = 0
	local function CheckRosterUpdate()
		rosterTimer = nil
		if IsAuraSoundRestrictionsActive() then
			frame:UnregisterEvent("GROUP_ROSTER_UPDATE")
			frame:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
			return -- Don't process anything during active restrictions, do it afterwards
		end
		lastRosterCheck = GetTime()

		local cacheTank, cachePlayers
		for index, unit in next, registeredUnits do
			local auraDB = db.profile.sounds[index]
			local checkUnit
			if auraDB.unit == "tank" then
				if cacheTank ~= nil then
					checkUnit = cacheTank
				else
					checkUnit = GetUnitToken(auraDB.unit) or false
					cacheTank = checkUnit
				end
			else
				if not cachePlayers then cachePlayers = {} end
				if cachePlayers[auraDB.playerName] ~= nil then
					checkUnit = cachePlayers[auraDB.playerName]
				else
					checkUnit = GetUnitToken(auraDB.unit, auraDB.playerName) or false
					cachePlayers[auraDB.playerName] = checkUnit
				end
			end
			if unit ~= checkUnit then
				RefreshAuraSounds()
				return
			end
		end
	end

	frame:SetScript("OnEvent", function(self, event)
		if event == "GROUP_ROSTER_UPDATE" then
			if IsAuraSoundRestrictionsActive() then
				if rosterTimer then
					rosterTimer:Cancel()
					rosterTimer = nil
				end
				self:UnregisterEvent(event)
				self:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
				return -- Don't process anything during active restrictions, do it afterwards
			end

			if not rosterTimer then
				local timeSinceLastCheck = GetTime() - lastRosterCheck
				if timeSinceLastCheck >= 1 then
					CheckRosterUpdate()
				else
					rosterTimer = BigWigsLoader.CTimerNewTimer(1, CheckRosterUpdate)
				end
			end
		elseif event == "ADDON_RESTRICTION_STATE_CHANGED" then
			if IsAuraSoundRestrictionsActive() then
				return
			end
			self:UnregisterEvent(event)
			RefreshAuraSounds()
		end
	end)

	local function RegisterAuraSound(info, unitToken, soundFile)
		local auraSoundID = C_UnitAuras.AddAuraSound(info.trigger, {
			unitToken = unitToken,
			spellID = info.spellID,
			soundFileName = type(soundFile) == "string" and soundFile or nil,
			soundFileID = type(soundFile) == "number" and soundFile or nil,
			outputChannel = "master",
			throttleSeconds = info.throttleSeconds,
		})
		if auraSoundID then
			auraSounds[#auraSounds + 1] = auraSoundID
		end
	end

	local function AddAllAuraSounds()
		local cacheTank, cachePlayers
		for index = 1, #db.profile.sounds do
			local info = db.profile.sounds[index]
			if info.enabled and info.sound ~= "None" then
				local unit = info.unit
				if unit == "tank" then
					frame:RegisterEvent("GROUP_ROSTER_UPDATE")
					if cacheTank ~= nil then
						unit = cacheTank
					else
						unit = GetUnitToken("tank") or false
						cacheTank = unit
					end
					registeredUnits[index] = unit
				elseif unit == "name" then
					if info.playerName then
						frame:RegisterEvent("GROUP_ROSTER_UPDATE")
						if not cachePlayers then cachePlayers = {} end
						if cachePlayers[info.playerName] ~= nil then
							unit = cachePlayers[info.playerName]
						else
							unit = GetUnitToken("name", info.playerName) or false
							cachePlayers[info.playerName] = unit
						end
						registeredUnits[index] = unit
					else
						unit = nil
					end
				end

				local soundFile = LibSharedMedia:Fetch("sound", info.sound, true)
				if unit and soundFile then
					if unit == "boss" then
						for i = 1, #bossList do
							RegisterAuraSound(info, bossList[i], soundFile)
						end
					elseif unit == "enemy" then
						for i = 1, #nameplateList do
							RegisterAuraSound(info, nameplateList[i], soundFile)
						end
					else
						RegisterAuraSound(info, unit, soundFile)
					end
				end
			end
		end
	end

	local function RemoveAllAuraSounds()
		if rosterTimer then
			rosterTimer:Cancel()
			rosterTimer = nil
		end
		frame:UnregisterEvent("GROUP_ROSTER_UPDATE")
		for i = 1, #auraSounds do
			C_UnitAuras.RemoveAuraSound(auraSounds[i])
		end
		auraSounds = {}
		registeredUnits = {}
	end

	function RefreshAuraSounds()
		if IsAuraSoundRestrictionsActive() then
			if rosterTimer then
				rosterTimer:Cancel()
				rosterTimer = nil
			end
			frame:UnregisterEvent("GROUP_ROSTER_UPDATE")
			frame:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
			return
		end
		RemoveAllAuraSounds()
		AddAllAuraSounds()
	end
end

--------------------------------------------------------------------------------
-- Options Table
--

do
	local roleIcons = {
		["TANK"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Tank:0|t",
		["HEALER"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Healer:0|t",
		["DAMAGER"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Damage:0|t",
		["NONE"] = "",
	}

	local function GetSoundOptions()
		local optionsTable = {
			type = "group",
			name = L.auraSounds,
			order = 6,
			args = {},
		}
		local options = optionsTable.args

		options.header = {
			type = "description",
			name = L.addAuraSpellDesc,
			fontSize = "medium",
			order = 1,
		}
		options.add = {
			type = "input",
			name = L.addAuraSpell,
			get = false,
			set = function(_, value)
				value = string.trim(value) -- Trim leading/trailing spaces
				local spellID = C_Spell.GetSpellIDForSpellIdentifier(value)
				table.insert(db.profile.sounds, {
					enabled = true,
					spellID = spellID,
					trigger = 0,
					unit = "player",
					sound = "None",
					throttleSeconds = 1,
				})
				BigWigsLoader:SendMessage("BigWigs_PluginOptionsUpdate", "Auras")
			end,
			validate = function(_, value)
				value = string.trim(value) -- Trim leading/trailing spaces
				local spellID = C_Spell.GetSpellIDForSpellIdentifier(value)
				if not spellID or not C_Spell.DoesSpellExist(spellID) or not BigWigsLoader.GetSpellName(spellID) then
					return ("%s: %s"):format(L.auras, L.invalidSpell)
				end
				return true
			end,
			order = 2,
		}

		local function FindSoundIndex(soundInfo)
			for i = 1, #db.profile.sounds do
				if db.profile.sounds[i] == soundInfo then
					return i
				end
			end
		end
		local function Get(info)
			return info.arg[info[#info]]
		end
		local function Set(info, value)
			local auraDB = info.arg
			if not FindSoundIndex(auraDB) then return end
			local key = info[#info]
			auraDB[key] = value
			if key == "unit" and value ~= "name" then
				auraDB.playerName = nil
			end
			RefreshAuraSounds()
		end

		local function RemoveSoundFromConfig(info)
			local index = FindSoundIndex(info.arg)
			if not index then return end
			table.remove(db.profile.sounds, index)
			RefreshAuraSounds()
			BigWigsLoader:SendMessage("BigWigs_PluginOptionsUpdate", "Auras")
		end
		local function ConfirmRemoveSound(info)
			local soundInfo = info.arg
			return L.confirmRemoveAuraSound:format(BigWigsLoader.GetSpellName(soundInfo.spellID), soundInfo.spellID)
		end

		local function GetSound(info)
			local sound = info.arg.sound
			for i, v in next, LibSharedMedia:List(SOUND) do
				if v == sound then
					return i
				end
			end
		end
		local function SetSound(info, value)
			Set(info, LibSharedMedia:List(SOUND)[value])
		end

		local function PlayerNameValues(info)
			local playerList = {}
			local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
			for unit in IterateGroup() do
				if not UnitIsUnit("player", unit) and not UnitInPartyIsAI(unit) then
					local name = BigWigsLoader.UnitName(unit)
					if name then
						local _, class = UnitClass(unit)
						local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
						playerList[name] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
					end
				end
			end
			local soundInfo = info.arg
			if soundInfo.playerName and not playerList[soundInfo.playerName] then
				playerList[soundInfo.playerName] = GRAY_FONT_COLOR:WrapTextInColorCode(soundInfo.playerName)
			end
			return playerList
		end
		local function PlayerNameHidden(info)
			return info.arg.unit ~= "name"
		end

		local function UnitDescName(info)
			local unitType = info.arg.unit
			if unitType == "tank" then
				local name = L.none
				local unit = GetUnitToken("tank")
				if unit then
					local unitName = BigWigsLoader.UnitName(unit)
					if unitName then
						local _, class = UnitClass(unit)
						local color = class and C_ClassColor.GetClassColor(class) or GRAY_FONT_COLOR
						name = color:WrapTextInColorCode(unitName)
					end
				end
				return L.auraSoundTankDesc:format(name)
			elseif unitType == "boss" then
				return L.auraSoundBossDesc
			elseif unitType == "enemy" then
				return L.auraSoundEnemyDesc
			end
			return ""
		end
		local function UnitDescHidden(info)
			local unitType = info.arg.unit
			return unitType ~= "tank" and unitType ~= "boss" and unitType ~= "enemy"
		end
		local function GetSpellDesc(info)
			local desc = BigWigsLoader.GetSpellDescription(info.arg.spellID)
			if desc then
				-- Remove stray CR+LF for e.g. 299250 spells that show another spell in their tooltip which isn't part of GetSpellDescription
				desc = desc:gsub("[\r\n]+$", "")
				if desc ~= "" then
					return desc
				end
			end
		end

		local order = 0
		for soundIndex = #db.profile.sounds, 1, -1 do
			order = order + 1
			local soundInfo = db.profile.sounds[soundIndex]
			if not C_Spell.IsSpellDataCached(soundInfo.spellID) then
				C_Spell.RequestLoadSpellData(soundInfo.spellID)
			end
			options[tostring(soundIndex)] = {
				type = "group",
				name = " ",
				inline = true,
				order = order + 10,
				get = Get,
				set = Set,
				args = {
					enabled = {
						type = "toggle",
						name = ("|cfffed000%s|r (%d)"):format(BigWigsLoader.GetSpellName(soundInfo.spellID), soundInfo.spellID),
						desc = GetSpellDesc,
						image = BigWigsLoader.GetSpellTexture(soundInfo.spellID) or 134400, -- question mark
						arg = soundInfo,
						width = 2.6,
						order = 1,
					},
					remove = {
						type = "execute",
						name = L.remove,
						func = RemoveSoundFromConfig,
						confirm = ConfirmRemoveSound,
						arg = soundInfo,
						width = 0.6,
						order = 2,
					},
					trigger = {
						type = "select",
						name = L.trigger,
						values = {
							[0] = L.onApplied,
							[1] = L.onDose,
							[2] = L.onRemoved,
						},
						arg = soundInfo,
						width = 1,
						order = 3,
					},
					sound = {
						type = "select",
						name = L.sound,
						get = GetSound,
						set = SetSound,
						values = LibSharedMedia:List(SOUND),
						dialogControl = "BigWigsSharedDropdown",
						itemControl = "DDI-Sound",
						arg = soundInfo,
						width = 2,
						order = 4,
					},
					unit = {
						type = "select",
						name = L.target,
						values = {
							player = L.myself,
							tank = L.indicatorType_Tank,
							name = L.playerInYourGroup,
							boss = L.boss,
							enemy = L.enemy,
						},
						sorting = { "player", "tank", "name", "boss", "enemy" },
						arg = soundInfo,
						width = 1,
						order = 5,
					},
					throttleSeconds = {
						type = "range",
						name = L.throttle,
						desc = L.throttleDesc,
						min = 0, max = 5, step = 0.1,
						arg = soundInfo,
						width = 2,
						order = 6,
					},
					playerName = {
						type = "select",
						name = L.playerInYourGroup,
						values = PlayerNameValues,
						hidden = PlayerNameHidden,
						arg = soundInfo,
						width = 1.6,
						order = 7,
					},
					unitDesc = {
						type = "description",
						name = UnitDescName,
						hidden = UnitDescHidden,
						arg = soundInfo,
						width = "full",
						order = 8,
					},
				},
			}
		end

		return optionsTable
	end

	InternalAPI.RegisterPluginOptionsCustomTab("Auras", "sounds", GetSoundOptions)
end

--------------------------------------------------------------------------------
-- Login
--

do
	local function UpdateProfile()
		ProfileUtils.ValidateMainSettings()
		ProfileUtils.ValidateMediaSettings()
		RefreshAuraSounds()
		BigWigsLoader:SendMessage("BigWigs_PluginOptionsUpdate", "Auras")
	end

	local loginFrame = CreateFrame("Frame")
	loginFrame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
		UpdateProfile()
		BigWigsLoader.RegisterMessage(loginFrame, "BigWigs_ProfileUpdate", UpdateProfile)
	end)
	loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	ProfileUtils.ValidateMainSettings()
end
