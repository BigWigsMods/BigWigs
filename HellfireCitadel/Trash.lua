
--------------------------------------------------------------------------------
-- Module Declaration
--

local x = true
if x then return end
local mod, CL = BigWigs:NewBoss("Hellfire Citadel Trash", 1026)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	
)

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

	}, {

	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
end

--------------------------------------------------------------------------------
-- Event Handlers
--


