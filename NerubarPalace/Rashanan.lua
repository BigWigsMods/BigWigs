if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rasha'nan", 2657, 2609)
if not mod then return end
mod:RegisterEnableMob(214504) -- Rasha'nan
mod:SetEncounterID(2918)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	439790, -- Rolling Acid
	{439815, extra = {455284}}, -- Infested Spawn
	{439783, extra = {434090}}, -- Spinneret's Strands (XXX are both used?)
})

--------------------------------------------------------------------------------
-- Locals
--

local infestedSpawnCount = 1
local rollingAcidCount = 1
local erosiveSprayCount = 1
local spinneretsStrandsCount = 1
local webReaveCount = 1

local timers = { -- Heroic PTR
	[455373] = {59.1, 84.8, 76.8, 29.8, 20.2, 78.9, 123.2, 57.4, 29.8, 20.2}, -- Infested Spawn
	[439789] = {41.5, 78.7, 30.3, 19.7, 96.5, 103.6, 59.5, 29.8, 20.2, 77.1}, -- Rolling Acid
	[439811] = {3.1, 29.7, 44.4, 59.5, 44.4, 57.7, 44.4, 59.1, 44.4, 59.6, 44.5, 57.4, 44.4}, -- Erosive Spray
	[439784] = {14.2, 29.8, 20.2, 98.4, 83.0, 78.3, 30.3, 19.7, 79.3, 121.1}, -- Spinneret's Strands
	[439795] = {107.0, 102.1, 103.6, 104.0, 101.9}, -- Web Reave
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spinnerets_strands_say = "Strands"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{444687, "TANK"}, -- Savage Assault
		{458067, "TANK"}, -- Savage Wound
		439789, -- Rolling Acid
		439787, -- Acidic Stupor
		439785, -- Corrosion
		439776, -- Acid Pool
		{455373, "PRIVATE"}, -- Infested Spawn
		455287, -- Infested Bite
		{439784, "PRIVATE"}, -- Spinneret's Strands
		--439780, -- Sticky Webs XXX gtfo?
		439795, -- Web Reave
		439811, -- Erosive Spray
		452806, -- Acidic Eruption
		457877, -- Acidic Carapace
		456853, -- Caustic Hail
		439792, -- Tacky Burst
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SavageAssault", 444687)
	self:Log("SPELL_AURA_APPLIED", "SavageWoundApplied", 458067)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SavageWoundApplied", 458067)
	self:Log("SPELL_CAST_START", "RollingAcid", 439789)
	self:Log("SPELL_AURA_APPLIED", "AcidicStuporApplied", 439787)
	self:Log("SPELL_AURA_APPLIED", "CorrosionApplied", 439785)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CorrosionApplied", 439785)
	self:Log("SPELL_CAST_START", "InfestedSpawn", 455373)
	self:Log("SPELL_AURA_APPLIED", "InfestedBiteApplied", 455287)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfestedBiteApplied", 455287)
	self:Log("SPELL_CAST_START", "SpinneretsStrands", 439784)
	self:Log("SPELL_CAST_START", "WebReave", 439795)
	self:Log("SPELL_CAST_START", "ErosiveSpray", 439811)
	self:Log("SPELL_CAST_START", "AcidicEruption", 452806)
	self:Log("SPELL_AURA_APPLIED", "AcidicCarapace", 457877)
	self:Log("SPELL_CAST_START", "CausticHail", 456853, 456762, 456841) -- XXX Confirm on PTR which is used
	self:Log("SPELL_CAST_SUCCESS", "TackyBurst", 439792)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 439776) -- Acid Pool
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 439776)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 439776)
end

function mod:OnEngage()
	infestedSpawnCount = 1
	rollingAcidCount = 1
	erosiveSprayCount = 1
	spinneretsStrandsCount = 1
	webReaveCount = 1

	self:CDBar(455373, timers[455373][infestedSpawnCount], CL.count:format(self:SpellName(455373), infestedSpawnCount)) -- Infested Spawn
	self:CDBar(439789, timers[439789][rollingAcidCount], CL.count:format(self:SpellName(439789), rollingAcidCount)) -- Rolling Acid
	self:CDBar(439811, timers[439811][erosiveSprayCount], CL.count:format(self:SpellName(439811), erosiveSprayCount)) -- Erosive Spray
	self:CDBar(439784, timers[439784][spinneretsStrandsCount], CL.count:format(self:SpellName(439784), spinneretsStrandsCount)) -- Spinneret's Strands
	self:CDBar(439795, timers[439795][webReaveCount], CL.count:format(self:SpellName(439795), webReaveCount)) -- Web Reave
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SavageAssault(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 10)
end

function mod:SavageWoundApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end


function mod:RollingAcid(args)
	self:StopBar(CL.count:format(args.spellName, rollingAcidCount))
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	rollingAcidCount = rollingAcidCount + 1
	self:CDBar(args.spellId, timers[args.spellId][rollingAcidCount], CL.count:format(args.spellName, rollingAcidCount))
end

function mod:AcidicStuporApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CorrosionApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:InfestedSpawn(args)
	self:StopBar(CL.count:format(args.spellName, infestedSpawnCount))
	self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	infestedSpawnCount = infestedSpawnCount + 1
	self:CDBar(args.spellId, timers[args.spellId][infestedSpawnCount], CL.count:format(args.spellName, infestedSpawnCount))
end

function mod:InfestedBiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 5)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:SpinneretsStrands(args)
	self:StopBar(CL.count:format(args.spellName, spinneretsStrandsCount))
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	spinneretsStrandsCount = spinneretsStrandsCount + 1
	self:CDBar(args.spellId, timers[args.spellId][spinneretsStrandsCount], CL.count:format(args.spellName, spinneretsStrandsCount))
end

function mod:WebReave(args)
	self:StopBar(CL.count:format(args.spellName, webReaveCount))
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	webReaveCount = webReaveCount + 1
	self:CDBar(args.spellId, timers[args.spellId][webReaveCount], CL.count:format(args.spellName, webReaveCount))
end

function mod:ErosiveSpray(args)
	self:StopBar(CL.count:format(args.spellName, erosiveSprayCount))
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	erosiveSprayCount = erosiveSprayCount + 1
	self:CDBar(args.spellId, timers[args.spellId][erosiveSprayCount], CL.count:format(args.spellName, erosiveSprayCount))
end

function mod:AcidicEruption(args)
	local _, ready = self:Interrupter(args.sourceGUID)
	self:Message(args.spellId, "yellow")
	if ready then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:AcidicCarapace(args)
	self:Message(args.spellId, "cyan", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:CausticHail(args)
	self:Message(456853, "cyan")
	self:PlaySound(456853, "info")
	-- self:Bar(456853, 10)
end

function mod:TackyBurst(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time-prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
