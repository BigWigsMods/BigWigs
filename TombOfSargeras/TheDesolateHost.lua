if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO List:
-- - Proximity: List of players in each realm, filter by realm.
-- - Soulbind: Able to see who is linked with who?
-- - Shattering Scream: Find target before debuffs?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Desolate Host", 1147, 1896)
if not mod then return end
mod:RegisterEnableMob(118460, 118462, 119072) -- Engine of Souls, Soul Queen Dejahna, The Desolate Host
mod.engageId = 2054
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{239006, "PROXIMITY"}, -- Dissonance
		236507, -- Quietus
		{235933, "SAY"}, -- Spear of Anguish
		235907, -- Collapsing Fissure
		{235989, "SAY"}, -- Tormented Cries
		235956, -- Rupturing Slam
		235968, -- Grasping Darkness
		236513, -- Bonecage Armor
		236340, -- Crush Mind
		236131, -- Wither
		236449, -- Soulbind
		236075, -- Wailing Souls
		236515, -- Shattering Scream
		236361, -- Spirit Chains
		236542, -- Sundering Doom
		236544, -- Doomed Sundering
		236548, -- Torment
	},{
		[239006] = "general",
		[235933] = -14856,-- Corporeal Realm
		[235956] = CL.adds,-- Adds
		[236340] = -14857,-- Spirit Realm
		[236515] = CL.adds,-- Adds
		[236542] = -14970, -- Tormented Souls
	}
end

function mod:OnBossEnable()
	-- General
	--self:Log("SPELL_CAST_SUCCESS", "Dissonance", 239006) -- Dissonance
	self:Log("SPELL_CAST_SUCCESS", "Quietus", 236507) -- Quietus

	-- Corporeal Realm
	self:Log("SPELL_AURA_APPLIED", "SpearofAnguish", 235933, 242796) -- Spear of Anguish
	self:Log("SPELL_CAST_SUCCESS", "CollapsingFissure", 235907) -- Collapsing Fissure
	self:Log("SPELL_AURA_APPLIED", "TormentedCriesApplied", 238018) -- Tormented Cries (Debuff)
	-- Adds
	self:Log("SPELL_CAST_SUCCESS", "RupturingSlam", 235956) -- Rupturing Slam
	self:Log("SPELL_CAST_START", "GraspingDarkness", 235968) -- Grasping Darkness
	self:Log("SPELL_AURA_APPLIED", "BonecageArmor", 236513) -- Bonecage Armor
	self:Log("SPELL_AURA_REMOVED", "BonecageArmorRemoved", 236513) -- Bonecage Armor

	-- Spirit Realm
	self:Log("SPELL_CAST_START", "CrushMind", 236340) -- Crush Mind
	self:Log("SPELL_AURA_APPLIED", "Wither", 236131) -- Wither
	self:Log("SPELL_AURA_APPLIED", "Soulbind", 236449) -- Soulbind
	self:Log("SPELL_AURA_REMOVED", "SoulbindRemoved", 236449) -- Soulbind
	self:Log("SPELL_CAST_SUCCESS", "WailingSouls", 236075) -- Wailing Souls
	-- Adds
	self:Log("SPELL_AURA_APPLIED", "ShatteringScream", 236515) -- Shattering Scream
	self:Log("SPELL_AURA_APPLIED", "SpiritChains", 236361) -- Spirit Chains

	-- Tormented Souls
	self:Log("SPELL_CAST_START", "SunderingDoom", 236542) -- Sundering Doom
	self:Log("SPELL_CAST_START", "DoomedSundering", 236544) -- Doomed Sundering
	self:Log("SPELL_AURA_APPLIED", "Torment", 236548) -- Torment
	self:Log("SPELL_AURA_APPLIED_DOSE", "Torment", 236548) -- Torment
end

function mod:OnEngage()
	self:OpenProximity(239006, 8) -- Dissonance
end

function mod:OnBossDisable()
	self:CloseProximity(239006) -- Dissonance
end
--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:Quietus(args)
	self:Message(args.spellId, "Important", "Warning")
	--self:CDBar(args.spellId, 30)
end

function mod:SpearofAnguish(args)
	self:TargetMessage(235933, args.destName, "Urgent", "Alarm", nil, nil, true)
	if self:Me(args.destGUID) then
		self:Say(235933)
	end
	--self:CDBar(235933, 30)
end

function mod:CollapsingFissure(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:CDBar(args.spellId, 30)
end

function mod:TormentedCriesApplied(args)
	self:TargetMessage(235989, args.destName, "Urgent", "Alarm")
	if self:Me(args.destGUID) then
		self:Say(235989)
	end
	--self:CDBar(235989, 30)
end

function mod:RupturingSlam(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:CDBar(args.spellId, 30)
end

function mod:GraspingDarkness(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:CDBar(args.spellId, 30)
end

function mod:BonecageArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alarm", nil, nil, true)
end

function mod:BonecageArmorRemoved(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Info", nil, nil, true)
end

function mod:CrushMind(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Attention", "Alert")
	end
	--self:CDBar(args.spellId, 30)
end

do
	local list = mod:NewTargetList()
	function mod:Soulbind(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Personal", "Warning")
		end
	end

	function mod:SoulbindRemoved(args)
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Positive", "Long", CL.removed:format(args.spellName))
		end
	end
end

function mod:WailingSouls(args)
	self:Message(args.spellId, "Important", "Warning")
	--self:CDBar(args.spellId, 30)
end

function mod:ShatteringScream(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:TargetBar(args.spellId, 6, args.destName)
		self:Say(args.spellId)
		self:ScheduleTimer("Say", 3, args.spellId, 3, true)
		self:ScheduleTimer("Say", 4, args.spellId, 2, true)
		self:ScheduleTimer("Say", 5, args.spellId, 1, true)
	else
		self:TargetMessage(args.spellId, args.destName, "Attention", "Info")
	end
end

function mod:SpiritChains(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
	end
end

function mod:SunderingDoom(args)
	self:Message(args.spellId, "Important", "Warning")
	--self:CDBar(args.spellId, 30)
end

function mod:DoomedSundering(args)
	self:Message(args.spellId, "Important", "Warning")
	--self:CDBar(args.spellId, 30)
end

function mod:Torment(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", "Info")
end
