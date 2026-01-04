if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Midnight Falls", 2913, 2740)
if not mod then return end
mod:RegisterEnableMob(240391) -- L'ura
mod:SetEncounterID(3183)
mod:SetPrivateAuraSounds({
	{ 1249609, 1249565, 1249558, 1249562, 1249566, 1249550, 1273133 }, -- Dark Rune
	1282006, -- Abyssal Pool
	{ 1261719, 1261720 }, -- Extinction Ray
	1279512, -- Shatterglass

	-- 1281184, -- Starburst
	-- 1276638, -- Heaven & Hell
})

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
	}
end

function mod:OnRegister()

end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

