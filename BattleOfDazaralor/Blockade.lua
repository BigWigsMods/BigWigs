--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Stormwall Blockade", 2070, 2337)
if not mod then return end
mod:RegisterEnableMob(146251, 146253, 146256) -- Sister Katherine, Brother Joseph, Laminaria
mod.engageId = 2280
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local ireCount = 1
local stormsWailCount = 1
local cracklingLightningCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.killed = "%s killed!"

	L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss who isn't active on your boat in stage 1."
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage 1
		"custom_on_fade_out_bars",
		-- Sister Katherine
		287995, -- Electric Shroud
		284262, -- Voltaic Flash
		284106, -- Crackling Lightning
		-- Brother Joseph
		286558, -- Tidal Shroud
		284362, -- Sea Storm
		284383, -- Sea's Temptation XXX Rename bar to "Add"?
		284405, -- Tempting Song
		-- Stage 2
		288696, -- Catastrophic Tides
		{285000, "TANK", "SAY_COUNTDOWN"}, -- Kelp-Wrapped
		285118, -- Sea Swell
		285017, -- Ire of the Deep
		{285350, "SAY_COUNTDOWN"}, -- Storm's Wail
	}, {
		["stages"] = CL.general,
		["custom_on_fade_out_bars"] = -19257, -- Stage One: Storm the Ships
		[287995] = -19261, -- Sister Katherine
		[286558] = -19262, -- Brother Joseph
		[288696] = -19258, -- Stage Two: Laminaria
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
	self:RegisterMessage("BigWigs_BarEmphasized", "BarEmphasized")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")

	-- Stage 1
	self:Log("SPELL_CAST_START", "Translocate", 284393)
	self:Log("SPELL_CAST_START", "TranslocatePlayer", 284934)

	-- Sister Katherine
	self:Log("SPELL_CAST_START", "ElectricShroud", 287995)
	self:Log("SPELL_CAST_START", "VoltaicFlash", 284262)
	self:Log("SPELL_CAST_START", "CracklingLightning", 284106)
	self:Death("SisterDeath", 146251) -- Sister Katherine

	-- Brother Joseph
	self:Log("SPELL_CAST_START", "TidalShroud", 286558)
	self:Log("SPELL_CAST_START", "SeaStorm", 284362)
	self:Log("SPELL_CAST_START", "SeasTemptation", 284383)
	self:Log("SPELL_AURA_APPLIED", "TemptingSongApplied", 284405)
	self:Death("BrotherDeath", 146253) -- Brother Joseph

	-- Stage 2
	self:Log("SPELL_CAST_START", "CatastrophicTides", 288696)
	self:Log("SPELL_INTERRUPT", "Interupted", "*")
	self:Log("SPELL_AURA_APPLIED", "KelpWrappedApplied", 285000)
	self:Log("SPELL_AURA_REFRESH", "KelpWrappedApplied", 285000)
	self:Log("SPELL_AURA_APPLIED_DOSE", "KelpWrappedApplied", 285000)
	self:Log("SPELL_AURA_REMOVED", "KelpWrappedRemoved", 285000)
	self:Log("SPELL_CAST_START", "SeaSwell", 285118)
	self:Log("SPELL_CAST_START", "IreoftheDeep", 285017)

	self:Log("SPELL_AURA_APPLIED", "StormsWailApplied", 285350)
	self:Log("SPELL_AURA_REMOVED", "StormsWailRemoved", 285350)
end

function mod:OnEngage()
	ireCount = 1
	stormsWailCount = 1
	cracklingLightningCount = 1

	self:CDBar(284362, 7) -- Sea Storm
	self:CDBar(284106, 10.5) -- Crackling Lightning
	self:CDBar(284383, 18) -- Sea's Temptation
	self:CDBar(284262, 24) -- Voltaic Flash
	self:CDBar(287995, 30) -- Electric Shroud
	self:CDBar(286558, 32) -- Tidal Shroud
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:IsSisterOnPlatform()
	local unit = self:GetUnitIdByGUID(146251)
	if unit then
		return IsItemInRange(116139, unit) -- 50yd
	end
end

function mod:IsBrotherOnPlatform()
	local unit = self:GetUnitIdByGUID(146253)
	if unit then
		return IsItemInRange(116139, unit) -- 50yd
	end
end

do
	local normalAnchor, emphasizeAnchor, colors = BigWigsAnchor, BigWigsEmphasizeAnchor, nil

	local brotherAbilities = {
		[284362] = true, -- Sea Storm
		[284383] = true, -- Sea's Temptation
		[286558] = true, -- Tidal Shroud
	}

	local sisterAbilities = {
		[284262] = true, -- Voltaic Flash
		[284106] = true, -- Crackling Lightning
		[287995] = true, -- Electric Shroud
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
		local r, g, b = colors:GetColor("barText", self, key)
		bar:SetTextColor(r, g, b, 0.33)
		r, g, b = colors:GetColor("barTextShadow", self, key)
		bar:SetShadowColor(r, g, b, 0.33)

		if bar:Get("bigwigs:emphasized") then
			r, g, b = colors:GetColor("barEmphasized", self, key)
			bar:SetColor(r, g, b, 0.5)
		else
			r, g, b = colors:GetColor("barColor", self, key)
			bar:SetColor(r, g, b, 0.5)
		end
	end

	local function handleBarColor(self, bar)
		if sisterAbilities[bar:Get("bigwigs:option")] then
			if self:IsSisterOnPlatform() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		elseif brotherAbilities[bar:Get("bigwigs:option")] then
			if self:IsBrotherOnPlatform() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		end
	end

	function mod:CheckBossPlatforms()
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
		if not self:GetOption("custom_on_fade_out_bars") then return end
		if sisterAbilities[key] then
			if not self:IsSisterOnPlatform() then
				fadeOutBar(self, bar)
			end
		elseif brotherAbilities[key] then
			if not self:IsBrotherOnPlatform() then
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


function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 284993 then -- Move Laminaria to Position // Might want to use Anchor Here 45313
		self:Message2("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
	end
end

-- Stage 1
function mod:Translocate(args)
	if self:MobId(args.sourceGUID) == 146251 then -- Sister
		cracklingLightningCount = 1
		self:CDBar(284106, 14.5) -- Crackling Lightning
		self:CDBar(284262, 19.5) -- Voltaic Flash
		self:CDBar(287995, 36.5) -- Electric Shroud
	else -- Brother
		self:CDBar(284362, 12) -- Sea Storm
		self:CDBar(284383, 20.5) -- Sea's Temptation
		self:CDBar(286558, 37.5) -- Tidal Shroud
	end
	if self:GetOption("custom_on_fade_out_bars") then
		self:CheckBossPlatforms()
		self:ScheduleTimer("CheckBossPlatforms", 5) -- XXX figure out what's reasonable for a recheck
	end
end

function mod:TranslocatePlayer(args)
	if self:GetOption("custom_on_fade_out_bars") and self:Me(args.sourceGUID) then
		self:CheckBossPlatforms()
		self:ScheduleTimer("CheckBossPlatforms", 5) -- XXX figure out what's reasonable for a recheck
	end
end

-- Sister Katherine
function mod:ElectricShroud(args)
	if self:IsSisterOnPlatform() then
		self:Message2(args.spellId, "red")
		self:PlaySound(args.spellId, "info")
	end
	self:CDBar(args.spellId, 35.5)
end

function mod:VoltaicFlash(args)
	if self:IsSisterOnPlatform() then
		self:Message2(args.spellId, "orange")
		self:PlaySound(args.spellId, "alarm")
	end
	self:CDBar(args.spellId, 17)
end

function mod:CracklingLightning(args)
	if self:IsSisterOnPlatform() then
		self:Message2(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
	cracklingLightningCount = cracklingLightningCount + 1
	self:CDBar(args.spellId, cracklingLightningCount % 2 == 0 and 12.1 or 22)
end

function mod:SisterDeath(args)
	self:Message2("stages", "red", L.killed:format(args.destName), false)
	self:PlaySound("stages", "long")
	self:StopBar(287995) -- Electric Shroud
	self:StopBar(284262) -- Voltaic Flash
	self:StopBar(284106) -- Crackling Lightning
end

-- Brother Joseph
function mod:TidalShroud(args)
	if self:IsBrotherOnPlatform() then
		self:Message2(args.spellId, "red")
		self:PlaySound(args.spellId, "info")
	end
	self:CDBar(args.spellId, 35.5)
end

function mod:SeaStorm(args)
	if self:IsBrotherOnPlatform() then
		self:Message2(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
	self:CDBar(args.spellId, 11)
end

function mod:SeasTemptation(args)
	if self:IsBrotherOnPlatform() then
		self:Message2(args.spellId, "cyan")
		self:PlaySound(args.spellId, "alarm")
	end
	self:CDBar(args.spellId, 7)
end

function mod:TemptingSongApplied(args)
	if self:IsBrotherOnPlatform() then
		self:TargetMessage2(args.spellId, "red", args.destName)
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end

function mod:BrotherDeath(args)
	self:Message2("stages", "cyan", L.killed:format(args.destName), false)
	self:PlaySound("stages", "long")
	self:StopBar(286558) -- Tidal Shroud
	self:StopBar(284362) -- Sea Storm
	self:StopBar(284383) -- Sea's Temptation
end

-- Stage 2
function mod:CatastrophicTides(args)
	self:Message2(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 15)
end

function mod:Interupted(args)
	if args.extraSpellId == 288696 then -- Catastrophic Tides
		self:Message2(288696, "green", CL.interrupted:format(args.extraSpellName))
		self:PlaySound(288696, "info")
		self:StopBar(CL.cast:format(args.extraSpellName))

		stormsWailCount = 1
		ireCount = 1

		self:CDBar(285017, 6, CL.count:format(self:SpellName(285017), ireCount)) -- Ire of the Deep
		self:CDBar(285118, 8.5) -- Sea Swell
		self:CDBar(285350, 15.5, CL.count:format(self:SpellName(285350), stormsWailCount)) -- Storm's Wail
	end
end

function mod:KelpWrappedApplied(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:SayCountdown(args.spellId, 15, nil, 5)
		self:PlaySound(args.spellId, "alarm")
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	elseif self:Tank() and self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		if amount == 5 then
			self:PlaySound(args.spellId, "warning", nil, args.destName)
		end
	end
end

function mod:KelpWrappedRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:SeaSwell(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 20.6)
end

function mod:IreoftheDeep(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, ireCount))
	self:PlaySound(args.spellId, "warning")
	ireCount = ireCount + 1
	self:CDBar(args.spellId, 32.5, CL.count:format(args.spellName, ireCount))
end

function mod:StormsWailApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, stormsWailCount))
	self:TargetBar(args.spellId, 10, args.destName, CL.count:format(args.spellName, stormsWailCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:SayCountdown(args.spellId, 10)
	end
	stormsWailCount = stormsWailCount + 1
	self:CDBar(args.spellId, 120, CL.count:format(args.spellName, stormsWailCount))
end

function mod:StormsWailRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
