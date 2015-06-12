
-- Notes --
-- Fel beam fixate

--------------------------------------------------------------------------------
-- Module Declaration
--

if GetBuildInfo() ~= "6.2.0" then return end

local mod, CL = BigWigs:NewBoss("Shadow-Lord Iskar", 1026, 1433)
if not mod then return end
mod:RegisterEnableMob(90316, 91591) -- 90316 in beta
mod.engageId = 1788

--------------------------------------------------------------------------------
-- Locals
--

local poundCount = 0 --???
local shadowEscapeCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{179202, "SAY", "FLASH"}, -- Eye of Anzu
		181956, -- Phantasmal Winds
		182323, -- Phantasmal Wounds
		{181824, "SAY", "PROXIMITY"}, -- Phantasmal Corruption
		{181753, "SAY"}, -- Fel Bomb
		{181912, "FLASH"}, -- Focused Blast
		{182582, "SAY"}, -- Fel Incineration
		181827, -- Fel Conduit
		{182200, "SAY"}, -- Fel Chakram
		{185510, "SAY"}, -- Dark Bindings
		185345, -- Shadow Riposte
		"stages",
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "EyeOfAnzu", 179202)
	self:Log("SPELL_CAST_SUCCESS", "PhantasmalWindsSuccess", 181956)
	self:Log("SPELL_AURA_APPLIED", "PhantasmalWinds", 185757, 181957)
	self:Log("SPELL_AURA_APPLIED", "PhantasmalWounds", 182325)
	self:Log("SPELL_AURA_APPLIED", "PhantasmalCorruption", 181824, 187990)
	self:Log("SPELL_AURA_REMOVED", "PhantasmalCorruptionRemoved", 181824, 187990)
	self:Log("SPELL_AURA_APPLIED", "FelBomb", 181753)
	self:Log("SPELL_CAST_START", "FocusedBlast", 181912)
	self:Log("SPELL_CAST_START", "FelConduit", 181827, 187998)
	self:Log("SPELL_AURA_APPLIED", "FelChakramApplied", 182200, 182178)
	self:Log("SPELL_CAST_START", "FelChakramStart", 182216)
	self:Log("SPELL_CAST_START", "DarkBindingsCast", 185510)
	self:Log("SPELL_AURA_APPLIED", "DarkBindings", 185510)
	self:Log("SPELL_CAST_START", "Stage2", 181873) -- Shadow Escape
	self:Log("SPELL_CAST_START", "ShadowRiposte", 185345)
	--self:Death("Deaths", 91543, 93625) --Corrupted Talonpriest,Phantasmal Resonance

	self:RegisterEvent("RAID_BOSS_WHISPER")
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Shadow-Lord Iskar (beta) engaged", false)
	if self:Mythic() then
		self:CDBar(185345, 9.5) -- Shadow Riposte
	end
	self:CDBar(181956, 16) -- Phantasmal Winds
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--function mod:Deaths(args)
	--cancel timers from the adds if needed
--end

function mod:ShadowRiposte(args)
	self:CDBar(args.spellId, 27)
end

function mod:PhantasmalWindsSuccess(args)
	self:CDBar(args.spellId, 35.5)
end

function mod:EyeOfAnzu(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", self:Me(args.destGUID) and "Info")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

do
	local list = mod:NewTargetList()
	function mod:PhantasmalWinds(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, 181956, list, "Attention")
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:PhantasmalWounds(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, 182323, list, "Attention")
		end
	end
end

function mod:PhantasmalCorruption(args)
	self:TargetBar(181824, 10, args.destName)
	self:TargetMessage(181824, args.destName, "Urgent", "Alert")
	if self:Me(args.destGUID) then
		self:Say(181824)
		self:OpenProximity(181824, 15) -- XXX verify obliteration range
	end
end

function mod:PhantasmalCorruptionRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(181824)
	end
	self:StopBar(args.spellName, args.destName)
end

function mod:FelBomb(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:FocusedBlast(args)
	self:Message(args.spellId, "Important", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 12)
	self:Flash(args.spellId)
end

function mod:FelConduit(args)
	self:Message(181827, "Important", "Long", CL.casting:format(args.spellName))
end

function mod:RAID_BOSS_WHISPER(event, msg)
	if msg:find(self:SpellName(182582)) then
		self:Message(182582, "Personal", "Alarm", CL.you:format(self:SpellName(182582)))
		self:Say(182582)
	end
end

do
	local list = mod:NewTargetList()
	function mod:FelChakramApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, 182200, list, "Attention", "Alert")
		end
		if self:Me(args.destGUID) then
			self:Say(182200)
		end
	end
end

function mod:FelChakramStart(args)
	self:CDBar(182200, 34)
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
	self:Message("stages", "Neutral", "Info", CL.stage:format(shadowEscapeCount), false)
	shadowEscapeCount = shadowEscapeCount + 1 -- For different adds and their timers if needed
	self:StopBar(185345) -- Shadow Riposte
	self:StopBar(181956) -- Phantasmal Winds
	self:StopBar(182200) -- Fel Chakram
end