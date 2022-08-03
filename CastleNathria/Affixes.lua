
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Castle Nathria Affixes", 2296)
if not mod then return end
mod.displayName = CL.affixes
mod:RegisterEnableMob(
	164406, -- Shriekwing
	165066, 165067, 169457, 169458, -- Huntsman Altimor, Margore, Bargast, Hecutis
	164261, -- Hungering Destroyer
	166644, -- Artificer Xy'mox
	165805, 165759, 168973, -- Shade of Kael'thas, Kael'thas, High Torturer Darithos
	165521, -- Lady Inerva Darkvein
	166969, 166970, 166971, -- Baroness Frieda, Lord Stavros, Castellan Niklaus
	164407, -- Sludgefist
	168112, 168113, -- General Kaal, General Grashaal
	167406 -- Sire Denathrius
)

--------------------------------------------------------------------------------
-- Locals
--

local chaoticDestructionCount = 1
local creationSparkCount = 1
local barrierCount = 1
local emitterCount = 1
local p2EmitterCount = 0

local bar_icon_texture = "|A:ui-ej-icon-empoweredraid-large:0:0|a "
local bar_icon = bar_icon_texture

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_bar_icon = "Bar Icon"
	L.custom_on_bar_icon_desc = bar_icon_texture.."Show the Fated Raid icon on bars."

	L.barrier = "Barrier"
	L.emitter = "Interrupt Add"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_on_bar_icon",
		372638, -- Chaotic Destruction
		369505, -- Creation Spark
		371447, -- Protoform Barrier
		371254, -- Reconfiguration Emitter
	}, nil, {
		[371447] = L.barrier, -- Protoform Barrier (Barrier)
		[371254] = L.emitter, -- Reconfiguration Emitter (Interrupt Add)
	}
end

function mod:OnBossEnable()
	-- Piggybacking off of actual boss modules
	self:RegisterMessage("BigWigs_OnBossEngage", "OnBossEngage")
	self:RegisterMessage("BigWigs_EncounterEnd", "EncounterEnd")

	-- Chaotic Destruction
	self:Log("SPELL_CAST_START", "ChaoticDestruction", 372638)
	-- Reconfiguration Emitter
	self:Log("SPELL_SUMMON", "ReconfigurationEmitter", 371254)
	-- Protoform Barrier
	self:Log("SPELL_AURA_APPLIED", "ProtoformBarrierApplied", 371447)
	self:Log("SPELL_AURA_REMOVED", "ProtoformBarrierRemoved", 371447)
	-- Creation Spark
	self:Log("SPELL_AURA_APPLIED", "CreationSpark", 369505)

	self.boss = nil
	self.bossModule = nil
end

function mod:EncounterEnd(_, module, _, _, _, _, status)
	if module == self.bossModule then
		self:Disable()
		if status == 0 then
			self:Enable()
		end
	end
end

