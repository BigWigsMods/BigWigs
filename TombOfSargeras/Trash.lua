
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tomb of Sargeras Trash", 1676)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Pre Goroth ]]--
	118022, -- Infernal Chaosbringer

	--[[ Goroth -> Demonic Inquisition ]]--
	121003, -- Rez the Tombwatcher

	--[[ Goroth -> Harjatan ]]--

	--[[ Goroth -> Sisters of the Moon ]]--
	120020, --Erdu'val
	120851, -- Hippogryph Lord Varah

	--[[ Harjatan -> Mistress Sassz'ine ]]--
	120482, -- Tidescale Seacaller
	120463, -- Undersea Custodian
	120012, -- Dresanoth
	120013, -- The Dread Stalker
	120003, --Warlord Darjah

	--[[ Sisters of the Moon -> The Desolate Host ]]--
	120777, -- Guardian Sentry
	120194, -- Ghostly Acolyte
	120019, -- Ryul the Fading

	--[[ Pre Maiden of Vigilance ]]--

	--[[ Maiden of Vigilance -> Fallen Avatar ]]--
	120449 -- Defensive Countermeasure

	--[[ Fallen Avatar -> Kil'jaeden ]]--

)

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rune = "Orcish Rune"

	--[[ Pre Goroth ]]--
	L.chaosbringer = "Infernal Chaosbringer"

	--[[ Goroth -> Demonic Inquisition ]]--
	L.rez = "Rez the Tombwatcher"

	--[[ Goroth -> Harjatan ]]--

	--[[ Goroth -> Sisters of the Moon ]]--
	L.erduval = "Erdu'val"
	L.varah = "Hippogryph Lord Varah"

	--[[ Harjatan -> Mistress Sassz'ine ]]--
	L.seacaller = "Tidescale Seacaller"
	L.custodian = "Undersea Custodian"
	L.dresanoth = "Dresanoth"
	L.stalker = "The Dread Stalker"
	L.darjah = "Warlord Darjah"

	--[[ Sisters of the Moon -> The Desolate Host ]]--
	L.sentry = "Guardian Sentry"
	L.acolyte = "Ghostly Acolyte"
	L.ryul = "Ryul the Fading"

	--[[ Pre Maiden of Vigilance ]]--

	--[[ Maiden of Vigilance -> Fallen Avatar ]]--
	L.countermeasure = "Defensive Countermeasure"

	--[[ Fallen Avatar -> Kil'jaeden ]]--
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{241742, "FLASH"}, -- Curse of Gul'dan (Orcish Rune)

		--[[ Pre Goroth ]]--
		242909, -- Massive Eruption (Infernal Chaosbringer)

		--[[ Goroth -> Demonic Inquisition ]]--
		241262, -- Felburn (Rez the Tombwatcher)

		--[[ Goroth -> Harjatan ]]--

		--[[ Goroth -> Sisters of the Moon ]]--
		241301, -- Wall of Doom (Erdu'val)
		{241171, "SAY", "PROXIMITY"}, -- Lunar Bomb (Hippogryph Lord Varah)
		241169, -- Umbra Destruction (Hippogryph Lord Varah)

		--[[ Harjatan -> Mistress Sassz'ine ]]--
		{240599, "SAY", "PROXIMITY"}, -- Embrace of the Tides (Tidescale Seacaller)
		240169, -- Electric Shock (Undersea Custodian)
		240176, -- Lightning Stork (Undersea Custodian)
		241254, -- Frost-Fingered Fear (Dresanoth)
		{241289, "FLASH"}, -- Mist Filled Pools (Dresanoth)
		{241267, "TANK"}, -- Icy Talons (Dresanoth)
		241703, -- Blood Siphon (The Dread Stalker)
		241716, -- Blood Drain (The Dread Stalker)
		{241465, "TANK"}, -- Coral Cut (Warlord Darjah)
		241446, -- Sonic Scream (Warlord Darjah)
		{241480, "FLASH"}, -- Summon Steam Elemental (Warlord Darjah)

		--[[ Sisters of the Moon -> The Desolate Host ]]--
		{240735, "SAY"}, -- Polymorph Bomb (Guardian Sentry)
		{239741, "SAY"}, -- Anguish (Ghostly Acolyte)
		{241367, "FLASH"}, -- Anguishing Strike (Ryul the Fading)
		{241675, "SAY", "PROXIMITY"}, -- Void Rift (Ryul the Fading)
		241646, -- Soul Portal (Ryul the Fading)

		--[[ Pre Maiden of Vigilance ]]--

		--[[ Maiden of Vigilance -> Fallen Avatar ]]--
		241374, -- Luminescent Barrier

		--[[ Fallen Avatar -> Kil'jaeden ]]--

	}, {
		[241742] = L.rune,
		[242909] = L.chaosbringer,
		[241262] = L.rez,
		[241301] = L.erduval,
		[241171] = L.varah,
		[240599] = L.seacaller,
		[240169] = L.custodian,
		[241254] = L.dresanoth,
		[241703] = L.stalker,
		[241465] = L.darjah,
		[240735] = L.sentry,
		[239741] = L.acolyte,
		[241367] = L.ryul,
		[241374] = L.countermeasure,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 241262, 241169, 240176, 241703) -- Felburn, Umbra Destruction, Lightning Storm, Blood Siphon
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 241262, 241169, 240176, 241703)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 241262, 241169, 240176, 241703)

	self:Log("SPELL_AURA_APPLIED", "CurseOfGuldan", 241742)
	self:Log("SPELL_AURA_REMOVED", "CurseOfGuldanRemoved", 241742)

	--[[ Pre Goroth ]]--
	self:Log("SPELL_CAST_START", "MassiveEruption", 242909)

	--[[ Goroth -> Demonic Inquisition ]]--


	--[[ Goroth -> Harjatan ]]--


	--[[ Goroth -> Sisters of the Moon ]]--
	self:Log("SPELL_CAST_START", "WallOfDoom", 241301)
	self:Log("SPELL_AURA_APPLIED", "LunarBomb", 241171)
	self:Log("SPELL_AURA_REMOVED", "LunarBombRemoved", 241171)

	--[[ Harjatan -> Mistress Sassz'ine ]]--
	self:Log("SPELL_AURA_APPLIED", "EmbraceOfTheTides", 240599)
	self:Log("SPELL_AURA_REMOVED", "EmbraceOfTheTidesRemoved", 240599)
	self:Log("SPELL_CAST_START", "ElectricShock", 240169)
	self:Log("SPELL_CAST_START", "FrostFingeredFear", 241254)
	self:Log("SPELL_CAST_START", "MistFilledPools", 241289)
	self:Log("SPELL_AURA_APPLIED", "IcyTalons", 241267)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IcyTalons", 241267)
	self:Log("SPELL_CAST_SUCCESS", "BloodDrain", 241716)
	self:Log("SPELL_AURA_APPLIED", "BloodDrainApplied", 241716)
	self:Log("SPELL_AURA_REMOVED", "BloodDrainRemoved", 241716)
	self:Log("SPELL_DISPEL", "BloodDrainDispelled", "*")
	self:Log("SPELL_AURA_APPLIED", "CoralCut", 241465)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CoralCut", 241465)
	self:Log("SPELL_AURA_REMOVED", "CoralCutRemoved", 241465)
	self:Log("SPELL_CAST_START", "SonicScream", 241446)
	self:Log("SPELL_CAST_SUCCESS", "SummonSteamElemental", 241480)


	--[[ Sisters of the Moon -> The Desolate Host ]]--
	self:Log("SPELL_AURA_APPLIED", "PolymorphBomb", 240735)
	self:Log("SPELL_AURA_REMOVED", "PolymorphBombRemoved", 240735)
	self:Log("SPELL_AURA_APPLIED", "Anguish", 239741)
	self:Log("SPELL_AURA_REMOVED", "AnguishRemoved", 239741)
	self:Log("SPELL_CAST_SUCCESS", "AnguishingStrike", 241367)
	self:Log("SPELL_AURA_APPLIED", "AnguishingStrikeApplied", 241367)
	self:Log("SPELL_AURA_APPLIED", "VoidRift", 241675)
	self:Log("SPELL_AURA_REMOVED", "VoidRiftRemoved", 241675)
	self:Log("SPELL_CAST_SUCCESS", "SoulPortal", 241646)

	--[[ Pre Maiden of Vigilance ]]--


	--[[ Maiden of Vigilance -> Fallen Avatar ]]--
	self:Log("SPELL_CAST_SUCCESS", "LuminescentBarrier", 241374)

	--[[ Fallen Avatar -> Kil'jaeden ]]--

end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:CurseOfGuldan(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 180, args.destName)
	self:Flash(args.spellId)
end

function mod:CurseOfGuldanRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

--[[ Pre Goroth ]]--
do
	local prev = 0
	function mod:MassiveEruption(args)
		local t = GetTime()
		if t-prev > 3 then
			self:Message(args.spellId, "Urgent", "Long")
		end
	end
end

--[[ Goroth -> Demonic Inquisition ]]--


--[[ Goroth -> Harjatan ]]--


--[[ Goroth -> Sisters of the Moon ]]--
function mod:WallOfDoom(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 6.1)
end

function mod:LunarBomb(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	self:TargetBar(args.spellId, 10, args.destName)

	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 10)
	end
end

function mod:LunarBombRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

--[[ Harjatan -> Mistress Sassz'ine ]]--
function mod:EmbraceOfTheTides(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
	self:TargetBar(args.spellId, 20, args.destName)
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 8)
		self:Say(args.spellId)
	end
end

function mod:EmbraceOfTheTidesRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:ElectricShock(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CastBar(args.spellId, 4)
end

function mod:FrostFingeredFear(args)
	local fear = self:SpellName(5782) -- "Fear"
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(fear))
	self:CDBar(args.spellId, 31, fear)
end

function mod:MistFilledPools(args)
	self:Flash(args.spellId)
	self:Message(args.spellId, "Important", "Warning", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 23)
end

function mod:IcyTalons(args)
	if self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 3 and "Alarm")
		self:StopBar(CL.count:format(args.spellName, amount-1), args.destName)
		self:TargetBar(args.spellId, 20, args.destName, CL.count:format(args.spellName, amount))
	end
end

function mod:BloodDrain(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning", nil, nil, self:Dispeller("magic"))
	self:Bar(args.spellId, 13.3)
end

function mod:BloodDrainApplied(args)
	if self:Me(args.destGUID) or self:Dispeller("magic") then
		self:Flash(args.spellId)
	end
	self:TargetBar(args.spellId, 3, args.destName)
end

function mod:BloodDrainRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

function mod:BloodDrainDispelled(args)
	if args.extraSpellId == 241716 then
		self:Message(241716, "Positive", "Info", CL.removed_by:format(args.extraSpellName, self:ColorName(args.sourceName)))
	end
end

function mod:CoralCut(args)
	if self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention")
		if not self:Me(args.destGUID) and amount > 1 and self:Tank() and not self:UnitDebuff("player", args.spellName) then
			self:PlaySound(args.spellId, "Warning")
		end
		self:StopBar(CL.count:format(args.spellName, amount-1), args.destName)
		self:TargetBar(args.spellId, 15, args.destName, CL.count:format(args.spellName, amount))
	end
end

function mod:CoralCutRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", self:Tank() and "Warning", CL.removed:format(args.spellName))
	else
		self:Message(args.spellId, "Positive", nil, CL.removed_from:format(args.spellName, self:ColorName(args.destName)))
	end
end

function mod:SonicScream(args)
	self:Message(args.spellId, "Important", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 2)
end

function mod:SummonSteamElemental(args)
	self:Message(args.spellId, "Urgent")
	if self:Damager() then
		self:Flash(args.spellId)
		self:PlaySound(args.spellId, "Warning")
	end
	self:CDBar(args.spellId, 32)
end

--[[ Sisters of the Moon -> The Desolate Host ]]--
function mod:PolymorphBomb(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 10, args.destName)

	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 10)
	end
end

function mod:PolymorphBombRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:Anguish(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 6, args.destName)

	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:AnguishRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:AnguishingStrike(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning", nil, nil, self:Tank())
	self:Bar(args.spellId, 15.8)
	if not self:Me(args.destGUID) and self:Tank() then
		self:Flash(args.spellId)
	end
end

function mod:AnguishingStrikeApplied(args)
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:VoidRift(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert")
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 10)
		self:Say(args.spellId)
	end
end

function mod:VoidRiftRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:SoulPortal(args)
	self:Message(args.spellId, "Positive", nil, CL.spawned:format(args.spellName))
	self:Bar(args.spellId, 15.8)
end

--[[ Pre Maiden of Vigilance ]]--


--[[ Maiden of Vigilance -> Fallen Avatar ]]--
function mod:LuminescentBarrier(args)
	self:Message(args.spellId, "Attention", self:Dispeller("magic", true) and "Warning", CL.on:format(args.spellName, args.sourceName))
end

--[[ Fallen Avatar -> Kil'jaeden ]]--
