if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aggramar", nil, 1984, 1712)
if not mod then return end
mod:RegisterEnableMob(124691)
mod.engageId = 2063
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One: Wrath of Aggramar ]]--
		{245990, "TANK"}, -- Taeshalach's Reach
		{245995, "SAY", "FLASH"}, -- Scorching Blaze
		244693, -- Wake of Flame
		244291, -- Foe Breaker
		244033, -- Flame Rend
		246014, -- Searing Tempest

		--[[ Intermission: Fires of Taeshalach ]]--
		244894, -- Corrupt Aegis

		--[[ Stage Two: Champion of Sargeras ]]--
		245983, -- Flare

		--[[ Stage Three: The Avenger ]]--
		246037, -- Empowered Flare
	},{
		[245990] = -15794, -- Stage One: wrath of Aggramar
		[244894] = -15795, -- Intermission: Fires of Taeshalach
		[245983] = -15858, -- Stage Two: Champion of Sargeras
		--[000000] = -15859, -- Intermission: Taeshalach's Rage
		[246037] = -15860, -- Stage Three: The Avenger
	}
end

function mod:OnBossEnable()
	--[[ Stage One: Wrath of Aggramar ]]--
	self:Log("SPELL_AURA_APPLIED", "TaeshalachsReach", 245990)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TaeshalachsReach", 245990)
	self:Log("SPELL_AURA_APPLIED", "ScorchingBlaze", 245995)
	self:Log("SPELL_CAST_START", "WakeofFlame", 244693)
	self:Log("SPELL_CAST_SUCCESS", "FoeBreaker", 244291)
	self:Log("SPELL_CAST_SUCCESS", "FlameRend", 244033)
	self:Log("SPELL_CAST_SUCCESS", "SearingTempest", 246014)

	--[[ Intermission: Fires of Taeshalach ]]--
	self:Log("SPELL_AURA_APPLIED", "CorruptAegis", 244894)
	self:Log("SPELL_AURA_REMOVED", "CorruptAegisRemoved", 244894)

	--[[ Stage Two: Champion of Sargeras ]]--
	self:Log("SPELL_CAST_SUCCESS", "Flare", 245983)

	--[[ Stage Three: The Avenger ]]--
	self:Log("SPELL_CAST_SUCCESS", "EmpoweredFlare", 246037)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Stage One: Wrath of Aggramar ]]--
function mod:TaeshalachsReach(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 4 and "Alarm") -- Swap on 5?
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
		end
	end
end

function mod:WakeofFlame(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
end

function mod:FoeBreaker(args)
	self:Message(args.spellId, "Neutral", "Info")
end

function mod:FlameRend(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:SearingTempest(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

--[[ Intermission: Fires of Taeshalach ]]--
function mod:CorruptAegis(args)
	self:Message(args.spellId, "Positive", "Long")
end

function mod:CorruptAegisRemoved(args)
	self:Message(args.spellId, "Neutral", "Info", CL.removed:format(args.spellName))
end

--[[ Stage Two: Champion of Sargeras ]]--
function mod:Flare(args)
	self:Message(args.spellId, "Important", "Warning")
end

--[[ Stage Three: The Avenger ]]--
function mod:EmpoweredFlare(args)
	self:Message(args.spellId, "Important", "Warning")
end
