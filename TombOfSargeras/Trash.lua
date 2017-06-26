
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
	120463, -- Undersea Custodian

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
	L.chaosbringer = "Infernal Chaosbringer"
	L.rez = "Rez the Tombwatcher"
	L.custodian = "Undersea Custodian"
	L.sentry = "Guardian Sentry"
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		--[[ Pre Goroth ]]--
		242909, -- Massive Eruption

		--[[ Goroth -> Demonic Inquisition ]]--
		241262, -- Felburn

		--[[ Goroth -> Harjatan ]]--

		--[[ Goroth -> Sisters of the Moon ]]--

		--[[ Harjatan -> Mistress Sassz'ine ]]--
		240169, -- Electric Shock
		240176, -- Lightning Stork

		--[[ Sisters of the Moon -> The Desolate Host ]]--
		{240735, "SAY"}, -- Polymorph Bomb

		--[[ Pre Maiden of Vigilance ]]--

		--[[ Maiden of Vigilance -> Fallen Avatar ]]--

		--[[ Fallen Avatar -> Kil'jaeden ]]--

	}, {
		[242909] = L.chaosbringer,
		[241262] = L.rez,
		[240169] = L.custodian,
		[240735] = L.sentry,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 241262, 240176) -- Felburn, Lightning Storm
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 241262, 240176)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 241262, 240176)
	--self:Log("SPELL_DAMAGE", "GroundEffectDamage", ) --
	--self:Log("SPELL_MISSED", "GroundEffectDamage", )

	--[[ Pre Goroth ]]--
	self:Log("SPELL_CAST_START", "MassiveEruption", 242909)

	--[[ Goroth -> Demonic Inquisition ]]--


	--[[ Goroth -> Harjatan ]]--


	--[[ Goroth -> Sisters of the Moon ]]--


	--[[ Harjatan -> Mistress Sassz'ine ]]--
	self:Log("SPELL_CAST_START", "ElectricShock", 240169)


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
function mod:ElectricShock(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CastBar(args.spellId, 4)
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
