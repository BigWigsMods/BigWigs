
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Withered J'im", -1015, 1796)
if not mod then return end
mod:RegisterEnableMob(102075, 112350) -- Withered J'im, Clone
mod.otherMenu = 1007
mod.worldBoss = 102075

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_mark_boss = "Mark the Boss"
	L.custom_on_mark_boss_desc = "Mark the main Withered Jim with {rt8}. Requires promoted or leader."
	L.custom_on_mark_boss_icon = 8
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		223715, -- More... MORE MORE MORE!
		223623, -- Nightshifted Bolts
		223614, -- Resonance
		"custom_on_mark_boss",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_REMOVED", "More", 223715) -- spawn on REMOVED (3s after APPLIED)
	self:Log("SPELL_CAST_START", "NightshiftedBolts", 223623)
	self:Log("SPELL_AURA_APPLIED", "Resonance", 223614)
	self:Death("Win", 102075)

	self:ScheduleTimer("CheckForEngage", 1)
end

function mod:OnEngage()
	self:CheckForWipe()
	if self:GetOption("custom_on_mark_boss") then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function checkTarget(unit)
	local guid = UnitGUID(unit)
	local mobId = guid and mod:MobId(guid)
	if mobId == 102075 then
		mod:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		mod:UnregisterEvent("PLAYER_TARGET_CHANGED")
		if not GetRaidTargetIndex(unit) then
			SetRaidTarget(unit, 8)
		end
	end
end
function mod:PLAYER_TARGET_CHANGED() checkTarget("target") end
function mod:UPDATE_MOUSEOVER_UNIT() checkTarget("mouseover") end

function mod:More(args)
	self:Message(args.spellId, "Neutral", "Info", 74511, args.spellId) -- 74511 = Summon Clone
	self:CDBar(args.spellId, 31, 74511, args.spellId) -- 30.6-31.0
end

-- The clones also cast Resonance, Nightshifted Bolts, and Nightstable Energy (on a ~31s cd)
-- Could track by guid, but it seems unnecessary (with a bunch of clones up, cast can happen very frequently)

do
	local prev = 0
	function mod:NightshiftedBolts(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Attention", "Alarm")
			-- 3s channel, but it can be interrupted, not sure if it stops the effect, though
		end
	end
end

do
	local prev = 0
	function mod:Resonance(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Urgent", "Alert")
		end
	end
end
