--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aberrus, the Shadowed Crucible Trash", 2569)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	201746, -- Sundered Naturalist
	205651 -- Bubbling Slime
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--[[ Kazzara -> Amalgamation Chamber ]]--
	L.naturalist = "Sundered Naturalist"

	--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
	L.slime = "Bubbling Slime"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Kazzara -> Amalgamation Chamber ]]--
		{406282, "SAY", "SAY_COUNTDOWN"}, -- Dream Burst
		408811, -- Form Ranks

		--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
		{411808, "SAY", "SAY_COUNTDOWN"}, -- Slime Ejection
		412498, -- Stagnating Pool
	},{
		[411808] = L.slime,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	--[[ Kazzara -> Amalgamation Chamber ]]--
	self:Log("SPELL_CAST_START", "DreamBurst", 406282)
	self:Log("SPELL_CAST_SUCCESS", "FormRanks", 408811)

	--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
	self:Log("SPELL_CAST_SUCCESS", "SlimeEjection", 411808)
	self:Log("SPELL_AURA_APPLIED", "SlimeEjectionApplied", 411808)
	self:Log("SPELL_AURA_REMOVED", "SlimeEjectionRemoved", 411808)
	self:Death("BubblingSlimeKilled", 205651) -- Bubbling Slime
	self:Log("SPELL_AURA_APPLIED", "StagnatingPoolApplied", 412498)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Kazzara -> Amalgamation Chamber ]]--
do
	local function printTarget(self, player, guid)
		self:TargetMessage(406282, "yellow", player)
		if self:Me(guid) then
			self:PlaySound(406282, "warning")
			self:Say(406282)
			self:SayCountdown(406282, 3.5)
		end
	end
	function mod:DreamBurst(args)
		self:GetUnitTarget(printTarget, 0.5, args.sourceGUID)
	end
end

function mod:FormRanks(args)
	self:Message(args.spellId, "red", CL.spawned:format(self:SpellName(378085)))
end

--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
function mod:SlimeEjection(args)
	self:CDBar(args.spellId, 13.1)
end

function mod:SlimeEjectionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:TargetBar(args.spellId, 5, args.destName)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:SlimeEjectionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:BubblingSlimeKilled()
	self:StopBar(411808) -- Slime Ejection
end

do
	local prev = 0
	function mod:StagnatingPoolApplied(args)
		if self:Me(args.destGUID) and args.time-prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end
