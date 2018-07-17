
-- GLOBALS: tDeleteItem, string

--------------------------------------------------------------------------------
-- TODO List:
-- - Add more timers, if they are more reliable in the future
-- - Could add bar stopping for:
--   - EchoingAnguish
--   - TormentingBurst
--   - Suffocating Dark

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Demonic Inquisition", 1676, 1867)
if not mod then return end
mod:RegisterEnableMob(116689, 116691)
mod.engageId = 2048
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local pangsofGuiltCounter = 1
local sweepCounter = 1
local nextAltPowerWarning = 20
local suffocatingDarkCounter = 1
local jailList = {}
local jailCount = 0
local jailTimer = nil
local fixateList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.fixate = "{-15307} ({41951})"
	L.fixate_desc = -15307
	L.fixate_icon = 41951

	L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_fixate_plates_icon = L.fixate_icon

	L.infobox_title_prisoners = "%d |4Prisoner:Prisoners;"

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Demonic Inquisition has some spells which are delayed by interupts/other casts. When this option is enabled, the bars for those abilities will stay on your screen."
end

--------------------------------------------------------------------------------
-- Initialization
--

local anguishMarker = mod:AddMarkerOption(false, "player", 1, 233983, 1, 2, 3)
function mod:GetOptions()
	return {
		{236283, "INFOBOX"}, -- Belac's Prisoner
		"altpower",
		"custom_on_stop_timers",
		233104, -- Torment
		248671, -- Unbridled Torment (Berserk)
		{233426, "TANK"}, -- Scythe Sweep
		{233431, "SAY"}, -- Calcified Quills
		233441, -- Bone Saw
		239401, -- Pangs of Guilt
		{233983, "FLASH", "SAY", "PROXIMITY"}, -- Echoing Anguish
		anguishMarker,
		233895, -- Suffocating Dark
		234015, -- Tormenting Burst
		235230, -- Fel Squall
		248713, -- Soul Corruption
		{"fixate", "FLASH"},
		"custom_on_fixate_plates",
	},{
		[236283] = "general",
		[233426] = -14645, -- Atrigan
		[239401] = -14646, -- Belac
		[248713] = -15550, -- Tormented Soul
		["fixate"] = "mythic",
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
	self:Log("SPELL_AURA_APPLIED", "BelacsPrisoner", 236283)
	self:Log("SPELL_AURA_REMOVED", "BelacsPrisonerRemoved", 236283)

	-- Atrigan
	self:Log("SPELL_CAST_START", "ScytheSweep", 233426)
	self:Log("SPELL_CAST_SUCCESS", "CalcifiedQuills", 233431)
	self:Log("SPELL_CAST_SUCCESS", "BoneSaw", 233441)

	-- Belac
	self:Log("SPELL_CAST_START", "PangsofGuilt", 239401)
	self:Log("SPELL_CAST_START", "EchoingAnguish", 233983)
	self:Log("SPELL_AURA_APPLIED", "EchoingAnguishApplied", 233983)
	self:Log("SPELL_AURA_REMOVED", "EchoingAnguishRemoved", 233983)
	self:Log("SPELL_CAST_START", "TormentingBurst", 234015)
	self:Log("SPELL_CAST_SUCCESS", "FelSquall", 235230)
	self:Log("SPELL_AURA_APPLIED", "SuffocatingDarkDamage", 233901)
	self:Log("SPELL_PERIODIC_DAMAGE", "SuffocatingDarkDamage", 233901)
	self:Log("SPELL_PERIODIC_MISSED", "SuffocatingDarkDamage", 233901)

	-- Tormented Soul
	self:Log("SPELL_AURA_APPLIED_DOSE", "SoulCorruption", 248713)

	if self:Mythic() and self:GetOption("custom_on_fixate_plates") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	pangsofGuiltCounter = 1
	sweepCounter = 1
	suffocatingDarkCounter = 1
	nextAltPowerWarning = 20
	jailCount = 0
	jailTimer = nil
	wipe(jailList)
	wipe(fixateList)

	-- Jail Infobox
	self:OpenInfo(236283, L.infobox_title_prisoners:format(jailCount))
	self:OpenAltPower("altpower", 233104) -- Torment

	-- Atrigan
	self:CDBar(233426, 5.8) -- Scythe Sweep
	if not self:Easy() then
		self:CDBar(233431, 11) -- Calcified Quills
	end
	self:CDBar(233441, 60.5) -- Bone Saw

	-- Belac
	self:CDBar(235230, 35) -- Fel Squall

	self:RegisterUnitEvent("UNIT_POWER", nil, "player")

	self:Berserk(720, true, nil, 248671, 248671) -- confirmed for nm/hc/my - 248671 has a nice description, 248669 is the aura applied

	if self:Mythic() and (self:GetOption("fixate") > 0 or self:GetOption("custom_on_fixate_plates")) then
		self:RegisterTargetEvents("CheckForFixate")
	end
end

function mod:OnBossDisable()
	if self:Mythic() and self:GetOption("custom_on_fixate_plates") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
do
	local prev = 0
	function mod:CheckForFixate(_, unit, guid)
		local mobId = self:MobId(guid)
		if mobId == 121138 and not fixateList[guid] and self:Me(UnitGUID(unit.."target")) then -- Tormented Fragment
			fixateList[guid] = true
			local t = GetTime()
			if t-prev > 1 then
				prev = t
				self:Flash("fixate", 41951)
				self:Message("fixate", "Personal", "Long", CL.you:format(self:SpellName(41951)), 41951) -- 41951 = "Fixate"
			end
			if self:GetOption("custom_on_fixate_plates") then
				self:AddPlateIcon(41951, guid)
			end
		end
	end
end

do
	local abilitysToPause = {
		[233983] = true, -- Echoing Anguish
		[234015] = true, -- Tormenting Burst
		[233895] = true, -- Suffocating Dark
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

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 233895 then -- Suffocating Dark
		self:Message(spellId, "Attention", "Info")
		suffocatingDarkCounter = suffocatingDarkCounter + 1
		self:CDBar(spellId, suffocatingDarkCounter == 2 and 42 or 25)
	end
end

do
	local lastPower, prev = 0, 0
	function mod:UNIT_POWER(event, unit, pType)
		if pType == "ALTERNATE" then
			local power = UnitPower(unit, 10) -- Enum.PowerType.Alternate = 10
			if power < lastPower or power >= nextAltPowerWarning then
				self:StackMessage(233104, self:UnitName(unit), power, "Personal")
				local t = GetTime()
				if (power >= 80 or power < lastPower) and t-prev > 1.5 then
					self:PlaySound(233104, "Info")
					prev = t
				end
				nextAltPowerWarning = tonumber(string.format("%d", power/20))*20+20 -- every 20 power
			end
			lastPower = power
		end
	end
end

do
	local function updatePower(self, id)
		for k in next, jailList do
			jailList[k] = UnitPower(k, 10) or 1
		end
		self:SetInfoByTable(id, jailList)
	end

	function mod:BelacsPrisoner(args)
		if self:Me(args.destGUID)then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
		end

		-- Add person to InfoBox
		jailCount = jailCount + 1
		jailList[args.destName] = UnitPower(args.destName, 10) or 1 -- Incase we can't grab unitpower
		self:SetInfoTitle(args.spellId, L.infobox_title_prisoners:format(jailCount))
		self:SetInfoByTable(args.spellId, jailList)
		if not jailTimer then
			jailTimer = self:ScheduleRepeatingTimer(updatePower, 1, self, args.spellId)
		end
	end
end

function mod:BelacsPrisonerRemoved(args)
	-- Remove from InfoBox
	jailList[args.destName] = nil
	jailCount = jailCount - 1
	if not next(jailList) then
		self:CancelTimer(jailTimer)
		jailTimer = nil
	end
	self:SetInfoTitle(args.spellId, L.infobox_title_prisoners:format(jailCount))
	self:SetInfoByTable(args.spellId, jailList)
end

function mod:ScytheSweep(args)
	self:Message(args.spellId, "Attention", self:Tank() and "Alert")
	sweepCounter = sweepCounter + 1
	self:CDBar(args.spellId, sweepCounter > 4 and sweepCounter % 2 == 0 and 35 or 24)
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(233431, name, "Urgent", "Alert", nil, nil, true)
		if self:Me(guid) then
			self:Say(233431)
		end
	end
	function mod:CalcifiedQuills(args)
		self:GetBossTarget(printTarget, 0.7, args.sourceGUID)
		self:CastBar(args.spellId, 5)
		self:CDBar(args.spellId, 21.5)
	end
end

function mod:BoneSaw(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, 16)
	if self:Easy() then
		self:Bar(args.spellId, 60.5)
	else
		self:CDBar(args.spellId, 61) -- 61-63
	end
end

function mod:PangsofGuilt(args) -- Interuptable
	self:Message(args.spellId, "Important", self:Interrupter(args.sourceGUID) and "Alarm", CL.casting:format(CL.count:format(args.spellName, pangsofGuiltCounter)))
	pangsofGuiltCounter = (pangsofGuiltCounter % 3) + 1
end

function mod:EchoingAnguish(args)
	self:Message(args.spellId, "Important", "Alert")
	self:OpenProximity(args.spellId, 8) -- Open proximity a bit before
	self:CDBar(args.spellId, 22)
end

do
	local proxList = {}
	function mod:EchoingAnguishApplied(args)
		proxList[#proxList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end

		self:OpenProximity(args.spellId, 8, proxList) -- Don't stand near others if they have the debuff

		if self:GetOption(anguishMarker) then
			SetRaidTarget(args.destName, #proxList)
		end
	end

	function mod:EchoingAnguishRemoved(args)
		tDeleteItem(proxList, args.destName)
		if self:GetOption(anguishMarker) then
			SetRaidTarget(args.destName, 0)
		end
		if #proxList == 0 then -- If there are no debuffs left, close proximity
			self:CloseProximity(args.spellId)

		else
			self:OpenProximity(args.spellId, 8, proxList) -- Refresh list
		end
	end
end

function mod:TormentingBurst(args)
	self:Message(args.spellId, "Attention", self:Healer() and "Long")
	self:CDBar(args.spellId, 17.1)
end

function mod:FelSquall(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, 16)
	self:Bar(args.spellId, 60.5)
end

do
	local prev = 0
	function mod:SuffocatingDarkDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 3 then
			prev = t
			self:Message(233895, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:SoulCorruption(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 5 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "Important", "Warning") -- check sound amount
		end
	end
end
