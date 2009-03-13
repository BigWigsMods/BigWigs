----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Mimiron"]
local mod = BigWigs:New(boss, tonumber(("$Revision: 5001 $"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33350		-- Most of the fight you fight vehicles .. does that matter..?
mod.toggleoptions = {"phase", -1, "plasma", "shock", "laser", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local phase = nil
local pName = UnitName("player")
local fmt = string.format
local laser = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Mimiron",
	
	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_warning = "Phase 2!",
	phase2_trigger = "Behold the VX-001 Anti-personnel Assault Cannon! You might want to take cover.",
	
	starttrigger = "We haven't much time, friends! You're going to help me test out my latest and greatest creation. Now, before you change your minds, remember that you kind of owe it to me after the mess you made with the XT-002.",
	
	plasma = "Plasma Blast",
	plasma_desc = "Warns when Plasma Blast is casting.",
	plasma_warning = "Casting Plasma Blast!",
	plasma_soon = "Plasma Blast soon!",
	
	shock = "Shock Blast",
	shock_desc = "Warns when Shock Blast is casting.",
	shock_warning = "Casting Shock Blast!",
	
	laser = "Laser Barrage",
	laser_desc = "Warn when Laser Barrage is active!",
	laser_soon = "Laser Barrage soon!",
	
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
	laser = GetSpellInfo(63274)
	
	self:AddCombatListener("SPELL_CAST_START", "Plasma", 62997) -- H id missing
	self:AddCombatListener("SPELL_CAST_START", "Shock", 63631) -- H id missing
	--self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	
	-- channel_start seems to fire right before any CLEU events, confirm?
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "Laser")
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	
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
		self:Bar(L["plasma"], 30, spellID)
		self:DelayedMessage(27, L["plasma_soon"], "Attention")
	end
end

function mod:Shock(_, spellID)
	if db.shock then
		self:IfMessage(L["shock_warning"], "Important", spellID)
		self:Bar(L["shock"], 5, spellID)
	end
end

function mod:Laser(unit, spell)
	if db.laser and spell == laser then
		self:IfMessage(L["laser"], "Important", 63274)
		self:Bar(L["laser"], 10, spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:match(L["starttrigger"]) then
		phase = 1
		if db.plasma then
			self:Bar(L["plasma"], 20, spellID)
			self:DelayedMessage(17, L["plasma_soon"], "Attention")
		end
	elseif msg:match(L["phase2_trigger"]) then
		phase = 2
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["plasma"])
		if db.phase then
			self:Message(L["phase2_warning"], "Attention")
		end
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
