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
	brainwash_name = "Brainwash Totem Alert",
	brainwash_desc = "Warn for Brainwash Totems",
	
	healing_cmd = "healing",
	healing_name = "Healing Totem Alert",
	healing_desc = "Warn for Healing Totems",
	
	triggerbrainwash = "Jin'do der Verhexer wirkt Totem der Gehirnw\195\164sche beschw\195\182ren.",
	triggerhealing = "Jin'do der Verhexer wirkt M\195\164chtiger Heilungszauberschutz.",

	warnbrainwash = "\195\156bernahmetotem!",
	warnhealing = "Heiltotem!",
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