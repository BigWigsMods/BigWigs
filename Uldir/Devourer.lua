if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

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
		{262277, "TANK"}, -- Thrashing Terror
		262292, -- Rotting Regurgitation
		262288, -- Shockwave Stomp
		{262313, "ME_ONLY"}, -- Malodorous Miasma
		{262314, "ME_ONLY", "PULSE"}, -- Putrid Paroxysm
		262364, -- Enticing Essence -- XXX Used for CL.adds right now
		262378, -- Fetid Frenzy
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TerribleThrash", 262277)
	self:Log("SPELL_CAST_START", "RottingRegurgitation", 262292)
	self:Log("SPELL_CAST_START", "ShockwaveStomp", 262288)
	self:Log("SPELL_AURA_APPLIED", "MalodorousMiasmaApplied", 262313)
	self:Log("SPELL_AURA_APPLIED", "PutridParoxysmApplied", 262314)
	self:Log("SPELL_CAST_START", "EnticingEssence", 262364)
	self:Log("SPELL_AURA_APPLIED", "FetidFrenzy", 262378)

	-- Trash spawning
	self:Log("SPELL_CAST_SUCCESS", "TrashChuteVisualState", 274470)
end

function mod:OnEngage()
	self:CDBar(262277, 5.5) -- Terrible Thrash
	self:CDBar(262292, 41.5) -- Rotting Regurgitation
	self:Bar(262288, 26) -- Shockwave Stomp
	self:Bar(262364, 35.5, CL.adds) -- Shockwave Stomp
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TerribleThrash(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 6)
end

function mod:RottingRegurgitation(args)
	self:Message(args.spellId, "yellow", nil, CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 46) -- 41.3, 52.1, 46.3, 41.9, 32.6, 34.1 XXX
	self:CastBar(args.spellId, 6.5)
end

function mod:ShockwaveStomp(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 30)
end

function mod:MalodorousMiasmaApplied(args)
	self:TargetMessage2(args.spellId, "orange", args.destName)
	self:PlaySound(args.spellId, "info", nil, args.destName)
end

function mod:PutridParoxysmApplied(args)
	self:TargetMessage2(args.spellId, "blue", args.destName)
	self:PlaySound(args.spellId, "warning", nil, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

do
	local prev = 0
function mod:EnticingEssence(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:FetidFrenzy(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

do
	local prev = 0
	function mod:TrashChuteVisualState(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(262364, "cyan", nil, CL.incoming:format(CL.adds))
			self:PlaySound(262364, "long")
			self:Bar(262364, 55, CL.adds)
		end
	end
end
