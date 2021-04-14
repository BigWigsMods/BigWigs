--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("The Eye of the Jailer", 2450, 2442)
if not mod then return end
--mod:RegisterEnableMob(164406) -- 
mod:SetEncounterID(2433)
--mod:SetRespawnTime(30)
--mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"berserk",
	},{
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	--self:Log("SPELL_CAST_START", "EarsplittingShriek", 330711)
	--self:Log("SPELL_AURA_APPLIED", "EcholocationApplied", 342077)
	--self:Log("SPELL_AURA_REMOVED", "EcholocationRemoved", 342077)
	--self:Log("SPELL_CAST_START", "EchoingScreech", 342863)
	--self:Log("SPELL_CAST_START", "WaveOfBlood", 345397)
	--self:Log("SPELL_CAST_START", "BlindSwipe", 343005)
	--self:Log("SPELL_CAST_START", "ExsanguinatingBite", 328857)
	--self:Log("SPELL_AURA_APPLIED", "ExsanguinatedApplied", 328897)
	--self:Log("SPELL_AURA_APPLIED_DOSE", "ExsanguinatedApplied", 328897)
	--self:Log("SPELL_AURA_REMOVED", "ExsanguinatedRemoved", 328897)
end

function mod:OnEngage()
	--shriekCount = 1
	--echoingScreechCount = 1
	--echolocationCount = 1
	--blindSwipeCount = 1
	--waveOfBloodCount = 1
	--self:SetStage(1)
	--
	--if self:Mythic() then
	--	self:Berserk(400)
	--else
	--	self:Berserk(550)
	--end
end

--------------------------------------------------------------------------------
-- Event Handlers
--


