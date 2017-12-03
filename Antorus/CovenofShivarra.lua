
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Coven of Shivarra", nil, 1986, 1712)
if not mod then return end
mod:RegisterEnableMob(122468, 122467, 122469, 125436) -- Noura, Asara, Diima, Thu'raya
mod.engageId = 2073
mod.respawnTime = 25

--------------------------------------------------------------------------------
-- Locals
--

local infoboxScheduled = nil
local chilledBloodTime = 0
local chilledBloodList = {}
local chilledBloodMaxAbsorb = 1
local tormentIcons = {
	["AmanThul"] = 139, -- Renew
	["Norgannon"] = 245910, -- Army
	["Khazgoroth"] = 245671, -- Flames
	["Golganneth"] = 421, -- Chain Lightning
}
local upcomingTorments = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.torment_of_the_titans = mod:SpellName(-16138) -- Torment of the Titans
	L.torment_of_the_titans_desc = "The Shivvara will force the titan souls to use their abilities against the players."
	L.torment_of_the_titans_icon = 245910 -- Spectral Army of Norgannon

	L.timeLeft = "%.1fs"
	L.torment = "Torment: %s"
	L.nextTorment = "Next Torment: |cffffffff%s|r"
	L.nextTorments = "Next Torments:"
	L.tormentHeal = "Heal/DoT"
	L.tormentLightning = "Lightning" -- short for Chain Lightning
	L.tormentArmy = "Army"
	L.tormentFlames = "Flames"
end

--------------------------------------------------------------------------------
-- Initialization
--

