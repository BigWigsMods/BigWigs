
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lethon", -1425)
if not mod then return end
mod:RegisterEnableMob(14888)
mod.otherMenu = -947
mod.worldBoss = 14888

--------------------------------------------------------------------------------
-- Locals
--

local warnHP = 80
local whirlCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Lethon"

	L.engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{24821, "TANK"}, -- Shadow Bolt Whirl
		24811, -- Draw Spirit
		-- Shared
		24818, -- Noxious Breath
		24814, -- Seeping Fog
	},{
		[24818] = CL.general,
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	whirlCount = 0 -- don't want to reset if OnEngage is late

	self:Log("SPELL_CAST_SUCCESS", "NoxiousBreath", 24818)
	self:Log("SPELL_AURA_APPLIED", "NoxiousBreathApplied", 24818)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NoxiousBreathApplied", 24818)
	self:Log("SPELL_CAST_SUCCESS", "SeepingFog", 24814)
	self:Log("SPELL_CAST_SUCCESS", "ShadowBoltWhirl", 24821)
	self:Log("SPELL_CAST_SUCCESS", "DrawSpirit", 24811)

	self:RegisterMessage("BigWigs_BossComm")
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

function mod:DrawSpirit(args)
	self:Message2(24811, "cyan")
	self:PlaySound(24811, "long")
	self:Bar(24811, 5, 710) -- 710 = Banish
end

do
	local prev = 0
	function mod:BigWigs_BossComm(_, msg, extra)
		if msg ~= "ShadowBoltWhirl" then return end

		local t = GetTime()
		if t-prev > 2 then
			prev = t
			whirlCount = extra
			-- cast every 5s, announce on the 4th for swapping sides
			if whirlCount == 4 then
				self:Message2(24821, "yellow", CL.count:format(self:SpellName(24821), whirlCount))
				self:PlaySound(24821, "alert")
				whirlCount = 0
			end
			whirlCount = whirlCount + 1
		end
	end
end

function mod:ShadowBoltWhirl(args)
	-- I'm really worried about this getting out of sync and being annoying (yay combat log range)
	if whirlCount > 0 then
		self:Sync("ShadowBoltWhirl", whirlCount)
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
			self:Message2(24814, "green")
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
				self:Message2(24811, "cyan", CL.soon:format(self:SpellName(24811)), false)
			end
			if warnHP < 30 then
				self:UnregisterUnitEvent(event, "target", "focus")
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg, sender)
	if msg:find(L.engage_trigger, nil, true) then
		whirlCount = 1
		self:Message2(24818, "yellow", L.custom_start_s:format(sender, self:SpellName(24818), 10), false)
		self:Bar(24818, 10) -- Noxious Breath
	end
end
