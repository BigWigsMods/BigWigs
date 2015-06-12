
-- Notes --
-- Nether Banish has conflicting descriptions
-- Phase Transitions
-- - P2 Start (70%): Yell "I grow tired of this pointless game. You face the immortal Legion, scourge of a thousand worlds."
-- - P3 Start (40%): Yell "Enough! Your meaningless struggle ends now!"

--------------------------------------------------------------------------------
-- Module Declaration
--

if GetBuildInfo() ~= "6.2.0" then return end

local mod, CL = BigWigs:NewBoss("Archimonde", 1026, 1438)
if not mod then return end
mod:RegisterEnableMob(91331, 91557) -- 91331 on beta
mod.engageId = 1799

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{184964, "SAY", "FLASH"}, -- Shackled Torment
		183828, -- Death Brand
		{186961, "ICON", "SAY", "PROXIMITY"}, -- Nether Banish
		183817, -- Shadow Burst
		183865, -- Demonic Havoc
		{182879, "SAY"}, -- Doomfire Fixate
		{189895, "SAY", "PROXIMITY"}, -- Void Star Fixate
		{186123, "SAY", "PROXIMITY"}, -- Wrought Chaos
		{185014, "SAY", "PROXIMITY"}, -- Focused Chaos
		183586, -- Doomfire
		183254, -- Allure of Flames
		185590, -- Desecrate
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ShackledTorment", 184964)
	self:Log("SPELL_CAST_START", "DeathBrand", 183828)
	self:Log("SPELL_AURA_APPLIED", "NetherBanish", 186961)
	self:Log("SPELL_AURA_REMOVED", "NetherBanishRemoved", 186961)
	self:Log("SPELL_CAST_START", "ShadowBurst", 183817)
	self:Log("SPELL_AURA_APPLIED", "ShadowBurstApplied", 183634)
	self:Log("SPELL_AURA_APPLIED", "DemonicHavoc", 183865)
	self:Log("SPELL_AURA_APPLIED", "DoomfireFixate", 182879)
	self:Log("SPELL_AURA_APPLIED", "VoidStarFixate", 189895)
	self:Log("SPELL_AURA_REMOVED", "VoidStarFixateRemoved", 189895)
	self:Log("SPELL_AURA_APPLIED", "WroughtChaos", 186123)
	self:Log("SPELL_AURA_REMOVED", "WroughtChaosRemoved", 186123)
	self:Log("SPELL_AURA_APPLIED", "FocusedChaos", 185014)
	self:Log("SPELL_AURA_REMOVED", "FocusedChaosRemoved", 185014)
	self:Log("SPELL_CAST_START", "AllureOfFlames", 183254)
	self:Log("SPELL_CAST_START", "Desecrate", 185590)

	self:Log("SPELL_AURA_APPLIED", "DoomfireDamage", 183586)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DoomfireDamage", 183586)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Archimonde (beta) engaged", false)
	self:Bar(183817, 41) -- Shadow Burst
	self:Bar(183254, 30) -- Allure of Flames
	self:Bar(183828, 15.4) -- Death Brand
	self:CDBar(185590, 45) -- Desecrate, Timers Min: 38.9/Avg: 60.0/Max: 74.6 (avg 45s on later pulls)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:ShackledTorment(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		self:CDBar(args.spellId, 32) -- Min: 31.8/Avg: 34.5/Max: 43.8
		
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

function mod:DeathBrand(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 2.5)
end

function mod:NetherBanish(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 7, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 30, nil, true) -- XXX EJ says 10yd tank only, spell says 30yd any player
	end
end

function mod:NetherBanishRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:ShadowBurst(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 2)
	self:ScheduleTimer("CDBar", 2, args.spellId, 51) -- Min: 52.8/Avg: 59.5/Max: 72
end

do
	local list = mod:NewTargetList()
	function mod:ShadowBurstApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, 183817, list, "Attention")
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:DemonicHavoc(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
	end
end

function mod:DoomfireFixate(args)
	self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	if self:Me(args.destGUID) then
		self:TargetBar(args.spellId, 10, args.destName)
		self:Say(args.spellId)
	end
end

function mod:VoidStarFixate(args)
	self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 15)
	end
end

function mod:VoidStarFixateRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:WroughtChaos(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Info")
	self:TargetBar(args.spellId, 5, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		--self:OpenProximity(args.spellId, 10, FOCUSEDCHAOS, true)
	end
end

function mod:WroughtChaosRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		--self:CloseProximity(args.spellId)
	end
end

function mod:FocusedChaos(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Info")
	self:TargetBar(args.spellId, 5, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		--self:OpenProximity(args.spellId, 10, WROUGHTCHAOS, true)
	end
end

function mod:FocusedChaosRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		--self:CloseProximity(args.spellId)
	end
end

function mod:AllureOfFlames(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, 48) -- Min: 47.5/Avg: 49.8/Max: 54.1
end

do
	local prev = 0
	function mod:DoomfireDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:Desecrate(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:CDBar(args.spellId, 27) -- Min: 26.8/Avg: 29.2/Max: 33.4
end

