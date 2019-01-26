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

local bossesKilled = 0

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
		{282834, "SAY", "FLASH", "PROXIMITY"}, -- Kimbul's Wrath
		-- Akunda's Aspect
		282411, -- Thundering Storm
		285878, -- Mind Wipe
		{286811, "SAY", "SAY_COUNTDOWN"}, -- Akunda's Wrath
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- General
	self:Log("SPELL_AURA_APPLIED", "LoasWrath", 282736)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LoasWrath", 282736)
	self:Log("SPELL_AURA_APPLIED", "LoasPact", 282079)
	self:Log("SPELL_CAST_SUCCESS", "CryoftheFallen", 286060)

	-- Pa'ku's Aspect
	self:Log("SPELL_CAST_START", "GiftofWind", 282098)
	self:Log("SPELL_AURA_APPLIED", "HasteningWinds", 285945)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HasteningWinds", 285945)

	-- Gonk's Aspect
	self:Log("SPELL_CAST_START", "CrawlingHex", 283193)
	self:Log("SPELL_AURA_APPLIED", "CrawlingHexApplied", 282135)
	self:Log("SPELL_AURA_REMOVED", "CrawlingHexRemoved", 282135)
	self:Log("SPELL_CAST_SUCCESS", "WildMaul", 285893)
	self:Log("SPELL_AURA_APPLIED", "MarkofPrey", 282209) -- Used for Gonk's Wrath as well

	-- Kimbul's Aspect
	self:Log("SPELL_CAST_START", "LaceratingClaws", 282444)
	self:Log("SPELL_AURA_APPLIED", "LaceratingClawsApplied", 282444)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LaceratingClawsApplied", 282444)
	self:Log("SPELL_AURA_APPLIED", "KimbulsWrathApplied", 282834)
	self:Log("SPELL_AURA_REMOVED", "KimbulsWrathRemoved", 282834)

	-- Akunda's Aspect
	self:Log("SPELL_CAST_START", "ThunderingStorm", 282411)
	self:Log("SPELL_CAST_START", "MindWipe", 285878)
	self:Log("SPELL_AURA_APPLIED", "AkundasWrathApplied", 286811)
	self:Log("SPELL_AURA_REMOVED", "AkundasWrathRemoved", 286811)

	self:Death("BossDeath", 144747, 144767, 144963, 144941) -- Pa'ku's Aspect, Gonk's Aspect, Kimbul's Aspect, Akunda's Aspect)
end

function mod:OnEngage()
	bossesKilled = 0
	self:CDBar(282098, 5) -- Gift of Wind
	self:CDBar(282135, 13.5) -- Crawling Hex
	self:CDBar(285893, 17) -- Wild Maul
	self:Bar(282107, 73) -- Pa'ku's Wrath
	self:Bar(282155, 31) -- Gonk's Wrath
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("282107", nil, true) then -- Pa'ku's Wrath, not in the combat log
		self:Message2(282107, "red")
		self:PlaySound(282107, "warning")
		self:Bar(282107, 60)
		self:CastBar(282107, 5)
	end
end

function mod:LoasWrath(args)
	local unit = self:GetBossByGUID(args.destGUID)
	if unit and not UnitIsDead(unit) then
		self:StackMessage(args.spellId, args.destName, args.amount, "cyan")
		self:PlaySound(args.spellId, "info")
	end
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

do
	local prev = 0
	function mod:MarkofPrey(args)
		-- Gonk's Wrath isn't in the combat log
		-- Instead, throttle the debuff that the raptors apply immediately
		local t = args.time
		if t-prev > 58 then
			prev = t
			self:Message2(282155, "cyan") -- Gonk's Wrath
			self:PlaySound(282155, "info") -- Gonk's Wrath
			self:Bar(282155, 60) -- Gonk's Wrath
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

function mod:LaceratingClaws(args)
	self:CDBar(args.spellId, 28) -- 27.9-30.4~
end

function mod:LaceratingClawsApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

do
	local scheduled, isOnMe = nil, nil
	local function announce()
		if not isOnMe then -- Already announced if it was on me
			mod:Message2(282834, "yellow")
			mod:PlaySound(282834, "alert")
		end
		scheduled = nil
		isOnMe = nil
	end

	function mod:KimbulsWrathApplied(args)
		if not scheduled then
			scheduled = true
			self:Bar(args.spellId, 60)
			self:SimpleTimer(announce, 0.1)
		end
		if self:Me(args.destGUID) then
			isOnMe = true
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:OpenProximity(args.spellId, 5)
		end
	end
end

function mod:KimbulsWrathRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
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
	self:Bar(args.spellId, 60)
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

function mod:BossDeath(args)
	bossesKilled = bossesKilled + 1
	if bossesKilled == 1 then -- Kimbul spawning
		self:Bar(282834, 49) -- Kimbul's Wrath XXX check this
	elseif bossesKilled == 2 then -- Akunda spawning
		self:Bar(286811, 33) -- Akunda's Wrath XXX check this
	end
end
