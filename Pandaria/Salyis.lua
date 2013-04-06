
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Salyis's Warband", 807, 725)
if not mod then return end
mod:RegisterEnableMob(62346)
mod.otherMenu = 6
mod.worldBoss = 62346

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "Bring me their corpses!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		121600, 121787, -6200,
		"bosskill",
	}
end

function mod:OnBossEnable()
	self:Emote("CannonBarrage", "spell:121600")
	self:Emote("Stomp", "spell:121787")
	self:Yell("Engage", L.engage_yell)

	self:Death("Win", 62346) --Galleon
end

function mod:OnEngage()
	self:Bar(121600, 23) -- Cannon Barrage
	self:Bar(121787, 50) -- Stomp
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CannonBarrage()
	self:Message(121600, "Urgent", nil, CL["incoming"]:format(self:SpellName(121600))) -- Cannon Barrage
	self:Bar(121600, 60) -- Cannon Barrage
end

function mod:Stomp()
	self:Message(121787, "Important", "Alarm", CL["incoming"]:format(self:SpellName(121787))) -- Stomp
	self:Bar(121787, 60) -- Stomp
	self:DelayedMessage(-6200, 10, "Attention", CL["incoming"]:format(self:SpellName(-6200)), 121747) -- Impaling Throw icon
end

