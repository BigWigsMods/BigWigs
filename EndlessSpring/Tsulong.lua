
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tsulong", 886, 742)
if not mod then return end
mod:RegisterEnableMob(62442)

local day, night = (EJ_GetSectionInfo(6315)), (EJ_GetSectionInfo(6310))
local summonUnstableSha, sunBreath, nightmares, darkOfNight = (GetSpellInfo(122953)), (GetSpellInfo(122855)), (GetSpellInfo(122777)), (GetSpellInfo(123813))

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes"

	L.breath, L.breath_desc = EJ_GetSectionInfo(6313)
	L.breath_icon = 122752
end
L = mod:GetLocale()
L.breath = L.breath.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122752, 122768, 122789, { 122777, "PROXIMITY", "FLASHSHAKE", "SAY" },
		122855, "ej:6320",
		123813,
		"berserk", "phases", "bosskill",
	}, {
		[122752] = "ej:6310",
		["ej:6320"] = "ej:6315",
		[123813] = "heroic",
		berserk = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SunBreath", 122855)
	self:Log("SPELL_AURA_APPLIED", "ShadowBreath", 122752)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DreadShadows", 122768)
	self:Log("SPELL_AURA_APPLIED", "Sunbeam", 122789)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")


	self:Death("Win", 62442)
end

function mod:OnEngage(diff)
	self:OpenProximity(8, 122777)
	self:Berserk(360) -- assume
	self:Bar("phases", day, 121, 122789)
	self:Bar(122777, nightmares, 15.6, 122777)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DreadShadows(player, _, _, _, spellName, stack)
	if self:Difficulty() > 2 then
		if UnitIsUnit("player", player) and stack > 5 and stack % 3 == 0 then -- might need adjusting
			self:LocalMessage(122768, ("%s (%d)"):format(spellName, stack), "Personal", 122768, "Info")
		end
	else
		if UnitIsUnit("player", player) and stack > 11 and stack % 3 == 0 then -- might need adjusting
			self:LocalMessage(122768, ("%s (%d)"):format(spellName, stack), "Personal", 122768, "Info")
		end
	end
end

function mod:Sunbeam(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(122789, spellName, "Positive", 122789)
	end
end

function mod:SunBreath(player, _, _, _, spellName)
	self:Bar(122855, spellName, 29, 122855)
	self:Message(122855, spellName, "Urgent", 122855)
end

function mod:ShadowBreath(player, _, _, _, spellName)
	if self:Tank() then
		self:Bar("breath", ("%s (%s)"):format(player, spellName), 30, 122752)
		self:TargetMessage("breath", spellName, player, "Urgent", 122752)
	end
end

do
	local scanned = 0
	local function getNightmaresTarget()
		if UnitExists("boss1target") then
			if not UnitDetailedThreatSituation("boss1target", "boss1") then
				local name = UnitName("boss1target")
				mod:TargetMessage(122777, nightmares, name, "Important", 122777, "Alert")
				if UnitIsUnit("boss1target", "player") then
					mod:FlashShake(122777)
					mod:Say(122777, CL["say"]:format(nightmares))
				end
			end
		else
			if scanned < 10 then
				scanned = scanned + 1
				mod:ScheduleTimer(getNightmaresTarget, 0.1)
			else
				mod:CancelAllTimers()
				scanned = 0
			end
		end
	end
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
		if not unitId:match("boss") then return end
		if spellId == 123252 then -- end of night phase
			self:CloseProximity(122777)
			self:Message("phases", day, "Positive", 122789)
			self:Bar("phases", night, 121, 122768)
			self:Bar("ej:6320", summonUnstableSha, 18, 122938)
		elseif spellId == 122767 then -- start of night phase
			self:OpenProximity(8, 122777)
			self:Message("phases", night, "Positive", 122768)
			self:Bar("phases", day, 121, 122789)
			self:SendMessage("BigWigs_StopBar", self, summonUnstableSha)
			self:SendMessage("BigWigs_StopBar", self, sunBreath)
		elseif spellId == 122953 then -- summon unstable sha
			self:Message("ej:6320", spellName, "Important", 122938, "Alert")
			self:Bar("ej:6320", spellName, 18, 122938)
		elseif spellId == 122770 or spellId ==122775 then -- Nightmares
			self:Bar(122777, spellName, 15, 122777)
			getNightmaresTarget() -- probably won't work
		elseif spellId == 123813 then -- dark of night- heroic
			self:Bar(123813, darkOfNight, 30, 130013)
			self:Message(123813, darkOfNight, "Urgent", 130013, "Alarm")
		end
	end
end