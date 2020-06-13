--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Vaelastrasz the Corrupt", 469)
if not mod then return end
mod:RegisterEnableMob(13020)
mod:SetAllowWin(true)
mod.engageId = 611

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Vaelastrasz the Corrupt"

	L.pull_rp = "RP timer"
	L.pull_rp_desc = "Timer for the RP after engaging the boss"
	L.pull_rp_icon = "spell_fire_lavaspawn"
	L.pull_rp_message = "Pull RP started, engaging in ~43s"
	L.pull_rp_bar = "Encounter starting"

	L.pull_rp_trigger = "Too late, friends!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"pull_rp",
		{18173, "ICON"}, -- Burning Adrenaline
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Log("SPELL_AURA_APPLIED", "Adrenaline", self:SpellName(18173))

	self:Death("Win", 13020)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PullRP()
	self:Message("pull_rp", "cyan", nil, L.pull_rp_message)
	self:Bar("pull_rp", 43, L.pull_rp_bar)
end

function mod:Adrenaline(args)
	self:TargetMessage(18173, args.destName, "yellow", "Alarm")
	self:PrimaryIcon(18173, args.destName)
	self:TargetBar(18173, 20, args.destName, 25698, 18173) -- Explode
end

