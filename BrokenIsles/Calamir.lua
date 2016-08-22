-- TO DO LIST
-- 1)Register Icy Comet cast success event,check getOptions comment for more info
-- 2)Boss has 3 auras cycling on him with 20 second uptime,there is also 5~ ish second downtime between each buff.
-- Since It was kinda challenging to set up timers onEngage due to timers differing on pull Time,I wanted to proc all timers first time
-- boss gains a buff then removeLogs for all 3 Logs to stop timers proccing again everytime a new buff comes up.You can check the ancientRage mods.
-- There is probably a waaay more efficient way to do that though.

-- Module Declaration
--
local mod,CL=BigWigs:NewBoss("Calamir", -1015, 1774)
if not mod then
	return end

mod:RegisterEnableMob(109331)
--mod.otherMenu = 962
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
		{189894, "SAY", "PROXIMITY"}, -- Burning Bomb
		217893, -- Wrathful Flames
		--ARCANE PHASE--
		217834, --Ancient Rage Arcane
		217986, -- Arcane Desolation
		{218012, "FLASH"}, -- Arcanopulse
		--FROST PHASE--
		217831, --Ancient Rage Frost
		217966, -- Howling Gale
		217925, --Icy Comet // SPELL_CAST_SUCCESS event for Icy Comet is missing ,I tried to register event but probably bad implementation
				--             Marked the event register parts with XXX
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ArcanoPulse", 218012)
	self:Log("SPELL_AURA_APPLIED", "IcyCometApplied", 217925)
	self:Log("SPELL_CAST_SUCCESS", "ArcaneDesolation", 217986)
	self:Log("SPELL_CAST_SUCCESS", "WrathfulFlames", 217893)
	self:Log("SPELL_CAST_SUCCESS", "HowlingGale", 217966)
	self:Log("SPELL_CAST_SUCCESS", "BurningBombSuccess", 217874)
	self:Log("SPELL_AURA_APPLIED", "BurningBomb", 217874)
	self:Log("SPELL_AURA_REMOVED", "BurningBombRemoved", 217874)
	self:Log("SPELL_CAST_SUCCESS", "AncientRageFire", 217563)
	self:Log("SPELL_CAST_SUCCESS", "AncientRageFrost", 217831)
	self:Log("SPELL_CAST_SUCCESS", "AncientRageArcane", 217834)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BOSS_KILL")
	self:RegisterUnitEvent("SPELL_CAST_SUCCESS", nil, "Unit") -- XXX
end

function mod:OnEngage()

end
--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:SPELL_CAST_SUCCESS(unit, spellName, _, _, spellId)-- XXX
	if spellId == 217919 or spellName == Icy Comet then 
		self:CDBar(217925, 76.7)
		self:Message(217925, "Attention", nil, CL.incoming:format(spellName))
	end
end

function mod:IcyCometApplied(args) -- RegisterEvent
	self:Message(217925, "Attention", "Warning", CL.underyou:format(args.spellName))
end

function mod:BurningBombSuccess(args)
	self:CDBar(args.spellId, bBomb % 2 == 1 and 12.5 or 63)
	bBomb = bBomb + 1
end

do
	local list = mod:NewTargetList()
	function mod:BurningBomb(args)
		list[#list+1] = args.destName
		self:TargetMessage(args.spellId, args.destName, "Important", self:Dispeller("magic") and "Alert")
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
--
function mod:AncientRageFire(args)
	self:CDBar(217893, 9)   --WrathfulFlames
	self:CDBar(217874, 17)  --BurningBomb
	self:CDBar(217966, 27)  --HowlingGale
	self:CDBar(217925, 34)  --IcyComet
	self:CDBar(218012, 51)  --ArcanoPulse
	self:CDBar(217986, 53)  --ArcaneDesolation
	self:RemoveLog("SPELL_CAST_SUCCESS", 217563)
	self:RemoveLog("SPELL_CAST_SUCCESS", 217831)
	self:RemoveLog("SPELL_CAST_SUCCESS", 217834)
end

function mod:AncientRageFrost(args)
	self:CDBar(217966, 2)   --HowlingGale
	self:CDBar(217925, 9)   --IcyComet
	self:CDBar(218012, 26)  --Arcanopulse
	self:CDBar(217986, 28)  --ArcaneDesolation
	self:CDBar(217874, 53)  --BurningBomb
	self:CDBar(217893, 60)  --WrathfulFlames
	self:RemoveLog("SPELL_CAST_SUCCESS", 217831)
	self:RemoveLog("SPELL_CAST_SUCCESS", 217563)
	self:RemoveLog("SPELL_CAST_SUCCESS", 217834)
end

function mod:AncientRageArcane(args)
	self:CDBar(217986, 2)  --ArcaneDesolation
	self:CDBar(217874, 27)  --BurningBomb
	self:CDBar(217893, 34) --WrathfulFlames
	self:CDBar(217966, 53)  --HowlingGale
	self:CDBar(217925, 59)  --IcyComet
	self:RemoveLog("SPELL_CAST_SUCCESS", 217834)
	self:RemoveLog("SPELL_CAST_SUCCESS", 217563)
	self:RemoveLog("SPELL_CAST_SUCCESS", 217831)
end
