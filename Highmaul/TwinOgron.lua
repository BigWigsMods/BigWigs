
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Twin Ogron", 994, 1148)
if not mod then return end
mod:RegisterEnableMob(78238, 78237) -- Pol, Phemos
--mod.engageId = 1719

--------------------------------------------------------------------------------
-- Locals
--

local bossDeaths = 0

local function GetBossUnit(guid)
	for i=1, 3 do
		local unit = ("boss%d"):format(i)
		if UnitGUID(unit) == guid then
			return unit
		end
	end
end

local function GetBossCastTime(guid)
	local unit = GetBossUnit(guid) or ""
	local spell, _, _, _, _, endTime = UnitCastingInfo(unit)
	if spell then
		return endTime / 1000 - GetTime()
	end
	return 0
end

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
		{143834, "TANK_HEALER"}, {158134, "ICON", "SAY", "FLASH"}, 158093, 158385,
		{158521, "TANK_HEALER"}, 157943, 158057, 158200,
		"bosskill"
	}, {
		[143834] = -9595, -- Pol
		[158521] = -9590, -- Phemos
		["bosskill"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Pol
	self:Log("SPELL_CAST_START", "ShieldBash", 143834)
	self:Log("SPELL_CAST_START", "ShieldCharge", 158134)
	self:Log("SPELL_CAST_START", "InterruptingShout", 158093)
	self:Log("SPELL_CAST_SUCCESS", "Pulverize", 158385) -- then 1.58s casts of 157952, 158415, 158419
	-- Phemos
	self:Log("SPELL_CAST_START", "DoubleSlash", 158521)
	self:Log("SPELL_CAST_START", "Whirlwind", 157943)
	self:Log("SPELL_CAST_START", "EnfeeblingRoar", 158057)
	self:Log("SPELL_CAST_START", "Quake", 158200)
	self:Log("SPELL_CAST_SUCCESS", "QuakeChannel", 158200)
	--"Blaze"

	self:Death("Deaths", 78238, 78237) -- Pol, Phemos
end

function mod:OnEngage()
	bossDeaths = 0
	self:CDBar(143834, 12) -- Shield Bash
	self:CDBar(158521, 16) -- Double Slash
	self:Bar(158134, 24) -- Shield Charge
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths(args)
	bossDeaths = bossDeaths + 1
	if bossDeaths > 1 then
		self:Win()
	end
end

-- Pol

function mod:ShieldBash(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, 23)
end

do
	local function warnShieldCharge(self, name, guid)
		self:PrimaryIcon(158134, name)
		if self:Me(guid) then
			self:Say(158134)
			self:Flash(158134)
		elseif self:Range(name, 10) then
			self:RangeMessage(158134, "Personal", "Alarm")
			self:Flash(158134)
			return
		end
		self:TargetMessage(158134, name, "Urgent", "Alarm")
	end
	function mod:ShieldCharge(args)
		--self:GetBossTarget(warnShieldCharge, 0.1, args.sourceGUID)
		local unit = GetBossUnit(args.sourceGUID)
		local target = unit and unit.."target"
		if target and not self:Tank(target) then
			warnShieldCharge(self, UnitName(target), UnitGUID(target))
		else
			self:Message(158134, "Urgent")
		end
		self:Bar(158093, 23) -- Interrupting Shout
	end
end

function mod:InterruptingShout(args)
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(args.spellName))
	local cast = GetBossCastTime(args.sourceGUID)
	if cast > 1 then
		self:Bar(args.spellId, cast, CL.cast:format(args.spellName))
	end
	self:Bar(158385, 23) -- Pulverize
end

function mod:Pulverize(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.incoming:format(args.spellName))
	self:Bar(158134, 24) -- Shield Charge
end

-- Phemos

function mod:DoubleSlash(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 25)
end

function mod:Whirlwind(args)
	self:Message(args.spellId, "Attention")
	self:Bar(158057, 28) -- Enfeebling Roar
end

function mod:EnfeeblingRoar(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(158200, 27) -- Quake
end

function mod:Quake(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
	--[[
	local cast = GetBossCastTime(args.sourceGUID)
	if cast > 1 then
		self:Bar(args.spellId, cast, CL.incoming:format(args.spellName))
	end
	--]]
	self:Bar(157943, 27) -- Whirlwind
end

function mod:QuakeChannel(args)
	self:Bar(args.spellId, 12, CL.cast:format(args.spellName))
end

