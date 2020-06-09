
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("High Priest Venoxis", 309)
if not mod then return end
mod:RegisterEnableMob(14507)
mod:SetAllowWin(true)
mod.engageId = 784

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

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Renew", 23895)
	self:Log("SPELL_CAST_START", "HolyFire", 23860)
	self:Log("SPELL_INTERRUPT", "HolyFireStop", "*")
	self:Log("SPELL_CAST_SUCCESS", "PoisonCloud", 23861)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Renew(args)
	self:Message2(23895, "orange", CL.on:format(args.spellName, args.destName))
	if self:Dispeller("magic", true) then
		self:PlaySound(23895, "alert")
	end
end

function mod:HolyFire(args)
	self:Message2(23860, "yellow")
	self:CastBar(23860, 3.5)
end

function mod:HolyFireStop(args)
	if args.extraSpellName == self:SpellName(23860) then
		self:StopBar(23860, CL.cast:format(args.extraSpellName))
	end
end

function mod:PoisonCloud(args)
	self:Message2(23861, "yellow")
	self:PlaySound(23861, "info")
end
