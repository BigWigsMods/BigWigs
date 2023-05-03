--------------------------------------------------------------------------------
-- TODO:
-- -- Repeating say, ending with - on clear (stage 2 only)
-- -- Timer to boss active

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Amalgamation Chamber", 2569, 2529)
if not mod then return end
mod:RegisterEnableMob(201774, 201773, 201934) -- Essence of Shadow, Eternal Blaze, Shadowflame Amalgamation
mod:SetEncounterID(2687)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

-- Essence of Shadow
local coalescingVoidCount = 1
local umbralDetonationCount = 1
local shadowsConvergenceCount = 1

-- Eternal Blaze
local fieryMeteorCount = 1
local moltenEruptionCount = 1
local swirlingFlameCount = 1

-- Shadowflame Amalgamation
local gloomConflagrationCount = 1
local blisteringTwilightCount = 1
local convergentEruptionCount = 1
local shadowflameBurstCount = 1

-- Mythic
local shadowAndFlameCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss that is out of range in stage 1."

	L.coalescing_void = "Run Away"
	L.shadow_convergence = "Orbs"
	L.molten_eruption = "Soaks"
	L.swirling_flame = "Tornadoes"
	L.gloom_conflagration = "Meteor + Run Away"
	L.blistering_twilight = "Bombs + Tornadoes"
	L.convergent_eruption = "Soaks + Orbs"
	L.shadowflame_burst = "Frontal Cone"

	L.shadow_and_flame = "Mythic Debuffs"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"custom_on_fade_out_bars",
		-- Essence of Shadow
		401809, -- Corrupting Shadow
		403459, -- Coalescing Void
		{405036, "SAY", "SAY_COUNTDOWN"}, -- Umbral Detonation
		405084, -- Lingering Umbra
		407640, -- Shadows Convergence
		-- {403699, "TANK"} -- Shadow Spike
		-- Eternal Blaze
		402617, -- Blazing Heat
		404732, -- Fiery Meteor
		403101, -- Molten Eruption
		404896, -- Swirling Flame
		-- {403203, "TANK"}, -- Flame Slash
		-- Shadowflame Amalgamation
		405394, -- Shadowflame
		405437, -- Gloom Conflagration
		{405642, "SAY", "SAY_COUNTDOWN"}, -- Blistering Twilight
		405645, -- Engulfing Heat
		408193, -- Convergent Eruption
		{405914, "TANK"}, -- Withering Vulnerability
		{406783, "TANK"}, -- Shadowflame Burst
		{409385, "PROXIMITY"}, -- Shadow and Flame
	},{
		["stages"] = "general",
		[401809] = -26336, -- Essence of Shadow
		[402617] = -26337, -- Eternal Blaze
		[405394] = -26338, -- Shadowflame Amalgamation
		[409385] = "mythic", -- Mythic
	},{
		[403459] = L.coalescing_void, -- Coalescing Void (Run Away)
		[405036] = CL.bombs, -- Umbral Detonation (Bombs)
		[407640] = L.shadow_convergence, -- Shadows Convergence (Orbs)
		[404732] = CL.meteor, -- Fiery Meteor (Meteor)
		[403101] = L.molten_eruption, -- Molten Eruption (Soaks)
		[404896] = L.swirling_flame, -- Swirling Flame (Tornadoes Fire)
		[405437] = L.gloom_conflagration, -- Gloom Conflagration (Meteor + Run Away)
		[405642] = L.blistering_twilight, -- Blistering Twilight (Bombs + Tornadoes Fire)
		[408193] = L.convergent_eruption, -- Convergent Eruption (Soaks + Orbs)
		[406783] = L.shadowflame_burst, -- Shadowflame Burst (Frontal Cone)
		[409385] = L.shadow_and_flame, -- Shadow and Flame
	}
end

