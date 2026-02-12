
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chimaerus the Undreamt God", 2939, 2795)
if not mod then return end
mod:RegisterEnableMob(245569) -- Chimaerus
mod:SetEncounterID(3306)
mod:SetPrivateAuraSounds({
	{1245698, sound = "info"}, -- Alnsight
	-- 1253744, -- Rift Vulnerability (Applied at the same time as Alnsight)
	{1250953, sound = "none"}, -- Rift Sickness
	-- 1262020, -- Colossal Strikes, Used?
	{1265940, sound = "alarm"}, -- Fearsome Cry
	1264756, -- Rift Madness
	1257087, -- Consuming Miasma
	{1258192, sound = "none"}, -- Lingering Miasma
	{1246653, sound = "none"}, -- Caustic Phelgm
	{1272726, sound = "alarm"}, -- Rending Tear
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

