if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Cauldron of Carnage", 2769, 2640)
if not mod then return end
mod:RegisterEnableMob(229181, 229177) -- Flarendo, Torque
mod:SetEncounterID(3010)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local bars = {}

local colossalClashCount = 1

local scrapbombCount = 1
local moltenPhlegmCount = 1
local eruptionStombCount = 1
local blastburnRoarcannonCount = 1

local staticChargeCount = 1
local thunderdrumSalvoCount = 1
local voltaicImageCount = 1
local lightningBashCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fade_out_bars = "Fade out bars"
	L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss that is out of range."

	L.bomb_explosion = "Bomb Explosion"
	L.bomb_explosion_desc = "Show a timer for the explosion off the bombs."
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_on_fade_out_bars",
		465833, -- Colossal Clash
			-- 463800, -- Zapbolt
			-- 465446, -- Fiery Wave
		471660, -- Raised Guard
		471557, -- King of Carnage
		-- Flarendo the Furious
		472222, -- Blistering Spite
		473650, -- Scrapbomb
		{"bomb_explosion", "HEALER"}, -- Bomb Explosion
		1214039, -- Molten Pool
			-- 465446, -- Fiery Waves
		1213690, -- Molten Phlegm
		{472233, "SAY"}, -- Blastburn Roarcannon
		1214190, -- Eruption Stomp
		-- Torq the Tempest
		472225, -- Galvanized Spite
		474159, -- Static Charge
			-- 473983, -- Static Discharge
		463900, -- Thunderdrum Salvo
		1213994, -- Voltaic Image
			463925, -- Lingering Electricity
		{466178, "TANK"}, -- Lightning Bash
	},{ -- Sections

	},{ -- Renames
		[465833] = CL.full_energy, -- Colossal Clash (Full Energy)
		[473650] = CL.bomb, -- Scrapbomb (Bomb)
		[472233] = CL.beam, -- Blastburn Roarcannon (Beam)
	}
end

function mod:OnRegister()
	self:SetSpellRename(473650, CL.bomb) -- Scrapbomb (Bomb)
	self:SetSpellRename(472233, CL.beam) -- Blastburn Roarcannon (Beam)
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")

	-- self:Log("SPELL_CAST_SUCCESS", "ColossalClash", 465833) -- XXX USCS
	self:Log("SPELL_AURA_APPLIED", "RaisedGuardApplied", 471660)
	self:Log("SPELL_AURA_REFRESH", "RaisedGuardApplied", 471660)
	self:Log("SPELL_AURA_APPLIED", "KingOfCarnageApplied", 471557)
	self:Log("SPELL_AURA_APPLIED_DOSE", "KingOfCarnageApplied", 471557)

	-- Flarendo the Furious
	self:Log("SPELL_AURA_APPLIED", "BlisteringSpiteApplied", 472222)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlisteringSpiteApplied", 472222)
	self:Log("SPELL_CAST_START", "Scrapbomb", 473650)
	self:Log("SPELL_AURA_APPLIED", "MoltenPhlegmApplied", 1213690)
	self:Log("SPELL_CAST_START", "BlastburnRoarcannonStart", 472233)
	self:Log("SPELL_CAST_START", "EruptionStomp", 1214190)

	-- Torq the Tempest
	self:Log("SPELL_AURA_APPLIED", "GalvanizedSpiteApplied", 472225)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GalvanizedSpiteApplied", 472225)
	self:Log("SPELL_CAST_SUCCESS", "StaticChargeSuccess", 473994)
	self:Log("SPELL_AURA_APPLIED", "StaticChargeApplied", 474159)
	self:Log("SPELL_CAST_SUCCESS", "ThunderdrumSalvoSuccess", 463900)
	-- self:Log("SPELL_CAST_SUCCESS", "VoltaicImage", 1213994) -- XXX USCS
	self:Log("SPELL_AURA_APPLIED", "VoltaicImageFixateApplied", 1214009)
	self:Log("SPELL_CAST_START", "LightningBash", 466178)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 1214039, 463925) -- Molten Pool, Lingering Electricity
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 1214039, 463925)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 1214039, 463925)
end

