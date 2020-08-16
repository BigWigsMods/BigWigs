if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Inerva Darkvein", 2296, 2420)
if not mod then return end
mod:RegisterEnableMob(165521) -- Lady Inerva Darkvein
mod.engageId = 2406
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local cognitionOnMe = nil
local bottleTimers = {28.5, 36, 20, 24, 26.8, 10.8, 14.9, 18.3, 17.4, 18.3, 28.5, 36.9, 36.5}
local bottleCount = 1
local anima = {}
local concentrateAnimaCount = 1
local mobCollector = {}
local conjuredManifestationList = {}
local conjuredManifestationCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.times = "%dx %s"

	L.level = "%s (Level |cffffff00%d|r)"
	L.full = "%s (|cffff0000FULL|r)"

	L.custom_off_experimental = "Enable experimental features"
	L.custom_off_experimental_desc = "These features are |cffff0000not tested|r and could |cffff0000spam|r."

	L.anima_tracking = "Anima Tracking |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Messages and Bars to track anima levels in the containers.|n|cffaaff00Tip: You might want to disable the information box or bars, depending your preference."
	L.anima_tracking_icon = "achievement_boss_darkanimus"

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Just for testing right now"

	L.bottles = "Bottles"
	L.sins = "Sins"
end

--------------------------------------------------------------------------------
-- Initialization
--

local sharedSufferingMarker = mod:AddMarkerOption(false, "player", 1, 324983, 1, 2, 3) -- Shared Suffering
local concentrateAnimaMarker = mod:AddMarkerOption(false, "player", 8, 332664, 8, 7, 6, 5) -- Concentrate Anima
local conjuredManifestationMarker = mod:AddMarkerOption(true, "npc", 8, -22618, 8, 7, 6, 5) -- Conjured Manifestation
function mod:GetOptions()
	return {
		"custom_off_experimental",
		{"anima_tracking", "INFOBOX"},
		"custom_on_stop_timers",
		331870, -- Focus Anima
		-- Container of Desire
		{341621, "TANK"}, -- Expose Desires
		325382, -- Warped Desires
		325936, -- Shared Cognition
		-- Container of Bottled Anima
		325769, -- Bottled Anima
		325713, -- Lingering Anima
		-- Container of Sin
		{324983, "SAY"}, -- Shared Suffering
		sharedSufferingMarker,
		-- Container of Concentrated Anima
		{332664, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Concentrate Anima
		concentrateAnimaMarker,
		conjuredManifestationMarker,
		{331573, "ME_ONLY"}, -- Unconscionable Guilt
		331550, -- Condemn
	}, {
		[331870] = "general",
		[325379] = -22571, -- Container of Desire
		[325769] = -22592, -- Container of Bottled Anima
		[324983] = -22599, -- Container of Sin
		[332664] = -22567, -- Container of Concentrated Anima
	},{
		[325769] = L.bottles, -- Bottled Anima (Bottles)
		[324983] = L.sins, -- Shared Suffering (Sins)
		[332664] = CL.adds, -- Concentrate Anima (Adds)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UPDATE_UI_WIDGET", "WIDGET") -- need to fix BossPrototype implementation before using mod:RegisterWidgetEvent
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")

	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Container of Desire
	self:Log("SPELL_CAST_START", "ExposeDesires", 341621)
	self:Log("SPELL_AURA_APPLIED", "WarpedDesiresApplied", 325382)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WarpedDesiresApplied", 325382)
	self:Log("SPELL_AURA_APPLIED", "SharedCognitionApplied", 325936)
	self:Log("SPELL_AURA_REMOVED", "SharedCognitionRemoved", 325936)

	-- Container of Bottled Anima
	--self:Log("SPELL_CAST_SUCCESS", "BottledAnima", 325769) -- see USCS

	-- Container of Sin
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:RegisterMessage("BigWigs_BossComm") -- Early Shared Suffering Warnings
	self:Log("SPELL_AURA_APPLIED", "SharedSufferingApplied", 324983)
	self:Log("SPELL_AURA_REMOVED", "SharedSufferingRemoved", 324983)

	-- Container of Concentrated Anima
	self:Log("SPELL_AURA_APPLIED", "ConcentrateAnimaApplied", 332664, 340477) -- Concentrated Anima, Highly Concentrated Anima
	self:Log("SPELL_AURA_REMOVED", "ConcentrateAnimaRemoved", 332664, 340477)
	self:Log("SPELL_AURA_APPLIED", "UnconscionableGuiltApplied", 331573)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnconscionableGuiltApplied", 331573)
	self:Log("SPELL_CAST_START", "Condemn", 331550)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 325713) -- Lingering Anima
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 325713)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 325713)
end

