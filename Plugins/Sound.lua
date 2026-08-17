-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Sounds", {
	"db",
	"soundOptions",
	"SetSoundOptions",
	"GetSoundFile",
	"GetDefaultSound",
	"GetDefaultSoundFile",
})
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local SOUND = LibSharedMedia.MediaType and LibSharedMedia.MediaType.SOUND or "sound"
local soundList = nil
local db
local sounds = {
	Long = "BigWigs: Long",
	Info = "BigWigs: Info",
	Alert = "BigWigs: Alert",
	Alarm = "BigWigs: Alarm",
	Warning = "BigWigs: Raid Warning",
	--onyou = L.spell_on_you,
	underyou = L.spell_under_you,
	privateaura = "BigWigs: Raid Warning",
}
local validGlobalSounds = {
	[L.spell_under_you] = "underyou",
}
local allowBlizzMessages = true
local registeredAuraModules = {}

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	media = {
		Long = sounds.Long,
		Info = sounds.Info,
		Alert = sounds.Alert,
		Alarm = sounds.Alarm,
		Warning = sounds.Warning,
		--onyou = L.spell_on_you,
		underyou = L.spell_under_you,
		privateaura = sounds.privateaura,
	},
	Long = {},
	Info = {},
	Alert = {},
	Alarm = {},
	Warning = {},
	underyou = {},
	privateaura = {},
}

