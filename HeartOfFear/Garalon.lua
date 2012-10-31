
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Garalon", 897, 713)
if not mod then return end
mod:RegisterEnableMob(62164, 63191)

-----------------------------------------------------------------------------------------
-- Locals
--

local mendleg = (GetSpellInfo(123495))
local legCounter, mendLegTimerRunning, mendLegCD = 4, false, 44

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122774, {122835, "ICON"}, 123081, 123495, "ej:6294",
		"berserk", "bosskill",
	}, {
		[122774] = "general",
	}
end

function mod:OnBossEnable()
	-- need to figure out which is faster
	self:Log("SPELL_CAST_SUCCESS", "Crush", 122774)
	self:Emote("Crush", "Crush")

	self:Log("SPELL_AURA_APPLIED", "PheromonesApplied", 122835, 123811)
	self:Log("SPELL_AURA_REMOVED", "PheromonesRemoved", 122835, 123811)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Pungency", 123081)
	self:Log("SPELL_CAST_SUCCESS", "MendLeg", 123495)
	self:Log("SPELL_CAST_SUCCESS", "BrokenLeg", 122786)

	-- not sure if a CL.underyou type warning should be added for Pheromone Trail, you aren't really supposed to be near it unless you have Pheromones on

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62164, 63191)
end

function mod:OnEngage(diff)
	legCounter, mendLegTimerRunning = 4, false
	self:Berserk(360) -- assume
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:Crush(a)
	local t = GetTime()
	print(a, t)
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

function mod:Pungency(player, _, _, _, spellName, buffStack)
	-- warn for every 3rd stack once we reach 12 stacks, this might needs some adjusting see what works best
	if buffStack > 11 and buffStack % 3 == 0 and UnitIsUnit("player", player) then
		-- this can't be important or personal because those are already used for these people
		self:LocalMessage(123081, ("%s (%d)"):format(spellName, buffStack), "Attention", 123081)
	end
end


function mod:MendLeg(_, _, _, _, spellName)
	legCounter = legCounter + 1
	if legCounter < 4 then -- don't start a timer if it has all 4 legs
		self:Message(123495, spellName, "Urgent", 123495)
		self:Bar(123495, "~"..spellName, mendLegCD, 123495) -- need logs of longer attempts to verify if it is on a CD or not, assume it is on one for now
	else
		-- all legs grew back, no need to start a bar, :BrokenLeg will start it
		mendLegTimerRunning = false
	end
end

function mod:BrokenLeg()
	legCounter = legCounter - 1
	-- this is just a way to start the bar after 1st legs death
	if not mendLegTimerRunning then
		self:Bar(123495, "~"..mendleg, mendLegCD, 123495) -- need logs of longer attempts to verify if it is CD or not
		mendLegTimerRunning = true
	end
end


function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 38 then -- phase starts at 33
			self:Message("ej:6294", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 108201, "Long") -- the corrent icon
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

