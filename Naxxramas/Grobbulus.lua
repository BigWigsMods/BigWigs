----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Grobbulus"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.bossName = boss
mod.zoneName = "Naxxramas"
mod.enabletrigger = 15931
mod.guid = 15931
mod.toggleOptions = {28169, "icon", 28240, "berserk", "bosskill"}
mod.consoleCmd = "Grobbulus"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Grobbulus", "enUS", true)
if L then
	L.bomb_message = "Injection"
	L.bomb_message_other = "%s is Injected!"

	L.icon = "Place Icon"
	L.icon_desc = "Place a raid icon on an Injected person. (Requires promoted or higher)"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Grobbulus")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Inject", 28169)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Cloud", 28240)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterMessage("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Inject(player, spellId)
	self:TargetMessage(L["bomb_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["bomb_message"])
	self:Bar(L["bomb_message_other"]:format(player), 10, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:Cloud(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:BigWigs_RecvSync(event, sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		if self.db.profile.berserk then
			self:Enrage(540, true)
		end
	end
end

