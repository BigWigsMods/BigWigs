if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Plexus Sentinel", 2810, 2684)
if not mod then return end
-- mod:RegisterEnableMob(225821)
mod:SetEncounterID(3129)
-- mod:SetPrivateAuraSounds({
-- 	1234567, -- PA Spell
-- })
mod:SetRespawnTime(30)
-- mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

-- function mod:OnRegister()
-- 	self:SetSpellRename(1234567, "String") -- Spell (Rename)
-- end

function mod:GetOptions()
	return {
		"berserk",
	}
end

function mod:OnBossEnable()
end

function mod:OnEngage()
	self:Berserk(600) -- Dummy
end

--------------------------------------------------------------------------------
-- Event Handlers
--
