if UnitFactionGroup("player") ~= "Horde" then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Jadefire Masters Horde", 2070, 2341)
if not mod then return end
mod:RegisterEnableMob(144693, 144690) -- Manceroy Flamefist, Mestrah
mod.engageId = 2266
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

local searingEmbersMarker = mod:AddMarkerOption(false, "player", 1, 286988, 1, 2, 3) -- Searing Embers
function mod:GetOptions()
	return {
		"stages",
		-- Mestrah, the Illuminated
		286436, -- Whirling Jade Storm
		282030, -- Multi-Sided Strike
		285645, -- Spirits of Xuen
		{285632, "FLASH"}, -- Stalking
		"custom_on_fixate_plates",
		-- Manceroy Flamefist
		282037, -- Rising Flames
		286379, -- Pyroblast
		{286425, "INFOBOX"}, -- Fire Shield
		{286988, "SAY"}, -- Searing Embers
		searingEmbersMarker,
		284374, -- Magma Trap
		-- Team Attacks
		285428, -- Fire from Mist
		284656, -- Ring of Hostility
		282040, -- Blazing Phoenix
		286396, -- Dragon's Breath
	}, {
		["stages"] = CL.general,
		[286436] = -19390, -- Mestrah, the Illuminated
		[282037] = -19394, -- Manceroy Flamefist
		[285428] = -19401, -- Team Attacks
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
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
		self:Message2(spellId, "yellow")
		self:PlaySound(spellId, "info")
		self:CDBar(spellId, 119) -- XXX Need correct info after Ring of Hostility stage
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if msg:find("284374", nil, true) then -- Magma Trap
		self:Message2(284374, "red", CL.count:format(self:SpellName(284374), trapCount))
		self:PlaySound(284374, "warning")
		trapCount = trapCount + 1
		self:CDBar(284374, 35, CL.count:format(self:SpellName(284374), trapCount))
	end
end

function mod:UNIT_POWER_FREQUENT(event, unit)
	local power = UnitPower(unit)
	if power >= 25 and lastWarnedPower < 25 then
		lastWarnedPower = 25
		self:Message2("stages", "cyan", CL.soon:format(self:SpellName(285428)), false) -- Fire from Mist
		self:PlaySound("stages", "info")
	elseif power >= 55 and lastWarnedPower < 55 then
		lastWarnedPower = 55
		self:Message2("stages", "cyan", CL.soon:format(self:SpellName(284656)), false) -- Ring of Hostility
		self:PlaySound("stages", "info")
	elseif power >= 95 and lastWarnedPower < 95  then
		lastWarnedPower = 95
		self:Message2("stages", "cyan", CL.soon:format(self:SpellName(-19409)), false) -- The Serpent and the Phoenix
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

function mod:WhirlingJadeStorm(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 45)
end

function mod:MultiSidedStrike(args)
	if self:Mythic() or self:Tank() then -- No warnings needed for non-tanks unless it's Mythic
		self:Message2(282030, "red")
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
	self:TargetBar(args.spellId, 15, self:ColorName(args.destName))
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
	self:StopBar(args.spellId, self:ColorName(args.destName))
	if self:Me(args.destGUID) then
		--self:CancelSayCountdown(args.spellId)
	end
end

do
	local interruptTime = nil
	function mod:Pyroblast(args)
		self:Message2(args.spellId, "orange")
		self:PlaySound(args.spellId, "warning")
		interruptTime = args.time
		self:CastBar(args.spellId, 10)
		self:CDBar(args.spellId, 52) -- XXX appears to get lower during the fight
	end

	function mod:Interupted(args)
		if args.extraSpellId == 286379 then -- Pyroblast
			interruptTime = 10 - (math.floor((args.time - interruptTime) * 100)/100)
			self:Message2(286379, "green", L.interrupted_after:format(args.extraSpellName, self:ColorName(args.sourceName), interruptTime))
			self:StopBar(CL.cast:format(args.extraSpellName))
		end
	end
end

do
	local timer, castOver, maxAbsorb = nil, 0, 0
	local red, yellow, green = {.6, 0, 0, .6}, {.7, .5, 0}, {0, .5, 0}

	local function updateInfoBox(self)
		local castTimeLeft = castOver - GetTime()
		local castPercentage = castTimeLeft / 10
		local absorb = UnitGetTotalAbsorbs("boss2")
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

		self:SetInfoBar(286425, 1, absorbPercentage, unpack(rgbColor))
		self:SetInfo(286425, 2, L.absorb_text:format(self:AbbreviateNumber(absorb), hexColor, absorbPercentage*100))
		self:SetInfoBar(286425, 3, castPercentage)
		self:SetInfo(286425, 4, L.cast_text:format(castTimeLeft, hexColor, castPercentage*100))
	end

	function mod:FireShieldApplied(args)
		if self:CheckOption(args.spellId, "INFOBOX") then
			self:OpenInfo(args.spellId, args.spellName)
			self:SetInfo(args.spellId, 1, L.absorb)
			self:SetInfo(args.spellId, 3, L.cast)
			castOver = GetTime() + 10 -- XXX Have to use the cast from pyroblast depending when it's applied/cast, but this could be at the same time.
			maxAbsorb = UnitGetTotalAbsorbs("boss2") -- Assumed
			timer = self:ScheduleRepeatingTimer(updateInfoBox, 0.1, self)
		end
	end

	function mod:FireShieldRemoved(args)
		self:Message2(args.spellId, "cyan", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:CloseInfo(args.spellId)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
	end
end

do
	local playerList, isOnMe = {}, nil

	local function announce()
		local meOnly = mod:CheckOption(286988, "ME_ONLY")

		if isOnMe and (meOnly or #playerList == 1) then
			mod:Message2(286988, "blue", CL.you:format(("|T13700%d:0|t%s"):format(isOnMe, mod:SpellName(286988))))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = ("|T13700%d:0|t"):format(i)
				msg = msg .. icon .. mod:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			mod:Message2(286988, "orange", CL.other:format(mod:SpellName(286988), msg))
		end

		playerList = {}
		isOnMe = nil
	end

	function mod:SearingEmbersApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:SimpleTimer(announce, 0.1)
			self:CDBar(args.spellId, 40)
		end
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(searingEmbersMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end

	function mod:SearingEmbersRemoved(args)
		if self:GetOption(searingEmbersMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

-- function mod:MagmaTrap(args)
	-- self:Message2(args.spellId, "orange")
	-- self:PlaySound(args.spellId, "alarm")
-- end

function mod:FirefromMist(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(284656, 95) -- Ring of Hostility
end

function mod:RingofHostility(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	-- XXX Stop bars?
end

function mod:RingofHostilityRemoved(args)
	self:Message2(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CDBar(282040, 90) -- Blazing Phoenix
end

function mod:BlazingPhoenix(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(286396, 16) -- Dragon's Breath
end

function mod:DragonsBreath(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
end
