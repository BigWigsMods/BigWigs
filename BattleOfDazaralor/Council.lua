--------------------------------------------------------------------------------
-- TODO:
-- - Loa Abilities
-- - Stop/Start bars on boss kills/swaps

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Conclave of the Chosen", 2070, 2330)
if not mod then return end
mod:RegisterEnableMob(144747, 144767, 144963, 144941) -- Pa'ku's Aspect, Gonk's Aspect, Kimbul's Aspect, Akunda's Aspect
mod.engageId = 2268
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		282736, -- Loa's Wrath
		282079, -- Loa's Pact
		286060, -- Cry of the Fallen
		-- Pa'ku's Aspect
		282098, -- Gift of Wind
		285945, -- Hastening Winds
		282107, -- Pa'ku's Wrath
		-- Gonk's Aspect
		{282135, "SAY", "SAY_COUNTDOWN"}, -- Crawling Hex
		285893, -- Wild Maul
		282155, -- Gonk's Wrath
		{282209, "SAY", "FLASH"}, -- Mark of Prey
		-- Kimbul's Aspect
		{282444, "TANK"}, -- Lacerating Claws
		282447, -- Kimbul's Wrath
		-- Akunda's Aspect
		282411, -- Thundering Storm
		285878, -- Mind Wipe
		{286811, "SAY", "SAY_COUNTDOWN"}, -- Akunda's Wrath
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "LoasWrath", 282736)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LoasWrath", 282736)
	self:Log("SPELL_AURA_APPLIED", "LoasPact", 282079)
	self:Log("SPELL_CAST_SUCCESS", "CryoftheFallen", 286060)

	-- Pa'ku's Aspect
	self:Log("SPELL_CAST_START", "GiftofWind", 282098)
	self:Log("SPELL_AURA_APPLIED", "HasteningWinds", 285945)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HasteningWinds", 285945)
	self:Log("SPELL_CAST_START", "PakusWrath", 282107)

	-- Gonk's Aspect
	self:Log("SPELL_CAST_START", "CrawlingHex", 283193)
	self:Log("SPELL_AURA_APPLIED", "CrawlingHexApplied", 282135)
	self:Log("SPELL_AURA_REMOVED", "CrawlingHexRemoved", 282135)
	self:Log("SPELL_CAST_SUCCESS", "WildMaul", 285893)
	self:Log("SPELL_CAST_START", "GonksWrath", 282155)
	self:Log("SPELL_AURA_APPLIED", "MarkofPrey", 282209)

	-- Kimbul's Aspect
	self:Log("SPELL_CAST_START", "LaceratingClaws", 282444)
	self:Log("SPELL_AURA_APPLIED", "LaceratingClawsApplied", 282444)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LaceratingClawsApplied", 282444)
	self:Log("SPELL_CAST_SUCCESS", "KimbulsWrath", 282447)

	-- Akunda's Aspect
	self:Log("SPELL_CAST_START", "ThunderingStorm", 282411)
	self:Log("SPELL_CAST_START", "MindWipe", 285878)
	self:Log("SPELL_AURA_APPLIED", "AkundasWrathApplied", 286811)
	self:Log("SPELL_AURA_REMOVED", "AkundasWrathRemoved", 286811)
end

function mod:OnEngage()
	self:CDBar(282098, 5) -- Gift of Wind
	self:CDBar(282135, 13.5) -- Crawling Hex
	self:CDBar(285893, 17) -- Wild Maul
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LoasWrath(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:LoasPact(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:CryoftheFallen(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 6)
end

function mod:GiftofWind(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 32)
end

function mod:HasteningWinds(args)
	local amount = args.amount or 1
	if amount % 4 == 1 and amount > 12 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:PakusWrath(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:CrawlingHex(args)
	self:Message2(282135, "orange")
	self:PlaySound(282135, "alarm")
	self:CDBar(282135, 25.5)
end

do
	local playerList = mod:NewTargetList()
	function mod:CrawlingHexApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "orange", playerList)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
	end

	function mod:CrawlingHexRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:WildMaul(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 17)
end

function mod:GonksWrath(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:MarkofPrey(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:LaceratingClaws(args)
	self:CDBar(args.spellId, 28) -- 27.9-30.4~
end

function mod:LaceratingClawsApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:KimbulsWrath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ThunderingStorm(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 19.5)
end

function mod:MindWipe(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 30.5)
end

function mod:AkundasWrathApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:AkundasWrathRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
