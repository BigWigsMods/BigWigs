if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ultraxion", 824, 331)
if not mod then return end
mod:RegisterEnableMob(55294, 56667) -- Ultraxion, Thrall

--------------------------------------------------------------------------------
-- Locales
--

local hour, fadingLight = (GetSpellInfo(106371)), (GetSpellInfo(105925))
local fadingLightTimers, fadingLightCounter = { 45, 15, 75, 15, 75, 15 }, 1 -- probably linked to some event, but just use this for now
local firstHour = true
local lightTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "I sense a great disturbance in the balance approaching. The chaos of it burns my mind"

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"warmup", {106371, "FLASHSHAKE"}, {105925, "FLASHSHAKE"}, "berserk", "bosskill",
	}, {
		warmup = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "HourofTwilight", 106371, 109415)
	self:Log("SPELL_AURA_APPLIED", "FadingLight", 105925, 109075)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55294)
end

function mod:Warmup(_, msg)
	if msg == L["engage_trigger"] then
		self:Bar("warmup", self.displayName, 35, "achievement_dungeon_dragonsoul_raid_ultraxion")
	end
end

function mod:OnEngage(diff)
	self:SendMessage("BigWigs_StopBar", self, self.displayName)
	self:Berserk(360)
	self:Bar(106371, hour, 45, 106371)
	firstHour = true
	fadingLightCounter = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HourofTwilight(_, spellId, _, _, spellName)
	if firstHour then
		self:Bar(105925, fadingLight, 45, 105925)
		firstHour = false
	end
	self:FlashShake(106371)
	self:Message(106371, spellName, "Urgent", spellId, "Alert")
	self:Bar(106371, spellName, 45, spellId)
end

do
	local scheduled = nil
	local function fadingLight(spellName)
		mod:TargetMessage(105925, spellName, lightTargets, "Urgent", 105925, "Alert")
		scheduled = nil
	end
	function mod:FadingLight(player, spellId, _, _, spellName)
		lightTargets[#lightTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(105925)
		end
		-- spellId specially only used for tanks, but used every time (poor mans antispam)
		-- should be a bit more accurate then using it in fadingLight
		if spellId == 105925 then
			self:Bar(105925, spellName, fadingLightTimers[fadingLightCounter], spellId)
			fadingLightCounter = fadingLightCounter + 1
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(fadingLight, 0.1, spellName)
		end
	end
end

