----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Hodir", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(32845)
mod:Toggle("hardmode", "BAR")
mod:Toggle("cold", "MESSAGE", "FLASHNSHAKE")
mod:Toggle(65123, "MESSAGE", "BAR", "WHISPER", "ICON")
mod:Toggle(61968, "MESSAGE", "BAR")
mod:Toggle(62478, "MESSAGE", "BAR")
mod:Toggle("berserk")
mod:Toggle("bosskill")
-- mod.toggleOptions = {"hardmode", "cold", 65123, 61968, 62478, "icon", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local flashFreezed = mod:NewTargetList()
local lastCold = nil
local cold = GetSpellInfo(62039)
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Hodir", "enUS", true)
if L then
	L.engage_trigger = "You will suffer for this trespass!"

	L.cold = "Biting Cold"
	L.cold_desc = "Warn when you have 2 or more stacks of Biting Cold."
	L.cold_message = "Biting Cold x%d!"

	L.flash_warning = "Freeze!"
	L.flash_soon = "Freeze in 5sec!"

	L.hardmode = "Hard mode"
	L.hardmode_desc = "Show timer for hard mode."

	L.icon = "Place icon"
	L.icon_desc = "Place a raid icon on players who get targetted with the Storm Clouds."

	L.end_trigger = "I... I am released from his grasp... at last."
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Hodir")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FlashCast", 61968)
	self:Log("SPELL_AURA_APPLIED", "Flash", 61969, 61990)
	self:Log("SPELL_AURA_APPLIED", "Frozen", 62478, 63512)
	self:Log("SPELL_AURA_APPLIED", "Cloud", 65123, 65133)
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Cloud(player, spellId, _, _, spellName)
	self:TargetMessage(65123, spellName, player, "Positive", spellId, "Info")
	self:Whisper(65123, player, spellName)
	self:Bar(65123, spellName..": "..player, 30, spellId)
	self:PrimaryIcon(65123, player)
end

function mod:FlashCast(_, spellId, _, _, spellName)
	self:IfMessage(61968, L["flash_warning"], "Attention", spellId)
	self:Bar(61968, spellName, 9, spellId)
	self:Bar(61968, spellName, 35, spellId)
	self:DelayedMessage(61968, 30, L["flash_soon"], "Attention")
end

local function flashWarn(spellId, spellName)
	mod:TargetMessage(61968, spellName, flashFreezed, "Urgent", spellId, "Alert")
end

function mod:Flash(player, spellId, _, _, spellName)
	if UnitInRaid(player) then
		flashFreezed[#flashFreezed + 1] = player
		self:ScheduleEvent("BWFFWarn", flashWarn, 0.5, spellId, spellName)
	end
end

function mod:Frozen(_, spellId, _, _, spellName)
	self:IfMessage(62478, spellName, "Important", spellId)
	self:Bar(62478, spellName, 20, spellId)
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg == L["engage_trigger"] then
		lastCold = nil
		local name = GetSpellInfo(61968)
		self:Bar(61968, name, 35, 61968)
		self:Bar("hardmode", L["hardmode"], 180, 6673)
		self:Berserk(480)
	elseif msg == L["end_trigger"] then
		self:Win()
	end
end

function mod:UNIT_AURA(event, unit)
	if unit and unit ~= "player" then return end
	local _, _, icon, stack = UnitDebuff("player", cold)
	if stack and stack ~= lastCold then
		if stack > 1 then
			self:LocalMessage("cold", L["cold_message"]:format(stack), "Personal", icon)
		end
		lastCold = stack
	end
end

