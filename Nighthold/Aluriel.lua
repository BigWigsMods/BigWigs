
--------------------------------------------------------------------------------
-- TODO List:
-- - Respawn time
-- - Tuning sounds / message colors
-- - Remove alpha engaged message
-- - We could merge the "pre" debuffs with the actual debuffs for Mark of Frost and Searing Brand.
--   I decided to do it like that because you have more customization options (emphasize and stuff)
-- - Blizzard decided to hide the "Animate: Mark of Frost" from the combatlog
--   If they enable it in the future we may not need the add locales, options and the usc event (see XXX comments)
-- - Add proximity for mark of frost and searing brand
-- - Count the add deaths maybe?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Spellblade Aluriel", 1088, 1751)
if not mod then return end
mod:RegisterEnableMob(104881)
mod.engageId = 1871
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--
local timers = {
	["Annihilate"] = {8.0, 45.0, 40.0, 44.0, 20.0, 18.0, 47.0}, -- may repeat after some point
}
local annihilateCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.icyAdd = select(2, EJ_GetCreatureInfo(2, 1751))
	L.icyAdd_desc = "This is the replacement for Animate: Mark of Frost" -- XXX alpha, if this gets live someone should write a better desc
	L.icyAdd_icon = 31687
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		212492, -- Annihilate
		"stages",
		"berserk",

		--[[ Master of Frost ]]--
		{212531, "SAY", "FLASH"}, -- Pre Mark of Frost
		212587, -- Mark of Frost
		212647, -- Frostbitten
		212530, -- Replicate: Mark of Frost
		212735, -- Detonate: Mark of Frost
		"icyAdd", -- Missing "Animate: Mark of Frost" (Blizzard, pls fix)  XXX Alpha, remove if they didnt add it for live
		213083, -- Frozen Tempest
		212736, -- Pool of Frost

		--[[ Master of Fire ]]--
		{213148, "SAY"}, -- Pre Searing Brand
		213166, -- Searing Brand
		213275, -- Detonate: Searing Brand
		213567, -- Animate: Searing Brand
		213278, -- Burning Ground

		--[[ Master of the Arcane ]]--
		213520, -- Arcane Orb
		213852, -- Replicate: Arcane Orb
		213390, -- Detonate: Arcane Orb
		213564, -- Animate: Arcane Orb
		213569, -- Armageddon
		213504, -- Arcane Fog
	}, {
		[212492] = "general",
		[212531] = -13376, -- Master of Frost
		[213148] = -13379, -- Master of Fire
		[213520] = -13380, -- Master of the Arcane
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ General ]]--
	self:Log("SPELL_CAST_START", "AnnihilateCast", 212492)
	self:Log("SPELL_AURA_APPLIED", "AnnihilateApplied", 215458)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AnnihilateApplied", 215458)
	self:Log("SPELL_AURA_APPLIED", "Stages", 216389, 213867, 213869) -- Icy / Fiery / Magic Enchantment

	--[[ Master of Frost ]]--
	self:Log("SPELL_AURA_APPLIED", "PreMarkOfFrostApplied", 212531)
	self:Log("SPELL_AURA_APPLIED", "MarkOfFrostApplied", 212587)
	self:Log("SPELL_AURA_APPLIED", "Frostbitten", 212647)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Frostbitten", 212647)
	self:Log("SPELL_CAST_START", "ReplicateMarkOfFrost", 212530)
	self:Log("SPELL_CAST_START", "DetonateMarkOfFrost", 212735)
	self:Log("SPELL_CAST_START", "FrozenTempest", 213083)

	--[[ Master of Fire ]]--
	self:Log("SPELL_AURA_APPLIED", "PreSearingBrandApplied", 213148)
	self:Log("SPELL_AURA_APPLIED", "SearingBrandApplied", 213166)
	self:Log("SPELL_CAST_START", "DetonateSearingBrand", 213275)
	self:Log("SPELL_CAST_START", "AnimateSearingBrand", 213567)

	--[[ Master of the Arcane ]]--
	self:Log("SPELL_CAST_START", "ReplicateArcaneOrb", 213852)
	--self:Log("SPELL_CAST_START", "DetonateArcaneOrb", 213390) -- XXX not in combatlog, using usc event, check on live
	self:Log("SPELL_CAST_START", "AnimateArcaneOrb", 213564)
	self:Log("SPELL_AURA_APPLIED", "Armageddon", 213569)

	--[[ Many ground effects, handle it! ]]--
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 212736, 213278, 213504) -- Pool of Frost / Burning Ground / Arcane Fog
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 212736, 213278, 213504)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 212736, 213278, 213504)
	self:Log("SPELL_DAMAGE", "GroundEffectDamage", 213520) -- Arcane Orb
	self:Log("SPELL_MISSED", "GroundEffectDamage", 213520)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Spellblade Aluriel (Alpha) Engaged (Post Alpha Test Mod)", "classicon_mage")
	annihilateCount = 1
	self:Bar(212492, timers["Annihilate"][annihilateCount]) -- Annihilate
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, spellGUID, _)
	local spellId = tonumber(select(5, strsplit("-", spellGUID)), 10) -- new uscs format: 3-[server id]-[instance id]-[zone uid]-[spell id]-[spell uid]
	if spellId == 215455 then -- Arcane Orb
		self:Message(213520, "Important")
	elseif spellId == 213853 then -- Actually called "Mark of Frost" but indicating the frost adds spawn, XXX Alpha, check on live
		self:Message("icyAdd", "Attention", "Info", CL.spawning:format(L.icyAdd), 31687)
	elseif spellId == 213390 then -- Detonate: Arcane Orb
		local fakeArgs = {spellName = spellName, spellId = spellId}
		self:DetonateArcaneOrb(fakeArgs)
	end
