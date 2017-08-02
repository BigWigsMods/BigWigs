if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Eonar the Life-Binder", nil, 2025, 1712)
if not mod then return end
mod:RegisterEnableMob(125562) -- Essence of Eonar
mod.engageId = 2075
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		250048, -- Life Force
		246313, -- Artillery Strike
		248861, -- Spear of Doom
		248326, -- Rain of Fel
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_POWER", nil, "boss1") -- XXX Assume Eonar is set as boss1
	self:Log("SPELL_CAST_START", "LifeForce", 250048)
	self:Log("SPELL_CAST_START", "LifeForceSuccess", 250048)
	self:Log("SPELL_CAST_SUCCESS", "ArtilleryStrike", 246313)
	self:Log("SPELL_CAST_SUCCESS", "SpearofDoom", 248861)
	self:Log("SPELL_CAST_SUCCESS", "RainofFel", 248326)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_POWER(unit)
	local power = UnitPower(unit)
	if power >= 80 then
		self:Message(250048, "Neutral", "Info", CL.soon:format(self:SpellName(250048))) -- Life Force
		self:UnregisterUnitEvent("UNIT_POWER", unit)
	end
end

function mod:LifeForce(args)
	self:Message(args.spellId, "Positive", "Long", CL.casting:format(args.spellName))
end

function mod:LifeForceSuccess(args) -- Should have reset UNIT_POWER to 0 again
	self:RegisterUnitEvent("UNIT_POWER", nil, "boss1")
end

function mod:ArtilleryStrike(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:SpearofDoom(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:RainofFel(args)
	self:Message(args.spellId, "Urgent", "Warning")
end
