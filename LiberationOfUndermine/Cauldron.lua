
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Cauldron of Carnage", 2769, 2640)
if not mod then return end
mod:RegisterEnableMob(229181, 229177) -- Flarendo, Torq
mod:SetEncounterID(3010)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local bars = {}

local colossalClashCount = 1

local scrapbombCount = 1
local moltenPhlegmCount = 1
local eruptionStompCount = 1
local blastburnRoarcannonCount = 1

local staticChargeCount = 1
local thunderdrumSalvoCount = 1
local voltaicImageCount = 1
local lightningBashCount = 1

local HIGH_STACKS = 25
local lastScrapbombExplosionTimer = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fade_out_bars = "Fade out bars"
	L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss that is out of range."

	L.bomb_explosion = "Bomb Explosion"
	L.bomb_explosion_desc = "Show a timer for the explosion off the Scrapbombs."
	L.bomb_explosion_icon = 133613

	L.eruption_stomp = "Stomp" -- Short for Eruption Stomp
	L.thunderdrum_salvo = "Salvo" -- Short for Thunderdrum Salvo
	L.voltaic_image = "Fixates" -- Multiple of Fixate
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_on_fade_out_bars",
		{465833, "CASTBAR"}, -- Colossal Clash
			-- 463800, -- Zapbolt
			-- 465446, -- Fiery Wave
		471660, -- Raised Guard
		471557, -- King of Carnage
		1221826, -- Tiny Tussle
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
		[472222] = -30339, -- Flarendo the Furious
		[472225] = -30344, -- Torq the Tempest
	},{ -- Renames
		[465833] = CL.full_energy, -- Colossal Clash (Full Energy)
		[473650] = CL.bomb, -- Scrapbomb (Bomb)
		[472233] = CL.beam, -- Blastburn Roarcannon (Beam)
		[1214190] = L.eruption_stomp, -- Eruption Stomp (Stomp)
		[463900] = L.thunderdrum_salvo, -- Thunderdrum Salvo (Salvo)
		[1213994] = L.voltaic_image, -- Voltaic Image (Fixates)
	}
end

function mod:OnRegister()
	self:SetSpellRename(473650, CL.bomb) -- Scrapbomb (Bomb)
	self:SetSpellRename(472233, CL.beam) -- Blastburn Roarcannon (Beam)
	self:SetSpellRename(1214190, L.eruption_stomp) -- Stomp
	self:SetSpellRename(463900, L.thunderdrum_salvo) -- Salvo
	self:SetSpellRename(1213994, L.voltaic_image) -- Fixates
end

function mod:OnBossEnable()
	-- Fading Bars
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
	self:RegisterMessage("BigWigs_BarEmphasized", "BarEmphasized")

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")

	-- self:Log("SPELL_CAST_SUCCESS", "ColossalClash", 465833) -- XXX USCS
	self:Log("SPELL_CAST_SUCCESS", "ColossalClashSuccess", 465863) -- Flarendo's cast
	self:Log("SPELL_AURA_REMOVED", "ColossalClashRemoved", 465863) -- Flarendo's cast
	self:Log("SPELL_AURA_APPLIED", "RaisedGuardApplied", 471660)
	self:Log("SPELL_AURA_REFRESH", "RaisedGuardApplied", 471660)
	self:Log("SPELL_AURA_APPLIED", "KingOfCarnageApplied", 471557)
	self:Log("SPELL_AURA_APPLIED_DOSE", "KingOfCarnageApplied", 471557)
	self:Log("SPELL_AURA_APPLIED", "TinyTusselApplied", 1221826)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TinyTusselApplied", 1221826)
	self:Log("SPELL_AURA_APPLIED", "SpiteApplied", 472222, 472225) -- Blistering Spite, Galvanized Spite
	self:Log("SPELL_AURA_APPLIED_DOSE", "SpiteApplied", 472222, 472225)

	-- Flarendo the Furious
	self:Log("SPELL_CAST_START", "Scrapbomb", 473650)
	self:Log("SPELL_SUMMON", "ScrapbombSpawn", 1217753)
	self:Log("SPELL_AURA_APPLIED", "MoltenPhlegmApplied", 1213690)
	self:Log("SPELL_CAST_START", "BlastburnRoarcannon", 472233)
	self:Log("SPELL_CAST_START", "EruptionStomp", 1214190)

	-- Torq the Tempest
	self:Log("SPELL_CAST_SUCCESS", "StaticCharge", 473994)
	self:Log("SPELL_AURA_APPLIED", "StaticChargeApplied", 474159)
	self:Log("SPELL_CAST_SUCCESS", "ThunderdrumSalvo", 463900)
	-- self:Log("SPELL_CAST_SUCCESS", "VoltaicImage", 1213994) -- XXX USCS
	self:Log("SPELL_AURA_APPLIED", "VoltaicImageFixateApplied", 1214009)
	self:Log("SPELL_CAST_START", "LightningBash", 466178)

	self:Death("Deaths", 229181, 229177) -- Flarendo, Torque

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 1214039, 463925) -- Molten Pool, Lingering Electricity
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 1214039, 463925)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 1214039, 463925)
end

