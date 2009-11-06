if not QueryQuestsCompleted then return end
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

	L.coldflame_message = "Coldflame on YOU!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "Impale", 69062)
	self:Log("SPELL_AURA_APPLIED", "Whirlwind", 69076)
	self:Log("SPELL_AURA_REMOVED", "WhirlwindCD", 69076)
	self:Log("SPELL_AURA_APPLIED", "Coldflame", 69146, 70823, 70824, 70825)

	self:Death("Win", 36612)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Bar(69076, spellName, 45, 69076)
end

--------------------------------------------------------------------------------
-- Event handlers
--

do
	local handle = nil
	local warned = nil
	local id, name = nil, nil
	local function impaleWarn()
		if not warned then
			mod:TargetMessage(69057, name, impale, "Urgent", id)
		else
			warned = nil
			wipe(impale)
		end
		handle = nil
	end
	function mod:Impale(_, spellId, player, _, spellName)
		impale[#impale + 1] = player
		if handle then self:CancelTimer(handle) end
		id, name = spellId, spellName
		handle = self:ScheduleTimer(impaleWarn, 0.1) -- has been 0.2 before
		if player == pName then
			warned = true
			self:TargetMessage(69057, spellName, player, "Important", spellId, "Info")
		end
	end
end

function mod:Coldflame(player, spellId)
	if player == pName then
		self:LocalMessage(69146, L["coldflame_message"], "Personal", spellId, "Alarm")
		self:FlashShake(69146)
	end
end

function mod:Whirlwind(_, spellId, _, _, spellName)
	self:Bar(69076, spellName, 30, spellId)
end

function mod:WhirlwindCD(_, spellId)
	self:Bar(69076, L["whirlwind_cd"], 60, spellId)
end
