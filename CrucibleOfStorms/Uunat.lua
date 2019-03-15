--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Uu'nat, Harbinger of the Void", 2096, 2332)
if not mod then return end
mod:RegisterEnableMob(145371) -- Uu'nat
mod.engageId = 2273
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local tormentCount = 0

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

local tormentMarker = mod:AddMarkerOption(false, "player", 1, 285652, 1, 2, 3, 4, 5) -- Broadside
function mod:GetOptions()
	return {
		284722, -- Umbral Shell
		284804, -- Custody of the Deep
		284583, -- Storm of Annihilation
		{284851, "TANK"}, -- Touch of the End
		285185, -- Oblivion Tear
		285410, -- Void Crash
		285376, -- Eyes of N'Zoth
		285345, -- Maddening Eyes of N'Zoth
		285367, -- Piercing Gaze of N'Zoth
		285453, -- Gift of N'Zoth: Obscurity
		{285307, "TANK"}, -- Feed
		285638, -- Gift of N'Zoth: Hysteria
		285427, -- Consume Essence
		285562, -- Unknowable Terror
		{285652, "SAY"}, -- Insatiable Torment
		tormentMarker,
		285685, -- Gift of N'Zoth: Lunacy
	},{
		[284722] = -19055, -- Relics of Power
		[284851] = -19104, -- Stage One: His All-Seeing Eyes
		[285638] = -19105, -- Stage Two: His Dutiful Servants
		[285652] = -19106, -- Stage Three: His Unwavering Gaze
	}
end

function mod:OnBossEnable()
	-- Relics of Power
	self:Log("SPELL_AURA_APPLIED", "UmbralShellApplied", 284722)
	self:Log("SPELL_AURA_APPLIED", "CustodyoftheDeepApplied", 284804)
	self:Log("SPELL_AURA_APPLIED", "StormofAnnihilationApplied", 284583)

	-- Stage One: His All-Seeing Eyes
	-- Uu'nat, Harbinger of the Void
	self:Log("SPELL_AURA_APPLIED", "TouchoftheEndApplied", 284851)
	self:Log("SPELL_CAST_START", "OblivionTear", 285185)
	self:Log("SPELL_CAST_SUCCESS", "VoidCrash", 285410)
	self:Log("SPELL_CAST_START", "EyesofNZoth", 285376)
	self:Log("SPELL_CAST_START", "MaddeningEyesofNZoth", 285345)
	self:Log("SPELL_CAST_SUCCESS", "PiercingGazeofNZoth", 285367)
	self:Log("SPELL_CAST_START", "GiftofNZothObscurity", 285453)

	-- Undying Guardian
	self:Log("SPELL_CAST_START", "Feed", 285307)

	-- Stage Two: His Dutiful Servants
	self:Log("SPELL_CAST_START", "GiftofNZothHysteria", 285638)
	self:Log("SPELL_CAST_START", "ConsumeEssence", 285427)
	self:Log("SPELL_CAST_START", "UnknowableTerror", 285562)

	-- Stage Three: His Unwavering Gaze
	self:Log("SPELL_AURA_APPLIED", "InsatiableTormentApplied", 285652)
	self:Log("SPELL_AURA_REMOVED", "InsatiableTormentRemoved", 285652)
	self:Log("SPELL_CAST_START", "GiftofNZothLunacy", 285638)
end

function mod:OnEngage()
	tormentCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UmbralShellApplied(args)
	self:TargetMessage2(args.spellId, "cyan", args.destName)
	self:PlaySound(args.spellId, "info", nil, args.destName)
end

function mod:CustodyoftheDeepApplied(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "info", nil, args.destName)
end

function mod:StormofAnnihilationApplied(args)
	self:TargetMessage2(args.spellId, "cyan", args.destName)
	self:PlaySound(args.spellId, "info", nil, args.destName)
end

-- Stage One: His All-Seeing Eyes
-- Uu'nat, Harbinger of the Void
function mod:TouchoftheEndApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:OblivionTear(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:VoidCrash(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:EyesofNZoth(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

do
	local prev = 0
	function mod:MaddeningEyesofNZoth(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:PiercingGazeofNZoth(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:GiftofNZothObscurity(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
end

-- Undying Guardian
do
	local prev = 0
	function mod:Feed(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "purple")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

-- Stage Two: His Dutiful Servants
function mod:GiftofNZothHysteria(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
end

function mod:ConsumeEssence(args)
	local _, ready = self:Interrupter(args.sourceGUID)
	if ready then
		self:Message2(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:UnknowableTerror(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 8)
end

-- Stage Three: His Unwavering Gaze
function mod:InsatiableTormentApplied(args)
	local icon = tormentCount % 5 + 1 -- Use marks 1-5
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.count_rticon:format(args.spellName, tormentCount, icon))
		self:PlaySound(args.spellId, "warning")
	end
	if self:GetOption(tormentMarker) then
		SetRaidTarget(args.destName, tormentCount)
	end
	tormentCount = tormentCount + 1
end

function mod:InsatiableTormentRemoved(args)
	if self:GetOption(tormentMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:GiftofNZothLunacy(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
end
