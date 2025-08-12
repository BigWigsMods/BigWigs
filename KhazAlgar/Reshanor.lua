--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Reshanor, The Untethered", -2371, 2762)
if not mod then return end
mod:RegisterEnableMob(238319) -- Reshanor
mod.otherMenu = -2274
mod.worldBoss = 238319

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.run = "Run to the portal and click the extra action button"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1237905, CL.frontal_cone) -- Twilight Breath (Frontal Cone)
	self:SetSpellRename(1237893, CL.roar) -- Veilshatter Roar (Roar)
end

function mod:GetOptions()
	return {
		1237905, -- Twilight Breath
		1237893, -- Veilshatter Roar
		"stages",
	},nil,{
		[1237905] = CL.frontal_cone, -- Twilight Breath (Frontal Cone)
		[1237893] = CL.roar, -- Veilshatter Roar (Roar)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()

	-- World bosses will wipe but keep listening to events if you fly away, so we only register OnEngage
	self:Log("SPELL_CAST_START", "TwilightBreath", 1237905)
	self:Log("SPELL_CAST_START", "VeilshatterRoar", 1237893)
	self:Log("SPELL_CAST_START", "UntetheredRetreat", 1237261)
	self:Log("SPELL_CAST_SUCCESS", "UntetheredRetreatApplied", 1237288)
	self:Log("SPELL_AURA_REMOVED", "UntetheredRetreatRemoved", 1237288)

	self:CDBar(1237905, 9.7, CL.frontal_cone) -- Twilight Breath
	self:CDBar(1237893, 26.8, CL.roar) -- Veilshatter Roar
	self:Bar("stages", 44.2, CL.stage:format(2), 1237261) -- Stage 2
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 3184 then
		self:Win()
	end
end

function mod:TwilightBreath(args)
	self:Message(args.spellId, "red", CL.frontal_cone)
	self:CDBar(args.spellId, 34.5, CL.frontal_cone)
	self:PlaySound(args.spellId, "alert")
end

function mod:VeilshatterRoar(args)
	self:StopBar(CL.roar)
	self:Message(args.spellId, "orange", CL.roar)
	self:PlaySound(args.spellId, "warning")
end

function mod:UntetheredRetreat(args)
	self:StopBar(CL.frontal_cone)
	self:StopBar(CL.roar)
	self:Message("stages", "cyan", L.run, args.spellId)
	self:PlaySound("stages", "long")
end

function mod:UntetheredRetreatApplied(args)
	self:Message("stages", "cyan", CL.stage:format(2), args.spellId, nil, 5) -- Stay onscreen for 5s
	self:Bar("stages", 44, CL.stage:format(1), args.spellId)
	self:PlaySound("stages", "long")
end

function mod:UntetheredRetreatRemoved(args)
	self:Message("stages", "cyan", CL.stage:format(1), false)
	self:Bar("stages", 55, CL.stage:format(2), 1237261)
	self:CDBar(1237905, 3, CL.frontal_cone) -- Twilight Breath
	self:CDBar(1237893, 13.4, CL.roar) -- Veilshatter Roar
	self:PlaySound("stages", "info")
end