function mod:OnEngage()
	bars = {}
	colossalClashCount = 1

	self:Bar(465833, 75, CL.count:format(CL.full_energy, colossalClashCount)) -- Colossal Clash

	-- Flarendo
	scrapbombCount = 1
	moltenPhlegmCount = 1
	eruptionStompCount = 1
	blastburnRoarcannonCount = 1

	local bombCD = self:Easy() and 10.0 or 9.0
	lastScrapbombExplosionTimer = bombCD + 14 -- expected explosion time, corrected when bomb spawns
	self:Bar(473650, bombCD, CL.count:format(CL.bomb, scrapbombCount)) -- Scrapbomb
	self:Bar("bomb_explosion", lastScrapbombExplosionTimer, CL.count:format(L.bomb_explosion, scrapbombCount), L.bomb_explosion_icon) -- Scrapbomb, bomb icon
	self:Bar(472233, self:Easy() and 16.0 or 15.0, CL.count:format(CL.beam, blastburnRoarcannonCount)) -- Blastburn Roarcannon
	self:Bar(1214190, self:Easy() and 30.0 or 26.0, CL.count:format(L.eruption_stomp, eruptionStompCount)) -- Eruption Stomp
	if not self:Easy() then
		self:Bar(1213690, self:Mythic() and 24.6 or 49.0, CL.count:format(self:SpellName(1213690), moltenPhlegmCount)) -- Molten Phlegm
	end

	-- Torq
	staticChargeCount = 1
	thunderdrumSalvoCount = 1
	voltaicImageCount = 1
	lightningBashCount = 1

	self:Bar(474159, 6.0, CL.count:format(self:SpellName(474159), staticChargeCount)) -- Static Charge
	self:Bar(463900, self:Easy() and 20.0 or 10.0, CL.count:format(L.thunderdrum_salvo, thunderdrumSalvoCount)) -- Thunderdrum Salvo
	self:Bar(466178, self:Easy() and 35.0 or 21.0, CL.count:format(self:SpellName(466178), lightningBashCount)) -- Lightning Bash
	if not self:Easy() then
		self:Bar(1213994, 30, CL.count:format(L.voltaic_image, voltaicImageCount)) -- Voltaic Image
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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
		[1213690] = true, -- Molten Phlegm
	}

	local torqueAbilities = {
		[474159] = true, -- Static Charge
		[463900] = true, -- Thunderdrum Salvo
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

-- General
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 465833 then -- Colossal Clash
		self:ColossalClash()
	elseif spellId == 1213994 then -- Voltaic Image
		self:VoltaicImage()
	end
end

function mod:Deaths(args)
	self:StopBar(CL.count:format(CL.full_energy, colossalClashCount)) -- Colossal Clash
	self:StopCastBar(465833)
	if args.mobId == 229181 then -- Flarendo
		self:StopBar(CL.count:format(CL.bomb, scrapbombCount)) -- Scrapbomb
		local bombCD = self:BarTimeLeft(CL.count:format(L.bomb_explosion, scrapbombCount))
		if bombCD > 10 then
			self:StopBar(CL.count:format(L.bomb_explosion, scrapbombCount))
		end
		self:StopBar(CL.count:format(self:SpellName(1213690), moltenPhlegmCount)) -- Molten Phlegm
		self:StopBar(CL.count:format(CL.beam, blastburnRoarcannonCount)) -- Blastburn Roarcannon
		self:StopBar(CL.count:format(L.eruption_stomp, eruptionStompCount)) -- Eruption Stomp
	elseif args.mobId == 229177 then -- Torq
		self:StopBar(CL.count:format(self:SpellName(474159), staticChargeCount)) -- Static Charge
		self:StopBar(CL.count:format(L.thunderdrum_salvo, thunderdrumSalvoCount)) -- Thunderdrum Salvo
		self:StopBar(CL.count:format(L.voltaic_image, voltaicImageCount)) -- Voltaic Image
		self:StopBar(CL.count:format(self:SpellName(466178), lightningBashCount)) -- Lightning Bash
	end
end

function mod:ColossalClash()
	self:StopBar(CL.count:format(CL.full_energy, colossalClashCount))
	self:Message(465833, "cyan", CL.count:format(CL.full_energy, colossalClashCount))
	self:PlaySound(465833, "long") -- 20s clash
	colossalClashCount = colossalClashCount + 1
	self:Bar(465833, 95, CL.count:format(CL.full_energy, colossalClashCount))
end

function mod:ColossalClashSuccess(args)
	self:CastBar(465833, 20)
end

function mod:ColossalClashRemoved(args)
	if self:MobId(args.destGUID) == 229177 then
		self:Message(465833, "cyan", CL.over:format(args.spellName))
		self:PlaySound(465833, "long")
	end
end

do
	local prev = 0
	function mod:RaisedGuardApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red")
			if self:Tank() then
				self:PlaySound(args.spellId, "warning")
			end
		end
	end
end

function mod:KingOfCarnageApplied(args)
	if not args.amount then -- killed one boss
		self:TargetMessage(args.spellId, "red", args.destName)
		self:PlaySound(args.spellId, "long")
	elseif args.amount % 2 == 1 then
		self:Message(args.spellId, "red", CL.count:format(args.spellName, args.amount))
		-- self:PlaySound(args.spellId, "alarm")
	end
end

function mod:TinyTusselApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 2)
		if args.amount then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:SpiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount >= HIGH_STACKS and amount % 4 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, HIGH_STACKS)
			-- if amount >= HIGH_STACKS then
			-- 	self:PlaySound(args.spellId, "alarm")
			-- end
		end
		if self:GetOption("custom_on_fade_out_bars") then
			self:CheckBossRange()
		end
	end
