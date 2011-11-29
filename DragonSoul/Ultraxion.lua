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
local hourCounter = 1
local lightTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "I am the beginning of the end...the shadow which blots out the sun"

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
	self:Log("SPELL_CAST_START", "HourofTwilight", 106371, 109415, 109416, 109417)
	self:Log("SPELL_AURA_APPLIED", "FadingLight", 105925, 109075, 110068, 110069, 110078, 110079, 110070, 110080)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Yell("Warmup", L["engage_trigger"])

	self:Death("Win", 55294)
end

function mod:Warmup()
	self:Bar("warmup", self.displayName, 30, "achievment_boss_ultraxion")
end

function mod:OnEngage(diff)
	self:SendMessage("BigWigs_StopBar", self, self.displayName)
	self:Berserk(360)
	self:Bar(106371, hour, 45, 106371)
	hourCounter = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HourofTwilight(_, spellId, _, _, spellName)
	if hourCounter == 1 then
		self:Bar(105925, fadingLight, 45, 105925)
	end
	self:FlashShake(106371)
	self:Message(106371, ("%s (%d)"):format(spellName, hourCounter), "Urgent", spellId, "Alert")
	hourCounter = hourCounter + 1
	self:Bar(106371, ("%s (%d)"):format(spellName, hourCounter), 45, spellId)

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
			local remaining = (select(6, UnitDebuff(player, spellName)))
			self:Bar(105925, spellName, remaining, spellId)
			self:FlashShake(105925)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(fadingLight, 0.1, spellName)
		end
	end
end

