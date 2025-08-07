local _, addonTbl = ...
local L = addonTbl.API:GetLocale("BigWigs")
local media = LibStub("LibSharedMedia-3.0")

-- Bar Textures
do
	local STATUSBAR = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
	media:Register(STATUSBAR, "Otravi", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Otravi")
	media:Register(STATUSBAR, "Smooth", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Smooth")
	media:Register(STATUSBAR, "Smooth v2", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Smoothv2")
	media:Register(STATUSBAR, "Smoother", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Smoother")
	media:Register(STATUSBAR, "Glaze", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Glaze")
	media:Register(STATUSBAR, "Charcoal", "Interface\\AddOns\\BigWigs\\Media\\Textures\\Charcoal")
	media:Register(STATUSBAR, "BantoBar", "Interface\\AddOns\\BigWigs\\Media\\Textures\\BantoBar")
end

-- Sounds
do
	-- Ours
	local SOUND = media.MediaType and media.MediaType.SOUND or "sound"
	--media:Register(SOUND, L.spell_on_you, "Interface\\AddOns\\BigWigs\\Media\\Sounds\\spell_on_you.ogg")
	media:Register(SOUND, L.spell_under_you, "Interface\\AddOns\\BigWigs\\Media\\Sounds\\spell_under_you.ogg")
	media:Register(SOUND, "BigWigs: Long", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Long.ogg")
	media:Register(SOUND, "BigWigs: Info", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Info.ogg")
	media:Register(SOUND, "BigWigs: Alert", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Alert.ogg")
	media:Register(SOUND, "BigWigs: Alarm", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Alarm.ogg")

	-- Ingame sounds
	media:Register(SOUND, "BigWigs: ".. L.FlagTaken, 569200) -- Sound\\Spells\\PVPFlagTaken
	media:Register(SOUND, "BigWigs: ".. L.Beware, 543587) -- Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01
	media:Register(SOUND, "BigWigs: ".. L.Destruction, 553193) -- Sound\\Creature\\KilJaeden\\KILJAEDEN02
	media:Register(SOUND, "BigWigs: ".. L.RunAway, 552035) -- Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01

	-- Ingame sounds used for raid warning messages
	media:Register(SOUND, "BigWigs: Raid Warning", 567397) -- Sound\\Interface\\RaidWarning
	--media:Register(SOUND, "BigWigs: Raid Boss Whisper", 876098) -- Sound\\Interface\\UI_RaidBossWhisperWarning

	-- Victory
	media:Register(SOUND, "BigWigs: Victory", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Victory.ogg")
	media:Register(SOUND, "BigWigs: Victory Long", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\VictoryLong.ogg")
	media:Register(SOUND, "BigWigs: Victory Classic", "Interface\\AddOns\\BigWigs\\Media\\Sounds\\VictoryClassic.ogg")
end

-- Fonts
do
	local FONT = media.MediaType and media.MediaType.FONT or "font"
	media:Register(FONT, "Noto Sans Regular", "Interface\\AddOns\\BigWigs\\Media\\Fonts\\NotoSans-Regular.otf", 130) -- 130 latin + cyr
	media:Register(FONT, "Noto Sans SemiCondensed", "Interface\\AddOns\\BigWigs\\Media\\Fonts\\NotoSans-SemiCondensed.otf", 130) -- 130 latin + cyr
end

-- Countdowns
addonTbl.API:RegisterCountdown("none", L.none, { false, false, false, false, false })
addonTbl.API:RegisterCountdown("simple", L.simple_no_voice, {
	567474, 567474, 567474, 567474, 567474, 567474, 567474, 567474, 567474, 567474 -- sound/interface/ui_battlegroundcountdown_timer.ogg
})
addonTbl.API:RegisterCountdown("English: Amy", "English: Amy", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\10.ogg",
})
addonTbl.API:RegisterCountdown("English: David", "English: David", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\10.ogg",
})
addonTbl.API:RegisterCountdown("English: Jim", "English: Jim", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\10.ogg",
})

local voiceMap = {
	enUS = {"English: Default (%s)", "Male", "Female"},
	deDE = {"Deutsch: Standard (%s)", "Männlich", "Weiblich"},
	esES = {"Español (es): Predeterminado (%s)", "Masculino", "Femenino"},
	esMX = {"Español (mx): Predeterminado (%s)", "Masculino", "Femenino"},
	frFR = {"Français : Défaut (%s)", "Homme", "Femme"},
	itIT = {"Italiano: Predefinito (%s)", "Maschio", "Femmina"},
	koKR = {"한국어 : 기본 (%s)", "남성", "여성"},
	ptBR = {"Português: Padrão (%s)", "Masculino", "Feminino"},
	ruRU = {"Русский: По умолчанию (%s)", "Мужской", "Женский"},
	zhCN = {"简体中文:默认(%s)", "男性", "女性"},
	zhTW = {"繁體中文:預設值(%s)", "男性", "女性"},
}

for locale, info in next, voiceMap do
	local name, male, female = info[1], info[2], info[3]

	addonTbl.API:RegisterCountdown(("%s: Default (Male)"):format(locale), name:format(male), {
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\1.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\2.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\3.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\4.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\5.ogg",
	})

	local id = ("%s: Default (Female)"):format(locale)
	if locale == "esMX" then
		-- never extracted the esMX female announcer and it's gone now, so just use esES
		locale = "esES"
	end
	addonTbl.API:RegisterCountdown(id, name:format(female), {
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\1.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\2.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\3.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\4.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\5.ogg",
	})
end
