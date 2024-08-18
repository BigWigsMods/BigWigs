--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Amirdrassil, the Dream's Hope Trash", 2549)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.placeholder = "placeholder"
end

--------------------------------------------------------------------------------
-- Initialization
--

local bannerMarker
function mod:GetOptions()
	return {

	},{

	},{
	}
end

function mod:OnRegister()
end

function mod:OnBossEnable()

end

--------------------------------------------------------------------------------
-- Event Handlers
--