function mod:OnEngage()
	bars = {}
	colossalClashCount = 1

	scrapbombCount = 1
	moltenPhlegmCount = 1
	eruptionStombCount = 1
	blastburnRoarcannonCount = 1

	staticChargeCount = 1
	thunderdrumSalvoCount = 1
	voltaicImageCount = 1
	lightningBashCount = 1

	-- Flarendo
	local bombCd = 9
	self:Bar(473650, bombCd, CL.count:format(CL.bomb, scrapbombCount)) -- Scrapbomb
	self:Bar("bomb_explosion", bombCd + 10, CL.count:format(L.bomb_explosion, scrapbombCount), 133613) -- Scrapbomb, bomb icon
	self:Bar(472233, 15.0, CL.count:format(CL.beam, blastburnRoarcannonCount)) -- Blastburn Roarcannon
	self:Bar(1214190, 27.0, CL.count:format(self:SpellName(1214190), eruptionStombCount)) -- Eruption Stomp
	self:Bar(1213690, self:Mythic() and 24.6 or 48.5, CL.count:format(self:SpellName(1213690), moltenPhlegmCount)) -- Molten Phlegm

	-- Torq
	self:Bar(474159, 9, CL.count:format(self:SpellName(474159), staticChargeCount)) -- Static Charge
	self:Bar(463900, 10, CL.count:format(self:SpellName(463900), thunderdrumSalvoCount)) -- Thunderdrum Salvo
	self:Bar(466178, 21, CL.count:format(self:SpellName(466178), lightningBashCount)) -- Lightning Bash
	self:Bar(1213994, 29, CL.count:format(self:SpellName(1213994), voltaicImageCount)) -- Voltaic Image

	self:Bar(465833, 70.5, CL.count:format(CL.full_energy, colossalClashCount)) -- Colossal Clash
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Fading Bar Tech
-- Fading Bar Tech
function mod:IsFlarendoInRange()
	local unit = self:GetUnitIdByGUID(229181)
	if unit then
		return self:UnitWithinRange(unit, 45)
	end
end
function mod:IsTorqueInRange()
	local unit = self:GetUnitIdByGUID(229177)
	if unit then
		return self:UnitWithinRange(unit, 45)
	end
end

do
	local colors

	local flarendoAbilities = {
		[473650] = true, -- Scrapbomb
		[472233] = true, -- Blastburn Roarcannon
		[1214190] = true, -- Eruption Stomp
		[1213690] = true,  -- Molten Phlegm
	}

	local torqueAbilities = {
		[474159] = true, -- Static Charge
		[463900] = true,-- Thunderdrum Salvo
		[466178] = true, -- Lightning Bash
		[1213994] = true, -- Voltaic Image
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
		if flarendoAbilities[bar:Get("bigwigs:option")] then
			if self:IsFlarendoInRange() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		elseif torqueAbilities[bar:Get("bigwigs:option")] then
			if self:IsTorqueInRange() then
				colorBar(self, bar)
			else
				fadeOutBar(self, bar)
			end
		end
	end

	function mod:CheckBossRange()
		if not self:GetOption("custom_on_fade_out_bars") then return end
		for k in next, bars do
			if k:Get("bigwigs:module") == self and k:Get("bigwigs:option") then
				handleBarColor(self, k)
			end
		end
	end

	function mod:BarCreated(_, _, bar, _, key)
		if not self:GetOption("custom_on_fade_out_bars") then return end
		bars[bar] = true
		if flarendoAbilities[key] then
			if not self:IsFlarendoInRange() then
				fadeOutBar(self, bar)
			end
		elseif torqueAbilities[key] then
			if not self:IsTorqueInRange() then
				fadeOutBar(self, bar)
			end
		end
	end

	function mod:BarEmphasized(_, _, bar)
		if not self:GetOption("custom_on_fade_out_bars") then return end
		bars[bar] = true
		if bar:Get("bigwigs:module") == self and bar:Get("bigwigs:option") then
			handleBarColor(self, bar)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 465833 then -- clash inc
		self:Message(spellId, "yellow", CL.count:format(CL.full_energy, colossalClashCount))
		self:PlaySound(spellId, "long") -- 20s clash
		colossalClashCount = colossalClashCount + 1
		self:Bar(spellId, 95, CL.count:format(CL.full_energy, colossalClashCount))
	elseif spellId == 1213994 then -- Voltaic Image
		self:Message(spellId, "yellow", CL.count:format(self:SpellName(spellId), voltaicImageCount))
		self:PlaySound(spellId, "alert")
		voltaicImageCount = voltaicImageCount + 1
		local cd = voltaicImageCount % 2 == 1 and 65.0 or 30.0
		if self:Mythic() then
			cd = 95
		end
		self:Bar(spellId, cd, CL.count:format(self:SpellName(spellId), voltaicImageCount))
	end
end

-- function mod:ColossalClash(args) -- XXX USCS for now
-- 	self:Message(args.spellId, "yellow", CL.count:format(CL.full_energy, colossalClashCount))
-- 	self:PlaySound(args.spellId, "long") -- 20s clash
-- 	colossalClashCount = colossalClashCount + 1
-- 	self:Bar(args.spellId, 95, CL.count:format(CL.full_energy, colossalClashCount))
-- end

do
	local prev = 0
	function mod:RaisedGuardApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:KingOfCarnageApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "cyan", args.destName, amount, 1)
	self:PlaySound(args.spellId, "info")
end

