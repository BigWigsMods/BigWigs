--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nightbane Raid", 532)
if not mod then return end
mod:RegisterEnableMob(17225)
mod:SetAllowWin(true)
mod:SetEncounterID(2454)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.name = "Nightbane"

	L.phase = "Phases"
	L.phase_desc = "Warn when Nightbane switches between phases."
	L.airphase_trigger = "Miserable vermin. I shall exterminate you from the air!"
	L.landphase_trigger1 = "Enough! I shall land and crush you myself!"
	L.landphase_trigger2 = "Insects! Let me show you my strength up close!"
	L.airphase_message = "Flying!"
	L.landphase_message = "Landing!"
	L.summon_trigger = "An ancient being awakens in the distance..."

	L.engage_trigger = "What fools! I shall bring a quick end to your suffering!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"phase", 36922, {30129, "FLASH"}, 37098
	}
end

function mod:OnRegister()
	self.displayName = L.name
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Fear", 36922)
	self:Log("SPELL_AURA_APPLIED", "CharredEarth", 30129)
	self:Log("SPELL_CAST_SUCCESS", "Bones", 37098)

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:BossYell("Air", L["airphase_trigger"])
	self:BossYell("Land", L["landphase_trigger1"], L["landphase_trigger2"])

	self:BossYell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 17225)
end

function mod:OnEngage()
	local spellId = 36922
	local fear = self:SpellName(spellId)
	self:MessageOld(spellId, "green", nil, CL["custom_start_s"]:format(self.displayName, fear, 35), false)
	self:CDBar(spellId, 35)
	self:DelayedMessage(spellId, 33, "green", CL["soon"]:format(fear))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fear(args)
	self:Bar(args.spellId, 2.5, "<"..args.spellName..">")
	self:MessageOld(args.spellId, "green")
	self:CDBar(args.spellId, 37)
	self:DelayedMessage(args.spellId, 35, "green", CL["soon"]:format(args.spellName))
end

function mod:CharredEarth(args)
	if self:Me(args.destGUID) then
		self:MessageOld(args.spellId, "blue", "alarm", CL["underyou"]:format(args.spellName))
		self:Flash(args.spellId)
	end
end

function mod:Bones(args)
	self:MessageOld(args.spellId, "orange")
	self:Bar(args.spellId, 11, "<"..args.spellName..">")
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if msg == L["summon_trigger"] then
		self:Bar("phase", 34, L["landphase_message"], "INV_Misc_Head_Dragon_01")
	end
end

function mod:Air()
	self:CancelDelayedMessage(CL["soon"]:format(self:SpellName(36922)))
	self:StopBar(36922) -- Fear

	self:MessageOld("phase", "yellow", "info", L["airphase_message"], "INV_Misc_Head_Dragon_01")
	self:Bar("phase", 57, L["landphase_message"], "INV_Misc_Head_Dragon_01")
end

function mod:Land()
	self:MessageOld("phase", "red", "long", L["landphase_message"], "INV_Misc_Head_Dragon_01")
	self:Bar("phase", 17, L["landphase_message"], "INV_Misc_Head_Dragon_01")
end

