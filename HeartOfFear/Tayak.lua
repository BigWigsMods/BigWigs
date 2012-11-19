
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blade Lord Ta'yak", 897, 744)
if not mod then return end
mod:RegisterEnableMob(62543)

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

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
	L.assault_message = "Assault"

	L.storm, L.storm_desc = EJ_GetSectionInfo(6350)
	L.storm_icon = 106996

	L.side_swap = "Side Swap"
end
L = mod:GetLocale()
L.assault = L.assault.." "..INLINE_TANK_ICON..INLINE_HEALER_ICON
L.assault_desc = CL.tankhealer..L.assault_desc

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
	self:AddSyncListener("Strike")

	self:Death("Win", 62543)
end

function mod:OnEngage()
	if self:Heroic() then
		self:Bar(125310, 125310, 60, 125310) --Blade Tempest
	end
	self:Bar(123175, "~"..self:SpellName(123175), 20.5, 123175) --Wind Step
	self:Bar("unseenstrike", 122994, 30, 122994) --Unseen Strike
	if self:Tank() or self:Healer() then
		self:Bar("assault", L["assault_message"], 15, 123474)
	end
	self:OpenProximity(8, 123175)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	if not self:LFR() then
		self:Berserk(480)
	end
	phase = 1
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
		if mod.isEngaged then
			mod:OpenProximity(8, 123175) -- Re-open normal proximity
		else
			mod:CloseProximity("unseenstrike") -- Close proximity for Instructor Maltik
		end
		mod:PrimaryIcon("unseenstrike")
		if timer then
			mod:CancelTimer(timer, true) -- Should never last this long, but no harm in it
			timer = nil
		end
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
			timer = nil
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
				self:Bar("unseenstrike", "~"..spellName, 55, L.unseenstrike_icon)
				if not timer then
					timer = self:ScheduleRepeatingTimer(warnStrike, 0.05) -- ~1s faster than boss emote
				end
				self:ScheduleTimer(removeIcon, 7)
			elseif spellId == 122839 then --Tempest Slash
				self:Bar(122842, "~"..spellName, self:Heroic() and 15.6 or 20.5, 122842)
			elseif spellId == 123814 then --Storm Unleashed (Phase 2)
				self:Message("storm", "20% - "..CL["phase"]:format(2), "Positive", L["storm_icon"], "Info")
				self:StopBar(125310) --Blade Tempest
				self:StopBar("~"..self:SpellName(122839)) --Tempest Slash
				self:StopBar("~"..self:SpellName(122949)) --Unseen Strike
				self:StopBar("~"..self:SpellName(123175)) --Wind Step
				self:CloseProximity(123175)
			end
		elseif spellId == 122949 and unit == "target" and not self.isEngaged then
			self:Sync("Strike") -- Instructor Maltik
		end
	end
	function mod:OnSync(sync)
		if sync == "Strike" then
			self:Bar("unseenstrike", L["unseenstrike_inc"], 6, L.unseenstrike_icon)
			if not timer then
				timer = self:ScheduleRepeatingTimer(warnStrike, 0.05)
			end
			self:ScheduleTimer(removeIcon, 7)
		end
	end
end

function mod:Assault(player, spellId, _, _, spellName, stack)
	if self:Tank() or self:Healer() then
		stack = stack or 1
		self:Bar("assault", "~"..L["assault_message"], 21, spellId)
		self:LocalMessage("assault", CL["stack"], "Urgent", spellId, stack > 1 and "Info", player, stack, L["assault_message"])
		if self:Tank() then
			self:Bar("assault", CL["stack"]:format(player, stack, L["assault_message"]), 45, spellId)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 25 and phase == 1 then -- phase starts at 20
			self:Message("storm", CL["soon"]:format(CL["phase"]:format(2)), "Positive", L["storm_icon"], "Info")
			phase = 2
		elseif hp < 14 and phase == 2 then
			self:Message("storm", CL["soon"]:format(L["side_swap"]), "Positive", L["storm_icon"], "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

