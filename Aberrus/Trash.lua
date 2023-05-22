if select(4, GetBuildInfo()) < 100100 then return end -- not 10.1
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aberrus, the Shadowed Crucible Trash", 2569)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(

)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
--if L then

--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {

	}, {

	}
end

function mod:OnBossEnable()

end

--------------------------------------------------------------------------------
-- Event Handlers
--
