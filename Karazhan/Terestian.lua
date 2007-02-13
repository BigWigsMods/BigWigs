--[[Attacks and Abilities

    * Terestrian Illhoof comes with an Elite imp minion. He deals a moderate amount of melee damage, the imp does Fire damage.
    * Terestrian summons a constant stream of nonelite imps that fireball for around 250, and have very little (1.5-2k) HP.
    * Terestrian will occasionally Sacrifice one player. This teleports them to the altar, wraps them in Dark Chains, paralyzes them, and deals 1k damage per second while healing Terestrian. The Dark Chains must be DPSed down to free the affected player. This is similar to Maexxna's Web Wrap, but far more damaging.
    * Terestrian will occasionally put a Mark of Flames debuff (Not sure if it's dispellable) on one player. It increases Fire damage taken by 500, tripling the damage taken from the nonelite imps. 

Strategy

    * Healers will take heavy damage from imp fire, they spend alot of mana healing themselves.
    * Terestrian and his Elite imp don't do a whole lot of damage to tanks.
    * Focus DPS on Terestrian, ignore his elite Imp pet. If it dies, Terestrian will simply resummon it.
    * The most important thing in the fight is to DPS down Dark Chains as soon as they appear. Otherwise, the Sacrifice victim will die very quickly, and Terestrian will heal a lot.
    * Every once in a while, the raid leader should call AoE to clear out the nonelite imps. Once most of them are dead, the group should resume hard DPS on the boss. 
]]

------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Terestian Illhoof"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Terestian",

	sacrifice_cmd = "sacrifice",
	sacrifice_name = "Sacrifice Alert",
	sacrifice_desc = "Warn for Sacrifice of players.",

	sacrifice_you = "You",
	sacrifice_trigger = "^([^%s]+) ([^%s]+) afflicted by Sacrifice",
	sacrifice_warning = "%s is being Sacrificed!",

} end )

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsTerestian = BigWigs:NewModule(boss)
BigWigsTerestian.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsTerestian.enabletrigger = boss
BigWigsTerestian.toggleoptions = {"sacrifice", "bosskill"}
BigWigsTerestian.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsTerestian:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckSacrifice")
end

------------------------------
--     Event Handlers    --
------------------------------

function BigWigsTerestian:CheckSacrifice( msg )
	if not self.db.profile.sacrifice then return end
	local splayer, stype = select(3, msg:find(L["sacrifice_trigger"]))
	if splayer then
		if splayer == L["sacrifice_you"] then
			splayer = UnitName("player")
		end
		self:Message( L["sacrifice_warning"]:format( splayer ), "Attention" )
	end
end
