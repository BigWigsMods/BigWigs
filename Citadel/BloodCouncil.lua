--------------------------------------------------------------------------------
-- Module Declaration
--
local mod = BigWigs:NewBoss("Blood Prince Council", "Icecrown Citadel")
if not mod then return end
--Prince Valanar, Prince Keleseth, Prince Taldaram
mod:RegisterEnableMob(37970, 37972, 37973)
mod.toggleOptions = {{72040, "FLASHSHAKE"}, 72039, {72037, "SAY", "FLASHSHAKE", "WHISPER"}, 70981, "skullprince", "berserk", "proximity", "bosskill"}
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
mod.optionHeaders = {
	[72040] = "Taldaram",
	[72039] = "Valanar",
	[70981] = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local count = 0

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.switch_message = "Health swap: %s"
	L.switch_bar = "~Next health swap"

	L.empowered_flames = "Empowered Flames"

	L.empowered_shock_message = "Casting Shock!"
	L.regular_shock_message = "Shock zone"
	L.shock_say = "Shock zone on me!"

	L.skullprince = "Skull on active prince"
	L.skullprince_desc = "Place a skull on the active blood prince with health."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Switch", 70981, 70982, 70952)
	self:Log("SPELL_CAST_START", "EmpoweredShock", 72039, 73037)
	self:Log("SPELL_CAST_START", "RegularShock", 72037)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Reboot")

	self:Death("Deaths", 37970, 37972, 37973)
	count = 0
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	--Need some sensible event args please Blizz
	count = count + 1
	if count == 3 then --3 bosses engaged
		count = 0
		local guid = UnitGUID("boss1")
		if guid then
			guid = tonumber(guid:sub(-12, -7), 16)
			if guid == 37970 or guid == 37972 or guid == 37973 then
				self:Engage()
				self:Bar(70981, L["switch_bar"], 45, 70981)
				self:Berserk(600)
			else
				self:Disable()
			end
		else
			self:Reboot()
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Switch(unit, spellId, _, _, spellName)
	self:Message(70981, L["switch_message"]:format(unit), "Positive", spellId, "Info")
	self:Bar(70981, L["switch_bar"], 45, spellId)
	for i = 1, 3 do
		local bossNum = ("boss%d"):format(i)
		local name = UnitName(bossNum)
		if name and name == unit and self.db.profile.skullprince then
			SetRaidTarget(bossNum, 8) --Skull
			break
		end
	end
end

function mod:EmpoweredShock(_, spellId)
	self:Message(72039, L["empowered_shock_message"], "Important", spellId, "Alert")
	self:OpenProximity(15)
	self:ScheduleTimer(self.CloseProximity, 5, self)
end

do
	local function scanTarget()
		for i = 1, 3 do
			local bossNum = ("boss%d"):format(i)
			local guid = UnitGUID(bossNum)
			if not guid then return end
			guid = tonumber((guid):sub(-12, -7), 16)
			if guid == 37970 then
				local target = UnitName(bossNum.."target")
				if target then
					if UnitIsUnit("player", target) then
						mod:FlashShake(72037)
						if bit.band(mod.db.profile[GetSpellInfo(72037)], BigWigs.C.SAY) == BigWigs.C.SAY then
							SendChatMessage(L["shock_say"], "SAY")
						end
					end
					mod:TargetMessage(72037, L["regular_shock_message"], target, "Urgent", 72037)
					mod:Whisper(72037, target, L["regular_shock_message"])
				end
				break
			end
		end
	end
	function mod:RegularShock()
		self:ScheduleTimer(scanTarget, 0.2)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, player)
	if msg:find(L["empowered_flames"]) then
		if UnitIsUnit(player, "player") then
			self:FlashShake(72040)
		end
		self:TargetMessage(72040, L["empowered_flames"], player, "Urgent", 72040, "Long")
	end
end

do
	local deaths = 0
	function mod:Deaths()
		deaths = deaths + 1
		if deaths == 3 then 
			self:Win()
		end
	end
end