function mod:OnEngage()
	mobCollector = {}
	conjuredManifestationList = {}
	conjuredManifestationCount = 1
	cognitionOnMe = nil
	bottleCount = 1
	concentrateAnimaCount = 1
	wipe(anima)

	self:Bar(341621, 12) -- Expose Desires
	self:Bar(324983, 23, L.sins) -- Shared Suffering
	self:Bar(325769, bottleTimers[bottleCount], L.bottles) -- Bottled Anima
	self:Bar(332664, 56, CL.count:format(CL.adds, concentrateAnimaCount)) -- Concentrate Anima

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
		[332664] = true, -- Concentrate Anima
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
		SetRaidTarget(unit, conjuredManifestationList[guid])
		conjuredManifestationList[guid] = nil
	end
end

do

	local widgetIds = {
		[2380] = {pos = 1, name = "Desires", icon = 325379}, -- Expose Desires
		[2399] = {pos = 2, name = "Bottles", icon = 325769}, -- Bottled Anima
		[2400] = {pos = 3, name = "Sins", icon = 325064}, -- Sins and Suffering
		[2401] = {pos = 4, name = CL.add, icon = 332664}, -- Concentrate Anima
	}

	local getStatusBarInfo = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo

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

	function mod:WIDGET(tbl)
		if not self:GetOption("custom_off_experimental") then return end

		local spell = widgetIds[tbl.widgetID]
		if not spell then return end

		local info = getStatusBarInfo(tbl.widgetID)
		if not info or not info.barValue then return end

		local oldInfo = anima[spell.icon]

		local curLevel = math.floor(info.barValue / (info.barMax / 3)) + 1
		if not oldInfo then -- first time we're seeing it
			anima[spell.icon] = {value = info.barValue, level = curLevel, lastUpdate = GetTime()}
		else
			if curLevel ~= oldInfo.level then
				if curLevel > 3 then -- it's full
					self:Message2("anima_tracking", "cyan", L.full:format(spell.name), spell.icon)
					self:StopBar(L.full:format(spell.name))
				else
					self:Message2("anima_tracking", "cyan", L.level:format(spell.name, curLevel), spell.icon)
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

do
	local vialCount = 0

	local function printBottleMessage(self)
		self:Message2(325769, "orange", L.times:format(vialCount, L.bottles))
		vialCount = 0
	end

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		if spellId == 325774 then -- Bottled Anima
			vialCount = vialCount + 1 -- amount of vials thrown every time
			if vialCount == 1 then
				bottleCount = bottleCount + 1 -- amount of cast
				self:ScheduleTimer(printBottleMessage, 0.1, self)
				self:PlaySound(325769, "info")
				self:CDBar(325769, bottleTimers[bottleCount] or 20, L.bottles)
			end
		elseif spellId == 338750 then -- Enable Container
			self:Message2(331870, "cyan")
			self:PlaySound(331870, "long")
			self:Bar(331870, 100)
		end
	end
end

function mod:ExposeDesires(args)
	if self:Tank() or self:Healer() then --or cognitionOnMe then < fai
		self:Message2(args.spellId, "purple")
		self:PlaySound(args.spellId, "alert")
	end
	self:CDBar(args.spellId, 8.5)
end

function mod:WarpedDesiresApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, "alarm")
end

