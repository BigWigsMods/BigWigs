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
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local bossesKilled = 0
local stavrosAlive = true
local friedaAlive = true
local niklausAlive = true
local killOrder = nil
local dancingFeverCount = 1
local mobCollector = {}

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
	L.custom_off_select_boss_order_value2 = "Frieda -> Niklaus -> Stavros"
	L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frieda"
	L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frieda"
	L.custom_off_select_boss_order_value5 = "Frieda -> Stavros -> Niklaus"
	L.custom_off_select_boss_order_value6 = "Stavros -> Frieda -> Niklaus"

	L.dance_assist = "Dance Assist"
	L.dance_assist_desc = "Show directional warnings for the dancing stage."
	L.dance_assist_icon = "misc_arrowlup"
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Dance Forward |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Dance Right |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Dance Down |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Dance Left |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Forward" -- Prance Forward!
	L.dance_yell_right = "right" -- Shimmy right!
	L.dance_yell_down = "down" -- Boogie down!
	L.dance_yell_left = "left" -- Sashay left!
end

--------------------------------------------------------------------------------
-- Initialization
--

local dutifulAttendantMarker = mod:AddMarkerOption(false, "npc", 8, -22948, 8) -- Dutiful Attendant
local waltzingVenthyrMarker = mod:AddMarkerOption(false, "npc", 8, -22653, 8) -- Waltzing Venthyr
local afterImageMarker = mod:AddMarkerOption(false, "npc", 6, -22433, 6) -- Afterimage of Baroness Frieda
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
		{346651, "ME_ONLY"}, -- Drain Essence
		337110, -- Dreadbolt Volley
		346657, -- Prideful Eruption
		346945, -- Manifest Pain
		346681, -- Soul Spikes

		--[[ Lord Stavros ]]--
		327497, -- Evasive Lunge
		{331634, "SAY", "ME_ONLY_EMPHASIZE"}, -- Dark Recital
		"custom_on_repeating_dark_recital",
		346800, -- Waltz of Blood
		346303, -- Violent Uproar
		waltzingVenthyrMarker,

		--[[ Intermission: The Danse Macabre ]]--
		330959, -- Danse Macabre
		"dance_assist",
		{330848, "ME_ONLY"}, -- Wrong Moves

		--[[ Mythic ]]--
		-22433, -- Afterimage of Baroness Frieda
		afterImageMarker,
		{347350, "SAY", "SAY_COUNTDOWN"}, -- Dancing Fever
	},{
		["stages"] = "general",
		[346690] = -22147, -- Castellan Niklaus
		[346651] = -22148, -- Baroness Frieda
		[327497] = -22149, -- Lord Stavros
		[330959] = -22146, -- Intermission: The Danse Macabre
		[347350] = "mythic",
	},{
		[331634] = CL.link, -- Dark Recital (Link)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
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
	self:Log("SPELL_CAST_SUCCESS", "DrainEssence", 346654)
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
	self:Log("SPELL_CAST_SUCCESS", "DanseMacabreBegins", 347376) -- Dance Area Trigger // This is when the NPC's start running to the stage
	self:Log("SPELL_AURA_REMOVED", "DanseMacabreOver", 330959)
	self:Log("SPELL_AURA_APPLIED", "WrongMovesApplied", 330848)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "DancingFeverApplied", 347350)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 346945) -- Manifest Pain
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 346945)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 346945)
end

function mod:OnEngage()
	bossesKilled = 0
	friedaAlive = true
	stavrosAlive = true
	niklausAlive = true
	dancingFeverCount = 1
	mobCollector = {}
	self:SetStage(1)

	self:CDBar(346698, 7.5) -- Summon Dutiful Attendant
	self:CDBar(346690, 18.5) -- Duelist's Riposte

	self:CDBar(337110, 6) -- Dreadbolt Volley
	self:CDBar(346651, 15.5) -- Drain Essence

	self:CDBar(327497, 8.5) -- Evasive Lunge
	self:CDBar(331634, 24) -- Dark Recital

	if self:Mythic() then
		self:CDBar(347350, 5, CL.count:format(self:SpellName(347350), dancingFeverCount)) -- Dancing Fever
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT") -- Afterimage warnings
	end

	-- Mark kill order
	killOrder = self:GetOption("custom_off_select_boss_order")
	if killOrder == 1 or killOrder == 4 then -- Niklaus first
		local boss = self:GetUnitIdByGUID(166971) -- Castellan Niklaus
		if boss then
			self:CustomIcon(false, boss, 7)
		end
	elseif killOrder == 2 or killOrder == 5 then -- Frieda First
		local boss = self:GetUnitIdByGUID(166969) -- Baroness Frieda
		if boss then
			self:CustomIcon(false, boss, 7)
		end
	elseif killOrder == 3 or killOrder == 6 then -- Stavros First
		local boss = self:GetUnitIdByGUID(166970) -- Lord Stavros
		if boss then
			self:CustomIcon(false, boss, 7)
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	local unit, guid = self:GetBossId(172803) -- Afterimage of Baroness Frieda
	if guid and not mobCollector[guid] then
		mobCollector[guid] = true
		self:Message(-22433, "red", CL.spawned:format(self:SpellName(-22433)), false)
		self:PlaySound(-22433, "long")
		if self:GetOption(afterImageMarker) then
			self:CustomIcon(false, unit, 6)
		end
	end
