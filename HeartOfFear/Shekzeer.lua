
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Empress Shek'zeer", 897, 743)
if not mod then return end
mod:RegisterEnableMob(62837)

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

	L.fumes_bar = "Your fumes buff"
end
L = mod:GetLocale()
L.eyes = L.eyes.." "..INLINE_TANK_ICON
L.eyes_desc = CL.tank..L.eyes_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{123845, "FLASHSHAKE", "ICON", "SAY"},
		"ej:6325", "eyes", {123788, "FLASHSHAKE", "ICON"}, "proximity", 123735,
		{125390, "FLASHSHAKE"}, 124097, 124827, {124077, "FLASHSHAKE"},
		{124862, "FLASHSHAKE", "SAY"}, { 124849, "FLASHSHAKE" },
		"phases", "berserk", "bosskill",
	}, {
		[123845] = "heroic",
		["ej:6325"] = "ej:6336",
		[125390] = "ej:6340",
		[124862] = "ej:6341",
		phases = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "HeartOfFearApplied", 123845)
	self:Log("SPELL_AURA_REMOVED", "HeartOfFearRemoved", 123845)
	self:Log("SPELL_AURA_APPLIED", "Eyes", 123707)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Eyes", 123707)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 125390)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 125390)
	self:Log("SPELL_AURA_APPLIED", "Resin", 124097)
	self:Log("SPELL_AURA_APPLIED", "Visions", 124862)
	self:Log("SPELL_AURA_APPLIED", "Poison", 124827)
	self:Log("SPELL_AURA_REFRESH", "Poison", 124827)
	self:Log("SPELL_AURA_APPLIED", "CryOfTerror", 123788)
	self:Log("SPELL_AURA_REMOVED", "CryOfTerrorRemoved", 123788)
	self:Log("SPELL_CAST_START", "ConsumingTerror", 124849)
	self:Log("SPELL_AURA_APPLIED", "Dispatch", 124077)
	self:Log("SPELL_CAST_SUCCESS", "DreadScreech", 123735)

	self:Yell("OnEngage", L["engage_trigger"]) -- XXX Check ENGAGE results

	self:Death("Win", 62837)
end

function mod:OnEngage(diff)
	self:OpenProximity(5)
	self:Berserk(900)
	self:Bar("ej:6325", 123627, 20, 123627) --Dissonance Field
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:RegisterEvent("UNIT_POWER_FREQUENT", "PoorMansDissonanceTimers")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe") -- XXX Check ENGAGE results
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HeartOfFearRemoved(_, spellId)
	self:PrimaryIcon(spellId)
end

function mod:HeartOfFearApplied(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, spellName, player, "Important", spellId, "Info")
	self:PrimaryIcon(spellId, player)
	if UnitIsUnit("player", player) then
		self:FlashShake(spellId)
		self:Say(spellId, CL["say"]:format(spellName))
	end
end

function mod:Dispatch(_, spellId, _, _, spellName) -- this is for interrupting, maybe check if the person can interrupt
	if UnitBuff("target", spellName) or UnitBuff("focus", spellName) then
		self:LocalMessage(spellId, CL["cast"]:format(spellName), "Personal", spellId, "Long")
		self:FlashShake(spellId)
	end
end

function mod:Poison(player, spellId)
	if UnitIsUnit("player", player) then
		self:Bar(spellId, L["fumes_bar"], 30, spellId)
	end
end

function mod:DreadScreech(_, spellId, _, _, spellName)
	self:Bar(spellId, "~"..spellName, 6, spellId) -- healers wanted it, think it is useless
end

function mod:ConsumingTerror(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alert")
	self:Bar(spellId, "~"..spellName, 32, spellId)
	self:FlashShake(spellId)
end

function mod:CryOfTerror(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, spellName, player, "Attention", spellId, "Long")
	self:PrimaryIcon(spellId, player)
	self:Bar(spellId, spellName, 25, spellId)
	if UnitIsUnit("player", player) then
		self:FlashShake(spellId)
	end
end

function mod:CryOfTerrorRemoved(_, spellId)
	self:PrimaryIcon(spellId)
end

do
	local visionsList, scheduled = mod:NewTargetList(), nil
	local function warnVisions(spellId)
		mod:TargetMessage(spellId, spellId, visionsList, "Important", spellId, "Alarm")
		scheduled = nil
	end
	function mod:Visions(player, spellId, _, _, spellName) -- if this is dispellable then we can remove the say and flashshake
		visionsList[#visionsList + 1] = player
		if UnitIsUnit("player", player) then
			-- EJ talks about 8 yard damage, but it is useless to have proximity meter because you are feared
			self:Say(spellId, CL["say"]:format(spellName))
			self:FlashShake(spellId)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnVisions, 0.1, spellId)
		end
	end
end

function mod:Fixate(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, spellName, player, "Attention", spellId, "Info")
	if UnitIsUnit("player", player) then
		self:FlashShake(spellId)
		self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId, "Info")
		self:TargetBar(spellId, spellName, player, 20, spellId)
	end
end

function mod:FixateRemoved(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:StopBar(CL["you"]:format(spellName))
	end
end

function mod:Resin(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId, "Info")
	end
end

function mod:PoorMansDissonanceTimers(_, unitId)
	if unitId == "boss1" then
		local power = UnitPower("boss1")
		if power == 149 then
			self:OpenProximity(5)
			self:Bar("ej:6325", 123627, 19, 128353) --Dissonance Field
			self:Bar("phases", CL["phase"]:format(2), 149, L.phases_icon)
			self:StopBar(CL["phase"]:format(1))
		elseif power == 130 then
			self:Bar("ej:6325", 123627, 65, 128353)
			self:Message("ej:6325", 123627, "Attention", 128353)
		elseif power == 65 then
			self:Message("ej:6325", 123627, "Attention", 128353)
		elseif power == 2 then
			self:CloseProximity()
			self:Bar("phases", CL["phase"]:format(1), 158, L.phases_icon)
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
			self:Message("phases", CL["soon"]:format(CL["phase"]:format(3)), "Positive", L.phases_icon, "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

