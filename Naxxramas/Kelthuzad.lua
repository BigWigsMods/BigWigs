----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewBoss("Kel'Thuzad", "Naxxramas")
if not mod then return end
mod.enabletrigger = 15990
mod.guid = 15990
mod.toggleOptions = { 27808, 27810, 28410, -1, 27819, "icon", -1 ,"guardians", "phase", "proximity", "bosskill" }
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end

------------------------------
--      Are you local?      --
------------------------------

local fbTargets = mod:NewTargetList()
local mcTargets = mod:NewTargetList()

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kel'Thuzad", "enUS", true)
if L then
	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzad's Chamber"

	L.start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!"
	L.start_warning = "Kel'Thuzad encounter started! ~3min 30sec till he is active!"
	L.start_bar = "Phase 2"

	L.phase = "Phase"
	L.phase_desc = "Warn for phases."
	L.phase2_trigger1 = "Pray for mercy!"
	L.phase2_trigger2 = "Scream your dying breath!"
	L.phase2_trigger3 = "The end is upon you!"
	L.phase2_warning = "Phase 2, Kel'Thuzad incoming!"
	L.phase2_bar = "Kel'Thuzad Active!"
	L.phase3_soon_warning = "Phase 3 soon!"
	L.phase3_trigger = "Master, I require aid!"
	L.phase3_warning = "Phase 3, Guardians in ~15 sec!"

	L.mc_message = "Mind Control: %s"
	L.mc_warning = "Mind controls soon!"
	L.mc_nextbar = "~Mind Controls"

	L.frostblast_bar = "Possible Frost Blast"
	L.frostblast_soon_message = "Possible Frost Blast in ~5 sec!"

	L.detonate_other = "Detonate - %s"
	L.detonate_possible_bar = "Possible Detonate"
	L.detonate_warning = "Next Detonate in 5 sec!"

	L.guardians = "Guardian Spawns"
	L.guardians_desc = "Warn for incoming Icecrown Guardians in phase 3."
	L.guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!"
	L.guardians_warning = "Guardians incoming in ~10sec!"
	L.guardians_bar = "Guardians incoming!"

	L.icon = "Raid Icon"
	L.icon_desc = "Place a raid icon on people with Detonate Mana."
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Kel'Thuzad")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnRegister()
	-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
end

function mod:OnBossDisable()
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
end

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Fizzure", 27810)
	self:AddCombatListener("SPELL_AURA_APPLIED", "FrostBlast", 27808)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Detonate", 27819)
	self:AddCombatListener("SPELL_AURA_APPLIED", "MC", 28410)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self.warnedAboutPhase3Soon = nil

	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ZONE_CHANGED_INDOORS(event, msg)
	if GetMinimapZoneText() ~= L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] or self:IsEnabled() then return end
	-- Activate the Kel'Thuzad mod!
	self:Enable()
end

function mod:Fizzure(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

do
	local spell = nil
	local name = nil
	local function fbWarn()
		mod:TargetMessage(name, fbTargets, "Important", spell, "Alert")
		mod:DelayedMessage(32, L["frostblast_soon_message"], "Attention")
		mod:Bar(L["frostblast_bar"], 37, spell)
	end

	function mod:FrostBlast(player, spellId, _, _, spellName)
		spell = spellId
		name = spellName
		fbTargets[#fbTargets + 1] = player
		self:ScheduleEvent("BWFrostBlastWarn", fbWarn, 0.4)
	end
end

function mod:Detonate(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Personal", spellId, "Alert")
	self:Whisper(player, spellName)
	self:PrimaryIcon(player, "icon")
	self:Bar(L["detonate_other"]:format(player), 5, spellId)
	self:Bar(L["detonate_possible_bar"], 20, spellId)
	self:DelayedMessage(15, L["detonate_warning"], "Attention")
end

do
	local spell = nil
	local function mcWarn()
		local spellName = GetSpellInfo(605) -- Mind Control
		mod:TargetMessage(spellName, mcTargets, "Important", spell, "Alert")
		mod:Bar(spellName, 20, 28410)
		mod:DelayedMessage(68, L["mc_warning"], "Urgent")
		mod:Bar(L["mc_nextbar"], 68, spell)
	end

	function mod:MC(player, spellId)
		spell = spellId
		mcTargets[#mcTargets + 1] = player
		self:ScheduleEvent("BWMCWarn", mcWarn, 0.5)
	end
end

function mod:UNIT_HEALTH(event, msg)
	if not self.db.profile.phase then return end

	if UnitName(msg) == mod.displayName then
		local health = UnitHealth(msg)
		if health > 40 and health <= 43 and not self.warnedAboutPhase3Soon then
			self:Message(L["phase3_soon_warning"], "Attention")
			self.warnedAboutPhase3Soon = true
		elseif health > 60 and self.warnedAboutPhase3Soon then
			self.warnedAboutPhase3Soon = nil
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if self.db.profile.phase and msg == L["start_trigger"] then
		self:Message(L["start_warning"], "Attention")
		self:Bar(L["start_bar"], 215, "Spell_Fire_FelImmolation")
		wipe(mcTargets)
		wipe(fbTargets)
		self:SendMessage("BigWigs_HideProximity", self)
	elseif msg == L["phase2_trigger1"] or msg == L["phase2_trigger2"] or msg == L["phase2_trigger3"] then
		if self.db.profile.phase then
			self:SendMessage("BigWigs_StopBar", self, L["start_bar"])
			self:Message(L["phase2_warning"], "Important")
			self:Bar(L["phase2_bar"], 15, "Spell_Shadow_Charm")
		end
		self:SendMessage("BigWigs_ShowProximity", self)
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:Message(L["phase3_warning"], "Attention")
	elseif self.db.profile.guardians and msg == L["guardians_trigger"] then
		self:Message(L["guardians_warning"], "Important")
		self:Bar(L["guardians_bar"], 10, 28866)
	end
end

