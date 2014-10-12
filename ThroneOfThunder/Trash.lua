
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Throne of Thunder Trash", 930)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	70236, -- Zandalari Storm-Caller
	70445, -- Stormbringer Draz'kil
	70440, -- Monara
	70430, -- Rocky Horror
	69821 -- Thunder Lord
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
	L.monara = "Monara"
	L.rockyhorror = "Rocky Horror"
	L.thunderlord_guardian = "Thunder Lord / Lightning Guardian"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{139322, "FLASH", "PROXIMITY", "SAY"},
		{139900, "FLASH", "PROXIMITY", "SAY"},
		{139899, "FLASH"},
		140673,
		{140296, "FLASH"},
	}, {
		[139322] = L.stormcaller,
		[139900] = L.stormbringer,
		[139899] = L.monara,
		[140673] = L.rockyhorror,
		[140296] = L.thunderlord_guardian
	}
end

function mod:OnBossEnable()
	scheduled = nil
	wipe(debuffTargets)

	self:Log("SPELL_AURA_APPLIED", "Storms", 139322, 139900) -- Storm Energy, Stormcloud
	self:Log("SPELL_AURA_REMOVED", "StormsRemoved", 139322, 139900)

	self:Log("SPELL_CAST_START", "HorrifyingRoar", 140673)

	self:Log("SPELL_AURA_APPLIED", "ConductiveShield", 140296)

	self:Log("SPELL_CAST_START", "ShadowNova", 139899)
	self:AddSyncListener("MonaraSN")
	self:AddSyncListener("MonaraDies")

	--self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Fixated", "target")

	self:Death("Disable", 70236, 70445, 70430, 69821)
	self:Death("MonaraDies", 70440)
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

function mod:HorrifyingRoar(args)
	self:Bar(args.spellId, 26.6) -- Either 29 or 26.6, which is picked may or may not be random
	self:Message(args.spellId, "Attention", "Long", CL["casting"]:format(args.spellName))
end

function mod:ConductiveShield(args)
	if UnitGUID("target") == args.destGUID then
		self:Flash(args.spellId)
		self:PlaySound(args.spellId, "Info")
	end
	if self:MobId(args.destGUID) == 69821 then -- Thunder Lord cooldown
		self:Bar(args.spellId, 20.5)
	end
	self:Bar(args.spellId, 10, CL["other"]:format(self:SpellName(133249), args.destName)) -- "Shielded"
	self:Message(args.spellId, "Attention", nil, CL["other"]:format(args.spellName, args.destName))
end

do
	-- Sync for corpse runners
	function mod:OnSync(sync)
		if sync == "MonaraDies" then
			self:Disable()
		elseif sync == "MonaraSN" then
			local spellId = 139899
			local name = self:SpellName(spellId)
			self:Message(spellId, "Urgent", "Long", CL["incoming"]:format(name))
			self:Bar(spellId, 3, CL["cast"]:format(name))
			self:Bar(spellId, 14.4)
			self:Flash(spellId)
		end
	end
	function mod:ShadowNova(args)
		self:Sync("MonaraSN")
	end
	function mod:MonaraDies()
		self:Sync("MonaraDies")
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