end

--[[ General ]]--
function mod:AnnihilateCast(args)
	self:Message(args.spellId, "Important", self:Tank() and "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 8, CL.cast:format(args.spellName))
	annihilateCount = annihilateCount + 1
	self:Bar(args.spellId, timers["Annihilate"][annihilateCount])
end

function mod:AnnihilateApplied(args)
	local amount = args.amount or 1
	self:StackMessage(212492, args.destName, amount, "Important", amount > 1 and "Warning") -- check sound amount
end

do
	local nextStage = {
		[216389] = 213867, -- frost > fire
		[213867] = 213869, -- fire > magic
		[213869] = 216389, -- magic > frost
	}
	function mod:Stages(args)
		self:Message("stages", "Neutral", "Long", args.spellName, args.spellId)
		self:Bar("stages", 85, self:SpellName(nextStage[args.spellId]), nextStage[args.spellId])

		if args.spellId == 216389 then -- Icy
			self:Bar(212587, 18) -- Mark of Frost (timer is the "pre" mark of frost aura applied)
			self:Bar(212530, 31) -- Replicate: Mark of Frost
			self:Bar(212735, 51) -- Detonate: Mark of Frost
			self:Bar("icyAdd", 65, L.icyAdd, 31687) -- 31687 = Summon Water Elemental
			self:Bar(213083, 74) -- Frozen Tempest
		elseif args.spellId == 213867 then -- Fiery
			self:Bar(213166, 18) -- Searing Brand (timer is the "pre" mark of frost aura applied)
			self:Bar(213275, 48) -- Detonate: Searing Brand
			self:Bar(213567, 65) -- Animate: Searing Brand
		else -- Magic
			self:Bar(213852, 26) -- Replicate: Arcane Orb
			self:Bar(213390, 48) -- Detonate: Arcane Orb
			self:Bar(213564, 65) -- Animate: Arcane Orb
		end
	end
end

--[[ Master of Frost ]]--
function mod:PreMarkOfFrostApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

do
	local list = mod:NewTargetList()
	function mod:MarkOfFrostApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Urgent")
		end

		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			if expires and expires > 0 then
				local timeLeft = expires - GetTime()
				self:TargetBar(args.spellId, timeLeft, args.destName)
			end
		end
	end
end

function mod:Frostbitten(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 3 and "Warning")
	end
end

function mod:ReplicateMarkOfFrost(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
end

function mod:DetonateMarkOfFrost(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
end

function mod:FrozenTempest(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 12, CL.cast:format(args.spellName))
end

--[[ Master of Fire ]]--
do
	local list = mod:NewTargetList()
	function mod:PreSearingBrandApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Urgent")
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:SearingBrandApplied(args)
	if self:Me(args.destGUID) then
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		if expires and expires > 0 then
			local timeLeft = expires - GetTime()
			self:TargetBar(args.spellId, timeLeft, args.destName)
		end
	end
end

function mod:DetonateSearingBrand(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
end

function mod:AnimateSearingBrand(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
end

--[[ Master of the Arcane ]]--
function mod:ReplicateArcaneOrb(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
end

function mod:DetonateArcaneOrb(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
end

function mod:AnimateArcaneOrb(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
end

do
	local prev = 0
	function mod:Armageddon(args)
		local t = GetTime()
		if t-prev > 1 then -- Throttle because 8 adds cast it simultaneously
			prev = t
			self:Message(args.spellId, "Urgent")
		end
	end
end

--[[ Many ground effects, handle it! ]]--
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
