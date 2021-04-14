
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Viscidus", 531)
if not mod then return end
mod:RegisterEnableMob(15299)
mod:SetAllowWin(true)
mod:SetEncounterID(713)

local swingCount = -1
local frostCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Viscidus"

	L.freeze = "Freezing States"
	L.freeze_desc = "Warn for the different frozen states."
	L.freeze_icon = "spell_frost_glacier"

	L.freeze_trigger1 = "begins to slow!"
	L.freeze_trigger2 = "is freezing up!"
	L.freeze_trigger3 = "is frozen solid!"
	L.freeze_trigger4 = "begins to crack!"
	L.freeze_trigger5 = "looks ready to shatter!"

	L.freeze_warn1 = "First freeze phase!"
	L.freeze_warn2 = "Second freeze phase!"
	L.freeze_warn3 = "Viscidus is frozen!"
	L.freeze_warn4 = "Cracking up - keep going!"
	L.freeze_warn5 = "Cracking up - almost there!"
	L.freeze_warn_melee = "%d melee attacks - %d more to go"
	L.freeze_warn_frost = "%d frost attacks - %d more to go"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"freeze",
		25991, -- Poison Bolt Volley
		25989, -- Toxin
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "PoisonBoltVolley", 25991)

	self:Log("SPELL_PERIODIC_DAMAGE", "ToxinDamage", 25989)
	self:Log("SPELL_PERIODIC_MISSED", "ToxinDamage", 25989)
	self:Log("SPELL_AURA_APPLIED", "ToxinDamage", 25989)

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") -- yikes
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
end

function mod:OnWipe()
	frostCount = 0 -- We might pull with a frost ability, so don't reset on engage
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PoisonBoltVolley(args)
	swingCount = -1
	self:Message(25991, "yellow")
	self:CDBar(25991, 10)
end

do
	local prev = 0
	function mod:ToxinDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(25989, "blue", CL.underyou:format(args.spellName))
			self:PlaySound(25989, "alarm")
		end
	end
end

do
	local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo -- XXX InfoBox?
	function mod:COMBAT_LOG_EVENT_UNFILTERED()
		local _,event,_,_,_,_,_,destGUID,_,_,_,_,_,school = CombatLogGetCurrentEventInfo()
		if event == "SPELL_DAMAGE" then
			if school == 0x10 and self:MobId(destGUID) == 15299 then -- 0x10 is Frost
				frostCount = frostCount + 1
				if frostCount < 20 and frostCount % 3 == 0 then
					self:Message("freeze", "green", L.freeze_warn_frost:format(frostCount, 20-frostCount), L.freeze_icon)
				end
			end
		elseif event == "SWING_DAMAGE" and swingCount ~= -1 and self:MobId(destGUID) == 15299 then
			swingCount = swingCount + 1
			if swingCount < 30 and swingCount % 3 == 0 then
				self:Message("freeze", "green", L.freeze_warn_melee:format(swingCount, 30-swingCount), L.freeze_icon)
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if msg:find(L.freeze_trigger1) then
		self:Message("freeze", "cyan", L.freeze_warn1, L.freeze_icon)
	elseif msg:find(L.freeze_trigger2) then
		self:Message("freeze", "cyan", L.freeze_warn2, L.freeze_icon)
	elseif msg:find(L.freeze_trigger3) then
		swingCount = 0
		self:Message("freeze", "red", L.freeze_warn3, L.freeze_icon)
		self:Bar("freeze", 30, L.freeze_warn3, L.freeze_icon)
		self:ScheduleTimer("OnWipe", 27) -- Reset the frostCount
	elseif msg:find(L.freeze_trigger4) then
		self:Message("freeze", "orange", L.freeze_warn4, L.freeze_icon)
	elseif msg:find(L.freeze_trigger5) then
		self:Message("freeze", "red", L.freeze_warn5, L.freeze_icon)
	end
end
