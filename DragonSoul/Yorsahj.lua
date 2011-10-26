if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Yor'sahj the Unsleeping", 824, 325)
if not mod then return end
mod:RegisterEnableMob(55312)

--------------------------------------------------------------------------------
-- Localization
--

local blobs_icon = (select(10, GetAchievementInfo(6129)))

local L = mod:NewLocale("enUS", true)
if L then
	L.bolt = "Void Bolt"
	L.bolt_desc = "Tank alert only. Count the stacks of void bolt and show a duration bar."
	L.bolt_icon = 108383
	L.bolt_message = "%2$dx Bolt on %1$s"

	L.blue = "Blue"
	L.green = "Green"
	L.purple = "Purple"
	L.yellow = "Yellow"
	L.black = "Black"
	L.red = "Red"

	L.blobs = "Blobs"
	L.blobs_bar = "Next blob spawn"
	L.blobs_desc = "Blobs moving towards the boss"
	L.blobs_icon = "achievement_doublerainbow"
end
L = mod:GetLocale()
L.bolt = L.bolt.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Locales
--

local bolt = (GetSpellInfo(108383))

local blue = ("|cFF0080FFL%s|r"):format(L["blue"])
local green = ("|cFF088A08L%s|r"):format(L["green"])
local purple = ("|cFF9932CDL%s|r"):format(L["purple"])
local yellow = ("|cFFFFA901L%s|r"):format(L["yellow"])
local black = ("|cFF424242L%s|r"):format(L["black"])
local red = ("|cFFFF0404L%s|r"):format(L["red"])

local colorCombinations = {
	[105420] = { purple, green, blue },
	[105435] = { green, red, black },
	[105436] = { green, yellow, red },
	[105437] = { blue, purple, yellow },
	[105439] = { blue, black, yellow },
	[105440] = { purple, red, black },
	--[105441] this is some generic thing, don't use it
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"blobs", "bolt", "proximity", "bosskill"
	}, {
		blobs = "general"
	}
end

function mod:OnBossEnable()

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_AURA_APPLIED", "AcidicApplied", 104898)
	self:Log("SPELL_AURA_REMOWED", "AcidicRemowed", 104898)
	self:Log("SPELL_AURA_APPLIED", "Bolt", 108383)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Bolt", 108383)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55312)
end

function mod:OnEngage(diff)

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Bolt(player, spellId, _, _, spellName, buffStack)
	if UnitGroupRolesAssigned("player") ~= "TANK" then return end
	if not buffStack then buffStack = 1 end
	self:SendMessage("BigWigs_StopBar", self, L["bolt_message"]:format(player, buffStack - 1))
	self:Bar("bolt", L["bolt_message"]:format(player, buffStack), 30, spellId)
	self:TargetMessage("bolt", L["bolt_message"], player, "Urgent", spellId, buffStack > 2 and "Info" or nil, buffStack)
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellName, _, _, spellId)
		if colorCombinations[spellId] then
			local t = GetTime()
			if t-prev > 5 then
				prev = t
				if self:Difficulty() > 2 then
					self:Message("blobs", ("%s %s %s %s"):format(colorCombinations[spellId][1], colorCombinations[spellId][2], colorCombinations[spellId][3]. colorCombinations[spellId][4]), "Urgent", blobs_icon, "Alarm")
				else
					self:Message("blobs", ("%s %s %s"):format(colorCombinations[spellId][1], colorCombinations[spellId][2], colorCombinations[spellId][3]), "Urgent", blobs_icon, "Alarm")
				end
				self:Bar("blobs", L["blobs_bar"], 75, blobs_icon)
			end
		end
	end
end

-- $ cat WoWCombatLog.txt | grep "APPLIED.*Yor.*,BUFF" | cut -d , -f 10,11 | sort | uniq
--104894,"Black Blood of Shu'ma"
--104896,"Shadowed Blood of Shu'ma"
--104897,"Crimson Blood of Shu'ma"
--104898,"Acidic Blood of Shu'ma"
--104901,"Glowing Blood of Shu'ma"
--105027,"Cobalt Blood of Shu'ma"
--108221,"Glowing Blood of Shu'ma"

function mod:AcidicApplied()
	self:OpenProximity(4)
end

function mod:AcidicRemowed()
	self:CloseProximity(4)
end

