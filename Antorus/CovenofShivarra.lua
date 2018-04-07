
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Coven of Shivarra", 1712, 1986)
if not mod then return end
mod:RegisterEnableMob(122468, 122467, 122469, 125436) -- Noura, Asara, Diima, Thu'raya
mod.engageId = 2073
mod.respawnTime = 21

--------------------------------------------------------------------------------
-- Locals
--

local chilledBloodTime = 0
local chilledBloodList = {}
local chilledBloodMaxAbsorb = 1
local tormentIcons = {
	AmanThul = 139, -- Renew
	Norgannon = 245910, -- Army
	Khazgoroth = 245671, -- Flames
	Golganneth = 421, -- Chain Lightning
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
	L.tormentHeal = "Heal/DoT"
	L.tormentLightning = "Lightning" -- short for Chain Lightning
	L.tormentArmy = "Army"
	L.tormentFlames = "Flames"
end

--------------------------------------------------------------------------------
-- Initialization
--

local chilledBloodMarker = mod:AddMarkerOption(false, "player", 1, 245586, 1, 2, 5)
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
		{253520, "SAY"}, -- Fulminating Pulse

		--[[ Asara, Mother of Night ]]--
		246329, -- Shadow Blades
		252861, -- Storm of Darkness

		--[[ Diima, Mother of Gloom ]]--
		{245518, "TANK_HEALER"}, -- Flashfreeze
		{245586, "INFOBOX"}, -- Chilled Blood
		chilledBloodMarker,
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
	self:Log("SPELL_AURA_APPLIED", "FulminatingPulse", 253520)
	self:Log("SPELL_AURA_REMOVED", "FulminatingPulseRemoved", 253520)

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
	self:Log("SPELL_DAMAGE", "WhirlingSaberDamage", 245629, 245634) -- Initial impact, standing in it
	self:Log("SPELL_MISSED", "WhirlingSaberDamage", 245629, 245634)

	self:Log("SPELL_AURA_APPLIED", "StormOfDarknessDamage", 253020)
	self:Log("SPELL_PERIODIC_DAMAGE", "StormOfDarknessDamage", 253020)
	self:Log("SPELL_PERIODIC_MISSED", "StormOfDarknessDamage", 253020)
end

function mod:OnEngage()
	chilledBloodTime = 0
	wipe(chilledBloodList)
	chilledBloodMaxAbsorb = 1
	wipe(upcomingTorments)

	self:Bar(245627, 8.5) -- Whirling Saber
	self:Bar(244899, 12.1) -- Fiery Strike
	if not self:Easy() then
		self:Bar(253520, 20.6) -- Fulminating Pulse
	end

	self:Bar(246329, 12.1) -- Shadow Blades
	if not self:Easy() then
		self:Bar(252861, 27.9) -- Storm of Darkness
	end

	self:CDBar("torment_of_the_titans", 82, L.torment_of_the_titans, L.torment_of_the_titans_icon)
	self:CDBar("stages", 190, -15969, "achievement_boss_argus_shivan") -- Diima, Mother of Gloom

	self:Berserk(720)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local updateInfoBox
do
	local debuffName = mod:SpellName(245586) -- Chilled Blood
	local tormentMarkup = {
		AmanThul = {color = "|cff81c784", text = "tormentHeal", icon = GetSpellTexture(tormentIcons.AmanThul)},
		Norgannon = {color = "|cff9575cd", text = "tormentArmy", icon = GetSpellTexture(tormentIcons.Norgannon)},
		Khazgoroth = {color = "|cffe57373", text = "tormentFlames", icon = GetSpellTexture(tormentIcons.Khazgoroth)},
		Golganneth = {color = "|cff4fc3f7", text = "tormentLightning", icon = GetSpellTexture(tormentIcons.Golganneth)},
	}

	local UnitDebuff, sort, min, sortFunc = UnitDebuff, table.sort, math.min, function(a, b)
		return a[2] > b[2]
	end
	function updateInfoBox()
		local showTorments = next(upcomingTorments)
		local showChilledBlood = mod:CheckOption(245586, "INFOBOX")
		local bloodOffset = 0

		-- Torment
		if showTorments then
			mod:OpenInfo("infobox", L.nextTorment:format(""))

			local nextTorment = tormentMarkup[upcomingTorments[1]]
			local data = ("|T%s:15:15:0:0:64:64:4:60:4:60|t%s%s|r"):format(nextTorment.icon, nextTorment.color, L[nextTorment.text])
			mod:SetInfo("infobox", 1, data)
			bloodOffset = 2
		end

		-- Chilled Blood
		if showChilledBlood then
			local totalAbsorb = 0
			for i = 1, #chilledBloodList do
				local debuff, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, value = UnitDebuff(chilledBloodList[i][1], debuffName)
				if debuff and value and value > 0 then
					chilledBloodList[i][2] = value
					totalAbsorb = totalAbsorb + value
				end
			end

			local timeLeft = chilledBloodTime + 10 - GetTime()

			if #chilledBloodList > 0 and timeLeft > 0 then
				if not showTorments then
					mod:OpenInfo("infobox", debuffName)
				end

				mod:SimpleTimer(updateInfoBox, 0.1)
				mod:SetInfo("infobox", bloodOffset+1, "|cffffffff" .. mod:SpellName(245586))
				mod:SetInfo("infobox", bloodOffset+2, L.timeLeft:format(timeLeft))
				mod:SetInfoBar("infobox", bloodOffset+1, timeLeft/10)

				sort(chilledBloodList, sortFunc)

				for i = 1, min((8-bloodOffset)/2, 3) do
					if chilledBloodList[i] then
						local player = chilledBloodList[i][1]
						local icon = GetRaidTargetIndex(player)
						mod:SetInfo("infobox", bloodOffset+1+i*2, (icon and ("|T13700%d:0|t"):format(icon) or "") .. mod:ColorName(player))
						mod:SetInfo("infobox", bloodOffset+2+i*2, mod:AbbreviateNumber(chilledBloodList[i][2]))
						mod:SetInfoBar("infobox", bloodOffset+1+i*2, chilledBloodList[i][2] / chilledBloodMaxAbsorb)
					else
						mod:SetInfo("infobox", bloodOffset+1+i*2, "")
						mod:SetInfo("infobox", bloodOffset+2+i*2, "")
						mod:SetInfoBar("infobox", bloodOffset+1+i*2, 0)
					end
				end
			else
				showChilledBlood = nil
			end
		end

		if not showChilledBlood and not showTorments then
			mod:CloseInfo("infobox")
		end
	end
end

--[[ General ]]--
function mod:UNIT_TARGETABLE_CHANGED(unit)
	if self:MobId(UnitGUID(unit)) == 122468 then -- Noura
		if UnitCanAttack("player", unit) then
			self:Message("stages", "green", "Long", -15967, false) -- Noura, Mother of Flame
			self:Bar(245627, 8.9) -- Whirling Saber
			self:Bar(244899, 12.5) -- Fiery Strike
			if not self:Easy() then
				self:Bar(253520, 21.1) -- Fulminating Pulse
			end
			self:StopBar(-15967) -- Noura, Mother of Flame
			if self:Mythic() then
				self:CDBar("stages", 46, -15968, "achievement_boss_argus_shivan") -- Asara, Mother of Night
			end
		else
			self:StopBar(244899) -- Fiery Strike
			self:StopBar(245627) -- Whirling Saber
			self:StopBar(253520) -- Fulminating Pulse
		end
	elseif self:MobId(UnitGUID(unit)) == 122467 then -- Asara
		if UnitCanAttack("player", unit) then
			self:Message("stages", "green", "Long", -15968, false) -- Asara, Mother of Night
			self:Bar(246329, 12.6) -- Shadow Blades
			if not self:Easy() then
				self:Bar(252861, 28.4) -- Storm of Darkness
			end
			self:StopBar(-15968) -- Asara, Mother of Night
		else
			self:StopBar(246329) -- Shadow Blades
			self:StopBar(252861) -- Storm of Darkness
		end
	elseif self:MobId(UnitGUID(unit)) == 122469 then -- Diima
		if UnitCanAttack("player", unit) then
			self:Message("stages", "green", "Long", -15969, false) -- Diima, Mother of Gloom
			self:Bar(245586, 8) -- Chilled Blood
			self:Bar(245518, 12.2) -- Flashfreeze
			if not self:Easy() then
				self:Bar(253650, 30) -- Orb of Frost
			end
			self:StopBar(-15969) -- Diima, Mother of Gloom
			if self:Mythic() then
				self:CDBar("stages", 46, -16398, "achievement_boss_argus_shivan") -- Thu'raya, Mother of the Cosmos
			else
				self:CDBar("stages", 185, -15967, "achievement_boss_argus_shivan") -- Noura, Mother of Flame
			end
		else
			self:StopBar(245518) -- Flashfreeze
			self:StopBar(245586) -- Chilled Blood
			self:StopBar(253650) -- Orb of Frost
		end
	elseif self:MobId(UnitGUID(unit)) == 125436 then -- Thu'raya
		if UnitCanAttack("player", unit) then
			self:Message("stages", "green", "Long", -16398, false) -- Thu'raya, Mother of the Cosmos
			self:Bar(250757, 5.2) -- Cosmic Glare
			self:StopBar(-16398) -- Thu'raya, Mother of the Cosmos
			self:CDBar("stages", 142, -15967, "achievement_boss_argus_shivan") -- Noura, Mother of Flame
		else
			self:StopBar(250757) -- Cosmic Glare
		end
	end
end

do
	local prev = 0
	function mod:ShivanPact(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "red", "Info")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("250095", nil, true) then -- Machinations of Aman'thul
		self:Message("torment_of_the_titans", "orange", nil, CL.soon:format(L.torment:format(L.tormentHeal)), tormentIcons["AmanThul"])
	elseif msg:find("245671", nil, true) then -- Flames of Khaz'goroth
		self:Message("torment_of_the_titans", "orange", nil, CL.soon:format(L.torment:format(L.tormentFlames)), tormentIcons["Khazgoroth"])
	elseif msg:find("246763", nil, true) then -- Fury of Golganneth
		self:Message("torment_of_the_titans", "orange", nil, CL.soon:format(L.torment:format(L.tormentLightning)), tormentIcons["Golganneth"])
	elseif msg:find("245910", nil, true) then -- Spectral Army of Norgannon
		self:Message("torment_of_the_titans", "orange", nil, CL.soon:format(L.torment:format(L.tormentArmy)), tormentIcons["Norgannon"])
	end
end

do
	local tormentLocaleLookup = {
		["AmanThul"] = "tormentHeal",
		["Norgannon"] = "tormentArmy",
		["Khazgoroth"] = "tormentFlames",
		["Golganneth"] = "tormentLightning",
	}

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
		local announceNextTorment = nil
		if spellId == 253949 then -- Machinations of Aman'thul
			self:StopBar(L.torment:format(L.tormentHeal))
			tDeleteItem(upcomingTorments, "AmanThul")
			self:Message("torment_of_the_titans", "red", "Warning", L.torment:format(L.tormentHeal), tormentIcons["AmanThul"])
			updateInfoBox()
			announceNextTorment = true
		elseif spellId == 253881 then -- Flames of Khaz'goroth
			self:StopBar(L.torment:format(L.tormentFlames))
			tDeleteItem(upcomingTorments, "Khazgoroth")
			self:Message("torment_of_the_titans", "red", "Warning", L.torment:format(L.tormentFlames), tormentIcons["Khazgoroth"])
			updateInfoBox()
			announceNextTorment = true
		elseif spellId == 253951 then  -- Fury of Golganneth
			self:StopBar(L.torment:format(L.tormentLightning))
			tDeleteItem(upcomingTorments, "Golganneth")
			self:Message("torment_of_the_titans", "red", "Warning", L.torment:format(L.tormentLightning), tormentIcons["Golganneth"])
			updateInfoBox()
			announceNextTorment = true
		elseif spellId == 253950 then -- Spectral Army of Norgannon
			self:StopBar(L.torment:format(L.tormentArmy))
			tDeleteItem(upcomingTorments, "Norgannon")
			self:Message("torment_of_the_titans", "red", "Warning", L.torment:format(L.tormentArmy), tormentIcons["Norgannon"])
			updateInfoBox()
			announceNextTorment = true
		end
		if announceNextTorment and #upcomingTorments == 1 then
			local nextTorment = upcomingTorments[1]
			self:ScheduleTimer("Message", 5, "torment_of_the_titans", "cyan", "Info", L.nextTorment:format(L[tormentLocaleLookup[nextTorment]]), tormentIcons[nextTorment])
		end
	end
end

function mod:TormentofAmanThul()
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[#upcomingTorments+1] = "AmanThul"
	if #upcomingTorments == 1 then
		self:Message("torment_of_the_titans", "cyan", "Info", L.nextTorment:format(L.tormentHeal), tormentIcons["AmanThul"])
	end
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentHeal), tormentIcons["AmanThul"])
	updateInfoBox()
