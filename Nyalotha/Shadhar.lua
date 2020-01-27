--------------------------------------------------------------------------------
-- TODO:
--


--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shad'har the Insatiable", 2217, 2367)
if not mod then return end
mod:RegisterEnableMob(157231) -- Shad'har the Insatiable
mod.engageId = 2335
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local crushAndDissolveCount = 1
local spitCount = 1
local fixateCount = 1
local lastPower = 0
local oldPowerPerSec = 1
local breathId = 306928

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Shad'har randomizes which off-cooldown ability she uses next. When this option is enabled, the bars for those abilities will stay on your screen."
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		"custom_on_stop_timers",
		306953, -- Debilitating Spit
		{318078, "SAY"}, -- Fixate

		--[[ Crush and Dissolve ]]--
		{-21311, "TANK_HEALER"}, -- Crush and Dissolve
		{307471, "TANK"}, -- Crush
		{307472, "TANK_HEALER"}, -- Dissolve

		--[[ Stage One: Shadowy Carapace ]]--
		{306448, "HEALER"}, -- Umbral Mantle
		306928, -- Umbral Breath

		--[[ Stage Two: Void-tinged Carapace ]]--
		306930, -- Entropic Breath

		--[[ Stage Three: Noxious Carapace ]]--
		306929, -- Bubbling Breath
		314736, -- Bubbling Overflow
		306942, -- Frenzy
	}, {
		["stages"] = CL.general,
		[-21311] = -21311, -- Crush and Dissolve
		[306448] = -21246,-- Stage One: Shadowy Carapace
		[306930] = -21247,-- Stage Two: Void-tinged Carapace
		[306929] = -20617,-- Stage Three: Noxious Carapace
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_POWER_UPDATE", nil, "boss1")
	self:Log("SPELL_CAST_SUCCESS", "DebilitatingSpit", 306953)
	self:Log("SPELL_CAST_SUCCESS", "Fixate", 318078)

	self:Log("SPELL_CAST_START", "CrushAndDissolveStart", 307476, 307478)
	self:Log("SPELL_AURA_APPLIED", "CrushApplied", 307471)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushApplied", 307471)
	self:Log("SPELL_AURA_APPLIED", "DissolveApplied", 307472)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DissolveApplied", 307472)

	self:Log("SPELL_CAST_START", "Breath", 306928, 306930, 306929) -- Umbral, Entropic, Bubbling Breath
	self:Log("SPELL_CAST_SUCCESS", "BreathSuccess", 306928, 306930, 306929) -- Umbral, Entropic, Bubbling Breath

	self:Log("SPELL_AURA_APPLIED", "UmbralMantle", 306448)

	self:Log("SPELL_AURA_APPLIED", "EntropicMantle", 306933)

	self:Log("SPELL_AURA_APPLIED", "NoxiousMantle", 306931)
	self:Log("SPELL_AURA_APPLIED", "FrenzyApplied", 306942)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 314736) -- Bubbling Overflow
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 314736)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 314736)

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	crushAndDissolveCount = 1
	spitCount = 1
	fixateCount = 1
	lastPower = 0
	oldPowerPerSec = 4
	self:StartBreathBar(306928)
	self:Bar(306448, 5) -- Umbral Mantle
	self:Bar(-21311, 15.5, CL.count:format(self:SpellName(-21311), crushAndDissolveCount), "inv_pet_voidhound") -- Crush and Dissolve
	self:Bar(318078, 31) -- Fixate
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local abilitysToPause = {
		[306928] = true, -- Umbral Breath
		[306930] = true, -- Entropic Breath
		[306929] = true, -- Bubbling Breath
		[306953] = true, -- Debilitating Spit
		[-21311] = true, -- Crush and Dissolve
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

function mod:UNIT_POWER_UPDATE(_, unit)
	local power = UnitPower(unit)
	local powerPerSec = power - lastPower
	lastPower = power
	if powerPerSec > oldPowerPerSec then
		oldPowerPerSec = powerPerSec
		local nextBreath = math.ceil((100 - power) / powerPerSec)
		self:Bar(breathId, nextBreath) -- SetOption:306928,306930,306929:::
	end
end

function mod:StartBreathBar(spellId)
	breathId = spellId
	self:Bar(breathId, math.ceil(100 / oldPowerPerSec)) -- SetOption:306928,306930,306929:::
end

do
	local playerList = mod:NewTargetList()
	function mod:DebilitatingSpit(args)
		playerList[#playerList+1] = args.destName
		if (self:Healer() and #playerList == 1) or (not self:Healer() and self:Me(args.destName)) then
			self:PlaySound(args.spellId, "info")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, spitCount))
		if #playerList == 1 then
			self:StopBar(CL.count:format(args.spellName, spitCount))
			spitCount = spitCount + 1
			self:Bar(args.spellId, 30.3, CL.count:format(args.spellName, spitCount))
		end
	end
end

function mod:Fixate(args)
	self:TargetMessage2(args.spellId, "red", args.destName, CL.count:format(args.spellName, fixateCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
	fixateCount = fixateCount + 1
	self:Bar(args.spellId, 31, CL.count:format(args.spellName, fixateCount))
end

function mod:CrushAndDissolveStart(args)
	self:StopBar(CL.count:format(self:SpellName(-21311), crushAndDissolveCount))
	self:Message2(args.spellId == 307476 and 307471 or 307472, args.spellId == 307476 and "purple" or "cyan", CL.casting:format(args.spellName))
	if self:Tank() then
		self:PlaySound(args.spellId == 307476 and 307471 or 307472, "alarm")
	end
	self:CastBar(args.spellId == 307476 and 307471 or 307472, 2.5, CL.count:format(args.spellName, crushAndDissolveCount))
	crushAndDissolveCount = crushAndDissolveCount + 1
	if crushAndDissolveCount % 3 == 1 then
		self:CDBar(-21311, 20, CL.count:format(self:SpellName(-21311), crushAndDissolveCount), "inv_pet_voidhound") -- Crush and Dissolve
	end
end

function mod:CrushApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, "info")
end

function mod:DissolveApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:Breath(args)
	self:StopBar(args.spellId)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, args.spellId == 306930 and 0.5 or 4)
end

function mod:BreathSuccess(args)
	self:StartBreathBar(args.spellId)
end

do
	local prev = 0
	function mod:UmbralMantle(args)
		local t = args.time
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
			self:Bar(args.spellId, 20)
		end
	end
end

function mod:EntropicMantle(args)
	self:Message2("stages", "cyan", CL.stage:format(2), args.spellId)
	self:PlaySound("stages", "long")
	self:StopBar(306448) -- Umbral Mantle
	self:StopBar(306928) -- Umbral Breath
	self:StartBreathBar(306930) -- Entropic Breath
	self:Bar(306953, 10.5, CL.count:format(self:SpellName(306953), spitCount)) -- Debilitating Spit
	self:CDBar(-21311, 15.4, CL.count:format(self:SpellName(-21311), crushAndDissolveCount), "inv_pet_voidhound") -- Crush and Dissolve
end

function mod:NoxiousMantle(args)
	self:Message2("stages", "cyan", CL.stage:format(3), args.spellId)
	self:PlaySound("stages", "long")
	self:StopBar(306930) -- Entropic Breath
	self:StartBreathBar(306929) -- Bubbling Breath
	self:Bar(306953, 11, CL.count:format(self:SpellName(306953), spitCount)) -- Debilitating Spit
	self:CDBar(-21311, 21, CL.count:format(self:SpellName(-21311), crushAndDissolveCount), "inv_pet_voidhound") -- Crush and Dissolve
end

function mod:FrenzyApplied(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 1.5 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
