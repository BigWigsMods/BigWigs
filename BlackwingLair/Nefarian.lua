--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("NefarianBWL", 469)
if not mod then return end
mod:RegisterEnableMob(11583, 10162) -- Nefarian, Lord Victor Nefarius
mod:SetAllowWin(true)
mod.engageId = 617

--------------------------------------------------------------------------------
-- Locals
--

local warnpairs = nil
local warnTable = nil

local adds_dead = 0
local total_adds = 42 -- this could be a magic number in the message function, but I like the faux-const better

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Nefarian"

	L.landing_soon_trigger = "Well done, my minions"
	L.landing_trigger = "BURN! You wretches"
	L.zerg_trigger = "Impossible! Rise my"

	L.triggershamans = "Shamans"
	L.triggerwarlock = "Warlocks"
	L.triggerhunter = "Hunters" -- Hunters and your annoying pea-shooters!
	L.triggermage = "Mages"

	L.landing_soon_warning = "Nefarian landing in 10 seconds!"
	L.landing_warning = "Nefarian is landing!"
	L.zerg_warning = "Zerg incoming!"
	L.classcall_warning = "Class call incoming!"

	L.warnshaman = "Shamans - Totems spawned!"
	L.warndruid = "Druids - Stuck in cat form!"
	L.warnwarlock = "Warlocks - Incoming Infernals!"
	L.warnpriest = "Priests - Heals hurt!"
	L.warnhunter = "Hunters - Bows/Guns broken!"
	L.warnwarrior = "Warriors - Stuck in berserking stance!"
	L.warnrogue = "Rogues - Ported and rooted!"
	L.warnpaladin = "Paladins - Blessing of Protection!"
	L.warnmage = "Mages - Incoming polymorphs!"

	L.classcall_bar = "Class call"

	L.classcall = "Class Call"
	L.classcall_desc = "Warn for Class Calls."

	L.otherwarn = "Landing and Zerg"
	L.otherwarn_desc = "Landing and Zerg warnings."

	L.add = "Drakonid deaths"
	L.add_desc = "Announce the number of adds killed in Phase 1 before Nefarian lands."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		22539, -- Shadow Flame
		22686, -- Bellowing Roar
		"classcall",
		"otherwarn",
		"add"
	}
end

function mod:OnRegister()
	self.displayName = L.bossName

	warnpairs = {
		[L.triggershamans] = {L.warnshaman, true},
		[L.triggerwarlock] = {L.warnwarlock, true},
		[L.triggerhunter] = {L.warnhunter, true}, -- No event
		[L.triggermage] = {L.warnmage, true},
		[L.landing_soon_trigger] = {L.landing_soon_warning},
		[L.landing_trigger] = {L.landing_warning},
		[L.zerg_trigger] = {L.zerg_warning},
	}
	warnTable = {
		[mod:SpellName(23414)] = L.warnrogue,
		[mod:SpellName(23398)] = L.warndruid,
		[mod:SpellName(23397)] = L.warnwarrior,
		[mod:SpellName(23401)] = L.warnpriest,
		[mod:SpellName(23418)] = L.warnpaladin,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Fear", self:SpellName(22686))
	self:Log("SPELL_CAST_START", "ShadowFlame", self:SpellName(22539))

	-- Rogue, Druid, Warrior, Priest, Paladin
	self:Log("SPELL_AURA_APPLIED", "ClassCall",
		self:SpellName(23414),
		self:SpellName(23398),
		self:SpellName(23397),
		self:SpellName(23401),
		self:SpellName(23418)
	)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("AddDied", 14264, 14263, 14261, 14265, 14262, 14302) --Red, Bronze, Blue, Black, Green, Chromatic
end

function mod:OnEngage()
	adds_dead = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fear(args)
	self:DelayedMessage(22686, 26, "orange", CL.custom_sec:format(args.spellName, 5))
	self:CDBar(22686, 32)
	self:Message(22686, "red")
	if self:Me(args.destGUID) then
		self:PlaySound(22686, "alert")
	end
	self:Bar(22686, 1.5, CL.cast:format(args.spellName))
end

function mod:ShadowFlame(args)
	self:Message(22539, "yellow")
	if self:Me(args.destGUID) then
		self:PlaySound(22539, "alert")
	end
	self:Bar(22539, 2, CL.cast:format(args.spellName))
end

do
	local prev = 0
	function mod:ClassCall(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Bar("classcall", 30, L.classcall_bar, "Spell_Shadow_Charm")
			self:DelayedMessage("classcall", 27, "green", L.classcall_warning)
			self:Message("classcall", "red", warnTable[args.spellName], "Spell_Shadow_Charm")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.landing_soon_trigger) then
		self:Bar("otherwarn", 10, L.landing_warning, "INV_Misc_Head_Dragon_Black")
		return
	end
	for i,v in pairs(warnpairs) do
		if msg:find(i) then
			if v[2] then
				self:Bar("classcall", 30, L.classcall_bar, "Spell_Shadow_Charm")
				self:DelayedMessage("classcall", 27, "green", L.classcall_warning)
				self:Message("classcall", "red", v[1], "Spell_Shadow_Charm")
			else
				self:Message("otherwarn", "red", v[1], false)
			end
			return
		end
	end
end

function mod:AddDied(args)
	adds_dead = adds_dead + 1
	self:Message("add", "green", CL.add_killed:format(adds_dead, total_adds), "INV_Misc_Head_Dragon_Black")
end
