--------------------------------------------------------------------------------
-- TODO:
-- -- Stop/start bars during a dance? does it delay it or just keep the CD counting down?

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
local killOrder = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.macabre_start_emote = "Take your places for the Danse Macabre!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Repeating Dark Recital"
	L.custom_on_repeating_dark_recital_desc = "Repeating Dark Recital say messages with icons {rt1}, {rt2} to find your partner while dancing."

	L.custom_off_select_boss_order = "Mark Boss Kill Order"
	L.custom_off_select_boss_order_desc = "Mark the order the raid will kill the bosses in with cross {rt7}. Requires raid leader or assist to mark."
	L.custom_off_select_boss_order_value1 = "Niklaus -> Frieda -> Stavros"
	L.custom_off_select_boss_order_value2 = "Frienda -> Niklaus -> Stavros"
	L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frienda"
	L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frienda"
	L.custom_off_select_boss_order_value5 = "Frienda -> Stavros -> Niklaus"
	L.custom_off_select_boss_order_value6 = "Stavros -> Frienda -> Niklaus"
end

--------------------------------------------------------------------------------
-- Initialization
--

local dutifulAttendantMarker = mod:AddMarkerOption(false, "npc", 8, 346698, 8) -- Summon Dutiful Attendant // TODO Replace npc with Dutiful Attendant from DJ
local waltzingVenthyrMarker = mod:AddMarkerOption(false, "npc", 8, 346303, 8) -- Violent Uproar // TODO Replace npc with Waltzing Venthyr from DJ
function mod:GetOptions()
	return {
		"stages",
		"custom_off_select_boss_order",

		--[[ Castellan Niklaus ]]--
		{346690, "TANK"}, -- Duelist's Riposte
		346698, -- Summon Dutiful Attendant
		dutifulAttendantMarker,
		330978, -- Dredger Servants
		330965, -- Castellan's Cadre
		{346790, "TANK"}, -- Sintouched Blade

		--[[ Baroness Frieda ]]--
		346651, -- Drain Essence
		337110, -- Dreadbolt Volley
		346657, -- Prideful Eruption
		346945, -- Manifest Pain
		346681, -- Soul Spikes

		--[[ Lord Stavros ]]--
		327497, -- Evasive Lunge
		{331634, "SAY"}, -- Dark Recital
		"custom_on_repeating_dark_recital",
		346800, -- Waltz of Blood
		346303, -- Violent Uproar
		waltzingVenthyrMarker,

		--[[ Intermission: The Danse Macabre ]]--
		330959, -- Danse Macabre
		{330848, "ME_ONLY"}, -- Wrong Moves

		--[[ Mythic ]]--
		{347350, "SAY", "SAY_COUNTDOWN"},
	}, {
		["stages"] = "general",
		[346690] = -22147, -- Castellan Niklaus
		[346651] = -22148, -- Baroness Frieda
		[327497] = -22149, -- Lord Stavros
		[330959] = -22146, -- Intermission: The Danse Macabre
		[347350] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:Death("BossDeath", 166969, 166970, 166971) -- Baroness Frieda, Lord Stavros, Castellan Niklaus

	--[[ Castellan Niklaus ]]--
	self:Log("SPELL_CAST_START", "DuelistsRiposte", 346690)
	self:Log("SPELL_AURA_APPLIED", "DuelistsRiposteApplied", 346690)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DuelistsRiposteApplied", 346690)
	self:Log("SPELL_CAST_START", "SummonDutifulAttendant", 346698)
	self:Log("SPELL_CAST_START", "DredgerServants", 330978)
	self:Log("SPELL_CAST_START", "CastellansCadre", 330965)
	self:Log("SPELL_CAST_START", "SintouchedBlade", 346790)

	--[[ Baroness Frieda ]]--
	self:Log("SPELL_AURA_APPLIED", "DrainEssenceApplied", 346651)
	self:Log("SPELL_CAST_START", "DreadboltVolley", 337110)
	self:Log("SPELL_CAST_START", "PridefulEruption", 346657)
	self:Log("SPELL_CAST_START", "SoulSpikes", 346762)
	self:Log("SPELL_AURA_APPLIED", "SoulSpikesApplied", 346681)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SoulSpikesApplied", 346681)

	--[[ Lord Stavros ]]--
	self:Log("SPELL_CAST_START", "EvasiveLunge", 327497)
	self:Log("SPELL_AURA_APPLIED", "EvasiveLungeApplied", 327610)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EvasiveLungeApplied", 327610)
	self:Log("SPELL_CAST_SUCCESS", "DarkRecital", 331634)
	self:Log("SPELL_AURA_APPLIED", "DarkRecitalApplied", 331637, 331636)
	self:Log("SPELL_AURA_REMOVED", "DarkRecitalRemoved", 331637, 331636)
	self:Log("SPELL_CAST_SUCCESS", "WaltzOfBlood", 346800)
	self:Log("SPELL_CAST_START", "ViolentUproar", 346303)

	--[[ Intermission: The Danse Macabre ]]--
	self:Log("SPELL_CAST_SUCCESS", "DanseMacabre", 330959)
	self:Log("SPELL_CAST_SUCCESS", "DanseMacabreKill", 328497)
	self:Log("SPELL_AURA_APPLIED", "WrongMovesApplied", 330848)
	self:Log("SPELL_AURA_REMOVED", "WrongMovesRemoved", 330848)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "DancingFeverApplied", 347350)
	--self:Log("SPELL_AURA_REMOVED", "DancingFeverRemoved", 347350)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 346945) -- Manifest Pain
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 346945)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 346945)
end