end

function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find(L.macabre_start_emote, nil, true) then -- Dance Macabre start
		self:CastBar(330959, 7) -- Dance Macabre
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg, npcname)
	if msg:find(L.dance_yell_up, nil, true) then
		self:Message("dance_assist", "blue", L.dance_assist_up, false)
	elseif msg:find(L.dance_yell_right, nil, true) then
		self:Message("dance_assist", "blue", L.dance_assist_right, false)
	elseif msg:find(L.dance_yell_down, nil, true) then
		self:Message("dance_assist", "blue", L.dance_assist_down, false)
	elseif msg:find(L.dance_yell_left, nil, true) then
		self:Message("dance_assist", "blue", L.dance_assist_left, false)
	end
end

function mod:BossDeath(args)
	bossesKilled = bossesKilled + 1
	if bossesKilled > 2 then return end -- You win at 3
	self:SetStage(bossesKilled + 1)

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
		self:StopBar(346698) -- Summon Dutiful Attendant
		self:StopBar(330978) -- Dredger Servants
	end

	if self:Mythic() then
		if friedaAlive == false then
			self:CDBar(337110, 20) -- Start/Reset the initial Dreadbolt Volley Afterimage Spawn.
		end
		if stavrosAlive == false then
			self:CDBar(331634, 40) -- Start/Reset the initial Dark Recital Afterimage Spawn
		end
	end

	if bossesKilled == 1 then
		if friedaAlive then
			self:CDBar(346651, 9) -- Drain Essence
			self:CDBar(346657, 38) -- Prideful Eruption
		end
		if stavrosAlive then
			self:CDBar(327497, 10.9) -- Evasive Lunge
			self:CDBar(331634, 26.6) -- Dark Recital
			self:CDBar(346800, 33.8) -- Waltz of Blood
		end
		if niklausAlive then
			self:CDBar(330978, 8.1) -- Dredger Servants
			self:CDBar(346690, 12.3) -- Duelist's Riposte
			self:CDBar(346698, 42.3) -- Summon Dutiful Attendant
		end
		if killOrder == 2 or killOrder == 3 then -- Niklaus second
			local boss = self:GetUnitIdByGUID(166971) -- Castellan Niklaus
			if boss then
				self:CustomIcon(false, boss, 7)
			end
		elseif killOrder == 1 or killOrder == 6 then -- Frieda second
			local boss = self:GetUnitIdByGUID(166969) -- Baroness Frieda
			if boss then
				self:CustomIcon(false, boss, 7)
			end
		elseif killOrder == 4 or killOrder == 5 then -- Stavros second
			local boss = self:GetUnitIdByGUID(166970) -- Lord Stavros
			if boss then
				self:CustomIcon(false, boss, 7)
			end
		end
	elseif bossesKilled == 2 then
		if friedaAlive then
			self:CDBar(346651, 9) -- Drain Essence
			self:CDBar(346657, 24) -- Prideful Eruption
			self:CDBar(346681, 35.2) -- Soul Spikes
		end
		if stavrosAlive then
			self:CDBar(331634, 9.4) -- Dark Recital
			self:CDBar(327497, 15.2) -- Evasive Lunge
			self:CDBar(346303, 29.8) -- Violent Uproar
			self:CDBar(346800, 65.2) -- Waltz of Blood
		end
		if niklausAlive then
			self:CDBar(346690, 12.3) -- Duelist's Riposte
			self:CDBar(330965, 16.6) -- Castellan's Cadre
			self:CDBar(346698, 25.2) -- Summon Dutiful Attendant
			self:CDBar(330978, 43.7) -- Dredger Servants
		end
		if killOrder == 5 or killOrder == 6 then -- Niklaus last
			local boss = self:GetUnitIdByGUID(166971) -- Castellan Niklaus
			if boss then
				self:CustomIcon(false, boss, 7)
			end
		elseif killOrder == 3 or killOrder == 4 then -- Frieda last
			local boss = self:GetUnitIdByGUID(166969) -- Baroness Frieda
			if boss then
				self:CustomIcon(false, boss, 7)
			end
		elseif killOrder == 1 or killOrder == 2 then -- Stavros last
			local boss = self:GetUnitIdByGUID(166970) -- Lord Stavros
			if boss then
				self:CustomIcon(false, boss, 7)
			end
		end
	end
