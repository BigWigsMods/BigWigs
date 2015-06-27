
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shadow-Lord Iskar", 1026, 1433)
if not mod then return end
mod:RegisterEnableMob(90316, 91591) -- 91591 = ?
mod.engageId = 1788

--------------------------------------------------------------------------------
-- Locals
--

local shadowEscapeCount = 1
local windTargets = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_off_wind_marker = "Phantasmal Winds marker"
	L.custom_off_wind_marker_desc = "Marks Phantasmal Winds targets with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader."
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
		182323, -- Phantasmal Wounds
		--[[ Phase 2 ]]--
		{181912, "FLASH"}, -- Focused Blast
		{181753, "SAY"}, -- Fel Bomb
		181827, -- Fel Conduit
		{181824, "SAY", "PROXIMITY"}, -- Phantasmal Corruption
		{185510, "SAY"}, -- Dark Bindings
		--[[ General ]]--
		{179202, "SAY", "FLASH"}, -- Eye of Anzu
		185345, -- Shadow Riposte
		{182582, "SAY"}, -- Fel Incineration
		"stages",
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
	shadowEscapeCount = 1
	wipe(windTargets)
	if self:Mythic() then
		self:CDBar(185345, 9.5) -- Shadow Riposte
	end
	self:CDBar(181956, 16) -- Phantasmal Winds
	self:Bar(182200, 6) -- Fel Chakram
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
	self:TargetMessage(args.spellId, args.destName, "Positive")
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, #windTargets > 0 and "Warning" or "Info")
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:ShadowRiposte(args)
	self:CDBar(args.spellId, 27)
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
			self:Message(181956, "Attention", UnitBuff("player", self:SpellName(179202)) and "Warning")
		end
		isOnMe = nil
	end
	function mod:PhantasmalWindsApplied(args)
		windTargets[#windTargets + 1] = args.destName
		if #windTargets == 1 then
			self:ScheduleTimer(warn, 0.2, self, args.spellName)
			self:CDBar(181956, 36)
		end
		if self:Me(args.destGUID) then
			isOnMe = true
		end
		if self.db.profile.custom_off_wind_marker then
			SetRaidTarget(args.destName, #windTargets)
		end
	end
end

function mod:PhantasmalWindsRemoved(args)
	if self.db.profile.custom_off_wind_marker then
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
		end
	end
end

function mod:PhantasmalCorruption(args)
	self:TargetBar(181824, 10, args.destName)
	self:TargetMessage(181824, args.destName, "Urgent", "Alert")
	if self:Me(args.destGUID) then
		self:Say(181824)
		self:OpenProximity(181824, 8) -- XXX verify range (spell says 5 yards)
	end
	self:CDBar(181824, 16)
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
	self:Bar(args.spellId, 18.4)
end

function mod:FocusedBlast(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 12)
	self:DelayedMessage(args.spellId, 9, "Important", CL.incoming:format(args.spellName), nil, "Long")
	self:ScheduleTimer("Flash", 9, args.spellId)
end

function mod:FelConduit(args)
	self:Message(181827, "Urgent", "Alert")
	self:Bar(181827, 15.9)
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
end

do
	local list = mod:NewTargetList()
	function mod:DarkBindings(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, 185510, list, "Attention")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:Stage2() -- Shadow Escape
	self:Message("stages", "Neutral", "Info", CL.phase:format(2), false)
	shadowEscapeCount = shadowEscapeCount + 1 -- For different adds and their timers if needed
	self:StopBar(185345) -- Shadow Riposte
	self:StopBar(181956) -- Phantasmal Winds
	self:StopBar(182200) -- Fel Chakram
	self:Bar("stages", 40, CL.phase:format(1))

	-- event for when Iskar is attackable again?
	self:DelayedMessage("stages", 40, "Neutral", CL.phase:format(1), false, "Info")
	self:ScheduleTimer("Bar", 40, 182200, 6) -- Fel Chakram
end

do
	local prev = 0
	function mod:FelFireDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(182582)
			self:Message(182582, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end
