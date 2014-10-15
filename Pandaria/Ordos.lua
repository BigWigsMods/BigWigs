
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ordos", 951, 861)
if not mod then return end
mod:RegisterEnableMob(72057)
mod.otherMenu = 862
mod.worldBoss = 72057

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "You will take my place on the eternal brazier."

	L.burning_soul_bar = "Explosions"
	L.burning_soul_self_bar = "You explode!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		144688, {144689, "FLASH", "SAY", "PROXIMITY"}, 144692, 144695,
		"berserk", "bosskill",
	}
end

function mod:OnBossEnable()
	self:Yell("Engage", L.engage_yell)

	self:Log("SPELL_CAST_START", "MagmaCrush", 144688)
	self:Log("SPELL_AURA_APPLIED", "BurningSoul", 144689)
	self:Log("SPELL_AURA_REMOVED", "BurningSoulRemoved", 144689)
	self:Log("SPELL_CAST_SUCCESS", "PoolOfFire", 144692)
	self:Log("SPELL_DAMAGE", "PoolOfFireDamage", 144694)
	self:Log("SPELL_MISSED", "PoolOfFireDamage", 144694)
	self:Log("SPELL_SUMMON", "AncientFlame", 144695)
	self:Log("SPELL_DAMAGE", "AncientFlameDamage", 144699)
	self:Log("SPELL_MISSED", "AncientFlameDamage", 144699)

	self:Death("Win", 72057) -- Ordos
end

function mod:OnEngage()
	self:Berserk(300) -- Eternal Agony
	self:CDBar(144688, 10) -- Magma Crush
	self:CDBar(144689, 23) -- Burning Soul
	self:CDBar(144695, 44) -- Ancient Flame
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MagmaCrush(args)
	self:Message(args.spellId, "Urgent", nil, CL["casting"]:format(args.spellName))
	self:CDBar(args.spellId, 12)
end

function mod:PoolOfFire(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:CDBar(args.spellId, 32)
end

do
	local prev = 0
	function mod:PoolOfFireDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 4 then
				prev = t
				self:Message(144692, "Personal", "Info", CL["underyou"]:format(args.spellName))
			end
		end
	end
end

function mod:AncientFlame(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 44)
end

do
	local prev = 0
	function mod:AncientFlameDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 4 then
				prev = t
				self:Message(144695, "Personal", "Info", CL["you"]:format(args.spellName))
			end
		end
	end
end

do
	local coloredNames, burningSoulList, isOnMe, scheduled = mod:NewTargetList(), {}, nil, nil
	local function warnBurningSoul(spellId)
		mod:CDBar(spellId, 24)
		mod:Bar(spellId, 10, L.burning_soul_bar)
		if isOnMe then
			mod:Bar(spellId, 10, L.burning_soul_self_bar)
		else
			mod:OpenProximity(spellId, 10, burningSoulList)
			mod:Bar(spellId, 10, L.burning_soul_bar)
		end
		for i,v in ipairs(burningSoulList) do
			coloredNames[i] = v
			burningSoulList[i] = nil
		end
		mod:TargetMessage(spellId, coloredNames, "Urgent", "Alert", nil, nil, true)
		scheduled = nil
	end

	function mod:BurningSoulRemoved(args)
		self:CloseProximity(args.spellId)
		isOnMe = nil
	end

	function mod:BurningSoul(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10)
			isOnMe = true
		end

		burningSoulList[#burningSoulList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnBurningSoul, 0.1, args.spellId)
		end
	end
end

