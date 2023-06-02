--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aberrus, the Shadowed Crucible Trash", 2569)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	205651 -- Bubbling Slime
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
	L.slime = "Bubbling Slime"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
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
