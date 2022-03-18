
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Supremus", 564, 1583)
if not mod then return end
mod:RegisterEnableMob(22898)
mod:SetEncounterID(602)
mod:SetAllowWin(true)
--mod:SetRespawnTime(0) -- Resets, doesn't respawn

--------------------------------------------------------------------------------
-- Locals
--

local fixateTimer = nil
local fixateTarget = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.normal_phase_trigger = "Supremus punches the ground in anger!"
	L.kite_phase_trigger = "The ground begins to crack open!"
	L.normal_phase = "Normal Phase"
	L.kite_phase = "Kite Phase"
	L.next_phase = "Next Phase"

	L.fixate = mod:SpellName(40607)
	L.fixate_icon = 40607
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"fixate", "SAY", "ICON"}, -- Fixate
		40126, -- Molten Punch
		40265, -- Molten Flame
		"stages",
		"berserk",
	}
end

function mod:OnBossEnable()
	-- This wasn't exposed until after BC?
	-- self:Log("SPELL_AURA_APPLIED", "Fixate", 41951)
	-- self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 41951)
	self:Log("SPELL_CAST_SUCCESS", "MoltenPunch", 40126)

	self:Log("SPELL_DAMAGE", "MoltenFlameDamage", 40265)
	self:Log("SPELL_MISSED", "MoltenFlameDamage", 40265) -- Not firing?

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end

function mod:OnEngage()
	fixateTimer, fixateTarget = nil, nil
	self:Berserk(900)
	self:CDBar(40126, 12) -- Molten Punch
	self:Bar("stages", 60, L.next_phase, "spell_shadow_summoninfernal")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FixateScan()
	local unit = self:GetUnitIdByGUID(22898)
	if not unit then return end

	local targetUnit = unit .. "target"
	local target = self:UnitName(targetUnit)
	if not target then
		if fixateTarget then
			self:PrimaryIcon("fixate")
			fixateTarget = nil
		end
		return
	end

	if target == fixateTarget then return end
	fixateTarget = target

	if self:Me(self:UnitGUID(targetUnit)) then
		self:Say("fixate", L.fixate)
	end
	self:TargetMessageOld("fixate", target, "red", "warning", L.fixate, L.fixate_icon)
	self:PrimaryIcon("fixate", target)
end

-- function mod:Fixate(args)
-- 	if self:Me(args.destGUID) then
-- 		self:Say(args.spellId)
-- 	end
-- 	self:TargetMessageOld(args.spellId, args.destName, "red", "warning")
-- 	self:PrimaryIcon(args.spellId, args.destName)
-- end

-- function mod:FixateRemoved(args)
-- 	self:PrimaryIcon(args.spellId)
-- end

function mod:MoltenPunch(args)
	self:MessageOld(args.spellId, "yellow")
	self:CDBar(args.spellId, 16) -- 16-20
end

do
	local prev = 0
	function mod:MoltenFlameDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:MessageOld(args.spellId, "blue", "alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg == L.normal_phase_trigger then
		if fixateTimer then
			self:CancelTimer(fixateTimer)
			self:PrimaryIcon("fixate")
		end
		self:MessageOld("stages", "cyan", "info", L.normal_phase, false)
		self:Bar("stages", 60, L.next_phase, "spell_shadow_summoninfernal")
	elseif msg == L.kite_phase_trigger then
		self:MessageOld("stages", "cyan", "info", L.kite_phase, false)
		self:Bar("stages", 60, L.next_phase, "spell_shadow_summoninfernal")
		if self:GetOption("fixate") > 0 then
			fixateTimer = self:ScheduleRepeatingTimer("FixateScan", 1)
		end
	end
end
