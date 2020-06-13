
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Ragnaros", 409)
if not mod then return end
mod:RegisterEnableMob(11502, 12018)
mod:SetAllowWin(true)
mod.engageId = 672

--------------------------------------------------------------------------------
-- Locals
--

local sonsdead = 0
local timer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.pull_rp = "RP timer"
	L.pull_rp_desc = "Timer for the RP after engaging Majordomo"
	L.pull_rp_icon = "spell_fire_lavaspawn"
	L.pull_rp_message = "Pull RP started, engaging in ~73s"
	L.pull_rp_bar = "Encounter starting"

	L.engage_trigger = "NOW FOR YOU,"
	L.submerge_trigger = "COME FORTH,"

	L.knockback_message = "Knockback!"
	L.knockback_bar = "Knockback"

	L.submerge = "Submerge"
	L.submerge_desc = "Warn for Ragnaros' submerge."
	L.submerge_icon = "spell_fire_volcano"
	L.submerge_message = "Ragnaros down for 90 sec!"
	L.submerge_bar = "Submerge"

	L.emerge = "Emerge"
	L.emerge_desc = "Warn for Ragnaros' emerge."
	L.emerge_icon = "spell_fire_volcano"
	L.emerge_message = "Ragnaros emerged, 3 mins until submerge!"
	L.emerge_bar = "Emerge"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
    "pull_rp",
		"submerge",
		"emerge",
		20566, -- Wrath of Ragnaros
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Log("SPELL_CAST_SUCCESS", "Knockback", self:SpellName(20566))
	self:Log("SPELL_CAST_START", "PullRP", self:SpellName(19774))

	self:Death("Win", 11502)
	self:Death("SonDeaths", 12143)
	self:Death("MajordomoDeath", 12018)
end

function mod:VerifyEnable(unit, mobId)
  if mobId == 11502 then
    return true
  elseif mobId == 12018 then
    return not UnitCanAttack(unit, "player")
  end
end

function mod:OnEngage()
	sonsdead = 0
	timer = nil
	self:Bar(20566, 27, L.knockback_bar) -- guesstimate for the first wrath
  self:Bar("submerge", 180, L.submerge_bar, "spell_fire_volcano")
	self:Message("submerge", "yellow", nil, CL.custom_min:format(L.submerge, 3), "spell_fire_volcano")
	self:DelayedMessage("submerge", 60, "yellow", CL.custom_min:format(L.submerge, 2))
	self:DelayedMessage("submerge", 120, "yellow", CL.custom_min:format(L.submerge, 1))
	self:DelayedMessage("submerge", 150, "yellow", CL.custom_sec:format(L.submerge, 30))
	self:DelayedMessage("submerge", 170, "orange", CL.custom_sec:format(L.submerge, 10), false, "Alarm")
	self:DelayedMessage("submerge", 175, "orange", CL.custom_sec:format(L.submerge, 5), false, "Alarm")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.engage_trigger, nil, true) then
		self:Engage()
	elseif msg:find(L.submerge_trigger, nil, true) then
		self:Submerge()
	end
end

function mod:Knockback(args)
	self:Message(20566, "red", nil, L.knockback_message)
	self:Bar(20566, 28, L.knockback_bar)
end

function mod:PullRP()
	self:Message("pull_rp", "white", nil, L.pull_rp_message)
	self:Bar("pull_rp", 73, L.pull_rp_bar, L.pull_rp_icon)
end

function mod:MajordomoDeath()
  -- it takes exactly 10 seconds for combat to start after Majodromo dies, while
  -- the time between starting the RP/summon and killing Majordomo varies
  local remaining = self:BarTimeLeft("pull_rp")
  if remaining ~= 10 then
    self:StopBar("pull_rp")
    self:Bar("pull_rp", 10, L.pull_rp_bar, L.pull_rp_icon)
  end
end

function mod:Emerge()
	sonsdead = 10 -- Block this firing again if sons are killed after he emerges
	timer = nil
	self:Bar(20566, 27, L.knockback_bar) -- guesstimate for the first wrath after emerging
	self:Bar("submerge", 180, L.submerge_bar, "spell_fire_volcano")
  self:Message("emerge", "yellow", "Long", L.emerge_message, "spell_fire_volcano")
	self:DelayedMessage("submerge", 60, "yellow", CL.custom_min:format(L.submerge, 2))
	self:DelayedMessage("submerge", 120, "yellow", CL.custom_min:format(L.submerge, 1))
	self:DelayedMessage("submerge", 150, "yellow", CL.custom_sec:format(L.submerge, 30))
	self:DelayedMessage("submerge", 170, "orange", CL.custom_sec:format(L.submerge, 10), false, "Alarm")
	self:DelayedMessage("submerge", 175, "orange", CL.custom_sec:format(L.submerge, 5), false, "Alarm")
end

function mod:Submerge()
	sonsdead = 0 -- reset counter
	self:StopBar(L.knockback_bar)
	self:Message("submerge", "yellow", "Long", L.submerge_message, "spell_fire_volcano")
	self:Bar("emerge", 90, L.emerge_bar, "spell_fire_volcano")
	self:DelayedMessage("emerge", 30, "yellow", CL.custom_sec:format(L.emerge, 60))
	self:DelayedMessage("emerge", 60, "yellow", CL.custom_sec:format(L.emerge, 30))
	self:DelayedMessage("emerge", 80, "orange", CL.custom_sec:format(L.emerge, 10), false, "Alarm")
	self:DelayedMessage("emerge", 85, "orange", CL.custom_sec:format(L.emerge, 5), false, "Alarm")
	timer = self:ScheduleTimer("Emerge", 90)
end

function mod:SonDeaths()
	sonsdead = sonsdead + 1
	if sonsdead < 9 then
		self:Message("emerge", "green", nil, CL.add_killed:format(sonsdead, 8), "spell_fire_elemental_totem")
	end
	if sonsdead == 8 then
		self:CancelTimer(timer)
		self:StopBar(L.emerge_bar)
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 60))
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 30))
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 10))
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 5))
		self:Emerge()
	end
end
