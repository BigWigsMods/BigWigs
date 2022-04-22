--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Inerva Darkvein", 2296, 2420)
if not mod then return end
mod:RegisterEnableMob(165521) -- Lady Inerva Darkvein
mod:SetEncounterID(2406)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local anima = {}
local concentratedAnimaCount = 1
local conjuredManifestationList = {}
local mobCollector = {}
local conjuredManifestationCount = 1
local enabledContainer = 0 -- 1: Desires, 2: Bottles, 3: Sins, 4: Adds

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.times = "%dx %s"

	L.level = "%s (Level |cffffff00%d|r)"
	L.full = "%s (|cffff0000FULL|r)"

	L.anima_adds = "Concentrated Anima Adds"
	L.anima_adds_desc = "Show a timer for when adds spawn from the Concentrated Anima debuffs."

	L.custom_off_experimental = "Enable experimental features"
	L.custom_off_experimental_desc = "These features are |cffff0000not tested|r and could |cffff0000spam|r."

	L.anima_tracking = "Anima Tracking |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Messages and Bars to track anima levels in the containers.|n|cffaaff00Tip: You might want to disable the information box or bars, depending your preference."
	L.anima_tracking_icon = "achievement_boss_darkanimus"

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Just for testing right now"

	L.desires = "Desires"
	L.bottles = "Bottles"
	L.sins = "Sins"
end

--------------------------------------------------------------------------------
-- Initialization
--

local sharedSufferingMarker = mod:AddMarkerOption(false, "player", 1, 324983, 1, 2, 3) -- Shared Suffering
local concentratedAnimaMarker = mod:AddMarkerOption(false, "player", 8, 332664, 8, 7, 6) -- Concentrated Anima
local conjuredManifestationMarker = mod:AddMarkerOption(true, "npc", 8, -22618, 8, 7) -- Conjured Manifestation
function mod:GetOptions()
	return {
		"custom_off_experimental",
		{"anima_tracking", "INFOBOX"},
		"custom_on_stop_timers",
		331870, -- Focus Anima
		-- Container of Desire
		{341621, "TANK_HEALER"}, -- Expose Desires
		{325382, "TANK"}, -- Warped Desires
		{340452, "SAY", "SAY_COUNTDOWN", "ME_ONLY", "ME_ONLY_EMPHASIZE"}, -- Change of Heart
		325936, -- Shared Cognition
		-- Container of Bottled Anima
		325769, -- Bottled Anima
		325713, -- Lingering Anima
		-- Container of Sin
		{324983, "SAY", "ME_ONLY_EMPHASIZE"}, -- Shared Suffering
		sharedSufferingMarker,
		-- Container of Concentrated Anima
		{332664, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Concentrated Anima
		"anima_adds",
		concentratedAnimaMarker,
		conjuredManifestationMarker,
		{331573, "ME_ONLY"}, -- Unconscionable Guilt
		331550, -- Condemn
	},{
		[331870] = "general",
		[325379] = -22571, -- Container of Desire
		[325769] = -22592, -- Container of Bottled Anima
		[324983] = -22599, -- Container of Sin
		[332664] = -22567, -- Container of Concentrated Anima
	},{
		[340452] = CL.bomb, -- Change of Heart (Bomb)
		[341621] = L.desires, -- Expose Desires (Desires)
		[325769] = L.bottles, -- Bottled Anima (Bottles)
		[324983] = L.sins, -- Shared Suffering (Sins)
		[332664] = CL.adds, -- Concentrated Anima (Adds)
	}
end

function mod:OnBossEnable()
	self:RegisterWidgetEvent(2380, "AnimaWidget") -- Expose Desires
	self:RegisterWidgetEvent(2399, "AnimaWidget") -- Bottled Anima
	self:RegisterWidgetEvent(2400, "AnimaWidget") -- Sins and Suffering
	self:RegisterWidgetEvent(2401, "AnimaWidget") -- Concentrated Anima
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")

	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Container of Desire
	self:Log("SPELL_CAST_START", "ExposeDesires", 341621, 341623, 341625) -- Expose Desires, Expose Cognition, Expose Heart // Each stage of the empowerment.
	self:Log("SPELL_AURA_APPLIED", "WarpedDesiresApplied", 325382)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WarpedDesiresApplied", 325382)
	self:Log("SPELL_AURA_APPLIED", "SharedCognitionApplied", 325936)
	self:Log("SPELL_AURA_REMOVED", "SharedCognitionRemoved", 325936)
	self:Log("SPELL_AURA_APPLIED", "ChangeOfHeartApplied", 340452)
	self:Log("SPELL_AURA_REMOVED", "ChangeOfHeartRemoved", 340452)

	-- Container of Bottled Anima
	self:Log("SPELL_CAST_START", "BottledAnima", 342280, 342281, 342282) -- Bottled Anima, Lingering Anima, Replicating Anima

	-- Container of Sin
	self:Log("SPELL_AURA_APPLIED", "SharedSufferingPreDebuffApplied", 355553) -- Shared Suffering Pre-Debuff
	self:Log("SPELL_AURA_REMOVED", "SharedSufferingRemoved", 324983) -- Shared Suffering Normal Debuff

	-- Container of Concentrated Anima
	self:Log("SPELL_CAST_START", "ConcentratedAnima", 342320, 342321) -- Lightly Concentrated Anima, Concentrated Anima
	self:Log("SPELL_AURA_APPLIED", "ConcentratedAnimaApplied", 332664, 340477) -- Concentrated Anima, Highly Concentrated Anima
	self:Log("SPELL_AURA_REMOVED", "ConcentratedAnimaRemoved", 332664, 340477)
	self:Log("SPELL_AURA_APPLIED", "UnconscionableGuiltApplied", 331573)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnconscionableGuiltApplied", 331573)
	self:Log("SPELL_CAST_START", "Condemn", 331550)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 325713) -- Lingering Anima
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 325713)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 325713)
end

