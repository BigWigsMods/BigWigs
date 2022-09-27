if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Terros", 2522, 2500)
if not mod then return end
mod:RegisterEnableMob(190496) -- Terros
mod:SetEncounterID(2639)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then

end

--------------------------------------------------------------------------------
-- Initialization
--

local rockBlastMarker = mod:AddMarkerOption(true, "player", 1, 380487, 1, 2, 3, 4, 5) -- Rock Blast
function mod:GetOptions()
	return {
		{380487, "SAY", "SAY_COUNTDOWN"}, -- Rock Blast
		rockBlastMarker,
		377166, -- Resonating Annihilation
		382458, -- Resonant Aftermath
		383073, -- Shattering Impact
		376279, -- Concussive Slam
		377505, -- Frenzied Devastation
		388393, -- Tectonic Barrage
	}, {

	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "RockBlastApplied", 386352)
	self:Log("SPELL_AURA_REMOVED", "RockBlastRemoved", 386352)
	self:Log("SPELL_CAST_START", "ResonatingAnnihilation", 377166)
	self:Log("SPELL_CAST_START", "ShatteringImpact", 383073)
	self:Log("SPELL_CAST_START", "ConcussiveSlam", 376279)
	self:Log("SPELL_AURA_APPLIED", "ConcussiveSlamApplied", 376276)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConcussiveSlamApplied", 376276)
	self:Log("SPELL_CAST_START", "FrenziedDevastation", 377505)

	self:Log("SPELL_AURA_APPLIED", "TectonicBarrage", 388393)
	self:Log("SPELL_DAMAGE", "TectonicBarrage", 388393)
	self:Log("SPELL_MISSED", "TectonicBarrage", 388393)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 382458) -- Resonant Aftermath
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 382458)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 382458)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local playerList = {}
	local prev = 0
	function mod:RockBlastApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			--self:Bar(380487, 30)
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(380487, "warning")
			self:Say(380487, CL.count_rticon:format(args.spellName, icon, icon))
			self:SayCountdown(380487, 10, icon)
		end
		self:TargetsMessage(380487, "orange", playerList)
		self:CustomIcon(rockBlastMarker, args.destName, icon)
	end

	function mod:RockBlastRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(380487)
		end
		self:CustomIcon(rockBlastMarker, args.destName)
	end
end

function mod:ResonatingAnnihilation(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	--self:Bar(args.spellId, 100)
end

function mod:ShatteringImpact(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20)
end

function mod:ConcussiveSlam(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 20)
end

function mod:ConcussiveSlamApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		self:StackMessage(376279, "purple", args.destName, args.amount, 0)
		self:PlaySound(376279, "warning")
	elseif self:Me(args.destGUID) then -- Not a tank
		self:StackMessage(376279, "blue", args.destName, args.amount, 0)
		self:PlaySound(376279, "warning")
	end
end

function mod:FrenziedDevastation(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 20)
end

do
	local prev = 0
	function mod:TectonicBarrage(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alarm")
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
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
