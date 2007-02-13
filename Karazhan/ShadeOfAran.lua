------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Shade of Aran"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local drinkannounced
local addsannounced

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Aran",

	adds_cmd = "adds",
	adds_name = "Elementals",
	adds_desc = "Warn about the water elemental adds spawning.",

	drink_cmd = "drink",
	drink_name = "Drinking",
	drink_desc = "Warn when Shade of Aran starts to drink.",

	engage_cmd = "engage",
	engage_name = "Engage",
	engage_desc = "Warn when Shade of Aran has been engaged",

	blizzard_cmd = "blizzard",
	blizzard_name = "Blizzard",
	blizzard_desc = "Warn about the Blizzard.",

	pull_cmd = "pull",
	pull_name = "Pull/Super AE",
	pull_desc = "Warn about the magnetic pull and Super Arcane Explosion.",

	flame_cmd = "flame",
	flame_name = "Flame Wreath",
	flame_desc = "Warn when someone is afflicted by Flame Wreath.",

	adds_message = "Elementals Incoming!",
	adds_warning = "Elementals Soon",
	adds_trigger = "I'm not finished yet! No, I have a few more tricks up my sleeve...",
	adds_bar = "Elementals despawn",

	drink_trigger = "Surely you wouldn't deny an old man a replenishing drink? No, no, I thought not.",
	drink_warning = "Low Mana - Drinking Soon!",
	drink_message = "Drinking - AoE Polymorph!",
	drink_bar = "Super Pyroblast Incoming",

	engage_trigger1 = "I'll not be tortured again!",
	engage_trigger2 = "Who are you? What do you want? Stay away from me!",
	engage_message = "Shade of Aran Engaged",

	blizzard_trigger1 = "Back to the cold dark with you!",
	blizzard_trigger2 = "I'll freeze you all!",
	blizzard_message = "Casting Blizzard!",

	pull_message = "Arcane Explosion is casting!",
	pull_trigger1 = "Yes, yes my son is quite powerful... but I have powers of my own!",
	pull_trigger2 = "I am not some simple jester! I am Nielas Aran!",
	pull_bar = "Arcane Explosion",

	flame_warning = "Casting Flame Wreath!",
	flame_trigger1 = "I'll show you: this beaten dog still has some teeth!",
	flame_trigger2 = "Burn, you hellish fiends!",

	flame_message = "Flame Wreath!",
	flame_bar = "Flame Wreath",
	flame_trigger = "casts Flame Wreath",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAran = BigWigs:NewModule(boss)
BigWigsAran.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsAran.enabletrigger = boss
BigWigsAran.toggleoptions = {"engage", "adds", "drink", -1, "blizzard", "pull", "flame", "bosskill"}
BigWigsAran.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAran:OnEnable()
	drinkannounced = nil
	addsannounced = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("UNIT_MANA")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsAran:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.drink and msg == L["drink_trigger"] then
		self:Message(L["drink_message"], "Positive")
		self:Bar(self, L["drink_bar"], 30, "Spell_Fire_Fireball02")
	elseif self.db.profile.pull and (msg == L["pull_trigger1"] or msg == L["pull_trigger2"])
		self:Message(L["pull_message"], "Attention")
		self:Bar(self, L["pull_bar"], 10, "Spell_Nature_GroundingTotem")
	elseif self.db.profile.flame and (msg == L["flame_trigger1"] or msg == L["flame_trigger2"])
		self:Message(L["flame_warning"], "Important", nil, "Alarm")
	elseif self.db.profile.blizzard and (msg == L["blizzard_trigger1"] or msg == L["blizzard_trigger2"])
		self:Message(L["blizzard_message"], "Attention")
	elseif self.db.profile.engage and (msg == L["engage_trigger1"] or msg == L["engage_trigger2"])
		self:Message(L["engage_message"], "Positive")
	end
end

function BigWigsAran:CHAT_MSG_MONSTER_SAY(msg)
	if self.db.profile.adds and msg == L["adds_trigger"] then
		self:Message(L["adds_message"], "Important")
		self:Bar(self, L["adds_bar"], 90, "Spell_Frost_SummonWaterElemental_2")
	end
end

function BigWigsAran:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.flame and msg:find(L["flame_trigger"]) then
		self:Message(L["flame_message"], "Important")
		self:Bar(self, L["flame_bar"], 20, "Spell_Fire_Fire")
	end
end

function BigWigsAran:UNIT_MANA(msg)
	if not self.db.profile.drink then return end
	if UnitName(msg) == boss then
		local mana = UnitMana(msg)
		if mana > 5000 and mana <= 10000 and not drinkannounced then
			self:Message(L["drink_warning"], "Urgent", nil, "Alert")
			drinkannounced = true
		elseif mana > 20000 and drinkannounced then
			drinkannounced = nil
		end
	end
end

function BigWigsAran:UNIT_HEALTH(msg)
	if not self.db.profile.adds then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 43 and health <= 46 and not addsannounced then
			self:Message(L["adds_warning"], "Urgent", nil, "Alert")
			addsannounced = true
		elseif health > 50 and addsannounced then
			addsannounced = false
		end
	end
end
