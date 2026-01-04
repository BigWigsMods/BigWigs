if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chimaerus the Undreamt God", 2939, 2795)
if not mod then return end
mod:RegisterEnableMob(245569) -- Chimaerus
mod:SetEncounterID(3306)

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

		1246621, -- Caustic Phelgm
		1272726, -- Rending Tear
		1262289, -- Alndust Upheaval
		1251021, -- Rift Emergence
		1257085, -- Consuming Miasma
		1245396, -- Consume

		-- 1272966, -- Stage Two
		1245452, -- Corrupted Devastation
		1245404, -- Ravenous Dive
	}, {
		[1246621] = -32998, -- Stage One: Insatiable Hunger
		[1245452] = -33000, -- Stage Two: To the Skies
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

