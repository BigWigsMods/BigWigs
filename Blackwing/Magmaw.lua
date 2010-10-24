if GetBuildInfo() ~= "4.0.3" then return end -- lets not brake live stuff
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Magmaw", "Blackwing Descent")
if not mod then return end
mod.toggleOptions = {"bosskill"}
mod.optionHeaders = {
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
--



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

function mod:OnRegister()
	self:RegisterEnableMob()
end

function mod:OnBossEnable()
	BigWigs:Print("This is a alpha module, timers ARE inaccurate. Please provide us with Transcriptor logs! You can contact us at #bigwigs@freenode.net or with the wowace ticket tracker.")

end


function mod:OnEngage(diff)
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--
