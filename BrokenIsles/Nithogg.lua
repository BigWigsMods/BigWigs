


local mod,CL=BigWigs:NewBoss("Nithogg",-1017,1749);
if not mod then 
	return end
	
	
mod:RegisterEnableMob(107023)
--mod.otherMenu = 962
mod.worldBoss = 107023
	
function mod:GetOptions()
		return 
		{
		
		212836,--Tail Lash 
		212852,--Storm Breath 23.7 tanks
		212867,--Electrical Storm 31.4
		212887,--Static Charge 41
		212837,--Crackling Jolt -12 
		}
end

function mod:OnBossEnable()

	self:Log("SPELL_CAST_SUCCESS", "TailLash", 212836)
	self:Log("SPELL_CAST_SUCCESS", "StormBreath", 212852)
	self:Log("SPELL_CAST_SUCCESS", "ElectricalStorm", 212867)
	self:Log("SPELL_CAST_SUCCESS", "StaticCharge", 212887)
	self:Log("SPELL_CAST_SUCCESS", "CracklingJolt", 212837)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 107023)
end

function mod:OnEngage()
			
			
			
end			

function mod:StormBreath(args)
	
	self:TargetMessage(args.spellId, args.destName, "Important", self:Tank() and "Warning")
	CDBar(212852,23.7)
		
end		

function mod:TailLash(args)

	self:Message(spellId, "Urgent", "Alert")
	CDBar(212836,7.8)
		
end	

function mod:ElectricalStorm(args)
	
	CDBar(212867,31.4)
		
end		
function mod:StaticCharge(args)
	
	CDBar(212887,41)
		
end		

function mod:CracklingJolt(args)
	
	CDBar(212837,12.7)
		
end		

	