if not IsTestBuild() then return end
if UnitFactionGroup("player") ~= "Alliance" then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ra'wani Kanae", 2070, 2344)
if not mod then return end
mod:RegisterEnableMob(144683)
mod.engageId = 2265
mod.respawnTime = 15 -- PTR

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{283573, "TANK"}, -- Sacred Blade
		283598, -- Wave of Light
		284469, -- Seal of Retribution
		283933, -- Judgement: Righteousness
		284436, -- Seal of Reckoning
		284474, -- Judgement: Reckoning
		283662, -- Call to Arms
		282113, -- Avenging Wrath
		284595, -- Penance
		283628, -- Heal
		283650, -- Blinding Faith
		-- Mythic
		287469, -- Prayer for the Fallen
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "SacredBladeApplied", 283573)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SacredBladeApplied", 283573)
	self:Log("SPELL_CAST_START", "WaveofLight", 283598)
	self:Log("SPELL_AURA_APPLIED", "SealofRetributionApplied", 284469)
	self:Log("SPELL_CAST_START", "JudgementRighteousness", 283933)
	self:Log("SPELL_AURA_APPLIED", "SealofReckoning", 284436)
	self:Log("SPELL_CAST_START", "JudgmentReckoning", 284474)
	self:Log("SPELL_CAST_START", "CalltoArms", 283662)
	self:Log("SPELL_AURA_APPLIED", "AvengingWrathApplied", 282113)
	self:Log("SPELL_CAST_START", "Penance", 284595)
	self:Log("SPELL_CAST_START", "Heal", 283628)
	self:Log("SPELL_CAST_START", "BlindingFaith", 283650)

	-- Mythic
	self:Log("SPELL_CAST_START", "PrayerfortheFallen", 287469)
end

function mod:OnEngage()
	self:CDBar(283650, 12) -- Blinding Faith
	self:Bar(283598, 13) -- Wave of Light
	self:CDBar(283662, 109) -- Call to Arms
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SacredBladeApplied(args)
	local amount = args.amount or 1
	if amount > 6 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:WaveofLight(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 11)
end

function mod:SealofRetributionApplied(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(283933, 51) -- Judgement: Righteousness
end

function mod:JudgementRighteousness(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:SealofReckoning(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(284474, 51) -- Judgement: Reckoning
end

function mod:JudgmentReckoning(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:CalltoArms(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 105)
end

function mod:AvengingWrathApplied(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:Penance(args)
	if self:Interrupter() then
		self:Message2(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:Heal(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message2(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:BlindingFaith(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 4)
	self:CDBar(args.spellId, 15)
end

function mod:PrayerfortheFallen(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end