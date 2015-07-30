
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Archimonde", 1026, 1438)
if not mod then return end
mod:RegisterEnableMob(91331)
mod.engageId = 1799
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local currentTorment, maxTorment = 0, 0
local burstCount, burstTimer = 1, nil
local banished = nil
local feedbackSoon, feedbackTimer = nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.torment_removed = "Torment removed (%d/%d)"
	L.chaos_bar = "%s -> %s"
	L.chaos_from = "%s from %s"
	L.chaos_to = "%s to %s"

	L.custom_off_torment_marker = "Shackled Torment marker"
	L.custom_off_torment_marker_desc = "Mark the Shackled Torment targets with {rt1}{rt2}{rt3}, requires promoted or leader."
	L.custom_off_torment_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- P1
		{182826, "ICON", "SAY"}, -- Doomfire
		{183817, "PROXIMITY"}, -- Shadowfel Burst
		185590, -- Desecrate
		-- P2
		{184964, "SAY", "FLASH"}, -- Shackled Torment
		"custom_off_torment_marker",
		{186123, "ICON", "SAY", "FLASH"}, -- Wrought Chaos
		183865, -- Demonic Havoc
		-- P3
		{187180, "PROXIMITY"}, -- Demonic Feedback
		{186961, "ICON", "SAY", "PROXIMITY"}, -- Nether Banish
		{189894, "SAY", "PROXIMITY"}, -- Void Star Fixate
		182225, -- Rain of Chaos
		-- General
		183254, -- Allure of Flames
		183828, -- Death Brand
		{183864, "TANK"}, -- Shadow Blast
		183963, -- Light of the Naaru
		"stages",
	}, {
		[182826] = -11577,
		[184964] = -11590,
		[187180] = -11599,
		[183254] = "general",
	}
end

function mod:OnBossEnable()
	-- P1
	self:Log("SPELL_AURA_APPLIED", "LightOfTheNaaru", 183963)
	self:Log("SPELL_CAST_START", "AllureOfFlames", 183254)
	self:Log("SPELL_CAST_START", "DeathBrandCast", 183828)
	self:Log("SPELL_AURA_APPLIED", "DeathBrand", 183828)
	self:Log("SPELL_AURA_APPLIED", "ShadowBlast", 183864)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowBlast", 183864)
	self:Log("SPELL_SUMMON", "Doomfire", 182826)
	self:Log("SPELL_AURA_APPLIED", "DoomfireDamage", 183586)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DoomfireDamage", 183586)
	self:Log("SPELL_AURA_APPLIED", "DoomfireFixate", 182879)
	self:Log("SPELL_AURA_REMOVED", "DoomfireFixateRemoved", 182879)
	self:Log("SPELL_CAST_START", "ShadowfelBurst", 183817)
	self:Log("SPELL_AURA_APPLIED", "ShadowfelBurstApplied", 183634)
	self:Log("SPELL_CAST_START", "Desecrate", 185590)
	-- P2
	self:Log("SPELL_AURA_APPLIED", "ShackledTorment", 184964)
	self:Log("SPELL_AURA_REMOVED", "ShackledTormentRemoved", 184964)
	self:Log("SPELL_CAST_SUCCESS", "WroughtChaosCast", 184265)
	self:Log("SPELL_AURA_APPLIED", "FocusedChaos", 185014)
	self:Log("SPELL_AURA_REMOVED", "FocusedChaosRemoved", 185014)
	self:Log("SPELL_AURA_APPLIED", "DemonicHavoc", 183865)
	-- P3
	self:Log("SPELL_CAST_START", "DemonicFeedback", 187180)
	self:Log("SPELL_AURA_APPLIED", "TankNetherBanish", 186961)
	self:Log("SPELL_AURA_REMOVED", "TankNetherBanishRemoved", 186961)
	self:Log("SPELL_AURA_APPLIED", "VoidStarFixate", 189895)
	self:Log("SPELL_AURA_REMOVED", "VoidStarFixateRemoved", 189895)
	self:Log("SPELL_AURA_APPLIED", "NetherBanishApplied", 186952) -- for Twisting Nether tracking
	self:Log("SPELL_AURA_REMOVED", "NetherBanishRemoved", 186952) -- for Twisting Nether tracking
	self:Log("SPELL_CAST_SUCCESS", "RainOfChaos", 182225)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Phases", "boss1")
end

