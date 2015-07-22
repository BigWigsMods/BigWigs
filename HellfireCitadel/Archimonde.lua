
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
local currentTorment = 0
local maxTorment = 0
local burstCount = 1
local burstTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.torment_removed = "Torment removed (%d/%d)"
	L.chaos_bar = "%s -> %s"

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
		{182826, "SAY"}, -- Doomfire
		{183817, "PROXIMITY"}, -- Shadowfel Burst
		185590, -- Desecrate
		-- P2
		{184964, "SAY", "FLASH"}, -- Shackled Torment
		"custom_off_torment_marker",
		{186123, "SAY", "FLASH"}, -- Wrought Chaos
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
	self:Log("SPELL_CAST_START", "AllureOfFlames", 183254)
	self:Log("SPELL_CAST_START", "DeathBrand", 183828)
	self:Log("SPELL_AURA_APPLIED", "ShadowBlast", 183864)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowBlast", 183864)
	self:Log("SPELL_SUMMON", "Doomfire", 182826)
	self:Log("SPELL_AURA_APPLIED", "DoomfireDamage", 183586)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DoomfireDamage", 183586)
	self:Log("SPELL_AURA_APPLIED", "DoomfireFixate", 182879)
	self:Log("SPELL_CAST_START", "ShadowfelBurst", 183817)
	self:Log("SPELL_AURA_APPLIED", "ShadowfelBurstApplied", 183634)
	self:Log("SPELL_CAST_START", "Desecrate", 185590)
	-- P2
	self:Log("SPELL_AURA_APPLIED", "ShackledTorment", 184964)
	self:Log("SPELL_AURA_REMOVED", "ShackledTormentRemoved", 184964)
	self:Log("SPELL_CAST_SUCCESS", "WroughtChaosCast", 184265)
	self:Log("SPELL_AURA_APPLIED", "WroughtChaos", 186123)
	self:Log("SPELL_AURA_APPLIED", "FocusedChaos", 185014)
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
	currentTorment = 0
	maxTorment = 0
	burstCount = 1

	self:Bar(182826, 6) -- Doomfire
	self:Bar(183828, 15.4) -- Death Brand
	self:Bar(183254, 30) -- Allure of Flames
	self:Bar(183817, 43) -- Shadowfel Burst
	burstTimer = self:ScheduleTimer("ShadowfelBurstSoon", 36)
	-- Desecrate initial cast is at 85%
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Phases(unit, spellName, _, _, spellId)
	if spellId == 190117 then -- Allow Phase 2 Spells
		self:StopBar(182826) -- Doomfire
		self:StopBar(183817) -- Shadowfel Burst
		self:CancelTimer(burstTimer)
		self:Message("stages", "Neutral", "Long", CL.phase:format(2), false)
		self:CDBar(186123, 7) -- Wrought Chaos
		self:CDBar(184964, 27) -- Shackled Torment
		self:CDBar(183828, 38) -- Death Brand
		self:CDBar(183254, 44) -- Allure of Flames
	elseif spellId == 190118 then -- Allow Phase 3 Spells
		self:Message("stages", "Neutral", "Long", CL.phase:format(3), false)
		self:StopBar(183254) -- Allure of Flames
		self:StopBar(183828) -- Death Brand
		self:CDBar(186961, 13) -- Nether Banish
		self:CDBar(186123, 27) -- Wrought Chaos
		self:CDBar(187180, 35) -- Demonic Feedback
		self:CDBar(184964, 57.5) -- Shackled Torment
		self:OpenProximity(187180, 7) -- Demonic Feedback XXX: Schedule it ~10sec before the timer
	end
end

function mod:AllureOfFlames(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, 48) -- Min: 47.5/Avg: 49.8/Max: 54.1
end

function mod:DeathBrand(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 42)
end

function mod:ShadowBlast(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
end

-- Phase 1

function mod:Doomfire(args)
	self:CDBar(args.spellId, 42)
end

function mod:DoomfireFixate(args)
	self:TargetMessage(182826, args.destName, "Important", "Alarm")
	if self:Me(args.destGUID) then
		self:TargetBar(182826, 10, args.destName)
		self:Say(182826)
	end
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
	self:Message(183817, "Urgent", nil, CL.soon:format(self:SpellName(183817)))
	self:OpenProximity(183817, 9) -- 8+1 safety
end

function mod:ShadowfelBurst(args)
	self:Message(args.spellId, "Urgent", "Warning")
	-- just in case timer is off
	self:Bar(args.spellId, 2)
	self:CancelTimer(burstTimer)
	self:OpenProximity(args.spellId, 9) -- 8+1 safety
end

do
	local list = mod:NewTargetList()
	function mod:ShadowfelBurstApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 183817, list, "Attention")
			burstCount = burstCount + 1
			self:Bar(args.spellId, burstCount == 2 and 61 or 56)
			self:CloseProximity(183817)
			burstTimer = self:ScheduleTimer("ShadowfelBurstSoon", burstCount == 2 and 54 or 48)
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
				self:Message(spellId, "Personal", "Alarm", CL.you:format(torment))
			end
			if self:GetOption("custom_off_torment_marker") then
				SetRaidTarget(target, i)
			end
			list[i] = self:ColorName(target)
		end
		if not isOnMe then
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
			self:CDBar(args.spellId, 32) -- Min: 31.8/Avg: 34.5/Max: 43.8
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
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
		end
	end
end

do
	local chaosCount = 0
	local chaosSource, chaosTarget = "", ""

	function mod:WroughtChaosCast(args)
		chaosCount = 0
	end

	function mod:WroughtChaos(args)
		chaosSource = self:ColorName(args.destName)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
			self:Say(args.spellId)
		end
	end

	function mod:FocusedChaos(args)
		chaosTarget = self:ColorName(args.destName)
		if self:Me(args.destGUID) then
			self:Message(186123, "Positive", "Info", CL.you:format(args.spellName))
			self:Say(186123, args.spellName)
			--self:Flash(186123, args.spellId)
		end

		chaosCount = chaosCount + 1
		local spell = CL.count:format(self:SpellName(186123), chaosCount)
		if not self:Mythic() then
			local targets = L.chaos_bar:format(chaosSource, chaosTarget)
			self:Message(186123, "Important", nil, CL.other:format(spell, targets)) -- Wrought Chaos (1): Player -> Player
			self:Bar(186123, 5, ("(%d) %s"):format(chaosCount, targets), "spell_shadow_soulleech_1") -- (1) Player -> Player
		else
			self:Message(186123, "Important", nil, spell) -- Wrought Chaos (1)
			self:Bar(186123, 5, ("(%d) %s"):format(chaosCount, args.spellName), "spell_shadow_soulleech_1") -- (1) Focused Chaos
		end
	end
end

-- Phase 3

function mod:RainOfChaos(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.incoming:format(args.spellName))
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
		self:CloseProximity(187180) -- Demonic Feedback
	end
end

function mod:NetherBanishRemoved(args)
	if self:Me(args.destGUID) then
		self:OpenProximity(187180, 7) -- Demonic Feedback
	end
end

function mod:VoidStarFixate(args)
	self:TargetMessage(189894, args.destName, "Personal", "Alarm")
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

function mod:DemonicFeedback(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 37)
end

