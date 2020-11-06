if UnitFactionGroup("player") ~= "Alliance" then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Jadefire Masters Alliance", 2070, 2323)
if not mod then return end
mod:RegisterEnableMob(144691, 144692) -- Ma'ra Grimfang, Anathos Firecaller
mod.engageId = 2285
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local lastWarnedPower = 0
local trapCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fixate_plates = "Stalking icon on Enemy Nameplate"
	L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is stalking on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_fixate_plates_icon = 285632 -- Stalking

	L.absorb = "Absorb"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Cast"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s interrupted by %s (%.1f seconds remaining)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local searingEmbersMarker = mod:AddMarkerOption(false, "player", 1, 286988, 1, 2, 3, 4) -- Searing Embers
function mod:GetOptions()
	return {
		"stages",
		-- Ma'ra Grimfang
		286436, -- Whirling Jade Storm
		282030, -- Multi-Sided Strike
		285645, -- Spirits of Xuen
		{285632, "FLASH"}, -- Stalking
		"custom_on_fixate_plates",
		-- Anathos Firecaller
		282037, -- Rising Flames
		286379, -- Pyroblast
		{286425, "INFOBOX"}, -- Fire Shield
		286988, -- Searing Embers
		searingEmbersMarker,
		284374, -- Magma Trap
		-- Team Attacks
		285428, -- Fire from Mist
		284656, -- Ring of Hostility
		282040, -- Blazing Phoenix
		286396, -- Dragon's Breath
	}, {
		["stages"] = CL.general,
		[286436] = -19197, -- Ma'ra Grimfang
		[282037] = -19200, -- Anathos Firecaller
		[285428] = -19203, -- Team Attacks
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", nil, "boss1", "boss2")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	-- Mestrah, the Illuminated
	self:Log("SPELL_CAST_SUCCESS", "WhirlingJadeStorm", 286436)
	self:Log("SPELL_CAST_START", "MultiSidedStrike", 282030, 285818)
	self:Log("SPELL_AURA_APPLIED", "StalkingApplied", 285632)
	self:Log("SPELL_AURA_REMOVED", "StalkingRemoved", 285632)

	-- Manceroy Flamefist
	self:Log("SPELL_AURA_APPLIED", "RisingFlamesApplied", 282037)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RisingFlamesApplied", 282037)
	self:Log("SPELL_AURA_REMOVED", "RisingFlamesRemoved", 282037)
	self:Log("SPELL_CAST_START", "Pyroblast", 286379)
	self:Log("SPELL_INTERRUPT", "Interupted", "*")
	self:Log("SPELL_AURA_APPLIED", "FireShieldApplied", 286425)
	self:Log("SPELL_AURA_REMOVED", "FireShieldRemoved", 286425)
	self:Log("SPELL_AURA_APPLIED", "SearingEmbersApplied", 286988)
	self:Log("SPELL_AURA_REMOVED", "SearingEmbersRemoved", 286988)
	-- self:Log("SPELL_CAST_SUCCESS", "MagmaTrap", 284374)

	-- Team Attacks
	self:Log("SPELL_CAST_START", "FirefromMist", 285428)
	self:Log("SPELL_CAST_SUCCESS", "RingofHostility", 284656)
	self:Log("SPELL_AURA_REMOVED", "RingofHostilityRemoved", 284656)
	self:Log("SPELL_CAST_START", "BlazingPhoenix", 282040)
	self:Log("SPELL_CAST_START", "DragonsBreath", 286396)

	if self:GetOption("custom_on_fixate_plates") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	lastWarnedPower = 0
	trapCount = 1

	self:CDBar(286379, 20.5) -- Pyroblast
	self:CDBar(286436, 21.5) -- Whirling Jade Storm
	self:CDBar(284374, 28, CL.count:format(self:SpellName(284374), trapCount)) -- Magma Trap
	self:CDBar(282030, 30) -- Multi-Sided Strike
	self:CDBar(285428, 68) -- Fire from Mist
	self:CDBar(285645, 74) -- Spirits of Xuen

	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 285645 then -- Spirits of Xuen
		self:Message(spellId, "yellow")
		self:PlaySound(spellId, "info")
		self:CDBar(spellId, 119) -- XXX Need correct info after Ring of Hostility stage
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if msg:find("284374", nil, true) then -- Magma Trap
		self:Message(284374, "red", CL.count:format(self:SpellName(284374), trapCount))
		self:PlaySound(284374, "warning")
		trapCount = trapCount + 1
		self:CDBar(284374, 35, CL.count:format(self:SpellName(284374), trapCount))
	end
end

function mod:UNIT_POWER_FREQUENT(event, unit)
	local power = UnitPower(unit)
	if power >= 25 and lastWarnedPower < 25 then
		lastWarnedPower = 25
		self:Message("stages", "cyan", CL.soon:format(self:SpellName(285428)), false) -- Fire from Mist
		self:PlaySound("stages", "info")
	elseif power >= 55 and lastWarnedPower < 55 then
		lastWarnedPower = 55
		self:Message("stages", "cyan", CL.soon:format(self:SpellName(284656)), false) -- Ring of Hostility
		self:PlaySound("stages", "info")
	elseif power >= 95 and lastWarnedPower < 95  then
		lastWarnedPower = 95
		self:Message("stages", "cyan", CL.soon:format(self:SpellName(-19409)), false) -- The Serpent and the Phoenix
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

function mod:WhirlingJadeStorm(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 45)
end

function mod:MultiSidedStrike(args)
	if self:Mythic() or self:Tank() then -- No warnings needed for non-tanks unless it's Mythic
		self:Message(282030, "red")
		self:PlaySound(282030, "warning")
		self:CDBar(282030, self:Mythic() and 73 or 55)
	end
end

function mod:StalkingApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Flash(args.spellId)
		if self:GetOption("custom_on_fixate_plates") then
			self:AddPlateIcon(args.spellId, args.sourceGUID)
		end
	end
end

function mod:StalkingRemoved(args)
	if self:GetOption("custom_on_fixate_plates") and self:Me(args.destGUID) then
		self:RemovePlateIcon(args.spellId, args.sourceGUID)
	end
end

function mod:RisingFlamesApplied(args)
	self:TargetBar(args.spellId, 15, args.destName)
	local amount = args.amount or 1
	if self:Me(args.destGUID) then
		--self:CancelSayCountdown(args.spellId) -- XXX See if we need this, was spammy
		--self:SayCountdown(args.spellId, 6, nil, 2)
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		if amount % 2 == 1 then
			self:PlaySound(args.spellId, "alarm")
		end
	elseif self:Tank() and self:Tank(args.destName) then
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		if amount > 3 and amount % 2 == 0 then
			self:PlaySound(args.spellId, "warning", nil, args.destName)
		end
	end
end

function mod:RisingFlamesRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		--self:CancelSayCountdown(args.spellId)
	end
end

do
	local castOver, maxAbsorb, absorbRemoved = 0, 0, 0
	local red, yellow, green = {.6, 0, 0, .6}, {.7, .5, 0}, {0, .5, 0}

	local function updateInfoBox(cleuUpdate)
		if castOver > 0 then
			if not cleuUpdate then
				mod:SimpleTimer(updateInfoBox, 0.1)
			end

			local castTimeLeft = castOver - GetTime()
			local castPercentage = castTimeLeft / 10
			local absorb = maxAbsorb - absorbRemoved
			local absorbPercentage = absorb / maxAbsorb

			local diff = castPercentage - absorbPercentage
			local hexColor = "ff0000"
			local rgbColor = red
			if diff > 0.1 then -- over 10%
				hexColor = "00ff00"
				rgbColor = green
			elseif diff > 0  then -- below 10%, so it's still close
				hexColor = "ffff00"
				rgbColor = yellow
			end

			mod:SetInfoBar(286425, 1, absorbPercentage, unpack(rgbColor))
			mod:SetInfo(286425, 2, L.absorb_text:format(mod:AbbreviateNumber(absorb), hexColor, absorbPercentage*100))
			mod:SetInfoBar(286425, 3, castPercentage)
			mod:SetInfo(286425, 4, L.cast_text:format(castTimeLeft, hexColor, castPercentage*100))
		else
			local absorb = maxAbsorb - absorbRemoved
			local absorbPercentage = absorb / maxAbsorb
			mod:SetInfoBar(286425, 1, absorbPercentage)
			mod:SetInfo(286425, 2, L.absorb_text:format(mod:AbbreviateNumber(absorb), "00ff00", absorbPercentage*100))
		end
	end

	do
		local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
		function mod:UpdateFireShieldAbsorbs()
			local _, subEvent, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, spellId, _, _, absorbed = CombatLogGetCurrentEventInfo()
			if subEvent == "SPELL_ABSORBED" and spellId == 286425 then -- Fire Shield
				absorbRemoved = absorbRemoved + absorbed
				--print(maxAbsorb - absorbRemoved, UnitGetTotalAbsorbs("boss2"), UnitGetTotalAbsorbs("boss1"))
				updateInfoBox(true)
			end
		end
	end

	function mod:FireShieldApplied(args)
		if self:CheckOption(args.spellId, "INFOBOX") then
			castOver = 0
			absorbRemoved = 0
			maxAbsorb = args.amount
			--print(args.amount, UnitGetTotalAbsorbs("boss2"), UnitGetTotalAbsorbs("boss1"))
			self:OpenInfo(args.spellId, args.spellName)
			self:SetInfo(args.spellId, 1, L.absorb)
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UpdateFireShieldAbsorbs")
		end
	end

	function mod:FireShieldRemoved(args)
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		--print(maxAbsorb, absorbRemoved, UnitGetTotalAbsorbs("boss2"), UnitGetTotalAbsorbs("boss1"))
		if castOver == 0 then
			self:CloseInfo(args.spellId)
		else
			absorbRemoved = maxAbsorb -- XXX temp, investigate why absorbRemoved ends up less than maxAbsorb
		end
	end

	local interruptTime = 0
	function mod:Pyroblast(args)
		interruptTime = args.time
		castOver = GetTime() + 10
		self:CastBar(args.spellId, 10)
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "warning")
		self:SetInfo(286425, 3, L.cast)
		self:CDBar(args.spellId, 52) -- XXX appears to get lower during the fight
		self:SimpleTimer(updateInfoBox, 0.1)
	end

	function mod:Interupted(args)
		if args.extraSpellId == 286379 then -- Pyroblast
			interruptTime = 10 - (math.floor((args.time - interruptTime) * 100)/100)
			self:Message(286379, "green", L.interrupted_after:format(args.extraSpellName, self:ColorName(args.sourceName), interruptTime))
		end
	end

	function mod:UNIT_SPELLCAST_STOP(_, _, _, spellId) -- Sometimes he interrupts himself
		if spellId == 286379 then -- Pyroblast
			castOver = 0
			self:StopBar(CL.cast:format(self:SpellName(spellId)))
			if maxAbsorb == absorbRemoved then
				self:CloseInfo(286425)
			else -- He stopped casting but still has shield left
				self:SetInfoBar(286425, 3, 0)
				self:SetInfo(286425, 4, "")
			end
		end
	end
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:SearingEmbersApplied(args)
		local playerIconsCount = #playerIcons+1
		playerList[#playerList+1] = args.destName
		playerIcons[playerIconsCount] = playerIconsCount
		if playerIconsCount == 1 then
			self:CDBar(args.spellId, 40)
		end
		if self:Dispeller("magic") then
			self:PlaySound(args.spellId, "alarm", nil, playerList)
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(searingEmbersMarker) then
			SetRaidTarget(args.destName, playerIconsCount)
		end
		self:TargetsMessage(args.spellId, "orange", playerList, self:Easy() and 3 or 4, nil, nil, nil, playerIcons)
	end

	function mod:SearingEmbersRemoved(args)
		if self:GetOption(searingEmbersMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

-- function mod:MagmaTrap(args)
	-- self:Message(args.spellId, "orange")
	-- self:PlaySound(args.spellId, "alarm")
-- end

function mod:FirefromMist(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(284656, 95) -- Ring of Hostility
end

function mod:RingofHostility(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	-- XXX Stop bars?
end

function mod:RingofHostilityRemoved(args)
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CDBar(282040, 90) -- Blazing Phoenix
end

function mod:BlazingPhoenix(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(286396, 16) -- Dragon's Breath
end

function mod:DragonsBreath(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
end
