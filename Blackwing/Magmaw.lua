--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Magmaw", 754)
if not mod then return end
mod:RegisterEnableMob(41570)

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	-- heroic
	L.blazing = "Skeleton Adds"
	L.blazing_desc = "Summons Blazing Bone Construct."
	L.blazing_message = "Add incoming!"
	L.blazing_bar = "Next skeleton"

	L.phase2 = "Phase 2"
	L.phase2_desc = "Warn for Phase 2 transition and display range check."
	L.phase2_message = "Phase 2!"
	L.phase2_yell = "Inconceivable! You may actually defeat my lava worm! Perhaps I can help... tip the scales."

	-- normal
	L.pillar_of_flame_cd = "~Pillar of Flame"

	L.slump = "Slump (Rodeo)"
	L.slump_desc = "Warn for when Magmaw slumps forward and exposes himself, allowing the riding rodeo to start."
	L.slump_bar = "Next rodeo"
	L.slump_message = "Yeehaw, ride on!"
	L.slump_trigger = "%s slumps forward, exposing his pincers!"

	L.infection_message = "You are infected!"

	L.expose_trigger = "head"
	L.expose_message = "Head exposed!"

	L.spew_bar = "~Next Spew"
	L.spew_warning = "Lava Spew Soon!"

	L.mangle_bar = "Mangle: %s"
	L.mangle_cooldown = "~Next Mangle"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"slump", 79011, 89773, 78006, {94679, "FLASHSHAKE", "WHISPER", "PROXIMITY"}, 91931,
		"blazing", {"phase2", "PROXIMITY"},
		"berserk", "bosskill"
	}, {
		slump = "normal",
		blazing = "heroic",
		bosskill = "general"
	}
end

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_SUMMON", "BlazingInferno", 92154, 92190, 92191, 92192)
	self:Yell("Phase2", L["phase2_yell"])

	--normal
	self:Log("SPELL_AURA_APPLIED", "Infection", 94679, 78097, 78941, 91913, 94678)
	self:Log("SPELL_AURA_REMOVED", "InfectionRemoved", 94679, 78097, 78941, 91913, 94678)
	self:Log("SPELL_AURA_APPLIED", "PillarOfFlame", 78006)
	self:Log("SPELL_AURA_APPLIED", "Mangle", 89773, 91912, 94616, 94617)
	self:Log("SPELL_AURA_REMOVED", "MangleRemoved", 89773, 91912, 94616, 94617)
	self:Log("SPELL_CAST_SUCCESS", "LavaSpew", 77690, 91919, 91931, 91932)
	-- --self:Log("SPELL_CAST_START", "Armageddon", 92177)
	--self:Log("SPELL_CAST_SUCCESS", "Armageddon", 92177)
	self:Emote("Slump", L["slump_trigger"])
	self:Emote("Vulnerability", L["expose_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 41570)
end

function mod:OnEngage(diff)
	if diff > 2 then
		self:Bar("blazing", L["blazing_bar"], 30, "SPELL_SHADOW_RAISEDEAD")
	end
	self:Berserk(600)
	self:Bar("slump", L["slump_bar"], 100, 36702)
	self:Bar(78006, GetSpellInfo(78006), 30, 78006) --Pillar of Flame
	self:Bar(91931, L["spew_bar"], 24, 91931)
	self:Bar(89773, L["mangle_cooldown"], 90, 89773)
	self:DelayedMessage(91931, 24, L["spew_warning"], "Attention")
	phase = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--
--[[
function mod:Armageddon()
	mod:Message(79011, "+! ARMAGEDDON !+", "Important", 92177, "Alarm")
end]]

do
	local function rebootTimers()
		mod:Bar(78006, L["pillar_of_flame_cd"], 9.5, 78006)
		mod:Bar(91931, L["spew_bar"], 4.5, 91931)
	end
	function mod:Vulnerability()
		self:Message(79011, L["expose_message"], "Positive", 79011)
		self:Bar(79011, L["expose_message"], 30, 79011)
		self:SendMessage("BigWigs_StopBar", self, L["pillar_of_flame_cd"])
		self:SendMessage("BigWigs_StopBar", self, L["spew_bar"])
		self:CancelDelayedMessage(L["spew_warning"])
		self:ScheduleTimer(rebootTimers, 30)
	end
end

do
	local prev = 0
	function mod:LavaSpew(_, spellId, _, _, spellName)
		local time = GetTime()
		if time - prev > 10 then
			prev = time
			self:Message(91931, spellName, "Important", spellId)
			self:Bar(91931, L["spew_bar"], 26, spellId)
			self:DelayedMessage(91931, 24, L["spew_warning"], "Attention")
		end
	end
end

function mod:BlazingInferno(_, spellId)
	self:Message("blazing", L["blazing_message"], "Urgent", "Interface\\Icons\\SPELL_SHADOW_RAISEDEAD", "Info")
	self:Bar("blazing", L["blazing_bar"], 35, "SPELL_SHADOW_RAISEDEAD")
end

function mod:Phase2()
	phase = 2
	self:Message("phase2", L["phase2_message"], "Attention", 92195)
	self:SendMessage("BigWigs_StopBar", self, L["blazing_bar"])
	self:OpenProximity(8, "phase2")
end

function mod:PillarOfFlame(_, spellId, _, _, spellName)
	self:Message(78006, spellName, "Urgent", spellId, "Alert")
	self:Bar(78006, L["pillar_of_flame_cd"], 32, spellId)
end

function mod:Infection(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(94679, L["infection_message"], "Personal", spellId, "Alarm")
		self:FlashShake(94679)
		self:OpenProximity(8, 94679)
	else
		self:Whisper(94679, player, L["infection_message"], true)
	end
end

function mod:InfectionRemoved(player)
	if phase == 1 and UnitIsUnit(player, "player") then
		self:CloseProximity(94679)
	end
end

function mod:Slump()
	self:SendMessage("BigWigs_StopBar", self,  L["pillar_of_flame_cd"])
	self:Bar("slump", L["slump_bar"], 95, 36702)
	self:Message("slump", L["slump_message"], "Positive", 36702, "Info")
end

do
	local mangleTarget = nil
	function mod:Mangle(player, spellId, _, _, spellName)
		mangleTarget = player
		self:TargetMessage(89773, spellName, player, "Personal", spellId, "Info")
		self:Bar(89773, L["mangle_bar"]:format(player), 30, spellId)
		self:Bar(89773, L["mangle_cooldown"], 95, spellId)
	end

	function mod:MangleRemoved(player, spellId, _, _, spellName)
		self:SendMessage("BigWigs_StopBar", self,  L["mangle_bar"]:format(mangleTarget))
	end
end

