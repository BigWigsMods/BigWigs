
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shadow-Lord Iskar", 1026, 1433)
if not mod then return end
mod:RegisterEnableMob(90316)
mod.engageId = 1788
mod.respawnTime = 20

--------------------------------------------------------------------------------
-- Locals
--

local shadowEscapeCount = 0
local nextPhase, nextPhaseSoon = 70, 75.5
local windTargets = {}
local eyeTarget = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_off_wind_marker = "Phantasmal Winds marker"
	L.custom_off_wind_marker_desc = "Marks Phantasmal Winds targets with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_wind_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Phase 1 ]]--
		{182200, "SAY", "FLASH"}, -- Fel Chakram
		181956, -- Phantasmal Winds
		"custom_off_wind_marker",
		{182323, "HEALER"}, -- Phantasmal Wounds
		185345, -- Shadow Riposte
		--[[ Phase 2 ]]--
		{181912, "FLASH"}, -- Focused Blast
		{181753, "SAY"}, -- Fel Bomb
		181827, -- Fel Conduit
		{181824, "SAY", "PROXIMITY"}, -- Phantasmal Corruption
		{185510, "SAY"}, -- Dark Bindings
		--[[ General ]]--
		{179202, "FLASH"}, -- Eye of Anzu
		{182582, "SAY"}, -- Fel Incineration
		"stages",
		"berserk",
	}, {
		[182200] = CL.phase:format(1),
		[181912] = CL.phase:format(2),
		[179202] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "EyeOfAnzu", 179202)
	self:Log("SPELL_CAST_SUCCESS", "PhantasmalWinds", 181956)
	self:Log("SPELL_AURA_APPLIED", "PhantasmalWindsApplied", 185757, 181957)
	self:Log("SPELL_AURA_REMOVED", "PhantasmalWindsRemoved", 185757, 181957)
	self:Log("SPELL_AURA_APPLIED", "PhantasmalWounds", 182325)
	self:Log("SPELL_AURA_APPLIED", "PhantasmalCorruption", 181824, 187990)
	self:Log("SPELL_AURA_REMOVED", "PhantasmalCorruptionRemoved", 181824, 187990)
	self:Log("SPELL_AURA_APPLIED", "FelBomb", 181753)
	self:Log("SPELL_CAST_START", "FocusedBlast", 181912)
	self:Log("SPELL_CAST_START", "FelConduit", 181827, 187998)
	self:Log("SPELL_AURA_APPLIED", "FelChakram", 182200, 182178)
	self:Log("SPELL_CAST_START", "DarkBindingsCast", 185510)
	self:Log("SPELL_AURA_APPLIED", "DarkBindings", 185510)
	self:Log("SPELL_CAST_START", "Stage2", 181873) -- Shadow Escape
	self:Log("SPELL_CAST_START", "ShadowRiposte", 185345)
	self:Log("SPELL_AURA_APPLIED", "FelFireDamage", 182600)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelFireDamage", 182600)
	self:Log("SPELL_PERIODIC_MISSED", "FelFireDamage", 182600)

	self:RegisterEvent("RAID_BOSS_WHISPER")

	self:Death("Deaths", 91543, 91541, 91539, 93625) -- Corrupted Talonpriest, Shadowfel Warden, Fel Raven, Phantasmal Resonance
end

function mod:OnEngage()
	shadowEscapeCount = 0
	nextPhase, nextPhaseSoon = 70, 75.5
	eyeTarget = nil
	wipe(windTargets)
	if self:Mythic() then
		self:CDBar(185345, 9.5) -- Shadow Riposte
	end
	-- normal modifier 1.25 for all CDs?
	self:Bar(182200, self:Normal() and 6.5 or 5.5) -- Fel Chakram
	self:CDBar(181956, self:Normal() and 21 or 17) -- Phantasmal Winds
	self:CDBar(182323, self:Normal() and 34 or 25) -- Phantasmal Wounds
	self:Berserk(540)
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths(args)
	if args.mobId == 91543 then -- Corrupted Talonpriest
		self:StopBar(181753) -- Fel Bomb
	elseif args.mobId == 91541 then -- Shadowfel Warden
		self:StopBar(181827) -- Fel Conduit
	elseif args.mobId == 91539 then -- Fel Raven
		self:StopBar(181824) -- Phantasmal Corruption
	elseif args.mobId == 93625 then -- Phantasmal Resonance
		self:StopBar(185510) -- Dark Bindings
	end
end

