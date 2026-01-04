if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lightblinded Vanguard", 2912, 2737)
if not mod then return end
mod:RegisterEnableMob(240431, 240437, 240438) -- Bellamy, Lightblood, Senn
mod:SetEncounterID(3180)

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

		-- Commander Venel Lightblood
		1248449, -- Aura of Wrath
		1248983, -- Execution Sentence
		1246765, -- Divine Storm
		1246749, -- Sacred Toll
		1246736, -- Judgement (Final Verdict)

		-- General Amias Bellamy
		1246162, -- Aura of Devotion
		1248644, -- Divine Toll
		1246485, -- Avenger's Shield
		1251857, -- Judgement (Shield of the Righteous)

		-- War Chaplain Senn
		1248451, -- Aura of Peace
		1255738, -- Searing Radiance
		1248674, -- Sacred Shield
	},{
		[1248449] = -33680, -- Lightblood
		[1246162] = -32195, -- Bellamy
		[1248451] = -33681, -- Senn
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

