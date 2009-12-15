--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Marrowgar", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36612)
mod.toggleOptions = {69076, 69057, {69146, "FLASHSHAKE"}, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local pName = UnitName("player")
local impale = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.impale_cd = "~Next impale"
	L.whirlwind_cd = "~Next whirlwind"
	L.ww_start = "Whirlwind starts"
	L.ww_end = "Whirwind ends"

	L.coldflame_message = "Coldflame on YOU!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "Impale", 69062, 72669, 72670)
	self:Log("SPELL_CAST_START", "ImpaleCD", 69057, 70826)
	self:Log("SPELL_AURA_APPLIED", "Whirlwind", 69076)
	self:Log("SPELL_AURA_REMOVED", "WhirlwindCD", 69076)
	self:Log("SPELL_AURA_APPLIED", "Coldflame", 69146, 70823, 70824, 70825)

	self:Death("Win", 36612)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Bar(69076, L["whirlwind_cd"], 45, 69076)
end

--------------------------------------------------------------------------------
-- Event handlers
--

do
	local scheduled = nil
	local function impaleWarn(spellId, spellName)
		mod:TargetMessage(69057, spellName, impale, "Urgent", spellId)
		scheduled = nil
	end
	function mod:Impale(_, spellId, player, _, spellName)
		impale[#impale + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(impaleWarn, 0.3, spellId, spellName)
		end
	end
end

function mod:ImpaleCD(_, spellId, _, _, spellName)
	self:Bar(69057, L["impale_cd"], 18, spellId)
end

function mod:Coldflame(player, spellId)
	if player == pName then
		self:LocalMessage(69146, L["coldflame_message"], "Personal", spellId, "Alarm")
		self:FlashShake(69146)
	end
end

function mod:Whirlwind(_, spellId, _, _, spellName)
	self:LocalMessage(spellId, L["ww_start"] , "Personal", "Alarm")---XXXX DEBUG ONLY!
	self:Bar(69076, spellName, 22, spellId)
	self:Bar(69076, L["whirlwind_cd"], 90, spellId)
end

function mod:WhirlwindCD(_, spellId)
	self:LocalMessage(spellId, L["ww_end"] , "Personal", "Alarm")---XXXX DEBUG ONLY!
end