local cosmicGlareMarker = mod:AddMarkerOption(false, "player", 3, 250912, 3,4)
function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		"berserk",
		"infobox",
		253203, -- Shivan Pact
		"torment_of_the_titans",

		--[[ Noura, Mother of Flame ]]--
		{244899, "TANK"}, -- Fiery Strike
		245627, -- Whirling Saber
		{253429, "SAY"}, -- Fulminating Pulse

		--[[ Asara, Mother of Night ]]--
		246329, -- Shadow Blades
		252861, -- Storm of Darkness

		--[[ Diima, Mother of Gloom ]]--
		{245518, "TANK_HEALER"}, -- Flashfreeze
		{245586, "INFOBOX"}, -- Chilled Blood
		253650, -- Orb of Frost

		--[[ Thu'raya, Mother of the Cosmos (Mythic) ]]--
		250648, -- Touch of the Cosmos
		{250757, "SAY", "FLASH"}, -- Cosmic Glare
		cosmicGlareMarker,
	},{
		["stages"] = "general",
		[244899] = -15967, -- Noura, Mother of Flame
		[246329] = -15968, -- Asara, Mother of Night
		[245518] = -15969, -- Diima, Mother of Gloom
		[250648] = -16398, -- Thu'raya, Mother of the Cosmos
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", nil, "boss1", "boss2", "boss3", "boss4")
	self:Log("SPELL_AURA_APPLIED", "ShivanPact", 253203)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")
	self:Log("SPELL_CAST_SUCCESS", "TormentofAmanThul", 250335)
	self:Log("SPELL_CAST_SUCCESS", "TormentofKhazgoroth", 250333)
	self:Log("SPELL_CAST_SUCCESS", "TormentofGolganneth", 249793)
	self:Log("SPELL_CAST_SUCCESS", "TormentofNorgannon", 250334)

	--[[ Noura, Mother of Flame ]]--
	self:Log("SPELL_AURA_APPLIED", "FieryStrike", 244899)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FieryStrike", 244899)
	self:Log("SPELL_CAST_SUCCESS", "FieryStrikeSuccess", 244899)
	self:Log("SPELL_CAST_START", "WhirlingSaber", 245627)
	self:Log("SPELL_AURA_APPLIED", "FulminatingPulse", 253429)
	self:Log("SPELL_AURA_REMOVED", "FulminatingPulseRemoved", 253429)

	--[[ Asara, Mother of Night ]]--
	self:Log("SPELL_CAST_SUCCESS", "ShadowBlades", 246329)
	self:Log("SPELL_CAST_START", "StormofDarkness", 252861)

	--[[ Diima, Mother of Gloom ]]--
	self:Log("SPELL_CAST_SUCCESS", "FlashfreezeSuccess", 245518)
	self:Log("SPELL_AURA_APPLIED", "Flashfreeze", 245518)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Flashfreeze", 245518)
	self:Log("SPELL_AURA_APPLIED", "ChilledBlood", 245586)
	self:Log("SPELL_AURA_REMOVED", "ChilledBloodRemoved", 245586)
	self:Log("SPELL_CAST_START", "OrbofFrost", 253650)

	--[[ Thu'raya, Mother of the Cosmos (Mythic) ]]--
	self:Log("SPELL_CAST_START", "TouchoftheCosmos", 250648)
	self:Log("SPELL_AURA_APPLIED", "CosmicGlare", 250757)
	self:Log("SPELL_AURA_REMOVED", "CosmicGlareRemoved", 250757)

	--[[ Ground effects ]]--
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 245634, 253020) -- Whirling Saber, Storm of Darkness
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 245634, 253020)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 245634, 253020)
	self:Log("SPELL_DAMAGE", "GroundEffectDamage", 245629) -- Whirling Saber (Impact)
	self:Log("SPELL_MISSED", "GroundEffectDamage", 245629)
end

function mod:OnEngage()
	infoboxScheduled = nil
	chilledBloodTime = 0
	wipe(chilledBloodList)
	chilledBloodMaxAbsorb = 1
	wipe(upcomingTorments)

	self:Bar(245627, 8.5) -- Whirling Saber
	self:Bar(244899, 12.1) -- Fiery Strike
	if not self:Easy() then
		self:Bar(253429, 20.6) -- Fulminating Pulse
	end

	self:Bar(246329, 12.1) -- Shadow Blades
	if not self:Easy() then
		self:Bar(252861, 27.9) -- Storm of Darkness
	end

	self:CDBar("torment_of_the_titans", 82, L.torment_of_the_titans, L.torment_of_the_titans_icon)
	self:CDBar("stages", 190, self:SpellName(-15969), "achievement_boss_argus_shivan") -- Diima, Mother of Gloom

	self:Berserk(720)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local updateInfoBox
do
	local debuffName = mod:SpellName(245586) -- Chilled Blood
	local tormentMarkup = {
		["AmanThul"] = {color = "|cff81c784", text = L.tormentHeal},
		["Norgannon"] = {color = "|cff9575cd", text = L.tormentArmy},
		["Khazgoroth"] = {color = "|cffe57373", text = L.tormentFlames},
		["Golganneth"] = {color = "|cff4fc3f7", text = L.tormentLightning},
	}
	for n, id in pairs(tormentIcons) do
		local _, _, icon = GetSpellInfo(id)
		tormentMarkup[n].icon = icon
	end

	function updateInfoBox(self)
		if infoboxScheduled then
			self:CancelTimer(infoboxScheduled)
			infoboxScheduled = nil
		end

		local showTorments = next(upcomingTorments)
		local showChilledBlood = self:CheckOption(245586, "INFOBOX")
		local bloodOffset = 0

		-- Torment
		if showTorments then
			self:OpenInfo("infobox", L.nextTorments)

			local pos = 0
			for i,v in pairs(upcomingTorments) do
				pos = pos + 1
				local data = ("|T%s:15:15:0:0:64:64:4:60:4:60|t%s%s|r"):format(tormentMarkup[v].icon, tormentMarkup[v].color, tormentMarkup[v].text)
				self:SetInfo("infobox", pos, data)
			end
			bloodOffset = math.ceil(pos/2)*2
		end

		-- Chilled Blood
		if showChilledBlood then
			local playerTable, totalAbsorb = {}, 0
			for name,_ in pairs(chilledBloodList) do
				local debuff, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, value = UnitDebuff(name, debuffName)
				if debuff and value and value > 0 then
					playerTable[#playerTable+1] = {name = name, value = value}
					totalAbsorb = totalAbsorb + value
				end
			end

			local timeLeft = chilledBloodTime + 10 - GetTime()

			if #playerTable > 0 and timeLeft > 0 then
				if not showTorments then
					self:OpenInfo("infobox", debuffName)
				end

				infoboxScheduled = self:ScheduleTimer(updateInfoBox, 0.1, self)
				self:SetInfo("infobox", bloodOffset+1, "|cffffffff" .. self:SpellName(245586))
				self:SetInfo("infobox", bloodOffset+2, L.timeLeft:format(timeLeft))
				self:SetInfoBar("infobox", bloodOffset+1, timeLeft/10)

				sort(playerTable, function(a, b) return a.value > b.value end)

				for i = 1, math.min((8-bloodOffset)/2, 3) do
					if playerTable[i] then
						self:SetInfo("infobox", bloodOffset+1+i*2, self:ColorName(playerTable[i].name))
						self:SetInfo("infobox", bloodOffset+2+i*2, self:AbbreviateNumber(playerTable[i].value))
						self:SetInfoBar("infobox", bloodOffset+1+i*2, playerTable[i].value / chilledBloodMaxAbsorb)
					else
						self:SetInfo("infobox", bloodOffset+1+i*2, "")
						self:SetInfo("infobox", bloodOffset+2+i*2, "")
						self:SetInfoBar("infobox", bloodOffset+1+i*2, 0)
					end
				end
			else
				showChilledBlood = nil
			end
		end

		if not showChilledBlood and not showTorments then
			self:CloseInfo("infobox")
		end
	end
end

--[[ General ]]--
function mod:UNIT_TARGETABLE_CHANGED(unit)
	if self:MobId(UnitGUID(unit)) == 122468 then -- Noura
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-15967), false) -- Noura, Mother of Flame
			self:Bar(245627, 8.9) -- Whirling Saber
			self:Bar(244899, 12.5) -- Fiery Strike
			if not self:Easy() then
				self:Bar(253429, 21.1) -- Fulminating Pulse
			end
			self:StopBar(self:SpellName(-15967)) -- Noura, Mother of Flame
		else
			self:StopBar(244899) -- Fiery Strike
			self:StopBar(245627) -- Whirling Saber
			self:StopBar(253429) -- Fulminating Pulse
		end
	elseif self:MobId(UnitGUID(unit)) == 122467 then -- Asara
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-15968), false) -- Asara, Mother of Night
			self:Bar(246329, 12.6) -- Shadow Blades
			if not self:Easy() then
				self:Bar(252861, 28.4) -- Storm of Darkness
			end
		else
			self:StopBar(246329) -- Shadow Blades
			self:StopBar(252861) -- Storm of Darkness
		end
	elseif self:MobId(UnitGUID(unit)) == 122469 then -- Diima
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-15969), false) -- Diima, Mother of Gloom
			self:Bar(245586, 8) -- Chilled Blood
			self:Bar(245518, 12.2) -- Flashfreeze
			if not self:Easy() then
				self:Bar(253650, 30) -- Orb of Frost
			end
			self:StopBar(self:SpellName(-15969)) -- Diima, Mother of Gloom
			self:CDBar("stages", 185, self:SpellName(-15967), "achievement_boss_argus_shivan") -- Noura, Mother of Flame
		else
			self:StopBar(245518) -- Flashfreeze
			self:StopBar(245586) -- Chilled Blood
			self:StopBar(253650) -- Orb of Frost
		end
	elseif self:MobId(UnitGUID(unit)) == 125436 then -- Thu'raya
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-16398), false) -- Thu'raya, Mother of the Cosmos
		end
	end
