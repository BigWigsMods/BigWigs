if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Varmathras", nil, 1983, 1712)
if not mod then return end
mod:RegisterEnableMob(125075)
mod.engageId = 2069
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		243961, -- Misery
		243963, -- Alone in the Darkness
		{243960, "TANK"}, -- Shadow Strike
		243999, -- Dark Fissure
		{244042, "SAY", "FLASH"}, -- Marked Prey
		{244094, "SAY", "FLASH", "ICON"}, -- Necrotic Embrace
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Misery", 243961)
	self:Log("SPELL_CAST_SUCCESS", "AloneintheDarkness", 243963)
	self:Log("SPELL_CAST_SUCCESS", "ShadowStrike", 243960)
	self:Log("SPELL_CAST_SUCCESS", "DarkFissure", 243999)
	self:Log("SPELL_AURA_APPLIED", "MarkedPrey", 244042)
	self:Log("SPELL_AURA_APPLIED", "MarkedPreyRemoved", 244042)
	self:Log("SPELL_AURA_APPLIED", "NecroticEmbrace", 244094)
	self:Log("SPELL_AURA_APPLIED", "NecroticEmbraceRemoved", 244094)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Misery(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 17.0)
end

function mod:AloneintheDarkness(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 17.0)
end

function mod:ShadowStrike(args)
	self:Message(args.spellId, "Neutral", "Info")
	self:Bar(args.spellId, 17.0)
end

function mod:DarkFissure(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 17.0)
end

do
	local playerList = mod:NewTargetList()
	function mod:MarkedPrey(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end

	function mod:MarkedPreyRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:NecroticEmbrace(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:SayCountdown(args.spellId, 4)
	end
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:NecroticEmbraceRemoved(args)
	self:PrimaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end