function mod:OnEngage()
	bossesKilled = 0
	friedaAlive = true
	stavrosAlive = true
	niklausAlive = true

	self:CDBar(346690, 18.4) -- Duelist's Riposte
	self:CDBar(346698, 7) -- Summon Dutiful Attendant

	self:CDBar(346651, 14.5) -- Drain Essence
	self:CDBar(337110, 6) -- Dreadbolt Volley

	self:CDBar(327497, 8.4) -- Evasive Lunge
	self:CDBar(331634, 23.8) -- Dark Recital

	if self:Mythic() then
		self:CDBar(347350, 5) -- Dancing Fever
	end

	-- Mark kill order
	killOrder = self:GetOption("custom_off_select_boss_order")
	if killOrder == 1 or killOrder == 4 then -- Niklaus first
		local boss = self:GetUnitIdByGUID(166971) -- Castellan Niklaus
		if boss then
			SetRaidTarget(boss, 7)
		end
	elseif killOrder == 2 or killOrder == 5 then -- Frieda First
		local boss = self:GetUnitIdByGUID(166969) -- Baroness Frieda
		if boss then
			SetRaidTarget(boss, 7)
		end
	elseif killOrder == 3 or killOrder == 6 then -- Stavros First
		local boss = self:GetUnitIdByGUID(166970) -- Lord Stavros
		if boss then
			SetRaidTarget(boss, 7)
		end
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
	if bossesKilled > 2 then return end -- You win at 3

	self:Message("stages", "green", CL.mob_killed:format(args.destName, bossesKilled, 3), false)
	if args.mobId == 166969 then -- Frieda
		friedaAlive = false
		self:StopBar(346651) -- Drain Essence
		self:StopBar(337110) --  Dreadbolt Volley
		self:StopBar(346657) --  Prideful Eruption
	elseif args.mobId == 166970 then -- Stavros
		stavrosAlive = false
		self:StopBar(327497) -- Evasive Lunge
		self:StopBar(331634) --  Dark Recital
		self:StopBar(346800) --  Waltz of Blood
	elseif args.mobId == 166971 then -- Niklaus
		niklausAlive = false
		self:StopBar(346690) -- Duelist's Riposte
		self:StopBar(346698) --  Summon Dutiful Attendant
		self:StopBar(330978) --  Dredger Servants
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
		if killOrder == 2 or killOrder == 3 then -- Niklaus second
			local boss = self:GetUnitIdByGUID(166971) -- Castellan Niklaus
			if boss then
				SetRaidTarget(boss, 7)
			end
		elseif killOrder == 1 or killOrder == 6 then -- Frieda second
			local boss = self:GetUnitIdByGUID(166969) -- Baroness Frieda
			if boss then
				SetRaidTarget(boss, 7)
			end
		elseif killOrder == 4 or killOrder == 5 then -- Stavros second
			local boss = self:GetUnitIdByGUID(166970) -- Lord Stavros
			if boss then
				SetRaidTarget(boss, 7)
			end
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
		if killOrder == 5 or killOrder == 6 then -- Niklaus last
			local boss = self:GetUnitIdByGUID(166971) -- Castellan Niklaus
			if boss then
				SetRaidTarget(boss, 7)
			end
		elseif killOrder == 3 or killOrder == 4 then -- Frieda last
			local boss = self:GetUnitIdByGUID(166969) -- Baroness Frieda
			if boss then
				SetRaidTarget(boss, 7)
			end
		elseif killOrder == 1 or killOrder == 2 then -- Stavros last
			local boss = self:GetUnitIdByGUID(166970) -- Lord Stavros
			if boss then
				SetRaidTarget(boss, 7)
			end
		end
	end
