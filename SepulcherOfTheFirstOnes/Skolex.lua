if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Skolex, the Insatiable Ravener", 2481, 2465)
if not mod then return end
mod:RegisterEnableMob(183937, 181395) -- Skolex x2, Check which
mod:SetEncounterID(2542)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local flailCount = 1
local retchCount = 1
local unendingCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		359770, -- Unending Hunger
		359829, -- Dust Flail
		360451, -- Retch
		360079, -- Tank Combo
		359979, -- Rend
		359975, -- Riftmaw
		364778, -- Destroy
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "UnendingHunger", 359770)
	self:Log("SPELL_CAST_START", "DustFlail", 359829)
	self:Log("SPELL_CAST_START", "Retch", 360451)
	self:Log("SPELL_CAST_START", "Rend", 359979)
	self:Log("SPELL_CAST_START", "Riftmaw", 359975)
	self:Log("SPELL_CAST_START", "Destroy", 364778)

end

function mod:OnEngage()
	flailCount = 1
	retchCount = 1
	unendingCount = 1

	self:Bar(359829, 2, CL.count:format(self:SpellName(359829), flailCount)) -- Dust Flail
	self:Bar(360079, 11) -- Tank Combo
	self:Bar(360451, 26, CL.count:format(self:SpellName(360451), retchCount)) -- Retch
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 360079 then -- Tank Combo
		self:CDBar(360079, 25) -- Tank Combo
	end
end

function mod:UnendingHunger(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, unendingCount))
	self:PlaySound(args.spellId, "long")
	unendingCount = unendingCount + 1
end

function mod:DustFlail(args)
	self:StopBar(CL.count:format(args.spellName, flailCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, flailCount))
	self:PlaySound(args.spellId, "alert")
	flailCount = flailCount + 1
	self:CDBar(args.spellId, 24.5, CL.count:format(args.spellName, flailCount))
end

function mod:Retch(args)
	self:StopBar(CL.count:format(args.spellName, retchCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, retchCount))
	self:PlaySound(args.spellId, "info")
	retchCount = retchCount + 1
	self:CDBar(args.spellId, 24.5, CL.count:format(args.spellName, retchCount))
end

function mod:Rend(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
end

function mod:Riftmaw(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
end

function mod:Destroy(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end