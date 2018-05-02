--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fetid Devourer", 1861, 2146)
if not mod then return end
mod:RegisterEnableMob(133298)
mod.engageId = 2128
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{262256, "TANK"}, -- Thrashing Terror
		262291, -- Rotting Regurgitation
		262288, -- Shockwave Stomp
		262313, -- Malodorous Miasma
		{262314, "PULSE"}, -- Deadly Disease
		262364, -- Enticing Essence
		262378, -- Fetid Frenzy
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ThrashingTerror", 262256)
	self:Log("SPELL_CAST_SUCCESS", "RottingRegurgitation", 262291)
	self:Log("SPELL_CAST_START", "ShockwaveStomp", 262288)
	self:Log("SPELL_AURA_APPLIED", "MalodorousMiasmaApplied", 262313)
	self:Log("SPELL_AURA_APPLIED", "DeadlyDiseaseApplied", 262314)
	self:Log("SPELL_CAST_START", "EnticingEssence", 262364)
	self:Log("SPELL_AURA_APPLIED", "FetidFrenzy", 262378)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ThrashingTerror(args)
	self:Message(args.spellId, "red", nil, CL.soon:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
end

function mod:RottingRegurgitation(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ShockwaveStomp(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

do
	local playerList = mod:NewTargetList()
	function mod:MalodorousMiasmaApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning", nil, playerList)
		self:TargetsMessage(args.spellId, "orange", playerList)
	end
end

function mod:DeadlyDiseaseApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:PlaySound(args.spellId, "warning")
		self:Flash(args.spellId)
	end
end

function mod:EnticingEssence(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

function mod:FetidFrenzy(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end
