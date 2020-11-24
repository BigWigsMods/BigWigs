
--------------------------------------------------------------------------------
-- TODO:
-- -- Mythic: Dancing Fever
-- -- Stop/start bars during a dance? does it delay it or just keep the CD counting down?
-- -- Translate boss emotes for the dance

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Council of Blood", 2296, 2426)
if not mod then return end
mod:RegisterEnableMob(
	166969, -- Baroness Frieda
	166970, -- Lord Stavros
	166971) -- Castellan Niklaus
mod.engageId = 2412
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local bossesKilled = 0
local stavrosAlive = true
local friedaAlive = true
local niklausAlive = true

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.macabre_start_emote = "Take your places for the Danse Macabre!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Repeating Dark Recital"
	L.custom_on_repeating_dark_recital_desc = "Repeating Dark Recital say messages with icons {rt1}, {rt2} to find your partner while dancing."
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",

		--[[ Castellan Niklaus ]]--
		{346690, "TANK"}, -- Duelist's Riposte
		346698, -- Summon Dutiful Attendant

	--	334948, -- Unstoppable Charge
		--330965, -- Castellan's Cadre
		--330967, -- Fixate

		--[[ Baroness Frieda ]]--
		346651, -- Drain Essence
		337110, -- Dreadbolt Volley
		346657, -- Prideful Eruption

	--	{331706, "SAY", "SAY_COUNTDOWN"}, -- Scarlet Letter
		--330978, -- Dredger Servants

		--[[ Lord Stavros ]]--
		327497, -- Evasive Lunge
		{331634, "SAY"}, -- Dark Recital
		"custom_on_repeating_dark_recital",
		346800, -- Waltz of Blood

		--330964, -- Dancing Fools

		--[[ Intermission: The Danse Macabre ]]--
		330959, -- Danse Macabre
		330848, -- Wrong Moves

		--[[ Mythic ]]--
		{347350, "SAY", "SAY_COUNTDOWN"},
	}, {
		["stages"] = "general",
		[328334] = -22147, -- Castellan Niklaus
		[327773] = -22148, -- Baroness Frieda
		[327497] = -22149, -- Lord Stavros
		[330959] = -22146, -- Intermission: The Danse Macabre
		[342859] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:Death("BossDeath", 166969, 166970, 166971) -- Baroness Frieda, Lord Stavros, Castellan Niklaus

	--[[ Castellan Niklaus ]]--
	self:Log("SPELL_CAST_START", "DuelistsRiposte", 346690)
	self:Log("SPELL_CAST_START", "SummonDutifulAttendant", 346698)

	-- self:Log("SPELL_CAST_START", "UnstoppableCharge", 334948)
	-- self:Log("SPELL_CAST_START", "CastellansCadre", 330965)
	-- self:Log("SPELL_AURA_APPLIED", "Fixate", 330967)

	--[[ Baroness Frieda ]]--
	self:Log("SPELL_AURA_APPLIED", "DrainEssenceApplied", 346651)
	self:Log("SPELL_CAST_START", "DreadboltVolley", 337110)
	self:Log("SPELL_CAST_START", "PridefulEruption", 346657)

	-- self:Log("SPELL_CAST_SUCCESS", "ScarletLetter", 331704)
	-- self:Log("SPELL_AURA_APPLIED", "ScarletLetterApplied", 331706)
	-- self:Log("SPELL_AURA_REMOVED", "ScarletLetterRemoved", 331706)	--
	-- self:Log("SPELL_CAST_START", "DredgerServants", 330978)

	--[[ Lord Stavros ]]--
	self:Log("SPELL_CAST_START", "EvasiveLunge", 327497)
	self:Log("SPELL_CAST_SUCCESS", "DarkRecital", 331634)
	self:Log("SPELL_AURA_APPLIED", "DarkRecitalApplied", 331637, 331636)
	self:Log("SPELL_AURA_REMOVED", "DarkRecitalRemoved", 331637, 331636)
	self:Log("SPELL_CAST_SUCCESS", "WaltzOfBlood", 346800)


	--self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3") -- Waltz Of Blood, Dancing Fools
	-- self:Log("SPELL_CAST_SUCCESS", "DancingFools", 330964) -- USCS

	--[[ Intermission: The Danse Macabre ]]--
	self:Log("SPELL_CAST_SUCCESS", "DanseMacabre", 330959)
	self:Log("SPELL_CAST_SUCCESS", "DanseMacabreKill", 328497)
	self:Log("SPELL_AURA_APPLIED", "WrongMovesApplied", 330848)
	self:Log("SPELL_AURA_REMOVED", "WrongMovesRemoved", 330848)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "DancingFeverApplied", 347350)
	--self:Log("SPELL_AURA_REMOVED", "DancingFeverRemoved", 347350)
