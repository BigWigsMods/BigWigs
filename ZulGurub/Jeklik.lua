
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("High Priestess Jeklik", 309)
if not mod then return end
mod:RegisterEnableMob(14517)
mod:SetAllowWin(true)
mod.engageId = 785

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "High Priestess Jeklik"

	L.swarm = 6605 -- Terrifying Screech
	L.swarm_desc = "Warn for the Bat swarms"
	L.swarm_icon = 24423
	-- L.swarm_trigger = "emits a deafening shriek"
	L.swarm_message = "Incoming bat swarm!"

	L.bomb = 23970 -- Throw Liquid Fire
	L.bomb_desc = "Warn for Bomb Bats"
	L.bomb_icon = 23970
	L.bomb_trigger = "I command you to rain fire down upon these invaders!"
	L.bomb_message = "Incoming bomb bats!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"swarm",
		23954, -- Great Heal
		26044, -- Mind Flay
		"bomb",
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Screech", 22884) -- Haven't actually seen Terrifying Screech or Psychic Scream in logs
	self:Log("SPELL_CAST_START", "GreatHeal", 23954)
	self:Log("SPELL_INTERRUPT", "GreatHealStop", "*")
	self:Log("SPELL_CAST_START", "MindFlay", 26044)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Screech(args)
	self:Message("swarm", "orange", L.swarm_message, L.swarm_icon)
	self:PlaySound("swarm", "alarm")
end

function mod:GreatHeal(args)
	self:Message(23954, "red", CL.casting:format(args.spellName))
	self:CastBar(23954, 4)
	if self:Interrupter() then
		self:PlaySound(23954, "long")
	end
end

function mod:GreatHealStop(args)
	if args.extraSpellName == self:SpellName(23954) then
		self:StopBar(CL.cast:format(args.extraSpellName))
		self:Message(23954, "green", CL.interrupted:format(args.extraSpellName))
	end
end

function mod:MindFlay(args)
	self:Message(23954, "yellow")
	self:PlaySound(23954, "info")
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.bomb_trigger, nil, true) then
		self:Message("bomb", "orange", L.bomb_message, L.bomb_icon)
		self:PlaySound("bomb", "alarm")
	end
end
