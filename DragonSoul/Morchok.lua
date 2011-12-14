--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Morchok", 824, 311)
if not mod then return end
mod:RegisterEnableMob(55265)

local stomp = GetSpellInfo(108571)
local crystal = GetSpellInfo(103640)
local kohcrom = EJ_GetSectionInfo(4262)
local fmtStr = "~%s - %s"
local crystalCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "You seek to halt an avalanche. I will bury you."

	L.crush = "Crush Armor"
	L.crush_desc = "Tank alert only. Count the stacks of crush armor and show a duration bar."
	L.crush_icon = 103687
	L.crush_message = "%2$dx Crush on %1$s"

	L.blood = "Blood"

	L.explosion = "Explosion"
end
L = mod:GetLocale()
L.crush = L.crush.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		108571, "crush", 103640, {103851, "FLASHSHAKE"}, 103846, 109017, "berserk", "bosskill",
	}, {
		[108571] = "general",
	}
end

function mod:OnBossEnable()
	--Heroic
	self:Log("SPELL_CAST_SUCCESS", "SummonKohcrom", 109017)

	--Normal
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "Blood")
	self:Log("SPELL_CAST_START", "Stomp", 108571, 109033, 109034, 103414)
	self:Log("SPELL_CAST_START", "BlackBlood", 103851)
	self:Log("SPELL_AURA_APPLIED", "Furious", 103846)
	self:Log("SPELL_AURA_APPLIED", "Crush", 103687)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Crush", 103687)
	self:Log("SPELL_AURA_APPLIED", "BlackBloodStacks", 110287, 110288, 103785, 108570)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlackBloodStacks", 110287, 110288, 103785, 108570)
	self:Log("SPELL_SUMMON", "ResonatingCrystal", 103639)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55265)
end

function mod:OnEngage(diff)
	self:Berserk(420) -- confirmed
	self:Bar(108571, stomp, 11, 108571)
	self:Bar(103640, crystal, 16, 103640)
	crystalCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SummonKohcrom(_, spellId)
	self:Bar(109017, (fmtStr):format(self.displayName, stomp), 6, spellId)
	self:Bar(109017, (fmtStr):format(kohcrom, stomp), 12, spellId)
end

-- I know it's ugly to use this, but if we were to start bars at :BlackBlood then we are subject to BlackBlood duration changes
function mod:Blood(_, unit, _, _, _, spellId)
	if unit == "boss1" and spellId == 103851 then
		crystalCount = 0
		if self:Difficulty() > 2 then
			self:Bar(108571, (fmtStr):format(self.displayName, stomp), 15, 108571)
			self:Bar(103640, (fmtStr):format(self.displayName, crystal), 22, 103640)
		else
			self:Bar(108571, "~"..stomp, 5, 108571)
			self:Bar(103640, crystal, 29, 103640)
		end
	end
end

function mod:Stomp(_, spellId, source, _, spellName)
	if self:Difficulty() > 2 then
		if UnitExists("boss2") and source ~= kohcrom then--Since we trigger kohcrom bar off morchok for more accuracy, we gotta make sure he exists and he isn't caster to avoid bad timers.
			self:Bar(108571, (fmtStr):format(kohcrom, spellName), (self:Difficulty() == 3) and 6 or 5, 108571)--6sec after on 10 man, 5 sec on 25
		else--It's not kohcrom casting, start morchoks normal bar.
			self:Bar(108571, (fmtStr):format(source, spellName), 12, spellId)
		end
	else
		self:Bar(108571, "~"..spellName, 12, spellId)
	end
end

function mod:Furious(_, spellId, _, _, spellName)
	self:Message(103846, spellName, "Positive", spellId) -- Positive?
end

do
	local prev = 0
	function mod:BlackBlood(_, spellId, _, _, spellName)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(103851, spellName, "Personal", spellId, "Long") -- not really personal, but we tend to associate personal with fns
		end
	end
end

do
	local prev = 0
	function mod:BlackBloodStacks(player, spellId, _, _, spellName)
		local t = GetTime()
		if t-prev > 2 and UnitIsUnit("player", player) then
			prev = t
			self:FlashShake(103851)
			self:LocalMessage(103851, CL["you"]:format(L["blood"]), "Personal", spellId, "Long")
		end
	end
end

function mod:ResonatingCrystal(_, spellId, source, _, spellName)
	if source ~= kohcrom then crystalCount = crystalCount + 1 end--Only incriment count off morchok casts.
	if self:Difficulty() > 2 then
		self:Message(103640, source.." - "..spellName, "Urgent", spellId, "Alarm")
		self:Bar(103640, source.." - "..(L["explosion"]), 12, spellId)
		if UnitExists("boss2") and crystalCount == 2 then--The CD bar will only start off morchok's 2nd crystal, if kohcrom is already summoned. Explosion bar will be CD for kohcrom's 3rd so redundant to have both.
			self:Bar(103640, (fmtStr):format(kohcrom, crystal), (self:Difficulty() == 3) and 6 or 5, 103640)--Same as stomp, 6/5
		end
	else
		self:Message(103640, spellName, "Urgent", spellId, "Alarm")
		self:Bar(103640, L["explosion"], 12, spellId)
	end
end

function mod:Crush(player, spellId, _, _, spellName, buffStack)
	if UnitGroupRolesAssigned("player") ~= "TANK" then return end
	if not buffStack then buffStack = 1 end
	self:SendMessage("BigWigs_StopBar", self, L["crush_message"]:format(player, buffStack - 1))
	self:Bar("crush", L["crush_message"]:format(player, buffStack), 20, spellId)
	self:TargetMessage("crush", L["crush_message"], player, "Urgent", spellId, buffStack > 2 and "Info" or nil, buffStack)
end