end

-- Flarendo the Furious
do
	local expectedExplosion = 0
	function mod:Scrapbomb(args)
		self:StopBar(CL.count:format(CL.bomb, scrapbombCount))
		if self:IsFlarendoInRange() then
			self:Message(args.spellId, "orange", CL.count:format(CL.bomb, scrapbombCount))
			self:PlaySound(args.spellId, "alert") -- soak bombs
		end
		scrapbombCount = scrapbombCount + 1

		local cd
		if self:Easy() then -- 2 per
			cd = scrapbombCount % 2 == 1 and 65.0 or 30.0 -- 10.0, 30.0
		else -- 3 per
			cd = scrapbombCount % 3 == 1 and 48.0 or scrapbombCount % 3 == 2 and 23.0 or 24.0 -- 9.0, 23.0, 24.0
		end
		expectedExplosion = cd + 14 -- storing this so we can correct the bar without jumping total duration around
		self:Bar(args.spellId, cd, CL.count:format(CL.bomb, scrapbombCount))
		self:Bar("bomb_explosion", expectedExplosion, CL.count:format(L.bomb_explosion, scrapbombCount), L.bomb_explosion_icon) -- Scrapbomb Explosion
	end

	function mod:ScrapbombSpawn() -- When spawned, 10s to explosion
		self:Bar("bomb_explosion", {10, lastScrapbombExplosionTimer}, CL.count:format(L.bomb_explosion, scrapbombCount-1), L.bomb_explosion_icon) -- Scrapbomb Explosion
		lastScrapbombExplosionTimer = expectedExplosion -- Now we can set the last timer to use it next bombs
	end
end

