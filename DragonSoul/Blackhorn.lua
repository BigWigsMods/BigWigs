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
		"sunder", 108862, {108076, "SAY", "FLASHSHAKE", "ICON" }, "sapper", "bosskill",
	}, {
		sunder = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "TwilightFlames", 108076) -- did they just remove this?
	self:Log("SPELL_CAST_START", "TwilightOnslaught", 107588)
	self:Log("SPELL_AURA_APPLIED", "Sunder", 108043)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Sunder", 108043)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Sapper")

	self:Death("Win", 56427)
end

function mod:OnEngage(diff)
	self:Bar(108862, (GetSpellInfo(108862)), 42, 108862) -- Twilight Onslaught
	self:Bar("sapper", L["sapper"], 70, L["sapper_icon"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Sapper(_, msg)
	if msg:find(L["sapper_trigger"]) then
		self:Message("sapper", L["sapper"], "Important", L["sapper_icon"], "Info")
		self:Bar("sapper", L["sapper"], 40, L["sapper_icon"])
	end
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

function mod:Sunder(player, spellId, _, _, spellName, buffStack)
	if UnitGroupRolesAssigned("player") ~= "TANK" then return end
	if not buffStack then buffStack = 1 end
	self:SendMessage("BigWigs_StopBar", self, L["sunder_message"]:format(player, buffStack - 1))
	self:Bar("sunder", L["sunder_message"]:format(player, buffStack), 30, spellId)
	self:TargetMessage("sunder", L["sunder_message"], player, "Urgent", spellId, buffStack > 2 and "Info" or nil, buffStack)
end

