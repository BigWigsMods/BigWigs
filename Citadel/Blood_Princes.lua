--------------------------------------------------------------------------------
-- Module Declaration
--
local mod = BigWigs:NewBoss("Blood Princes", "Icecrown Citadel")
if not mod then return end
--Prince Valanar, Prince Keleseth, Prince Taldaram
mod:RegisterEnableMob(37970, 37972, 37973)
mod.toggleOptions = {{72040, "FLASHSHAKE", "ICON"}, {70981, "ICON"}, 72039, "bosskill"}

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.switch_message = "Blood Switch"
	L.switch_bar = "~Next Blood Switch"

	L.infernoflames = "Inferno Flames"
	L.infernoflames_message = "Inferno Flames following YOU"

	L.shock_message = "Casting Shock!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Switch", 70981, 70982, 70952)
	self:Log("SPELL_CAST_START", "Shock", 72039, 73037) --73037 for 25man?
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:Death("Deaths", 37970, 37972, 37973)
end

do
	local c = 0
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		c = c + 1
		if c == 3 then
			c = 0
			if UnitName("boss1") then
				self:Engage()
				self:Bar(70981, L["switch_bar"], 45, spellId)
				--Enrage ?
			else
				self:Reboot()
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Switch(unit, spellId, _, _, spellName)
	self:Message(70981, L["switch_message"], "Attention", spellId)
	self:Bar(70981, L["switch_bar"], 45, spellId)
	for i = 1, 4 do
		local bossNum = ("boss%d"):format(i)
		local name = UnitName(bossNum)
		if name and name == unit and bit.band(self.db.profile[spellName], BigWigs.C.ICON) == BigWigs.C.ICON then
			SetRaidTarget(bossNum, 8)
			return
		end
	end
end

function mod:Shock(_, spellId)
	self:Message(72039, L["shock_message"], "Positive", spellId, "Alert")
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, player)
	if msg:find(L["infernoflames"]) then
		self:SecondaryIcon(72040, player)
		if UnitIsUnit(player, "player") then
			self:FlashShake(72040)
			self:LocalMessage(72040, L["infernoflames_message"], "Personal", 72040, "Alarm")
		else
			self:TargetMessage(72040, L["infernoflames"], player, "Urgent", 72040)
		end
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

