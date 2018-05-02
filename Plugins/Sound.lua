-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Sounds")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
local SOUND = media.MediaType and media.MediaType.SOUND or "sound"
local soundList = nil
local db
local sounds = {
	Long = "BigWigs: Long",
	Info = "BigWigs: Info",
	Alert = "BigWigs: Alert",
	Alarm = "BigWigs: Alarm",
	Warning = "BigWigs: Raid Warning",
}

--------------------------------------------------------------------------------
-- Sound Registration
--

media:Register(SOUND, "BigWigs: Long", "Interface\\AddOns\\BigWigs\\Sounds\\Long.ogg")
media:Register(SOUND, "BigWigs: Info", "Interface\\AddOns\\BigWigs\\Sounds\\Info.ogg")
media:Register(SOUND, "BigWigs: Alert", "Interface\\AddOns\\BigWigs\\Sounds\\Alert.ogg")
media:Register(SOUND, "BigWigs: Alarm", "Interface\\AddOns\\BigWigs\\Sounds\\Alarm.ogg")

-- Ingame sounds that DBM uses for DBM converts
media:Register(SOUND, "BigWigs: [DBM] ".. L.FlagTaken, "Sound\\Spells\\PVPFlagTaken.ogg")
media:Register(SOUND, "BigWigs: [DBM] ".. L.Beware, "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.ogg")
media:Register(SOUND, "BigWigs: [DBM] ".. L.Destruction, "Sound\\Creature\\KilJaeden\\KILJAEDEN02.ogg")
media:Register(SOUND, "BigWigs: [DBM] ".. L.RunAway, "Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.ogg")

-- Ingame sounds used by Blizzard
media:Register(SOUND, "BigWigs: Raid Warning", "Sound\\Interface\\RaidWarning.ogg")
media:Register(SOUND, "BigWigs: Raid Boss Whisper", "Sound\\Interface\\UI_RaidBossWhisperWarning.ogg")

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	sound = true,
	media = {
		Long = "BigWigs: Long",
		Info = "BigWigs: Info",
		Alert = "BigWigs: Alert",
		Alarm = "BigWigs: Alarm",
		Warning = "BigWigs: Raid Warning",
	},
}

plugin.pluginOptions = {
	type = "group",
	name = L.Sounds,
	get = function(info)
		for i, v in next, soundList do
			if v == db.media[info[#info]] then
				return i
			end
		end
	end,
	set = function(info, value)
		local sound = info[#info]
		PlaySoundFile(media:Fetch(SOUND, soundList[value]), "Master")
		db.media[sound] = soundList[value]
	end,
	args = {
		sound = {
			type = "toggle",
			name = L.sound,
			desc = L.soundDesc,
			get = function() return db.sound end,
			set = function(_, v) db.sound = v end,
			order = 1,
			width = "full",
			descStyle = "inline",
		},
		resetAll = {
			type = "execute",
			name = L.resetAll,
			desc = L.resetAllCustomSound,
			func = function() plugin.db:ResetProfile() end,
			order = 3,
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
		if t.type and t.type == "select" then
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
		wipe(keyTable)
		keyTable[1] = name
		keyTable[2] = key
		local t = addKey(soundOptions, keyTable)
		if t.args.countdown then
			t.args.countdown.disabled = not flags or bit.band(flags, C.COUNTDOWN) == 0
		end
		return t
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

local function updateProfile()
	db = plugin.db.profile
end

function plugin:OnRegister()
	updateProfile()

	soundList = media:List(SOUND)

	for k in next, sounds do
		local n = L[k] or k
		self.pluginOptions.args[k] = {
			type = "select",
			name = n,
			order = 2,
			disabled = function() return not db.sound end,
			values = soundList,
			width = "full",
			itemControl = "DDI-Sound",
		}
		soundOptions.args[k] = {
			name = n,
			get = function(info)
				local name, key = unpack(info.arg)
				local optionName = info[#info]
				for i, v in next, soundList do
					-- If no custom sound exists for this option, fall back to global sound option
					if v == (db[optionName] and db[optionName][name] and db[optionName][name][key] or db.media[optionName]) then
						return i
					end
				end
			end,
			set = function(info, value)
				local name, key = unpack(info.arg)
				local optionName = info[#info]
				if not db[optionName] then db[optionName] = {} end
				if not db[optionName][name] then db[optionName][name] = {} end
				db[optionName][name][key] = soundList[value]
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
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_Sound")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local PlaySoundFile = PlaySoundFile
	function plugin:BigWigs_Sound(event, module, key, soundName)
		if db.sound then
			local sDb = db[soundName]
			if not module or not key or not sDb or not sDb[module.name] or not sDb[module.name][key] then
				local path = db.media[soundName] and media:Fetch(SOUND, db.media[soundName], true) or media:Fetch(SOUND, soundName, true)
				if path then
					PlaySoundFile(path, "Master")
				end
			else
				local newSound = sDb[module.name][key]
				local path = db.media[newSound] and media:Fetch(SOUND, db.media[newSound], true) or media:Fetch(SOUND, newSound, true)
				if path then
					PlaySoundFile(path, "Master")
				end
			end
		end
	end
end
