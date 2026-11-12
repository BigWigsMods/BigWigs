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
local AddAllAuraSounds, RemoveAllAuraSounds
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

		for soundIndex = #db.profile.sounds, 1, -1 do
			local soundInfo = db.profile.sounds[soundIndex]
			-- Not a table, or spellID is invalid | XXX temp also remove voice countdown support 12.1.5
			if type(soundInfo) ~= "table" or type(soundInfo.spellID) ~= "number" or not BigWigsLoader.GetSpellName(soundInfo.spellID) or soundInfo.voice or soundInfo.duration then
				table.remove(db.profile.sounds, soundIndex)
			else
				if type(soundInfo.enabled) ~= "boolean" then
					soundInfo.enabled = true
				end
				if type(soundInfo.trigger) ~= "number" or soundInfo.trigger < 0 or soundInfo.trigger > 2 or math.floor(soundInfo.trigger+0.5) ~= soundInfo.trigger then
					soundInfo.trigger = 0
				end
				if type(soundInfo.unit) ~= "string" or (soundInfo.unit ~= "player" and soundInfo.unit ~= "tank" and soundInfo.unit ~= "name") then
					soundInfo.unit = "player"
				end
				if soundInfo.unit ~= "name" or (soundInfo.unit == "name" and type(soundInfo.playerName) ~= "string") then
					soundInfo.playerName = nil
				end
				if type(soundInfo.sound) ~= "string" or not LibSharedMedia:IsValid("sound", soundInfo.sound) then
					soundInfo.sound = "None"
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

	local frame = CreateFrame("Frame")
	frame:SetScript("OnEvent", function(self, event)
		if event == "GROUP_ROSTER_UPDATE" then
			if IsAuraSoundRestrictionsActive() then
				self:UnregisterEvent(event)
				self:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
				return -- Don't process anything during active restrictions, do it afterwards
			end

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
					RemoveAllAuraSounds()
					AddAllAuraSounds()
					return
				end
			end
		elseif event == "ADDON_RESTRICTION_STATE_CHANGED" then
			if IsAuraSoundRestrictionsActive() then
				return
			end
			self:UnregisterEvent(event)
			RemoveAllAuraSounds()
			AddAllAuraSounds()
		end
	end)

	function AddAllAuraSounds()
		if IsAuraSoundRestrictionsActive() then
			frame:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
			return
		end

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
					local auraSoundID = C_UnitAuras.AddAuraSound(info.trigger, {
						unitToken = unit,
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
			end
		end
	end

	function RemoveAllAuraSounds()
		for i = 1, #auraSounds do
			C_UnitAuras.RemoveAuraSound(auraSounds[i])
		end
		auraSounds = {}
		registeredUnits = {}
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
				local spellID = C_Spell.GetSpellIDForSpellIdentifier(value)
				table.insert(db.profile.sounds, {
					enabled = true,
					spellID = spellID,
					trigger = 0,
					unit = "player",
					sound = "None",
					throttleSeconds = 1,
				})
				BigWigsLoader.CTimerAfter(0, function() BigWigsLoader:SendMessage("BigWigs_PluginOptionsUpdate", "Auras") end)
			end,
			validate = function(_, value)
				if not C_Spell.GetSpellIDForSpellIdentifier(value) then
					return ("%s: %s"):format(L.auras, L.invalidSpell)
				end
				return true
			end,
			order = 2,
		}

		local function Get(info)
			local index = tonumber(info[#info - 1])
			if not db.profile.sounds[index] then return false end
			local key = info[#info]
			return db.profile.sounds[index][key]
		end
		local function Set(info, value)
			local index = tonumber(info[#info - 1])
			local auraDB = db.profile.sounds[index]
			local key = info[#info]
			auraDB[key] = value
			if key == "unit" and value ~= "name" then
				auraDB.playerName = nil
			end
			RemoveAllAuraSounds()
			AddAllAuraSounds()
		end

		local function RemoveSoundFromConfig(info)
			local index = tonumber(info[#info - 1])
			table.remove(db.profile.sounds, index)
			RemoveAllAuraSounds()
			AddAllAuraSounds()
			BigWigsLoader.CTimerAfter(0, function() BigWigsLoader:SendMessage("BigWigs_PluginOptionsUpdate", "Auras") end)
		end

		local function GetSound(info)
			local index = tonumber(info[#info - 1])
			if not db.profile.sounds[index] then return false end
			local sound = db.profile.sounds[index].sound
			for i, v in next, LibSharedMedia:List(SOUND) do
				if v == sound then
					return i
				end
			end
		end
		local function SetSound(info, value)
			Set(info, LibSharedMedia:List(SOUND)[value])
		end

		local function PlayerNameValues()
			local playerList = {}
			local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
			for unit in IterateGroup() do
				if not UnitInPartyIsAI(unit) then
					local name = BigWigsLoader.UnitName(unit)
					local _, class = UnitClass(unit)
					local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
					playerList[name] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
				end
			end
			return playerList
		end
		local function PlayerNameHidden(info)
			local index = tonumber(info[#info - 1])
			if not db.profile.sounds[index] then return false end
			return db.profile.sounds[index].unit ~= "name"
		end

		local function UnitTargetName()
			local name = L.none
			local unit = GetUnitToken("tank")
			if unit then
				name = BigWigsLoader.UnitName(unit)
				local _, class = UnitClass(unit)
				local color = C_ClassColor.GetClassColor(class) or GRAY_FONT_COLOR
				name = color:WrapTextInColorCode(name)
			end
			return "  "..L.currentUnit:format(name)
		end
		local function UnitTargetHidden(info)
			local index = tonumber(info[#info - 1])
			if not db.profile.sounds[index] then return false end
			return db.profile.sounds[index].unit ~= "tank"
		end

		local order = 0
		for soundIndex = #db.profile.sounds, 1, -1 do
			order = order + 1
			local soundInfo = db.profile.sounds[soundIndex]
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
						name = ("|cfffed000%s|r (%d)"):format(BigWigsLoader.GetSpellName(soundInfo.spellID) or L.unknown, soundInfo.spellID),
						image = BigWigsLoader.GetSpellTexture(soundInfo.spellID) or 134400, -- question mark
						width = 2.6,
						order = 1,
					},
					remove = {
						type = "execute",
						name = L.remove,
						func = RemoveSoundFromConfig,
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
						width = 2,
						order = 4,
					},
					unit = {
						type = "select",
						name = L.selectPlayer,
						values = {
							player = L.myself,
							tank = L.indicatorType_Tank,
							name = L.playerInYourGroup,
						},
						sorting = { "player", "tank", "name" },
						width = 1,
						order = 5,
					},
					playerName = {
						type = "select",
						name = L.playerInYourGroup,
						values = PlayerNameValues,
						hidden = PlayerNameHidden,
						width = 1.6,
						order = 6,
					},
					unitTarget = {
						type = "description",
						name = UnitTargetName,
						hidden = UnitTargetHidden,
						width = 1.2,
						order = 7,
					},
					throttleSeconds = {
						type = "range",
						name = L.throttle,
						desc = L.throttleDesc,
						min = 0, max = 5, step = 0.1,
						width = 2,
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
		RemoveAllAuraSounds()
		AddAllAuraSounds()
		BigWigsLoader.CTimerAfter(0, function() BigWigsLoader:SendMessage("BigWigs_PluginOptionsUpdate", "Auras") end)
	end

	local loginFrame = CreateFrame("Frame")
	loginFrame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
		UpdateProfile()
		BigWigsLoader.RegisterMessage(loginFrame, "BigWigs_ProfileUpdate", UpdateProfile)
	end)
	loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end
