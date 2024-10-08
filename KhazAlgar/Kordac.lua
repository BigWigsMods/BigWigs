--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kordac, the Dormant Protector", -2248, 2637)
if not mod then return end
mod:RegisterEnableMob(221084) -- Kordac, the Dormant Protector
mod.otherMenu = -2274
mod.worldBoss = 221084

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(458423, CL.dodge) -- Arcane Bombardment (Dodge)
	self:SetSpellRename(458695, CL.laser) -- Overcharged Lasers (Laser)
end

function mod:GetOptions()
	return {
		458423, -- Arcane Bombardment
		458329, -- Titanic Impact
		458838, -- Supression Burst
		458799, -- Overcharged Earth
		{458695, "ME_ONLY_EMPHASIZE"}, -- Overcharged Lasers
	},nil,{
		[458423] = CL.dodge, -- Arcane Bombardment (Dodge)
		[458695] = CL.laser, -- Overcharged Lasers (Laser)
	}
end

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	--self:RegisterEvent("BOSS_KILL") -- Turns friendly on win
end

function mod:OnEngage()
	self:CheckForWipe()
	self:RegisterUnitEvent("UNIT_AURA", nil, "player")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	-- World bosses will wipe but keep listening to events if you fly away, so we only register OnEngage
	self:Log("SPELL_CAST_START", "ArcaneBombardment", 458423)
	self:Log("SPELL_CAST_START", "TitanicImpact", 458329)
	self:Log("SPELL_AURA_APPLIED", "SupressionBurstApplied", 458838)

	self:Log("SPELL_AURA_APPLIED", "OverchargedEarthDamage", 458799)
	self:Log("SPELL_PERIODIC_DAMAGE", "OverchargedEarthDamage", 458799)
	self:Log("SPELL_PERIODIC_MISSED", "OverchargedEarthDamage", 458799)

	self:CDBar(458329, 10.5) -- Titanic Impact
	self:CDBar(458838, 22.7) -- Supression Burst
	self:CDBar(458423, 36.2, CL.dodge) -- Arcane Bombardment
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local applied = false
	function mod:UNIT_AURA()
		local hasAura = self:GetPlayerAura(458695) -- Overcharged Lasers
		if hasAura and not applied then
			applied = true
			self:PersonalMessage(458695, nil, CL.laser)
			self:PlaySound(458695, "warning")
		elseif not hasAura and applied then
			applied = false
			self:PersonalMessage(458695, "removed", CL.laser)
		end
	end
end

do
	local prev = ""
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castId, spellId)
		if spellId == 459404 and prev ~= castId then -- Critical Condition
			prev = castId
			self:Win()
		end
	end
end

function mod:ArcaneBombardment(args)
	self:Message(args.spellId, "red", CL.extra:format(args.spellName, CL.dodge))
	self:CDBar(args.spellId, 66, CL.dodge)
	self:PlaySound(args.spellId, "long")
end

function mod:TitanicImpact(args)
	self:Message(args.spellId, "orange")
	self:CDBar(args.spellId, 15.8)
	self:PlaySound(args.spellId, "info")
end

function mod:SupressionBurstApplied(args)
	self:CDBar(args.spellId, 48)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alarm")
end

do
	local prev = 0
	function mod:OverchargedEarthDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end