end

function mod:TormentofKhazgoroth()
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[#upcomingTorments+1] = "Khazgoroth"
	if #upcomingTorments == 1 then
		self:Message("torment_of_the_titans", "cyan", "Info", L.nextTorment:format(L.tormentFlames), tormentIcons["Khazgoroth"])
	end
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentFlames), tormentIcons["Khazgoroth"])
	updateInfoBox()
end

function mod:TormentofGolganneth()
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[#upcomingTorments+1] = "Golganneth"
	if #upcomingTorments == 1 then
		self:Message("torment_of_the_titans", "cyan", "Info", L.nextTorment:format(L.tormentLightning), tormentIcons["Golganneth"])
	end
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentLightning), tormentIcons["Golganneth"])
	updateInfoBox()
end

function mod:TormentofNorgannon()
	self:StopBar(L.torment_of_the_titans)
	upcomingTorments[#upcomingTorments+1] = "Norgannon"
	if #upcomingTorments == 1 then
		self:Message("torment_of_the_titans", "cyan", "Info", L.nextTorment:format(L.tormentArmy), tormentIcons["Norgannon"])
	end
	self:Bar("torment_of_the_titans", 90, L.torment:format(L.tormentArmy), tormentIcons["Norgannon"])
	updateInfoBox()
end

--[[ Noura, Mother of Flame ]]--
function mod:FieryStrike(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) or amount > 2 then -- Swap above 2, always display stacks on self
		self:StackMessage(args.spellId, args.destName, amount, "cyan", "Info")
	end
end

function mod:FieryStrikeSuccess(args)
	self:Bar(args.spellId, 10.9)
end

function mod:WhirlingSaber(args)
	self:Message(args.spellId, "yellow", "Alert", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 35.3)
end

do
	local playerList = mod:NewTargetList()
	function mod:FulminatingPulse(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
			self:PlaySound(args.spellId, "Alarm")
		end
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "red", playerList, 3)
		if #playerList == 1 then
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
	self:Message(args.spellId, "yellow", "Alert")
	self:CDBar(args.spellId, 29.2)
end

function mod:StormofDarkness(args)
	self:Message(args.spellId, "red", "Alarm")
	self:Bar(args.spellId, 58.5)
end

--[[ Diima, Mother of Gloom ]]--
function mod:Flashfreeze(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, amount, "cyan", "Info")
	end
end

function mod:FlashfreezeSuccess(args)
	self:Bar(args.spellId, 10.9)
end

do
	local playerList = mod:NewTargetList()

	function mod:ChilledBlood(args)
		playerList[#playerList+1] = args.destName

		if self:Healer() then -- Always play a sound for healers
			self:PlaySound(args.spellId, "Alarm", nil, playerList)
		elseif self:Me() then
			self:PlaySound(args.spellId, "Alarm")
		end

		self:TargetsMessage(args.spellId, "green", playerList, 3)
		if #playerList == 1 then
			chilledBloodTime = GetTime()
			self:Bar(args.spellId, 25.5)
			self:SimpleTimer(updateInfoBox, 0.3)
		end

		if self:GetOption(chilledBloodMarker) then
			SetRaidTarget(args.destName, #playerList > 2 and 5 or #playerList) -- Icons: 1, 2, 5
		end

		local debuff, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, value = UnitDebuff(args.destName, args.spellName)
		if debuff and value and value > 0 then
			chilledBloodList[#chilledBloodList+1] = {args.destName, value}
			chilledBloodMaxAbsorb = math.max(chilledBloodMaxAbsorb, value)
		end
	end

	function mod:ChilledBloodRemoved(args)
		for i = #chilledBloodList, 1, -1 do
			if chilledBloodList[i][1] == args.destName then
				tremove(chilledBloodList, i)
			end
		end
		if self:GetOption(chilledBloodMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:OrbofFrost(args)
	self:Message(args.spellId, "yellow", "Alert")
	self:Bar(args.spellId, 30.4)
end

--[[ Thu'raya, Mother of the Cosmos (Mythic) ]]--
function mod:TouchoftheCosmos(args)
	if self:Interrupter() then
		self:Message(args.spellId, "orange", "Alarm")
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:CosmicGlare(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
			self:PlaySound(args.spellId, "Alarm")
		end

		playerList[#playerList+1] = args.destName

		self:TargetsMessage(args.spellId, "yellow", playerList, 2)
		if #playerList == 1 then
			self:CDBar(args.spellId, 15)
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
	function mod:WhirlingSaberDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(245627, "blue", "Alert", CL.underyou:format(args.spellName))
			end
		end
	end
end

do
	local prev = 0
	function mod:StormOfDarknessDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(252861, "blue", "Alert", CL.underyou:format(args.spellName))
			end
		end
	end
end
