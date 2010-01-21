--------------------------------------------------------------------------------
-- Module Declaration
--
local mod = BigWigs:NewBoss("Blood Princes", "Icecrown Citadel")
if not mod then return end
--Prince Valanar, Prince Keleseth, Prince Taldaram
mod:RegisterEnableMob(37970, 37972, 37973)
mod.toggleOptions = {{72040, "FLASHSHAKE"}, 71079, "bosskill"}

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.switch_message = "Vulnerability switch"

	L.infernoflames = "Inferno Flames"
	L.infernoflames_message = "Inferno Flames following YOU"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Switch", 71079, 71082, 71075)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:Death("Deaths", 37970, 37972, 37973)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Switch()
	self:Message("Switch", L["switch_message"], "Attention")
	self:Bar("Switch", L["switch_message"], 40)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, player)
	if msg:find(L["infernoflames"]) then
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