do
	local playerList = mod:NewTargetList()
	function mod:SharedCognitionApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:Bar(args.spellId, 10)
		end
		if self:Me(args.destGUID) then
			cognitionOnMe = true
			self:PlaySound(args.spellId, "alarm")
			self:TargetBar(args.spellId, 21, args.destName)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:SharedCognitionRemoved(args)
		if self:Me(args.destGUID) then
			cognitionOnMe = nil
			self:StopBar(args.spellId, args.destName)
		end
	end
end

function mod:BottledAnima(args)
	--self:Message2(args.spellId, "red", L.bottles)
	--self:PlaySound(args.spellId, "warning")
	--self:Bar(args.spellId, 25.5, L.bottles)
end

do
	local playerList, onMe = {}, nil
	local function addPlayerToList(self, name)
		if not tContains(playerList, name) then
			local count = #playerList+1
			playerList[count] = name
			self:TargetsMessage(324983, "yellow", self:ColorName(playerList), 3, L.sins, nil, 4)
			if self:GetOption(sharedSufferingMarker) then
				SetRaidTarget(name, count)
			end
			if count == 1 then
				self:Bar(324983, 26.8, L.sins)
			end
		end
	end

	function mod:RAID_BOSS_WHISPER(_, msg)
		if msg:find("325005", nil, true) then -- Shared Suffering
			onMe = true
			self:Say(324983, L.sins)
			self:PlaySound(324983, "warning")
			self:Sync("SharedSufferingTarget")
		end
	end

	function mod:BigWigs_BossComm(_, msg, _, name)
		if msg == "SharedSufferingTarget" then
			addPlayerToList(self, name)
		end
	end

	function mod:SharedSufferingApplied(args)
		addPlayerToList(self, args.destName)
		if self:Me(args.destGUID) and not onMe then
			onMe = true
			self:Say(324983, L.sins)
			self:PlaySound(324983, "warning")
		end
	end

	function mod:SharedSufferingRemoved(args)
		if self:Me(args.destGUID) then
			onMe = false
		end
		playerList = {}
		if self:GetOption(sharedSufferingMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

do
	local playerList, proxList, isOnMe, playerIcons = mod:NewTargetList(), {}, nil, {}
	function mod:ConcentrateAnimaApplied(args)
		local count = #playerList+1
		local icon = 9-count -- 8, 7, 6, 5
		proxList[count] = args.destName
		playerList[count] = args.destName
		playerIcons[count] = icon
		if #playerList == 1 then
			self:StopBar(CL.count:format(CL.adds, concentrateAnimaCount))
			concentrateAnimaCount = concentrateAnimaCount + 1
			self:Bar(332664, 36, CL.count:format(CL.adds, concentrateAnimaCount))
			conjuredManifestationList = {}
			conjuredManifestationCount = 1
		end
		if self:Me(args.destGUID) then
			isOnMe = true
			self:PlaySound(332664, "alarm")
			self:Say(332664, CL.count_rticon:format(args.spellName, icon, icon))
			self:SayCountdown(332664, 10)
			self:OpenProximity(332664, 8)
		end
		self:TargetsMessage(332664, "yellow", playerList, nil, nil, nil, nil, playerIcons)

		if self:GetOption(concentrateAnimaMarker) then
			SetRaidTarget(args.destName, icon)
		end
		if not isOnMe then
			self:OpenProximity(332664, 8, proxList)
		end
	end

	function mod:ConcentrateAnimaRemoved(args)
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

		if self:GetOption(concentrateAnimaMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:UnconscionableGuiltApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "yellow")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:Condemn(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
	if self:GetOption(conjuredManifestationMarker) and not mobCollector[args.sourceGUID] then
		mobCollector[args.sourceGUID] = true
		conjuredManifestationList[args.sourceGUID] = (8 - (conjuredManifestationCount % 4) + 1) -- 8, 7, 6, 5
		conjuredManifestationCount = conjuredManifestationCount + 1
		for k, v in pairs(conjuredManifestationList) do
			local unit = self:GetUnitIdByGUID(k)
			if unit then
				SetRaidTarget(unit, conjuredManifestationList[k])
				conjuredManifestationList[k] = nil
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
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
