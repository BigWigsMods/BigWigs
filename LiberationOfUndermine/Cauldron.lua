if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Cauldron of Carnage", 2769, 2640)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(3010)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then
-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		465833, -- Colossal Clash
			-- 463800, -- Zapbolt
			-- 465446, -- Fiery Wave
		471660, -- Raised Guard
		471557, -- King of Carnage
		-- Flarendo the Furious
		472222, -- Blistering Spite
		473650, -- Scrapbomb
			{1213690, "SAY_COUNTDOWN"}, -- Molten Phlegm
				1214039, -- Molten Pool
					-- 465446, -- Fiery Waves
		{472231, "SAY"}, -- Blastburn Roarcannon
		1214190, -- Eruption Stomp
		-- Torq the Tempest
		472223, -- Galvanized Spite
		473951, -- Static Charge
			-- 473983, -- Static Discharge
		463840, -- Thunderdrum Salvo
		1213994, -- Voltaic Image
			463925, -- Lingering Electricity
		466178, -- Lightning Bash
			-- 1217933, -- Overload Burst
	},{ -- Sections

	},{ -- Renames

	}
end

function mod:OnRegister()
	--self:SetSpellRename(1214009, CL.renameMe) -- Spell (Rename)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ColossalClash", 465833)
	self:Log("SPELL_AURA_APPLIED", "RaisedGuardApplied", 471660)
	self:Log("SPELL_AURA_APPLIED", "KingOfCarnageApplied", 471557)
	self:Log("SPELL_AURA_APPLIED_DOSE", "KingOfCarnageApplied", 471557)

	-- Flarendo the Furious
	self:Log("SPELL_AURA_APPLIED", "BlisteringSpiteApplied", 472222)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlisteringSpiteApplied", 472222)
	self:Log("SPELL_CAST_START", "Scrapbomb", 473650)
	self:Log("SPELL_AURA_APPLIED", "MoltenPhlegmApplied", 1213690)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenPhlegmApplied", 1213690) -- XXX Stacks or refreshes?
	self:Log("SPELL_AURA_APPLIED", "BlastburnRoarcannonApplied", 472231)
	self:Log("SPELL_CAST_START", "EruptionStomp", 1214190)

	-- Torq the Tempest
	self:Log("SPELL_AURA_APPLIED", "GalvanizedSpiteApplied", 472223)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GalvanizedSpiteApplied", 472223)
	self:Log("SPELL_AURA_APPLIED", "StaticChargeApplied", 473951)
	self:Log("SPELL_CAST_START", "ThunderdrumSalvo", 463840)
	self:Log("SPELL_AURA_APPLIED", "ThunderdrumSalvoApplied", 463840)
	self:Log("SPELL_CAST_SUCCESS", "VoltaicImage", 1213994)
	self:Log("SPELL_AURA_APPLIED", "VoltaicImageFixateApplied", 1214009)
	self:Log("SPELL_CAST_START", "LightningBash", 466178)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 1214039, 463925) -- Molten Pool, Lingering Electricity
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 1214039, 463925)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 1214039, 463925)
end

function mod:OnEngage()
	-- self:Bar(473650, 20) -- Scrapbomb
	-- self:Bar(465833, 90) -- Colossal Clash
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ColossalClash(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long") -- 20s clash
	-- self:Bar(args.spellId, 110)
end

do
	local prev = 0
	function mod:RaisedGuardApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:KingOfCarnageApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "cyan", args.destName, amount, 1)
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 10, CL.count:format(args.spellName, amount + 1))
end

-- Flarendo the Furious
function mod:BlisteringSpiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		local tooHigh = 15 -- XXX finetune
		if amount % 2 == 1 or amount >= tooHigh then
			self:StackMessage(args.spellId, "blue", args.destName, amount, tooHigh)
			if amount >= tooHigh then
				self:PlaySound(args.spellId, "alarm") -- too many stacks
			end
		end
	end
end

function mod:Scrapbomb(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- soak bombs
	-- self:Bar(args.spellId, 110)
end

function mod:MoltenPhlegmApplied(args)
	if self:Me(args.destGUID) then
		self:StopSayCountdown(args.spellId) -- restart
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:SayCountdown(args.spellId, 30)
	end
end

do
	local prev = 0
	function mod:BlastburnRoarcannonApplied(args)
		if args.time - prev > 2 then -- 3 targets in Mythic
			prev = args.time
			self:Message(args.spellId, "yellow")
			-- self:Bar(args.spellId, 30)
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId, nil, nil, "Blastburn Roarcannon")
		end
	end
end

function mod:EruptionStomp(args)
	self:Message(args.spellId, "purple")
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	-- self:Bar(args.spellId, 30)
end

-- Torq the Tempest

function mod:GalvanizedSpiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		local tooHigh = 15 -- XXX finetune
		if amount % 2 == 1 or amount >= tooHigh then
			self:StackMessage(args.spellId, "blue", args.destName, amount, tooHigh)
			if amount >= tooHigh then
				self:PlaySound(args.spellId, "alarm") -- too many stacks
			end
		end
	end
end

function mod:StaticChargeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info") -- watch steps
		-- XXX track charge and warn when high?
	end
end

function mod:ThunderdrumSalvo(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	-- self:Bar(args.spellId, 30)
end

function mod:ThunderdrumSalvoApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		-- XXX Say / Countdown?
	end
end

function mod:VoltaicImage(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	-- self:Bar(args.spellId, 30)
end

function mod:VoltaicImageFixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1213994, nil, CL.fixate)
		self:PlaySound(1213994, "alarm")
	end
end

function mod:LightningBash(args)
	self:Message(args.spellId, "purple")
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	-- self:Bar(args.spellId, 30)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
