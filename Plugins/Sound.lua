
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsSound")
--~~ local dewdrop = DewdropLib:GetInstance("1.0")

local sounds = {
	Long = "Interface\\AddOns\\BigWigs\\Sounds\\Long.mp3",
	Info = "Interface\\AddOns\\BigWigs\\Sounds\\Info.mp3",
	Alert = "Interface\\AddOns\\BigWigs\\Sounds\\Alert.mp3",
	Alarm = "Interface\\AddOns\\BigWigs\\Sounds\\Alarm.mp3",
	Victory = "Interface\\AddOns\\BigWigs\\Sounds\\Victory.mp3",
}


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Sounds"] = true,
	["sounds"] = true,
	["Options for sounds."] = true,

	["toggle"] = true,
	["Use sounds"] = true,
	["Toggle sounds on or off."] = true,
	["default"] = true,
	["Default only"] = true,
	["Use only the default sound."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Sounds"] = "효과음",
	["Options for sounds."] = "효과음 옵션.",

	["Use sounds"] = "효과음 사용",
	["Toggle sounds on or off."] = "효과음을 켜거나 끔.",
	["Default only"] = "기본음",
	["Use only the default sound."] = "기본음만 사용.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Sounds"] = "声音",
	["Use sounds"] = "使用声音",
	["Options for sounds."] = "声音设置。",
	["Toggle sounds on or off."] = "切换是否使用声音。",
} end)

L:RegisterTranslations("deDE", function() return {
	["Sounds"] = "Sound",
	-- ["sounds"] = true,
	["Use sounds"] = "Benutze Sounds",
	["Options for sounds."] = "Optionen f\195\188r Sound.",
	["Toggle sounds on or off."] = "Aktiviere oder deaktiviere Sound.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSound = BigWigs:NewModule(L["Sounds"])
BigWigsSound.defaults = {
	defaultonly = false,
	sound = true,
}
BigWigsSound.consoleCmd = L["sounds"]
BigWigsSound.consoleOptions = {
	type = "group",
	name = L["Sounds"],
	desc = L["Options for sounds."],
	args = {
		[L["toggle"]] = {
			type = "toggle",
			name = L["Sounds"],
			desc = L["Toggle sounds on or off."],
			get = function() return BigWigsSound.db.profile.sound end,
			set = function(v)
				BigWigsSound.db.profile.sound = v
				BigWigs:ToggleModuleActive(L["Sounds"], v)
			end,
		},
		[L["default"]] = {
			type = "toggle",
			name = L["Default only"],
			desc = L["Use only the default sound."],
			get = function() return BigWigsSound.db.profile.defaultonly end,
			set = function(v) BigWigsSound.db.profile.defaultonly = v end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsSound:OnEnable()
	self:RegisterEvent("BigWigs_Message")
end

function BigWigsSound:BigWigs_Message(text, color, noraidsay, sound, broadcastonly)
	if not text or sound == false or broadcastonly then return end

	if sounds[sound] and not self.db.profile.defaultonly then PlaySoundFile(sounds[sound])
	else PlaySound("RaidWarning") end
end

