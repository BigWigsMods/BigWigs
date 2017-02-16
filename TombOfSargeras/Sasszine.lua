if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mistress Sassz'ine", 1147, 1861)
if not mod then return end
mod:RegisterEnableMob(115767) -- XXX Guestimate
mod.engageId = 2037 
--mod.respawnTime = 30

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
	230143, -- Hydra Shot
	{230201, "TANK", "FLASH"}, -- Burden of Pain
	230227, -- From the Abyss
	232732, -- Slicing Tornado
	230358, -- Thundering Shock
	230384, -- Consuming Hunger
	232746, -- Beckon Sarukel
	234621, -- Devouring Maw
	232756, -- Summon Ossunet
	232913, -- Befouling Ink
	232757, -- Call Vellius
	232827, -- Crashing Wave
	},{
		[230143] = "general",
		[232732] = -14591,
		[232746] = -14605,
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "HydraShot", 230143)	
	self:Log("SPELL_CAST_SUCCESS", "BurdenofPain", 230201)	
	self:Log("SPELL_CAST_SUCCESS", "FromtheAbyss", 230227)	
	
	-- Stage One: Ten Thousand Fangs
	self:Log("SPELL_CAST_SUCCESS", "SlicingTornado", 232732)
	self:Log("SPELL_CAST_START", "ThunderingShock", 230358)
	self:Log("SPELL_CAST_START", "ConsumingHunger", 230384)	
	
	-- Stage Two: Terrors of the Deep
	self:Log("SPELL_CAST_START", "BeckonSarukel", 232746)	
	self:Log("SPELL_CAST_SUCCESS", "DevouringMaw", 234621)	
	self:Log("SPELL_CAST_START", "SummonOssunet", 232756)
	self:Log("SPELL_CAST_SUCCESS", "BefoulingInk", 232913)			
	self:Log("SPELL_CAST_START", "CallVellius", 232757)			
	self:Log("SPELL_CAST_START", "CrashingWave", 232827)			
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:HydraShot(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Alert")	
			self:Bar(args.spellId, 6, CL.casting:format(args.spellName))	
			--self:Bar(args.spellId, 10)
		end
	end
end

function mod:BurdenofPain(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert")
	self:TargetBar(args.spellId, 20, args.destName)
	--self:Bar(args.spellId, 10)
	
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end		
end

function mod:FromtheAbyss(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:SlicingTornado(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:ThunderingShock(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:ConsumingHunger(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:BeckonSarukel(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:DevouringMaw(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, 10)
end

function mod:SummonOssunet(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:BefoulingInk(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:CallVellius(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end


function mod:CrashingWave(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, 4, CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end
