------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Azgalor"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local pName = UnitName("player")
local db = nil
local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Azgalor",

	doom = "Doom",
	doom_desc = "Warn for Doom.",
	doom_other = "Doom on %s",
	doom_you = "Doom on YOU!",

	howl = "Howl of Azgalor",
	howl_desc = "Warn for Howl of Azgalor.",
	howl_bar = "~Howl Cooldown",
	howl_message = "AOE Silence",
	howl_warning = "AOE Silence Soon!",

	fire = "Rain of Fire",
	fire_desc = "Warn when Rain of Fire is on you.",
	fire_you = "Rain of Fire on YOU!",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Doom (requires promoted or higher).",
} end )

L:RegisterTranslations("esES", function() return {
	doom = "Condena (Doom)",
	doom_desc = "Avisar sobre Condena.",
	doom_other = "Condena en %s",
	doom_you = "¡Condena en TI!",

	howl = "Aullido de Azgalor (Howl of Azgalor)",
	howl_desc = "Avisar de Aullido de Azgalor.",
	howl_bar = "~Aullido (Silencio)",
	howl_message = "Silencio de área",
	howl_warning = "¡Silencio de área en breve!",

	fire = "Lluvia de Fuego",
	fire_desc = "Avisar cuando te afecta Lluvia de Fuego.",
	fire_you = "¡Lluvia de Fuego en TI!",

	icon = "Icono",
	icon_desc = "Poner un icono de banda sobre los jugadores afectados por Condena. (Requiere derechos de banda)",
} end )

L:RegisterTranslations("frFR", function() return {
	doom = "Destin funeste",
	doom_desc = "Prévient quand un joueur subit les effets du Destin funeste.",
	doom_other = "Destin funeste sur %s",
	doom_you = "Destin funeste sur VOUS !",

	howl = "Hurlement d'Azgalor",
	howl_desc = "Prévient de l'arrivée des Hurlements d'Azgalor.",
	howl_bar = "~Recharge Hurlement",
	howl_message = "Silence de zone",
	howl_warning = "Silence de zone imminent !",

	fire = "Pluie de feu",
	fire_desc = "Prévient quand la Pluie de feu est sur vous.",
	fire_you = "Pluie de feu sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Destin funeste (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	doom = "파멸",
	doom_desc = "파멸에 대한 경고입니다.",
	doom_other = "%s에 파멸",
	doom_you = "당신에 파멸!",

	 howl = "아즈갈로의 울부짖음",
	 howl_desc = "아즈갈로의 울부짖음을 경보합니다.",
	 howl_bar = "~침묵 대기시간",
	 howl_message = "광역 침묵",
	 howl_warning = "곧 광역 침묵!",

	 fire = "불의 비",
	 fire_desc = "자신에게 불의 비가 내릴때를 알림니다.",
	 fire_you = "당신에 불의 비!",

	icon = "전술 표시",
	icon_desc = "파멸에 걸린 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("deDE", function() return {
	doom = "Verdammnis",
	doom_desc = "Warnt vor Verdammnis.",
	doom_other = "Verdammnis auf %s",
	doom_you = "Verdammnis auf DIR!",

	howl = "Geheul des Azgalor",
	howl_desc = "Warnt vor Geheul des Azgalor.",
	howl_bar = "~Geheul Cooldown",
	howl_message = "AOE Stille",
	howl_warning = "AOE Stille Bald!",

	fire = "Feuerregen",
	fire_desc = "Warnt wenn Feuerregen auf dir ist.",
	fire_you = "Feuerregen auf DIR!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziere ein Schlachtzug Symbol auf Spielern die von Verdammnis betroffen sind (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhTW", function() return {
	doom = "災厄降臨",
	doom_desc = "災厄降臨警報",
	doom_other = "災厄降臨: [%s]",
	doom_you = "你受到災厄降臨!",

	howl = "亞茲加洛之吼",
	howl_desc = "亞茲加洛之吼警報",
	howl_bar = "<亞茲加洛之吼冷卻>",
	howl_message = "群體沉默",
	howl_warning = "即將發動群體沉默!",

	fire = "火焰之雨",
	fire_desc = "當你在火焰之雨範圍時發出警報",
	fire_you = "你受到火焰之雨!",

	icon = "團對標記",
	icon_desc = "在受到災厄降臨的隊友頭上標記 (需要權限)",
} end )

L:RegisterTranslations("zhCN", function() return {
	doom = "厄运",
	doom_desc = "当玩家受到厄运时发出警报。",
	doom_other = "厄运：>%s<！",
	doom_you = ">你< 厄运！",

	howl = "阿兹加洛之嚎",
	howl_desc = "阿兹加洛之嚎警报。",
	howl_bar = "<阿兹加洛之嚎 冷却>",
	howl_message = "群体沉默",
	howl_warning = "即将 群体沉默！",

	fire = "火焰之雨",
	fire_desc = "当你受到火焰之雨时发出警报。",
	fire_you = ">你< 火焰之雨！",

	icon = "团队标记",
	icon_desc = "给受到诅咒的队员打上标记。（需要权限）",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"doom", "howl", "fire", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "RainOfFire", 31340)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Howl", 31344)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Doom", 31347)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:RainOfFire(player)
	if db.fire and player == pName then
		self:LocalMessage(L["fire_you"], "Urgent", 31340, "Alarm")
	end
end

function mod:Howl(_, spellID)
	if db.howl then
		self:IfMessage(L["howl_message"], "Important", spellID)
		self:Bar(L["howl_bar"], 16, spellID)
		self:DelayedMessage(15, L["howl_warning"], "Important")
	end
end

function mod:Doom(player, spellID)
	if db.doom then
		local other = L["doom_other"]:format(player)
		if player == pName then
			self:LocalMessage(L["doom_you"], "Personal", spellID, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", spellID)
		end
		self:Bar(other, 19, spellID)
		self:Icon(player, "icon")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.enrage then
			self:Enrage(600)
		end
	end
end

