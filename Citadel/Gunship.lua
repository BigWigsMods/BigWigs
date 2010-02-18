--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Icecrown Gunship Battle", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37184) --Zafod Boombox
mod.toggleOptions = {"adds", "mage", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local killed = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds = "Portals"
	L.adds_desc = "Warn for Portals."
	L.adds_trigger_alliance = "Reavers, Sergeants, attack!"
	L.adds_trigger_horde = "Marines, Sergeants, attack!"
	L.adds_message = "Portals!"
	L.adds_bar = "Next Portals"

	L.mage = "Mage"
	L.mage_desc = "Warn when a mage spawns to freeze the gunship cannons."
	L.mage_message = "Mage Spawned!"
	L.mage_bar = "Next Mage"

	L.warmup_trigger_alliance = "Fire up the engines"
	L.warmup_trigger_horde = "Rise up, sons and daughters"

	L.disable_trigger_alliance = "Onward, brothers and sisters"
	L.disable_trigger_horde = "Onward to the Lich King"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Yell("Warmup", L["warmup_trigger_alliance"], L["warmup_trigger_horde"])
	self:Yell("AddsPortal", L["adds_trigger_alliance"], L["adds_trigger_horde"]) --XXX unreliable, change to repeater
	self:Yell("Defeated", L["disable_trigger_alliance"], L["disable_trigger_horde"])
	self:Log("SPELL_CAST_START", "Frozen", 69705)
	self:Log("SPELL_AURA_REMOVED", "FrozenCD", 69705)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

do
	local count = 0
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		--Need some sensible event args please Blizz
		count = count + 1
		if count == 2 then --2 bosses engaged
			count = 0
			local guid = UnitGUID("boss1")
			if guid then
				guid = tonumber(guid:sub(-12, -7), 16)
				if guid == 37540 or guid == 37215 then
					self:Engage()
				else
					self:Disable()
				end
			end
		end
	end
end

function mod:Warmup()
	self:Bar("adds", COMBAT, 45, "achievement_dungeon_hordeairship")
	--XXX Fix me, move to engage, need more logs for testing
	self:Bar("adds", L["adds_bar"], 60, 53142)
	self:Bar("mage", L["mage_bar"], 82, 69705)
end

function mod:VerifyEnable()
	if not killed then return true end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AddsPortal()
	self:Message("adds", L["adds_message"], "Attention", 53142)
	self:Bar("adds", L["adds_bar"], 60, 53142) --Portal: Dalaran icon
end

function mod:Frozen(_, spellId)
	self:Message("mage", L["mage_message"], "Positive", spellId, "Info")
end

function mod:FrozenCD(_, spellId)
	self:Bar("mage", L["mage_bar"], 35, spellId)
end

function mod:Defeated()
	killed = true
	self:Win()
end

