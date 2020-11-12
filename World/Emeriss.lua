
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Emeriss", -1440)
if not mod then return end
mod:RegisterEnableMob(14889)
mod.otherMenu = -947
mod.worldBoss = 14889

--------------------------------------------------------------------------------
-- Locals
--

local warnHP = 80

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Emeriss"

	L.engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{24928, "ICON"}, -- Volatile Infection
		24910, -- Corruption of the Earth
		24871, -- Spore Cloud
		-- Shared
		24818, -- Noxious Breath
		24814, -- Seeping Fog
	},{
		[24818] = CL.general,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "NoxiousBreath", 24818)
	self:Log("SPELL_AURA_APPLIED", "NoxiousBreathApplied", 24818)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NoxiousBreathApplied", 24818)
	self:Log("SPELL_CAST_SUCCESS", "SeepingFog", 24814)
	self:Log("SPELL_AURA_APPLIED", "VolatileInfection", 24928)
	self:Log("SPELL_CAST_SUCCESS", "Corruption", 24910)
	self:Log("SPELL_AURA_APPLIED", "SporeCloudDamage", 24871)
	self:Log("SPELL_PERIODIC_DAMAGE", "SporeCloudDamage", 24871)
	self:Log("SPELL_PERIODIC_MISSED", "SporeCloudDamage", 24871)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Death("Win", 14889)
end

function mod:OnEngage()
	warnHP = 80
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Corruption(args)
	self:Message(24910, "red")
	self:PlaySound(24910, "long")
	self:Bar(24910, 10)
end

function mod:VolatileInfection(args)
	self:TargetMessage(24928, "orange", args.destName)
	self:PlaySound(24928, "alert")
	self:PrimaryIcon(24928, args.destName)
end

do
	local prev = 0
	function mod:SporeCloudDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PersonalMessage(24871)
				self:PlaySound(24871, "alarm")
			end
		end
	end
end

function mod:NoxiousBreath(args)
	self:Bar(24818, 10)
end

function mod:NoxiousBreathApplied(args)
	if not self:Damager() and self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(24818, args.destName, amount, "purple")
		if self:Tank() and amount > 3 then
			self:PlaySound(24818, "warning")
		end
	end
end

do
	local prev = 0
	function mod:SeepingFog(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(24814, "green")
			self:PlaySound(24814, "info")
			-- self:CDBar(24818, 20)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(UnitGUID(unit)) == 14889 then
		local hp = UnitHealth(unit)
		if hp < warnHP then -- 80, 55, 30
			warnHP = warnHP - 25
			if hp > warnHP then -- avoid multiple messages when joining mid-fight
				self:Message(24910, "red", CL.soon:format(self:SpellName(24910)), false)
				self:PlaySound(24910, "alarm")
			end
			if warnHP < 30 then
				self:UnregisterUnitEvent(event, "target", "focus")
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg, sender)
	if msg:find(L.engage_trigger, nil, true) then
		self:Message(24818, "yellow", L.custom_start_s:format(self.displayName, self:SpellName(24818), 10), false)
		self:Bar(24818, 10) -- Noxious Breath
	end
end
