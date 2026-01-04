if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fallen-King Salhadaar", 2912, 2736)
if not mod then return end
mod:RegisterEnableMob(240432) -- Fallen-King Salhadaar
mod:SetEncounterID(3179)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then
-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions() -- SetOption:skip-unused
	return {
		"stages",

		1247738, -- Desperate Measures
		1250686, -- Twisting Obscurity
		1254081, -- Fractured Projection
		1260823, -- Despotic Command
		1253911, -- Shattering Twilight
		1246175, -- Cosmic Unraveling
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