end

function mod:OnEngage()
	bossesKilled = 0
	friedaAlive = true
	stavrosAlive = true
	niklausAlive = true

	self:CDBar(346690, 17) -- Tactical Advance
	self:CDBar(346698, 7) -- Summon Dutiful Attendant

	self:CDBar(346651, 14.5) -- Drain Essence
	self:CDBar(337110, 6) -- Dreadbolt Volley

	self:CDBar(327497, 8.5) -- Evasive Lunge
	self:CDBar(331634, 23.8) -- Dark Recital

	if self:Mythic() then
		self:CDBar(347350, 5) -- Evasive Lunge
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find(L.macabre_start_emote, nil, true) then -- Dance Macabre start
		self:CastBar(330959, 7) -- Dance Macabre
	end
end

function mod:BossDeath(args)
	bossesKilled = bossesKilled + 1
	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	if args.mobId == 166969 then
		friedaAlive = false
	elseif args.mobId == 166970 then
		stavrosAlive = false
	elseif args.mobId == 166971 then
		niklausAlive = false
	end
	if bossesKilled == 1 then
		if friedaAlive then
			--self:CDBar(331706, 8) -- Scarlet Letter
		end
		if stavrosAlive then
			--self:CDBar(331634, 8) -- Dark Recital
		end
		if niklausAlive then
			--self:CDBar(334948, 7) -- Unstoppable Charge
		end
	elseif bossesKilled == 2 then
		if friedaAlive then
				--self:CDBar(330978, 10.3) -- Dredger Servants
		end
		if stavrosAlive then
			--self:CDBar(330964, 5.5) -- Dancing Fools
		end
		if niklausAlive then
			--self:CDBar(330965, 5.2) -- Castellan's Cadre
		end
	end
end

--[[ Castellan Niklaus ]]--
function mod:DuelistsRiposte(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 37.5)
end

function mod:SummonDutifulAttendant(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 45)
end

-- function mod:UnstoppableCharge(args)
-- 	self:Message(args.spellId, "red")
-- 	self:PlaySound(args.spellId, "long")
-- 	self:Bar(args.spellId, 19.7)
-- end

-- function mod:CastellansCadre(args)
-- 	self:Message(args.spellId, "cyan")
-- 	self:PlaySound(args.spellId, "info")
-- 	self:CDBar(args.spellId, 26.5)
-- end

-- function mod:Fixate(args)
-- 	if self:Me(args.destGUID) then
-- 		self:PersonalMessage(args.spellId)
-- 		self:PlaySound(args.spellId, "warning")
-- 	end
-- end


--[[ Baroness Frieda ]]--
do
	local playerList = mod:NewTargetList()
	function mod:DrainEssenceApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		if #playerList == 1 then
			self:CDBar(args.spellId, 22.5)
		end
		self:TargetsMessage(args.spellId, "cyan", playerList, 3)
	end
end

