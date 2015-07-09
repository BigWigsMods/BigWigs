
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hellfire Citadel Trash", 1026)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	94857, -- Orb of Destruction
	94284, -- Fiery Enkindler
	95630, -- Construct Peacekeeper
	95614 -- Binder Eloah
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.orb = "Orb of Destruction"
	L.enkindler = "Fiery Enkindler"
	L.peacekeeper = "Construct Peacekeeper"
	L.eloah = "Binder Eloah"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		188072, -- Fel Destruction
		{187110, "PROXIMITY", "SAY"}, -- Focused Fire
		{189595, "FLASH"}, -- Protocol: Crowd Control
		{189533, "TANK"}, -- Sever Soul
	}, {
		[188072] = L.orb,
		[187110] = L.enkindler,
		[189595] = L.peacekeeper,
		[189533] = L.eloah,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_DAMAGE", "FelDestructionDamage", 188072)
	self:Log("SPELL_MISSED", "FelDestructionDamage", 188072)

	self:Log("SPELL_AURA_APPLIED", "FocusedFire", 187110)
	self:Log("SPELL_AURA_REMOVED", "FocusedFireRemoved", 187110)

	self:Log("SPELL_CAST_START", "ProtocolCrowdControl", 189595)

	self:Log("SPELL_AURA_APPLIED", "SeverSoul", 189533)
	self:Log("SPELL_AURA_REMOVED", "SeverSoulRemoved", 189533)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Orb of Destruction ]]--

do
	local prev = 0
	function mod:FelDestructionDamage(args)
		if self:Me(args.destGUID) and GetTime()-prev > 2.5 then
			prev = GetTime()
			self:RangeMessage(args.spellId, "Personal", "Alarm", L.orb)
		end
	end
end

--[[ Fiery Enkindler ]]--

function mod:FocusedFire(args)
	if self:Me(args.destGUID) then
		self:TargetBar(args.spellId, 12, args.destName)
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 5, nil, true)
	end
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm")
end

function mod:FocusedFireRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
		self:StopBar(args.spellName, args.destName)
	end
end

--[[ Construct Peacekeeper ]]--

function mod:ProtocolCrowdControl(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Flash(args.spellId)
end

--[[ Binder Eloah ]]--

function mod:SeverSoul(args)
	self:TargetBar(args.spellId, 6, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
end

function mod:SeverSoulRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