end

--[[ Castellan Niklaus ]]--
function mod:DuelistsRiposte(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	local cd = self:Mythic() and 7.5 or 8.5
	if stavrosAlive then -- 2 tank bosses alive, longer CD
		if self:Mythic() then
			cd = bossesKilled == 0 and 18.7 or 15
		else
			cd = bossesKilled == 0 and 21.5 or 17
		end
	end
	self:CDBar(args.spellId, cd)
end

function mod:DuelistsRiposteApplied(args)
	self:NewStackMessage(args.spellId, "purple", args.destName, args.amount, 2)
end

do
	function mod:DutifulAttendantMarking(event, unit, guid)
		if self:MobId(guid) == 175992 then -- Dutiful Attendant
			self:CustomIcon(dutifulAttendantMarker, unit, 8)
			self:UnregisterTargetEvents()
		end
	end

	function mod:SummonDutifulAttendant(args)
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
		self:CDBar(args.spellId, self:Mythic() and (bossesKilled == 2 and 22.5 or 45) or bossesKilled == 2 and 25.5 or 51.5)
		if self:GetOption(dutifulAttendantMarker) then
			self:RegisterTargetEvents("DutifulAttendantMarking")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
	end
end

function mod:DredgerServants(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, self:Mythic() and 45 or 51)
end

function mod:CastellansCadre(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, self:Mythic() and 45 or 51.5)
end

function mod:SintouchedBlade(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 5)
end

--[[ Baroness Frieda ]]--
do
	local playerList = {}
	function mod:DrainEssence()
		playerList = {}
		self:CDBar(346651, self:Mythic() and 22.5 or bossesKilled == 1 and 20 or bossesKilled == 2 and 45 or 25)
	end

	function mod:DrainEssenceApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, 3)
	end
end

do
	local prev = 0
	function mod:DreadboltVolley(args)
		if not friedaAlive and self:Mythic() then -- Afterimage stuff
			local _, ready = self:Interrupter() -- warn regardless of target/focus
			if ready then
				self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
				self:PlaySound(args.spellId, "alarm")
			end
			local t = args.time
			if t-prev > 15 then -- 3 casts, 3s~ between, only start bar for the first in the set
				prev = t
				self:CDBar(args.spellId, 45)
			end
		else -- Actual Frieda
			local canDo, ready = self:Interrupter(args.sourceGUID)
			if canDo then
				self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
				if ready then
					self:PlaySound(args.spellId, "alarm")
				end
			end
			self:CDBar(args.spellId, 5.3) -- Spell Lockout?
		end
	end
end

function mod:PridefulEruption(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, (bossesKilled == 1 and 120 or bossesKilled == 2 and 41.5)) -- Cooldown with 1 boss killed unconfirmed

end

function mod:SoulSpikes(args)
	self:Message(346681, "orange", CL.casting:format(args.spellName))
	self:PlaySound(346681, "alert")
	self:CDBar(346681, 41.5)
end

function mod:SoulSpikesApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "orange", args.destName, amount)
	self:PlaySound(args.spellId, "info")
end

