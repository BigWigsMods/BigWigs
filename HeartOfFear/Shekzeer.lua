
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Empress Shek'zeer", 897, 743)
if not mod then return end
mod:RegisterEnableMob(62837)

-----------------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Death to all who dare challenge my empire!"
	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes."
	L.phases_icon = "achievement_raid_mantidraid07"

	L.eyes = "Eyes of the Empress"
	L.eyes_desc = "Count the stacks and show a duration bar for Eyes of the Empress."
	L.eyes_icon = 123707
	L.eyes_message = "%2$dx Eyes on %1$s"
end
L = mod:GetLocale()
L.eyes = L.eyes.." "..INLINE_TANK_ICON
L.eyes_desc = CL.tank..L.eyes_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:6325", "eyes", {123788, "FLASHSHAKE"}, "proximity",
		{125390, "FLASHSHAKE"}, 124097,
		{124862, "FLASHSHAKE", "SAY"}, { 124849, "FLASHSHAKE" },
		"phases", "berserk", "bosskill",
	}, {
		["ej:6325"] = "ej:6336",
		[125390] = "ej:6340",
		[124862] = "ej:6341",
		phases = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Eyes", 123707)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Eyes", 123707)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 125390)
	self:Log("SPELL_AURA_APPLIED", "Resin", 124097)
	self:Log("SPELL_AURA_APPLIED", "Visions", 124862)
	self:Log("SPELL_AURA_APPLIED", "CryOfTerror", 123788)
	self:Log("SPELL_CAST_START", "ConsumingTerror", 124849)

	self:Yell("OnEngage", L["engage_trigger"]) -- XXX Check ENGAGE results

	self:Death("Win", 62837)
end

function mod:OnEngage(diff)
	self:OpenProximity(5)
	if not self:LFR() then
		self:Berserk(900)
	end
	self:Bar("ej:6325", 123627, 20, 123627) --Dissonance Field
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:RegisterEvent("UNIT_POWER_FREQUENT", "PoorMansDissonanceTimers")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe") -- XXX Check ENGAGE results
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ConsumingTerror(_, _, _, _, spellName)
	self:Message(124849, spellName, "Important", 124849, "Alert")
	self:Bar(124849, "~"..spellName, 32, 124849)
	self:FlashShake(124849)
end

function mod:CryOfTerror(player, _, _, _, spellName)
	self:TargetMessage(123788,spellName, player, "Attention", 123788, "Long")
	if UnitIsUnit("player", player) then
		self:FlashShake(123788)
	end
end

do
	local visionsList, scheduled = mod:NewTargetList(), nil
	local function warnVisions(spellName)
		mod:TargetMessage(124862, spellName, visionsList, "Important", 124862, "Alarm")
		scheduled = nil
	end
	function mod:Visions(player, _, _, _, spellName) -- if this is dispellable then we can remove the say and flashshake
		visionsList[#visionsList + 1] = player
		if UnitIsUnit("player", player) then
			-- EJ talks about 8 yard damage, but it is useless to have proximity meter because you are feared
			self:Say(124862, CL["say"]:format(spellName))
			self:FlashShake(124862)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(warnVisions, 0.1, spellName)
		end
	end
end

function mod:Fixate(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(125390)
		self:LocalMessage(125390, CL["you"]:format(spellName), "Personal", 125390, "Info")
		self:Bar(125390, spellName, 30, 125390) -- EJ sais 30, in game tooltip sais 20
	end
end

function mod:Resin(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(124097, CL["you"]:format(spellName), "Personal", 124097, "Info")
	end
end

function mod:PoorMansDissonanceTimers(_, unitId)
	if unitId == "boss1" then
		local power = UnitPower("boss1")
		if power == 149 then
			self:OpenProximity(5)
			self:Bar("ej:6325", 123627, 19, 128353) --Dissonance Field
			self:Bar("phases", CL["phase"]:format(2), 149, L["phases_icon"])
			self:StopBar(CL["phase"]:format(1))
		elseif power == 130 then
			self:Bar("ej:6325", 123627, 65, 128353)
			self:Message("ej:6325", 123627, "Attention", 128353)
		elseif power == 65 then
			self:Message("ej:6325", 123627, "Attention", 128353)
		elseif power == 2 then
			self:CloseProximity()
			self:Bar("phases", CL["phase"]:format(1), 158, L["phases_icon"])
		end
	end
end

function mod:Eyes(player, spellId, _, _, _, buffStack)
	if self:Tank() then
		buffStack = buffStack or 1
		self:StopBar(L["eyes_message"]:format(player, buffStack - 1))
		self:Bar("eyes", L["eyes_message"]:format(player, buffStack), 30, spellId)
		self:LocalMessage("eyes", L["eyes_message"], "Urgent", spellId, buffStack > 2 and "Info" or nil, player, buffStack)
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 35 then -- phase starts at 30
			self:Message("phases", CL["soon"]:format(CL["phase"]:format(3)), "Positive", L["phases_icon"], "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

