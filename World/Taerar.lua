
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Taerar", -1431)
if not mod then return end
mod:RegisterEnableMob(14890)
mod.otherMenu = -947
mod.worldBoss = 14890

--------------------------------------------------------------------------------
-- Locals
--

local warnHP = 80

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Taerar"

	L.engage_trigger = "Peace is but a fleeting dream! Let the NIGHTMARE reign!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		22686, -- Bellowing Roar
		24841, -- Summon Shade of Taerar
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
	self:Log("SPELL_CAST_START", "BellowingRoar", 22686)
	self:Log("SPELL_CAST_SUCCESS", "Shades", 24841)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Death("Win", 14888)
end

function mod:OnEngage()
	warnHP = 80
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BellowingRoar(args)
	self:Message2(22686, "orange", CL.casting:format(args.spellName))
	-- self:CastBar(22686, 1.5)
	self:Bar(22686, 30)
end

function mod:Shades(args)
	self:Message2(24841, "cyan", CL.incoming:format(CL.adds), false)
	self:PlaySound(24841, "long")
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
			self:Message2(24814, "green")
			self:PlaySound(24814, "info")
			-- self:CDBar(24818, 20)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(UnitGUID(unit)) == 14890 then
		local hp = UnitHealth(unit)
		if hp < warnHP then -- 80, 55, 30
			if hp > warnHP-25 then -- avoid multiple messages when joining mid-fight
				self:Message2(24841, "cyan", CL.soon:format(CL.adds), false)
			end
			warnHP = warnHP - 25
			if warnHP < 30 then
				self:UnregisterUnitEvent(event, "target", "focus")
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg, sender)
	if msg:find(L.engage_trigger, nil, true) then
		self:Message2(24818, "yellow", L.custom_start_s:format(sender, self:SpellName(24818), 10), false)
		self:Bar(24818, 10) -- Noxious Breath
	end
end