function mod:OnBossEnable()
	-- Fading Bars
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
	self:RegisterMessage("BigWigs_BarEmphasized", "BarEmphasized")

	-- Essence of Shadow
	self:Log("SPELL_AURA_APPLIED", "CorruptingShadowApplied", 401809)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CorruptingShadowApplied", 401809)
	self:Log("SPELL_AURA_REMOVED", "CorruptingShadowRemoved", 401809)
	self:Log("SPELL_CAST_START", "CoalescingVoid", 403459)
	self:Log("SPELL_CAST_START", "UmbralDetonation", 405016)
	self:Log("SPELL_AURA_APPLIED", "UmbralDetonationApplied", 405036)
	self:Log("SPELL_AURA_REMOVED", "UmbralDetonationRemoved", 405036)
	self:Log("SPELL_CAST_START", "ShadowsConvergence", 407640)
	-- self:Log("SPELL_CAST_START", "ShadowSpike", 403699)

	-- Eternal Blaze
	self:Log("SPELL_AURA_APPLIED", "BlazingHeatApplied", 402617)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingHeatApplied", 402617)
	self:Log("SPELL_AURA_REMOVED", "BlazingHeatRemoved", 402617)
	self:Log("SPELL_CAST_START", "FieryMeteor", 404732)
	self:Log("SPELL_CAST_START", "MoltenEruption", 403101)
	self:Log("SPELL_CAST_START", "SwirlingFlame", 404896)
	-- self:Log("SPELL_CAST_START", "FlameSlash", 403203)

	-- Shadowflame Amalgamation
	self:Log("SPELL_CAST_SUCCESS", "Stage2Trigger", 406730)
	self:Log("SPELL_AURA_APPLIED", "ShadowflameApplied", 405394)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowflameApplied", 405394)
	self:Log("SPELL_AURA_REMOVED", "ShadowflameRemoved", 405394)
	self:Log("SPELL_CAST_START", "GloomConflagration", 405437)
	self:Log("SPELL_CAST_START", "BlisteringTwilight", 405641)
	self:Log("SPELL_AURA_APPLIED", "BlisteringTwilightApplied", 405642)
	self:Log("SPELL_AURA_REMOVED", "BlisteringTwilightRemoved", 405642)
	self:Log("SPELL_CAST_START", "ConvergentEruption", 408193)
	self:Log("SPELL_CAST_SUCCESS", "WitheringVulnerability", 405914)
	self:Log("SPELL_AURA_APPLIED", "WitheringVulnerabilityApplied", 405914)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WitheringVulnerabilityApplied", 405914)
	self:Log("SPELL_CAST_START", "ShadowflameBurst", 406783)

	-- Ground Effects
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 405084, 405645) -- Lingering Umbra, Engulfing Heat
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 405084, 405645)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 405084, 405645)

	-- Mythic
	self:Log("SPELL_CAST_START", "ShadowAndFlame", 409385)
	self:Log("SPELL_CAST_SUCCESS", "ShadowAndFlameSuccess", 409385)
end

function mod:OnEngage()
	mod:SetStage(1)
	-- Shadowflame Amalgamation
	local gloomConflagrationCount = 1
	local blisteringTwilightCount = 1
	local convergentEruptionCount = 1
	local shadowflameBurstCount = 1

	-- Mythic
	local shadowAndFlameCount = 1

	-- Essence of Shadow
	coalescingVoidCount = 1
	umbralDetonationCount = 1
	shadowsConvergenceCount = 1
	self:Bar(403459, 30, CL.count:format(L.coalescing_void, coalescingVoidCount)) -- Coalescing Void
	self:Bar(405036, 19.5, CL.count:format(CL.bombs, umbralDetonationCount)) -- Umbral Detonation
	self:Bar(407640, 23, CL.count:format(L.shadow_convergence, shadowsConvergenceCount)) -- Shadows Convergence

	-- Eternal Blaze
	fieryMeteorCount = 1
	moltenEruptionCount = 1
	swirlingFlameCount = 1
	self:Bar(404732, 32.5, CL.count:format(CL.meteor, fieryMeteorCount)) -- Fiery Meteor
	self:Bar(403101, 23.0, CL.count:format(L.molten_eruption, moltenEruptionCount)) -- Molten Eruption
	self:Bar(404896, 9.5, CL.count:format(L.swirling_flame, swirlingFlameCount)) -- Swirling Flame
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Fading Bar Tech
function mod:IsEssenceOfShadowInRange()
	local unit = self:GetUnitIdByGUID(201774)
	if unit then
		return IsItemInRange(116139, unit) -- 50yd
	end
end

function mod:IsEternalBlazeInRange()
	local unit = self:GetUnitIdByGUID(201773)
	if unit then
		return IsItemInRange(116139, unit) -- 50yd
	end
end

