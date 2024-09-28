--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aggregation of Horrors", -2214, 2635)
if not mod then return end
mod:RegisterEnableMob(220999) -- Aggregation of Horrors
mod.otherMenu = -2274
mod.worldBoss = 220999

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.void_rocks = "Void Rocks"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(452205, L.void_rocks) -- Crystalline Barrage (Void Rocks)
	self:SetSpellRename(453271, CL.explosion) -- Dark Awakening (Explosion)
end

function mod:GetOptions()
	return {
		452205, -- Crystalline Barrage
		453271, -- Dark Awakening
		452980, -- Voidquake
		453294, -- Crystal Strike
	},nil,{
		[452205] = L.void_rocks, -- Crystalline Barrage (Void Rocks)
		[453271] = CL.explosion, -- Dark Awakening (Explosion)
		[453294] = CL.interruptible, -- Crystal Strike (Interruptible)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()

	-- World bosses will wipe but keep listening to events if you fly away, so we only register OnEngage
	self:Log("SPELL_CAST_START", "CrystallineBarrage", 452205)
	self:Log("SPELL_CAST_START", "DarkAwakening", 453271)
	self:Log("SPELL_CAST_START", "Voidquake", 452980)
	self:Log("SPELL_CAST_START", "CrystalStrike", 453294)

	self:CDBar(452980, 9) -- Voidquake
	self:CDBar(452205, 25, L.void_rocks) -- Crystal Strike
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2988 then
		self:Win()
	end
end

function mod:CrystallineBarrage(args)
	self:Message(args.spellId, "yellow", L.void_rocks)
	self:Bar(args.spellId, 46.3, L.void_rocks)
	self:CDBar(453271, 20, CL.explosion) -- Dark Awakening
	self:PlaySound(args.spellId, "long")
end

function mod:DarkAwakening(args)
	self:Message(args.spellId, "red", CL.explosion)
	self:StopBar(CL.explosion)
	self:PlaySound(args.spellId, "warning")
end

function mod:Voidquake(args)
	self:Message(args.spellId, "orange")
	self:CDBar(args.spellId, 46)
	self:PlaySound(args.spellId, "info")
end

function mod:CrystalStrike(args)
	self:Message(args.spellId, "purple", CL.extra:format(args.spellName, CL.interruptible))
	self:PlaySound(args.spellId, "alarm")
end
