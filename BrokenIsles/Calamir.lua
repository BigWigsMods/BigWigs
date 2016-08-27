-- TO DO LIST
-- 1)Check Cast-Succeed Buff Rotation Timers on combat
-- 2)could potentially add Icy comet Spell id as 3rd else if statement

--------------------------------------------------------------------------------
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
		--[[ FIRE PHASE ]]--
		{217887, "SAY", "PROXIMITY"}, -- Burning Bomb
		217893, -- Wrathful Flames
		--[[ ARCANE PHASE  ]]--
		217986, -- Arcane Desolation
		{218012, "FLASH"}, -- Arcanopulse
		--[[ FROST PHASE ]]--
		217966, -- Howling Gale
		217925, -- Icy Comet
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
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	bBomb = 1
	hGale = 1
	aDesolation = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = nil
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, castGUID, spellId)
		if spellId == 217563 and castGUID ~= prev then -- Fire
			prev = castGUID
			self:CDBar(217893, 9) -- Wrathful Flames
			self:CDBar(217874, 17) -- Burning Bomb
			self:CDBar(217966, 27) -- Howling Gale
			self:CDBar(217925, 34) -- Icy Comet
			self:CDBar(218012, 51) -- Arcanopulse
			self:CDBar(217986, 53) -- Arcane Desolation
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		elseif spellId == 217831 and castGUID ~= prev then -- Frost
			prev = castGUID
			self:CDBar(217966, 2) -- Howling Gale
			self:CDBar(217925, 9) -- Icy Comet
			self:CDBar(218012, 26) -- Arcanopulse
			self:CDBar(217986, 28) -- Arcane Desolation
			self:CDBar(217874, 53) -- Burning Bomb
			self:CDBar(217893, 60) -- Wrathful Flames
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		elseif spellId == 217834 and castGUID ~= prev then -- Arcane
			prev = castGUID
			self:CDBar(217986, 2) -- Arcane Desolation
			self:CDBar(217874, 27) -- Burning Bomb
			self:CDBar(217893, 34) -- Wrathful Flames
			self:CDBar(217966, 53) -- Howling Gale
			self:CDBar(217925, 59) -- Icy Comet
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		end
	end
end

function mod:IcyCometApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Attention", "Warning", CL.underyou:format(args.spellName))
	end
end

function mod:BurningBombSuccess(args)
	self:CDBar(217887, bBomb % 2 == 1 and 12.5 or 63)
	bBomb = bBomb + 1
end

do
	local list = mod:NewTargetList()
	function mod:BurningBomb(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Info", nil, nil, self:Dispeller())
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

function mod:BOSS_KILL(_, id)
	if id == 1952 then
		self:Win()
	end
end