do
	local normalAnchor, emphasizeAnchor, colors = BigWigsAnchor, BigWigsEmphasizeAnchor, nil

	local essenceOfShadowAbilities = {
		[403459] = true, -- Coalescing Void
		[405036] = true, -- Umbral Detonation
		[407640] = true, -- Shadows Convergence
	}

	local eternalBlazeAbilities = {
		[404732] = true, -- Fiery Meteor
		[403101] = true, -- Molten Eruption
		[404896] = true, -- Swirling Flame
	}

	local function colorBar(self, bar)
		colors = colors or BigWigs:GetPlugin("Colors")
		local key = bar:Get("bigwigs:option")
		bar:SetTextColor(colors:GetColor("barText", self, key))
		bar:SetShadowColor(colors:GetColor("barTextShadow", self, key))

		if bar:Get("bigwigs:emphasized") then
			bar:SetColor(colors:GetColor("barEmphasized", self, key))
		else
			bar:SetColor(colors:GetColor("barColor", self, key))
		end
	end

	local function fadeOutBar(self, bar)
		colors = colors or BigWigs:GetPlugin("Colors")
		local key = bar:Get("bigwigs:option")
		local r, g, b, a = colors:GetColor("barText", self, key)
		if a > 0.33 then
			bar:SetTextColor(r, g, b, 0.33)
		end
		r, g, b, a = colors:GetColor("barTextShadow", self, key)
		if a > 0.33 then
			bar:SetShadowColor(r, g, b, 0.33)
		end

		if bar:Get("bigwigs:emphasized") then
			r, g, b, a = colors:GetColor("barEmphasized", self, key)
			if a > 0.5 then
				bar:SetColor(r, g, b, 0.5)
			end
		else
			r, g, b, a = colors:GetColor("barColor", self, key)
			if a > 0.5 then
				bar:SetColor(r, g, b, 0.5)
			end
		end
	end

	local function handleBarColor(self, bar)
		if essenceOfShadowAbilities[bar:Get("bigwigs:option")] then
			if self:IsEssenceOfShadowInRange() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		elseif eternalBlazeAbilities[bar:Get("bigwigs:option")] then
			if self:IsEternalBlazeInRange() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		end
	end

	function mod:CheckBossRange()
		if not self:GetOption("custom_on_fade_out_bars") then return end
		if not normalAnchor then return end
		for k in next, normalAnchor.bars do
			if k:Get("bigwigs:module") == self and k:Get("bigwigs:option") then
				handleBarColor(self, k)
			end
		end
		for k in next, emphasizeAnchor.bars do
			if k:Get("bigwigs:module") == self and k:Get("bigwigs:option") then
				handleBarColor(self, k)
			end
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if not self:GetOption("custom_on_fade_out_bars") or self:GetStage() ~= 1 then return end
		if essenceOfShadowAbilities[key] then
			if not self:IsEssenceOfShadowInRange() then
				fadeOutBar(self, bar)
			end
		elseif eternalBlazeAbilities[key] then
			if not self:IsEternalBlazeInRange() then
				fadeOutBar(self, bar)
			end
		end
	end

	function mod:BarEmphasized(_, _, bar)
		if not self:GetOption("custom_on_fade_out_bars") then return end
		if bar:Get("bigwigs:module") == self and bar:Get("bigwigs:option") then
			handleBarColor(self, bar)
		end
	end
end

-- Essence of Shadow
function mod:CorruptingShadowApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 20 then -- start with 20+, update after PTR
			self:StackMessage(args.spellId, "blue", args.destName, amount, 20)
			self:PlaySound(args.spellId, "warning")
		end
		if self:GetOption("custom_on_fade_out_bars") and self:GetStage() == 1 then
			self:CheckBossRange()
		end
	end
end

function mod:CorruptingShadowRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:CoalescingVoid(args)
	self:StopBar(CL.count:format(L.coalescing_void, coalescingVoidCount))
	if self:IsEssenceOfShadowInRange() then
		self:Message(args.spellId, "yellow", CL.count:format(L.coalescing_void, coalescingVoidCount))
		self:PlaySound(args.spellId, "alert")
	end
	coalescingVoidCount = coalescingVoidCount + 1
	self:Bar(args.spellId, self:Mythic() and 35.2 or 22, CL.count:format(L.coalescing_void, coalescingVoidCount))
end

