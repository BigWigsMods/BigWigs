if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nalak", 928, 814)
if not mod then return end
mod:RegisterEnableMob(69099)
mod.otherMenu = 6

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		136338, 136339, 136340, "bosskill",
	}
end

function mod:OnBossEnable()
	-- these spell ids are probably totally wrong
	self:Log("SPELL_CAST_START", "ArcNova", 136338)
	self:Log("SPELL_AURA_APPLIED", "LightningTether", 136339)
	self:Log("SPELL_CAST_SUCCESS", "Stormcloud", 136340)
	self:Log("SPELL_DAMAGE", "StormcloudDamage", 136340)
	self:Log("SPELL_MISSED", "StormcloudDamage", 136340)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 69099)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ArcNova(args)
	self:Message(args.spellId, "Urgent", "Alert")
end

do
	local tetherTargets, scheduled = mod:NewTargetList(), nil
	local function warnTether(spellId)
		mod:TargetMessage(spellId, tetherTargets, "Urgent")
		scheduled = nil
	end
	function mod:LightningTether(args)
		-- 3s cast, Tethers the target to Nalak, inflicting Nature damage every 1 sec. and increased Nature damage if the target is far away.
		tetherTargets[#tetherTargets+1] = args.destName
		if UnitIsUnit("player", args.destName) then
			self:Bar(args.spellId, 15, CL["you"]:format(args.spellName))
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnTether, 0.2, args.spellId)
		end
	end
end

function mod:Stormcloud(args)
	self:Message(args.spellId, "Attention")
end

function mod:StormcloudDamage(args)
	if UnitIsUnit("player", args.destName) then
		self:Message(args.spellId, "Personal", "Alarm", CL["under"]:format(args.spellName))
	end
end