-- Flarendo the Furious
function mod:BlisteringSpiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		local tooHigh = 25
		if amount % 4 == 1 or amount >= tooHigh then
			self:StackMessage(args.spellId, "blue", args.destName, amount, tooHigh)
			if amount >= tooHigh then
				self:PlaySound(args.spellId, "alarm") -- too many stacks
			end
		end
		if self:GetOption("custom_on_fade_out_bars") then
			self:CheckBossRange()
		end
	end
end

function mod:Scrapbomb(args)
	self:StopBar(CL.count:format(CL.bomb, scrapbombCount))
	self:Bar("bomb_explosion", 10, CL.count:format(L.bomb_explosion, scrapbombCount), 133613) -- Scrapbomb, bomb icon
	self:Message(args.spellId, "orange", CL.count:format(CL.bomb, scrapbombCount))
	self:PlaySound(args.spellId, "alert") -- soak bombs
	scrapbombCount = scrapbombCount + 1
	local cd = scrapbombCount % 3 == 1 and 47.0 or 24.0
	if self:Mythic() then
		cd = scrapbombCount % 3 == 1 and 48 or scrapbombCount % 3 == 2 and 24 or 23
	end
	self:Bar(args.spellId, cd, CL.count:format(CL.bomb, scrapbombCount))
	self:Bar("bomb_explosion", cd + 10, CL.count:format(L.bomb_explosion, scrapbombCount), 133613) -- Scrapbomb, bomb icon
end

do
	local prev = 0
	function mod:MoltenPhlegmApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			moltenPhlegmCount = moltenPhlegmCount + 1
			local cd = 95
			if self:Mythic() then
				cd = moltenPhlegmCount % 2 == 1 and 67.6 or 27.4
			end
			self:Bar(args.spellId, 95, CL.count:format(args.spellName, moltenPhlegmCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end


do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:PersonalMessage(472233, nil, CL.beam)
			self:PlaySound(472233, "warning")
			self:Say(472233, CL.beam, nil, "Beam")
		end
	end

	function mod:BlastburnRoarcannonStart(args)
			self:Message(args.spellId, "yellow", CL.count:format(CL.beam, blastburnRoarcannonCount))
			blastburnRoarcannonCount = blastburnRoarcannonCount + 1
			local cd = blastburnRoarcannonCount % 3 == 1 and 47.0 or 24.0
			if self:Mythic() then
				cd = blastburnRoarcannonCount % 3 == 1 and 48 or blastburnRoarcannonCount % 3 == 2 and 24 or 23
			end
			self:Bar(args.spellId, cd, CL.count:format(CL.beam, blastburnRoarcannonCount))
			self:GetBossTarget(printTarget, 1, args.sourceGUID) -- targets player
	end
end

function mod:EruptionStomp(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, eruptionStombCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive and move
	end
	eruptionStombCount = eruptionStombCount + 1
	local cd = eruptionStombCount % 2 == 1 and 71.0 or 24.0
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, eruptionStombCount))
end

-- Torq the Tempest

function mod:GalvanizedSpiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		local tooHigh = 25
		if amount % 4 == 1 or amount >= tooHigh then
			self:StackMessage(args.spellId, "blue", args.destName, amount, tooHigh)
			if amount >= tooHigh then
				self:PlaySound(args.spellId, "alarm") -- too many stacks
			end
		end
		if self:GetOption("custom_on_fade_out_bars") then
			self:CheckBossRange()
		end
	end
end

function mod:StaticChargeSuccess()
	staticChargeCount = staticChargeCount + 1
	self:Bar(474159, 95, CL.count:format(self:SpellName(474159), staticChargeCount)) -- Static Charge
end

function mod:StaticChargeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info") -- watch steps
		-- XXX track charge and warn when high altpower?
	end
end

function mod:ThunderdrumSalvoSuccess(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, thunderdrumSalvoCount))
	self:PlaySound(args.spellId, "alert")
	thunderdrumSalvoCount = thunderdrumSalvoCount + 1
	local cd = thunderdrumSalvoCount % 2 == 1 and 65.0 or 30.0
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, thunderdrumSalvoCount))
end

-- function mod:VoltaicImage(args)
-- 	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, voltaicImageCount))
-- 	self:PlaySound(args.spellId, "alert")
-- 	voltaicImageCount = voltaicImageCount + 1
-- 	local cd = voltaicImageCount % 2 == 1 and 65.0 or 30.0
-- 	self:Bar(args.spellId, cd, CL.count:format(args.spellName, voltaicImageCount))
-- end

function mod:VoltaicImageFixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1213994, nil, CL.fixate)
		self:PlaySound(1213994, "alarm")
	end
end

function mod:LightningBash(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, lightningBashCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	lightningBashCount = lightningBashCount + 1
	local cd = thunderdrumSalvoCount % 2 == 1 and 65.0 or 30.0
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, lightningBashCount))
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
