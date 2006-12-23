------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Shade of Aran"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local addsannounced, enrageannounced

----------------------------
--      Localization      --
----------------------------
--[[
    * Magnetic Pull / Super Arcane Explosion - Pulls everyone to the center of the room, Slows everyone, then starts a 10(?) second uninterruptable cast that deals 12,000 noncrit damage to a 30 yard radius (note that the room is only 35yds wide). If you start running as soon as you're pulled, you can avoid the AE even while Slowed.
    * Flame Wreath - 5(?) sec uninterruptable cast. Targets 3 random people in the raid. If there is no one close to them, nothing happens. If there are any other players near the target, it creates a circle of fire on the ground for 20 (??) seconds. Anyone who crosses the flame wreath (moving in our out) will trigger a 3-4k Explosion that hits everyone in the room. 
]]

L:RegisterTranslations("enUS", function() return {
	cmd = "Aran",

	adds_cmd = "adds",
	adds_name = "Water Elemental Adds",
	adds_desc = "Warn about the water elemental adds at 40%.",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn about enrage when he goes OOM.",

	blizzard_cmd = "blizzard",
	blizzard_name = "Blizzard",
	blizzard_desc = "Warn about the Blizzard.",

	conflag_cmd = "conflag",
	conflag_name = "Conflagration",
	conflag_desc = "Warn who is conflagged and mark them with a RTI.",

	pull_cmd = "pull",
	pull_name = "Pull/Super IAE",
	pull_desc = "Warn about the magnetic pull and Super Arcane Explosion.",

	flame_cmd = "flame",
	flame_name = "Flame Wreath",
	flame_desc = "Warn when someone is afflicted by Flame Wreath.",

	conflagration_trigger = "afflicted by Conflagration", -- Spell_Fire_Incinerate 10 sec
	blizzard_trigger = "begins to cast Blizzard", -- Spell_Frost_IceStorm 12 sec
	pull_trigger = "Magnetic Pull", -- Spell_Nature_GroundingTotem 10sec?
	flame_trigger = "(.*) (.*) afflicted by Flame Wreath", -- Spell_Fire_Fire tricky one

	adds_message = "Elementals incoming soon!",
	adds_bar = "Elementals despawn",

	enrage_warning = "Enrage soon!",
	enrage_message = "Enrage! AoE Polymorph!",
	enrage_bar = "Super Pyroblast Incoming",

	you = "You",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAran = BigWigs:NewModule(boss)
BigWigsAran.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsAran.enabletrigger = boss
BigWigsAran.toggleoptions = {"adds", "enrage", "blizzard", "conflag", "pull", "flame", "bosskill"}
BigWigsAran.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAran:OnEnable()
	self.core:Print("The Aran boss mod is beta quality, at best! Please don't rely on it for anything!")

	addsannounced = nil
	enrageannounced = nil

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "EventBucket")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "EventBucket")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF", "EventBucket")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "EventBucket")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_MANA")

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsAran:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, "refreshing drink") and self.db.profile.enrage then
		self:TriggerEvent("BigWigs_Message", L["enrage_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["enrage_bar"], 30, "Interface\\Icons\\Spell_Fire_Fireball02")
	end
end

-- Event bucket until we know what's really going on.
function BigWigsAran:EventBucket(msg)

end

function BigWigsAran:BigWigs_RecvSync(sync, rest, nick)
	
end

function BigWigsAran:UNIT_MANA(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local mana = UnitMana(msg)
		if mana > 1000 and mana <= 1200 and not enrageannounced then
			self:TriggerEvent("BigWigs_Message", L["enrage_warning"], "Important")
			enrageannounced = true
		elseif mana > 5000 and enrageannounced then
			enrageannounced = nil
		end
	end
end

function BigWigsAran:UNIT_HEALTH(msg)
	if not self.db.profile.adds then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 40 and health <= 43 and not addsannounced then
			self:TriggerEvent("BigWigs_Message", L["adds_message"], "Important")
			-- This bar should be 90 seconds and is probably triggered by
			-- something, we just fire it now at 40-43% HP since we have nothing
			-- better to go on.
			self:TriggerEvent("BigWigs_StartBar", self, L["adds_bar"], 95, "Interface\\Icons\\Spell_Frost_SummonWaterElemental_2")
			addsannounced = true
		elseif health > 70 and addsannounced then
			addsannounced = nil
		end
	end
end

