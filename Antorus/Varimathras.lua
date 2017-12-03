--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Varimathras", nil, 1983, 1712)
if not mod then return end
mod:RegisterEnableMob(122366)
mod.engageId = 2069
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local tormentActive = 0 -- 1: Flames, 2: Frost, 3: Fel, 4: Shadows
local _, shadowDesc = EJ_GetSectionInfo(16350)
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.shadowOfVarmathras = "{-16350}"
	L.shadowOfVarmathras_desc = shadowDesc
	L.shadowOfVarmathras_icon = "spell_warlock_demonsoul"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages", -- Torment of Flames, Frost, Fel, Shadows
		"berserk",
		243961, -- Misery
		{243960, "TANK"}, -- Shadow Strike
		243999, -- Dark Fissure
		{244042, "SAY", "FLASH", "ICON"}, -- Marked Prey
		{244094, "SAY", "FLASH", "ICON"}, -- Necrotic Embrace
		"shadowOfVarmathras",
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
		self:Message("stages", "Positive", "Long", args.spellName, args.spellId)
		if self:Easy() then
			self:CDBar("stages", 355, self:SpellName(243973), 243973) -- Torment of Shadows
		else
			self:CDBar("stages", 120, self:SpellName(243977), 243977) -- Torment of Frost
		end
	end
end

function mod:TormentofFrost(args)
	if tormentActive ~= 2 then
		tormentActive = 2
		self:Message("stages", "Positive", "Long", args.spellName, args.spellId)
		self:CDBar("stages", 114, self:SpellName(243980), 243980) -- Torment of Fel
	end
end

function mod:TormentofFel(args)
	if tormentActive ~= 3 then
		tormentActive = 3
		self:Message("stages", "Positive", "Long", args.spellName, args.spellId)
		self:CDBar("stages", 121, self:SpellName(243973), 243973) -- Torment of Shadows
	end
end

function mod:TormentofShadows(args)
	if tormentActive ~= 4 then
		tormentActive = 4
		self:Message(args.spellId, "Positive", "Long", args.spellName, args.spellId)
	end
end

function mod:Misery(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
	end
end

function mod:ShadowStrike(args)
	self:Message(243960, "Urgent", "Warning")
	self:CDBar(243960, 9.8)
end

function mod:DarkFissure(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 32.9)
end

function mod:MarkedPrey(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
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

function mod:NecroticEmbraceSuccess()
	self:CDBar(244094, 30.5)
end

do
	local playerList = mod:NewTargetList()
	function mod:NecroticEmbrace(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			-- Only 1 initial application, can avoid spreading. XXX See if this remains viable, or we need to mark everyone.
			self:SecondaryIcon(args.spellId, args.destName)
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning")
		end
	end

	function mod:NecroticEmbraceRemoved(args)
		self:SecondaryIcon(args.spellId)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(243999, "Personal", "Alert", CL.underyou:format(args.spellName)) -- Dark Fissure
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
				self:Message("shadowOfVarmathras", "Urgent", "Alarm", L.shadowOfVarmathras, L.shadowOfVarmathras_icon)
			end
		end

	end
end
