
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tomb of Sargeras Trash", 1147)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Pre Goroth ]]--
	118022, -- Infernal Chaosbringer

	--[[ Goroth -> Demonic Inquisition ]]--
	121003, -- Rez the Tombwatcher

	--[[ Goroth -> Harjatan ]]--

	--[[ Goroth -> Sisters of the Moon ]]--

	--[[ Harjatan -> Mistress Sassz'ine ]]--
	120482, -- Tidescale Seacaller
	120463, -- Undersea Custodian
	120012, -- Dresanoth

	--[[ Sisters of the Moon -> The Desolate Host ]]--
	120777 -- Guardian Sentry

	--[[ Pre Maiden of Vigilance ]]--

	--[[ Maiden of Vigilance -> Fallen Avatar ]]--

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
	--[[ Pre Goroth ]]--
	L.chaosbringer = "Infernal Chaosbringer"

	--[[ Goroth -> Demonic Inquisition ]]--
	L.rez = "Rez the Tombwatcher"

	--[[ Goroth -> Harjatan ]]--

	--[[ Goroth -> Sisters of the Moon ]]--

	--[[ Harjatan -> Mistress Sassz'ine ]]--
	L.seacaller = "Tidescale Seacaller"
	L.custodian = "Undersea Custodian"
	L.dresanoth = "Dresanoth",

	--[[ Sisters of the Moon -> The Desolate Host ]]--
	L.sentry = "Guardian Sentry"

	--[[ Pre Maiden of Vigilance ]]--

	--[[ Maiden of Vigilance -> Fallen Avatar ]]--

	--[[ Fallen Avatar -> Kil'jaeden ]]--
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		--[[ Pre Goroth ]]--
		242909, -- Massive Eruption (Infernal Chaosbringer)

		--[[ Goroth -> Demonic Inquisition ]]--
		241262, -- Felburn (Rez the Tombwatcher)

		--[[ Goroth -> Harjatan ]]--

		--[[ Goroth -> Sisters of the Moon ]]--

		--[[ Harjatan -> Mistress Sassz'ine ]]--
		{240599, "SAY", "PROXIMITY"}, -- Embrace of the Tides (Tidescale Seacaller)
		240169, -- Electric Shock (Undersea Custodian)
		240176, -- Lightning Stork (Undersea Custodian)
		241254, -- Frost-Fingered Fear (Dresanoth)
		{241289, "FLASH"}, -- Mist Filled Pools (Dresanoth)
		{241267, "TANK"}, -- Icy Talons (Dresanoth)

		--[[ Sisters of the Moon -> The Desolate Host ]]--
		{240735, "SAY"}, -- Polymorph Bomb (Guardian Sentry)

		--[[ Pre Maiden of Vigilance ]]--

		--[[ Maiden of Vigilance -> Fallen Avatar ]]--

		--[[ Fallen Avatar -> Kil'jaeden ]]--

	}, {
		[242909] = L.chaosbringer,
		[241262] = L.rez,
		[240599] = L.seacaller,
		[240169] = L.custodian,
		[241254] = L.dresanoth,
		[240735] = L.sentry,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 241262, 240176) -- Felburn, Lightning Storm
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 241262, 240176)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 241262, 240176)

	--[[ Pre Goroth ]]--
	self:Log("SPELL_CAST_START", "MassiveEruption", 242909)

	--[[ Goroth -> Demonic Inquisition ]]--


	--[[ Goroth -> Harjatan ]]--


	--[[ Goroth -> Sisters of the Moon ]]--


	--[[ Harjatan -> Mistress Sassz'ine ]]--
	self:Log("SPELL_AURA_APPLIED", "EmbraceOfTheTides", 240599)
	self:Log("SPELL_AURA_REMOVED", "EmbraceOfTheTidesRemoved", 240599)
	self:Log("SPELL_CAST_START", "ElectricShock", 240169)
	self:Log("SPELL_CAST_START", "FrostFingeredFear", 241254)
	self:Log("SPELL_CAST_START", "MistFilledPools", 241289)
	self:Log("SPELL_AURA_APPLIED", "IcyTalons", 241267)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IcyTalons", 241267)


	--[[ Sisters of the Moon -> The Desolate Host ]]--
	self:Log("SPELL_AURA_APPLIED", "PolymorphBomb", 240735)
	self:Log("SPELL_AURA_REMOVED", "PolymorphBombRemoved", 240735)

	--[[ Pre Maiden of Vigilance ]]--


	--[[ Maiden of Vigilance -> Fallen Avatar ]]--


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
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

--[[ Pre Maiden of Vigilance ]]--


--[[ Maiden of Vigilance -> Fallen Avatar ]]--


--[[ Fallen Avatar -> Kil'jaeden ]]--
