
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nighthold Trash", 1088)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Skorpyron to Chronomatic Anomaly ]]--
	115914, -- Torm the Brute
	111081, -- Fulminant
	111072 -- Pulsauron
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.torm = "Torm the Brute"
	L.fulminant = "Fulminant"
	L.pulsauron = "Pulsauron"
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		--[[ Skorpyron to Chronomatic Anomaly ]]--
		230438, -- Devastating Strike (Torm)
		231086, -- Bolder Strike (Torm)
		230482, -- Rumbling Blow (Torm)
		230488, -- Rumbling Ground (Torm)
		221164, -- Fulminate (Fulminant)
		221160, -- Compress the Void (Pulsauron)
	}, {
		[230438] = L.torm,
		[221164] = L.fulminant,
		[221160] = L.pulsauron,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 230488) -- Rumbling Ground (Torm)
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 230488)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 230488)
	--self:Log("SPELL_DAMAGE", "GroundEffectDamage", ) --
	--self:Log("SPELL_MISSED", "GroundEffectDamage", )

	--[[ Skorpyron to Chronomatic Anomaly ]]--
	self:Log("SPELL_CAST_START", "DevastatingStrike", 230438)
	self:Log("SPELL_CAST_START", "BolderStrike", 231086)
	self:Log("SPELL_CAST_START", "RumblingBlow", 230482)
	self:Death("TormDeath", 115914)
	self:Log("SPELL_CAST_START", "Fulminate", 221164)
	self:Log("SPELL_CAST_SUCCESS", "CompressTheVoid", 221160)
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

--[[ Skorpyron to Chronomatic Anomaly ]]--
function mod:DevastatingStrike(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 7.5)
end

function mod:BolderStrike(args)
	self:Message(args.spellId, "Urgent", "Long")
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
