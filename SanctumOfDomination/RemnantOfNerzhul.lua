--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Remnant of Ner'zhul", 2450, 2444)
if not mod then return end
mod:RegisterEnableMob(175729, 177117) -- Remnant of Ner'zhul, Orb of Torment
mod:SetEncounterID(2432)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local tankList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.slow = mod:SpellName(31589) -- Slow
end

--------------------------------------------------------------------------------
-- Initialization
--

local malevolenceMarker = mod:AddMarkerOption(false, "player", 1, 350469, 1, 2, 3, 4, 5) -- Malevolence
function mod:GetOptions()
	return {
		350073, -- Torment
		350388, -- Thermal Lament
		{350469, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Malevolence (Bombs)
		malevolenceMarker,
		350489, -- Lingering Malevolence
		{349889, "SAY", "SAY_COUNTDOWN"}, -- Blight
		349890, -- Suffering
		353332, -- Grasp of Malice
		--350671, -- Aura of Spite
		351066, -- Shatter
	},{
	},{
		[350388] = L.slow, -- Thermal Lament (Slow)
		[350469] = CL.bombs, -- Malevolence (Bombs)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TormentApplied", 350073)
	self:Log("SPELL_AURA_APPLIED", "ThermalLamentApplied", 350388)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ThermalLamentApplied", 350388)
	self:Log("SPELL_CAST_START", "MalevolenceStart", 350469)
	self:Log("SPELL_AURA_APPLIED", "MalevolenceApplied", 350469)
	self:Log("SPELL_AURA_REMOVED", "MalevolenceRemoved", 350469)
	self:Log("SPELL_AURA_APPLIED", "BlightApplied", 349889)
	self:Log("SPELL_AURA_APPLIED", "SufferingApplied", 349890)
	self:Log("SPELL_CAST_START", "GraspOfMalice", 353332, 355123)
	--self:Log("SPELL_AURA_APPLIED", "AuraOfSpiteApplied", 350671)
	--self:Log("SPELL_AURA_APPLIED_DOSE", "AuraOfSpiteApplied", 350671)
	self:Log("SPELL_CAST_START", "Shatter", 351066)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 350489) -- Lingering Malevolence
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 350489)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 350489)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TormentApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ThermalLamentApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:NewStackMessage(args.spellId, "blue", args.destName, amount, 3, L.slow) -- Perhaps warn with slow% in the message
		if amount > 2 then -- 45%+ slow
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	-- TODO:
	-- - Mark players ordered by duration left so you always know which expires first

	local playerList = {}
	function mod:MalevolenceStart(args)
		playerList = {}
		self:Message(args.spellId, "yellow", CL.incoming:format(CL.bombs))
		--self:Bar(args.spellId, 20, CL.bombs)
	end

	function mod:MalevolenceApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			local _, _, _, expires = self:UnitDebuff("player", args.spellId)
			if expires and expires > 0 then
				local timeLeft = expires - GetTime()
				self:TargetBar(args.spellId, timeLeft, args.destName)
				self:Say(args.spellId, CL.bomb)
				self:SayCountdown(args.spellId, timeLeft)
				self:PlaySound(args.spellId, "warning")
			end
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, self:Mythic() and 100 or 2, CL.bomb)
		self:CustomIcon(malevolenceMarker, args.destName, count)
	end

	function mod:MalevolenceRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(args.spellId, args.destName)
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(malevolenceMarker, args.destName)
	end
end

function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

function mod:BlightApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:TargetBar(args.spellId, 6, args.destName)
	if self:Tank() then
		self:PlaySound(args.spellId, "warning", args.destName)
	end
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
	--self:Bar(args.spellId, 20)
end

function mod:SufferingApplied(args)
	if self:Me(args.destGUID) and not self:Tank() then -- Non-tank player warnings
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	elseif self:Tank() and self:Tank(args.destName) then -- Tank warnings
		self:TargetMessage(args.spellId, "purple", args.destName)
		local bossUnit = self:GetBossId(args.sourceGUID)
		if bossUnit and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "warning") -- Why didnt you taunt on Blight?
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

-- function mod:AuraOfSpiteApplied(args)
-- 	local amount = args.amount or 1
-- 	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, amount)) -- Aura of Spite (4) // 4 = level/stacks on boss
-- 	self:PlaySound(args.spellId, "info")
-- end

function mod:GraspOfMalice(args)
	self:Message(353332, "yellow")
	self:PlaySound(353332, "alert")
	--self:Bar(353332, 42)
end

function mod:Shatter(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
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
