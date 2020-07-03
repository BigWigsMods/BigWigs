
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lord Kazzak", -1419)
if not mod then return end
mod:RegisterEnableMob(12397)
mod.otherMenu = -947
mod.worldBoss = 12397

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Lord Kazzak"

	L.engage_trigger = "For the Legion! For Kil'Jaeden!"

	L.supreme_mode = "Supreme Mode"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		21056, -- Mark of Kazzak
		21063, -- Twisted Reflection
		"berserk",
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "MarkOfKazzak", 21056)
	self:Log("SPELL_AURA_APPLIED", "TwistedReflection", 21063)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Death("Win", 12397)
end

function mod:OnEngage()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MarkOfKazzak(args)
	self:TargetMessage2(21056, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(21056, "alert")
	end
end

function mod:TwistedReflection(args)
	self:TargetMessage2(21063, "orange", args.destName)
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.engage_trigger, nil, true) then
		self:Berserk(180, nil, nil, L.supreme_mode, L.supreme_mode)
	end
end
