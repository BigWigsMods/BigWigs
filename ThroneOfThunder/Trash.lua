
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Trash", 930)
if not mod then return end
mod:RegisterEnableMob(
	70236, -- Zandalari Storm-Caller
	70445 -- Stormbringer Draz'kil
	--68220 -- Gastropod
)

--------------------------------------------------------------------------------
-- Locals
--

local debuffTargets = mod:NewTargetList()
local scheduled = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.stormcaller = "Zandalari Storm-Caller"
	L.stormbringer = "Stormbringer Draz'kil"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{139322, "FLASH", "PROXIMITY", "SAY"},
		{139900, "FLASH", "PROXIMITY", "SAY"},
	}, {
		[139322] = L.stormcaller,
		[139900] = L.stormbringer,
	}
end

function mod:OnBossEnable()
	scheduled = nil

	self:Log("SPELL_AURA_APPLIED", "Storms", 139322, 139900) -- Storm Energy, Stormcloud
	self:Log("SPELL_AURA_REMOVED", "StormsRemoved", 139322, 139900)

	--self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Fixated", "target")

	self:Death("Disable", 70236, 70445, 68220)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function warnStorms(spellId)
		scheduled = nil
		mod:TargetMessage(spellId, debuffTargets, "Urgent", "Alert")
	end
	function mod:Storms(args)
		debuffTargets[#debuffTargets+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:OpenProximity(args.spellId, 10)
			self:Say(args.spellId)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnStorms, 0.2, args.spellId)
		end
	end
	function mod:StormsRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
	end
end
--[[
do
	local function scan()
		--self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert")
		print(UnitName("targettarget"), UnitName("targettargettarget"))
	end
	function mod:Fixated(_, _, _, _, spellId)
		if spellId == 140306 then
			print(UnitName("targettarget"), UnitName("targettargettarget"))
			self:ScheduleTimer(scan, 0.05)
			self:ScheduleTimer(scan, 0.1)
			self:ScheduleTimer(scan, 0.2)
			self:ScheduleTimer(scan, 0.3)
			self:ScheduleTimer(scan, 0.4)
			self:ScheduleTimer(scan, 0.5)
		end
	end
end
]]
