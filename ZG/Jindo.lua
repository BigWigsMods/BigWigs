------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Jin'do the Hexxer")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "jindo",
	
	brainwash_cmd = "brainwash",
	brainwash_name = "Brainwash Totem Alert",
	brainwash_desc = "Warn for Brainwash Totems",
	
	healing_cmd = "healing",
	healing_name = "Healing Totem Alert",
	healing_desc = "Warn for Healing Totems",
	
	triggerbrainwash = "Jin'do the Hexxer casts Summon Brain Wash Totem.",
	triggerhealing = "Jin'do the Hexxer casts Powerful Healing Ward.",

	warnbrainwash = "Brain Wash Totem!",
	warnhealing = "Healing Totem!",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "jindo",
	
	brainwash_cmd = "brainwash",
	brainwash_name = "Gehirnw\195\164sche",
	brainwash_desc = "Warnung, wenn Jin'do \195\156bernahmetotem beschw\195\182rt.",
	
	healing_cmd = "healing",
	healing_name = "Heiltotem",
	healing_desc = "Warnung, wenn Jin'do Heiltotem beschw\195\182rt.",
	
	triggerbrainwash = "Jin'do der Verhexer wirkt Totem der Gehirnw\195\164sche beschw\195\182ren.",
	triggerhealing = "Jin'do der Verhexer wirkt M\195\164chtiger Heilungszauberschutz.",

	warnbrainwash = "\195\156bernahmetotem!",
	warnhealing = "Heiltotem!",
} end )

L:RegisterTranslations("zhCN", function() return {
	brainwash_name = "洗脑图腾警报",
	brainwash_desc = "洗脑图腾警报",
	
	healing_name = "治疗图腾警报",
	healing_desc = "治疗图腾警报",
	
	triggerbrainwash = "金度施放了召唤洗脑图腾。",
	triggerhealing = "金度施放了强效治疗守卫。",

	warnbrainwash = "洗脑图腾！",
	warnhealing = "治疗图腾！",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsJindo = BigWigs:NewModule(boss)
BigWigsJindo.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsJindo.enabletrigger = boss
BigWigsJindo.toggleoptions = {"brainwash", "healing", "bosskill"}
BigWigsJindo.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsJindo:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsJindo:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.brainwash and msg == L"triggerbrainwash" then
		self:TriggerEvent("BigWigs_Message", L"warnbrainwash", "Orange")
	elseif self.db.profile.healing and msg == L"triggerhealing" then
		self:TriggerEvent("BigWigs_Message", L"warnhealing", "Red" )
	end 
end
