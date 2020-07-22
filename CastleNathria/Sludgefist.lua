if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sludgefist", 2296, 2394)
if not mod then return end
mod:RegisterEnableMob(164407)
mod.engageId = 2399
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{331209, "SAY"}, -- Hateful Gaze
		331211, -- Heedless Charge
		331314, -- Stunned Impact
		{335491, "SAY"}, -- Chain Link
		332318, -- Destructive Stomp
		-- TODO: Falling Debris (USCS?)
		332687, -- Colossal Roar
		{335470, "SAY"}, -- Chain Slam
		-- TODO: Stonequake, slow+dmg on player - can be avoided?
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "HatefulGaze", 331209)
	self:Log("SPELL_CAST_SUCCESS", "HeedlessCharge", 331211)
	self:Log("SPELL_AURA_APPLIED", "StunnedImpact", 331314)
	self:Log("SPELL_CAST_SUCCESS", "ChainLink", 335292, 335468, 335779, 335491) -- one of those might work (placing my bet on USCS though)
	self:Log("SPELL_AURA_APPLIED", "ChainLinkApplied", 335293)
	self:Log("SPELL_CAST_START", "DestructiveStomp", 332318)
	self:Log("SPELL_CAST_SUCCESS", "ColossalRoar", 332687)
	self:Log("SPELL_AURA_APPLIED", "ChainSlam", 335470)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HatefulGaze(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)

	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end

	self:TargetBar(args.spellId, 6, args.destName)
end

function mod:HeedlessCharge(args)
	self:Message2(args.spellId, "red")
end

function mod:StunnedImpact(args)
	self:Message2(args.spellId, "red", CL.on:format(args.spellName, args.destName))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 12)
end

do
	local prev = 0

	function mod:ChainLink(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:TargetMessage2(335491, "orange", args.destName)
		end
	end
end

function mod:ChainLinkApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage2(335491, "blue", args.destName)
		self:PlaySound(335491, "alert")
		self:Say(335491)
	end
end

function mod:DestructiveStomp(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 4)
end

function mod:ColossalRoar(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
end

function mod:ChainSlam(args)
	if self:Me(args.destGUID) then
		self:TargetMessage2(335491, "blue", args.destName)
		self:PlaySound(335491, "long")
		self:Say(335491)
	end
end
