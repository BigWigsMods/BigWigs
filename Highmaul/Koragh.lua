
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Ko'ragh", 994, 1153)
if not mod then return end
mod:RegisterEnableMob(79015)
mod.engageId = 1723

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fire_bar = "Everyone Explodes!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		163472,
		161242, 160734, {161328, "SAY", "FLASH"}, {162184, "HEALER"}, {162185, "PROXIMITY"}, {162186, "ICON", "FLASH", "SAY"}, 172747,
		"bosskill"
	}, {
		[163472] = "mythic",
		[161242] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "CausticEnergy", 161242)
	self:Log("SPELL_CAST_START", "ExpelMagicShadow", 162184)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicFire", 162185)
	self:Log("SPELL_AURA_APPLIED", "ExpelMagicArcane", 162186)
	self:Log("SPELL_CAST_START", "ExpelMagicFrost", 172747)
	self:Log("SPELL_CAST_SUCCESS", "SuppressionField", 161328)
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "DominatingPower", 163472)
end

function mod:OnEngage()
	-- pretty consistant early cast for fire, but everything else is all over the place :\
	--self:CDBar(162185, 7) -- Expel Magic: Fire
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(unit, powerType)
	if powerType == "ALTERNATE" then
		local power = UnitPower(unit, 10)
		if power < 25 then -- XXX probably need to tweak this (~10s)
			self:Message(160734, "Neutral", "Info", CL.soon:format(self:SpellName(160734)))
			self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1")
			-- Knockback at 0 power, Vulnerability 4s later
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 160734 then -- Vulnerability
		self:Message(spellId, "Positive", nil, CL.removed:format(self:SpellName(156803))) -- Nullification Barrier removed!
		self:Bar(spellId, 20)
		self:StopBar(161328) -- Suppression Field
	elseif spellId == 156803 then -- Nullification Barrier
		self:Message(160734, "Positive", nil, spellName)
		--self:CDBar(160734, 12)
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
	end
end

function mod:ExpelMagicShadow(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:ExpelMagicArcane(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:ExpelMagicFire(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 10, L.fire_bar)
	self:OpenProximity(args.spellId, 5)
	self:ScheduleTimer("CloseProximity", 10, args.spellId)
end

function mod:ExpelMagicFrost(args)
	self:Message(args.spellId, "Attention") --, self:Dispeller("magic") and "Info"
end

function mod:SuppressionField(msg, sender, _, _, target)
	-- shooooould incorporate trample into the warning since he charges to the target, hmm
	if self:Me(target) then
		self:Flash(161328)
		self:Say(161328)
	end
	self:TargetMessage(161328, target, "Attention", "Alarm")
	self:CDBar(161328, 15)
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(spellId)
		mod:TargetMessage(spellId, list, "Attention")
		scheduled = nil
	end
	function mod:CausticEnergy(args)
		list[#list+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.2, args.spellId)
		end
	end
end

-- Mythic

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(spellId)
		mod:TargetMessage(spellId, list, "Urgent")
		scheduled = nil
	end
	function mod:DominatingPower(args)
		list[#list+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.2, args.spellId)
		end
	end
end

