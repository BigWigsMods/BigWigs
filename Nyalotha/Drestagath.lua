--------------------------------------------------------------------------------
-- TODO:
--
-- -- Add spawn timers

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Drest'agath", 2217, 2373)
if not mod then return end
mod:RegisterEnableMob(157602) -- Drest'agath
mod.engageId = 2343
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.adds = CL.adds
	L.adds_desc = "Warnings and Messages for the Eye, Tentacle and Maw of Drest'agath."
	L.adds_icon = "achievement_nzothraid_drestagath"

	L.eye_killed = "Eye Killed!"
	L.tentacle_killed = "Tentacle Killed!"
	L.maw_killed = "Maw Killed!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"adds",
		308941, -- Throes of Agony
		310246, -- Void Grip
		{310277, "TANK", "SAY_COUNTDOWN"}, -- Volatile Seed
		310329, -- Entropic Crash
		{310358, "SAY", "SAY_COUNTDOWN"}, -- Mutterings of Insanity
		310390, -- Void Glare
		308377, -- Void Infused Ichor
		{310580, "SAY"}, -- Acid Splash
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "ThroesofAgony", 308941)
	self:Log("SPELL_CAST_START", "VoidGrip", 310246)
	self:Log("SPELL_AURA_APPLIED", "VolatileSeed", 310277)
	self:Log("SPELL_AURA_REMOVED", "VolatileSeedRemoved", 310277)
	self:Log("SPELL_CAST_START", "EntropicCrash", 310329)
	self:Log("SPELL_AURA_APPLIED", "MutteringsofInsanityApplied", 310358)
	self:Log("SPELL_AURA_REMOVED", "MutteringsofInsanityRemoved", 310358)
	self:Log("SPELL_AURA_APPLIED", "VoidInfusedIchor", 308377)

	self:Log("SPELL_CAST_START", "AcidSplash", 310580)
	self:Death("EyeDeath", 157612) -- Eye of Drest'agath
	self:Death("TentacleDeath", 157614) -- Tentacle of Drest'agath
	self:Death("MawDeath", 157613) -- Maw of Drest'agath
end

function mod:OnEngage()
	self:Bar(310329, 15) -- Entropic Crash
	self:Bar(310358, 30) -- Mutterings of Insanity
	self:Bar(310390, 45.5) -- Void Glare
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 310351 then -- Mutterings of Insanity
		self:Bar(310358, 51)
	elseif spellId == 310390 then -- Void Glare
		self:Message2(spellId, "orange")
		self:PlaySound(spellId, "alert")
		self:Bar(spellId, 46)
	end
end

function mod:ThroesofAgony(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
end

function mod:VoidGrip(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:VolatileSeed(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 17)
	self:TargetBar(args.spellId, 10, args.destName)
	if self:Me(args.destGUID) then
		self:SayCountdown(args.spellId, 10)
	end
end

function mod:VolatileSeedRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:EntropicCrash(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 45)
end

do
	local playerList = mod:NewTargetList()
	function mod:MutteringsofInsanityApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:MutteringsofInsanityRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:VoidInfusedIchor(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Say(310580)
		end
		self:TargetMessage2(310580, "red", name)
		self:PlaySound(310580, "alarm", nil, name)
	end

	function mod:AcidSplash(args)
		self:GetUnitTarget(printTarget, 0.1, args.sourceGUID)
	end
end

function mod:EyeDeath()
	self:Message2("adds", "cyan", L.eye_killed, false)
	self:PlaySound("adds", "info")
end

function mod:TentacleDeath()
	self:Message2("adds", "cyan", L.tentacle_killed, false)
	self:PlaySound("adds", "info")
end

function mod:MawDeath()
	self:Message2("adds", "cyan", L.maw_killed, false)
	self:PlaySound("adds", "info")
end
