--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Kel'Thuzad", 533)
if not mod then return end
mod:RegisterEnableMob(15990)
mod:SetAllowWin(true)
mod.engageId = 1114
mod.toggleOptions = {27808, 27810, 28410, {27819, "WHISPER", "ICON", "FLASHSHAKE"}, "guardians", "phase", "proximity", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local fbTargets = mod:NewTargetList()
local mcTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Kel'Thuzad"

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
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
function mod:OnRegister()
	local f = CreateFrame("Frame")
	local func = function()
		if not mod:IsEnabled() and GetSubZoneText() == L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] then
			mod:Enable()
		end
	end
	f:SetScript("OnEvent", func)
	f:RegisterEvent("ZONE_CHANGED_INDOORS")
	func()
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Fizzure", 27810)
	self:Log("SPELL_AURA_APPLIED", "FrostBlast", 27808)
	self:Log("SPELL_AURA_APPLIED", "Detonate", 27819)
	self:Log("SPELL_AURA_APPLIED", "MC", 28410)
	self:Death("Win", 15990)

	self.warnedAboutPhase3Soon = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fizzure(_, spellId, _, _, spellName)
	self:Message(27810, spellName, "Important", spellId)
end

do
	local spell = nil
	local name = nil
	local handle = nil
	local function fbWarn()
		mod:TargetMessage(27808, name, fbTargets, "Important", spell, "Alert")
		mod:DelayedMessage(27808, 32, L["frostblast_soon_message"], "Attention")
		mod:Bar(27808, L["frostblast_bar"], 37, spell)
		handle = nil
	end

	function mod:FrostBlast(player, spellId, _, _, spellName)
		spell = spellId
		name = spellName
		fbTargets[#fbTargets + 1] = player
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(fbWarn, 0.4)
	end
end

function mod:Detonate(player, spellId, _, _, spellName)
	self:TargetMessage(27819, spellName, player, "Personal", spellId, "Alert")
	if UnitIsUnit(player, "player") then self:FlashShake(27819) end
	self:Whisper(27819, player, spellName)
	self:PrimaryIcon(27819, player)
	self:Bar(27819, L["detonate_other"]:format(player), 5, spellId)
	self:Bar(27819, L["detonate_possible_bar"], 20, spellId)
	self:DelayedMessage(27819, 15, L["detonate_warning"], "Attention")
end

do
	local spell = nil
	local handle = nil
	local function mcWarn()
		local spellName = GetSpellInfo(605) -- Mind Control
		mod:TargetMessage(28410, spellName, mcTargets, "Important", spell, "Alert")
		mod:Bar(28410, spellName, 20, 28410)
		mod:DelayedMessage(28410, 68, L["mc_warning"], "Urgent")
		mod:Bar(28410, L["mc_nextbar"], 68, spell)
		handle = nil
	end

	function mod:MC(player, spellId)
		spell = spellId
		mcTargets[#mcTargets + 1] = player
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(mcWarn, 0.5)
	end
end

function mod:UNIT_HEALTH(event, msg)
	if UnitName(msg) == mod.displayName then
		local health = UnitHealth(msg) / UnitHealthMax(msg) * 100
		if health > 40 and health <= 43 and not self.warnedAboutPhase3Soon then
			self:Message("phase", L["phase3_soon_warning"], "Attention")
			self.warnedAboutPhase3Soon = true
		elseif health > 60 and self.warnedAboutPhase3Soon then
			self.warnedAboutPhase3Soon = nil
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg == L["start_trigger"] then
		self:Message("phase", L["start_warning"], "Attention")
		self:Bar("phase", L["start_bar"], 215, "Spell_Fire_FelImmolation")
		wipe(mcTargets)
		wipe(fbTargets)
		self:CloseProximity()
		self:Engage()
	elseif msg == L["phase2_trigger1"] or msg == L["phase2_trigger2"] or msg == L["phase2_trigger3"] then
		self:SendMessage("BigWigs_StopBar", self, L["start_bar"])
		self:Message("phase", L["phase2_warning"], "Important")
		self:Bar("phase", L["phase2_bar"], 15, "Spell_Shadow_Charm")
		self:OpenProximity(10)
	elseif msg == L["phase3_trigger"] then
		self:Message("phase", L["phase3_warning"], "Attention")
	elseif msg == L["guardians_trigger"] then
		self:Message("guardians", L["guardians_warning"], "Important")
		self:Bar("guardians", L["guardians_bar"], 10, 28866)
	end
end

