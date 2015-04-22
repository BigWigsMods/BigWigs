
-- Notes --
-- Fel Rupture is instant? (and is hidden?)
-- Globules spawn instantly on APPLIED?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Kilrogg Deadeye", 1026, 1396)
if not mod then return end
mod:RegisterEnableMob(90378)
--mod.engageId = 0

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local deathThroesCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Kilrogg Deadeye ]]--
		{180372, "FLASH", "SAY"}, -- Heart Seeker
		182428, -- Vision of Death
		180224, -- Death Throes
		{180199, "TANK"}, -- Shred Armor
		187089, -- Cleansing Aura
		--[[ Salivating Bloodthirster ]]--
		-11266, -- Salivating Bloodthirster
		--[[ Hulking Terror ]]--
		183917, -- Rending Howl
		180163, -- Savage Strikes
		--[[ Hellblaze Imp ]]--
		180618, -- Fel Blaze
		--[[ Hellblaze Mistress ]]--
		180033, -- Cinder Breath
		--[[ General ]]--
		"altpower",
		"berserk",
	}, {
		[180372] = self.displayName, -- Kilrogg Deadeye
		[-11266] = -11266, -- Salivating Bloodthirster
		[183917] = -11269, -- Hulking Terror
		[180618] = -11274, -- Hellblaze Imp
		[180033] = -11278, -- Hellblaze Mistress
		["altpower"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "HeartSeeker", 180372)
	self:Log("SPELL_CAST_START", "VisionOfDeath", 182428)
	self:Log("SPELL_CAST_START", "DeathThroes", 180224)
	self:Log("SPELL_CAST_START", "ShredArmor", 180199)
	self:Log("SPELL_AURA_APPLIED", "ShreddedArmor", 180200)
	self:Log("SPELL_AURA_APPLIED", "CleansingAura", 187089)

	self:Log("SPELL_CAST_SUCCESS", "BloodthirsterSpawn", 181113) -- Encounter Spawn

	self:Log("SPELL_CAST_START", "RendingHowl", 183917)
	self:Log("SPELL_CAST_START", "SavageStrikes", 180163)

	self:Log("SPELL_CAST_START", "FelBlaze", 180618)

	self:Log("SPELL_CAST_START", "CinderBreath", 180033)

	self:Death("Kill", 90378)
end

function mod:OnEngage()
	deathThroesCount = 0
	self:Message("berserk", "Neutral", nil, "Kilrogg (beta) engaged", false)
	self:OpenAltPower("altpower", 182159) -- Fel Corruption
end

function mod:Kill()
	self:Message("berserk", "Neutral", nil, "Kilrogg (beta) killed", false)
	self:Wipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Kilrogg Deadeye ]]--

do
	local list = mod:NewTargetList()
	function mod:HeartSeeker(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Important", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:TargetBar(args.spellId, 5, args.destName)
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

function mod:VisionOfDeath(args)
	self:Message(args.spellId, "Positive", "Long")
	self:Bar(args.spellId, 8)
end

function mod:DeathThroes(args)
	deathThroesCount = deathThroesCount + 1
	self:Message(args.spellId, "Urgent", "Long", CL.count:format(args.spellName, deathThroesCount))
	self:Bar(args.spellId, 9, CL.count:format(args.spellName, deathThroesCount))
end

function mod:ShredArmor(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 1.7)
end

function mod:ShreddedArmor(args) -- Tank Failed
	self:TargetMessage(180199, args.destName, "Important", nil, args.spellId)
	self:TargetBar(180199, 30, args.destName, args.spellId)
end

function mod:CleansingAura(args)
	self:TargetMessage(args.spellId, args.destName, "Positive")
end

--[[ Salivating Bloodthirster ]]--

function mod:BloodthirsterSpawn(args)
	if self:MobId(args.sourceGUID) == 93369 then -- Salivating Bloodthirster
		self:Message(-11266, "Attention", "Info")
	end
end

--[[ Hulking Terror ]]--

function mod:RendingHowl(args)
	self:Message(args.spellId, "Urgent", not self:Healer() and "Info", CL.casting:format(args.spellName))
end

function mod:SavageStrikes(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 6)
end

--[[ Hellblaze Imp ]]--

function mod:FelBlaze(args)
	self:Message(args.spellId, "Attention", "Long")
	self:Bar(args.spellId, 10)
end

--[[ Hellblaze Mistress ]]--

function mod:CinderBreath(args)
	self:Message(args.spellId, "Attention", "Long")
	self:Bar(args.spellId, 4.5)
end