do
	local count = 1
	function mod:UmbralDetonation(args)
		self:StopBar(CL.count:format(CL.bombs, umbralDetonationCount))
		if self:IsEssenceOfShadowInRange() then
			self:Message(405036, "yellow", CL.count:format(CL.bombs, umbralDetonationCount))
			self:PlaySound(405036, "alert")
		end
		umbralDetonationCount = umbralDetonationCount + 1
		self:Bar(405036, self:Mythic() and (umbralDetonationCount == 2 and 42.5 or 35) or 22, CL.count:format(CL.bombs, umbralDetonationCount))
		count = 1
	end


	function mod:UmbralDetonationApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, CL.bomb)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 6)
		end
		count = count + 1
	end

	function mod:UmbralDetonationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:ShadowsConvergence(args)
	self:StopBar(CL.count:format(L.shadow_convergence, shadowsConvergenceCount))
	if self:IsEssenceOfShadowInRange() then
		self:Message(args.spellId, "yellow", CL.count:format(L.shadow_convergence, shadowsConvergenceCount))
		self:PlaySound(args.spellId, "alert")
	end
	shadowsConvergenceCount = shadowsConvergenceCount + 1
	self:Bar(args.spellId, self:Mythic() and (shadowsConvergenceCount == 2 and 41.5 or 35.3) or 21, CL.count:format(L.shadow_convergence, shadowsConvergenceCount))
end

-- function mod:ShadowSpike(args)
-- 	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
-- 	if bossUnit and self:Tanking(bossUnit) then
-- 		self:Message(args.spellId, "purple")
-- 		self:PlaySound(args.spellId, "alarm")
-- 	end
-- end

-- Eternal Blaze
function mod:BlazingHeatApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 20 then -- start with 20+, update after PTR
			self:StackMessage(args.spellId, "blue", args.destName, amount, 20)
			self:PlaySound(args.spellId, "warning")
		end
		if self:GetOption("custom_on_fade_out_bars") then
			self:CheckBossRange()
		end
	end
end

function mod:BlazingHeatRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FieryMeteor(args)
	self:StopBar(CL.count:format(CL.meteor, fieryMeteorCount))
	if self:IsEternalBlazeInRange() then
		self:Message(args.spellId, "yellow", CL.count:format(CL.meteor, fieryMeteorCount))
		self:PlaySound(args.spellId, "alert")
	end
	fieryMeteorCount = fieryMeteorCount + 1
	self:Bar(args.spellId, self:Mythic() and 35.3 or 31.5, CL.count:format(CL.meteor, fieryMeteorCount))
end

function mod:MoltenEruption(args)
	self:StopBar(CL.count:format(L.molten_eruption, moltenEruptionCount))
	if self:IsEternalBlazeInRange() then
		self:Message(args.spellId, "yellow", CL.count:format(L.molten_eruption, moltenEruptionCount))
		self:PlaySound(args.spellId, "alert")
	end
	moltenEruptionCount = moltenEruptionCount + 1
	self:CDBar(args.spellId, self:Mythic() and (moltenEruptionCount == 2 and 41.5 or 35) or 23.1, CL.count:format(L.molten_eruption, moltenEruptionCount))
end

function mod:SwirlingFlame(args)
	self:StopBar(CL.count:format(L.swirling_flame, swirlingFlameCount))
	if self:IsEternalBlazeInRange() then
		self:Message(args.spellId, "yellow", CL.count:format(L.swirling_flame, swirlingFlameCount))
		self:PlaySound(args.spellId, "alert")
	end
	swirlingFlameCount = swirlingFlameCount + 1
	local cd = 21
	if self:Mythic() then
		cd = swirlingFlameCount == 3 and 27 or (swirlingFlameCount % 2 == 0 and 14.6 or 20.7)
	end
	self:CDBar(args.spellId, cd, CL.count:format(L.swirling_flame, swirlingFlameCount))
end

-- function mod:FlameSlash(args)
-- 	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
-- 	if bossUnit and self:Tanking(bossUnit) then
-- 		self:Message(args.spellId, "purple")
-- 		self:PlaySound(args.spellId, "alarm")
-- 	end
-- end

-- Shadowflame Amalgamation

