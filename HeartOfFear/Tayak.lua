
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blade Lord Ta'yak", 897, 744)
if not mod then return end
mod:RegisterEnableMob(62543)

--------------------------------------------------------------------------------
-- Locals
--

local unseenStrike, bladeTempest = (GetSpellInfo(122994)), (GetSpellInfo(125310))

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.unseenstrike_cone = "Cone of Unseen Strike"

	L.assault = "Overwhelming Assault"
	L.assault_desc = "Tank alert only. The attack leaves the target's defenses exposed, increasing the target's damage taken when an Overwhelming Assault lands by 100% for 45 sec."
	L.assault_icon = 123474
end
L = mod:GetLocale()
L.assault = L.assault.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{125310, "FLASHSHAKE"},
		{ "ej:6346", "ICON" }, "assault", "proximity", 122842, "ej:6350",
		"berserk", "bosskill",
	}, {
		[125310] = "heroic",
		["ej:6346"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_CAST_SUCCESS", "Assault", 123474)
	self:Log("SPELL_CAST_START", "BladeTempest", 125310)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62543)
end

function mod:OnEngage(diff)
	if self:Heroic() then
		self:Bar(125310, bladeTempest, 60, 125310)
	end
	self:OpenProximity(8)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:Bar("ej:6346", unseenStrike, 30, 122994)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BladeTempest(_, _, _, _, spellName)
	self:Message(125310, spellName, "Important", 125310, "Alarm")
	self:Bar(125310, spellName, 60, 125310)
	self:FlashShake(125310)
end

do
	local function warnStrike(spellName)
		local player = UnitName("boss1target") -- because this event does not supply destName with UNIT_SPELLCAST_SUCCEEDED
		mod:TargetMessage("ej:6346", spellName, player, "Urgent", 122994, "Alarm")
		mod:PrimaryIcon("ej:6346", player)
	end
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
		if unit == "boss1" then
			if spellId == 122949 then -- Unseen Strike
				self:Bar("ej:6346", L["unseenstrike_cone"], 5, 122994)
				self:Bar("ej:6346", spellName, 60, 122994)
				self:ScheduleTimer(warnStrike, 0.5, spellName) -- still faster than using boss emote (0.4 needs testing)
			elseif spellId == 122839 then -- correct spellId -- tempest slash
				if self:Heroic() then
					self:Bar(122842, "~"..spellName, 15.6, 122842)
				else
					self:Bar(122842, "~"..spellName, 20.5, 122842)
				end
				-- don't think this needs a message
			elseif spellId == 123814 then
				self:Message("ej:6350", CL["phase"]:format(2), "Positive", 106996, "Info") -- the corrent icon
				self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(125310))) --blade tempest
				self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(122839))) --tempest slash
				self:SendMessage("BigWigs_StopBar", self, unseenStrike)
			end
		end
	end
end

function mod:Assault(player, spellId, _, _, spellName)
	if self:Tank() then
		-- ability has a 21sec CD might want to add a bar for that too
		self:Bar("assault", ("%s (%s)"):format(player, spellName), 45, spellId)
		self:TargetMessage("assault", spellName, player, "Urgent", spellId)
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 25 then -- phase starts at 20
			self:Message("ej:6350", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 106996, "Info") -- the corrent icon
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end
