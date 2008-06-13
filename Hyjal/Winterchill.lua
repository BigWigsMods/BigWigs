------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Rage Winterchill"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Winterchill",

	decay = "Death & Decay on You",
	decay_desc = "Warn for Death & Decay on You.",
	decay_message = "Death & Decay on YOU!",

	icebolt = "Icebolt",
	icebolt_desc = "Icebolt warnings.",
	icebolt_message = "Icebolt on %s!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player afflicted by Icebolt (requires promoted or higher).",
} end )

L:RegisterTranslations("esES", function() return {
	decay = "Muerte y descomposición (Death & Decay)",
	decay_desc = "Avisar sobre Muerte y descomposición en ti.",
	decay_message = "¡Muerte y descomposición en TI!",

	icebolt = "Descarga de hielo (Icebolt)",
	icebolt_desc = "Avisos de Descarga de hielo.",
	icebolt_message = "¡Descarga de hielo en %s!",

	icon = "Icono de banda",
	icon_desc = "Poner un icono de banda sobre los jugadores afectados por Descarga de hielo. (Requiere derechos de banda)",
} end )

L:RegisterTranslations("frFR", function() return {
	decay = "Mort & décomposition sur vous",
	decay_desc = "Prévient quand la Mort & décomposition est sur vous.",
	decay_message = "Mort & décomposition sur VOUS !",

	icebolt = "Eclair de glace",
	icebolt_desc = "Avertissements concernant l'Eclair de glace.",
	icebolt_message = "Eclair de glace sur %s !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Eclair de glace (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	decay = "자신의 죽음과 부패",
	decay_desc = "자신이 죽음과 부패에 걸렸을 때 알립니다.",
	decay_message = "당신은 죽음과 부패!",

	icebolt = "얼음 화살",
	icebolt_desc = "얼음 화살 경고.",
	icebolt_message = "%s 얼음 화살!",

	icon = "전술 표시",
	icon_desc = "얼음 화살에 걸린 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 요구)",
} end )

L:RegisterTranslations("deDE", function() return {
	decay = "Tod & Verfall auf dir",
	decay_desc = "Warnt vor Tod & Verfall auf dir.",
	decay_message = "Tod & Verfall auf DIR!",

	icebolt = "Eisblitz",
	icebolt_desc = "Eisblitz Warnung.",
	icebolt_message = "Eisblitz auf %s!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziere ein Schlachtzug Symbol auf Spielern die von Eisblitz betroffen sind (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhTW", function() return {
	decay = "死亡凋零",
	decay_desc = "通報你受到死亡凋零",
	decay_message = "你受到死亡凋零!",

	icebolt = "寒冰箭",
	icebolt_desc = "寒冰箭警告",
	icebolt_message = "寒冰箭: [%s]",

	icon = "團隊標記",
	icon_desc = "在受到寒冰箭的隊友頭上標記 (需要權限)",
} end )

L:RegisterTranslations("zhCN", function() return {
	decay = "死亡凋零",
	decay_desc = "当你受到死亡凋零发出警报。",
	decay_message = ">你< 死亡凋零！逃离！",

	icebolt = "寒冰箭",
	icebolt_desc = "当玩家受到寒冰箭时发出警报。",
	icebolt_message = "寒冰箭：>%s<！",

	icon = "团队标记",
	icon_desc = "给中了寒冰箭的玩家打上标记。（需要权限）",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Hyjal Summit"]
mod.enabletrigger = boss
mod.guid = 17767
mod.toggleoptions = {"decay", -1, "icebolt", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Icebolt", 31249)
	self:AddCombatListener("SPELL_AURA_APPLIED", "DeathAndDecay", 31258)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Icebolt(player, spellID)
	if db.icebolt then
		self:IfMessage(L["icebolt_message"]:format(player), "Important", spellID, "Alert")
		self:Icon(player, "icon")
	end
end

function mod:DeathAndDecay(player, spellID)
	if UnitIsUnit(player, "player") and db.decay then
		self:LocalMessage(L["decay_message"], "Personal", spellID, "Alarm")
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

