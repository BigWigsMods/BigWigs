if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Demonic Inquisition", 1147, 1867)
if not mod then return end
mod:RegisterEnableMob(120996, 116691) -- XXX Guestimate
mod.engageId = 2048
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
		233426, -- Scythe Sweep
		233431, -- Calcified Quills
		233441, -- Bone Saw
		239401, -- Shadow Bolt Volley
		{233983, "FLASH", "SAY", "PROXIMITY"}, -- Echoing Anguish
		233895, -- Suffocating Dark
		234015, -- Tormenting Burst
		235230, -- Fel Squall
	},{
		[233426] = -14645, -- Atrigan
		[239401] = -14646, -- Belac
	}
end

function mod:OnBossEnable()
	-- Atrigan
	self:Log("SPELL_CAST_START", "ScytheSweep", 233426)	
	self:Log("SPELL_CAST_START", "CalcifiedQuills", 233431)
	self:Log("SPELL_CAST_START", "BoneSaw", 233441)
	
	-- Belac
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 239401)	
	self:Log("SPELL_CAST_START", "EchoingAnguish", 233983)		
	self:Log("SPELL_AURA_APPLIED", "EchoingAnguish", 233983)		
	self:Log("SPELL_AURA_REMOVED", "EchoingAnguish", 233983)		
	self:Log("SPELL_AURA_APPLIED", "SuffocatingDark", 233895)		
	self:Log("SPELL_CAST_START", "TormentingBurst", 234015)		
	self:Log("SPELL_CAST_START", "FelSquall", 235230)	
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ScytheSweep(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:CalcifiedQuills(args)
	self:Message(args.spellId, "Urgent", "Alert", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:BoneSaw(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, 15, CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end

function mod:ShadowBoltVolley(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:EchoingAnguish(args)
	self:OpenProximity(args.spellId, 8) -- Open proximity a bit before
end

do
	local playerList, proxList = mod:NewTargetList(), {}

	function mod:EchoingAnguishApplied(args)
		proxList[#proxList+1] = args.destName
		
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		
		self:OpenProximity(args.spellId, 8, proxList) -- Don't stand near others if they have the debuff

		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Alert")			
			--self:Bar(args.spellId, 10)
		end
	end

	function mod:EchoingAnguishRemoved(args)
		tDeleteItem(proxList, args.destName)
		if #proxList == 0 then -- If there are no debuffs left, close proximity
			self:CloseProximity(args.spellId)
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:SuffocatingDark(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Alert")		
			--self:Bar(args.spellId, 10)
		end
	end
end

function mod:TormentingBurst(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:FelSquall(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	self:Bar(args.spellId, 15, CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end