function mod:OnEngage()
	conjuredManifestationList = {}
	mobCollector = {}
	conjuredManifestationCount = 1
	concentratedAnimaCount = 1
	enabledContainer = 0
	anima = {}

	self:Bar(341621, 12, L.desires) -- Expose Desires
	self:Bar(324983, 23, L.sins) -- Shared Suffering
	self:Bar(325769, 33, L.bottles) -- Bottled Anima
	self:Bar(332664, self:Mythic() and 44 or 54, CL.count:format(CL.adds, concentratedAnimaCount)) -- Concentrated Anima

	if self:GetOption("custom_off_experimental") then
		self:OpenInfo("anima_tracking", L.anima_tracking)
	end

	if self:GetOption(conjuredManifestationMarker) then
		self:RegisterTargetEvents("ConjuredManifestationMarker")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local abilitysToPause = {
		[325064] = true, -- Sins and Suffering
		[324983] = true, -- Shared Suffering
		[325769] = true, -- Bottled Anima
		[332664] = true, -- Concentrated Anima
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

function mod:ConjuredManifestationMarker(event, unit, guid)
	if self:MobId(guid) == 170197 and conjuredManifestationList[guid] then -- Conjured Manifestation
		self:CustomIcon(conjuredManifestationMarker, unit, conjuredManifestationList[guid])
	end
end

do
	local widgetIds = {
		[2380] = {pos = 1, name = "Desires", icon = 325379}, -- Expose Desires
		[2399] = {pos = 2, name = "Bottles", icon = 325769}, -- Bottled Anima
		[2400] = {pos = 3, name = "Sins", icon = 325064}, -- Sins and Suffering
		[2401] = {pos = 4, name = CL.add, icon = 332664}, -- Concentrated Anima
	}

	function mod:UpdateAnimaInfoBox(pos, text, time)
		self:SetInfo("anima_tracking", pos*2-1, text)
		if time > 60 then
			self:SetInfo("anima_tracking", pos*2, ("%d:%02d"):format(time/60, time%60))
		elseif time > 0 then
			self:SetInfo("anima_tracking", pos*2, ("%d"):format(time))
		else
			self:SetInfo("anima_tracking", pos*2, "")
		end
	end

	local soundPrev = 0

	function mod:AnimaWidget(id, _, info)
		if not self:GetOption("custom_off_experimental") then return end

		if not info.barValue then return end

		local spell = widgetIds[id]
		local oldInfo = anima[spell.icon]

		local curLevel = math.floor(info.barValue / (info.barMax / 3)) + 1
		if not oldInfo then -- first time we're seeing it
			anima[spell.icon] = {value = info.barValue, level = curLevel, lastUpdate = GetTime()}
		else
			if curLevel ~= oldInfo.level then
				if curLevel > 3 then -- it's full
					self:Message("anima_tracking", "cyan", L.full:format(spell.name), spell.icon)
					self:StopBar(L.full:format(spell.name))
				else
					self:Message("anima_tracking", "cyan", L.level:format(spell.name, curLevel), spell.icon)
					self:StopBar(L.level:format(spell.name, oldInfo.level))
				end
				local t = GetTime()

				if t-soundPrev > 10 then -- high threshold in case something is really wrong
					soundPrev = t
					self:PlaySound("anima_tracking", "info")
				end
			end

			local timeDiff = (GetTime() - oldInfo.lastUpdate)
			local gain = (info.barValue - oldInfo.value) / timeDiff
			if gain > 0 then
				local nextLevelAtAnima = (info.barMax / 3) * curLevel
				local animaToNext = nextLevelAtAnima - info.barValue
				local t = math.ceil(animaToNext / gain)
				if animaToNext > 0 then -- safety
					local text = curLevel > 2 and L.full:format(spell.name) or L.level:format(spell.name, curLevel + 1)

					if math.abs(t - self:BarTimeLeft(text)) > 1 then -- avoid restarting the bar on small differences
						self:Bar("anima_tracking", t, text, spell.icon)
					end
					self:UpdateAnimaInfoBox(spell.pos, text, animaToNext / gain)
				end
			elseif gain < 0 then
				self:StopBar(L.level:format(spell.name, 2)) -- Stopping all for now, just in case
				self:StopBar(L.level:format(spell.name, 3))
				self:StopBar(L.full:format(spell.name))
				self:UpdateAnimaInfoBox(spell.pos, "", 0)
			end

			anima[spell.icon].value = info.barValue
			anima[spell.icon].level = curLevel
			anima[spell.icon].lastUpdate = GetTime()
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 331844 then -- Focus Anima: Desires
		self:Message(331870, "cyan", CL.other:format(self:SpellName(331870), L.desires))
		self:PlaySound(331870, "long")
		enabledContainer = 1
		self:Bar(331870, 97, CL.other:format(self:SpellName(331870), L.bottles)) -- She picks the next one 3s early, hidden cast?
	elseif spellId == 331870 then -- Focus Anima: Bottles
		self:StopBar(CL.other:format(self:SpellName(331870), L.bottles))
		self:Message(331870, "cyan", CL.other:format(self:SpellName(331870), L.bottles))
		self:PlaySound(331870, "long")
		enabledContainer = 2
		self:Bar(331870, 97, CL.other:format(self:SpellName(331870), L.sins))
	elseif spellId == 331872 then -- Focus Anima: Sins
		self:StopBar(CL.other:format(self:SpellName(331870), L.sins))
		self:Message(331870, "cyan", CL.other:format(self:SpellName(331870), L.sins))
		self:PlaySound(331870, "long")
		enabledContainer = 3
		self:Bar(331870, 97, CL.other:format(self:SpellName(331870), CL.adds))
	elseif spellId == 331873 then -- Focus Anima: Adds
		self:StopBar(CL.other:format(self:SpellName(331870), CL.adds))
		self:Message(331870, "cyan", CL.other:format(self:SpellName(331870), CL.adds))
		self:PlaySound(331870, "long")
		enabledContainer = 4
	end
end

function mod:ExposeDesires(args)
	self:Message(341621, "purple", CL.casting:format(args.spellName))
	self:Bar(341621, enabledContainer == 1 and 9.7 or 12.9, L.desires)
	if self:Tanking("boss1") or self:Healer() then
		self:PlaySound(341621, "alert")
	end
end

function mod:WarpedDesiresApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount, 2)
	if amount > 1 and not self:Tanking("boss1") then
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:SharedCognitionApplied(args)
		local t = args.time
		if t-prev > 3 then
			prev = t
			playerList = {}
		end

		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
			self:TargetBar(args.spellId, 21, args.destName)
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:SharedCognitionRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(args.spellId, args.destName)
		end
	end
