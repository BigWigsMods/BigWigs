
if GetBuildInfo() ~= "1.13.2" then
	print("|cFF33FF99BigWigs|r: You're trying to run the Classic version of BigWigs on a live server.")
	return
end

local L = BigWigsAPI:GetLocale("BigWigs")
local media = LibStub("LibSharedMedia-3.0")

-- Bar Textures
do
	local STATUSBAR = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
	media:Register(STATUSBAR, "Otravi", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Otravi")
	media:Register(STATUSBAR, "Smooth", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Smooth")
	media:Register(STATUSBAR, "Smooth v2", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Smoothv2")
	media:Register(STATUSBAR, "Glaze", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Glaze")
	media:Register(STATUSBAR, "Charcoal", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Charcoal")
	media:Register(STATUSBAR, "BantoBar", "Interface\\AddOns\\BigWigs\\Media\\Textures\\BantoBar")
end

-- Sounds
do
	-- Ours
	local SOUND = media.MediaType and media.MediaType.SOUND or "sound"
	media:Register(SOUND, "BigWigs: Long", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Long.ogg")
	media:Register(SOUND, "BigWigs: Info", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Info.ogg")
	media:Register(SOUND, "BigWigs: Alert", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Alert.ogg")
	media:Register(SOUND, "BigWigs: Alarm", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Alarm.ogg")

	-- Ingame sounds that DBM uses for DBM converts
	--media:Register(SOUND, "BigWigs: [DBM] ".. L.FlagTaken, C_RaidLocks and 569200 or "Sound\\Spells\\PVPFlagTaken.ogg")
	--media:Register(SOUND, "BigWigs: [DBM] ".. L.Beware, C_RaidLocks and 543587 or "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.ogg")
	--media:Register(SOUND, "BigWigs: [DBM] ".. L.Destruction, C_RaidLocks and 553193 or "Sound\\Creature\\KilJaeden\\KILJAEDEN02.ogg")
	--media:Register(SOUND, "BigWigs: [DBM] ".. L.RunAway, C_RaidLocks and 552035 or "Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.ogg")

	-- Ingame sounds used by Blizzard
	media:Register(SOUND, "BigWigs: Raid Warning", C_RaidLocks and 567397 or "Sound\\Interface\\RaidWarning.ogg")
	--media:Register(SOUND, "BigWigs: Raid Boss Whisper", C_RaidLocks and 876098 or "Sound\\Interface\\UI_RaidBossWhisperWarning.ogg")

	-- Victory
	media:Register(SOUND, "BigWigs: Victory", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Victory.ogg")
	media:Register(SOUND, "BigWigs: Victory Long", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\VictoryLong.ogg")
	media:Register(SOUND, "BigWigs: Victory Classic", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\VictoryClassic.ogg")
end

-- Fonts
do
	local FONT = media.MediaType and media.MediaType.FONT or "font"
	media:Register(FONT, "Noto Sans Regular", "Interface\\AddOns\\BigWigs\\Media\\Fonts\\Noto.ttf", 130) -- 130 latin + cyr
	media:Register(FONT, "Noto Sans SemiCondensed", "Interface\\AddOns\\BigWigs\\Media\\Fonts\\NotoSans-SemiCondensed.ttf", 130) -- 130 latin + cyr
end
