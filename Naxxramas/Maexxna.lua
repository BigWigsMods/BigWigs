----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Maexxna"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15952
mod.toggleOptions = {29484, 28622, 54123, "bosskill"}
mod.consoleCmd = "Maexxna"

------------------------------
--      Are you local?      --
------------------------------

local inCocoon = mod:NewTargetList()
local started = nil
local enrageannounced = nil

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Maexxna", "enUS", true)
if L then
	L.webspraywarn30sec = "Cocoons in 10 sec"
	L.webspraywarn20sec = "Cocoons! Spiders in 10 sec!"
	L.webspraywarn10sec = "Spiders! Spray in 10 sec!"
	L.webspraywarn5sec = "WEB SPRAY in 5 seconds!"
	L.webspraywarn = "Web Spray! 40 sec until next!"
	L.enragewarn = "Enrage - SQUISH SQUISH SQUISH!"
	L.enragesoonwarn = "Enrage Soon - Bugsquatters out!"

	L.webspraybar = "Web Spray"
	L.cocoonbar = "Cocoons"
	L.spiderbar = "Spiders"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Maexxna")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cocoon", 28622)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enrage", 54123, 54124) --Norm/Heroic
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spray", 29484, 54125)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("UNIT_HEALTH")

	wipe(inCocoon)
	started = nil
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

local function cocoonWarn()
	mod:TargetMessage(L["cocoonbar"], inCocoon, "Important", 745, "Alert")
end

function mod:Cocoon(player)
	inCocoon[#inCocoon + 1] = player
	self:ScheduleEvent("Cocoons", cocoonWarn, 0.3)
end

function mod:Spray()
	self:IfMessage(L["webspraywarn"], "Important", 54125)
	self:DelayedMessage(10, L["webspraywarn30sec"], "Attention")
	self:DelayedMessage(20, L["webspraywarn20sec"], "Attention")
	self:DelayedMessage(30, L["webspraywarn10sec"], "Attention")
	self:DelayedMessage(35, L["webspraywarn5sec"], "Attention")
	self:Bar(L["webspraybar"], 40, 54125)
	if self:GetOption(28622) then
		self:Bar(L["cocoonbar"], 20, 745)
	end
	self:Bar(L["spiderbar"], 30, 17332)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		self:Spray()
	end
end

function mod:Enrage(_, spellId)
	self:IfMessage(L["enragewarn"], "Attention", spellId, "Alarm")
end

function mod:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 30 and health <= 33 and not enrageannounced then
			if self:GetOption(54123) then
				self:Message(L["enragesoonwarn"], "Important")
			end
			enrageannounced = true
		elseif health > 40 and enrageannounced then
			enrageannounced = nil
		end
	end
end

