--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Yor'sahj the Unsleeping", 824, 325)
if not mod then return end
mod:RegisterEnableMob(55312)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar! H'IWN IILTH!"

	L.bolt = GetSpellInfo(108383)
	L.bolt_desc = "Tank alert only. Count the stacks of void bolt and show a duration bar."
	L.bolt_icon = 108383
	L.bolt_message = "%2$dx Bolt on %1$s"

	L.blue = "|cFF0080FFBlue|r"
	L.green = "|cFF088A08Green|r"
	L.purple = "|cFF9932CDPurple|r"
	L.yellow = "|cFFFFA901Yellow|r"
	L.black = "|cFF424242Black|r"
	L.red = "|cFFFF0404Red|r"

	L.blobs = "Blobs"
	L.blobs_bar = "Next blob spawn"
	L.blobs_desc = "Blobs moving towards the boss"
	L.blobs_icon = "achievement_doublerainbow"
end
L = mod:GetLocale()
L.bolt = L.bolt.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Locals
--

local colorCombinations = {
	[105420] = { L.purple, L.green, L.blue, L.black },
	[105435] = { L.green, L.red, L.black, L.blue },
	[105436] = { L.green, L.yellow, L.red, L.black },
	[105437] = { L.purple, L.blue, L.yellow, L.green },
	[105439] = { L.blue, L.black, L.yellow, L.purple },
	[105440] = { L.purple, L.red, L.black, L.yellow },
	--[105441] this is some generic thing, don't use it
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"blobs", "bolt", "proximity", "berserk", "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Blobs")
	self:Log("SPELL_AURA_APPLIED", "AcidicApplied", 104898)
	self:Log("SPELL_AURA_REMOVED", "AcidicRemoved", 104898)
	self:Log("SPELL_AURA_APPLIED", "Bolt", 108383, 108384, 108385, 104849, 105416, 109549, 109550, 109551)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Bolt", 108383, 108384, 108385, 104849, 105416, 109549, 109550, 109551)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55312)
end

function mod:OnEngage()
	self:Berserk(600) --complete guess
	self:Bar("blobs", L["blobs_bar"], 21, L["blobs_icon"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Bolt(player, spellId, _, _, spellName, buffStack)
	if self:Tank() then
		buffStack = buffStack or 1
		self:SendMessage("BigWigs_StopBar", self, L["bolt_message"]:format(player, buffStack - 1))
		self:Bar("bolt", L["bolt_message"]:format(player, buffStack), 22, spellId)
		self:LocalMessage("bolt", L["bolt_message"], "Urgent", spellId, buffStack > 2 and "Info" or nil, player, buffStack)
	end
end

function mod:Blobs(_, unit, spellName, _, _, spellId)
	if (unit):find("^boss%d$") and colorCombinations[spellId] then
		if self:Difficulty() > 2 then
			self:Message("blobs", ("%s %s %s %s"):format(colorCombinations[spellId][1], colorCombinations[spellId][2], colorCombinations[spellId][4], colorCombinations[spellId][3]), "Urgent", L["blobs_icon"], "Alarm")
			self:Bar("blobs", L["blobs_bar"], 75, L["blobs_icon"])
		else
			self:Message("blobs", ("%s %s %s"):format(colorCombinations[spellId][1], colorCombinations[spellId][2], colorCombinations[spellId][3]), "Urgent", L["blobs_icon"], "Alarm")
			self:Bar("blobs", L["blobs_bar"], 90, L["blobs_icon"])
		end
	end
end

function mod:AcidicApplied()
	if not self:LFR() then
		self:OpenProximity(4)
	end
end

function mod:AcidicRemoved()
	if not self:LFR() then
		self:CloseProximity()
	end
end

