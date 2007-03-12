------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Sulfuron Harbinger"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sulfuron",

	inspire_name = "Inpire Gain Alert",
	inspire_desc = "Warn when Sulfuron gains Inspire",

	heal_name = "Heal Alert",
	heal_desc = "Warn when a Flamewaker Priest starts healing",

	inspire_trigger = "%s gains Inspire",
	inpire_message = "Sulfuron gains Inspire!",
	inspire_bar = "Inspire",

	heal_trigger = "begins to cast Dark Mending",
	heal_message = "A Flamewaker Priest is healing!",
	heal_bar = "Dark Mending",
} end)

L:RegisterTranslations("frFR", function() return {
	inspire_name = "Alerte Inspirer",
	inspire_desc = "Pr\195\169viens quand le Messager de Sulfuron gagne Inspirer.",

	heal_name = "Alerte Soins",
	heal_desc = "Pr\195\169viens quand un Pr\195\170tre Attise-flammes commence \195\160 lancer un soin.",

	inspire_trigger = "%s gagne Inspirer",
	inpire_message = "Sulfuron gagne Inspirer !",
	inspire_bar = "Inspirer",

	heal_trigger = "commence \195\160 lancer Gu\195\169rison t\195\169n\195\169breuse",
	heal_message = "Un Pr\195\170tre Attise-flammes lance un soin !",
	heal_bar = "Gu\195\169rison t\195\169n\195\169breuse",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
mod.enabletrigger = boss
mod.toggleoptions = {"inspire", -1, "heal", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SulfuronInsp", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "SulfuronHeal", 2.5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (msg:find(L["inspire_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "SulfuronInsp")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if (msg:find(L["heal_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "SulfuronHeal")
	end
end

function mod:BigWigs_RecvSync(sync)
	if (sync == "SulfuronInsp" and self.db.profile.inspire) then
		self:TriggerEvent("BigWigs_Message", L["inpire_message"], "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["inspire_bar"], 10, "Interface\\Icons\\Ability_Warrior_BattleShout")
	elseif (sync == "SulfuronHeal" and self.db.profile.heal) then
		self:TriggerEvent("BigWigs_Message", L["heal_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["heal_bar"], 2, "Interface\\Icons\\Spell_Shadow_ChillTouch")
	end
end
