--[[
TODO:
	look if there is even a point to try and target scan for mortar cannon
]]--

if select(4, GetBuildInfo()) < 50400 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Iron Juggernaut", 953, 864)
if not mod then return end
mod:RegisterEnableMob(71466)

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

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
		{-8179, "FLASH"}, {144459, "HEALER"}, {144467, "TANK"}, -- Assaukt mode
		144485, {-8190, "FLASH", "ICON"}, {144498, "FLASH"}, -- Siege mode
		"stages", -8183, "berserk", "bosskill",
	}, {
		[-8179] = -8177,
		[144485] = -8178,
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Siege mode
	self:Log("SPELL_PERIODIC_DAMAGE", "NapalmOil", 144498)
	self:Log("SPELL_AURA_REMOVED", "CutterLaserRemoved", 146325)
	self:Log("SPELL_AURA_APPLIED", "CutterLaserApplied", 146325)
	self:Log("SPELL_CAST_START", "ShockPulse", 144485)
	-- Assaukt mode
	self:Log("SPELL_AURA_APPLIED", "IgniteArmor", 144467)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IgniteArmor", 144467)
	self:Log("SPELL_AURA_APPLIED", "LaserBurn", 144459)
	self:Log("SPELL_DAMAGE", "BorerDrill", 144218)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Death("Win", 71466)
end

function mod:OnEngage()
	self:Berserk(600) -- XXX Assumed
	-- no need to start bars here we do it at regeneration
	phase = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Siege mode
do
	local prev = 0
	function mod:NapalmOil(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(-8179, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(-8179)
		end
	end
end

function mod:CutterLaserRemoved(args)
	self:PrimaryIcon(-8190)
end

function mod:CutterLaserApplied(args)
	-- way too varied timer 11-21
	self:TargetMessage(-8190, args.destName, "Important", "Warning")
	self:PrimaryIcon(-8190, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(-8190)
	end
end

function mod:ShockPulse(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 4, CL["cast"]:format(args.spellName))
end

-- Assaukt mode
function mod:IgniteArmor(args)
	local amount = args.amount or 0
	self:Message(args.spellId, "Attention", nil, CL["count"]:format(amount))
	self:CDBar(args.spellId, 9)
end

function mod:LaserBurn(args)
	self:Bar(args.spellId, 11) -- is there even a point for this?
	self:Message(args.spellId, "Important")
end

do
	local prev = 0
	function mod:BorerDrill(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(-8179, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(-8179)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
	if spellId == 144296 then -- Borer Drill
		self:Message(-8179, "Attention")
		self:CDBar(-8179, 19) -- Borer Drill
	elseif spellId == 144673 then -- Crawler Mine
		self:Message(-8183, "Urgent")
		if phase == 1 then
			self:Bar(-8183, 30)
		else
			self:CDBar(-8183, 25)
		end
	elseif spellId == 144492 then -- Napalm Oil
		self:Message(-8179, "Attention")
		self:CDBar(-8179, 20)
	elseif spellId == 146359 then -- Regeneration aka Assault mode
		phase = 1
		self:Message("stages", "Neutral", "Long", CL["phase"]:format(phase))
		self:Bar("stages", 120, CL["phase"]:format(2)) -- maybe should use UNIT_POWER to adjust timer since there seems to be a 6 sec variance
		if self:Healer() then
			self:CDBar(144459, 8)
		end
		self:Bar(-8183, 30) -- Crawler Mine
		self:CDBar(-8179, 19) -- Borer Drill
		self:StopBar(-8179) -- Napalm Oil
		self:StopBar(CL["phase"]:format(1)) -- in case it overruns
	elseif spellId == 146360 then -- Depletion aka Siege mode
		phase = 2
		self:Message("stages", "Neutral", "Long", CL["phase"]:format(phase))
		self:Bar("stages", 64, CL["phase"]:format(1)) -- maybe should use UNIT_POWER to adjust timer since there seems to be a 6 sec variance
		self:CDBar(-8183, 18) -- Crawler Mine
		self:CDBar(-8179, 10) -- Napalm Oil
		self:StopBar(144459) -- Laser Burn
		self:StopBar(-8179) -- Borer Drill
		self:StopBar(144467) -- Ignite Armor
		self:StopBar(CL["phase"]:format(2)) -- in case it overruns
	end
end


