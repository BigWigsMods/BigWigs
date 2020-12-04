--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Maexxna", 533)
if not mod then return end
mod:RegisterEnableMob(15952)
mod:SetAllowWin(true)
mod.engageId = 1116

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Maexxna"

	L.webspraywarn30sec = "Cocoons in 10 sec"
	L.webspraywarn20sec = "Cocoons! Spiders in 10 sec!"
	L.webspraywarn10sec = "Spiders! Spray in 10 sec!"
	L.webspraywarn5sec = "WEB SPRAY in 5 seconds!"
	L.enragewarn = "Frenzy - SQUISH SQUISH SQUISH!"
	L.enragesoonwarn = "Frenzy Soon - Bugsquatters out!"

	L.cocoonbar = "Cocoons"
	L.spiderbar = "Spiders"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		28776, -- Necrotic Poison
		{28622, "SAY"}, -- Web Wrap (Cocoon)
		29484, -- Web Spray
		28747, -- Enrage
	}, nil, {
		[28622] = L.cocoonbar,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "NecroticPoison", 28776)
	self:Log("SPELL_AURA_APPLIED", "Cocoon", 28622)
	self:Log("SPELL_CAST_SUCCESS", "Spray", 29484)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 28747)
end

function mod:OnEngage()
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")

	self:Message(29484, "yellow", CL.custom_start_s:format(L.bossName, self:SpellName(29484), 40), false)
	self:Bar(29484, 40)
	self:DelayedMessage(29484, 10, "yellow", L.webspraywarn30sec)
	self:DelayedMessage(29484, 20, "yellow", L.webspraywarn20sec)
	self:DelayedMessage(29484, 30, "yellow", L.webspraywarn10sec)
	self:DelayedMessage(29484, 35, "yellow", L.webspraywarn5sec)

	self:Bar(28622, 20, L.cocoonbar, 745)
	self:Bar(29484, 30, L.spiderbar, 17332)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:NecroticPoison(args)
	-- I feel bad using hard checks, but everyone else doesn't care
	if self:Me(args.destGUID) or self:Healer() or self:Dispeller("poison") then
		self:TargetMessage(28776, "purple", args.destName)
		self:PlaySound(28776, "info")
	end
end

do
	local inCocoon = mod:NewTargetList()
	function mod:Cocoon(args)
		inCocoon[#inCocoon + 1] = args.destName
		self:TargetsMessage(28622, "red", inCocoon, 0, L.cocoonbar, 745)
		if self:Me(args.destGUID) then
			self:PlaySound(28622, "alert")
			self:Say(28622)
		end
	end
end

function mod:Spray(args)
	self:Message(29484, "red")
	self:Bar(29484, 40)
	self:DelayedMessage(29484, 10, "yellow", L.webspraywarn30sec)
	self:DelayedMessage(29484, 20, "yellow", L.webspraywarn20sec)
	self:DelayedMessage(29484, 30, "yellow", L.webspraywarn10sec)
	self:DelayedMessage(29484, 35, "yellow", L.webspraywarn5sec)

	self:Bar(28622, 20, L.cocoonbar, 745)
	self:Bar(29484, 30, L.spiderbar, 17332)
end

function mod:Frenzy(args)
	self:Message(28747, "orange", L.enragewarn)
	self:PlaySound(28747, "alarm")
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(UnitGUID(unit)) == 15952 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 30 and hp < 35 then
			self:Message(28747, "red", L.enragesoonwarn)
			self:UnregisterEvent(event)
		elseif hp < 30 then -- too fast!
			self:UnregisterEvent(event)
		end
	end
end
