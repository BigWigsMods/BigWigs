
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ordos", 951, 861)
if not mod then return end
mod:RegisterEnableMob(72057)
mod.otherMenu = 6
mod.worldBoss = 72057

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "You will take my place on the eternal brazier!"

	L.burning_soul_bar = "Explosions"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		144688, {144689, "FLASH", "SAY", "PROXIMITY"}, 144692, 144695,
		"bosskill",
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
	self:Message(args.spellId, "Urgent", nil, CL["cast"]:format(args.spellName))
	self:CDBar(args.spellId, 12) -- 15.7 29.1 24.1 13.3 20.6 12.1
end

function mod:PoolOfFire(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:CDBar(args.spellId, 32) -- 32.6 33.8 41.3
end

do
	local prev = 0
	function mod:PoolOfFireDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message(144692, "Personal", "Info", CL["under"]:format(args.spellName))
			end
		end
	end
end

function mod:AncientFlame(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 44) -- 43.5 45.9
end

do
	local prev = 0
	function mod:AncientFlameDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message(144695, "Personal", "Info", CL["near"]:format(args.spellName))
			end
		end
	end
end

do
	local burningSoulList, isOnMe, scheduled = mod:NewTargetList(), nil, nil
	local function warnBurningSoul(spellId)
		if not isOnMe then
			mod:OpenProximity(spellId, 8, burningSoulList)
		end
		mod:TargetMessage(spellId, burningSoulList, "Urgent", "Alert", nil, true)
		scheduled = nil
	end

	function mod:BurningSoulRemoved(args)
		self:CloseProximity(args.spellId)
		isOnMe = nil
	end

	function mod:BurningSoul(args)
		self:CDBar(args.spellId, 24) -- 23.8 - 41.4
		self:Bar(args.spellId, 10, L.burning_soul_bar)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 8)
			isOnMe = true
		end

		burningSoulList[#burningSoulList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(0.3, warnBurningSoul, args.spellId)
		end
	end
end

