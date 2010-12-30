--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Cho'gall", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(43324)
mod.toggleOptions = {"orders", 91303, 81628, 82299, 82630, 82414, "berserk", "bosskill"}
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
mod.optionHeaders = {
	orders = "heroic",
	[91303] = CL.phase:format(1),
	[82630] = CL.phase:format(2),
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local worshipTargets = mod:NewTargetList()
local worshipCooldown = 24

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	--heroic
	L.orders = "Shadow/Flame Orders"
	L.orders_desc = "Warning for Shadow/Flame Orders"

	--normal
	L.worship_cooldown = "~Worship"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_CAST_SUCCESS", "Orders", 81171, 81556)

	--normal
	self:Log("SPELL_AURA_APPLIED", "Worship", 91317, 93366)
	self:Log("SPELL_CAST_START", "SummonCorruptingAdherent", 81628)
	self:Log("SPELL_CAST_START", "FesterBlood", 82299)
	self:Log("SPELL_CAST_SUCCESS", "LastPhase", 82630)
	self:Log("SPELL_CAST_SUCCESS", "DarkenedCreations", 82414)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 43324)
end


function mod:OnEngage()
	self:Bar(91303, L["worship_cooldown"], 11, 91303)
	self:Bar(81628, (GetSpellInfo(81628)), 58, 81628)
	self:Berserk(600)
	worshipCooldown = 24 -- its not 40 sec till the 1st add
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Orders(_, spellId, _, _, spellName)
	self:Message("orders", spellName, "Urgent", spellId)
end

function mod:SummonCorruptingAdherent(_, spellId, _, _, spellName)
	worshipCooldown = 40
	self:Message(81628, spellName, "Attention", 81628)
	self:Bar(81628, spellName, 91, 81628)
	-- I assume its 40 sec from summon and the timer is not between two casts of Fester Blood
	self:Bar(82299, (GetSpellInfo(82299)), 40, 82299)
end

function mod:FesterBlood(_, spellId, _, _, spellName)
	self:Message(82299, spellName, "Important", spellId, "Alert")
end

function mod:LastPhase(_, spellId, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(81628)))
	self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(82299)))
	self:SendMessage("BigWigs_StopBar", self, L["worship_cooldown"])
	self:Message(82630, spellName, "Attention", spellId)
	self:Bar(82414, (GetSpellInfo(82414)), 6, 82414)
end

function mod:DarkenedCreations(_, spellId, _, _, spellName)
	self:Message(82414, spellName, "Urgent", spellId)
	self:Bar(82414, spellName, 40, 82414)
end

do
	local scheduled = nil
	local function worshipWarn(spellName)
		mod:TargetMessage(91303, spellName, worshipTargets, "Important", 91303, "Alarm")
		scheduled = nil
	end
	function mod:Worship(player, spellId, _, _, spellName)
		worshipTargets[#worshipTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:Bar(91303, L["worship_cooldown"], worshipCooldown, 91303)
			self:ScheduleTimer(worshipWarn, 0.3, spellName)
		end
	end
end

