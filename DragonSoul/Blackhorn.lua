--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Warmaster Blackhorn", 824, 332)
if not mod then return end
mod:RegisterEnableMob(56781, 56427, 56598, 42288, 55870 ) -- Boss engage npc, Blackhorn, The Skyfire, Ka'anu Reevs, Sky Captain Swayze

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.harpooning = "Harpooning"

	L.rush = "Blade Rush"
	L.rush_desc = select(2, EJ_GetSectionInfo(4198))
	L.rush_icon = 100 -- charge icon

	L.sunder = "Sunder Armor"
	L.sunder_desc = "Tank alert only. Count the stacks of sunder armor and show a duration bar."
	L.sunder_icon = 108043
	L.sunder_message = "%2$dx Sunder on %1$s"

	L.sapper_trigger = "A drake swoops down to drop a Twilight Sapper onto the deck!"
	L.sapper = "Sapper"
	L.sapper_desc = "Sapper dealing damage to the ship"
	L.sapper_icon = 73457
end
L = mod:GetLocale()
L.sunder = L.sunder.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"sunder", 108862, {108076, "SAY", "FLASHSHAKE", "ICON"}, "sapper", {108046, "SAY", "FLASHSHAKE"}, "berserk", "bosskill",
	}, {
		sunder = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "TwilightFlames", 108076) -- did they just remove this?
	self:Log("SPELL_CAST_START", "TwilightOnslaught", 107588)
	self:Log("SPELL_CAST_START", "Shockwave", 108046)
	self:Log("SPELL_AURA_APPLIED", "Sunder", 108043)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Sunder", 108043)
	self:Emote("Sapper", L["sapper_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Win", 56427)
end

function mod:OnEngage(diff)
	self:Bar(108862, (GetSpellInfo(108862)), 42, 108862) -- Twilight Onslaught
	if not self:LFR() then
		self:Bar("sapper", L["sapper"], 70, L["sapper_icon"])
	end
	if self:Difficulty() > 2 then
		self:Berserk(420)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Sapper()
	self:Message("sapper", L["sapper"], "Important", L["sapper_icon"], "Info")
	self:Bar("sapper", L["sapper"], 40, L["sapper_icon"])
end

do
	local function checkTarget(sGUID)
		local mobId = mod:GetUnitIdByGUID(sGUID)
		if mobId then
			local player = UnitName(mobId.."target")
			if not player then return end
			if UnitIsUnit("player", player) then
				local twilightFlames = GetSpellInfo(108076)
				mod:Say(108076, CL["say"]:format(twilightFlames))
				mod:FlashShake(108076)
				mod:LocalMessage(108076, twilightFlames, "Personal", 108076, "Long")
			end
			mod:PrimaryIcon(108076, player)
		end
	end
	function mod:TwilightFlames(...)
		local sGUID = select(11, ...)
		self:ScheduleTimer(checkTarget, 0.1, sGUID)
	end
end

function mod:TwilightOnslaught(_, spellId, _, _, spellName)
	self:Message(108862, spellName, "Urgent", spellId, "Alarm")
	self:Bar(108862, spellName, 35, spellId)
end

do
	local timer, fired = nil, 0
	local function shockWarn()
		fired = fired + 1
		local player = UnitName("boss1target")
		if player and (not UnitDetailedThreatSituation("boss1target", "boss1") or fired > 11) then
			-- If we've done 12 (0.6s) checks and still not passing the threat check, it's probably being cast on the tank
			local shockwave = GetSpellInfo(108046)
			mod:TargetMessage(108046, shockwave, player, "Urgent", 108046, "Alarm")
			mod:CancelTimer(timer, true)
			timer = nil
			if UnitIsUnit("boss1target", "player") then
				mod:FlashShake(108046)
				mod:Say(108046, CL["say"]:format(shockwave))
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer, true)
			timer = nil
		end
	end
	function mod:Shockwave()
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(shockWarn, 0.05)
		end
	end
end

function mod:Sunder(player, spellId, _, _, spellName, buffStack)
	if UnitGroupRolesAssigned("player") ~= "TANK" then return end
	if not buffStack then buffStack = 1 end
	self:SendMessage("BigWigs_StopBar", self, L["sunder_message"]:format(player, buffStack - 1))
	self:Bar("sunder", L["sunder_message"]:format(player, buffStack), 30, spellId)
	self:TargetMessage("sunder", L["sunder_message"], player, "Urgent", spellId, buffStack > 2 and "Info" or nil, buffStack)
end

