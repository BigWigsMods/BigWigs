----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Mimiron"]
local mod = BigWigs:New(boss, tonumber(("$Revision: 5001 $"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33350		-- Most of the fight you fight vehicles .. does that matter..?
mod.toggleoptions = {"plasma", "shock", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Mimiron",
	
	plasma = "Plasma Blast",
	plasma_desc = "Warns when Plasma Blast is casting.",
	plasma_warning = "Casting Plasma Blast!",
	
	shock = "Shock Blast",
	shock_desc = "Warns when Shock Blast is casting.",
	shock_warning = "Casting Shock Blast!",
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )


--[[
		Needs cooldowns off the spells.
		
		Plasma Blast seems to be only cast every ~30s in our limited 10man trys
		Shock Blast didn't produce an accurate prediction.
]]
------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Plasma", 62997) -- H id missing
	self:AddCombatListener("SPELL_CAST_START", "Shock", 63631) -- H id missing
	--self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	--self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	
	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Plasma(_, spellID)
	if db.plasma then
		self:IfMessage(L["plasma_warning"], "Important", spellID)
		self:Bar(L["plasma_warning"], 3, spellID)
	end
end

function mod:Shock(_, spellID)
	if db.shock then
		self:IfMessage(L["shock_warning"], "Important", spellID)
		self:Bar(L["shock"], 5, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
	end
end