end

--[[ Castellan Niklaus ]]--
function mod:DuelistsRiposte(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, bossesKilled == 0 and 21.4 or bossesKilled == 1 and 17 or 9)
end

function mod:DuelistsRiposteApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
end

do
	function mod:DutifulAttendantMarking(event, unit, guid)
		if self:MobId(guid) == 175992 then -- Dutiful Attendant
			SetRaidTarget(unit, 8)
			self:UnregisterTargetEvents()
		end
	end

	function mod:SummonDutifulAttendant(args)
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
		self:CDBar(args.spellId, 45)
		if self:GetOption(dutifulAttendantMarker) then
			self:RegisterTargetEvents("DutifulAttendantMarking")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
	end
end
function mod:DredgerServants(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	--self:CDBar(args.spellId, 45)
end

function mod:CastellansCadre(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:CDBar(args.spellId, 26.5)
end

function mod:SintouchedBlade(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	--self:CDBar(args.spellId, 26.5)
end


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

function mod:SoulSpikes(args)
	self:Message(346681, "orange", CL.casting:format(args.spellName))
	self:PlaySound(346681, "alert")
end

function mod:SoulSpikesApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "cyan")
	self:PlaySound(args.spellId, "info")
end

--[[ Lord Stavros ]]--
function mod:EvasiveLunge(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, bossesKilled == 0 and 21.4 or bossesKilled == 1 and 17 or 11)
end

function mod:EvasiveLungeApplied(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and not self:Tank() then
		self:StackMessage(327497, args.destName, amount, "blue")
		self:PlaySound(327497, "alarm")
	elseif self:Tank() and self:Tank(args.destName) then
		self:StackMessage(327497, args.destName, amount, "purple")
	end
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

function mod:WaltzOfBlood(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 60)
end

do
	function mod:WaltzingVenthyrMarking(event, unit, guid)
		if self:MobId(guid) == 176026 then -- Dancing Fool (only 1 targetable unit)
			SetRaidTarget(unit, 8)
			self:UnregisterTargetEvents()
		end
	end

	local prev = 0
	function mod:ViolentUproar(args) -- Maybe a better way?
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "warning")
			--self:Bar(args.spellId, 30)
			if self:GetOption(waltzingVenthyrMarker) then
				self:RegisterTargetEvents("WaltzingVenthyrMarking")
				self:ScheduleTimer("UnregisterTargetEvents", 5)
			end
		end
	end
end

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
	self:TargetMessage(args.spellId, "orange", args.destName) -- ME_ONLY is enabled, but players can get all fails if they would like too
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "info")
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

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
