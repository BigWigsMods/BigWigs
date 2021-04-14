
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("High Priest Venoxis", 309)
if not mod then return end
mod:RegisterEnableMob(14507)
mod:SetAllowWin(true)
mod:SetEncounterID(784)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "High Priest Venoxis"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		23895, -- Renew
		23860, -- Holy Fire
		23861, -- Poison Cloud
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Renew", 23895)
	self:Log("SPELL_CAST_START", "HolyFire", 23860)
	self:Log("SPELL_INTERRUPT", "HolyFireStop", "*")
	self:Log("SPELL_CAST_SUCCESS", "PoisonCloud", 23861)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Renew(args)
	self:Message(23895, "orange", CL.on:format(args.spellName, args.destName))
	if self:Dispeller("magic", true) then
		self:PlaySound(23895, "alert")
	end
end

function mod:HolyFire(args)
	self:Message(23860, "yellow")
	self:CastBar(23860, 3.5)
end

function mod:HolyFireStop(args)
	if args.extraSpellName == self:SpellName(23860) then
		self:StopBar(CL.cast:format(args.extraSpellName))
	end
end

function mod:PoisonCloud(args)
	self:Message(23861, "yellow")
	self:PlaySound(23861, "info")
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 14507 then
		local hp = self:GetHealth(unit)
		if hp < 56 then
			self:UnregisterUnitEvent(event, "target", "focus")
			if hp > 50 then -- make sure we're not too late
				self:Message(23861, "green", CL.soon:format(self:SpellName(23861)), false)
			end
		end
	end
end
