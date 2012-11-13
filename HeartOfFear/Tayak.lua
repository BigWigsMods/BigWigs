
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blade Lord Ta'yak", 897, 744)
if not mod then return end
mod:RegisterEnableMob(62543)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "On your guard, invaders. I, Ta'yak, Lord of Blades, will be your opponent."

	L.unseenstrike, L.unseenstrike_desc = EJ_GetSectionInfo(6346)
	L.unseenstrike_icon = 122994
	L.unseenstrike_inc = "Incoming Strike!"

	L.assault, L.assault_desc = EJ_GetSectionInfo(6349)
	L.assault_icon = 123474
	L.assault_message = "%2$dx Assault on %1$s"

	L.storm, L.storm_desc = EJ_GetSectionInfo(6350)
	L.storm_icon = 106996
end
L = mod:GetLocale()
L.assault = L.assault.." "..INLINE_TANK_ICON
L.assault_desc = CL.tank..L.assault_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{125310, "FLASHSHAKE"},
		122842, {"unseenstrike", "ICON", "SAY", "PROXIMITY"}, {123175, "PROXIMITY"}, "assault", "storm",
		"proximity", "berserk", "bosskill",
	}, {
		[125310] = "heroic",
		[122842] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Log("SPELL_CAST_START", "BladeTempest", 125310)
	self:Log("SPELL_CAST_SUCCESS", "WindStep", 123175)
	self:Log("SPELL_AURA_APPLIED", "Assault", 123474)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Assault", 123474)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62543)
end

function mod:OnEngage()
	if self:Heroic() then
		self:Bar(125310, 125310, 60, 125310) --Blade Tempest
	end
	self:Bar(123175, "~"..self:SpellName(123175), 20.5, 123175) --Wind Step
	self:Bar("unseenstrike", 122994, 30, 122994) --Unseen Strike
	self:OpenProximity(8, 123175) -- close this in last phase
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	if not self:LFR() then
		self:Berserk(480)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BladeTempest(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alarm")
	self:Bar(spellId, spellName, 60, spellId)
	self:FlashShake(spellId)
end

function mod:WindStep(_, spellId, _, _, spellName)
	self:Bar(spellId, "~"..spellName, 29, spellId) --28.9-30.2
end

do
	local timer = nil
	local strike = mod:SpellName(122949)
	local function removeIcon()
		mod:OpenProximity(8, 123175) -- Re-open normal proximity
		mod:PrimaryIcon("unseenstrike")
		mod:CancelTimer(timer, true) -- Should never last this long, but no harm in it
	end
	local function warnStrike()
		local player = UnitDebuff("boss1target", strike) and "boss1target"
		if not player then -- Most of the time this won't run as boss1target works
			for i=1, GetNumGroupMembers() do
				local id = ("raid%d"):format(i)
				player = UnitDebuff(id, strike) and id
				if player then break end
			end
		end
		if player then
			mod:CancelTimer(timer, true)
			local name, server = UnitName(player)
			if server then name = name .."-".. server end
			if UnitIsUnit(player, "player") then
				mod:Say("unseenstrike", CL["say"]:format(strike))
			else
				mod:OpenProximity(5, "unseenstrike", name, true)
			end
			mod:TargetMessage("unseenstrike", strike, name, "Urgent", L.unseenstrike_icon, "Alarm")
			mod:PrimaryIcon("unseenstrike", name)
		end
	end
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
		if unit == "boss1" then
			if spellId == 122949 then --Unseen Strike
				self:Bar("unseenstrike", L["unseenstrike_inc"], 6, L.unseenstrike_icon)
				self:Bar("unseenstrike", "~"..spellName, 60, L.unseenstrike_icon)
				timer = self:ScheduleRepeatingTimer(warnStrike, 0.05) -- ~1s faster than boss emote
				self:ScheduleTimer(removeIcon, 7)
			elseif spellId == 122839 then --Tempest Slash
				self:Bar(122842, "~"..spellName, self:Heroic() and 15.6 or 20.5, 122842)
			elseif spellId == 123814 then --Storm Unleashed (Phase 2)
				self:Message("storm", CL["phase"]:format(2), "Positive", L["storm_icon"], "Info")
				self:StopBar(125310) --Blade Tempest
				self:StopBar("~"..self:SpellName(122839)) --Tempest Slash
				self:StopBar("~"..self:SpellName(122949)) --Unseen Strike
				self:StopBar("~"..self:SpellName(123175)) --Wind Step
				self:CloseProximity(123175)
			end
		end
	end
end

function mod:Assault(player, spellId, _, _, spellName, stack)
	if self:Tank() then
		stack = stack or 1
		self:Bar("assault", spellName, 21, spellId) --might be helpful for healers, too
		--self:Bar("assault", ("%s (%s)"):format(player, spellName), 45, spellId) --not terribly useful?
		self:LocalMessage("assault", L["assault_message"], "Urgent", spellId, stack > 1 and "Info", player, stack)
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 25 then -- phase starts at 20
			self:Message("storm", CL["soon"]:format(CL["phase"]:format(2)), "Positive", L["storm_icon"], "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end
