--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aggramar", nil, 1984, 1712)
if not mod then return end
mod:RegisterEnableMob(121975)
mod.engageId = 2063
mod.respawnTime = 25

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local wakeOfFlameCount = 1
local comboTime = nil
local foeBreakerCount = 1
local flameRendCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",

		--[[ Stage One: Wrath of Aggramar ]]--
		{245990, "TANK"}, -- Taeshalach's Reach
		{245994, "SAY", "FLASH"}, -- Scorching Blaze
		{244693, "SAY"}, -- Wake of Flame
		244688, -- Taeshalach Technique
		245458, -- Foe Breaker
		245463, -- Flame Rend
		245301, -- Searing Tempest

		--[[ Stage Two: Champion of Sargeras ]]--
		245983, -- Flare

		--[[ Stage Three: The Avenger ]]--
		246037, -- Empowered Flare
	},{
		["stages"] = "general",
		[245990] = -15794, -- Stage One: wrath of Aggramar
		[245983] = -15858, -- Stage Two: Champion of Sargeras
		[246037] = -15860, -- Stage Three: The Avenger
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ Stage One: Wrath of Aggramar ]]--
	self:Log("SPELL_AURA_APPLIED", "TaeshalachsReach", 245990)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TaeshalachsReach", 245990)
	self:Log("SPELL_AURA_APPLIED", "ScorchingBlaze", 245994)
	self:Log("SPELL_CAST_START", "WakeofFlame", 244693)
	self:Log("SPELL_CAST_START", "FoeBreaker", 245458)
	self:Log("SPELL_CAST_START", "FlameRend", 245463)
	self:Log("SPELL_CAST_START", "SearingTempest", 245301)

	--[[ Intermission: Fires of Taeshalach ]]--
	self:Log("SPELL_AURA_APPLIED", "CorruptAegis", 244894)
	self:Log("SPELL_AURA_REMOVED", "CorruptAegisRemoved", 244894)
end

function mod:OnEngage()
	stage = 1
	wakeOfFlameCount = 1
	comboTime = GetTime() + 35
	foeBreakerCount = 1
	flameRendCount = 1

	self:Bar(244693, 5.5) -- Wake of Flame
	self:Bar(245994, 8) -- Scorching Blaze
	self:Bar(244688, 35) -- Taeshalach Technique
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 244688 then -- Taeshalach Technique
		foeBreakerCount = 1
		flameRendCount = 1
		comboTime = GetTime() + 60.8

		self:Bar(spellId, 60.8)
		self:Bar(245463, 4, CL.count:format(self:SpellName(244033), flameRendCount)) -- Flame Rend
		self:Bar(245301, 15.7) -- Searing Tempest
	elseif spellId == 245983 then -- Flare
		self:Message(spellId, "Important", "Warning")
		if comboTime < GetTime() + 15.8 then
			self:Bar(spellId, 15.8)
		end
	elseif spellId == 246037 then -- Empowered Flare
		self:Message(spellId, "Important", "Warning")
		if comboTime < GetTime() + 16.2 then
			self:Bar(spellId, 16.2)
		end
	end
end

--[[ Stage One: Wrath of Aggramar ]]--
function mod:TaeshalachsReach(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 7 then
		self:StackMessage(args.spellId, args.destName, amount, "Neutral", amount > 7 and "Info") -- Swap on 8+
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:ScorchingBlaze(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Warning")
			if comboTime < GetTime() + 7.3 then
				self:CDBar(args.spellId, 7.3)
			end
		end
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(244693, name, "Attention", "Alert", nil, nil, true)
		if self:Me(guid) then
			self:Say(244693)
		end
	end
	function mod:WakeofFlame(args)
		self:GetBossTarget(printTarget, 0.7, args.sourceGUID)
		wakeOfFlameCount = wakeOfFlameCount + 1
		if comboTime < GetTime() + 24 then
			self:Bar(args.spellId, 24)
		end
	end
end

function mod:FoeBreaker(args)
	self:Message(args.spellId, "Neutral", "Info", CL.count:format(args.spellName, foeBreakerCount))
	foeBreakerCount = foeBreakerCount + 1
	if foeBreakerCount == 2 then
		self:Bar(args.spellId, 7.5, CL.count:format(args.spellName, foeBreakerCount))
	end
end

function mod:FlameRend(args)
	self:Message(args.spellId, "Important", "Alarm", CL.count:format(args.spellName, flameRendCount))
	flameRendCount = flameRendCount + 1
	if flameRendCount == 2 then
		self:Bar(args.spellId, 7.5, CL.count:format(args.spellName, flameRendCount))
	end
end

function mod:SearingTempest(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CastBar(args.spellId, 6)

	-- Combo is almost over, start bars again
	self:Bar(245994, 13.5) -- Scorching Blaze
	if stage == 1 then
		self:Bar(244693, 14.7) -- Wake of Flame
	elseif stage == 2 then
		self:Bar(245983, 18.3) -- Flare
	elseif stage == 3 then
		self:Bar(246037, 18.3) -- Empowered Flare
	end
end

--[[ Intermission: Fires of Taeshalach ]]--
function mod:CorruptAegis()
	self:Message("stages", "Neutral", "Long", CL.intermission, false)
	self:StopBar(245994) -- Scorching Blaze
	self:StopBar(244693) -- Wake of Flame
	self:StopBar(244688) -- Taeshalach Technique
	self:StopBar(245458, CL.count:format(self:SpellName(245458), foeBreakerCount)) -- Foe Breaker
	self:StopBar(245463, CL.count:format(self:SpellName(245463), flameRendCount)) -- Flame Rend
	self:StopBar(245301) -- Searing Tempest
	self:StopBar(245983) -- Flare
end

function mod:CorruptAegisRemoved()
	stage = stage + 1
	self:Message("stages", "Neutral", "Long", CL.stage:format(stage), false)

	self:CDBar(245994, 6) -- Scorching Blaze
	self:Bar(244688, 37.5) -- Taeshalach Technique
	if stage == 2 then
		self:Bar(245983, 10.5) -- Flare
	elseif stage == 3 then
		self:Bar(246037, 10) -- Empowered Flare
	end
end