--[[ Lord Stavros ]]--
function mod:EvasiveLunge(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	local cd = self:Mythic() and 7.5 or 11
	if niklausAlive	then -- 2 tank bosses alive, longer CD
		if self:Mythic() then
			cd = bossesKilled == 0 and 18.7 or 15
		else
			cd = bossesKilled == 0 and 21.5 or 17
		end
	end
	self:CDBar(args.spellId, cd)
end

function mod:EvasiveLungeApplied(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and not self:Tank() then
		self:NewStackMessage(327497, "blue", args.destName, amount)
		self:PlaySound(327497, "alarm")
	elseif self:Tank() and self:Tank(args.destName) then
		self:NewStackMessage(327497, "purple", args.destName, amount, 2)
	end
end

do
	local firstDarkRecitalTargetGUID, lastDarkRecitalName, darkrecitalPairCount = nil, nil, 0
	local darkRecitalFallbackTimer, sayTimer = nil, nil

	function mod:DarkRecital(args)
		self:Message(args.spellId, "orange")
		firstDarkRecitalTargetGUID = nil
		darkrecitalPairCount = 0
		if stavrosAlive == false then
			self:Bar(args.spellId, bossesKilled == 1 and 60 or 37.7)
		else
			self:Bar(args.spellId, self:Mythic() and (bossesKilled == 0 and 45 or bossesKilled == 1 and 60 or 22.9) or bossesKilled == 0 and 51.5 or bossesKilled == 1 and 69.5 or 22.9)
		end
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
				darkRecitalFallbackTimer = self:ScheduleTimer("PersonalMessage", 0.1, 331634, false, CL.link_with:format("|cffff0000???"))
			end
		elseif args.spellId == 331637 and firstDarkRecitalTargetGUID then -- 2nd Dark Recital Target
			if self:Me(args.destGUID) then -- We got 2nd debuff, so print last name
				self:PersonalMessage(331634, false, CL.link_with_icon:format(darkrecitalPairCount, self:ColorName(lastDarkRecitalName)))
				local icon = ("{rt%d}"):format(darkrecitalPairCount)
				self:Yell(331634, icon, true)
				if self:GetOption("custom_on_repeating_dark_recital") then
					sayTimer = self:ScheduleRepeatingTimer("Yell", 1.5, false, icon, true)
				end
			elseif self:Me(firstDarkRecitalTargetGUID) then -- We got 1st debuff so this is our partner
				self:PersonalMessage(331634, false, CL.link_with_icon:format(darkrecitalPairCount, self:ColorName(args.destName)))
				local icon = ("{rt%d}"):format(darkrecitalPairCount)
				self:Yell(331634, icon, true)
				if self:GetOption("custom_on_repeating_dark_recital") then
					sayTimer = self:ScheduleRepeatingTimer("Yell", 1.5, false, icon, true)
				end
			end
			firstDarkRecitalTargetGUID = nil
			if darkRecitalFallbackTimer then -- We printed above, so cancel this
				self:CancelTimer(darkRecitalFallbackTimer)
				darkRecitalFallbackTimer = nil
			end
		else -- Missing a partner, alternative message
			if self:Me(args.destGUID) or self:Me(firstDarkRecitalTargetGUID) then
				self:PersonalMessage(331634, false, CL.link_with:format("|cffff00ff???"))
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
			self:CustomIcon(waltzingVenthyrMarker, unit, 8)
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
			self:Bar(args.spellId, 60)
			if self:GetOption(waltzingVenthyrMarker) then
				self:RegisterTargetEvents("WaltzingVenthyrMarking")
				self:ScheduleTimer("UnregisterTargetEvents", 5)
			end
		end
	end
end

--[[ Intermission: The Danse Macabre ]]--
function mod:DanseMacabreBegins(args)
	self:Message(330959, "green") -- Dance Macabre
	self:PlaySound(330959, "long")

	self:PauseBar(346651) -- Drain Essence
	self:PauseBar(337110) -- Dreadbolt Volley
	self:PauseBar(346657) -- Prideful Eruption
	self:PauseBar(346681) -- Soul Spikes
	self:PauseBar(327497) -- Evasive Lunge
	self:PauseBar(331634) -- Dark Recital
	self:PauseBar(346800) -- Waltz of Blood
	self:PauseBar(346690) -- Duelist's Riposte
	self:PauseBar(346698) -- Summon Dutiful Attendant
	self:PauseBar(330978) -- Dredger Servants
	self:PauseBar(330965) -- Castellans Cadre
	self:PauseBar(346303) -- Violent Uproar
	self:PauseBar(347350, CL.count:format(self:SpellName(347350), dancingFeverCount)) -- Dancing Fever
end

function mod:DanseMacabreOver(args)
	self:ResumeBar(346651) -- Drain Essence
	self:ResumeBar(337110) -- Dreadbolt Volley
	self:ResumeBar(346657) -- Prideful Eruption
	self:ResumeBar(346681) -- Soul Spikes
	self:ResumeBar(327497) -- Evasive Lunge
	self:ResumeBar(331634) -- Dark Recital
	self:ResumeBar(346800) -- Waltz of Blood
	self:ResumeBar(346690) -- Duelist's Riposte
	self:ResumeBar(346698) -- Summon Dutiful Attendant
	self:ResumeBar(330978) -- Dredger Servants
	self:ResumeBar(330965) -- Castellans Cadre
	self:ResumeBar(346303) -- Violent Uproar
	self:ResumeBar(347350, CL.count:format(self:SpellName(347350), dancingFeverCount)) -- Dancing Fever
end

function mod:WrongMovesApplied(args)
	self:TargetMessage(args.spellId, "orange", args.destName) -- ME_ONLY is enabled, but players can get all fails if they would like too
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "info")
	end
end

--[[ Mythic ]]--
do
	local playerList = {}
	local prev = 0
	function mod:DancingFeverApplied(args)
		local t = args.time
		if t-prev > 3 then
			prev = t
			playerList = {}
			dancingFeverCount = dancingFeverCount + 1
			self:CDBar(args.spellId, 60, CL.count:format(args.spellName, dancingFeverCount))
		end

		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, 5, CL.count:format(args.spellName, dancingFeverCount-1))
	end
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
