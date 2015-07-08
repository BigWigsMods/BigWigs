
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hellfire Citadel Trash", 1026)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	95630, -- Construct Peacekeeper
	95614 -- Binder Eloah
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.peacekeeper = "Construct Peacekeeper"
	L.eloah = "Binder Eloah"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{189595, "FLASH"}, -- Protocol: Crowd Control
		{189533, "TANK"}, -- Sever Soul
	}, {
		[189595] = L.peacekeeper
		[189533] = L.eloah
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_CAST_START", "ProtocolCrowdControl", 189595)

	self:Log("SPELL_AURA_APPLIED", "SeverSoul", 189533)
	self:Log("SPELL_AURA_REMOVED", "SeverSoulRemoved", 189533)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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