function mod:OnEngage()
	currentTorment, maxTorment = 0, 0
	burstCount = 1
	phase = 1
	banished = nil
	feedbackSoon = nil

	self:Bar(182826, 6) -- Doomfire
	self:Bar(183828, 18) -- Death Brand
	self:Bar(183254, 30) -- Allure of Flames
	self:Bar(183817, 43) -- Shadowfel Burst
	burstTimer = self:ScheduleTimer("ShadowfelBurstSoon", 33)
	-- Desecrate initial cast is at 85%
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Phases(unit, spellName, _, _, spellId)
	if spellId == 190117 then -- Allow Phase 2 Spells
		self:StopBar(182826) -- Doomfire
		self:StopBar(183817) -- Shadowfel Burst
		self:StopBar(185590) -- Desecrate
		self:CloseProximity(183817) -- Shadowfel Burst
		self:CancelTimer(burstTimer)

		phase = 2
		self:Message("stages", "Neutral", "Long", CL.phase:format(2), false)
		self:CDBar(186123, 7) -- Wrought Chaos
		self:CDBar(184964, 27) -- Shackled Torment
		self:CDBar(183828, 38) -- Death Brand
		self:CDBar(183254, 44) -- Allure of Flames
	elseif spellId == 190118 then -- Allow Phase 3 Spells
		self:StopBar(183254) -- Allure of Flames
		self:StopBar(183828) -- Death Brand

		phase = 3
		self:Message("stages", "Neutral", "Long", CL.phase:format(3), false)
		self:CDBar(186961, 13) -- Nether Banish
		self:CDBar(186123, 27) -- Wrought Chaos
		self:CDBar(187180, 35) -- Demonic Feedback
		self:CDBar(184964, 57.5) -- Shackled Torment
		feedbackTimer = self:ScheduleTimer("DemonicFeedbackSoon", 24)
	end
end

