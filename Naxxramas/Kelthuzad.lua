--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Kel'Thuzad", 533)
if not mod then return end
mod:RegisterEnableMob(15990)
mod:SetAllowWin(true)
mod.engageId = 1114

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
	L.start_warning = "Kel'Thuzad encounter started! ~5min until he is active!"

	L.phase2_trigger1 = "Pray for mercy!"
	L.phase2_trigger2 = "Scream your dying breath!"
	L.phase2_trigger3 = "The end is upon you!"
	L.phase2_warning = "Phase 2 - Kel'Thuzad incoming!"
	L.phase2_bar = "Kel'Thuzad Active!"

	L.phase3_trigger = "Master, I require aid!"
	L.phase3_soon_warning = "Phase 3 soon!"
	L.phase3_warning = "Phase 3 - Guardians in ~15 sec!"

	L.guardians = "Guardian Spawns"
	L.guardians_desc = "Warn for incoming Icecrown Guardians in phase 3."
	L.guardians_icon = 28866 -- inv_trinket_naxxramas04
	L.guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!"
	L.guardians_warning = "Guardians incoming in ~10sec!"
	L.guardians_bar = "Guardians incoming!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		27808, -- Frost Blast
		27810, -- Shadow Fissure
		28410, -- Chains of Kel'Thuzad
		{27819, "ICON", "FLASH"}, -- Detonate Mana
		"guardians",
		"stages",
		"proximity",
	}
end

-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
function mod:OnRegister()
	local f = CreateFrame("Frame")
	local func = function()
		if not mod:IsEnabled() and GetSubZoneText() == L.KELTHUZADCHAMBERLOCALIZEDLOLHAX then
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
	self:Log("SPELL_AURA_APPLIED", "ChainsOfKelThuzad", 28410)

	self:BossYell("Engage", L.start_trigger)
	self:BossYell("Phase2", L.phase2_trigger1, L.phase2_trigger2, L.phase2_trigger3)
	self:BossYell("Phase3", L.phase3_trigger)
	self:BossYell("Guardians", L.guardians_trigger)
	self:Death("Win", 15990)
end

function mod:OnEngage()
	wipe(mcTargets)
	wipe(fbTargets)
	self:CloseProximity("proximity")

	self:Message("stages", "yellow", L.start_warning, false) -- CL.custom_start:format(L.bossName, _G.ACTIVE_PETS, 5)
	self:Bar("stages", 310, CL.phase:format(2), "Spell_Fire_FelImmolation")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Phase2()
	self:StopBar(CL.phase:format(2))

	self:Message("stages", "cyan", L.phase2_warning, false)
	self:PlaySound("stages", "info")
	self:Bar("stages", 15, L.phase2_bar, "Spell_Shadow_Charm")
	self:OpenProximity("proximity", 10)
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

function mod:Phase3()
	self:Message("stages", "cyan", L.phase3_warning, false)
	self:PlaySound("stages", "info")
end

function mod:Guardians()
	self:Message("guardians", "red", L.guardians_warning, L.guardians_icon)
	self:Bar("guardians", 10, L.guardians_bar, L.guardians_icon)
end

function mod:Fizzure(args)
	self:Message(27810, "red")
end

function mod:FrostBlast(args)
	fbTargets[#fbTargets + 1] = args.destName
	self:TargetsMessage(27808, "red", fbTargets, 0, nil, nil, 0.4)
	if self:Me(args.destGUID) then
		self:PlaySound(27808, "alert")
	end
	if #fbTargets == 1 then
		self:DelayedMessage(27808, 20, "yellow", CL.soon:format(args.spellName))
		self:CDBar(27808, 25)
	end
end

function mod:Detonate(args)
	self:TargetMessage(27819, "yellow", args.destName, self:SpellName(20789)) -- 20789 = Detonate
	if self:Me(args.destGUID) then
		self:PlaySound(27819, "alert")
		self:Flash(27819)
	end
	self:PrimaryIcon(27819, args.destName)
	self:TargetBar(27819, 5, args.destName, self:SpellName(20789))
	self:CDBar(27819, 20, self:SpellName(20789))
	self:DelayedMessage(27819, 15, "yellow", CL.soon:format(self:SpellName(20789)))
end

function mod:ChainsOfKelThuzad(args)
	mcTargets[#mcTargets + 1] = args.destName
	self:TargetsMessage(28410, "red", mcTargets, 5, self:SpellName(605), nil, 0.5) -- 605 = Mind Control
	if self:Me(args.destGUID) then
		self:PlaySound(28410, "alert")
	end
	if #mcTargets == 1 then
		self:Bar(28410, 20, mod:SpellName(605))
		self:DelayedMessage(28410, 68, "orange", CL.soon:format(self:SpellName(605)))
		self:CDBar(28410, 68, self:SpellName(605))
	end
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(UnitGUID(unit)) == 15990 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp < 46 then
			self:Message("stages", "cyan", L.phase3_soon_warning, false)
			self:PlaySound("stages", "info")
			self:UnregisterEvent(event, "target", "focus")
		end
	end
end