function mod:DreadboltVolley(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end


function mod:PridefulEruption(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 25)
end

-- do
-- 	local function printTarget(self, name, guid)
-- 		self:TargetMessage(331706, "red", name)
-- 		if self:Me(guid) then
-- 			self:Yell(331706)
-- 		end
-- 	end
--
-- 	function mod:ScarletLetter(args)
-- 		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
-- 		self:PlaySound(331706, "long")
-- 		self:CDBar(331706, 30.5)
-- 	end
-- end

-- function mod:ScarletLetterApplied(args)
-- 	self:TargetBar(args.spellId, 8, args.destName)
-- 	if self:Me(args.destGUID) then
-- 		self:YellCountdown(args.spellId, 8)
-- 	end
-- end
--
-- function mod:ScarletLetterRemoved(args)
-- 	if self:Me(args.destGUID) then
-- 		self:CancelYellCountdown(args.spellId)
-- 	end
-- end
--
-- function mod:DredgerServants(args)
-- 	self:Message(args.spellId, "cyan")
-- 	self:PlaySound(args.spellId, "info")
-- 	self:CDBar(args.spellId, 32)
-- end

--[[ Lord Stavros ]]--
function mod:EvasiveLunge(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 18.8)
end

-- function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
-- 	if spellId == 327724 then -- Waltz of Blood
-- 		self:Message(327619, "yellow")
-- 		self:PlaySound(327619, "long")
-- 		self:CDBar(327619, 22) -- Waltz of Blood
-- 	elseif spellId == 330964 then -- Dancing Fools
-- 		self:Message(spellId, "yellow")
-- 		self:PlaySound(spellId, "long")
-- 		self:CDBar(spellId, 30)
-- 	end
-- end

function mod:WaltzOfBlood(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 60)
end

do
	local firstDarkRecitalTargetGUID, lastDarkRecitalName, darkrecitalPairCount = nil, nil, 0
	local darkRecitalFallbackTimer, sayTimer = nil, nil

	function mod:DarkRecital(args)
		self:Message(args.spellId, "orange")
		firstDarkRecitalTargetGUID = nil
		darkrecitalPairCount = 0
		self:Bar(args.spellId, 45)
	end

	function mod:DarkRecitalApplied(args)
		if self:Me(args.destGUID) then
			self:PlaySound(331634, "warning")
		end

		if args.spellId == 331636 then -- 1st Dark Recital Target
			firstDarkRecitalTargetGUID = args.destGUID
			lastDarkRecitalName = args.destName
			darkrecitalPairCount = darkrecitalPairCount + 1
			if self:Me(args.destGUID) then -- fallback if a partner is missing
				darkRecitalFallbackTimer = self:ScheduleTimer("Message", 0.1, 331634, "blue", CL.link:format("|cffff0000???"))
			end
		elseif args.spellId == 331637 and firstDarkRecitalTargetGUID then -- 2nd Dark Recital Target
			if self:Me(args.destGUID) then -- We got 2nd debuff, so print last name
				self:Message(331634, "blue", CL.link:format(self:ColorName(lastDarkRecitalName)))
				self:Yell(331634, "{rt"..darkrecitalPairCount.."}", true)
				if self:GetOption("custom_on_repeating_dark_recital") then
					sayTimer = self:ScheduleRepeatingTimer(SendChatMessage, 1.5, "{rt"..darkrecitalPairCount.."}", "YELL")
				end
			elseif self:Me(firstDarkRecitalTargetGUID) then -- We got 1st debuff so this is our partner
				self:Message(331634, "blue", CL.link:format(self:ColorName(args.destName)))
				self:Yell(331634, "{rt"..darkrecitalPairCount.."}", true)
				if self:GetOption("custom_on_repeating_dark_recital") then
					sayTimer = self:ScheduleRepeatingTimer(SendChatMessage, 1.5, "{rt"..darkrecitalPairCount.."}", "YELL")
				end
			end
			firstDarkRecitalTargetGUID = nil
			if darkRecitalFallbackTimer then -- We printed above, so cancel this
				self:CancelTimer(darkRecitalFallbackTimer)
				darkRecitalFallbackTimer = nil
			end
		else -- Missing a partner, alternative message
			if self:Me(args.destGUID) or self:Me(firstDarkRecitalTargetGUID) then
				self:Message(331634, "blue", CL.link:format("|cffff00ff???"))
				if darkRecitalFallbackTimer then -- We printed above, so cancel this
					self:CancelTimer(darkRecitalFallbackTimer)
					darkRecitalFallbackTimer = nil
				end
			end
			firstDarkRecitalTargetGUID = nil
		end
	end

	function mod:DarkRecitalRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(331634, "green", CL.removed:format(args.spellName))
			self:PlaySound(331634, "info")
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
		end
	end
end

-- function mod:DancingFools(args) -- USCS
-- 	self:Message(args.spellId, "cyan")
-- 	self:PlaySound(args.spellId, "info")
-- 	self:Bar(args.spellId, 30)
-- end

--[[ Intermission: The Danse Macabre ]]--

do
	local prev = 0
	function mod:DanseMacabre(args)
		local t = args.time
		if t-prev > 10 then
			prev = t
			self:Message(args.spellId, "green")
			self:PlaySound(args.spellId, "long")
		end
	end
end

function mod:DanseMacabreKill(args)
		self:CDBar(347350, 32) -- Dancing Fever
end

function mod:WrongMovesApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

function mod:WrongMovesRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

--[[ Mythic ]]--
do
	local playerList = mod:NewTargetList()
	function mod:DancingFeverApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		if #playerList == 1 then
			self:CDBar(args.spellId, 60)
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 5)
	end

	-- function mod:DancingFeverRemoved(args)
	--
	-- end
end
