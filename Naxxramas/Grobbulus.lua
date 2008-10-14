------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Grobbulus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Grobbulus",

	youinjected = "You're injected",
	youinjected_desc = "Warn when you're injected.",
	bomb_message_you = "You are injected!",

	otherinjected = "Others injected",
	otherinjected_desc = "Warn when others are injected.",
	bomb_message_other = "%s is injected!",

	icon = "Place Icon",
	icon_desc = "Place a raid icon on an injected person. (Requires promoted or higher)",

	cloud = "Poison Cloud",
	cloud_desc = "Warn for Poison Clouds.",
	cloud_warn = "Poison Cloud! Next in ~15 seconds!",
	cloud_bar = "Next Poison Cloud",
} end )

L:RegisterTranslations("deDE", function() return {
	youinjected = "Du bist verseucht",
	youinjected_desc = "Warnung, wenn Du von Mutagene Injektion betroffen bist.",
	bomb_message_you = "Du bist verseucht!",

	otherinjected = "X ist verseucht",
	otherinjected_desc = "Warnung, wenn andere Spieler von Mutagene Injektion betroffen sind.",
	bomb_message_other = "%s ist verseucht!",

	icon = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der von Mutagene Injektion betroffen ist. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	cloud = "Giftwolke",
	cloud_desc = "Warnung vor Giftwolken.",
	cloud_warn = "Giftwolke! N\195\164chste in ~15 Sekunden!",
	cloud_bar = "Giftwolke",
} end )

L:RegisterTranslations("koKR", function() return {
	youinjected = "자신의 돌연변이",
	youinjected_desc = "자신의 돌연변이를 알립니다.",
	bomb_message_you = "당신은 돌연변이 유발!",

	otherinjected = "타인의 돌연변이",
	otherinjected_desc = "타인의 돌연변이를 알립니다.",
	bomb_message_other = "%s 돌연변이 유발!",

	icon = "전술 표시",
	icon_desc = "돌연변이 유발 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	cloud = "독구름",
	cloud_desc = "독구름을 알립니다.",
	cloud_warn = "독구름! 다음은 약 15초 이내!",
	cloud_bar = "독구름",
} end )

L:RegisterTranslations("zhCN", function() return {
	youinjected = "玩家变异注射警报",
	youinjected_desc = "你中了变异注射时发出警报",
	bomb_message_you = "你中变异注射了！",

	otherinjected = "队友变异注射警报",
	otherinjected_desc = "队友中了变异注射时发出警报",
	bomb_message_other = "%s中变异注射了！",

	icon = "标记图标",
	icon_desc = "在中了变异注射的队友头上标记骷髅图标（需要助理或领袖权限）",

	cloud = "毒性云雾",
	cloud_desc = "毒性云雾警报",
	cloud_warn = "~15 秒后施放毒性云雾！",
	cloud_bar = "毒性云雾",
} end )

L:RegisterTranslations("zhTW", function() return {
	youinjected = "突變注射警報",
	youinjected_desc = "你中了突變注射時發出警報",
	bomb_message_you = "你中突變注射了！",

	otherinjected = "隊友突變注射警報",
	otherinjected_desc = "隊友中了突變注射時發出警報",
	bomb_message_other = "%s 中突變注射了！",

	icon = "標記突變注射",
	icon_desc = "在中了突變注射的隊友頭上標記骷髏標記（需要助理或領隊權限）",

	cloud = "毒雲術",
	cloud_desc = "當施放毒雲術時發出警報",
	cloud_warn = "15 秒後再次施放毒雲！",
	cloud_bar = "毒雲術",
} end )

L:RegisterTranslations("frFR", function() return {
	youinjected = "Injection mutante sur vous",
	youinjected_desc = "Préviens quand vous subissez les effets de l'Injection mutante.",
	bomb_message_you = "Tu es injecté !",

	otherinjected = "Injection mutante sur les autres",
	otherinjected_desc = "Préviens quand un joueur subit les effets de l'Injection mutante.",
	bomb_message_other = "%s est injecté !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Injection mutante (nécessite d'être promu ou mieux).",

	cloud = "Nuage empoisonné",
	cloud_desc = "Préviens quand Globbulus lance ses nuages empoisonnés.",
	cloud_warn = "Nuage empoisonné ! Prochain dans ~15 sec. !",
	cloud_bar = "Nuage empoisonné",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15931
mod.toggleoptions = {"youinjected", "otherinjected", "icon", "cloud", -1, "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Inject", 28169)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Cloud", 28240)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Inject(player, spellID)
	local other = L["bomb_message_other"]:format(player)
	if self.db.profile.youinjected and UnitIsUnit(player, "player") then
		self:LocalMessage(L["bomb_message_you"], "Personal", spellID, "Alarm")
		self:WideMessage(other)
		self:Bar(other, 10, spellID)
	elseif self.db.profile.otherinjected then
		self:IfMessage(other, "Attention", spellID)
		self:Whisper(rest, L["bomb_message_you"])
		self:Bar(other, 10, spellID)
	end
	self:Icon(player, "other")
end

function mod:Cloud(_, spellID)
	if self.db.profile.cloud then
		self:IfMessage(L["cloud_warn"], "Urgent", spellID)
		self:Bar(L["cloud_bar"], 15, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.enrage then
			self:Enrage(720)
		end
	end
end

