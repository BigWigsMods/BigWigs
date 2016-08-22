


--arcane->fire->frost....-> rotation 5~ seconds between each element 20 sec buff uptime

local mod,CL=BigWigs:NewBoss("Calamir",-1015,1774);
if not mod then 
	return end
	
mod:RegisterEnableMob(109331)
--mod.otherMenu = 962
mod.worldBoss = 109331

local bBomb=1;	
local hGale=1;
local aDesolation=1;

function mod:GetOptions()
	return {
		--FIRE PHASE--
		217874, -- Burning Bomb
		217893, -- Wrathful Flames
		--ARCANE PHASE--
		217986, -- Arcane Desolation
		{218012, "FLASH"}, -- Arcanopulse
		--FROST PHASE--
		217966, -- Howling Gale
		217919, --Icy Comet(journal spell) missing ID on wowhead 
	}
end

function mod:OnBossEnable()
	
	
	self:Log("SPELL_CAST_SUCCESS", "ArcanoPulse", 218012)
	self:Log("SPELL_CAST_SUCCESS", "IcyComet", 217919)
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
end


--[[function mod:OnEngage()
	
	-- //local _, _, _, _, _, duration, expirationTime = UnitBuff("Unit", "Calamir") --fix this
	--if duration == nil then
		

end--]]

function mod:AncientRageFire(args)

	self:CDBar(217893,9);  --WrathfulFlames
	self:CDBar(217874,17); --BurningBomb
	self:CDBar(217966,27)  --HowlingGale
	self:CDBar(217919,34)  --IcyComet
	self:CDBar(218012,51)  --ArcanoPulse
	self:CDBar(217986,53)  --ArcaneDesolation
	
	self:RemoveLog("SPELL_CAST_SUCCESS", 217563)
	
end

function mod:AncientRageFrost(args)

	self:CDBar(217966,2)  --HowlingGale	
	self:CDBar(217919,9)  --IcyComet
	self:CDBar(218012,26)  --Arcanopulse
	self:CDBar(217986,28)  --ArcaneDesolation
	self:CDBar(217874,53);  --BurningBomb
	self:CDBar(217893,60); --WrathfulFlames
	
	self:RemoveLog("SPELL_CAST_SUCCESS", 217831)
	
end

function mod:AncientRageArcane(args)

	self:CDBar(217986,2)  --ArcaneDesolation
	self:CDBar(217874,27);  --BurningBomb
	self:CDBar(217893,34); --WrathfulFlames
	self:CDBar(217966,53)  --HowlingGale
	self:CDBar(217919,59)  --IcyComet
	
	self:RemoveLog("SPELL_CAST_SUCCESS", 217834);
	
end

function mod:BurningBombSuccess(args)
	if bBomb==1 then
		self:CDBar(args.spellId, 12.5)
		bBomb=2;
	else
		self:CDBarBar(args.spellId, 63)
		bBomb=1;
	end

end

function mod:BurningBomb(args)

	self:TargetMessage(args.spellId, args.destName, "Important", self:Dispeller("magic") and "Alert")
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 10);
		self:Say(args.spellId)
	end	
	
end

function mod:BurningBombRemoved(args)
	self:CloseProximity(args.spellId);
end

function mod:WrathfulFlames(args)
	self:CDBar(args.spellId, 76.4)
end


function mod:ArcanoPulse(args)
	self:CDBar(args.spellId,76.7)
	self:Flash(args.spellId)
end

function mod:IcyComet(args)
	self:CDBar(args.spellId,76.7)
end
	
function mod:ArcaneDesolation(args)
	if aDesolation==1 then
		self:CDBar(args.spellId, 12.5)
		aDesolation=2;
	else
		self:CDBar(args.spellId, 61.9)
		aDesolation=1;
	end
end
	
function mod:HowlingGale(args)
	if hGale==1 then
		self:CDBar(args.spellId, 12.5)
		hGale=2;
	else
		self:CDBar(args.spellId, 61.9)
		hGale=1;
	end
	
end

function mod:BOSS_KILL(event, id)
	if id == 1952 then
		self:Win()
	end
end


