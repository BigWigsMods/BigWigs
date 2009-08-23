----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Koralon the Flame Watcher"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Vault of Archavon"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 33993
mod.toggleOptions = {"fists", "cinder", "berserk", "bosskill"}
mod.consoleCmd = "Koralon"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local UnitGUID = _G.UnitGUID
local GetNumRaidMembers = _G.GetNumRaidMembers
local fmt = _G.string.format
local guid = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	fists = "Meteor Fists",
	fists_desc = "Warn when Koralon casts Meteor Fists.",
	fists_message = "Meteor Fists Active!",

	cinder = "Cinder",
	cinder_desc = "Warn when Koralon casts Flaming Cinder.",
	cinder_message = "Flaming Cinder!",
} end )

L:RegisterTranslations("deDE", function() return {
	fists = "Meteorfäuste",
	fists_desc = "Warnt wenn Koralon Meteorfäuste wirkt.",
	fists_message = "Meteorfäuste Aktiv!",

	cinder = "Zunder",
	cinder_desc = "Warnt wenn Koralon Flammender Zunder wirkt.",
	cinder_message = "Flammender Zunder!",
} end )

L:RegisterTranslations("frFR", function() return {
	fists = "Poings météoriques",
	fists_desc = "Prévient quand Koralon incante des Poings météoriques.",
	fists_message = "Poings météoriques actifs !",

	cinder = "Braise enflammée",
	cinder_desc = "Prévient quand Koralan incante une Braise enflammée.",
	cinder_message = "Braise enflammée !",
} end )

L:RegisterTranslations("koKR", function() return {
	fists = "유성 주먹",
	fists_desc = "코랄론의 유성 주먹 시전을 알립니다.",
	fists_message = "유성 주먹!",

	cinder = "잿더미",
	cinder_desc = "코랄론의 불타는 잿더미 시전을 알립니다.",
	cinder_message = "불타는 잿더미!",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	fists = "Meteor Fists",
	fists_desc = "当Koralon施放Meteor Fists时发出警报。",
	fists_message = "Meteor Fists！",

	cinder = "Cinder",
	cinder_desc = "当Koralon施放Flaming Cinder时发出警报。",
	cinder_message = "Flaming Cinder！",
]]
} end )

L:RegisterTranslations("zhTW", function() return {
--[[
	fists = "隕石之拳",
	fists_desc = "當寇拉隆施放隕石之拳時發出警報。",
	fists_message = "隕石之拳！",

	cinder = "燃焰餘燼",
	cinder_desc = "當寇拉隆施放燃焰餘燼時發出警報。",
	cinder_message = "燃焰餘燼！",
]]
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fists", 66725, 66808)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Cinder", 67332, 66684)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	guid = nil
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fists(_, spellID)
	if db.fists then
		self:IfMessage(L["fists_message"], "Attention", spellID)
		self:Bar(L["fists"], 15, spellID)
	end
end

function mod:Cinder(_, spellID)
	if db.cinder then
		self:IfMessage(L["cinder_message"], "Attention", spellID)
		self:Bar(L["cinder_bar"], 20, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.berserk then
			self:Enrage(360, true)
		end
	end
end

