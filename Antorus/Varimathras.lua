--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Varimathras", 1712, 1983)
if not mod then return end
mod:RegisterEnableMob(122366)
mod.engageId = 2069
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local tormentActive = 0 -- 1: Flames, 2: Frost, 3: Fel, 4: Shadows
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.shadowOfVarimathras_icon = "spell_warlock_demonsoul"
end

--------------------------------------------------------------------------------
-- Initialization
--

local necroticEmbraceMarker = mod:AddMarkerOption(false, "player", 3, 244094, 3, 4) -- Necrotic Embrace
function mod:GetOptions()
	return {
		"stages", -- Torment of Flames, Frost, Fel, Shadows
		"berserk",
		243961, -- Misery
		{243960, "TANK"}, -- Shadow Strike
		243999, -- Dark Fissure
		{244042, "SAY", "FLASH", "ICON"}, -- Marked Prey
		{244094, "SAY", "FLASH", "PULSE", "PROXIMITY"}, -- Necrotic Embrace
		necroticEmbraceMarker,
		-16350, -- Shadow of Varimathras
	},{
		["stages"] = "general",
		[-16350] = "mythic",
	}
end

function mod:OnBossEnable()
	--[[ Stages ]]--
	self:Log("SPELL_AURA_APPLIED", "TormentofFlames", 243968)
	self:Log("SPELL_AURA_APPLIED", "TormentofFrost", 243977)
	self:Log("SPELL_AURA_APPLIED", "TormentofFel", 243980)
	self:Log("SPELL_AURA_APPLIED", "TormentofShadows", 243973)

	--[[ General ]]--
	self:Log("SPELL_AURA_APPLIED", "Misery", 243961)
	self:Log("SPELL_CAST_SUCCESS", "ShadowStrike", 243960, 257644) -- Heroic, Normal
	self:Log("SPELL_CAST_START", "DarkFissureStart", 243999)
	self:Log("SPELL_CAST_SUCCESS", "DarkFissure", 243999)
	self:Log("SPELL_AURA_APPLIED", "MarkedPrey", 244042)
	self:Log("SPELL_AURA_REMOVED", "MarkedPreyRemoved", 244042)
	self:Log("SPELL_CAST_SUCCESS", "NecroticEmbraceSuccess", 244093)
	self:Log("SPELL_AURA_APPLIED", "NecroticEmbrace", 244094)
	self:Log("SPELL_AURA_REMOVED", "NecroticEmbraceRemoved", 244094)
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 244005) -- Dark Fissure
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 244005) -- Dark Fissure
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 244005) -- Dark Fissure

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_SUCCESS", "EchoesofDoom", 248732)
end

function mod:OnEngage()
	tormentActive = 0
	wipe(mobCollector)

	self:CDBar("stages", 5, self:SpellName(243968), 243968) -- Torment of Flames
	self:CDBar(243960, 9.7) -- Shadow Strike
	self:CDBar(243999, 17.8) -- Dark Fissure
	self:CDBar(244042, 25.5) -- Marked Prey
	if not self:Easy() then
		self:CDBar(244094, 35.3) -- Necrotic Embrace
	end

	self:Berserk(310)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TormentofFlames(args)
	if tormentActive ~= 1 then
		tormentActive = 1
		self:Message("stages", "green", "Long", args.spellName, args.spellId)
		if self:Easy() then
			self:CDBar("stages", 355, self:SpellName(243973), 243973) -- Torment of Shadows
		else
			self:CDBar("stages", self:Mythic() and 100 or 120, self:SpellName(243977), 243977) -- Torment of Frost
		end
	end
end

function mod:TormentofFrost(args)
	if tormentActive ~= 2 then
		tormentActive = 2
		self:Message("stages", "green", "Long", args.spellName, args.spellId)
		self:CDBar("stages", self:Mythic() and 100 or 114, self:SpellName(243980), 243980) -- Torment of Fel
	end
end

function mod:TormentofFel(args)
	if tormentActive ~= 3 then
		tormentActive = 3
		self:Message("stages", "green", "Long", args.spellName, args.spellId)
		self:CDBar("stages", self:Mythic() and 90 or 121, self:SpellName(243973), 243973) -- Torment of Shadows
	end
end

function mod:TormentofShadows(args)
	if tormentActive ~= 4 then
		tormentActive = 4
		self:Message("stages", "green", "Long", args.spellName, args.spellId)
	end
end

function mod:Misery(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Alarm", CL.you:format(args.spellName))
	end
end

function mod:ShadowStrike()
	self:Message(243960, "orange", "Warning")
	self:CDBar(243960, 9.8)
end

function mod:DarkFissureStart(args)
	self:CDBar(243960, 5.3) -- Shadow Strike
end

function mod:DarkFissure(args)
	self:Message(args.spellId, "yellow", "Alert")
	self:CDBar(args.spellId, 32.9)
end

function mod:MarkedPrey(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
		self:PlaySound(args.spellId, "Alarm")
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage2(args.spellId, "red", args.destName)
	self:TargetBar(args.spellId, 5, args.destName)
	self:CDBar(args.spellId, 32.8)
end

function mod:MarkedPreyRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

do
	local playerList, isOnMe, proxList = mod:NewTargetList(), false, {}

	function mod:NecroticEmbraceSuccess()
		wipe(proxList)
		self:CDBar(244094, 30.5)
	end

	local function warn()
		if not isOnMe then
			mod:TargetsMessage(244094, "orange", playerList, #playerList) -- Necrotic Embrace
			mod:OpenProximity(244094, 10, proxList)
		end
		wipe(playerList)
	end

	function mod:NecroticEmbrace(args)
		if #playerList >= 2 then return end -- Avoid spam if something goes wrong
		if tContains(proxList, args.destName) then return end -- Don't annouce someone twice

		playerList[#playerList+1] = args.destName
		local count = #playerList
		local icon = count + 2
		if self:Me(args.destGUID) then
			isOnMe = true
			self:PlaySound(args.spellId, "Warning")
			self:TargetMessage2(args.spellId, "orange", args.destName, false, CL.count_icon:format(args.spellName, count, icon))
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, icon))
			self:Flash(args.spellId, icon)
			self:SayCountdown(args.spellId, 6, icon)
			self:OpenProximity(args.spellId, 10)
		end

		proxList[#proxList+1] = args.destName

		if count == 1 then
			self:SimpleTimer(warn, 0.3)
		end

		if self:GetOption(necroticEmbraceMarker) then
			SetRaidTarget(args.destName, icon) -- Icons 3 and 4
		end
	end

	function mod:NecroticEmbraceRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "green", "Info", CL.removed:format(args.spellName))
			isOnMe = false
			self:CancelSayCountdown(args.spellId)
			self:CloseProximity(args.spellId)
		end

		if self:GetOption(necroticEmbraceMarker) then
			SetRaidTarget(args.destName, 0)
		end

		tDeleteItem(proxList, args.destName)

		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else -- Update proximity
				self:OpenProximity(args.spellId, 10, proxList)
			end
		end
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(243999, "blue", "Alert", CL.underyou:format(args.spellName)) -- Dark Fissure
		end
	end
end

--[[ Mythic ]]--
do
	local prev = 0
	function mod:EchoesofDoom(args)
		if not mobCollector[args.sourceGUID] then
			mobCollector[args.sourceGUID] = true -- Only warn once per Shadow
			local t = GetTime()
			if t-prev > 1.5 then -- Also don't spam too much if it's a wipe and several are spawning at the same time
				prev = t
				self:Message(-16350, "orange", "Alarm", nil, L.shadowOfVarimathras_icon)
			end
		end
	end
end