do
	local prev = 0
	function mod:Stage2Trigger(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(L.coalescing_void, coalescingVoidCount)) -- Coalescing Void
			self:StopBar(CL.count:format(CL.bombs, umbralDetonationCount)) -- Umbral Detonation
			self:StopBar(CL.count:format(L.shadow_convergence, shadowsConvergenceCount)) -- Shadows Convergence
			self:StopBar(CL.count:format(CL.meteor, fieryMeteorCount)) -- Fiery Meteor
			self:StopBar(CL.count:format(L.molten_eruption, moltenEruptionCount)) -- Molten Eruption
			self:StopBar(CL.count:format(L.swirling_flame, swirlingFlameCount)) -- Swirling Flame

			mod:SetStage(2)
			self:Message("stages", "cyan", CL.stage:format(2), false)
			self:PlaySound("stages", "long")
			gloomConflagrationCount = 1
			blisteringTwilightCount = 1
			convergentEruptionCount = 1
			shadowflameBurstCount = 1
			shadowAndFlameCount = 1

			self:Bar(405914, 17.5)
			self:Bar(406783, self:Mythic() and 19.5 or 18.5, CL.count:format(L.shadowflame_burst, shadowflameBurstCount)) -- Shadowflame Burst
			self:Bar(405642, self:Mythic() and 22 or 21.5, CL.count:format(L.blistering_twilight, blisteringTwilightCount)) -- Blistering Twilight
			self:Bar(405437, self:Mythic() and 50 or 32.5, CL.count:format(L.gloom_conflagration, gloomConflagrationCount)) -- Gloom Conflagration
			self:Bar(408193, self:Mythic() and 35.5 or 47.0, CL.count:format(L.convergent_eruption, convergentEruptionCount)) -- Convergent Eruption
			if self:Mythic() then
				self:Bar(409385, 29.5, CL.count:format(L.shadow_and_flame, shadowAndFlameCount)) -- Shadow and Flame
			end
		end
	end
end

function mod:ShadowflameApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 20 then -- start with 20+, update after PTR
			self:StackMessage(args.spellId, "blue", args.destName, amount, 20)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:ShadowflameRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:GloomConflagration(args)
	self:StopBar(CL.count:format(L.gloom_conflagration, gloomConflagrationCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.gloom_conflagration, gloomConflagrationCount))
	self:PlaySound(args.spellId, "alert")
	gloomConflagrationCount = gloomConflagrationCount + 1
	self:Bar(args.spellId, self:Mythic() and 47.5 or 40, CL.count:format(L.gloom_conflagration, gloomConflagrationCount))
end

do
	local count = 1
	function mod:BlisteringTwilight(args)
		self:StopBar(CL.count:format(L.blistering_twilight, blisteringTwilightCount))
		self:Message(405642, "yellow", CL.count:format(L.blistering_twilight, blisteringTwilightCount))
		self:PlaySound(405642, "alert")
		blisteringTwilightCount = blisteringTwilightCount + 1
		self:Bar(405642, self:Mythic() and 47.5 or 40, CL.count:format(L.blistering_twilight, blisteringTwilightCount))
	end

	function mod:BlisteringTwilightApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, CL.bomb)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 6)
		end
	end

	function mod:BlisteringTwilightRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:ConvergentEruption(args)
	self:StopBar(CL.count:format(L.convergent_eruption, convergentEruptionCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.convergent_eruption, convergentEruptionCount))
	self:PlaySound(args.spellId, "alert")
	convergentEruptionCount = convergentEruptionCount + 1
	self:Bar(args.spellId, self:Mythic() and 47.5 or 40, CL.count:format(L.convergent_eruption, convergentEruptionCount))
end

function mod:WitheringVulnerability(args)
	self:Bar(args.spellId, self:Mythic() and 24 or 35.5)
end

function mod:WitheringVulnerabilityApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Tank() and not self:Me(args.destGUID) and not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "warning")
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ShadowflameBurst(args)
	self:StopBar(CL.count:format(L.shadowflame_burst, shadowflameBurstCount))
	self:Message(args.spellId, "purple", CL.count:format(L.shadowflame_burst, shadowflameBurstCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameBurstCount = shadowflameBurstCount + 1
	self:Bar(args.spellId, self:Mythic() and 24.3 or (shadowflameBurstCount > 5 and 40 or 35.3), CL.count:format(L.shadowflame_burst, shadowflameBurstCount))
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:ShadowAndFlame(args)
	self:StopBar(CL.count:format(L.shadow_and_flame, shadowAndFlameCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.shadow_and_flame, shadowAndFlameCount))
	self:PlaySound(args.spellId, "alert")
	shadowAndFlameCount = shadowAndFlameCount + 1
	self:Bar(args.spellId, 47.5, CL.count:format(L.shadow_and_flame, shadowAndFlameCount))
	self:OpenProximity(args.spellId, 6)
end

function mod:ShadowAndFlameSuccess(args)
	self:CloseProximity(args.spellId)
end
