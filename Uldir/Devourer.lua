
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fetid Devourer", 1861, 2146)
if not mod then return end
mod:RegisterEnableMob(133298)
mod.engageId = 2128
mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local trashCount = 0
local stompCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.breath = "{262292} ({18609})" -- Rotting Regurgitation (Breath)
	L.breath_desc = 262292
	L.breath_icon = 262292
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{262277, "TANK"}, -- Thrashing Terror
		"breath", -- Rotting Regurgitation
		262288, -- Shockwave Stomp
		{262313, "ME_ONLY", "SAY", "SAY_COUNTDOWN"}, -- Malodorous Miasma
		{262314, "ME_ONLY", "FLASH", "SAY", "SAY_COUNTDOWN"}, -- Putrid Paroxysm
		262364, -- Enticing Essence -- XXX Used for CL.adds right now
		262378, -- Fetid Frenzy
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "TerribleThrash", 262277)
	self:Log("SPELL_CAST_START", "RottingRegurgitation", 262292)
	self:Log("SPELL_CAST_START", "ShockwaveStomp", 262288)
	self:Log("SPELL_CAST_SUCCESS", "ShockwaveStompSuccess", 262288) -- sometimes doesn't finish the cast, increasing counter on _SUCCESS
	self:Log("SPELL_AURA_APPLIED", "MalodorousMiasmaApplied", 262313)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MalodorousMiasmaApplied", 262313)
	self:Log("SPELL_AURA_REMOVED", "MalodorousMiasmaRemoved", 262313)
	self:Log("SPELL_AURA_APPLIED", "PutridParoxysmApplied", 262314)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PutridParoxysmApplied", 262314)
	self:Log("SPELL_AURA_REMOVED", "PutridParoxysmRemoved", 262314)
	self:Log("SPELL_CAST_START", "EnticingEssence", 262364)
	self:Log("SPELL_AURA_APPLIED", "FetidFrenzy", 262378)

	-- Adds spawning
	self:Log("SPELL_CAST_SUCCESS", "TrashChuteVisualState", 274470)
end

function mod:OnEngage()
	trashCount = 0
	stompCount = 1
	self:CDBar(262277, 5.5) -- Terrible Thrash
	self:CDBar("breath", self:Easy() and 30.5 or 41.5, 18609, 262292) -- Breath (Rotting Regurgitation)
	if not self:Easy() then
		self:Bar(262288, 26, CL.count:format(self:SpellName(262288), stompCount)) -- Shockwave Stomp
	end
	self:Bar(262364, self:Easy() and 50 or 35.5, self:SpellName(-18875)) -- Waste Disposal Units
	self:Berserk(330)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TerribleThrash(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 6)
end

function mod:RottingRegurgitation(args)
	self:Message2("breath", "yellow", 18609, 262292) -- Breath (Rotting Regurgitation)
	self:PlaySound("breath", "alert")
	self:CDBar("breath", self:Easy() and 30.5 or 46, 18609, 262292) -- 41.3, 52.1, 46.3, 41.9, 32.6, 34.1 XXX
	self:CastBar("breath", 6.5, 18609, 262292)
end

function mod:ShockwaveStomp(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:ShockwaveStompSuccess(args)
	stompCount = stompCount + 1
	self:Bar(args.spellId, 26.5, CL.count:format(args.spellName, stompCount))
end

function mod:MalodorousMiasmaApplied(args)
	local amount = args.amount or 1
	if amount == 1 then
		self:TargetMessage2(args.spellId, "orange", args.destName)
	else
		self:StackMessage(args.spellId, args.destName, args.amount, "orange")
	end
	self:PlaySound(args.spellId, self:Mythic() and "warning" or "info", nil, args.destName) -- spread in Mythic
	if self:Mythic() and self:Me(args.destGUID) then
		if amount == 1 then
			self:Say(args.spellId)
		end
		self:CancelSayCountdown(args.spellId)
		self:SayCountdown(args.spellId, 18)
	end
end

function mod:MalodorousMiasmaRemoved(args)
	if self:Mythic() and self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:PutridParoxysmApplied(args)
	local amount = args.amount or 1
	if amount == 1 then
		self:TargetMessage2(args.spellId, "orange", args.destName)
	else
		self:StackMessage(args.spellId, args.destName, args.amount, "orange")
	end
	self:PlaySound(args.spellId, "warning", nil, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		if self:Mythic() then
			if amount == 1 then
				self:Say(args.spellId)
			end
			self:CancelSayCountdown(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
	end
end

function mod:PutridParoxysmRemoved(args)
	if self:Mythic() and self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

do
	local prev = 0
	function mod:EnticingEssence(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:FetidFrenzy(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:TrashChuteVisualState()
	trashCount = trashCount + 1
	if (self:Mythic() and trashCount % 3 == 2) or (not self:Mythic() and trashCount % 2 == 1) then -- Small add
		self:Message2(262364, "cyan", CL.incoming:format(self:SpellName(-17867)))
		self:PlaySound(262364, "long")
		if not self:Mythic() then
			self:Bar(262364, self:Mythic() and 75 or self:Easy() and 60 or 55, self:SpellName(-18875)) -- Waste Disposal Units
			self:Bar(262364, 10, CL.spawning:format(CL.adds)) -- Adds / Enticing Essence
		end
	elseif (self:Mythic() and trashCount % 3 == 1) then -- Big Add
		self:Message2(262364, "cyan", CL.incoming:format(self:SpellName(-18565)))
		self:PlaySound(262364, "long")
		self:Bar(262364, 75, self:SpellName(-18875)) -- Waste Disposal Units
		self:Bar(262364, 20, CL.spawning:format(CL.adds)) -- Adds
	end
end
