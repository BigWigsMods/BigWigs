--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Nefarian ", 469, 1536) -- Space is intentional to prevent conflict with Nefarian from BWD
if not mod then return end
mod:RegisterEnableMob(11583, 10162) -- Nefarian, Lord Victor Nefarius
mod.toggleOptions = {22539, 22686, "classcall", "otherwarn"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.landing_soon_trigger = "Well done, my minions"
	L.landing_trigger = "BURN! You wretches"
	L.zerg_trigger = "Impossible! Rise my"

	L.triggershamans = "Shamans"
	L.triggerwarlock = "Warlocks"
	L.triggerhunter = "Hunters" -- Hunters and your annoying pea-shooters!
	L.triggermage = "Mages"
	L.triggerdeathknight = "Death Knights" -- Death Knights... get over here!
	L.triggermonk = "Monks"

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
	L.warndeathknight = "Death Knights - Death Grip"
	L.warnmonk = "Monks - Stuck Rolling"
	L.warndemonhunter = "Demon Hunters - Blinded"

	L.classcall_bar = "Class call"

	L.classcall = "Class Call"
	L.classcall_desc = "Warn for Class Calls."

	L.otherwarn = "Landing and Zerg"
	L.otherwarn_desc = "Landing and Zerg warnings."
end
L = mod:GetLocale()

local warnpairs = {
	[L.triggershamans] = {L.warnshaman, true},
	[L.triggerwarlock] = {L.warnwarlock, true},
	[L.triggerhunter] = {L.warnhunter, true}, -- No event
	[L.triggermage] = {L.warnmage, true},
	[L.triggerdeathknight] = {L.warndeathknight, true}, -- No event
	[L.triggermonk] = {L.warnmonk, true},
	[L.landing_soon_trigger] = {L.landing_soon_warning},
	[L.landing_trigger] = {L.landing_warning},
	[L.zerg_trigger] = {L.zerg_warning},
}
local warnTable = {
	[23414] = L.warnrogue,
	[23398] = L.warndruid,
	[23397] = L.warnwarrior,
	[23401] = L.warnpriest,
	[23418] = L.warnpaladin,
	[204813] = L.warndemonhunter,
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Fear", 22686)
	self:Log("SPELL_CAST_START", "ShadowFlame", 22539)

	-- Rogue, Druid, Warrior, Priest, Paladin, Demon Hunter
	self:Log("SPELL_AURA_APPLIED", "ClassCall", 23414, 23398, 23397, 23401, 23418, 204813)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("Win", 11583)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fear(args)
	self:DelayedMessage(args.spellId, 26, "orange", CL.custom_sec:format(args.spellName, 5))
	self:CDBar(args.spellId, 32)
	self:Message(args.spellId, "red", "Alert")
	self:Bar(args.spellId, 1.5, CL.cast:format(args.spellName))
end

function mod:ShadowFlame(args)
	self:Message(args.spellId, "yellow", "Alert")
	self:Bar(args.spellId, 2, CL.cast:format(args.spellName))
end

do
	local prev = 0
	function mod:ClassCall(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Bar("classcall", 30, L.classcall_bar, "Spell_Shadow_Charm")
			self:DelayedMessage("classcall", 27, "green", L.classcall_warning)
			self:Message("classcall", "red", nil, warnTable[args.spellId], "Spell_Shadow_Charm")
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
				self:Message("classcall", "red", nil, v[1], "Spell_Shadow_Charm")
			else
				self:Message("otherwarn", "red", nil, v[1], false)
			end
			return
		end
	end
end

