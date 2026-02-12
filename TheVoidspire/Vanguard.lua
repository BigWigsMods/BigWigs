
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lightblinded Vanguard", 2912, 2737)
if not mod then return end
mod:RegisterEnableMob(240431, 240437, 240438) -- Bellamy, Lightblood, Senn
mod:SetEncounterID(3180)
mod:SetPrivateAuraSounds({
	{1276982, sound = "underyou"}, -- Divine Consecration
	{1248985, 1248994}, -- Execution Sentence (Targetted)
	{1249008, 1249024, sound = "none"}, -- Execution Sentence (Soaked Debuff)
	-- {1249122, 1249123} -- Execution Sentance (Unknown)
	{1272324, sound = "underyou"}, -- Divine Tempest
	{1246736, sound = "alarm"}, -- Judgement (Final Verdict)
	{1251857, sound = "alarm"}, -- Judgement (Shield of the Righteous)
	-- {1251840, sound = "alarm"}, -- Judgment of the Righteous, Used?
	{1248652, sound = "alarm"}, -- Divine Toll
	1246487, -- Avenger's Shield (Targetted)
	{1246502, sound = "alarm"}, -- Avenger's Shield (DoT Debuff)
	{1248721, sound = "alarm"}, -- Tyr's Wrath
	-- {1249130, sound = "info"}, -- Elekk Charge (Buff on the NPC's, lol)
	{1258514, sound = "alarm"}, -- Blinding Light
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