local function updateProfile()
	db = plugin.db.profile
	local printTbl, blockedFromPrints = {}, {}
	for k, v in next, db do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			db[k] = plugin.defaultDB[k]
		elseif sounds[k] then
			for bossModuleName, soundTbl in next, v do
				for optionKey, soundName in next, soundTbl do
					if not LibSharedMedia:IsValid("sound", soundName) then
						soundTbl[optionKey] = nil -- Invalid sound, remove
						if not blockedFromPrints[soundName] then
							blockedFromPrints[soundName] = true
							local moduleName = bossModuleName:sub(16) -- Remove "BigWigs_Bosses_" text
							printTbl[#printTbl+1] = L.soundResetPrint:format(moduleName, soundName)
						end
					end
				end
				if not next(soundTbl) then
					db[k][bossModuleName] = nil -- Sounds list for this boss module is an empty table, remove it
				end
			end
		end
	end

	for k, v in next, db.media do
		local defaultType = type(plugin.defaultDB.media[k])
		if defaultType == "nil" then
			db.media[k] = nil
		elseif type(v) ~= defaultType then
			db.media[k] = plugin.defaultDB.media[k] -- Invalid type, reset
		elseif not LibSharedMedia:IsValid("sound", v) then
			db.media[k] = plugin.defaultDB.media[k] -- Invalid sound, reset
			if not blockedFromPrints[v] then
				blockedFromPrints[v] = true
				printTbl[#printTbl+1] = L.soundResetPrint:format(plugin.moduleName, v)
			end
		end
	end

	if printTbl[1] then
		plugin:SimpleTimer(function()
			for i = 1, #printTbl do
				plugin:Print(printTbl[i])
			end
		end, 0)
	end
end

--------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	type = "group",
	name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Sounds:20|t ".. L.Sounds,
	get = function(info)
		for i, v in next, soundList do
			if v == db.media[info[#info]] then
				return i
			end
		end
	end,
	set = function(info, value)
		local sound = info[#info]
		db.media[sound] = soundList[value]
		plugin:UnregisterAllAuraSounds()
		plugin:CheckAllBossModulesForAuraSounds()
		plugin:PlaySoundFile(LibSharedMedia:Fetch(SOUND, soundList[value]))
	end,
	order = 7,
	args = {
		heading = {
			type = "description",
			name = L.soundsDesc,
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		-- Begin sound dropdowns
		--onyou = {
		--	type = "select",
		--	name = L.onyou,
		--	order = 2,
		--	values = function() return soundList end,
		--	width = "full",
		--	itemControl = "DDI-Sound",
		--},
		underyou = {
			type = "select",
			name = L.underyou,
			order = 3,
			values = function() return soundList end,
			width = "full",
			itemControl = "DDI-Sound",
		},
		--privateaura = {
		--	type = "select",
		--	name = L.privateaura,
		--	order = 4,
		--	values = function() return soundList end,
		--	width = "full",
		--	itemControl = "DDI-Sound",
		--	hidden = BigWigsLoader.isClassic,
		--},
		newline2 = {
			type = "description",
			name = "\n\n",
			order = 20,
		},
		oldSounds = {
			type = "header",
			name = L.oldSounds,
			order = 21,
		},
		Alarm = {
			type = "select",
			name = L.Alarm,
			order = 22,
			values = function() return soundList end,
			width = "full",
			itemControl = "DDI-Sound",
		},
		Alert = {
			type = "select",
			name = L.Alert,
			order = 23,
			values = function() return soundList end,
			width = "full",
			itemControl = "DDI-Sound",
		},
		Info = {
			type = "select",
			name = L.Info,
			order = 24,
			values = function() return soundList end,
			width = "full",
			itemControl = "DDI-Sound",
		},
		Long = {
			type = "select",
			name = L.Long,
			order = 25,
			values = function() return soundList end,
			width = "full",
			itemControl = "DDI-Sound",
		},
		Warning = {
			type = "select",
			name = L.Warning,
			order = 26,
			values = function() return soundList end,
			width = "full",
			itemControl = "DDI-Sound",
		},
		-- End sound dropdowns
		reset = {
			type = "execute",
			name = L.reset,
			desc = L.resetSoundDesc,
			func = function()
				for k in next, plugin.db.profile.media do
					plugin.db.profile.media[k] = sounds[k]
				end
				plugin:UnregisterAllAuraSounds()
				plugin:CheckAllBossModulesForAuraSounds()
			end,
			order = 27,
		},
		resetAll = {
			type = "execute",
			name = L.resetAll,
			desc = L.resetAllCustomSound,
			func = function()
				plugin.db:ResetProfile()
				updateProfile()
				plugin:UnregisterAllAuraSounds()
				plugin:CheckAllBossModulesForAuraSounds()
			end,
			order = 28,
		},
	}
}

local soundOptions = {
	type = "group",
	name = L.Sounds,
	handler = plugin,
	inline = true,
	args = {
		customSoundDesc = {
			name = L.customSoundDesc,
			type = "description",
			order = 1,
			width = "full",
		},
	},
}
plugin.soundOptions = soundOptions

do
	local function addKey(t, key)
		if t.type and (t.type == "select" or t.type == "range") then
			t.arg = key
		elseif t.args then
			for k, v in next, t.args do
				t.args[k] = addKey(v, key)
			end
		end
		return t
	end

	local C = BigWigs.C
	local keyTable = {}
	function plugin:SetSoundOptions(name, key, flags)
		table.wipe(keyTable)
		keyTable[1] = name
		keyTable[2] = key
		local t = addKey(soundOptions, keyTable)
		if t.args.countdown then
			t.args.countdown.disabled = not flags or (bit.band(flags, C.COUNTDOWN) == 0 and bit.band(flags, C.CASTBAR_COUNTDOWN) == 0)
			t.args.countdownTime.disabled = not flags or (bit.band(flags, C.COUNTDOWN) == 0 and bit.band(flags, C.CASTBAR_COUNTDOWN) == 0)
		end
		return t
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	updateProfile()

	soundList = LibSharedMedia:List(SOUND)
	allowBlizzMessages = true

	for k in next, sounds do
		local n = L[k] or k
		soundOptions.args[k] = {
			name = n,
			get = function(info)
				local name, key = unpack(info.arg)
				local optionName = info[#info]
				for i, v in next, soundList do
					-- If no custom sound exists for this option, fall back to global sound option
					if v == (db[optionName][name] and db[optionName][name][key] or db.media[optionName]) then
						return i
					end
				end
			end,
			set = function(info, value)
				local name, key = unpack(info.arg)
				local optionName = info[#info]
				if not db[optionName][name] then db[optionName][name] = {} end
				db[optionName][name][key] = soundList[value]
				self:PlaySoundFile(LibSharedMedia:Fetch(SOUND, soundList[value]))
				-- We don't cleanup/reset the DB as someone may have a custom global sound but wish to use the default sound on a specific option
			end,
			hidden = function(info)
				local name, key = unpack(info.arg)
				local module = BigWigs:GetBossModule(name:sub(16), true)
				if not module or not module.soundOptions then -- no module entry? show all sounds
					return false
				end
				local optionSounds = module.soundOptions[key]
				if not optionSounds then
					return true
				end
				local optionName = info[#info]:lower()
				if type(optionSounds) == "table" then
					for _, sound in next, optionSounds do
						if sound:lower() == optionName then
							return false
						end
					end
				else
					return optionName ~= optionSounds:lower()
				end
				return true
			end,
			type = "select",
			values = soundList,
			order = 2,
			width = "full",
			itemControl = "DDI-Sound",
		}
	end

	local soundsPlayedTable = {}
	for optionKey, soundName in next, db.media do
		if sounds[optionKey] and soundName ~= "None" and not soundsPlayedTable[soundName] then
			soundsPlayedTable[soundName] = true
		end
	end
	for k, v in next, db do
		if sounds[k] then
			for _, soundTbl in next, v do
				for _, soundName in next, soundTbl do
					if soundName ~= "None" and not soundsPlayedTable[soundName] then
						soundsPlayedTable[soundName] = true
					end
				end
			end
		end
	end
	local timer
	local function Loop()
		local soundName = next(soundsPlayedTable)
		if not soundName then timer:Cancel() return end
		soundsPlayedTable[soundName] = nil
		local played, id = self:PlaySoundFile(LibSharedMedia:Fetch(SOUND, soundName))
		if played then StopSound(id) end
	end
	timer = BigWigsLoader.CTimerNewTicker(0, Loop)

	-- Register aura sounds
	if self:IsAuraSoundRestrictionsActive() then
		self:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
	else
		self:CheckAllBossModulesForAuraSounds()
	end

	self:RegisterMessage("BigWigs_Sound")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_RefreshAuraSounds")
	if BigWigsLoader.isRetail then
		self:RegisterEvent("ENCOUNTER_WARNING")
		self:RegisterMessage("BigWigs_BlockBlizzMessages")
		self:RegisterMessage("BigWigs_AllowBlizzMessages")
	end
end

function plugin:OnPluginDisable()
	self:UnregisterAllAuraSounds()
end

-------------------------------------------------------------------------------
-- Event Handlers
--

-- Functions for Aura Sounds
function plugin:BigWigs_BossModuleRegistered(_, bossModule, currentInstanceID)
	if bossModule:IsZoneID(currentInstanceID) and bossModule:HasAuraData() and not registeredAuraModules[bossModule] then
		self:RegisterAuraSounds(bossModule)
	end
end

function plugin:BigWigs_RefreshAuraSounds(_, bossModule)
	if registeredAuraModules[bossModule] then
		self:UnregisterAuraSounds(bossModule)
		self:RegisterAuraSounds(bossModule)
	end
end

do
	local IsAddOnRestrictionActive = C_RestrictedActions.IsAddOnRestrictionActive
	function plugin:IsAuraSoundRestrictionsActive()
		if IsAddOnRestrictionActive(1) or (IsAddOnRestrictionActive(0) and IsAddOnRestrictionActive(2)) then
			return true -- Encounter, or Combat+ChallengeMode
		end
	end
end

do
	local GetInstanceInfo = BigWigsLoader.GetInstanceInfo
	function plugin:CheckAllBossModulesForAuraSounds()
		local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
		for _, bossModule in BigWigs:IterateBossModules() do
			if bossModule:IsZoneID(instanceID) and bossModule:HasAuraData() and not registeredAuraModules[bossModule] then
				self:RegisterAuraSounds(bossModule)
			end
		end
	end
end

function plugin:ADDON_RESTRICTION_STATE_CHANGED(event)
	if self:IsAuraSoundRestrictionsActive() then
		return
	end
	self:UnregisterEvent(event)
	self:CheckAllBossModulesForAuraSounds()
end

do
	local auraEventToID = {
		-- These are the enum values for UnitAuraSoundTrigger
		onApplied = 0,
		onStack = 1,
		onRemoved = 2,
	}
	local AddAuraSound = C_UnitAuras.AddAuraSound
	function plugin:RegisterAuraSounds(bossModule)
		if bossModule:HasAuraData() and not registeredAuraModules[bossModule] then
			if self:IsAuraSoundRestrictionsActive() then
				self:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
				return
			end

			local soundsRegistedForThisModule = {}
			registeredAuraModules[bossModule] = soundsRegistedForThisModule
			local spellIDList = bossModule:GetAuraSpellIDToIndexList()
			for spellId in next, spellIDList do
				local soundsToRegister = {}
				local onAppliedSound = bossModule:GetAuraAppliedSound(spellId)
				if not onAppliedSound then
					onAppliedSound = bossModule:GetAuraAppliedSoundDefault(spellId)
					local hasGlobalSound = validGlobalSounds[onAppliedSound]
					if hasGlobalSound then
						onAppliedSound = db.media[hasGlobalSound]
					end
				end
				local onStackSound = bossModule:GetAuraAppliedDoseSound(spellId)
				if not onStackSound then
					onStackSound = bossModule:GetAuraAppliedDoseSoundDefault(spellId)
					if onStackSound then
						local hasGlobalSound = validGlobalSounds[onStackSound]
						if hasGlobalSound then
							onStackSound = db.media[hasGlobalSound]
						end
					end
				end
				local onRemovedSound = bossModule:GetAuraRemovedSound(spellId)
				if not onRemovedSound then
					onRemovedSound = bossModule:GetAuraRemovedSoundDefault(spellId)
					local hasGlobalSound = validGlobalSounds[onAppliedSound]
					if hasGlobalSound then
						onAppliedSound = db.media[hasGlobalSound]
					end
				end
				if onAppliedSound and onAppliedSound ~= "None" then
					soundsToRegister.onApplied = self:GetSoundFile(nil, nil, onAppliedSound)
				end
				if onStackSound and onStackSound ~= "None" then
					soundsToRegister.onStack = self:GetSoundFile(nil, nil, onStackSound)
				end
				if onRemovedSound and onRemovedSound ~= "None" then
					soundsToRegister.onRemoved = self:GetSoundFile(nil, nil, onRemovedSound)
				end

				for event, sound in next, soundsToRegister do
					local auraSoundInfoTable = {
						spellID = spellId,
						unitToken = "player",
						outputChannel = "master",
					}
					if type(sound) == "string" then
						auraSoundInfoTable.soundFileName = sound
					else
						auraSoundInfoTable.soundFileID = sound
					end
					local auraSoundID = AddAuraSound(auraEventToID[event], auraSoundInfoTable)
					if auraSoundID ~= nil then
						soundsRegistedForThisModule[#soundsRegistedForThisModule + 1] = auraSoundID
					end
				end
			end
		end
	end
end

do
	local RemoveAuraSound = C_UnitAuras.RemoveAuraSound
	function plugin:UnregisterAuraSounds(bossModule)
		if registeredAuraModules[bossModule] then
			for i = 1, #registeredAuraModules[bossModule] do
				local auraSoundID = registeredAuraModules[bossModule][i]
				RemoveAuraSound(auraSoundID)
			end
			registeredAuraModules[bossModule] = nil
		end
	end
end

function plugin:UnregisterAllAuraSounds()
	for bossModule in next, registeredAuraModules do
		self:UnregisterAuraSounds(bossModule)
	end
end

-- Functions for regular sounds
do
	local tmp = { -- XXX temp
		["long"] = "Long",
		["info"] = "Info",
		["alert"] = "Alert",
		["alarm"] = "Alarm",
		["warning"] = "Warning",
	}
	function plugin:GetSoundFile(module, key, soundName)
		soundName = tmp[soundName] or soundName
		local sDb = db[soundName]
		if not module or not key or not sDb or not sDb[module.name] or not sDb[module.name][key] then
			local path = db.media[soundName] and LibSharedMedia:Fetch(SOUND, db.media[soundName], true) or LibSharedMedia:Fetch(SOUND, soundName, true)
			return path
		else
			local newSound = sDb[module.name][key]
			local path = db.media[newSound] and LibSharedMedia:Fetch(SOUND, db.media[newSound], true) or LibSharedMedia:Fetch(SOUND, newSound, true)
			return path
		end
	end

	function plugin:GetDefaultSound(soundName)
		if not soundName then return end
		if soundName == "none" then
			return "None"
		end
		soundName = tmp[soundName] or soundName

		local custom = soundName:match("^name:(.+)$")
		if custom and not LibSharedMedia:Fetch(SOUND, custom, true) then
			return
		end
		return custom or db.media[soundName]
	end

	function plugin:GetDefaultSoundFile(soundName)
		local defaultSound = self:GetDefaultSound(soundName)
		return defaultSound and LibSharedMedia:Fetch(SOUND, defaultSound, true)
	end
end

function plugin:BigWigs_Sound(_, module, key, soundName)
	local soundPath = self:GetSoundFile(module, key, soundName)
	if soundPath then
		self:PlaySoundFile(soundPath)
	end
end

do
	local severitySoundMap = {
		[0] = "alert",
		[1] = "alarm",
		[2] = "warning",
	}
	function plugin:ENCOUNTER_WARNING(_, eventInfo)
		if allowBlizzMessages then
			local shouldPlaySound = eventInfo.shouldPlaySound
			local severity = eventInfo.severity
			if shouldPlaySound then
				self:BigWigs_Sound(nil, nil, false, severitySoundMap[severity] or "alert")
			end
		end
	end
end

function plugin:BigWigs_AllowBlizzMessages()
	allowBlizzMessages = true
end

function plugin:BigWigs_BlockBlizzMessages()
	allowBlizzMessages = false
end
