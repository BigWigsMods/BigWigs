if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gorothi Worldbreaker", nil, 1992, 1712) -- XXX Temp missing map id
if not mod then return end
mod:RegisterEnableMob(122450) -- Garothi Worldbreaker
mod.engageId = 2076
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{246220, "TANK", "SAY"}, -- Locked On
		--244395, -- Searing Barrage XXX Might be too spammy, leave out for now
		244152, -- Apocalypse Drive
		246655, -- Surging Fel
		244969, -- Eradication
		--245237, -- Empowered XXX Do we want to track/announce the stacks?
		244106, -- Carnage
		{244410, "SAY"}, -- Decimation
		244761, -- Annihilation
	},{
		[246220] = "general",
		[244410] = -15915, -- Decimator
		[244761] = -15917, -- Annihilator
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "LockedOn", 246220) -- Locked On pre-debuff
	self:Log("SPELL_AURA_REMOVED", "LockedOnRemoved", 246220) -- Locked On pre-debuff
	--self:Log("SPELL_AURA_SUCCESS", "SearingBarrage", 244395)
	self:Log("SPELL_AURA_APPLIED", "ApocalypseDrive", 244152)
	self:Log("SPELL_AURA_REMOVED", "ApocalypseDriveOver", 244152)
	self:Log("SPELL_CAST_SUCCESS", "SurgingFel", 246655)
	self:Log("SPELL_CAST_START", "Eradication", 244969)
	--self:Log("SPELL_AURA_APPLIED", "Empowered", 245237)
	self:Log("SPELL_CAST_SUCCESS", "Carnage", 244106)
	self:Log("SPELL_AURA_APPLIED", "Decimation", 244410, 252797, 246687, 245770) -- XXX Check which debuffs are actually used in each difficulty
	self:Log("SPELL_AURA_REMOVED", "DecimationRemoved", 244410, 252797, 246687, 245770)
	self:Log("SPELL_CAST_SUCCESS", "Annihilation", 244761)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LockedOn(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 7)
		self:TargetBar(args.spellId, 7, args.destName)
	end
end

function mod:LockedOnRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

--function mod:SearingBarrage(args) -- XXX Remove if unused
--	self:Message(args.spellId, "Attention", "Alarm")
--end

function mod:ApocalypseDrive(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, 20)
end

function mod:ApocalypseDriveOver(args)
	self:Message(args.spellId, "Positive", "Info")
	self:StopBar(CL.cast:format(args.spellName))
end

function mod:SurgingFel(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:Eradication(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

--function mod:Empowered(args) -- XXX Remove if unused
--	self:Message(args.spellId, "Neutral", "Info")
--end

function mod:Carnage(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

do
	local playerList = mod:NewTargetList()
	function mod:Decimation(args)
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName) -- XXX Unkown duration (3 or 5 seconds on wowhead), set fixed duration once known
			local remaining = expires-GetTime()
			self:Say(244410)
			self:SayCountdown(244410, remaining)
			self:TargetBar(244410, remaining, args.destName)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 244410, playerList, "Positive", "Alert")
		end
	end
end

function mod:DecimationRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(244410)
		self:StopBar(244410, args.destName)
	end
end

function mod:Annihilation(args)
	self:Message(args.spellId, "Attention", "Alert")
end
