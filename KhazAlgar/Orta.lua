--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Orta, the Broken Mountain", -2213, 2625)
if not mod then return end
mod:RegisterEnableMob(221067) -- Orta, the Broken Mountain
mod.otherMenu = -2274
mod.worldBoss = 221067

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(450407, CL.frontal_cone) -- Colossal Slam (Frontal Cone)
	self:SetSpellRename(450454, CL.knockback) -- Tectonic Roar (Knockback)
	self:SetSpellRename(450677, CL.dodge) -- Rupturing Runes (Dodge)
end

function mod:GetOptions()
	return {
		450407, -- Colossal Slam
		450454, -- Tectonic Roar
		450677, -- Rupturing Runes
		450929, -- Mountain's Grasp
	},nil,{
		[450407] = CL.frontal_cone, -- Colossal Slam (Frontal Cone)
		[450454] = CL.knockback, -- Tectonic Roar (Knockback)
		[450677] = CL.dodge, -- Rupturing Runes (Dodge)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()

	-- World bosses will wipe but keep listening to events if you fly away, so we only register OnEngage
	self:Log("SPELL_CAST_START", "ColossalSlam", 450407)
	self:Log("SPELL_CAST_START", "TectonicRoar", 450454)
	self:Log("SPELL_CAST_START", "RupturingRunes", 450677)
	self:Log("SPELL_CAST_START", "MountainsGrasp", 450929)
	self:Log("SPELL_AURA_APPLIED", "MountainsGraspApplied", 450929)

	self:CDBar(450407, 5, CL.frontal_cone) -- Colossal Slam
	self:CDBar(450454, 22.1, CL.knockback) -- Tectonic Roar
	self:CDBar(450677, 13.3, CL.dodge) -- Rupturing Runes
	self:CDBar(450929, 27.3) -- Mountain's Grasp
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2984 then
		self:Win()
	end
end

function mod:ColossalSlam(args)
	self:Message(args.spellId, "yellow", CL.frontal_cone)
	self:CDBar(args.spellId, 31.7, CL.frontal_cone)
	self:PlaySound(args.spellId, "info")
end

function mod:TectonicRoar(args)
	self:Message(args.spellId, "red", CL.knockback)
	self:CDBar(args.spellId, 31.9, CL.knockback)
	self:PlaySound(args.spellId, "warning")
end

function mod:RupturingRunes(args)
	self:Message(args.spellId, "orange", CL.extra:format(args.spellName, CL.dodge))
	self:CDBar(args.spellId, 31.8, CL.dodge)
	self:PlaySound(args.spellId, "long")
end

do
	local playerList = {}
	function mod:MountainsGrasp(args)
		playerList = {}
		self:Message(args.spellId, "yellow")
		self:CDBar(args.spellId, 31.8)
		self:PlaySound(args.spellId, "alarm")
	end

	function mod:MountainsGraspApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end
