
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Butcher", 994, 971)
if not mod then return end
mod:RegisterEnableMob(77404)
mod.engageId = 1706

--------------------------------------------------------------------------------
-- Locals
--

local cleaveCount = 1
local addCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.frenzy = -8862 -- Frenzy
	L.frenzy_icon = "spell_shadow_unholyfrenzy"

	L.adds_multiple = "Adds x%d"

	L.tank_proximity = "Tank Proximity"
	L.tank_proximity_desc = "Open a 5 yard proximity showing the other tanks to help you deal with the Heavy Handed ability."
	L.tank_proximity_icon = 156138 -- Heavy Handed / ability_butcher_heavyhanded
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]] --
		-10228, -- Night-Twisted Cadaver
		{163046, "FLASH"}, -- Pale Vitriol
		--[[ General ]]--
		{156151, "TANK_HEALER"}, -- The Tenderizer
		{"tank_proximity", "TANK", "PROXIMITY"},
		156157, -- Cleave
		156152, -- Gushing Wounds
		156197, -- Bounding Cleave
		"frenzy",
		"berserk",
	}, {
		[-10228] = "mythic",
		[156151] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "BoundingCleave", 156197, 156257)
	self:Log("SPELL_AURA_APPLIED", "Tenderizer", 156151)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Tenderizer", 156151)
	self:Log("SPELL_CAST_START", "Cleave", 156157, 156293)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GushingWounds", 156152)
	self:Log("SPELL_AURA_REMOVED", "GushingWoundsRemoved", 156152)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 156598)
	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "AddSpawn", 163051) -- Paleobomb
	self:Log("SPELL_PERIODIC_DAMAGE", "PaleVitriolDamage", 163046)
	self:Log("SPELL_PERIODIC_MISSED", "PaleVitriolDamage", 163046)
end

function mod:OnEngage()
	cleaveCount = 1
	addCount = 1

	self:Bar(156151, 7) -- Tenderizer
	self:Bar(156197, 60) -- Bounding Cleave
	if self:Mythic() then
		self:Bar(-10228, 18, L.adds_multiple:format(1), "spell_shadow_corpseexplode")
	end
	if not self:LFR() then
		self:Berserk(self:Mythic() and 240 or 300)
	end
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")

	if self:Tank() then
		local _, _, _, myMapId = UnitPosition("player")
		local tankList = {}
		for unit in self:IterateGroup() do
			local _, _, _, tarMapId = UnitPosition(unit)
			if tarMapId == myMapId and self:Tank(unit) and not self:Me(UnitGUID(unit)) then
				tankList[#tankList+1] = unit
			end
		end
		if tankList[1] then
			self:OpenProximity("tank_proximity", 5, tankList, true)
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:AddSpawn()
		local t = GetTime()
		if t-prev > 5 then
			-- every four waves adds another add: 3x1, 4x2, 4x3, etc
			local num = floor(addCount / 4) + 1
			self:Message(-10228, "Attention", nil, CL.spawning:format(L.adds_multiple:format(num)), "spell_shadow_corpseexplode")
			addCount = addCount + 1
			local nextNum = floor((addCount) / 4) + 1
			self:Bar(-10228, 14.5, L.adds_multiple:format(nextNum), "spell_shadow_corpseexplode")
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:PaleVitriolDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:BoundingCleave(args)
	local frenzied = args.spellId == 156257 and true
	cleaveCount = 1
	self:Message(156197, "Urgent", "Alert")
	self:Bar(156197, frenzied and 30 or 60) -- Bounding Cleave
	self:CDBar(156157, frenzied and 5 or 8) -- Cleave
	self:CDBar(156151, 17) -- Tenderizer
end

function mod:Tenderizer(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", args.amount and "Warning")
	self:CDBar(args.spellId, 17)
end

function mod:Cleave(args)
	self:Message(156157, "Attention", nil, CL.count:format(args.spellName, cleaveCount))
	--self:StopBar(CL.count:format(args.spellName, cleaveCount))
	cleaveCount = cleaveCount + 1
	--self:CDBar(args.spellId, 6, CL.count:format(args.spellName, cleaveCount))
end

function mod:GushingWounds(args)
	if self:Me(args.destGUID) and args.amount > 2 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Personal", "Alarm")
		self:TargetBar(args.spellId, 15, args.destName)
	end
end

function mod:GushingWoundsRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 36 then
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		self:Message("frenzy", "Neutral", nil, CL.soon:format(self:SpellName(L.frenzy)), false)
	end
end

function mod:Frenzy(args)
	self:Message("frenzy", "Important", "Alarm", args.spellName, L.frenzy_icon)
	-- gains power faster while frenzied
	local left = (100 - UnitPower("boss1")) * 0.3
	self:Bar(156197, left) -- Bounding Cleave
end

