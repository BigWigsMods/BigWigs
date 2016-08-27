-- TO DO LIST
-- 1)Check Cast-Succeed Buff Rotation Timers on combat
-- 2)could potentially add Icy comet Spell id as 3rd else if statement
-- Module Declaration
--
local mod, CL = BigWigs:NewBoss("Calamir", -1015, 1774)
if not mod then return end

mod:RegisterEnableMob(109331)
mod.otherMenu = 1007
mod.worldBoss = 109331
--------------------------------------------------------------------------------
-- Locals
--
local bBomb = 1
local hGale = 1
local aDesolation = 1
--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		--FIRE PHASE--
		217563,	--Ancient Rage Fire
		{217887, "SAY", "PROXIMITY"}, -- Burning Bomb
		217893, -- Wrathful Flames
		--ARCANE PHASE--
		217834, --Ancient Rage Arcane
		217986, -- Arcane Desolation
		{218012, "FLASH"}, -- Arcanopulse
		--FROST PHASE--
		217831, --Ancient Rage Frost
		217966, -- Howling Gale
		217925, --Icy Comet
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ArcanoPulse", 218012)
	self:Log("SPELL_AURA_APPLIED", "IcyCometApplied", 217925)
	self:Log("SPELL_CAST_SUCCESS", "ArcaneDesolation", 217986)
	self:Log("SPELL_CAST_SUCCESS", "WrathfulFlames", 217893)
	self:Log("SPELL_CAST_SUCCESS", "HowlingGale", 217966)
	self:Log("SPELL_CAST_SUCCESS", "BurningBombSuccess", 217874)
	self:Log("SPELL_AURA_APPLIED", "BurningBomb", 217887)
	self:Log("SPELL_AURA_REMOVED", "BurningBombRemoved", 217887)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()

end
--------------------------------------------------------------------------------
-- Event Handlers
function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, spellGUID, spellId)
	if spellId == 217563 then -- fire
		self:CDBar(217893, 9)   --WrathfulFlames
		self:CDBar(217874, 17)  --BurningBomb
		self:CDBar(217966, 27)  --HowlingGale
		self:CDBar(217925, 34)  --IcyComet
		self:CDBar(218012, 51)  --ArcanoPulse
		self:CDBar(217986, 53)  --ArcaneDesolation
		self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil)
	elseif spellId == 217831 then -- frost
		self:CDBar(217966, 2)   --HowlingGale
		self:CDBar(217925, 9)   --IcyComet
		self:CDBar(218012, 26)  --Arcanopulse
		self:CDBar(217986, 28)  --ArcaneDesolation
		self:CDBar(217874, 53)  --BurningBomb
		self:CDBar(217893, 60)  --WrathfulFlames
		self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil)
	elseif spellId == 217834 then-- arcane
		self:CDBar(217986, 2)  --ArcaneDesolation
		self:CDBar(217874, 27)  --BurningBomb
		self:CDBar(217893, 34) --WrathfulFlames
		self:CDBar(217966, 53)  --HowlingGale
		self:CDBar(217925, 59)  --IcyComet
		self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil)
	end
end

function mod:IcyCometApplied(args)
	if self:Me(args.destGUID) then
		self:Message(217925, "Attention", "Warning", CL.underyou:format(args.spellName))
	end
end

function mod:BurningBombSuccess(args)
	self:CDBar(args.spellId, bBomb % 2 == 1 and 12.5 or 63)
	bBomb = bBomb + 1
end

do
	local list = mod:NewTargetList()
	function mod:BurningBomb(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Info", nil, nil, self:Dispeller())
		end
		if self:Me(args.destGUID) then
			self:OpenProximity(args.spellId, 10)
			self:Say(args.spellId)
		end
	end

	function mod:BurningBombRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
	end
end

function mod:WrathfulFlames(args)
	self:CDBar(args.spellId, 76.4)
end

function mod:ArcanoPulse(args)
	self:CDBar(args.spellId, 76.7)
	self:Flash(args.spellId)
end

function mod:ArcaneDesolation(args)
	self:CDBar(args.spellId, aDesolation % 2 == 1 and 12.5 or 61.9)
	aDesolation = aDesolation + 1
end

function mod:HowlingGale(args)
	self:CDBar(args.spellId, hGale % 2 == 1 and 12.5 or 61.9)
	hGale = hGale + 1
end

function mod:BOSS_KILL(event, id)
	if id == 1952 then
		self:Win()
	end
end