function mod:OnBossEngage(_, module, diff)
	if self.isEngaged then return end

	self.isEngaged = true
	self.bossModule = module
	self.boss = module.engageId

	chaoticDestructionCount = 1
	creationSparkCount = 1
	barrierCount = 1
	emitterCount = 1

	bar_icon = self:GetOption("custom_on_bar_icon") and bar_icon_texture or ""

	-- Multi-boss engage z.z
	local boss = self.boss
	if boss == 2405 or boss == 2399 then
		-- Xymox / Sludgefist (Chaotic Destruction)
		self:Bar(372638, 11, bar_icon..CL.count:format(self:SpellName(372638), chaoticDestructionCount))

	elseif boss == 2418 or boss == 2412 or boss == 2407 then
		-- Huntsman / Council / Denathrius (Reconfiguration Emitter)
		if boss == 2412 then -- Council
			self:Log("SPELL_CAST_SUCCESS", "CouncilDanseMacabreBegins", 347376)
		elseif boss == 2407 then -- Denathrius
			self:Log("SPELL_CAST_START", "DenathriusMarchOfThePenitentStart", 328117)
			self:Log("SPELL_CAST_SUCCESS", "DenathriusIndignationSuccess", 326005)
		end

		self:Bar(371254, boss == 2407 and 25 or 5, bar_icon..CL.count:format(L.emitter, emitterCount))

	elseif boss == 2383 or boss == 2402 then
		-- Hungering Destroyer / Sun King (Protoform Barrier)
		self:Bar(371447, 15, bar_icon..CL.count:format(L.barrier, barrierCount))

	elseif boss == 2398 or boss == 2406 or boss == 2417 then
		-- Shriekwing / Darkvein / SLG (Creation Spark)
		if boss == 2398 then -- Shriekwing
			self:Log("SPELL_AURA_REMOVED", "ShriekwingBloodShroudRemoved", 328921)
		end

		self:Bar(369505, 20, bar_icon..CL.count:format(self:SpellName(369505), creationSparkCount))
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ChaoticDestruction(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	chaoticDestructionCount = chaoticDestructionCount + 1
	self:Bar(372638, 60, bar_icon..CL.count:format(args.spellName, chaoticDestructionCount))
end

function mod:ReconfigurationEmitter(args)
	self:StopBar(bar_icon..CL.count:format(L.emitter, emitterCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.emitter, emitterCount))
	self:PlaySound(args.spellId, "info")
	emitterCount = emitterCount + 1
	if self.boss == 2407 then -- Denathrius
		if self:GetStage() == 1 then
			self:Bar(args.spellId, 60, CL.count:format(L.emitter, emitterCount))
		elseif self:GetStage() == 2 then
			-- XXX only seen two mythic casts
			-- first 3 normal/heroic casts are 27 84 85
			self:Bar(args.spellId, self:Mythic() and 79 or (emitterCount - p2EmitterCount) == 1 and 84 or 85, bar_icon..CL.count:format(L.emitter, emitterCount))
		elseif self:GetStage() == 3 then
			self:Bar(args.spellId, 70, bar_icon..CL.count:format(L.emitter, emitterCount))
		end
	else
		self:Bar(args.spellId, 75, bar_icon..CL.count:format(L.emitter, emitterCount))
	end
end

function mod:ProtoformBarrierApplied(args)
	if self:Player(args.destFlags) then return end -- spellsteal? lol
	self:StopBar(bar_icon..CL.count:format(L.barrier, barrierCount))
	self:Message(args.spellId, "yellow", CL.on:format(CL.count:format(L.barrier, barrierCount), args.destName))
	self:PlaySound(args.spellId, "info")
	barrierCount = barrierCount + 1
	self:Bar(args.spellId, 60, bar_icon..CL.count:format(L.barrier, barrierCount))
end

function mod:ProtoformBarrierRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(L.barrier))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = {}
	local prev = 0
	function mod:CreationSpark(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:StopBar(bar_icon..CL.count:format(args.spellName, creationSparkCount))
			creationSparkCount = creationSparkCount + 1
			if self.boss ~= 2398 or creationSparkCount % 2 == 0 then -- Shriekwing: two per stage one
				self:Bar(args.spellId, 45, bar_icon..CL.count:format(args.spellName, creationSparkCount))
			end
		end
		playerList[#playerList + 1] = args.destName
		self:NewTargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(args.spellName, creationSparkCount - 1))
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "info")
		end
	end
end

-- Boss specific timer resetting

function mod:ShriekwingBloodShroudRemoved()
	self:Bar(369505, 20, bar_icon..CL.count:format(self:SpellName(369505), creationSparkCount)) -- Creation Spark
end

function mod:CouncilDanseMacabreBegins()
	self:Bar(371254, self:Mythic() and 42 or 33.6, bar_icon..CL.count:format(L.emitter, emitterCount)) -- Reconfiguration Emitter
end

function mod:DenathriusMarchOfThePenitentStart()
	p2EmitterCount = emitterCount
	self:Bar(371254, 27, bar_icon..CL.count:format(L.emitter, emitterCount)) -- Reconfiguration Emitter
end

function mod:DenathriusIndignationSuccess()
	self:Bar(371254, 29.5, bar_icon..CL.count:format(L.emitter, emitterCount)) -- Reconfiguration Emitter
end
