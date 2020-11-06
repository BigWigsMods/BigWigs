--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Vaelastrasz the Corrupt", 469)
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

	L.warmup_trigger = "Too late, friends!"
	L.warmup_message = "RP started, engaging in ~43s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"warmup",
		{18173, "ICON"}, -- Burning Adrenaline
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Log("SPELL_AURA_APPLIED", "Adrenaline", self:SpellName(18173))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.warmup_trigger, nil, true) then
		self:Message("warmup", "cyan", L.warmup_message, false)
		self:Bar("warmup", 43, CL.active, "inv_misc_monsterscales_05")
	end
end

function mod:Adrenaline(args)
	self:TargetMessage(18173, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(18173, "alarm")
	end
	self:PrimaryIcon(18173, args.destName)
	self:TargetBar(18173, 20, args.destName, 25698, 18173) -- Explode
end