function mod:EyeOfAnzu(args)
	eyeTarget = args.destGUID
	self:TargetMessage(args.spellId, args.destName, "Positive")
	if self:Me(eyeTarget) then
		self:PlaySound(args.spellId, #windTargets > 0 and "Warning" or "Info")
		self:Flash(args.spellId)
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(185345, name, "Important", "Long") -- Warning is used in Eye+Winds events, so Long here to be distinct
	end
	function mod:ShadowRiposte(args)
		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
		self:CDBar(args.spellId, 27)
	end
end

function mod:PhantasmalWinds(args)
	wipe(windTargets)
end

do
	local isOnMe = nil, nil
	local function warn(self, spellName)
		if isOnMe then
			self:Message(181956, "Personal" , "Alarm", CL.you:format(spellName))
		else
			self:Message(181956, "Attention", UnitBuff("player", self:SpellName(179202)) and "Warning") -- Warning if you have the Eye
		end
		isOnMe = nil
	end
	function mod:PhantasmalWindsApplied(args)
		windTargets[#windTargets + 1] = args.destName
		if #windTargets == 1 then
			self:ScheduleTimer(warn, 0.3, self, args.spellName)
			self:CDBar(181956, self:Normal() and 45 or 36)
		end
		if self:Me(args.destGUID) then
			isOnMe = true
		end
		if self:GetOption("custom_off_wind_marker") then
			SetRaidTarget(args.destName, #windTargets)
		end
	end
end

function mod:PhantasmalWindsRemoved(args)
	if self:GetOption("custom_off_wind_marker") then
		SetRaidTarget(args.destName, 0)
	end
	tDeleteItem(windTargets, args.destName)
end

do
	local prev = 0
	function mod:PhantasmalWounds(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(182323, "Urgent")
			self:CDBar(182323, self:Normal() and 40 or 28)
		end
	end
end

function mod:PhantasmalCorruption(args)
	if args.destGUID ~= eyeTarget then
		self:TargetBar(181824, 10, args.destName)
		self:TargetMessage(181824, args.destName, "Urgent", "Warning", nil, nil, true)
		if self:Me(args.destGUID) then
			self:Say(181824)
			self:OpenProximity(181824, 8) -- XXX verify range (spell says 5 yards)
		end
	end
	self:CDBar(181824, self:Normal() and 19.5 or 16)
end

function mod:PhantasmalCorruptionRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(181824)
	end
	self:StopBar(181824, args.destName)
end

function mod:FelBomb(args)
	self:TargetMessage(args.spellId, args.destName, "Important", self:Dispeller("magic") and "Alert")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:Bar(args.spellId, self:Normal() and 23 or 18.4)
end

function mod:FocusedBlast(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 12)
	self:DelayedMessage(args.spellId, 9, "Important", CL.incoming:format(args.spellName), nil, "Long")
	self:ScheduleTimer("Flash", 9, args.spellId)
end

function mod:FelConduit(args)
	self:Message(181827, "Urgent", "Alert")
	self:Bar(181827, self:Normal() and 19.3 or 15.9)
end

function mod:RAID_BOSS_WHISPER(event, msg)
	if msg:find(182582) then -- Fel Incineration
		self:Message(182582, "Personal", "Alarm", CL.you:format(self:SpellName(182582)))
		self:Say(182582)
	end
end

do
	local list = mod:NewTargetList()
	function mod:FelChakram(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 182200, list, "Attention", "Alert")
			self:CDBar(182200, 34)
		end
		if self:Me(args.destGUID) then
			self:Say(182200)
			self:Flash(182200)
		end
	end
end

function mod:DarkBindingsCast(args)
	self:Message(args.spellId, "Urgent", "Info", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 34)
end

function mod:DarkBindings(args)
	list[#list+1] = args.destName
	if #list == 1 then
		self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention")
	end
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:Stage2() -- Shadow Escape
	self:StopBar(185345) -- Shadow Riposte
	self:StopBar(181956) -- Phantasmal Winds
	self:StopBar(182200) -- Fel Chakram
	shadowEscapeCount = shadowEscapeCount + 1

	self:Message("stages", "Neutral", "Info", ("%d%% - %s"):format(nextPhase, CL.phase:format(2)), false)
	nextPhase = nextPhase - 25
	self:ScheduleTimer("Stage1", 40) -- event for when Iskar is attackable again?
	self:Bar("stages", 40, CL.phase:format(1), "achievement_boss_hellfire_felarakkoa")
	self:Bar(181912, 20) -- Focused Blast
	self:CDBar(181753, self:Normal() and 21 or 15.5) -- Fel Bomb, 15.5-17.4
	if shadowEscapeCount > 1 then -- Fel Warden
		self:Bar(181827, self:Normal() and 7 or 6) -- Fel Conduit
	end
	if shadowEscapeCount > 2 then -- Fel Raven
		self:Bar(181824, self:Normal() and 27 or 22) -- Phantasmal Corruption
	end
	if self:Mythic() then
		self:Bar(185510, 21) -- Dark Bindings
	end
end

function mod:Stage1() -- Shadow Escape over
	self:StopBar(181912) -- Focused Blast
	self:Message("stages", "Neutral", "Info", CL.phase:format(1), false)
	if self:Mythic() then
		self:CDBar(185345, 10.5) -- Shadow Riposte
	end
	self:CDBar(182200, self:Normal() and 10 or 5.5) -- Fel Chakram (doesn't always happen?)
	--self:CDBar(181956, 20) -- Phantasmal Winds
	--self:CDBar(182323, 22) -- Phantasmal Wounds
end

do
	local prev = 0
	function mod:FelFireDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(182582, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextPhaseSoon then
		nextPhaseSoon = nextPhaseSoon - 25
		if nextPhaseSoon < 20 then
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
		self:Message("stages", "Neutral", nil, CL.soon:format(CL.phase:format(2)), false)
	end
end

