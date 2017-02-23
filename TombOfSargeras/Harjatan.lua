if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Harjatan the Bludger", 1147, 1856)
if not mod then return end
mod:RegisterEnableMob(116407)
mod.engageId = 2036
mod.respawnTime = 30

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
		{231998, "TANK"}, -- Jagged Abrasion
		231854, -- Unchecked Rage
		232192, -- Commanding Roar
		232061, -- Draw In
		233429, -- Frigid Blows
		232174, -- Frosty Discharge
		{231729, "SAY", "FLASH"}, -- Aqueous Burst
		231904, -- Tend Wounds
		{234128, "SAY", "FLASH"}, -- Driven Assault
		240319, -- Hatching
	},{
		[231998] = "general",
		[231729] = -14555,
		[234128] = -14722,
		[240319] = "mythic",
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")

	-- Boss
	self:Log("SPELL_AURA_APPLIED", "JaggedAbrasion", 231998)
	self:Log("SPELL_AURA_APPLIED_DOSE", "JaggedAbrasion", 231998)
	self:Log("SPELL_CAST_START", "UncheckedRage", 231854)
	self:Log("SPELL_CAST_SUCCESS", "DrawIn", 232061)
	self:Log("SPELL_AURA_REMOVED_DOSE", "FrigidBlows", 233429)
	self:Log("SPELL_CAST_START", "FrostyDischarge", 232174)

	-- Adds
	self:Log("SPELL_AURA_APPLIED", "AqueousBurst", 231729)
	self:Log("SPELL_CAST_START", "TendWounds", 231904)
	self:Log("SPELL_AURA_APPLIED", "DrivenAssault", 234016)
	self:Log("SPELL_AURA_REMOVED", "DrivenAssaultRemoved", 234016)

	-- Mythic
	self:Log("SPELL_CAST_START", "Hatching", 240319)
end

function mod:OnEngage()
	self:Bar(232192, 17.5)	-- Commanding Roar
	self:Bar(231854, 21) -- Unchecked Rage
	self:Bar(232061, 60) -- Draw In
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 232192 then -- Commanding Roar
		self:Message(spellId, "Important", "Alert", spellName)
		if self:BarTimeLeft(232061) > 32.8 then -- Draw In
			self:Bar(spellId, 32.8)
		end
	end
end

function mod:JaggedAbrasion(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Warning") -- Swap on 4
end

function mod:UncheckedRage(args)
	self:Message(args.spellId, "Attention", "Warning")
	if self:BarTimeLeft(232061) > 20.5 then -- Draw In
		self:Bar(args.spellId, 20.5)
	end
end

function mod:DrawIn(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 10, CL.casting:format(args.spellName))
end

function mod:FrigidBlows(args)
	local amount = args.amount or 1
	if amount < 4 then -- Start warnings last 3 stacks
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount < 2 and "Alert") -- Add sound on last stack
	end
end

function mod:FrostyDischarge(args)
	self:Message(args.spellId, "Urgent", "Warning", args.spellName)
	self:Bar(232192, 18.2)	-- Commanding Roar
	self:Bar(231854, 21.4) -- Unchecked Rage
	self:Bar(232061, 60) -- Draw In
end

do
	local playerList = mod:NewTargetList()
	function mod:AqueousBurst(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end
end

function mod:TendWounds(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Important", "Warning")
	end
end

do
	local playerList = mod:NewTargetList(), nil
	function mod:DrivenAssault(args)
		if self:Me(args.destGUID) then
			self:AddPlate(234128, args.sourceGUID, 10, true) -- Show the target that is fixating on you more clear
			self:Flash(234128)
			self:Say(234128)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 234128, playerList, "Important", "Alarm")
		end
	end
	function mod:DrivenAssaultRemoved(args)
		if self:Me(args.destGUID) then
			self:RemovePlate(234128, args.sourceGUID, true) -- Clear fixate plate incase it's removed early
		end
	end
end

function mod:Hatching(args)
	self:Message(args.spellId, "Important", "Long")
end
