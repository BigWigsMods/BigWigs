--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Romulo & Julianne", 532)
if not mod then return end
mod:RegisterEnableMob(17533, 17534) --Romulo, Julianne
mod:SetAllowWin(true)
mod:SetEncounterID(2447)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.name = "Romulo & Julianne"

	L.phase = "Phases"
	L.phase_desc = "Warn when entering a new Phase."
	L.phase1_trigger = "What devil art thou, that dost torment me thus?"
	L.phase1_message = "Act I - Julianne"
	L.phase2_trigger = "Wilt thou provoke me? Then have at thee, boy!"
	L.phase2_message = "Act II - Romulo"
	L.phase3_trigger = "Come, gentle night; and give me back my Romulo!"
	L.phase3_message = "Act III - Both"

	L.poison = "Poison"
	L.poison_desc = "Warn of a poisoned player."
	L.poison_icon = 30822
	L.poison_message = "Poisoned"

	L.heal = "Heal"
	L.heal_desc = "Warn when Julianne casts Eternal Affection."
	L.heal_icon = 30878
	L.heal_message = "Julianne casting Heal!"

	L.buff = "Self-Buff Alert"
	L.buff_desc = "Warn when Romulo & Julianne gain a self-buff."
	L.buff_icon = 30841
	L.buff1_message = "Romulo gains Daring!"
	L.buff2_message = "Julianne gains Devotion!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"phase", "heal", "buff", "poison"
	}
end

function mod:OnRegister()
	self.displayName = L.name
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Poison", 30822)
	self:Log("SPELL_CAST_START", "Heal", 30878)

	self:Log("SPELL_AURA_APPLIED", "Devotion", 30887)
	self:Log("SPELL_AURA_REMOVED", "DevotionRemoved", 30887)

	self:Log("SPELL_AURA_APPLIED", "Daring", 30841)
	self:Log("SPELL_AURA_REMOVED", "DaringRemoved", 30841)

	self:BossYell("Act1", L["phase1_trigger"])
	self:BossYell("Act2", L["phase2_trigger"])
	self:BossYell("Act3", L["phase3_trigger"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Poison(args)
	self:TargetMessageOld("poison", args.destName, "red", nil, L["poison_message"], args.spellId)
end

function mod:Heal(args)
	self:MessageOld("heal", "orange", nil, L["heal_message"], args.spellId)
end

function mod:Devotion(args)
	if self:MobId(args.destGUID) == 17534 then -- Julianne
		self:MessageOld("buff", "yellow", nil, L["buff2_message"], args.spellId)
		self:Bar("buff", 10, L["buff2_message"], args.spellId)
	end
end

function mod:DevotionRemoved(args)
	if self:MobId(args.destGUID) == 17534 then -- Julianne
		self:StopBar(L["buff2_message"])
	end
end

function mod:Daring(args)
	if self:MobId(args.destGUID) == 17533 then -- Julianne
		self:MessageOld("buff", "yellow", nil, L["buff1_message"], args.spellId)
		self:Bar("buff", 8, L["buff1_message"], args.spellId)
	end
end

function mod:DaringRemoved(args)
	if self:MobId(args.destGUID) == 17533 then -- Julianne
		self:StopBar(L["buff1_message"])
	end
end

function mod:Act1()
	self:MessageOld("phase", "green", nil, L["phase1_message"], false)
end

function mod:Act2()
	self:MessageOld("phase", "green", nil, L["phase2_message"], false)
end

function mod:Act3()
	self:MessageOld("phase", "green", nil, L["phase3_message"], false)
end

