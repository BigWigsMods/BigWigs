--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Freya", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(32906)
mod.toggleOptions = {"phase", "wave", "tree", {62589, "WHISPER", "ICON", "FLASHSHAKE"}, {62623, "ICON"}, "proximity", 62861, {62437, "FLASHSHAKE"}, {62865, "FLASHSHAKE"}, "berserk", "bosskill"}

mod.optionHeaders = {
	phase = "normal",
	[62861] = "hard",
	berserk = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local phase = nil
local root = mod:NewTargetList()
-- XXXLOLHAXBOOBS to prevent us from enabling again after she dies.
-- I never have enough time after she does the yell to do any testing for which Unit* APIs will
-- allow us to properly disable the VerifyEnable check after she does the yell.
-- Perhaps I'll make a script for it next time we go to Ulduar (which might never happen again).
local sheIsDead = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger1 = "The Conservatory must be protected!"
	L.engage_trigger2 = "Elders grant me your strength!"

	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase2_message = "Phase 2!"

	L.wave = "Waves"
	L.wave_desc = "Warn for Waves."
	L.wave_bar = "Next Wave"
	L.conservator_trigger = "Eonar, your servant requires aid!"
	L.detonate_trigger = "The swarm of the elements shall overtake you!"
	L.elementals_trigger = "Children, assist me!"
	L.tree_trigger = "A |cFF00FFFFLifebinder's Gift|r begins to grow!"
	L.conservator_message = "Conservator!"
	L.detonate_message = "Detonating lashers!"
	L.elementals_message = "Elementals!"

	L.tree = "Eonar's Gift"
	L.tree_desc = "Alert when Freya spawns a Eonar's Gift."
	L.tree_message = "Tree is up!"

	L.fury_message = "Fury"
	L.fury_other = "Fury: %s"

	L.tremor_warning = "Ground Tremor soon!"
	L.tremor_bar = "~Next Ground Tremor"
	L.energy_message = "Unstable Energy on YOU!"
	L.sunbeam_message = "Sun beams up!"
	L.sunbeam_bar = "~Next Sun Beams"

	L.end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Energy", 62865, 62451)              --Elder Brightleaf
	self:Log("SPELL_CAST_SUCCESS", "EnergySpawns", 62865, 62451)        --Elder Brightleaf
	self:Log("UNIT_DIED", "Deaths")                                     --Elder Brightleaf
	self:Log("SPELL_AURA_APPLIED", "Root", 62861, 62930, 62283, 62438)  --Elder Ironbranch
	self:Log("SPELL_CAST_START", "Tremor", 62437, 62859, 62325, 62932)  --Elder Stonebark
	self:Log("SPELL_CAST_START", "Sunbeam", 62623, 62872)
	self:Log("SPELL_AURA_APPLIED", "Fury", 62589, 63571)
	self:Log("SPELL_AURA_REMOVED", "FuryRemove", 62589, 63571)
	self:Log("SPELL_AURA_REMOVED", "AttunedRemove", 62519)
	self:Emote("Tree", L["tree_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger1"], L["engage_trigger2"])
	self:Yell("Yells", L["end_trigger"], L["conservator_trigger"], L["detonate_trigger"], L["elementals_trigger"])
end

function mod:OnEngage()
	phase = 1
	self:Berserk(600)
	self:Bar("wave", L["wave_bar"], 11, 35594)
end

function mod:VerifyEnable(unit)
	if sheIsDead then return false end
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local id, name, handle = nil, nil, nil
	local function rootWarn()
		mod:TargetMessage(62861, name, root, "Attention", id, "Info")
		handle = nil
	end
	function mod:Root(player, spellId, _, _, spellName)
		root[#root + 1] = player
		id, name = spellId, spellName
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(rootWarn, 0.2)
	end
end

do
	local _, class = UnitClass("player")
	local function isCaster()
		local power = UnitPowerType("player")
		if power ~= 0 then return end
		if class == "PALADIN" then
			local _, _, points = GetTalentTabInfo(1)
			-- If a paladin has less than 20 points in Holy, he's not a caster.
			-- And so it shall forever be, said the Lord.
			if points < 20 then return end
		end
		return true
	end

	function mod:Tremor(_, spellId, _, _, spellName)
		local caster = isCaster()
		local color = caster and "Personal" or "Attention"
		local sound = caster and "Long" or nil
		self:Message(62437, spellName, color, spellId, sound)
		if caster then self:FlashShake(62437) end
		if phase == 1 then
			self:Bar(62437, spellName, 2, spellId)
			self:Bar(62437, L["tremor_bar"], 30, spellId)
			self:DelayedMessage(62437, 26, L["tremor_warning"], "Attention")
		elseif phase == 2 then
			self:Bar(62437, spellName, 2, spellId)
			self:Bar(62437, L["tremor_bar"], 23, spellId)
			self:DelayedMessage(62437, 20, L["tremor_warning"], "Attention")
		end
	end
end

do
	local id, name, handle = nil, nil, nil
	local function scanTarget()
		local bossId = mod:GetUnitIdByGUID(32906)
		if not bossId then return end
		local target = UnitName(bossId .. "target")
		if target then
			mod:TargetMessage(62623, name, target, "Attention", id)
			mod:SecondaryIcon(62623, target)
		end
		handle = nil
	end

	function mod:Sunbeam(_, spellId, _, _, spellName)
		id, name = spellId, spellName
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(scanTarget, 0.1)
	end
end

function mod:Fury(player, spellId)
	if UnitIsUnit(player, "player") then
		self:OpenProximity(10)
		self:FlashShake(62589)
	end
	self:TargetMessage(62589, L["fury_message"], player, "Personal", spellId, "Alert")
	self:Whisper(62589, player, L["fury_message"])
	self:Bar(62589, L["fury_other"]:format(player), 10, spellId)
	self:PrimaryIcon(62589, player)
end

function mod:FuryRemove(player)
	self:SendMessage("BigWigs_StopBar", self, L["fury_other"]:format(player))
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
end

function mod:AttunedRemove()
	phase = 2
	self:SendMessage("BigWigs_StopBar", self, L["wave_bar"])
	self:Message("phase", L["phase2_message"], "Important")
end

do
	local last = nil
	function mod:Energy(player)
		if UnitIsUnit(player, "player") then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(62865, L["energy_message"], "Personal",  62451, "Alarm")
				self:FlashShake(62865)
				last = t
			end
		end
	end
end

do
	local sunBeamName = nil
	local last = nil
	function mod:EnergySpawns(unit, spellId, _, _, spellName)
		local t = GetTime()
		if not last or (t > last + 10) then
			sunBeamName = unit
			self:Message(62865, L["sunbeam_message"], "Important", spellId)
			last = t
		end
	end
	function mod:Deaths(event, name)
		if not sunBeamName or name ~= sunBeamName then return end
		self:Bar(62865, L["sunbeam_bar"], 35, 62865)
	end
end

function mod:Tree()
	self:Message("tree", L["tree_message"], "Urgent", 5420, "Alarm")
end

function mod:Yells(msg)
	if msg == L["end_trigger"] then
		-- Never enable again this session!
		sheIsDead = true
		self:Win()
	elseif msg == L["conservator_trigger"] then
		self:Message("wave", L["conservator_message"], "Positive", 35594)
		self:Bar("wave", L["wave_bar"], 60, 35594)
	elseif msg == L["detonate_trigger"] then
		self:Message("wave", L["detonate_message"], "Positive", 35594)
		self:Bar("wave", L["wave_bar"], 60, 35594)
	elseif msg == L["elementals_trigger"] then
		self:Message("wave", L["elementals_message"], "Positive", 35594)
		self:Bar("wave", L["wave_bar"], 60, 35594)
	end
end

