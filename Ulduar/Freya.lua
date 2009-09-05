----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Freya"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
mod.bossName = boss
mod.zoneName = "Ulduar"
mod.enabletrigger = 32906
mod.guid = 32906
mod.toggleOptions = {"phase", "wave", "tree", 62589, 62623, "icon", "proximity", 62861, 62437, 62865, "berserk", "bosskill"}
mod.optionHeaders = {
	phase = CL.normal,
	[62861] = CL.hard,
	berserk = CL.general,
}
mod.proximityCheck = "bandage"
mod.consoleCmd = "Freya"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local phase = nil
local pName = UnitName("player")
local fmt = string.format
local root = mod:NewTargetList()

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Freya", "enUS", true)
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

	L.icon = "Place Icon"
	L.icon_desc = "Place a Raid Target Icon on the player targetted by Sunbeam and Nature's Fury. (requires promoted or higher)"

	L.end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes."
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Freya")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Energy", 62865, 62451)             -- Elder Brightleaf
	self:AddCombatListener("SPELL_CAST_SUCCESS", "EnergySpawns", 62865, 62451)       -- Elder Brightleaf
	self:AddCombatListener("UNIT_DIED", "Deaths")                                    -- Elder Brightleaf
	self:AddCombatListener("SPELL_AURA_APPLIED", "Root", 62861, 62930, 62283, 62438) -- Elder Ironbranch
	self:AddCombatListener("SPELL_CAST_START", "Tremor", 62437, 62859, 62325, 62932) -- Elder Stonebark
	self:AddCombatListener("SPELL_CAST_START", "Sunbeam", 62623, 62872)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fury", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FuryRemove", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "AttunedRemove", 62519)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

local function rootWarn(spellId, spellName)
	mod:TargetMessage(spellName, root, "Attention", spellId, "Info")
end

function mod:Root(player, spellId, _, _, spellName)
	root[#root + 1] = player
	self:ScheduleEvent("BWrootWarn", rootWarn, 0.2, spellId, spellName)
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
		self:IfMessage(spellName, color, spellId, sound)
		if phase == 1 then
			self:Bar(spellName, 2, spellId)
			self:Bar(L["tremor_bar"], 30, spellId)
			self:DelayedMessage(26, L["tremor_warning"], "Attention")
		elseif phase == 2 then
			self:Bar(spellName, 2, spellId)
			self:Bar(L["tremor_bar"], 23, spellId)
			self:DelayedMessage(20, L["tremor_warning"], "Attention")
		end
	end
end

local function scanTarget(spellId, spellName)
	local target
	if UnitName("target") == mod.bossName then
		target = UnitName("targettarget")
	elseif UnitName("focus") == mod.bossName then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == mod.bossName then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		mod:TargetMessage(spellName, target, "Attention", spellId)
		mod:SecondaryIcon(target, "icon")
		mod:CancelScheduledEvent("BWsunbeamToTScan")
	end
end

function mod:Sunbeam(_, spellId, _, _, spellName)
	self:ScheduleEvent("BWsunbeamToTScan", scanTarget, 0.1, spellId, spellName)
end

function mod:Fury(player, spellId)
	if player == pName then
		self:SendMessage("BigWigs_ShowProximity", self)
	end
	self:TargetMessage(L["fury_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["fury_message"])
	self:Bar(L["fury_other"]:format(player), 10, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:FuryRemove(player)
	self:SendMessage("BigWigs_StopBar", self, L["fury_other"]:format(player))
	if player == pName then
		self:SendMessage("BigWigs_HideProximity", self)
	end
end

function mod:AttunedRemove()
	phase = 2
	self:SendMessage("BigWigs_StopBar", self, L["wave_bar"])
	if db.phase then
		self:IfMessage(L["phase2_message"], "Important")
	end
end

do
	local last = nil
	function mod:Energy(player)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["energy_message"], "Personal",  62451, "Alarm")
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
			self:IfMessage(L["sunbeam_message"], "Important", spellId)
			last = t
		end
	end
	function mod:Deaths(name)
		if not sunBeamName or name ~= sunBeamName then return end
		self:Bar(L["sunbeam_bar"], 35, 62865)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["tree_trigger"] and db.tree then
		self:IfMessage(L["tree_message"], "Urgent", 5420, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger1"] or msg == L["engage_trigger2"] then
		phase = 1
		if db.berserk then
			self:Enrage(600, true)
		end
		if db.wave then
			--35594, looks like a wave :)
			self:Bar(L["wave_bar"], 11, 35594)
		end
	elseif msg == L["conservator_trigger"] and db.wave then
		self:IfMessage(L["conservator_message"], "Positive", 35594)
		self:Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["detonate_trigger"] and db.wave then
		self:IfMessage(L["detonate_message"], "Positive", 35594)
		self:Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["elementals_trigger"] and db.wave then
		self:IfMessage(L["elementals_message"], "Positive", 35594)
		self:Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["end_trigger"] then
		self:BossDeath(nil, self.guid)
	end
end

