----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Hodir"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32845
mod.toggleOptions = {"hardmode", "cold", 65123, 61968, 62478, "berserk", "icon", "bosskill"}
mod.consoleCmd = "Hodir"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local flashFreezed = mod:NewTargetList()
local fmt = string.format
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

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_START", "FlashCast", 61968)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flash", 61969, 61990)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Frozen", 62478, 63512)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cloud", 65123, 65133)
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Cloud(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Positive", spellId, "Info")
	self:Whisper(player, spellName)
	self:Bar(spellName..": "..player, 30, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:FlashCast(_, spellId, _, _, spellName)
	self:IfMessage(L["flash_warning"], "Attention", spellId)
	self:Bar(spellName, 9, spellId)
	self:Bar(spellName, 35, spellId)
	self:DelayedMessage(30, L["flash_soon"], "Attention")
end

local function flashWarn(spellId, spellName)
	mod:TargetMessage(spellName, flashFreezed, "Urgent", spellId, "Alert")
end

function mod:Flash(player, spellId, _, _, spellName)
	if UnitInRaid(player) then
		flashFreezed[#flashFreezed + 1] = player
		self:ScheduleEvent("BWFFWarn", flashWarn, 0.5, spellId, spellName)
	end
end

function mod:Frozen(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 20, spellId)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		lastCold = nil
		if self:GetOption(61968) then
			local name = GetSpellInfo(61968)
			self:Bar(name, 35, 61968)
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 180, 6673)
		end
		if db.berserk then
			self:Enrage(480, true)
		end
	elseif msg == L["end_trigger"] then
		self:BossDeath(nil, self.guid)
	end
end

function mod:UNIT_AURA(unit)
	if unit and unit ~= "player" then return end
	local _, _, icon, stack = UnitDebuff("player", cold)
	if stack and stack ~= lastCold then
		if db.cold and stack > 1 then
			self:LocalMessage(L["cold_message"]:format(stack), "Personal", icon)
		end
		lastCold = stack
	end
end

