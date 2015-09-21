
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hellfire High Council", 1026, 1432)
if not mod then return end
mod:RegisterEnableMob(92142, 92144, 92146) -- Blademaster Jubei'thos, Dia Darkwhisper, Gurtogg Bloodboil
mod.engageId = 1798
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local horrorCount = 1
local leapCount = 0
local felRageCount = 1

local diaIsDead = false
local gurtoggIsDead = false
local jubeiIsDead = false
local nextAbility = 0 -- 1: horror, 2: mirror, 3: leap
local nextAbilityTime = 0
local startHorrorCD, startMirrorCD, startLeapCD

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Dia Darkwhisper ]]--
		184449, -- Mark of the Necromancer
		{184476, "SAY", "PROXIMITY"}, -- Reap
		{184657, "TANK_HEALER"}, -- Nightmare Visage
		184681, -- Wailing Horror
		--[[ Gurtogg Bloodboil ]]--
		{184358, "ICON"}, -- Fel Rage
		184355, -- Bloodboil
		{184847, "TANK"}, -- Acidic Wound
		184366, -- Demolishing Leap
		--[[ Blademaster Jubei'thos ]]--
		--183210, -- Fel Blade
		183885, -- Mirror Images
		"berserk",
	}, {
		[184449] = -11489, -- Dia Darkwhisper
		[184358] = -11490, -- Gurtogg Bloodboil
		[183885] = -11488, -- Blademaster Jubei'thos
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	-- Dia Darkwhisper
	self:Log("SPELL_AURA_APPLIED", "MarkOfTheNecromancer", 184449, 184676) -- 184676: 30% Mark of the Necromancer
	self:Log("SPELL_CAST_START", "Reap", 184476)
	self:Log("SPELL_CAST_SUCCESS", "ReapOver", 184476)
	self:Log("SPELL_CAST_START", "NightmareVisage", 184657)

	self:Log("SPELL_AURA_APPLIED", "ReapDamage", 184652)
	self:Log("SPELL_PERIODIC_DAMAGE", "ReapDamage", 184652)
	self:Log("SPELL_PERIODIC_MISSED", "ReapDamage", 184652)
	-- Gurtogg Bloodboil
	self:Log("SPELL_AURA_APPLIED", "FelRage", 184360)
	self:Log("SPELL_AURA_REMOVED", "FelRageRemoved", 184360)
	self:Log("SPELL_AURA_APPLIED", "Bloodboil", 184355)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BloodboilDose", 184355)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcidicWound", 184847)
	self:Log("SPELL_AURA_APPLIED", "DemolishingLeapStart", 184365)
	self:Log("SPELL_CAST_SUCCESS", "DemolishingLeapStart", 184366)
	self:Log("SPELL_AURA_REMOVED", "DemolishingLeapStop", 184365)
	-- Blademaster Jubei'thos
	self:Log("SPELL_CAST_SUCCESS", "MirrorImages", 183885)

	self:Death("DiaDeath", 92144)
	self:Death("GurtoggDeath", 92146)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")
end

function mod:OnEngage()
	horrorCount, leapCount, felRageCount = 1, 0, 1
	diaIsDead, gurtoggIsDead, jubeiIsDead = false, false, false
	nextAbility = 1

	self:Berserk(600)
	startHorrorCD(self)
	self:Bar(184358, 30) -- Gurtogg Bloodboil : Fel Rage
	self:CDBar(184449, 6.3) -- Dia Darkwhisper : Mark of the Necromancer, 6.3-7.5
	self:CDBar(184476, 67) -- Dia Darkwhisper : Reap, 66-69

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	function startLeapCD(self, remaining)
		if diaIsDead and jubeiIsDead and gurtoggIsDead then return end
		remaining = remaining or 72
		if gurtoggIsDead then
			startHorrorCD(self, remaining)
		else
			self:CDBar(184366, remaining) -- Demolishing Leap
			nextAbility = 3
			nextAbilityTime = GetTime() + remaining
		end
	end

	function mod:DemolishingLeapStart(args)
		-- Start initial bar on buff gain (happens once) then every other bar on spell completion
		self:Message(184366, "Important", nil, CL.incoming:format(args.spellName))
		leapCount = leapCount + 1
		self:Bar(184366, leapCount == 1 and 4.8 or 5.8, CL.count:format(args.spellName, leapCount))
		if args.spellId == 184365 then
			startHorrorCD(self)
		end
	end

	function mod:DemolishingLeapStop(args)
		self:StopBar(CL.count:format(args.spellName, leapCount))
		leapCount = 0
	end
end

do
	local prev = 0
	function mod:MarkOfTheNecromancer(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(184449, "Attention")

			if args.spellId == 184676 then -- 30% Mark of the Necromancer
				self:StopBar(184476) -- Reap
				self:StopBar(184449) -- Mark of the Necromancer
			end
		end
	end
end

do
	local prev = 0
	function mod:MarkOfTheNecromancerApplied(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 5 then -- If many people die or are dispelled, multiple debuffs can apply to you at the same time
				prev = t
				self:Say(184476)
				self:OpenProximity(184476, 5) -- 5 yard guess
				self:Message(184476, "Personal", "Alarm", ("%s (%s)"):format(CL.you:format(self:SpellName(184476)), self:SpellName(135856))) -- 135856 = Dispel
			end
		end
	end
end

function mod:Reap(args)
	if UnitDebuff("player", self:SpellName(184449)) then -- Mark of the Necromancer
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 5) -- 5 yard guess
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
	else
		self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
		self:Log("SPELL_AURA_APPLIED", "MarkOfTheNecromancerApplied", 184450, 185065, 185066)
	end
	self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
	self:Bar(184449, 14) -- Mark of the Necromancer
	self:CDBar(args.spellId, 66) -- 66-67
end

function mod:ReapOver(args)
	self:CloseProximity(args.spellId)
	self:RemoveLog("SPELL_AURA_APPLIED", 184450, 185065, 185066)
end

do
	local timers = {0, 67, 76, 82} -- pretty consistent now
	function mod:FelRage(args)
		self:TargetMessage(184358, args.destName, "Urgent", "Warning")
		self:TargetBar(184358, 25, args.destName)
		self:PrimaryIcon(184358, args.destName)

		felRageCount = felRageCount + 1
		local timer = timers[felRageCount]
		if timer then
			self:CDBar(184358, timer)
		end
	end
end

function mod:FelRageRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(184358)
end

function mod:NightmareVisage(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 16, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 32) -- 32 - 35
end

do
	function startHorrorCD(self, remaining)
		if diaIsDead and jubeiIsDead and gurtoggIsDead then return end
		remaining = remaining or 75
		if diaIsDead then
			startMirrorCD(self, remaining)
		else
			self:CDBar(184681, remaining, CL.count:format(self:SpellName(184681), horrorCount)) -- Wailing Horror
			nextAbility = 1
			nextAbilityTime = GetTime() + remaining
		end
	end

	function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
		if msg:find("184681", nil, true) then
			self:Message(184681, "Urgent", "Alert", CL.count:format(self:SpellName(184681), horrorCount))
			horrorCount = horrorCount + 1
			startMirrorCD(self)
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:Bloodboil(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
		end
	end
end

function mod:BloodboilDose(args)
	if self:Me(args.destGUID) and args.amount > 2 and self:Mythic() then
		self:Message(args.spellId, "Personal", "Alert", CL.you:format(CL.count:format(args.spellName, args.amount)))
	end
end

function mod:AcidicWound(args)
	if args.amount % 5 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
	end
end

do
	function startMirrorCD(self, remaining)
		if diaIsDead and jubeiIsDead and gurtoggIsDead then return end
		remaining = remaining or 78
		if jubeiIsDead then
			startLeapCD(self, remaining)
		else
			self:CDBar(183885, remaining) -- Mirror Images
			nextAbility = 2
			nextAbilityTime = GetTime() + remaining
		end
	end

	function mod:MirrorImages(args)
		self:Message(args.spellId, "Attention")
		startLeapCD(self)
	end
end

do
	local prev = 0
	function mod:ReapDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(184476, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 190607 then -- Ghostly, Blademaster Jubei'thos dies
		jubeiIsDead = true
		if nextAbility == 2 then -- mirror
			startLeapCD(self, nextAbilityTime - GetTime())
			self:StopBar(183885) -- Mirror Images
		end
	end
end

function mod:DiaDeath(args)
	diaIsDead = true
	self:StopBar(184657) -- Nightmare Visage
	self:StopBar(CL.cast:format(self:SpellName(184657))) -- Nightmare Visage cast
	if nextAbility == 1 then -- horror
		startMirrorCD(self, nextAbilityTime - GetTime())
		self:StopBar(CL.count:format(self:SpellName(184681), horrorCount)) -- Wailing Horror
	end
end

function mod:GurtoggDeath(args)
	gurtoggIsDead = true
	if nextAbility == 3 then -- leap
		startHorrorCD(self, nextAbilityTime - GetTime())
		self:StopBar(184366) -- Demolishing Leap
	end
	self:StopBar(184358) -- Fel Rage
end

