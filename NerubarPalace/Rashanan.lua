if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rasha'nan", 2657, 2609)
if not mod then return end
mod:RegisterEnableMob(224552) -- Rasha'nan XXX Confirm on PTR
mod:SetEncounterID(2918)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--


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
		439815, -- Infested Spawn XXX Private
		455287, -- Infested Bite
		{439784, "SAY"}, -- Spinneret's Strands
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
	self:Log("SPELL_CAST_SUCCESS", "InfestedSpawn", 439815)
	self:Log("SPELL_AURA_APPLIED", "InfestedBiteApplied", 455287)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfestedBiteApplied", 455287)
	self:Log("SPELL_CAST_START", "SpinneretsStrands", 439784)
	self:Log("SPELL_AURA_APPLIED", "SpinneretsStrandsTarget", 439783)
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
	-- self:Bar(444687, 6) -- Savage Assault
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
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	-- self:Bar(args.spellId, 10)
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
	self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	-- self:Bar(args.spellId, 10)
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
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	-- self:Bar(args.spellId, 10)
end

function mod:SpinneretsStrandsTarget(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(439784)
		self:Say(439784, L.spinnerets_strands_say, nil, "Strands")
		self:PlaySound(439784, "warning")
	end
end

function mod:WebReave(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	-- self:Bar(args.spellId, 10)
end

function mod:ErosiveSpray(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	-- self:Bar(args.spellId, 10)
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
