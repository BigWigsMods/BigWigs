--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Argus the Unmaker", nil, 2031, 1712)
if not mod then return end
mod:RegisterEnableMob(124828)
mod.engageId = 2092
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		--[[ Stage 1 ]]--
		248165, -- Cone of Death
		248317, -- Blight Orb
		{248396, "ME_ONLY", "SAY", "FLASH"}, -- Wasting Plague
		248167, -- Death Fog
		257296, -- Tortured Rage
		248499, -- Sweeping Scythe
		255594, -- Sky and Sea

		--[[ Stage 2 ]]--
		252280, -- Volatile Soul
		250669, -- Soul Burst
		251570, -- Soul Bomb
		251815, -- Edge of Obliteration
		255199, -- Avatar of Aggramar
		255200, -- Aggramar's Boon
	},{
		["stages"] = "general",
		[248165] = CL.stage:format(1),
		[252280] = CL.stage:format(2),
		--[248165] = CL.stage:format(3),
		--[248165] = CL.stage:format(4),
	}
end

function mod:OnBossEnable()
	--[[ Stage 1 ]]--
	self:Log("SPELL_CAST_START", "ConeofDeath", 248165)
	self:Log("SPELL_CAST_START", "BlightOrb", 248317)
	self:Log("SPELL_AURA_APPLIED", "WastingPlague", 248396)
	self:Log("SPELL_AURA_REMOVED", "WastingPlagueRemoved", 248396)
	self:Log("SPELL_CAST_START", "TorturedRage", 257296)
	self:Log("SPELL_CAST_START", "SweepingScythe", 248499)
	self:Log("SPELL_AURA_APPLIED", "SweepingScytheStack", 244899)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SweepingScytheStack", 244899)
	self:Log("SPELL_CAST_START", "SkyandSea", 255594)
	self:Log("SPELL_AURA_APPLIED", "StrengthoftheSkyandSea", 253901, 253903) -- Strength of the Sea, Strength of the Sky
	self:Log("SPELL_AURA_APPLIED_DOSE", "StrengthoftheSkyandSea", 253901, 253903) -- Strength of the Sea, Strength of the Sky

	--[[ Stage 2 ]]--
	self:Log("SPELL_CAST_START", "GolgannethsWrath", 256674)
	self:Log("SPELL_CAST_START", "VolatileSoul", 252280)
	self:Log("SPELL_AURA_APPLIED", "Soulburst", 250669)
	self:Log("SPELL_AURA_REMOVED", "SoulburstRemoved", 248396)
	self:Log("SPELL_AURA_APPLIED", "Soulbomb", 251570)
	self:Log("SPELL_AURA_REMOVED", "SoulbombRemoved", 248396)
	self:Log("SPELL_CAST_SUCCESS", "EdgeofObliteration", 251815)
	self:Log("SPELL_AURA_APPLIED", "AvatarofAggramar", 255199)
	self:Log("SPELL_AURA_APPLIED", "AggramarsBoon", 255200)

	-- Ground Effects
	self:Log("SPELL_AURA_APPLIED", "GroundEffects", 248167) -- Death Fog
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffects", 248167) -- Death Fog
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffects", 248167) -- Death Fog
end

function mod:OnEngage()
	stage = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Stage 1 ]]--
function mod:ConeofDeath(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:BlightOrb(args)
	self:Message(args.spellId, "Neutral", "Info")
end

function mod:WastingPlague(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:TargetBar(args.spellId, 8, args.destName)
	end
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Warning")
end

function mod:WastingPlagueRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:TorturedRage(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:SweepingScythe(args)
	self:Message(args.spellId, "Neutral", "Alert")
end

function mod:SweepingScytheStack(args)
	if self:Me(args.destGUID) or self:Tank() then -- Always Show for Tanks and when on Self
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", self:Tank() and (amount > 2 and "Alarm") or "Warning") -- Warning sound for non-tanks, 3+ stacks warning for tanks
	end
end

function mod:SkyandSea(args)
	self:Message(args.spellId, "Positive", "Long", CL.incoming:format(args.spellName))
end

function mod:StrengthoftheSkyandSea(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(255594, args.destName, amount, "Positive", "Long", args.spellName)
	end
end

--[[ Stage 2 ]]--
function mod:GolgannethsWrath()
	stage = 2
	self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
end

function mod:VolatileSoul(args)
	self:Message(args.spellId, "Attention", "Alert")
end

do
	local playerList = mod:NewTargetList()
	function mod:Soulburst(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 15)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end

	function mod:SoulburstRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:Soulbomb(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 15)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
end

function mod:SoulbombRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:EdgeofObliteration(args)
	self:Message(args.spellId, "Attention", "Alarm")
end

function mod:AvatarofAggramar(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Long", nil, nil, true)
end

function mod:AggramarsBoon(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Info")
	end
end

-- Ground Effects
do
	local prev = 0
	function mod:GroundEffects(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName)) -- Death Fog
		end
	end
end
