-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Sounds")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")
local mType = media.MediaType and media.MediaType.SOUND or "sound"
local soundList = nil

local sounds = {
	Long = "BigWigs: Long",
	Info = "BigWigs: Info",
	Alert = "BigWigs: Alert",
	Alarm = "BigWigs: Alarm",
	Victory = "BigWigs: Victory",
}
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = "|cff" .. ("%02x%02x%02x"):format(r * 255, g * 255, b * 255) .. key .. "|r"
			return self[key]
		end
	})
end

--------------------------------------------------------------------------------
-- Options
--

local function resetAll()
	plugin.db:ResetProfile()
	for k in pairs(sounds) do
		if k ~= "Victory" then
			if not plugin.db.profile[k] then plugin.db.profile[k] = {} end
		end
	end
end

plugin.defaultDB = {
	defaultonly = false,
	media = {
		Long = "BigWigs: Long",
		Info = "BigWigs: Info",
		Alert = "BigWigs: Alert",
		Alarm = "BigWigs: Alarm",
		Victory = "BigWigs: Victory",
	},
}

plugin.pluginOptions = {
	type = "group",
	name = L["Sounds"],
	get = function(info)
		for i, v in next, soundList do
			if v == plugin.db.profile.media[info[#info]] then
				return i
			end
		end
	end,
	set = function(info, value)
		local sound = info[#info]
		PlaySoundFile(media:Fetch(mType, soundList[value]), "Master")
		plugin.db.profile.media[sound] = soundList[value]
	end,
	args = {
		default = {
			type = "toggle",
			name = colorize[L["Default only"]],
			desc = L.soundDefaultDescription,
			get = function(info) return plugin.db.profile.defaultonly end,
			set = function(info, v) plugin.db.profile.defaultonly = v end,
			order = 1,
			width = "full",
			descStyle = "inline",
		},
		resetAll = {
			type = "execute",
			name = L["Reset all"],
			desc = L.resetAllCustomSound,
			func = resetAll,
			order = 3,
		},
	}
}

local soundOptions = {
	type = "group",
	name = L["Sounds"],
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

local function addKey(t, key)
	if t.type and t.type == "select" then
		t.arg = key
	elseif t.args then
		for k, v in pairs(t.args) do
			t.args[k] = addKey(v, key)
		end
	end
	return t
end

local keyTable = {}
function plugin:SetSoundOptions(name, key, flags)
	wipe(keyTable)
	keyTable[1] = name
	keyTable[2] = key
	if type(key) == "number" then key = GetSpellInfo(key) end
	local t = addKey(soundOptions, keyTable)
	return t
end

-------------------------------------------------------------------------------
-- Initialization
--

local function shouldDisable() return plugin.db.profile.defaultonly end

function plugin:OnRegister()
	media:Register(mType, "BigWigs: Long", "Interface\\AddOns\\BigWigs\\Sounds\\Long.mp3")
	media:Register(mType, "BigWigs: Info", "Interface\\AddOns\\BigWigs\\Sounds\\Info.mp3")
	media:Register(mType, "BigWigs: Alert", "Interface\\AddOns\\BigWigs\\Sounds\\Alert.mp3")
	media:Register(mType, "BigWigs: Alarm", "Interface\\AddOns\\BigWigs\\Sounds\\Alarm.mp3")
	media:Register(mType, "BigWigs: Victory", "Interface\\AddOns\\BigWigs\\Sounds\\Victory.mp3")
	media:Register(mType, "BigWigs: Victory Long", "Interface\\AddOns\\BigWigs\\Sounds\\VictoryLong.mp3")
	media:Register(mType, "BigWigs: Victory Classic", "Interface\\AddOns\\BigWigs\\Sounds\\VictoryClassic.mp3")
	media:Register(mType, "BigWigs: 5", "Interface\\AddOns\\BigWigs\\Sounds\\5.mp3")
	media:Register(mType, "BigWigs: 4", "Interface\\AddOns\\BigWigs\\Sounds\\4.mp3")
	media:Register(mType, "BigWigs: 3", "Interface\\AddOns\\BigWigs\\Sounds\\3.mp3")
	media:Register(mType, "BigWigs: 2", "Interface\\AddOns\\BigWigs\\Sounds\\2.mp3")
	media:Register(mType, "BigWigs: 1", "Interface\\AddOns\\BigWigs\\Sounds\\1.mp3")

	soundList = media:List(mType)

	for k, s in pairs(sounds) do
		local n = L[k] or k
		self.pluginOptions.args[k] = {
			type = "select",
			name = n,
			order = 2,
			disabled = shouldDisable,
			values = soundList,
			width = "full",
			itemControl = "DDI-Sound",
		}
		if k ~= "Victory" then
			soundOptions.args[k] = {
				name = n,
				get = function(info)
					local name, key = unpack(info.arg)
					if not plugin.db.profile[info[#info]][name] then
						for i, v in next, soundList do
							if v == s then
								return i
							end
						end
					elseif not plugin.db.profile[info[#info]][name][key] then
						for i, v in next, soundList do
							if v == s then
								return i
							end
						end
					else
						for i, v in next, soundList do
							if v == plugin.db.profile[info[#info]][name][key] then
								return i
							end
						end
					end
				end,
				set = function(info, value)
					local name, key = unpack(info.arg)
					if not plugin.db.profile[info[#info]][name] then plugin.db.profile[info[#info]][name] = {} end
					plugin.db.profile[info[#info]][name][key] = soundList[value]
				end,
				type = "select",
				values = soundList,
				order = 2,
				width = "full",
				itemControl = "DDI-Sound",
			}
		end
	end
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_Message")
	self:RegisterMessage("BigWigs_Sound")
	for k in pairs(sounds) do
		if k ~= "Victory" then
			if not plugin.db.profile[k] then plugin.db.profile[k] = {} end
		end
	end
end

local function play(sound)
	if plugin.db.profile.defaultonly then
		PlaySound("RaidWarning", "Master")
	elseif type(sound) == "string" then
		local s = plugin.db.profile.media[sound] and media:Fetch(mType, plugin.db.profile.media[sound]) or media:Fetch(mType, sound)
		if type(s) == "string" then
			PlaySoundFile(s, "Master")
		end
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

local function customSound(module, key, sound)
	if not module or not key or sound == "Victory" then return false end
	if not plugin.db.profile[sound] then error(("Invalid sound: %s (module: %s, key: %s)"):format(sound, module.name, key)) return end
	if not plugin.db.profile[sound][module.name] then
		return false
	else
		if plugin.db.profile[sound][module.name][key] == "None" then
			return false
		else
			return plugin.db.profile[sound][module.name][key]
		end
	end
end

function plugin:BigWigs_Message(event, module, key, text, color, sound)
	if not text or not sound or not BigWigs.db.profile.sound then return end
	play(customSound(module, key, sound) or sound)
end

function plugin:BigWigs_Sound(event, sound)
	if not BigWigs.db.profile.sound or not sound then return end
	play(sound)
end

