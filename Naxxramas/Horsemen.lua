----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("The Four Horsemen", "Naxxramas")
if not mod then return end
--[[
	16064 - thane
	30549 - baron
	16065 - blaumeux
	16063 - zeliek
--]]
mod.enabletrigger = { 16064, 30549, 16065, 16063 } 
mod.guid = 16065
mod.toggleOptions = {"mark", -1, 28884, 28863, 28883, "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local deaths = 0
local started = nil
local marks = 1

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: The Four Horsemen", "enUS", true)
if L then
	L.mark = "Mark"
	L.mark_desc = "Warn for marks."
	L.markbar = "Mark %d"
	L.markwarn1 = "Mark %d!"
	L.markwarn2 = "Mark %d in 5 sec"

	L.dies = "#%d Killed"

	L.startwarn = "The Four Horsemen Engaged! Mark in ~17 sec"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: The Four Horsemen")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "VoidZone", 28863, 57463)
	self:AddCombatListener("SPELL_CAST_START", "Meteor", 28884, 57467)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Wrath", 28883, 57466)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Mark", 28832, 28833, 28834, 28835) --Mark of Korth'azz, Mark of Blaumeux, Mark of Rivendare, Mark of Zeliek
	self:AddCombatListener("UNIT_DIED", "Deaths")

	marks = 1
	deaths = 0
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterMessage("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:VoidZone(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 12, spellId)
end

function mod:Meteor(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 12, spellId)
end

function mod:Wrath(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 12, spellId)
end

local last = 0
function mod:Mark()
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if self.db.profile.mark then
			self:IfMessage(L["markwarn1"]:format(marks), "Important", 28835)
			marks = marks + 1
			self:Bar(L["markbar"]:format(marks), 12, 28835)
			self:DelayedMessage(7, L["markwarn2"]:format(marks), "Urgent")
		end
	end
end

function mod:BigWigs_RecvSync(event, sync, rest)
	if self:ValidateEngageSync(sync, rest) and not started then
		marks = 1
		deaths = 0
		started = true
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		if self.db.profile.mark then
			self:Message(L["startwarn"], "Attention")
			self:Bar(L["markbar"]:format(marks), 17, 28835)
			self:DelayedMessage(12, L["markwarn2"]:format(marks), "Urgent")
		end
	end
end

function mod:Deaths(_, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid or guid == 30549 or guid == 16063 or guid == 16064 then
		deaths = deaths + 1
		if deaths < 4 then
			self:IfMessage(L["dies"]:format(deaths), "Positive")
		end
	end
	if deaths == 4 then
		self:BossDeath(nil, self.guid, true)
	end
end