end

do
	local prev = 0
	function mod:ShivanPact(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Important", "Info")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("250095", nil, true) then -- Machinations of Aman'thul
		self:Message("torment_of_the_titans", "Urgent", nil, CL.soon:format(L.torment:format(L.tormentHeal)), tormentIcons["AmanThul"])
	elseif msg:find("245671", nil, true) then -- Flames of Khaz'goroth
		self:Message("torment_of_the_titans", "Urgent", nil, CL.soon:format(L.torment:format(L.tormentFlames)), tormentIcons["Khazgoroth"])
	elseif msg:find("246763", nil, true) then -- Fury of Golganneth
		self:Message("torment_of_the_titans", "Urgent", nil, CL.soon:format(L.torment:format(L.tormentLightning)), tormentIcons["Golganneth"])
	elseif msg:find("245910", nil, true) then -- Spectral Army of Norgannon
		self:Message("torment_of_the_titans", "Urgent", nil, CL.soon:format(L.torment:format(L.tormentArmy)), tormentIcons["Norgannon"])
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 253949 then -- Machinations of Aman'thul
		self:StopBar(L.torment:format(L.tormentHeal))
		upcomingTorments[1] = nil
		self:Message("torment_of_the_titans", "Important", "Warning", L.torment:format(L.tormentHeal), tormentIcons["AmanThul"])
		updateInfoBox(self)
	elseif spellId == 253881 then -- Flames of Khaz'goroth
		self:StopBar(L.torment:format(L.tormentFlames))
		upcomingTorments[2] = nil
		self:Message("torment_of_the_titans", "Important", "Warning", L.torment:format(L.tormentFlames), tormentIcons["Khazgoroth"])
		updateInfoBox(self)
	elseif spellId == 253951 then  -- Fury of Golganneth
		self:StopBar(L.torment:format(L.tormentLightning))
		upcomingTorments[3] = nil
		self:Message("torment_of_the_titans", "Important", "Warning", L.torment:format(L.tormentLightning), tormentIcons["Golganneth"])
		updateInfoBox(self)
	elseif spellId == 253950 then -- Spectral Army of Norgannon
		self:StopBar(L.torment:format(L.tormentArmy))
		upcomingTorments[4] = nil
		self:Message("torment_of_the_titans", "Important", "Warning", L.torment:format(L.tormentArmy), tormentIcons["Norgannon"])
		updateInfoBox(self)
	end
end

function mod:TormentofAmanThul(args)
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[1] = "AmanThul"
	self:Message("torment_of_the_titans", "Neutral", "Info", L.nextTorment:format(L.tormentHeal), tormentIcons["AmanThul"])
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentHeal), tormentIcons["AmanThul"])
	updateInfoBox(self)
