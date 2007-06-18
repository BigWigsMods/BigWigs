------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local boss = BB["The Illidari Council"]
local malande = BB["Lady Malande"]
local gathios = BB["Gathios the Shatterer"]
local zerevor = BB["High Nethermancer Zerevor"]
local veras = BB["Veras Darkshadow"]
BB = nil

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheIllidariCouncil",

	immune = "Immunity Warning",
	immune_desc = "Warn when Malande becomes immune to spells or melee attacks.",
	immune_spell_trigger = "Lady Malande gains Blessing of Spell Warding.",
	immune_melee_trigger = "Lady Malande gains Blessing of Protection.",
	immune_message = "Malande: %s Immune for 15sec!",
	immune_bar = "%s Immune!",

	spell = "Spell",
	melee = "Melee",

	shield = "Reflective Shield",
	shield_desc = "Warn when Malande Gains Reflective Shield.",
	shield_trigger = "Lady Malande gains Reflective Shield.",
	shield_message = "Reflective Shield on Malande!",

	poison = "Deadly Poison",
	poison_desc = "Warn for Deadly Poison on players.",
	poison_trigger = "^([^%s]+) ([^%s]+) afflicted by Deadly Poison.$",
	poison_other = "%s has Deadly Poison!",
	poison_you = "Deadly Poison on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Deadly Poison.",

	circle = "Circle of Healing",
	circle_desc = "Warn when Malande begins to cast Circle of Healing.",
	circle_trigger = "Lady Malande begins to cast Circle of Healing.",
	circle_message = "Casting Circle of Healing!",
	circle_heal_trigger = "^Lady Malande 's Circle of Healing heals",
	circle_fail_trigger = "interrupted", --GIVE ME A FUCKING EVENT OK
	circle_heal_message = "Healed! - Next in ~20sec",
	circle_fail_message = "Interrupted! - Next in ~12sec",
	circle_bar = "~Circle of Healing Cooldown",
} end )

--[[
DEV INFO

Debuff "Deadly Poison" -> Raid Warning -> Deadly Poison on <Name> (needs healing attention because it ticks for 1k and is followed by an envenom for 4-6k)

Boss cast -> "Lady Malande begins to cast Circle of Healing." -> Raid Warning (needs to be interupted asap, rotation), cooldown ~12sec, 20+sec after successful cast,

warning "Reflective Shield" on Malande "Lady Malande gains Reflective Shield." 

Lady Malande -> Buff "Lady Malande gains Blessing of Spell Warding" -> 15 Sec Spell immune

Lady Malande -> Buff "Lady Malande gains Blessing of Protection" -> 15 sec melee immune

]]

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = {malande, gathios, zerevor, veras}
mod.toggleoptions = {"immune", "shield", "circle", "poison", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Poison")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Poison")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Poison")

	--self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	--self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalSpell", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalMelee", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCCast", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCHeal", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCFail", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "CouncilPoison", 2)
end

------------------------------
--      Event Handlers      --
------------------------------


function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MalSpell" and self.db.profile.immune then
		self:Message(L["immune_message"]:format(L["spell"]), "Positive", nil, "Alarm")
		self:Bar(L["immune_bar"]:format(L["spell"]), 15, "Spell_Holy_SealOfRighteousness")
	elseif sync == "MalMelee" and self.db.profile.immune then
		self:Message(L["immune_message"]:format(L["melee"]), "Positive", nil, "Alert")
		self:Bar(L["immune_bar"]:format(L["melee"]), 15, "Spell_Holy_SealOfProtection")
	elseif sync == "MalShield" and self.db.profile.shield then
		self:Message(L["shield_message"], "Important", nil, "Long")
	elseif sync == "MalCCast" and self.db.profile.circle then
		self:Message(L["circle_message"], "Attention", nil, "Info")
		self:Bar(L["circle"], 2.5, "Spell_Holy_CircleOfRenewal")
	elseif sync == "MalCHeal" and self.db.profile.circle then
		self:Message(L["circle_heal_message"], "Urgent")
		self:Bar(L["circle_bar"], 20, "Spell_Holy_CircleOfRenewal")
	elseif sync == "MalCFail" and self.db.profile.circle then
		self:Message(L["circle_fail_message"], "Urgent")
		self:Bar(L["circle_bar"], 12, "Spell_Holy_CircleOfRenewal")
	elseif sync == "CouncilPoison" and rest and self.db.profile.poison then
		local other = L["poison_other"]:format(rest)
		if rest == UnitName("player") then
			self:Message(L["poison_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["immune_spell_trigger"] then
		self:Sync("MalSpell")
	elseif msg == L["immune_melee_trigger"] then
		self:Sync("MalMelee")
	elseif msg == L["shield_trigger"] then
		self:Sync("MalShield")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["circle_trigger"] then
		self:Sync("MalCCast")
	elseif msg == L["circle_heal_trigger"] then
		self:Sync("MalCHeal")
	elseif msg:find(L["circle_fail_trigger"]) then
		self:Sync("MalCFail") --im aware this won't work ;) it seemes UNIT_SPELLCAST_INTERRUPTED only fires for friendly targets, not sure how to pick it up
	end
end

function mod:Poison()
	local pplayer, ptype = select(3, msg:find(L["poison_trigger"]))
	if pplayer and ptype then
		if pplayer == L2["you"] and ptype == L2["are"] then
			pplayer = UnitName("player")
		end
		self:Sync("CouncilPoison "..pplayer)
	end
end
