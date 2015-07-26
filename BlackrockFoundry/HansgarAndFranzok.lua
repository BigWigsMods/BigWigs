
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hans'gar and Franzok", 988, 1155)
if not mod then return end
mod:RegisterEnableMob(76973, 76974) -- Hans'gar, Franzok
mod.engageId = 1693
--mod.respawnTime = 30 -- 27-30 standard 30 when reset during stampers, shorter otherwise?

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local stamperWarned = nil

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		162124, -- Smart Stampers
		--[[ General ]]--
		160838, -- Disrupting Roar
		{153470, "HEALER"}, -- Skullcracker
		{156938, "TANK_HEALER", "FLASH"}, -- Crippling Suplex
		157139, -- Shattered Vertebrae
		{155818, "FLASH"}, -- Scorching Burns
		{155747, "SAY"}, -- Body Slam
		"stages",
		--"berserk",
	}, {
		[162124] = "mythic",
		[160838] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CripplingSuplex", 156938)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatteredVertebrae", 157139)
	-- Franzok
	self:Log("SPELL_CAST_START", "DisruptingRoar", 160838, 160845, 160847, 160848)
	self:Log("SPELL_CAST_START", "Skullcracker", 153470)
	-- Environmental Threats
	self:Log("SPELL_AURA_APPLIED", "ScorchingBurnsDamage", 155818)
	self:Log("SPELL_PERIODIC_DAMAGE", "ScorchingBurnsDamage", 155818)
	self:Log("SPELL_PERIODIC_MISSED", "ScorchingBurnsDamage", 155818)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:Log("SPELL_AURA_APPLIED", "SmartStampers", 162124)
	self:Log("SPELL_AURA_REMOVED", "SmartStampersRemoved", 162124)
end

function mod:OnEngage()
	phase = 1
	stamperWarned = nil
	self:CDBar(153470, 20) -- Skullcracker
	self:CDBar(160838, 45) -- Disrupting Roar
	if self:Mythic() then
		self:Bar(162124, 13) -- Smart Stampers
	end

	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", "Jumps", "boss1", "boss2")
	self:RegisterUnitEvent("UNIT_TARGET", "BodySlamTarget", "boss1", "boss2")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SmartStampers(args)
	if not stamperWarned then
		stamperWarned = true
		self:Message(args.spellId, "Neutral", "Alert")
	end
end

function mod:SmartStampersRemoved(args)
	if stamperWarned then
		stamperWarned = nil
		self:Message(args.spellId, "Neutral", "Alert", CL.over:format(args.spellName))
	end
end

-- Phase fuckery
do
	local phaseThreats = {
		mod:SpellName(161570), -- Searing Plates (Hans'gar leaves)
		mod:SpellName(158139), -- Stamping Presses (Franzok leaves)
		mod:SpellName(161570), -- Searing Plates (Hans'gar leaves)
		--mod:SpellName(158139), -- Stamping Presses (Hans'gar returns)
	}

	function mod:JumpAway(unit)
		self:Message("stages", "Neutral", "Info", phaseThreats[phase], false)
		if self:MobId(UnitGUID(unit)) == 76974 then -- Franzok
			self:StopBar(153470) -- Skullcracker
			self:StopBar(160838) -- Disrupting Roar
		end
	end

	function mod:Jumps(unit)
		if UnitExists(unit) then -- jumped back
			if phase < 3 then
				self:Message("stages", "Neutral", "Info", CL.over:format(phaseThreats[phase]), false)
				phase = phase + 1
				--self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "Phases", "boss1")
				--[[
				-- paused? cds are all over the place when he comes back
				if self:MobId(UnitGUID(unit)) == 76974 then -- Franzok
					self:CDBar(153470, 21) -- Skullcracker
					self:CDBar(160838, 46) -- Disrupting Roar
				end
				--]]
				if self:Mythic() then
					self:Bar(162124, 13) -- Smart Stampers
				end
			else
				-- phase 3, Searing while Hans'gar is up, then Stamping when he jumps back down
				self:Message("stages", "Neutral", "Info", CL.soon:format(self:SpellName(158139)), false) -- Stamping Presses
			end
		elseif self:MobId(UnitGUID(unit)) == 76974 then -- Franzok jumped away (doesn't Tactical Retreat anymore?)
			self:Message("stages", "Neutral", "Info", phaseThreats[phase], false)
			if self:MobId(UnitGUID(unit)) == 76974 then -- Franzok
				self:StopBar(153470) -- Skullcracker
				self:StopBar(160838) -- Disrupting Roar
			end
		end
	end
end

function mod:BodySlamTarget(unit)
	local target = unit.."target"
	local guid = UnitGUID(target)
	if not guid or UnitDetailedThreatSituation(target, unit) ~= false or self:MobId(guid) ~= 1 then return end

	if self:Me(guid) then
		self:Say(155747)
	elseif self:Range(target) < 10 then
		self:RangeMessage(155747)
		return
	end
	self:TargetMessage(155747, self:UnitName(target), "Attention", "Alarm")
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 156220 then -- Tactical Retreat (Hans'gar jumped away)
		self:JumpAway(unit)
	elseif spellId == 156546 or spellId == 156542 then -- Crippling Suplex (tank picked up)
		self:Message(156938, "Important", "Alarm", CL.soon:format(spellName))
	end
end

function mod:CripplingSuplex(args)
	self:Message(args.spellId, self:Tank() and "Personal" or "Important", "Warning", CL.casting:format(args.spellName))
	self:Flash(args.spellId)
	self:Bar(args.spellId, 3)
end

function mod:ShatteredVertebrae(args)
	if (self:Tank() or self:Healer()) and self:Tank(args.destName) then
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end

function mod:DisruptingRoar(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if unit then
		local _, _, _, _, _, endTime = UnitCastingInfo(unit)
		local cast = endTime and (endTime / 1000 - GetTime()) or 0
		if cast > 1 then
			self:Bar(args.spellId, cast, CL.cast:format(args.spellName))
		end
	end

	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	if self:Ranged() then
		self:PlaySound(args.spellId, "Long")
		self:Flash(args.spellId)
	end
	self:CDBar(args.spellId, 46)
end

function mod:Skullcracker(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 21) -- 21-26
end

do
	local prev = 0
	function mod:ScorchingBurnsDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

