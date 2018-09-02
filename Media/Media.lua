
local L = BigWigsAPI:GetLocale("BigWigs")
local media = LibStub("LibSharedMedia-3.0")

-- Bar Textures
do
	local STATUSBAR = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
	media:Register(STATUSBAR, "Otravi", "Interface\\AddOns\\BigWigs\\Media\\Textures\\otravi")
	media:Register(STATUSBAR, "Smooth", "Interface\\AddOns\\BigWigs\\Media\\Textures\\smooth")
	media:Register(STATUSBAR, "Glaze", "Interface\\AddOns\\BigWigs\\Media\\Textures\\glaze")
	media:Register(STATUSBAR, "Charcoal", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Charcoal")
	media:Register(STATUSBAR, "BantoBar", "Interface\\AddOns\\BigWigs\\Media\\Textures\\default")
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
	media:Register(SOUND, "BigWigs: [DBM] ".. L.FlagTaken, "Sound\\Spells\\PVPFlagTaken.ogg")
	media:Register(SOUND, "BigWigs: [DBM] ".. L.Beware, "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.ogg")
	media:Register(SOUND, "BigWigs: [DBM] ".. L.Destruction, "Sound\\Creature\\KilJaeden\\KILJAEDEN02.ogg")
	media:Register(SOUND, "BigWigs: [DBM] ".. L.RunAway, "Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.ogg")

	-- Ingame sounds used by Blizzard
	media:Register(SOUND, "BigWigs: Raid Warning", "Sound\\Interface\\RaidWarning.ogg")
	media:Register(SOUND, "BigWigs: Raid Boss Whisper", "Sound\\Interface\\UI_RaidBossWhisperWarning.ogg")

	-- Victory
	media:Register(SOUND, "BigWigs: Victory", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Victory.ogg")
	media:Register(SOUND, "BigWigs: Victory Long", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\VictoryLong.ogg")
	media:Register(SOUND, "BigWigs: Victory Classic", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\VictoryClassic.ogg")
end

-- Fonts
do
	local FONT = media.MediaType and media.MediaType.FONT or "font"
	media:Register(FONT, "Noto Sans Regular", "Interface\\AddOns\\BigWigs\\Media\\Fonts\\Noto.ttf")
end
