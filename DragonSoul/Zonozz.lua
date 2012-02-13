--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Warlord Zon'ozz", 824, 324)
if not mod then return end
mod:RegisterEnableMob(55308)

local ballTimer = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Zzof Shuul'wah. Thoq fssh N'Zoth!"

	L.ball = "Void ball"
	L.ball_desc = "Void ball that bounces off of players and the boss."
	L.ball_icon = 28028 -- void sphere icon
	L.ball_yell = "Gul'kafh an'qov N'Zoth."

	L.bounce = "Void ball bounce"
	L.bounce_desc = "Counter for the void ball bounces."
	L.bounce_icon = 73981 -- some bouncing bullet like icon

	L.darkness = "Tentacle disco party!"
	L.darkness_desc = "This phase starts, when the void ball hits the boss."
	L.darkness_icon = 109413

	L.shadows = "Shadows"

	L.drain, L.drain_desc = EJ_GetSectionInfo(3971)
	L.drain_icon = 104322
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ball", "bounce", "darkness",
		"drain", {103434, "FLASHSHAKE", "SAY", "PROXIMITY"},
		"berserk", "bosskill",
	}, {
		ball = "ej:3973",
		drain = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Darkness")
	self:Log("SPELL_CAST_SUCCESS", "PsychicDrain", 104322, 104607, 104608, 104606)
	self:Log("SPELL_AURA_APPLIED", "ShadowsApplied", 103434, 104600, 104601, 104599)
	self:Log("SPELL_AURA_REMOVED", "ShadowsRemoved", 103434, 104600, 104601, 104599)
	self:Log("SPELL_CAST_SUCCESS", "ShadowsCast", 103434, 104600, 104601, 104599)
	self:Log("SPELL_AURA_APPLIED", "VoidDiffusion", 106836)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidDiffusion", 106836)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Yell("VoidoftheUnmaking", L["ball_yell"])

	self:Death("Win", 55308)
end

function mod:OnEngage(diff)
	if not self:LFR() then
		self:Berserk(360) -- confirmed 10 man heroic
	end
	self:Bar("ball", L["ball"], 6, L["ball_icon"])
	self:Bar(103434, "~"..GetSpellInfo(103434), 23, 103434) -- Shadows
	self:Bar("drain", L["drain"], 17, 104322)
	ballTimer = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Darkness(_, unit, spellName, _, _, spellId)
	if unit == "boss1" and spellId == L["darkness_icon"] then
		self:Bar("darkness", L["darkness"], 30, spellId)
		self:Message("darkness", L["darkness"], "Important", spellId, "Info")
		self:Bar(103434, "~"..GetSpellInfo(103434), 37, 103434) -- Shadows
		local isHC = self:Difficulty() > 2 and 45 or 54
		if (GetTime() - ballTimer) > isHC then
			self:Bar("ball", L["ball"], isHC == 45 and isHC or 36, L["ball_icon"])
		end
		self:SendMessage("BigWigs_StopBar", self, "~"..L["drain"])
	end
end

function mod:VoidDiffusion(_, spellId, _, _, spellName, stack)
	self:Message("bounce", ("%s (%d)"):format(L["bounce"], stack or 1), "Important", spellId)
end

function mod:PsychicDrain(_, spellId, _, _, spellName)
	self:Bar("drain", "~"..spellName, 20, spellId)
	self:Message("drain", spellName, "Urgent", spellId)
end

function mod:VoidoftheUnmaking()
	if ballTimer ~= 0 then
		self:Bar("drain", L["drain"], 8.3, L["drain_icon"])
	end
	ballTimer = GetTime()
	self:Bar("ball", L["ball"], 90, L["ball_icon"])
	self:Message("ball", L["ball"], "Urgent", L["ball_icon"], "Alarm")
end

function mod:ShadowsCast(_, spellId, _, _, spellName)
	self:Message(103434, spellName, "Attention", spellId)
	self:Bar(103434, "~"..spellName, 26, spellId) -- 26-29
end

function mod:ShadowsApplied(player, spellId)
	if UnitIsUnit(player, "player") and not self:LFR() then
		self:LocalMessage(103434, CL["you"]:format(L["shadows"]), "Personal", spellId, "Alert")
		self:Say(103434, CL["say"]:format(L["shadows"]))
		self:FlashShake(103434)
		if self:Difficulty() > 2 then
			self:OpenProximity(10, 103434)
		end
	end
end

function mod:ShadowsRemoved(player)
	if UnitIsUnit(player, "player") and not self:LFR() then
		self:CloseProximity(103434)
	end
end

