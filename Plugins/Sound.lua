assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsSound")
local media = AceLibrary("SharedMedia-1.0")
local mType = media.MediaType and media.MediaType.SOUND or "sound"
local db = nil

local sounds = {
	["Long"] = "BigWigs: Long",
	["Info"] = "BigWigs: Info",
	["Alert"] = "BigWigs: Alert",
	["Alarm"] = "BigWigs: Alarm",
	["Victory"] = "BigWigs: Victory",
}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Sounds"] = true,
	["Options for sounds."] = true,

	["Set the sound to use for %q (Ctrl-Click a sound to preview.)"] = true,
	["toggle"] = true,
	["Use sounds"] = true,
	["Toggle all sounds on or off."] = true,
	["default"] = true,
	["Default only"] = true,
	["Use only the default sound."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Sounds"] = "효과음",
	["Options for sounds."] = "효과음 옵션.",

	["Use sounds"] = "효과음 사용",
	["Toggle all sounds on or off."] = "효과음을 켜거나 끔.",
	["Default only"] = "기본음",
	["Use only the default sound."] = "기본음만 사용.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Sounds"] = "声音",
	["Options for sounds."] = "声音的选项",

	["toggle"] = "选择",
	["Use sounds"] = "使用声音",
	["Toggle all sounds on or off."] = "切换是否使用声音。",
	["default"] = "默认",
	["Default only"] = "只用默认",
	["Use only the default sound."] = "只用默认声音",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Sounds"] = "聲音",
	["Options for sounds."] = "聲音的選項",

	["toggle"] = "選擇",
	["Use sounds"] = "使用聲音",
	["Toggle all sounds on or off."] = "切換是否使用聲音。",
	["default"] = "預設",
	["Default only"] = "只用預設",
	["Use only the default sound."] = "只用預設聲音",
} end)

L:RegisterTranslations("deDE", function() return {
	["Sounds"] = "Sound",
	["Options for sounds."] = "Optionen f\195\188r Sound.",

	--["toggle"] = true,
	["Use sounds"] = "Sound nutzen",
	["Toggle all sounds on or off."] = "Sound aktivieren/deaktivieren.",
	--["default"] = "true",
	["Default only"] = "Nur Standard",
	["Use only the default sound."] = "Nur Standard Sound.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Sounds"] = "Sons",
	["Options for sounds."] = "Options concernant les sons.",

	--["toggle"] = true,
	["Use sounds"] = "Utiliser les sons",
	["Toggle all sounds on or off."] = "Joue ou non les sons.",
	--["default"] = true,
	["Default only"] = "Son par d\195\169faut uniquement",
	["Use only the default sound."] = "Utilise uniquement le son par d\195\169faut.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Sounds")

plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.defaultDB = {
	defaultonly = false,
	sound = true,
	media = {
		["Long"] = "BigWigs: Long",
		["Info"] = "BigWigs: Info",
		["Alert"] = "BigWigs: Alert",
		["Alarm"] = "BigWigs: Alarm",
		["Victory"] = "BigWigs: Victory",
	},
}
plugin.consoleCmd = L["Sounds"]
plugin.consoleOptions = {
	type = "group",
	name = L["Sounds"],
	desc = L["Options for sounds."],
	args = {
		["spacer1"] = {
			type = "header",
			name = " ",
			order = 200,
		},
		[L["default"]] = {
			type = "toggle",
			name = L["Default only"],
			desc = L["Use only the default sound."],
			get = function() return plugin.db.profile.defaultonly end,
			set = function(v) plugin.db.profile.defaultonly = v end,
			order = 201,
			disabled = function() return not BigWigs:IsModuleActive(plugin) end,
		},
		[L["toggle"]] = {
			type = "toggle",
			name = L["Sounds"],
			desc = L["Toggle all sounds on or off."],
			get = function() return plugin.db.profile.sound end,
			set = function(v)
				plugin.db.profile.sound = v
				BigWigs:ToggleModuleActive(plugin, v)
			end,
			order = 202,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

local function ShouldDisable()
	return not BigWigs:IsModuleActive(plugin) or plugin.db.profile.defaultonly
end

function plugin:OnRegister()
	db = self.db.profile

	media:Register(mType, "BigWigs: Long", "Interface\\AddOns\\BigWigs\\Sounds\\Long.mp3")
	media:Register(mType, "BigWigs: Info", "Interface\\AddOns\\BigWigs\\Sounds\\Info.mp3")
	media:Register(mType, "BigWigs: Alert", "Interface\\AddOns\\BigWigs\\Sounds\\Alert.mp3")
	media:Register(mType, "BigWigs: Alarm", "Interface\\AddOns\\BigWigs\\Sounds\\Alarm.mp3")
	media:Register(mType, "BigWigs: Victory", "Interface\\AddOns\\BigWigs\\Sounds\\Victory.mp3")

	local function get(sound)
		return db.media[sound]
	end

	local function set(sound, value)
		if IsControlKeyDown() then
			PlaySoundFile(media:Fetch(mType, value))
		else
			db.media[sound] = value
		end
	end

	for k in pairs(sounds) do
		self.consoleOptions.args[k] = {
			type = "text",
			name = k,
			desc = L["Set the sound to use for %q (Ctrl-Click a sound to preview.)"]:format(k),
			passValue = k,
			get = get,
			set = set,
			disabled = ShouldDisable,
			validate = media:List(mType),
		}
	end
end

function plugin:OnEnable()
	if not db.sound then
		BigWigs:ToggleModuleActive(self, false)
		return
	end

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_Sound")
end

local function play(sound)
	if not db.defaultonly then
		local s = db.media[sound] and media:Fetch(mType, db.media[sound]) or media:Fetch(mType, sound)
		if type(s) == "string" then
			PlaySoundFile(s)
			return
		end
	end
	PlaySound("RaidWarning")
end

function plugin:BigWigs_Message(text, color, noraidsay, sound, broadcastonly)
	if not text or type(sound) ~= "string" or broadcastonly or not db.sound then return end
	play(sound)
end

function plugin:BigWigs_Sound( sound )
	if not db.sound or type(sound) ~= "string" then return end
	play(sound)
end

