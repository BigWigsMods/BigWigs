--------------------------------------------------------------------------------
-- Module Declaration
--
local mod = BigWigs:NewBoss("Blood Prince Council", "Icecrown Citadel")
if not mod then return end
--Prince Valanar, Prince Keleseth, Prince Taldaram
mod:RegisterEnableMob(37970, 37972, 37973)
mod.toggleOptions = {{72040, "FLASHSHAKE"}, {70981, "ICON"}, 72039, {72037, "SAY", "FLASHSHAKE", "WHISPER"}, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local count = 0

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.switch_message = "Target swap!"
	L.switch_bar = "~Next target swap"

	L.infernoflames = "Inferno Flames"
	L.infernoflames_message = "Fireball"

	L.empowered_shock_message = "Casting Shock!"
	L.regular_shock_message = "Shock zone on %s!"
	L.shock_say = "Shock zone on me!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Switch", 70981, 70982, 70952)
	self:Log("SPELL_CAST_START", "EmpoweredShock", 72039)
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
	self:Message(70981, L["switch_message"], "Positive", spellId, "Info")
	self:Bar(70981, L["switch_bar"], 45, spellId)
	for i = 1, 4 do
		local bossNum = ("boss%d"):format(i)
		local name = UnitName(bossNum)
		if name and name == unit and bit.band(self.db.profile[spellName], BigWigs.C.ICON) == BigWigs.C.ICON then
			SetRaidTarget(bossNum, 8) -- XXX 8 isn't guaranteed to be the primaryicon, need to fetch that from somewhere
			break
		end
	end
end

function mod:EmpoweredShock(_, spellId)
	self:Message(72039, L["empowered_shock_message"], "Important", spellId, "Alert")
end

do
	local scheduled = nil
	local function scanTarget()
		scheduled = nil
		local bossId = mod:GetUnitIdByGUID(37970)
		if not bossId then return end
		local target = UnitName(bossId .. "target")
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
		handle = nil
	end

	function mod:RegularShock()
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(scanTarget, 0.1)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, player)
	if msg:find(L["infernoflames"]) then
		if UnitIsUnit(player, "player") then
			self:FlashShake(72040)
		end
		self:TargetMessage(72040, L["infernoflames_message"], player, "Urgent", 72040)
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