do
	local prev = 0
	function mod:MoltenPhlegmApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, moltenPhlegmCount))
			moltenPhlegmCount = moltenPhlegmCount + 1

			local cd
			if self:Mythic() then -- 2 per
				cd = moltenPhlegmCount % 2 == 1 and 70.5 or 24.5 -- 24.5, 24.5
			else -- 1 per
				cd = 95.0
			end
			self:Bar(args.spellId, cd, CL.count:format(args.spellName, moltenPhlegmCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local function printTarget(self, player, guid)
		self:TargetMessage(472233, "red", player, CL.count:format(CL.beam, blastburnRoarcannonCount-1))
		if self:Me(guid) then
			self:PlaySound(472233, "warning")
			self:Say(472233, CL.beam, nil, "Beam")
		else
			self:PlaySound(472233, "alarm", nil, player)
		end
	end

	function mod:BlastburnRoarcannon(args)
		self:StopBar(CL.count:format(CL.beam, blastburnRoarcannonCount))
		blastburnRoarcannonCount = blastburnRoarcannonCount + 1
		self:GetBossTarget(printTarget, 1, args.sourceGUID) -- targets a player

		local cd
		if self:Easy() then -- 2 per
			cd = blastburnRoarcannonCount % 2 == 1 and 65.0 or 30.0 -- 16.0, 30.0
		else -- 3 per
			cd = blastburnRoarcannonCount % 3 == 1 and 50.0 or blastburnRoarcannonCount % 3 == 2 and 24.0 or 21.0 -- 15.0, 24.0, 21.0
		end
		self:Bar(args.spellId, cd, CL.count:format(CL.beam, blastburnRoarcannonCount))
	end
end

function mod:EruptionStomp(args)
	self:StopBar(CL.count:format(args.spellName, eruptionStompCount))
	if self:IsFlarendoInRange() then
		self:Message(args.spellId, "purple", CL.count:format(args.spellName, eruptionStompCount))
	end
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive and move
	end
	eruptionStompCount = eruptionStompCount + 1

	local cd
	if self:Easy() then -- 2 per
		cd = eruptionStompCount % 2 == 1 and 65.0 or 30.0 -- 30.0, 30.0
	elseif self:Mythic() then -- 2 per
		cd = eruptionStompCount % 2 == 1 and 70.0 or 25.0 -- 26.0, 25.0
	else -- 1 per
		cd = 95.0
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, eruptionStompCount))
end

-- Torq the Tempest
function mod:StaticCharge()
	self:StopBar(CL.count:format(self:SpellName(474159), staticChargeCount))
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

function mod:ThunderdrumSalvo(args)
	self:StopBar(CL.count:format(L.thunderdrum_salvo, thunderdrumSalvoCount))
	if self:IsTorqueInRange() then
		self:Message(args.spellId, "yellow", CL.count:format(L.thunderdrum_salvo, thunderdrumSalvoCount))
		self:PlaySound(args.spellId, "alarm")
	end
	thunderdrumSalvoCount = thunderdrumSalvoCount + 1

	local cd
	if self:Easy() then -- 2 per
		cd = thunderdrumSalvoCount % 2 == 1 and 70.0 or 25.0 -- 20.0, 25.0
	else -- 2 per
		cd = thunderdrumSalvoCount % 2 == 1 and 65.0 or 30.0 -- 10.0, 30.0
	end
	self:Bar(args.spellId, cd, CL.count:format(L.thunderdrum_salvo, thunderdrumSalvoCount))
end

function mod:VoltaicImage()
	self:StopBar(CL.count:format(L.voltaic_image, voltaicImageCount))
	if self:IsTorqueInRange() then
		self:Message(1213994, "orange", CL.count:format(L.voltaic_image, voltaicImageCount))
		self:PlaySound(1213994, "alert")
	end
	voltaicImageCount = voltaicImageCount + 1

	local cd
	if self:Mythic() then -- 1 per
		cd = 95.0
	else -- 2 per
		cd = voltaicImageCount % 2 == 1 and 65.0 or 30.0 -- 30.0, 30.0
	end
	self:Bar(1213994, cd, CL.count:format(L.voltaic_image, voltaicImageCount))
end

function mod:VoltaicImageFixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1213994, nil, CL.fixate)
		self:PlaySound(1213994, "alarm")
	end
end

function mod:LightningBash(args)
	self:StopBar(CL.count:format(args.spellName, lightningBashCount))
	if self:IsTorqueInRange() then
		self:Message(args.spellId, "purple", CL.count:format(args.spellName, lightningBashCount))
	end
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	lightningBashCount = lightningBashCount + 1

	local cd
	if self:Easy() then -- 2 per
		cd = lightningBashCount % 2 == 1 and 70.0 or 25.0 -- 35.0, 25.0
	else -- 2 per
		cd = lightningBashCount % 2 == 1 and 65.0 or 30.0 -- 21.0, 30.0
	end
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
