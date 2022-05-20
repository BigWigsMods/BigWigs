--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Eredar Twins", 580, 1594)
if not mod then return end
mod:RegisterEnableMob(25166, 25165) -- Grand Warlock Alythess, Lady Sacrolash
mod:SetAllowWin(true)
mod:SetEncounterID(727)
mod:SetRespawnTime(35)

--------------------------------------------------------------------------------
-- Locals
--

local deaths = 0
local threatTable = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.lady = "Sacrolash #3:"
	L.lock = "Alythess #2:"

	L.threat = "Threat"

	L.custom_on_threat = "Threat InfoBox"
	L.custom_on_threat_desc = "Show second on threat for Grand Warlock Alythess and third on threat for Lady Sacrolash."
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		45230, -- Pyrogenics
		45256, -- Confounding Blow
		45248, -- Shadow Blades
		{45342, "ICON", "SAY"}, -- Conflagration
		{45329, "ICON", "SAY"}, -- Shadow Nova
		"custom_on_threat",
		"proximity",
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_AURA_APPLIED", "Pyrogenics", 45230)
	self:Log("SPELL_DISPEL", "PyrogenicsDispelled", "*")
	self:Log("SPELL_CAST_SUCCESS", "ConfoundingBlow", 45256)
	self:Log("SPELL_CAST_START", "ShadowBlades", 45248)
	self:Log("SPELL_CAST_START", "ConflagrationStart", 45342)
	self:Log("SPELL_AURA_APPLIED", "Conflagration", 45342)
	self:Log("SPELL_AURA_REMOVED", "ConflagrationRemoved", 45342)
	self:Log("SPELL_CAST_START", "ShadowNovaStart", 45329)
	self:Log("SPELL_CAST_SUCCESS", "ShadowNovaSuccess", 45329)

	self:Death("Deaths", 25166, 25165)
end

function mod:OnEngage()
	deaths = 0
	self:Berserk(360)
	self:OpenProximity("proximity", 10)
	if self:GetOption("custom_on_threat") and not self:Solo() then
		self:OpenInfo(false, L.threat)
		self:UpdateInfoBox()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths(args)
	deaths = deaths + 1
	if deaths == 2 then
		self:Win()
	end
end

function mod:GetThreat(mobId, index)
	local bossUnit = self:GetUnitIdByGUID(mobId)
	if not bossUnit then
		return nil
	end

	local count = 0
	for unit in self:IterateGroup() do
		count = count + 1
		local _, _, scaledPercentage, _, threatValue = self:Tanking(unit, bossUnit)
		if not threatTable[count] then threatTable[count] = {} end
		threatTable[count][1] = unit
		threatTable[count][2] = scaledPercentage or 0
		threatTable[count][3] = threatValue or 0
	end
	for i = count + 1, #threatTable do
		threatTable[i] = nil
	end

	sort(threatTable, function(a, b)
		if a[2] == b[2] then
			return a[3] > b[3]
		end
		return a[2] > b[2]
	end)

	local player = threatTable[math.min(index, count)]
	if not player then
		return nil
	end

	return self:UnitName(player[1])
end

function mod:UpdateInfoBox()
	if not _G.BigWigsInfoBox:IsShown() then return end

	-- Lady Sacrolash
	self:SetInfo(false, 1, ("|cffff7c0a%s|r"):format(L.lady)) -- orange for Conflag
	self:SetInfo(false, 2, self:GetThreat(25165, 3) or "???")

	-- Grand Warlock Alythess
	self:SetInfo(false, 3, ("|cff8788ee%s|r"):format(L.lock)) -- purple for Shadow Nova
	self:SetInfo(false, 4, self:GetThreat(25166, 2) or "???")

	self:ScheduleTimer("UpdateInfoBox", 1)
end

function mod:Pyrogenics(args)
	if self:MobId(args.destGUID) == 25166 then -- Grand Warlock Alythess
		self:TargetMessageOld(args.spellId, args.destName, "orange")
		self:Bar(args.spellId, 15)
		if self:Dispeller("magic", true) then -- Offensive dispeller
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:PyrogenicsDispelled(args)
	if args.extraSpellId == 45230 then
		self:MessageOld(45230, "green", "info", CL.removed_by:format(args.extraSpellName, self:ColorName(args.sourceName)))
		self:StopBar(45230)
	end
end

function mod:ConfoundingBlow(args)
	self:CDBar(args.spellId, 20)
end

function mod:ShadowBlades(args)
	self:Bar(args.spellId, 10)
end

do
	local function printTarget(self, name, guid)
		self:TargetMessageOld(45342, name, "yellow", "warning")
		self:PrimaryIcon(45342, name)
		if self:Me(guid) then
			self:Say(45342)
		end
	end

	function mod:ConflagrationStart(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
		self:CDBar(args.spellId, 32)
	end
end

function mod:Conflagration(args)
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:ConflagrationRemoved(args)
	self:PrimaryIcon(args.spellId)
end

do
	local function printTarget(self, name, guid)
		self:TargetMessageOld(45329, name, "red", "long", nil, nil, true)
		self:SecondaryIcon(45329, name)
		if self:Me(guid) then
			self:Say(45329)
		end
	end

	function mod:ShadowNovaStart(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:ShadowNovaSuccess(args)
	self:SecondaryIcon(args.spellId)
end
