if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Portal Keeper Hasabel", nil, 1985, 1712)
if not mod then return end
mod:RegisterEnableMob(124393)
mod.engageId = 2064
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Platform: Nexus ]]--
		{244016, "TANK"}, -- Reality Tear
		243983, -- Collapsing World
		244000, -- Felstorm Barrage
		244677, -- Transport Portal
		244709, -- Fiery Detonation
		245504, -- Howling Shadows
		246075, -- Catastrophic Implosion

		--[[ Platform: Xoroth ]]--
		244607, -- Flames of Xoroth
		244598, -- Supernova
		244613, -- Everburning Flames

		--[[ Platform: Rancora ]]--
		{244949, "SAY"}, -- Felsilk Wrap
		246316, -- Poison Essence
		244849, -- Caustic Slime

		--[[ Platform: Nathreza ]]--
		{245050, "HEALER"}, -- Delusions
		245040, -- Corrupt
		245118, -- Cloying Shadows
	},{
		[244016] = -15799, -- Platform: Nexus
		[244607] = -15800, -- Platform: Xoroth
		[244926] = -15801, -- Platform: Rancora
		[245050] = -15802, -- Platform: Nathreza
	}
end

function mod:OnBossEnable()
	--[[ Platform: Nexus ]]--
	self:Log("SPELL_AURA_APPLIED", "RealityTear", 244016)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RealityTear", 244016)
	self:Log("SPELL_CAST_START", "CollapsingWorld", 243983, 243984) -- Could be either - 2s / 8s cast
	self:Log("SPELL_CAST_START", "FelstormBarrage", 244000)
	self:Log("SPELL_CAST_SUCCESS", "TransportPortal", 244677)
	self:Log("SPELL_CAST_START", "FieryDetonation", 244709)
	self:Log("SPELL_CAST_START", "HowlingShadows", 245504)
	self:Log("SPELL_CAST_START", "CatastrophicImplosion", 246075)

	--[[ Platform: Xoroth ]]--
	self:Log("SPELL_CAST_START", "FlamesofXoroth", 244607)
	self:Log("SPELL_CAST_SUCCESS", "Supernova", 244598)
	self:Log("SPELL_AURA_APPLIED", "EverburningFlames", 244613)

	--[[ Platform: Rancora ]]--
	self:Log("SPELL_AURA_APPLIED", "FelsilkWrap", 244949)
	self:Log("SPELL_CAST_START", "PoisonEssence", 246316)
	self:Log("SPELL_AURA_APPLIED", "CausticSlime", 244849)

	--[[ Platform: Nathreza ]]--
	self:Log("SPELL_CAST_START", "Delusions", 245050)
	self:Log("SPELL_AURA_APPLIED", "Corrupt", 245040)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Corrupt", 245040)
	self:Log("SPELL_AURA_APPLIED", "CloyingShadows", 245040)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RealityTear(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Alarm", nil, nil, amount > 2 and true) -- Assumed swap around 3~
end

function mod:CollapsingWorld(args)
	self:Message(args.spellId, "Important", "Warning")
end

function mod:FelstormBarrage(args)
	self:Message(args.spellId, "Urgent", "Alert")
end

function mod:TransportPortal(args)
	self:Message(args.spellId, "Neutral", "Info")
end

function mod:FieryDetonation(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Attention", "Alert")
	end
end

function mod:HowlingShadows(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Urgent", "Alarm")
	end
end

function mod:CatastrophicImplosion(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:FlamesofXoroth(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Urgent", "Alarm")
	end
end

function mod:Supernova(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:EverburningFlames(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info")
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:FelsilkWrap(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Positive", "Warning", nil, nil, true)
		end
	end
end

function mod:PoisonEssence(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:CausticSlime(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info")
	end
end

function mod:Delusions(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:Corrupt(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning") -- Sound when stacks are 3 or higher
	end
end

function mod:CloyingShadows(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info")
	end
end
