
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kilrogg Deadeye", 1026, 1396)
if not mod then return end
mod:RegisterEnableMob(90378)
mod.engageId = 1786
mod.respawnTime = 14

--------------------------------------------------------------------------------
-- Locals
--

local deathThroesCount = 0
local visionCount = 1
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.add_warnings = "Add Spawn Warnings"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Kilrogg Deadeye ]]--
		{188929, "FLASH", "SAY"}, -- Heart Seeker
		182428, -- Vision of Death
		180224, -- Death Throes
		{180199, "TANK"}, -- Shred Armor
		187089, -- Cleansing Aura
		--[[ Hulking Terror ]]--
		183917, -- Rending Howl
		180163, -- Savage Strikes
		--[[ Hellblaze Imp ]]--
		180618, -- Fel Blaze
		--[[ Hellblaze Mistress ]]--
		180033, -- Cinder Breath
		--[[ Add Spawn Warnings ]]--
		-11269, -- Hulking Terror
		-11266, -- Salivating Bloodthirster
		-11261, -- Blood Globule
		-11263, -- Fel Blood Globule
		--[[ General ]]--
		"altpower",
	}, {
		[188929] = self.displayName, -- Kilrogg Deadeye
		[183917] = -11269, -- Hulking Terror
		[180618] = -11274, -- Hellblaze Imp
		[180033] = -11278, -- Hellblaze Mistress
		[-11266] = L.add_warnings,
		["altpower"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "HeartSeeker", 188929)
	self:Log("SPELL_CAST_START", "VisionOfDeath", 182428)
	self:Log("SPELL_CAST_START", "DeathThroes", 180224)
	self:Log("SPELL_CAST_START", "ShredArmor", 180199)
	self:Log("SPELL_AURA_APPLIED", "CleansingAura", 187089)

	self:Log("SPELL_CAST_START", "RendingHowl", 183917)
	self:Log("SPELL_CAST_START", "SavageStrikes", 180163)

	self:Log("SPELL_CAST_START", "FelBlaze", 180618)

	self:Log("SPELL_CAST_START", "CinderBreath", 180033)
end

function mod:OnEngage()
	deathThroesCount = 0
	visionCount = 1
	wipe(mobCollector)
	self:CDBar(182428, 60, CL.count:format(self:SpellName(182428), visionCount)) -- Vision of Death
	self:CDBar(188929, 25) -- Heart Seeker
	self:CDBar(180199, 10.8) -- Shred Armor
	self:OpenAltPower("altpower", 182159) -- Fel Corruption
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local adds = {
		[93369] = -11269, -- Hulking Terror
		[90521] = -11266, -- Salivating Bloodthirster
		[90477] = -11261, -- Blood Globule
		[90513] = -11263, -- Fel Blood Globule
	}
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		for i = 1, 5 do
			local guid = UnitGUID("boss"..i)
			if guid and not mobCollector[guid] then
				mobCollector[guid] = true
				local id = adds[self:MobId(guid)]
				if id then
					self:Message(id, "Neutral", "Info", self:SpellName(id), false)
				end
			end
		end
	end

	function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
		if spellId == 182012 then -- Max Health Increase
			self:Message(-11269, "Neutral", "Info", self:SpellName(-11269), false) -- Hulking Terror
		end
	end
end

--[[ Kilrogg Deadeye ]]--

do
	local list = mod:NewTargetList()
	function mod:HeartSeeker(args)
		if self:MobId(args.destGUID) == 90378 then return end

		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Important", "Alarm")
			self:CDBar(args.spellId, 25.5) -- 25.5-32.9
		end
		if self:Me(args.destGUID) then
			self:TargetBar(args.spellId, 5, args.destName)
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

function mod:VisionOfDeath(args)
	self:Message(args.spellId, "Positive", "Long", CL.count:format(args.spellName, visionCount))
	self:Bar(args.spellId, 8, CL.cast:format(CL.count:format(args.spellName, visionCount)))
	visionCount = visionCount + 1
	self:CDBar(args.spellId, 75.5, CL.count:format(args.spellName, visionCount)) -- 75.5-84.2
end

function mod:DeathThroes(args)
	deathThroesCount = deathThroesCount + 1
	self:Message(args.spellId, "Urgent", "Long", CL.count:format(args.spellName, deathThroesCount))
	self:Bar(args.spellId, 9, CL.count:format(args.spellName, deathThroesCount))
end

function mod:ShredArmor(args)
	if UnitDetailedThreatSituation("player", "boss1") then
		self:Message(args.spellId, "Important", "Warning")
	end
	self:CDBar(args.spellId, 17) -- 17s but can be delayed by other abilities
end

function mod:CleansingAura(args)
	self:TargetMessage(args.spellId, args.destName, "Positive")
end

--[[ Hulking Terror ]]--

function mod:RendingHowl(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
end

function mod:SavageStrikes(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 6)
end

--[[ Hellblaze Imp ]]--

do
	local prev = 0
	function mod:FelBlaze(args)
		if UnitBuff("player", self:SpellName(185458)) then -- Vision of Death
			local t = GetTime()
			if t-prev > 3 then
				prev = t
				self:Message(args.spellId, "Attention")
				self:Bar(args.spellId, 10)
			end
		end
	end
end

--[[ Hellblaze Mistress ]]--

do
	local prev = 0
	function mod:CinderBreath(args)
		if UnitBuff("player", self:SpellName(185458)) then -- Vision of Death
			local t = GetTime()
			if t-prev > 3 then
				prev = t
				self:Message(args.spellId, "Attention")
				self:Bar(args.spellId, 4.5)
			end
		end
	end
end

