
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
	["Use sounds"] = true,
	["Options for sounds."] = true,
	["Toggle sounds on or off."] = true,
} end)


L:RegisterTranslations("koKR", function() return {
	["Sounds"] = "효과음",
	["sounds"] = "효과음",
	["Use sounds"] = "효과음 사용",
	["Options for sounds."] = "효과음 옵션.",
	["Toggle sounds on or off."] = "효과음을 켜거나 끔.",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSound = BigWigs:NewModule(L"Sounds")
BigWigsSound.consoleCmd = L"sounds"
BigWigsSound.consoleOptions = {
	type = "toggle",
	name = L"Sounds",
	desc = L"Toggle sounds on or off.",
	get = function() return BigWigsSound.db.profile.sound end,
	set = function(v)
		BigWigsSound.db.profile.sound = v
		BigWigs:ToggleModuleActive(L"Sounds", v)
	end,
}


------------------------------
--      Initialization      --
------------------------------

function BigWigsSound:OnEnable()
	self:RegisterEvent("BigWigs_Message")
end


function BigWigsSound:BigWigs_Message(text, color, noraidsay, sound)
	if not text or sound == false then return end

	if sounds[sound] then PlaySoundFile(sounds[sound])
	else PlaySound("RaidWarning") end
end

