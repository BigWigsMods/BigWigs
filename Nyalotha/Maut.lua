--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Maut", 2217, 2365)
if not mod then return end
mod:RegisterEnableMob(156523) -- Maut
mod.engageId = 2327
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.stage2_over = "Stage 2 Over - %.1f sec"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage 1
		{310129, "TANK"}, -- Shadow Claws
		{308872, "TANK"}, -- Dark Offering
		{307806, "SAY", "SAY_COUNTDOWN"}, -- Devour Magic
		307586, -- Devoured Abyss
		308044, -- Stygian Annihilation
		308903, -- Dark Manifestation
		305663, -- Black Wings
		{314337, "FLASH"}, -- Ancient Curse
		-- Stage 2
		305722, -- Obsidian Destruction
		{314993, "SAY"}, -- Drain Essence
	}, {
		[310129] = CL.stage:format(1),
		[314337] = CL.mythic,
		[305722] = CL.stage:format(2),
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "ShadowClaws", 310129)
	self:Log("SPELL_AURA_APPLIED", "ShadowWounds", 307399)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowWounds", 307399)
	self:Log("SPELL_CAST_START", "DarkOffering", 308872)
	self:Log("SPELL_AURA_APPLIED", "DevourMagic", 307806)
	self:Log("SPELL_CAST_START", "StygianAnnihilationStart", 308044)
	self:Log("SPELL_CAST_SUCCESS", "StygianAnnihilationSuccess", 308044)
	self:Log("SPELL_CAST_START", "DarkManifestation", 308903)
	self:Log("SPELL_CAST_START", "BlackWings", 305663)
	--- Mythic
	self:Log("SPELL_CAST_START", "AncientCurse", 314337)
	self:Log("SPELL_AURA_REMOVED", "AncientCurseRemoved", 315025)

	-- Stage 2
	self:Log("SPELL_CAST_START", "ObsidianDestruction", 305722)
	self:Log("SPELL_AURA_APPLIED", "ObsidianDestructionApplied", 305722)
	self:Log("SPELL_AURA_REMOVED", "ObsidianDestructionRemoved", 305722)
	self:Log("SPELL_AURA_APPLIED", "DrainEssence", 314993)
end

function mod:OnEngage()
	self:CDBar(310129, 8) -- Shadow Claws
	self:CDBar(307806, 9) -- Devour Magic
	self:CDBar(308903, 13) -- Dark Manifestation
	self:CDBar(305663, 20) -- Black Wings
	self:CDBar(308044, 41) -- Stygian Annihilation
	if self:Mythic() then
		self:CDBar(314337, 18) -- Ancient Curse
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1
function mod:ShadowClaws(args)
	self:CDBar(args.spellId, 12.2)
end

function mod:ShadowWounds(args)
	local amount = args.amount or 1
	self:StackMessage(310129, args.destName, amount, "purple")
	if amount > 1 then
		self:PlaySound(310129, "alarm", nil, args.destName)
	end
end

function mod:DarkOffering(args)
	self:Message2(args.spellId, "purple") -- XXX only show for tank of target?
	self:PlaySound(args.spellId, "alarm")
end

function mod:DevourMagic(args)
	self:Bar(args.spellId, 24.3)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:Say(args.spellId)
		self:TargetBar(args.spellId, 6, args.destName)
		self:SayCountdown(args.spellId, 6)
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end

do
	local devouredAbyss, devouredAbyssCheck = mod:SpellName(307586), nil

	local function checkForDevouredAbyss(self)
		if UnitIsDead("player") then
			-- Nothing
		elseif not self:UnitDebuff("player", 307586) then -- Devoured Abyss
			self:Message2(307586, "blue", CL.no:format(devouredAbyss))
			self:PlaySound(307586, "warning")
			devouredAbyssCheck = self:ScheduleTimer(checkForDevouredAbyss, 1.5, self)
		else
			self:Message2(307586, "green", CL.you:format(devouredAbyss))
		end
		devouredAbyssCheck = nil
	end

	function mod:StygianAnnihilationStart(args)
		self:Message2(args.spellId, "red")
		self:PlaySound(args.spellId, "long")
		self:CastBar(args.spellId, 5)
		if not devouredAbyssCheck then
			devouredAbyssCheck = self:ScheduleTimer(checkForDevouredAbyss, 2.5, self)
		end
	end

	function mod:StygianAnnihilationSuccess(args)
		if devouredAbyssCheck then
			self:CancelTimer(devouredAbyssCheck)
			devouredAbyssCheck = nil
		end
	end
end


function mod:DarkManifestation(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 35.3)
end

function mod:BlackWings(args)
	self:Message2(args.spellId, "orange")
	--self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 30.4)
end

--- Mythic
function mod:AncientCurse(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 50)
end

function mod:AncientCurseRemoved(args)
	if self:Me(args.destGUID) then
		self:Message2(314337, "green", CL.removed:format(args.spellName))
		self:PlaySound(314337, "info")
	end
end

-- Stage 2
function mod:ObsidianDestruction(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:StopBar(305663) -- Black Wings
	self:StopBar(310129) -- Shadow Claws
	self:StopBar(307806) -- Devour Magic
	self:StopBar(308903) -- Dark Manifestation
	--self:StopBar(308044) -- Stygian Annihilation
	if self:Mythic() then
		self:StopBar(314337) -- Ancient Curse
	end
end

do
	local prev = 0
	function mod:ObsidianDestructionApplied(args)
		prev = args.time
		self:CastBar(args.spellId, 60)
	end

	function mod:ObsidianDestructionRemoved(args)
		self:Message2(args.spellId, "cyan", L.stage2_over:format(args.time-prev))
		self:PlaySound(args.spellId, "long")
		self:StopBar(314993) -- Drain Essence
		self:CDBar(310129, 7) -- Shadow Claws
		self:CDBar(307806, 11.6) -- Devour Magic
		self:CDBar(308903, 12.1) -- Dark Manifestation
		self:CDBar(305663, 19.4) -- Black Wings
		self:CDBar(308044, 40) -- Stygian Annihilation
		if self:Mythic() then
			self:CDBar(314337, 18) -- Ancient Curse
		end
	end
end

function mod:DrainEssence(args)
	self:CDBar(args.spellId, 13.3)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:Say(args.spellId)
		--self:TargetBar(args.spellId, 6, args.destName)
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end
