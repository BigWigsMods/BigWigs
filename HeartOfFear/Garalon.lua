
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Garalon", 897, 713)
if not mod then return end
mod:RegisterEnableMob(62164, 63191) -- 63191 you interact with, 62164 casts all the abilities

-----------------------------------------------------------------------------------------
-- Locals
--

local legCounter, mendLegTimerRunning = 4, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.crush_stun = "Crush stun"
	L.crush_trigger1 = "Garalon prepares to"
	L.crush_trigger2 = "Garalon senses" --Garalon senses the passage of Pheromones and begins to cast [Crush]!
	L.crush_trigger3 = "Garalon detects" --Garalon detects Baddie under him and begins to cast [Crush]!
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122774, 122735, 122754, {122835, "ICON"}, 123120, 123081, 123495, "ej:6294",
		"berserk", "bosskill",
	}, {
		[122774] = "general",
	}
end

function mod:OnBossEnable()
	self:Emote("Crush", L["crush_trigger1"], L["crush_trigger2"], L["crush_trigger3"])

	self:Log("SPELL_AURA_APPLIED", "PheromonesApplied", 122835)
	self:Log("SPELL_AURA_REMOVED", "PheromonesRemoved", 122835)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Pungency", 123081)
	self:Log("SPELL_CAST_SUCCESS", "MendLeg", 123495)
	self:Log("SPELL_CAST_SUCCESS", "BrokenLeg", 122786)
	self:Log("SPELL_CAST_START", "FuriousSwipe", 122735)
	self:Log("SPELL_AURA_APPLIED", "Fury", 122754)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Fury", 122754)
	self:Log("SPELL_DAMAGE", "PheromoneTrail", 123120)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62164, 63191)
end

function mod:OnEngage(diff)
	legCounter, mendLegTimerRunning = 4, nil
	self:Berserk(420)
	self:Bar(122735, 122735, 11, 122735) --Furious Swipe
	if self:Heroic() then
		self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:PheromoneTrail(player, _, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(123120, CL["underyou"]:format(spellName), "Personal", 123120, "Alert") -- even tho we usually use Alarm, Alarm has been sued too much in the module
		end
	end
end

function mod:Crush()
	self:Message(122774, CL["soon"]:format(self:SpellName(122774)), "Important", 122774, "Alarm") -- Crush
	--self:Bar(122774, L["crush_stun"], 4, 122774)
	self:Bar(122774, CL["cast"]:format(self:SpellName(122774)), 3.6, 122774) --Crush

	self:Bar(122735, 122735, 9, 122735) --Furious Swipe
end

function mod:Fury(_, spellId, _, _, spellName, buffStack, _, _, _, dGUID)
	--Garalon-62164 gains the buff, then casts Fury, which gives the buff to Garalon-63191
	if self:GetCID(dGUID) == 62164 then
		self:Bar(spellId, spellName, 30, 119622) --Rage like icon (swipe and fury have the same)
		self:Message(spellId, ("%s (%d)"):format(spellName, buffStack or 1), "Urgent", 119622)
	end
end

function mod:PheromonesApplied(player, spellId, _, _, spellName)
	self:PrimaryIcon(spellId, player)
	if UnitIsUnit("player", player) then
		-- Local message with personal and info for when you gain the debuff, others don't care that you got it
		self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId, "Info")
	elseif self:Healer() then
		selt:LocalMessage(spellId, spellName, "Attention", spellId, nil, player)
	end
end

function mod:PheromonesRemoved(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		-- Local message with important and alarm for when you loose the debuff, others don't care that you lost it
		self:LocalMessage(spellId, CL["other"]:format(spellName, player), "Important", spellId, "Alarm")
	end
end

function mod:Pungency(player, spellId, _, _, spellName, buffStack)
	if buffStack > (self:Heroic() and 3 or 7) and buffStack % 2 == 0 then
		self:TargetMessage(spellId, ("%s (%d)"):format(spellName, buffStack), player, "Attention", spellId)
	end
end

function mod:MendLeg(_, spellId, _, _, spellName)
	legCounter = legCounter + 1
	if legCounter < 4 then -- don't start a timer if it has all 4 legs
		self:Message(spellId, spellName, "Urgent", spellId)
		self:Bar(spellId, "~"..spellName, 30, spellId)
	else
		-- all legs grew back, no need to start a bar, :BrokenLeg will start it
		mendLegTimerRunning = nil
	end
end

function mod:BrokenLeg()
	legCounter = legCounter - 1
	-- this is just a way to start the bar after 1st legs death
	if not mendLegTimerRunning then
		self:Bar(123495, "~"..self:SpellName(123495), 30, 123495)
		mendLegTimerRunning = nil
	end
end

do
	--Furious Swipe's cast time is 2.5ish seconds, with 8s between SPELL_CAST_STARTs
	local function nextSwipe(spellName)
		mod:Bar(122735, spellName, 8, 122735)
	end
	function mod:FuriousSwipe(_, spellId, _, _, spellName)
		--delay the bar so it ends when the damage occurs
		self:ScheduleTimer(nextSwipe, 2.5, spellName)
	end

	--[[
	--another idea is we have one bar for the cd and one bar for the cast, but they're both pretty short
	local function nextSwipe(spellName)
		self:Bar(122735, spellName, 5.5, 122735)
	end
	function mod:FuriousSwipe(_, spellId, _, _, spellName)
		self:StopBar(spellName)
		self:Bar(122735, CL["cast"]:format(spellName), 2.5, spellId) --use "cast" to help distinguish the two bars
		self:ScheduleTimer(nextSwipe, 2.5, spellName)
	end
	--]]
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if not unitId:find("boss", nil, true) then return end
	local id = self:GetCID(UnitGUID(unitId))
	if id == 62164 or id == 63191 then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 38 then -- phase starts at 33
			self:Message("ej:6294", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 108201, "Long") -- the corrent icon
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

