
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nighthold Trash", 1088)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Skorpyron to Trilliax ]]--
	115914, -- Torm the Brute
	111081, -- Fulminant
	111072, -- Pulsauron
	112255, -- Sludgerax

	--[[ Trilliax to Aluriel ]]--
	112671, -- Duskwatch Battle-Magus
	112675, -- Duskwatch Sentinel
	113307, -- Chronowraith
	112665, -- Nighthold Protector

	--[[ Aluriel to Krosos ]]--
	111210 -- Searing Infernal
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "Torm the Brute"
	L.fulminant = "Fulminant"
	L.pulsauron = "Pulsauron"
	L.sludgerax = "Sludgerax"

	--[[ Trilliax to Aluriel ]]--
	L.battle_magus = "Duskwatch Battle-Magus"
	L.sentinel = "Duskwatch Sentinel"
	L.chronowraith = "Chronowraith"
	L.protector = "Nighthold Protector"

	--[[ Aluriel to Krosos ]]--
	L.infernal = "Searing Infernal"
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		--[[ Skorpyron to Trilliax ]]--
		230438, -- Devastating Strike (Torm)
		{231086, "SAY", "FLASH"}, -- Bolder Strike (Torm)
		230482, -- Rumbling Blow (Torm)
		230488, -- Rumbling Ground (Torm)
		221164, -- Fulminate (Fulminant)
		221160, -- Compress the Void (Pulsauron)
		{223655, "SAY", "FLASH", "ICON"}, -- Oozing Rush (Sludgerax)

		--[[ Trilliax to Aluriel ]]--
		224510, -- Crackling Slice (Duskwatch Battle-Magus)
		225389, -- Protective Shield (Duskwatch Sentinel)
		225412, -- Mass Siphon (Chronowraith)
		224568, -- Mass Suppress (Nighthold Protector)
		224572, -- Disrupting Energy (Nighthold Protector)

		--[[ Aluriel to Krosos ]]--
		{221344, "SAY", "FLASH"}, -- Annihilating Orb (Searing Infernal)
	}, {
		[230438] = L.torm,
		[221164] = L.fulminant,
		[221160] = L.pulsauron,
		[223655] = L.sludgerax,
		[224510] = L.battle_magus,
		[225389] = L.sentinel,
		[225412] = L.chronowraith,
		[224568] = L.protector,
		[221344] = L.infernal,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	-- Rumbling Ground, Disrupting Energy
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 230488, 224572)
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 230488, 224572)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 230488, 224572)
	-- NPCName, ...
	--self:Log("SPELL_DAMAGE", "GroundEffectDamage", ) -- SpellName, ...
	--self:Log("SPELL_MISSED", "GroundEffectDamage", )

	--[[ Skorpyron to Trilliax ]]--
	self:Log("SPELL_CAST_START", "DevastatingStrike", 230438)
	self:Log("SPELL_CAST_START", "BolderStrike", 231086)
	self:Log("SPELL_CAST_START", "RumblingBlow", 230482)
	self:Death("TormDeath", 115914)
	self:Log("SPELL_CAST_START", "Fulminate", 221164)
	self:Log("SPELL_CAST_SUCCESS", "CompressTheVoid", 221160)
	self:Log("SPELL_AURA_APPLIED", "OozingRush", 223655)
	self:Log("SPELL_AURA_REMOVED", "OozingRushRemoved", 223655)

	--[[ Trilliax to Aluriel ]]--
	self:Log("SPELL_CAST_START", "CracklingSlice", 224510)
	self:Log("SPELL_CAST_SUCCESS", "ProtectiveShield", 225389)
	self:Log("SPELL_CAST_SUCCESS", "MassSiphon", 225412)
	self:Death("ChronowraithDeath", 113307)
	self:Log("SPELL_CAST_START", "MassSuppress", 224568)

	--[[ Aluriel to Krosos ]]--
	self:Log("SPELL_AURA_APPLIED", "AnnihilatingOrb", 221344)
	self:Log("SPELL_AURA_REMOVED", "AnnihilatingOrbRemoved", 221344)
	self:Death("InfernalDeath", 111210)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Skorpyron to Trilliax ]]--
function mod:DevastatingStrike(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 7.5)
end

do
	local function printTarget(self, player, guid)
		self:TargetMessage(231086, player, "Urgent", "Long", nil, nil, true)
		if self:Me(guid) then
			self:Say(231086)
			self:Flash(231086)
		end
	end
	function mod:BolderStrike(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:RumblingBlow(args)
	self:Message(args.spellId, "Attention", "Info")
end

function mod:TormDeath(args)
	self:StopBar(230438) -- Devastating Strike
end

do
	local prev, fulminateCount = 0, 0
	function mod:Fulminate(args)
		local t = GetTime()
		self:Message(args.spellId, "Important", t-prev > 2 and "Alarm")
		prev = t
		local pad = strrep(" ", fulminateCount) -- hack so i can have two bars/messages for the same thing up
		self:Bar(args.spellId, 5, CL.cast:format(args.spellName)..pad)
		fulminateCount = 1 - fulminateCount
	end
end

do
	local prev = 0
	function mod:CompressTheVoid(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Urgent", t-prev > 2 and "Long")
			self:Bar(args.spellId, 15)
		end
	end
end

function mod:OozingRush(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning")
	self:TargetBar(args.spellId, 10, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:OozingRushRemoved(args)
	self:StopBar(args.spellId, args.destName)
	self:PrimaryIcon(args.spellId)
end

--[[ Trilliax to Aluriel ]]--
do
	local prev = 0
	function mod:CracklingSlice(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Attention", "Long")
		end
	end
end

function mod:ProtectiveShield(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:MassSiphon(args)
	self:Message(args.spellId, "Urgent", self:Interrupter(args.sourceGUID) and "Info", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 15)
end

function mod:ChronowraithDeath(args)
	self:StopBar(225412) -- Mass Siphon
end

function mod:MassSuppress(args)
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and "Long")
end

--[[ Aluriel to Krosos ]]--
function mod:AnnihilatingOrb(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning")
	self:Bar(args.spellId, 5, args.destName)
	self:Bar(args.spellId, 35)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:AnnihilatingOrbRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:InfernalDeath(args)
	self:StopBar(221344) -- Annihilating Orb
end
