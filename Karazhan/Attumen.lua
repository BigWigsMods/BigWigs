------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Attumen the Huntsman"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local horse = BB["Midnight"]
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Attumen",

	phase = "Phase",
	phase_desc = "Warn when entering a new Phase.",
	phase2_trigger = "%s calls for her master!",
	phase2_message = "Phase 2 - %s & Attumen",
	phase3_trigger = "Come Midnight, let's disperse this petty rabble!",
	phase3_message = "Phase 3 - %s",

	curse = "Cursed Tanks",
	curse_desc = "Warn when a tank is cursed by Intangible Presence.",
	curse_message = "Tank Cursed - %s",
} end)

L:RegisterTranslations("deDE", function() return {
	phase = "Phase",
	phase_desc = "Warnt wenn eine neue Phase beginnt",
	phase2_trigger = "%s ruft nach ihrem Meister!",
	phase2_message = "Phase 2 - %s & Attumen",
	phase3_trigger = "Komm Mittnacht, lass' uns dieses Gesindel auseinander treiben!",
	phase3_message = "Phase 3 - %s",

	curse = "Verfluchter Tank",
	curse_desc = "Warnt wenn ein Tank verflucht ist",
	curse_message = "Tank verflucht - %s",
} end)

L:RegisterTranslations("frFR", function() return {
	phase = "Phase",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase2_trigger = "%s appelle son maître !",
	phase2_message = "Phase 2 - %s & Attumen",
	phase3_trigger = "Viens, Minuit, allons disperser cette insignifiante racaille !",
	phase3_message = "Phase 3 - %s",

	curse = "Tanks maudits",
	curse_desc = "Préviens quand un tank est maudit par la Présence immatérielle.",
	curse_message = "Tank maudit - %s",
} end)


L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "새로운 단계 진입 시 알립니다.",
	phase2_trigger = "%s|1이;가; 주인을 부릅니다!",
	phase2_message = "2 단계 - %s & 어튜멘",
	phase3_trigger = "이랴! 이 오합지졸을 데리고 실컷 놀아보자!",
	phase3_message = "3 단계 - %s",

	curse = "저주 걸린 전사",
	curse_desc = "탱커가 무형의 저주에 걸렸을 때 경고합니다.",
	curse_message = "저주 걸린 전사 - %s",
} end)

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段警报",
	phase_desc = "当进入下一阶段时发出警告。",
	phase2_trigger = "%s呼喊着她的主人！",
	phase2_message = "第二阶段 - %s和阿图门",
	phase3_trigger = "来吧，午夜，让我们解决这群乌合之众！",
	phase3_message = "第三阶段 - %s",

	curse = "诅咒警报",
	curse_desc = "当近战受到无形的诅咒时发出警告。",
	curse_message = "无形：>%s<！- 速度解除！",
} end)

L:RegisterTranslations("zhTW", function() return {
	phase = "階段警告",
	phase_desc = "當進入下一個階段時發送警告",
	phase2_trigger = "%s呼叫她的主人!",
	phase2_message = "第二階段 - %s & 阿圖曼",
	phase3_trigger = "來吧午夜，讓我們驅散這群小規模的烏合之眾!",
	phase3_message = "第三階段 - %s",

	curse = "詛咒警告",
	curse_desc = "近戰受到無形守護的詛咒時發送警告",
	curse_message = "無形守護詛咒：[%s] - 解詛咒",
} end)

L:RegisterTranslations("esES", function() return {
	phase = "Fase",
	phase_desc = "Aviso cuando entra en una nueva Fase.",
	phase2_trigger = "%s llama a su maestro!",
	phase2_message = "Fase 2 - %s & Attumen",
	phase3_trigger = "Vamos, Medianoche, dispersemos esta muchedumbre insignificante!",
	phase3_message = "Fase 3 - %s",

	curse = "Tanques Malditos",
	curse_desc = "Avisa cuando un guerrero o un druida es afectado por Presencia intangible.",
	curse_message = "Tanque Maldito - %s",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = {horse, boss}
mod.toggleoptions = {"phase", "curse", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Curse", 29833)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

local rfID = GetSpellInfo(25780) --Righteous Fury
local function isPlayerTank(player)
	if UnitPowerType(player) == 1 then return true end
	local _, class = UnitClass(player)
	if class ~= "PALADIN" then return end
	local i = 1
	local name = UnitBuff(player, i)
	while name do
		if name == rfID then return true end
		i = i + 1
		name = UnitBuff(player, i)
	end
end

function mod:Curse(player)
	if db.curse and isPlayerTank(player) then
		self:IfMessage(L["curse_message"]:format(player), "Attention", 29833)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase3_trigger"] and db.phase then
		self:Message(L["phase3_message"]:format(boss), "Important")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["phase2_trigger"] and db.phase then
		self:Message(L["phase2_message"]:format(horse), "Urgent")
	end
end

