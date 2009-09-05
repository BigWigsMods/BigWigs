----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["The Iron Council"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
local breaker = BB["Steelbreaker"]
local molgeim = BB["Runemaster Molgeim"]
local brundir = BB["Stormcaller Brundir"]
mod.zoneName = BZ["Ulduar"]
mod.enabletrigger = {breaker, molgeim, brundir, boss}
mod.guid = 32867
mod.toggleOptions = {61869, 63483, 61887, 61903, 64637, "proximity", 62274, 61974, 62269, 62273, "icon", "berserk", "bosskill"}
mod.optionHeaders = {
	[61869] = brundir,
	[61903] = breaker,
	[62274] = brundir,
	proximity = CL.general,
	
}
mod.proximityCheck = "bandage"
mod.consoleCmd = "Council"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local previous = nil
local deaths = 0
local overwhelmTime = 35
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Iron Council", "enUS", true)
if L then
	L.engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!"
	L.engage_trigger2 = "Nothing short of total decimation will suffice."
	L.engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you are still only mortal."

	L.overload_message = "Overload in 6sec!"
	L.death_message = "Rune of Death on YOU!"
	L.summoning_message = "Elementals Incoming!"

	L.chased_other = "%s is being chased!"
	L.chased_you = "YOU are being chased!"

	L.overwhelm_other = "Overwhelming Power: %s"

	L.shield_message = "Rune shield!"

	L.icon = "Raid Target Icon"
	L.icon_desc = "Place a Raid Target Icon on the player targeted by Lightning Tendrils or Overwhelming Power (requires promoted or higher)."

	L.council_dies = "%s dead"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Iron Council")

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_START", "Punch", 61903, 63493) -- Steelbreaker
	self:AddCombatListener("SPELL_AURA_APPLIED", "Overwhelm", 64637, 61888) -- Steelbreaker +2
	self:AddCombatListener("SPELL_AURA_REMOVED", "OverRemove", 64637, 61888)

	self:AddCombatListener("SPELL_AURA_APPLIED", "Shield", 62274, 63489) -- Molgeim
	self:AddCombatListener("SPELL_CAST_SUCCESS", "RunePower", 61974) -- Molgeim
	self:AddCombatListener("SPELL_CAST_SUCCESS", "RuneDeathCD", 62269, 63490) -- Molgeim +1
	self:AddCombatListener("SPELL_AURA_APPLIED", "RuneDeath", 62269, 63490) -- Molgeim +1
	self:AddCombatListener("SPELL_CAST_START", "RuneSummoning", 62273) -- Molgeim +2

	self:AddCombatListener("SPELL_CAST_SUCCESS", "Overload", 61869, 63481) -- Brundir
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Whirl", 63483, 61915) -- Brundir +1
	self:AddCombatListener("SPELL_AURA_APPLIED", "Tendrils", 61887, 63486) -- Brundir +2

	self:AddCombatListener("UNIT_DIED", "Deaths")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Punch(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
end

function mod:Overwhelm(player, spellId, _, _, spellName)
	if player == pName then
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
	self:TargetMessage(spellName, player, "Personal", spellId, "Alert")
	self:Whisper(player, spellName)
	self:Bar(L["overwhelm_other"]:format(player), overwhelmTime, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:OverRemove(player)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
	self:TriggerEvent("BigWigs_StopBar", self, L["overwhelm_other"]:format(player))
end

function mod:Shield(unit, spellId)
	if unit == molgeim then
		self:IfMessage(L["shield_message"], "Attention", spellId)
	end
end

function mod:RunePower(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Positive", spellId)
	self:Bar(spellName, 30, spellId)
end

function mod:RuneDeathCD(_, spellId, _, _, spellName)
	self:Bar(spellName, 30, spellId)
end

function mod:RuneDeath(player, spellId)
	if player == pName then
		self:LocalMessage(L["death_message"], "Personal", spellId, "Alarm")
	end
end

function mod:RuneSummoning(_, spellId)
	self:IfMessage(L["summoning_message"], "Attention", spellId)
end

function mod:Overload(_, spellId, _, _, spellName)
	self:IfMessage(L["overload_message"], "Attention", spellId, "Long")
	self:Bar(spellName, 6, spellId)
end

function mod:Whirl(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
end

local function targetCheck()
	local target
	if UnitName("target") == brundir then
		target = UnitName("targettarget")
	elseif UnitName("focus") == brundir then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == brundir then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target ~= previous then
		if target then
			if target == pName then
				mod:LocalMessage(L["chased_you"], "Personal", nil, "Alarm")
			else
				mod:IfMessage(L["chased_other"]:format(target), "Attention")
				mod:Whisper(player, L["chased_you"])
			end
			mod:PrimaryIcon(target, "icon")
			previous = target
		else
			previous = nil
		end
	end
end

local function tendrilsRemove()
	mod:CancelScheduledEvent("BWTendrilsToTScan")
	mod:PrimaryIcon(false, "icon")
end

function mod:Tendrils(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 25, spellId)
	self:ScheduleRepeatingEvent("BWTendrilsToTScan", targetCheck, 0.2)
	self:ScheduleEvent("TargetCancel", tendrilsRemove, 25)
end

function mod:Deaths(unit, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid or guid == 32927 or guid == 32857 then
		deaths = deaths + 1
		if deaths < 3 then
			self:IfMessage(L["council_dies"]:format(unit), "Positive")
		end
	end
	if deaths == 3 then
		self:BossDeath(nil, self.guid)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger1"]) or msg:find(L["engage_trigger2"]) or msg:find(L["engage_trigger3"]) then
		previous = nil
		deaths = 0
		overwhelmTime = GetRaidDifficulty() == 1 and 60 or 35
		if db.berserk then
			self:Enrage(900, true)
		end
	end
end