end

function mod:TormentofKhazgoroth(args)
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[2] = "Khazgoroth"
	self:Message("torment_of_the_titans", "Neutral", "Info", L.nextTorment:format(L.tormentFlames), tormentIcons["Khazgoroth"])
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentFlames), tormentIcons["Khazgoroth"])
	updateInfoBox(self)
end

function mod:TormentofGolganneth(args)
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[3] = "Golganneth"
	self:Message("torment_of_the_titans", "Neutral", "Info", L.nextTorment:format(L.tormentLightning), tormentIcons["Golganneth"])
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentLightning), tormentIcons["Golganneth"])
	updateInfoBox(self)
end

function mod:TormentofNorgannon(args)
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[4] = "Norgannon"
	self:Message("torment_of_the_titans", "Neutral", "Info", L.nextTorment:format(L.tormentArmy), tormentIcons["Norgannon"])
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentArmy), tormentIcons["Norgannon"])
	updateInfoBox(self)
end

--[[ Noura, Mother of Flame ]]--
function mod:FieryStrike(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) or amount > 2 then -- Swap above 2, always display stacks on self
		self:StackMessage(args.spellId, args.destName, amount, "Neutral", "Info")
	end
end

function mod:FieryStrikeSuccess(args)
	self:Bar(args.spellId, 10.9)
end

function mod:WhirlingSaber(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 35.3)
end

do
	local playerList = mod:NewTargetList()
	function mod:FulminatingPulse(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
			self:Bar(args.spellId, 40.1)
		end
	end

	function mod:FulminatingPulseRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

--[[ Asara, Mother of Night ]]--
function mod:ShadowBlades(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 29.2)
end

function mod:StormofDarkness(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 58.5)
end

--[[ Diima, Mother of Gloom ]]--
function mod:Flashfreeze(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, amount, "Neutral", "Info")
	end
end

function mod:FlashfreezeSuccess(args)
	self:Bar(args.spellId, 10.9)
end

do
	local targetList = mod:NewTargetList()

	function mod:ChilledBlood(args)
		targetList[#targetList+1] = args.destName

		if #targetList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, targetList, "Positive", "Alarm", nil, nil, self:Healer() and true) -- Always play a sound for healers
			self:Bar(args.spellId, 25.5)
			chilledBloodTime = GetTime()
			infoboxScheduled = self:ScheduleTimer(updateInfoBox, 0.1, self)
		end

		local debuff, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, value = UnitDebuff(args.destName, args.spellName)
		if debuff and value and value > 0 then
			chilledBloodList[args.destName] = true
			chilledBloodMaxAbsorb = math.max(chilledBloodMaxAbsorb, value)
		end
	end

	function mod:ChilledBloodRemoved(args)
		chilledBloodList[args.destName] = nil
		updateInfoBox(self)
	end
end

function mod:OrbofFrost(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 30.4)
end

--[[ Thu'raya, Mother of the Cosmos (Mythic) ]]--
function mod:TouchoftheCosmos(args)
	if self:Interrupter() then
		self:Message(args.spellId, "Urgent", "Alarm")
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:CosmicGlare(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:Bar(args.spellId, 25.6)
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Attention", "Alarm")
			if self:GetOption(cosmicGlareMarker) then
				SetRaidTarget(args.destName, 3)
			end
		elseif self:GetOption(cosmicGlareMarker) then
			SetRaidTarget(args.destName, 4)
		end
	end
end

function mod:CosmicGlareRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(cosmicGlareMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

--[[ Ground effects ]]--
do
	local prev = 0
	local optionIds = {
		[245629] = 245627, -- Whirling Saber
		[245634] = 245627, -- Whirling Saber
		[253020] = 252861, -- Storm of Darkness
	}
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(optionIds[args.spellId] or args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end
