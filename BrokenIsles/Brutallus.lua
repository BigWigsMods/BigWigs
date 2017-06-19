if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Brutallus", -1021, 1883)
if not mod then return end
mod:RegisterEnableMob(117239)
mod.otherMenu = 1007
mod.worldBoss = 117239

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		233484, -- Meteor Slash
		233566, -- Rupture
		233515, -- Crashing Embers
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "MeteorSlash", 233484)
	self:Log("SPELL_CAST_SUCCESS", "Rupture", 233566)
	self:Log("SPELL_CAST_SUCCESS", "CrashingEmbers", 233515)

	self:Death("Win", 117239)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	--if id == XXX then
	--	self:Win()
	--end
end

function mod:MeteorSlash(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CDBar(args.spellId, 16)
end

function mod:Rupture(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 18)
end

function mod:CrashingEmbers(args)
	self:Message(args.spellId, "Important", "Alert")
	self:CDBar(args.spellId, 17)
end
