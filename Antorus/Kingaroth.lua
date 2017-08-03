if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kin'garoth", nil, 2004, 1712)
if not mod then return end
mod:RegisterEnableMob(122578, 125050) -- XXX Remove unused id's
mod.engageId = 2088
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage: Deployment ]]--
		{244312, "TANK"}, -- Forging Strike
		248475, -- Reverberating Strike
		246779, -- Diabolic Bomb
		246840, -- Ruiner
		248061, -- Cleansing Protocol
		248375, -- Shattering Strike

		--[[ Stage: Construction ]]--
		246516, -- Apocalypse Protocol
		246634, -- Apocalypse Blast
		246646, -- Flames of the Forge

		--[[ Adds ]]--
		246664, -- Annihilation
		{246686, "SAY"}, -- Decimation
		246706, -- Demolish
	},{
		[244312] = -16151, -- Stage: Deployment
		[246516] = -16152, -- Stage: Construction
		[246664] = CL.adds,
	}
end

function mod:OnBossEnable()
	--[[ Stage: Deployment ]]--
	self:Log("SPELL_CAST_SUCCESS", "ForgingStrike", 244312)
	self:Log("SPELL_CAST_START", "ReverberatingStrike", 248475)
	self:Log("SPELL_CAST_SUCCESS", "DiabolicBomb", 246779)
	self:Log("SPELL_CAST_SUCCESS", "Ruiner", 246840)
	self:Log("SPELL_CAST_SUCCESS", "CleansingProtocol", 248061)
	self:Log("SPELL_CAST_START", "ShatteringStrike", 248375)

	--[[ Stage: Construction ]]--
	self:Log("SPELL_AURA_APPLIED", "ApocalypseProtocol", 246516)
	self:Log("SPELL_CAST_SUCCESS", " ApocalypseBlast", 246634)
	self:Log("SPELL_CAST_SUCCESS", "FlamesoftheForge", 246646)

	--[[ Adds ]]--
	self:Log("SPELL_CAST_SUCCESS", "Annihilation", 246664)
	self:Log("SPELL_AURA_APPLIED", "Decimation", 246687)
	self:Log("SPELL_CAST_SUCCESS", "Demolish", 246706)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

	--[[ Stage: Deployment ]]--
function mod:ForgingStrike(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:ReverberatingStrike(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:DiabolicBomb(args)
	self:Message(args.spellId, "Important", "Warning")
end

function mod:Ruiner(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:CleansingProtocol(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:ShatteringStrike(args)
	self:Message(args.spellId, "Neutral", "Info")
end

	--[[ Stage: Construction ]]--
function mod:ApocalypseProtocol(args)
	self:Message(args.spellId, "Positive", "Long")
end

function mod:ApocalypseBlast(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:FlamesoftheForge(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CastBar(args.spellId, 40)
end

	--[[ Adds ]]--
function mod:Annihilation(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

do
	local playerList = mod:NewTargetList()
	function mod:Decimation(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm", nil, nil, true)
		end
	end
end

function mod:Demolish(args)
	self:Message(args.spellId, "Attention", "Alert")
end
