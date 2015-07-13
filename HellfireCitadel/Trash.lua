
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hellfire Citadel Trash", 1026)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	94806, -- Fel Hellweaver, summons 94857 (Orb of Destruction) non-targetable
	94284, -- Fiery Enkindler
	94995, -- Graggra
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
	L.graggra = "Graggra"
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
		--187099, -- Residual Shadows
		{188476, "TANK"}, -- Bad Breath
		{188448, "PROXIMITY"}, -- Blazing Fel Touch
		{188510, "SAY"}, -- Graggra Smash
		{189595, "FLASH"}, -- Protocol: Crowd Control
		{189533, "TANK"}, -- Sever Soul
	}, {
		[188072] = L.orb,
		[187110] = L.enkindler,
		[188476] = L.graggra,
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

	self:Log("SPELL_CAST_START", "BadBreathCasting", 188476)
	self:Log("SPELL_AURA_APPLIED", "BadBreath", 188476)
	self:Log("SPELL_AURA_REFRESH", "BadBreath", 188476)

	self:Log("SPELL_AURA_APPLIED", "BlazingFelTouch", 188448)
	self:Log("SPELL_AURA_REMOVED", "BlazingFelTouchRemoved", 188448)

	self:Log("SPELL_AURA_APPLIED", "GraggraSmash", 188510)

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

--[[ Graggra ]]--

function mod:BadBreathCasting(args)
	self:Message(args.spellId, "Urgent")
end

function mod:BadBreath(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
end

function mod:BlazingFelTouch(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:OpenProximity(args.spellId, 6, nil, true)
	end
end

function mod:BlazingFelTouchRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.over:format(args.spellName))
		self:CloseProximity(args.spellId)
	end
end

function mod:GraggraSmash(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:TargetBar(args.spellId, 5, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm")
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

