--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Gobfather", -2346, 2683)
if not mod then return end
mod:RegisterEnableMob(231821) -- The Gobfather
mod.otherMenu = -2274
mod.worldBoss = 231821

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1216687, CL.frontal_cone) -- Flaming Flames (Frontal Cone)
	self:SetSpellRename(1216709, CL.dodge) -- Death From Above (Dodge)
	self:SetSpellRename(1216812, CL.knockback) -- Giga-Rocket Slam (Knockback)
end

function mod:GetOptions()
	return {
		1216687, -- Flaming Flames
		1216505, -- Bombfield
		1216709, -- Death From Above
		1216812, -- Giga-Rocket Slam
	},nil,{
		[1216687] = CL.frontal_cone, -- Flaming Flames (Frontal Cone)
		[1216709] = CL.dodge, -- Death From Above (Dodge)
		[1216812] = CL.knockback, -- Giga-Rocket Slam (Knockback)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()

	-- World bosses will wipe but keep listening to events if you fly away, so we only register OnEngage
	self:Log("SPELL_CAST_START", "FlamingFlames", 1216687)
	self:Log("SPELL_CAST_START", "Bombfield", 1216505)
	self:Log("SPELL_CAST_START", "DeathFromAbove", 1216709)
	self:Log("SPELL_CAST_START", "GigaRocketSlam", 1216812)

	self:CDBar(1216505, 5.1) -- Bombfield
	self:CDBar(1216687, 17.6, CL.frontal_cone) -- Flaming Flames
	self:CDBar(1216709, 26.8, CL.dodge) -- Death From Above
	self:CDBar(1216812, 44.2, CL.knockback) -- Giga-Rocket Slam
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 3128 then
		self:Win()
	end
end

function mod:FlamingFlames(args)
	self:Message(args.spellId, "red", CL.frontal_cone)
	self:CDBar(args.spellId, 49.3, CL.frontal_cone)
	self:PlaySound(args.spellId, "alert")
end

function mod:Bombfield(args)
	self:Message(args.spellId, "yellow")
	self:CDBar(args.spellId, 49.3)
	self:PlaySound(args.spellId, "info")
end

function mod:DeathFromAbove(args)
	self:Message(args.spellId, "orange", CL.extra:format(args.spellName, CL.dodge))
	self:CDBar(args.spellId, 49.3, CL.dodge)
	self:PlaySound(args.spellId, "long")
end

function mod:GigaRocketSlam(args)
	self:Message(args.spellId, "red", CL.knockback)
	self:CDBar(args.spellId, 49.3, CL.knockback)
	self:PlaySound(args.spellId, "warning")
end
