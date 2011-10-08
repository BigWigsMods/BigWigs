--[[if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Alizabal", 752, 339)
if not mod then return end
mod:RegisterEnableMob(55869)

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
	return {"berserk", "bosskill"}
end

function mod:OnBossEnable()
	--self:Log("SPELL_CAST_START", "MeteorSlash", 88942, 95172)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55869)
end

function mod:OnEngage()
	--self:Berserk(300)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(_, unit)
	if unit ~= "boss1" then return end
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	
end
]]
