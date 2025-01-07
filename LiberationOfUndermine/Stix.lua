if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Stix Bunkjunker", 2769, 2642)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(3012)
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
		464399, -- Electromagnetic Sorting
			461536, -- Rolling Rubbish
				-- 465741, -- Garbage Dump XXX Can we warn how much health someone removed? for fun.
				-- 1217685, -- Messed Up
				-- 465611, -- Rolled! XXX Warn who rolled over you?
			464854, -- Garbage Pile
			-- 464865, -- Discarded Doomsplosive XXX Warn when spawned, and when absorbed?
				1217975, -- Doomsploded
				-- 465747, -- Muffled Doomsplosion
			-- Territorial Bombshell XXX Warn how many are up and left to destroy/kill?
		466849, -- Cleanup Crew XXX Fix tooltip if used?
			-- Scrapmaster
			1219384, -- Scrap Rockets
			-- 466742, -- Dumpster Dive
			-- Junkyard Hyena
			466748, -- Infected Bite
		464149, -- Incinerator
			{472893, "SAY"}, -- Incineration
			464248, -- Hot Garbage
				1218343, -- Toxic Fumes
		464112, -- Demolish
		-- 1217954, -- Meltdown XXX is this an cooldown ability or it's auto attack?
		467117, -- Overdrive
			-- 467149, -- Overcharged Bolt
			467135, -- Trash Compactor
			-- 473227, -- Maximum Output
	},{ -- Sections

	},{ -- Renames

	}
end

function mod:OnRegister()
	--self:SetSpellRename(999999, CL.renameMe) -- Spell (Rename)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ElectromagneticSorting", 464399)
	self:Log("SPELL_AURA_APPLIED", "RollingRubbish", 461536)
	self:Log("SPELL_AURA_APPLIED", "Doomsploded", 1217975)
	self:Log("SPELL_CAST_SUCCESS", "CleanupCrew", 466849)
	self:Log("SPELL_CAST_SUCCESS", "ScrapRockets", 1219384)
	self:Log("SPELL_AURA_APPLIED", "InfectedBiteApplied", 466748)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfectedBiteApplied", 466748)
	self:Log("SPELL_CAST_SUCCESS", "Incinerator", 464149)
	self:Log("SPELL_AURA_APPLIED", "IncinerationApplied", 472893)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ToxicFumesApplied", 1218343)
	self:Log("SPELL_CAST_START", "Demolish", 464112)
	self:Log("SPELL_AURA_APPLIED", "DemolishApplied", 464112)
	self:Log("SPELL_CAST_START", "Overdrive", 467117)
	self:Log("SPELL_CAST_SUCCESS", "TrashCompactor", 467135)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 464854, 464248) -- Garbage Pile, Hot Garbage
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 464854, 464248)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 464854, 464248)
end

function mod:OnEngage()
	-- self:Bar(464399, 10) -- Electromagnetic Sorting
	-- self:Bar(466849, 20) -- Cleanup Crew
	-- self:Bar(464149, 30) -- Incinerator
	-- self:Bar(464112, 40) -- Demolish
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ElectromagneticSorting(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "long") -- damage and garbage over 5 seconds
	-- self:Bar(args.spellId, 10)
end

function mod:RollingRubbish(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info") -- you're rubbish
	end
end

do
	local prev = 0
	function mod:Doomsploded(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:CleanupCrew(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info") -- adds inc
	-- self:Bar(args.spellId, 10)
end

function mod:ScrapRockets(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:InfectedBiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:Incinerator(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- debuffs inc
	-- self:Bar(args.spellId, 10)
end

function mod:IncinerationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- watch surrouding
		self:Say(args.spellId, nil, nil, "Incineration")
	end
end

function mod:ToxicFumesApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 6)
			if amount > 5 then
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:Demolish(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
	-- self:Bar(args.spellId, 25)
end

function mod:DemolishApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:Overdrive(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- final stage inc
	-- self:Bar(args.spellId, 10)
end

function mod:TrashCompactor(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "warning") -- watch drop location
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
