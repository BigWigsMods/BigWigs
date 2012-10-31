
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Garalon", 897, 713)
if not mod then return end
mod:RegisterEnableMob(62164, 63191) -- Verify id

-----------------------------------------------------------------------------------------
-- Locals
--

local legCounter, mendLegTimerRunning, mendLegCD = 4, false, 30

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.crush_stun = "Crush stun"
	L.crush_trigger = "Garalon prepares to"
	L.crush_trigger1 = "Garalon senses"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122774, {122835, "ICON"}, 123081, 123495, "ej:6294", 122735,
		"berserk", "bosskill",
	}, {
		[122774] = "general",
	}
end

function mod:OnBossEnable()
	self:Emote("Crush", L["crush_trigger"], L["crush_trigger1"])

	self:Log("SPELL_AURA_APPLIED", "PheromonesApplied", 122835, 123811)
	self:Log("SPELL_AURA_REMOVED", "PheromonesRemoved", 122835, 123811)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Pungency", 123081)
	self:Log("SPELL_CAST_SUCCESS", "MendLeg", 123495)
	self:Log("SPELL_CAST_SUCCESS", "BrokenLeg", 122786)
	self:Log("SPELL_CAST_START", "FuriousSwipe", 122735)

	-- not sure if a CL.underyou type warning should be added for Pheromone Trail, you aren't really supposed to be near it unless you have Pheromones on

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62164, 63191)
end

function mod:OnEngage(diff)
	legCounter, mendLegTimerRunning = 4, false
	self:Berserk(420)
	if self:Heroic() then
		self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:Crush()
	self:Bar(122774, L["crush_stun"], 4, 122082)
	self:Message(122774, 122774, "Important", 122082, "Alarm") -- Crush
end

function mod:PheromonesApplied(player, _, _, _, spellName)
	self:PrimaryIcon(122835, player)
	if UnitIsUnit("player", player) then
		-- Local message with personal and info for when you gain the debuff, others don't care that you got it
		self:LocalMessage(122835, CL["you"]:format(spellName), "Personal", 116417, "Info")
	end
end

function mod:PheromonesRemoved(player, _, _, _, spellName)
	SetRaidTarget(player, 0)
	if UnitIsUnit("player", player) then
		-- Local message with important and alarm for when you loose the debuff, others don't care that you lost it
		self:LocalMessage(122835, CL["other"]:format(spellName, player), "Important", 116417, "Alarm")
	end
end

function mod:Pungency(player, spellId, _, _, spellName, buffStack)
	if self:Heroic() then
		if buffStack > 3 and buffStack % 2 == 0 then
			self:TargetMessage(spellId, ("%s (%d)"):format(spellName, buffStack), player, "Attention", spellId)
		end
	else
		if buffStack > 7 and buffStack % 2 == 0 then
			self:TargetMessage(spellId, ("%s (%d)"):format(spellName, buffStack), player, "Attention", spellId)
		end
	end
end


function mod:MendLeg(_, spellId, _, _, spellName)
	legCounter = legCounter + 1
	if legCounter < 4 then -- don't start a timer if it has all 4 legs
		self:Message(spellId, spellName, "Urgent", spellId)
		self:Bar(spellId, "~"..spellName, mendLegCD, spellId)
	else
		-- all legs grew back, no need to start a bar, :BrokenLeg will start it
		mendLegTimerRunning = false
	end
end

function mod:BrokenLeg()
	legCounter = legCounter - 1
	-- this is just a way to start the bar after 1st legs death
	if not mendLegTimerRunning then
		self:Bar(123495, "~"..self:SpellName(123495), mendLegCD, 123495) -- need logs of longer attempts to verify if it is CD or not
		mendLegTimerRunning = true
	end
end

function mod:FuriousSwipe(_, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 8, spellId)
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if not unitId then return end
	local GUID = UnitGUID(unitId)
	if not GUID then return end
	local id = tonumber(GUID:sub(7, 10), 16)
	if id == 62164 or id == 63191 then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 38 then -- phase starts at 33
			self:Message("ej:6294", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 108201, "Long") -- the corrent icon
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