end

function mod:ChangeOfHeartApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.bomb)
		self:SayCountdown(args.spellId, 4)
		self:PlaySound(args.spellId, "warning")
	end
	self:TargetBar(args.spellId, 4, args.destName, CL.bomb)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.bomb)
end

function mod:ChangeOfHeartRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(args.spellId, args.destName)
end

function mod:BottledAnima(args)
	self:Message(325769, "orange", L.bottles)
	self:PlaySound(325769, "info")
	self:Bar(325769, enabledContainer == 2 and (self:Mythic() and 15 or 30) or (self:Mythic() and 30 or 45), L.bottles)
end

do
	local playerList, prev = {}, 0
	function mod:SharedSufferingPreDebuffApplied(args)
		local t = args.time
		if t-prev > 3 then
			prev = t
			playerList = {}
		end

		if self:Me(args.destGUID) then
			self:Say(324983, L.sins)
			self:PlaySound(324983, "warning")
		end

		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		self:NewTargetsMessage(324983, "yellow", playerList, 3, L.sins)
		self:CustomIcon(sharedSufferingMarker, args.destName, count)
		if count == 1 then
			self:Bar(324983, enabledContainer == 3 and (self:Mythic() and 30 or 35) or 51, L.sins)
		end
	end

	function mod:SharedSufferingRemoved(args)
		self:CustomIcon(sharedSufferingMarker, args.destName)
	end