function mod:LightOfTheNaaru(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", self:Tank() and "Info")
	end
end

function mod:AllureOfFlames(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, 48) -- Min: 47.5/Avg: 49.8/Max: 54.1
end

function mod:DeathBrandCast(args)
	if self:Tank() and self:Me(UnitGUID("boss1target")) then -- pre-warning for current tank
		self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
	end
end

function mod:DeathBrand(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
	self:CDBar(args.spellId, 43)
	if self:Tank() and not self:Me(args.destGUID) then --  taunt warning for other tank
		self:PlaySound(args.spellId, "Warning")
	end
end

function mod:ShadowBlast(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
end

-- Phase 1

function mod:Doomfire(args)
	self:CDBar(args.spellId, 42) -- seems to be either 42 46 42 or 42 42 49
end

function mod:DoomfireFixate(args)
	self:TargetMessage(182826, args.destName, "Important", "Alarm")
	self:PrimaryIcon(182826, args.destName)
	self:TargetBar(182826, 10, args.destName)
	if self:Me(args.destGUID) then
		self:Say(182826)
	end
end

function mod:DoomfireFixateRemoved(args)
	self:PrimaryIcon(182826)
	self:StopBar(182826, args.destName)
end

do
	local prev = 0
	function mod:DoomfireDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(182826, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:ShadowfelBurstSoon()
	burstTimer = nil
	self:Message(183817, "Urgent", nil, CL.soon:format(self:SpellName(183817)))
	if self:Ranged() then
		self:OpenProximity(183817, 9) -- 8+1 safety
	end
end

function mod:ShadowfelBurst(args)
	self:Message(args.spellId, "Urgent", "Warning")
	if self:Ranged() then
		self:OpenProximity(args.spellId, 9) -- 8+1 safety
	end
	burstCount = burstCount + 1
	if burstTimer then
		self:CancelTimer(burstTimer)
	end
	burstTimer = self:ScheduleTimer("ShadowfelBurstSoon", burstCount == 2 and 53 or 48)
end

do
	local list = mod:NewTargetList()
	function mod:ShadowfelBurstApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 183817, list, "Urgent")
			self:Bar(183817, burstCount == 2 and 61 or 56)
			if self:Ranged() then
				self:OpenProximity(183817, 8, args.destName)
				self:ScheduleTimer("CloseProximity", 6, 183817)
			end
		end
	end
end

function mod:Desecrate(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:CDBar(args.spellId, 27) -- Min: 26.8/Avg: 29.2/Max: 33.4
end

-- Phase 2

do
	local list, isOnMe = {}, nil
	local function tormentSay(self, spellId)
		sort(list)
		for i = 1, #list do
			local target = list[i]
			if target == isOnMe then
				local torment = CL.count:format(self:SpellName(187553), i) -- 187553 = "Torment"
				self:Say(spellId, torment)
				self:Flash(spellId)
				self:TargetMessage(spellId, target, "Personal", "Alarm", torment)
			end
			if self:GetOption("custom_off_torment_marker") then
				SetRaidTarget(target, i)
			end
			list[i] = self:ColorName(target)
		end
		if not isOnMe and not banished then
			self:TargetMessage(spellId, list, "Attention")
		else
			wipe(list)
		end
	end

	function mod:ShackledTorment(args)
		if self:Me(args.destGUID) then
			isOnMe = args.destName
		end

		currentTorment = currentTorment + 1
		if currentTorment > maxTorment then
			maxTorment = currentTorment
		end

		list[#list + 1] = args.destName
		if #list == 1 then
			self:CDBar(args.spellId, 32) -- p2 40.1, 36.5.. p2.5 31.6 ?
			self:ScheduleTimer(tormentSay, 0.3, self, args.spellId)
		end
	end

	function mod:ShackledTormentRemoved(args)
		if self:GetOption("custom_off_torment_marker") then
			SetRaidTarget(args.destName, 0)
		end

		currentTorment = currentTorment - 1
		self:Message(args.spellId, "Neutral", isOnMe and "Info", L.torment_removed:format(maxTorment - currentTorment, maxTorment))
		if currentTorment == 0 then
			maxTorment = 0
		end

		if self:Me(args.destGUID) then
			isOnMe = nil
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:DemonicHavoc(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", self:Dispeller("magic") and "Alert", nil, nil, true)
		end
	end
end

do
	local chaosCount, prev, isOnMe = 0, 0, nil

	function mod:WroughtChaosCast(args)
		chaosCount = 0
		--self:CDBar(186123, 52)
	end

	function mod:FocusedChaos(args)
		-- throttle for Mythic
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			chaosCount = chaosCount + 1
		end
		isOnMe = nil

		if self:Me(args.sourceGUID) then -- Wrought Chaos (1) to PLAYER
			local spell = CL.count:format(self:SpellName(186123), chaosCount)
			self:TargetMessage(186123, args.sourceName, "Personal", "Info", L.chaos_to:format(self:SpellName(186123), self:ColorName(args.destName)))
			self:Say(186123)
			isOnMe = true
		end
		if self:Me(args.destGUID) then -- Focused Chaos (1) from PLAYER
			local spell = CL.count:format(args.spellName, chaosCount)
			self:TargetMessage(186123, args.destName, "Positive", "Alarm", L.chaos_from:format(args.spellName, self:ColorName(args.sourceName)), args.spellId)
			self:Say(186123, args.spellName)
			--self:Flash(186123, args.spellId)
			isOnMe = true
		end
		if isOnMe then
			local targets = L.chaos_bar:format(args.sourceName, args.destName)
			self:Bar(186123, 5, ("(%d) %s"):format(chaosCount, targets), "spell_shadow_soulleech_1") -- (1) Player -> Player
		end

		if not self:Mythic() then
			-- Always clear before setting
			self:SecondaryIcon(186123)
			self:PrimaryIcon(186123)
			-- Delay for potential latency with clearing the icons
			self:ScheduleTimer("SecondaryIcon", 0.3, 186123, args.sourceName)
			self:ScheduleTimer("PrimaryIcon", 0.3, 186123, args.destName)

			if not banished and not isOnMe then
				local spell = CL.count:format(self:SpellName(186123), chaosCount)
					local targets = L.chaos_bar:format(args.sourceName, args.destName)
				self:Message(186123, "Important", nil, CL.other:format(spell, targets)) -- Wrought Chaos (1): Player -> Player
				self:Bar(186123, 5, ("(%d) %s"):format(chaosCount, targets), "spell_shadow_soulleech_1") -- (1) Player -> Player
			end
		end
	end

	function mod:FocusedChaosRemoved(args)
		if chaosCount == 4 then
			self:SecondaryIcon(186123)
			self:PrimaryIcon(186123)
		end
	end
end

-- Phase 3

function mod:RainOfChaos(args)
	if not banished then
		self:Message(args.spellId, "Urgent", "Alert")
	end
	self:Bar(args.spellId, 62)
end

function mod:TankNetherBanish(args)
	self:CDBar(args.spellId, 62)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 7, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 8, nil, true)
	end
end

function mod:TankNetherBanishRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:NetherBanishApplied(args)
	if self:Me(args.destGUID) then
		banished = true
		if feedbackSoon then
			self:CloseProximity(187180) -- Demonic Feedback
		end
	end
end

function mod:NetherBanishRemoved(args)
	if self:Me(args.destGUID) then
		banished = nil
		if feedbackSoon then
			self:OpenProximity(187180, 7) -- Demonic Feedback
		end
	end
end

function mod:VoidStarFixate(args)
	if banished then
		self:TargetMessage(189894, args.destName, "Personal", "Alarm")
	end
	if self:Me(args.destGUID) then
		self:Say(189894)
		self:OpenProximity(189894, 15)
	end
end

function mod:VoidStarFixateRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(189894)
	end
end

function mod:DemonicFeedbackSoon()
	feedbackSoon = true
	if not banished then
		self:Message(187180, "Attention", "Info", CL.soon:format(self:SpellName(187180)))
		self:OpenProximity(187180, 7)
	end
end

function mod:DemonicFeedback(args)
	feedbackSoon = nil
	if not banished then
		self:Message(args.spellId, "Attention", "Warning")
		self:OpenProximity(187180, 7)
	end
	self:CDBar(args.spellId, 37)

	self:CancelTimer(feedbackTimer)
	feedbackTimer = self:ScheduleTimer("DemonicFeedbackSoon", 28)
end