end

do
	local playerList, proxList = {}, {}
	function mod:ConcentratedAnima()
		playerList, proxList = {}, {}
		conjuredManifestationList = {}
		conjuredManifestationCount = 1
		self:StopBar(CL.count:format(CL.adds, concentratedAnimaCount))
		concentratedAnimaCount = concentratedAnimaCount + 1
		self:CDBar(332664, enabledContainer == 4 and (self:Mythic() and 43 or 51) or (self:Mythic() and 65 or 60), CL.count:format(CL.adds, concentratedAnimaCount))
	end

	local isOnMe = false
	function mod:ConcentratedAnimaApplied(args)
		local count = #playerList+1
		local icon = 9-count -- 8, 7, 6
		proxList[count] = args.destName
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if #playerList == 1 then
			self:Bar("anima_adds", 10, CL.spawning:format(CL.adds), 332664) -- Adds Spawning
		end
		if self:Me(args.destGUID) then
			isOnMe = true
			self:PlaySound(332664, "alarm")
			self:Say(332664, CL.rticon:format(args.spellId == 340477 and CL.big_add or CL.small_add, icon))
			self:SayCountdown(332664, 10, icon)
			self:OpenProximity(332664, 8)
		end
		self:NewTargetsMessage(332664, "yellow", playerList, CL.adds)

		self:CustomIcon(concentratedAnimaMarker, args.destName, icon)
		if not isOnMe then
			self:OpenProximity(332664, 8, proxList)
		end
	end

	function mod:ConcentratedAnimaRemoved(args)
		tDeleteItem(proxList, args.destName)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:CancelSayCountdown(332664)
			self:CloseProximity(332664)
		end

		if not isOnMe then
			if #proxList == 0 then
				self:CloseProximity(332664)
			else
				self:OpenProximity(332664, 8, proxList)
			end
		end

		self:CustomIcon(concentratedAnimaMarker, args.destName)
	end
end

function mod:UnconscionableGuiltApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "yellow", args.destName, amount)
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:Condemn(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
	if self:GetOption(conjuredManifestationMarker) and not mobCollector[args.sourceGUID] and not conjuredManifestationList[args.sourceGUID] then
		mobCollector[args.sourceGUID] = true
		conjuredManifestationList[args.sourceGUID] = 9-conjuredManifestationCount -- 8, 7 (max 2 adds per wave)
		conjuredManifestationCount = conjuredManifestationCount + 1
		for k, v in next, conjuredManifestationList do
			local unit = self:GetUnitIdByGUID(k)
			if unit then
				self:CustomIcon(conjuredManifestationMarker, unit, v)
			end
		end
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
