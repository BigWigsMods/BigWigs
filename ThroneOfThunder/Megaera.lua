--[[
TODO:
	torrent of ice needs to be switched to CLEU events when they actually get added
	maybe try and figure out if there is a system to how the fogged heads cast stuff
]]--
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Megaera", 930, 821)
if not mod then return end
mod:RegisterEnableMob(70248, 70212, 70235, 70247, 68065) -- Arcane Head, Flaming Head, Frozen Head, Venomous Head, Megaera

--------------------------------------------------------------------------------
-- Locals
--
local frostOrFireDead = nil
local breathCounter = 0
local breathTimerHandle = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.breaths = "Breaths"
	L.breaths_desc = "Warnings related to all the different types of breaths."
	L.breaths_icon = 105050

	L.arcane_adds = "Arcane adds"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		140138, 140179,
		{139822, "FLASH", "ICON"},
		{139866, "FLASH", "SAY"}, {139909, "FLASH"},

		139458, {"breaths", "FLASH"}, "proximity", "berserk", "bosskill",
	}, {
		[140138] = -7005, -- Heroic only, Arcane Head
		[139822] = -6998, -- Fire Head
		[139866] = -7002, -- Frost Head
		--[] = -7004, -- Poison Head
		[139458] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Arcane
	self:Log("SPELL_AURA_APPLIED", "Suppression", 140179)
	self:Log("SPELL_CAST_SUCCESS", "NetherTear", 140138)
	self:Log("SPELL_DAMAGE", "BreathDamage", 139992)
	self:Log("SPELL_CAST_START", "Diffusion", 139991)
	-- Poison
	self:Log("SPELL_DAMAGE", "BreathDamage", 139839)
	self:Log("SPELL_CAST_START", "RotArmor", 139838)
	-- Frost
	self:Log("SPELL_DAMAGE", "BreathDamage", 139842)
	self:Log("SPELL_CAST_START", "ArcticFreeze", 139841)
	self:Log("SPELL_PERIODIC_DAMAGE", "IcyGround", 139909)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- XXX Torrent of Ice needs to be switched to CLEU ASAP
	-- Fire
	self:Log("SPELL_DAMAGE", "BreathDamage", 137730)
	self:Log("SPELL_CAST_START", "IgniteFlesh", 137729)
	self:Log("SPELL_DAMAGE", "Cinders", 139836)
	self:Log("SPELL_AURA_APPLIED", "CindersApplied", 139822)
	self:Log("SPELL_AURA_REMOVED", "CindersRemoved", 139822)
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Rampage", "boss1")

	self:Death("Deaths", 70248, 70212, 70235, 70247, 68065)
end

function mod:OnEngage()
	frostOrFireDead = nil
	breathCounter = 0
	breathTimerHandle = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- General
--

local function breaths()
	breathCounter = breathCounter + 1
	mod:Message("breaths", "Attention", nil, CL["count"]:format(L["breaths"], breathCounter), L.breaths_icon) -- neutral breath icon
	mod:Bar("breaths", 16.5, L["breaths"], L.breaths_icon)
	breathTimerHandle = nil
end

do
	local prev = 0
	function mod:BreathDamage(args)
		if not self:Me(args.destGUID) or self:Tank() then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message("breaths", "Personal", "Info", CL["you"]:format(args.spellName), args.spellId)
			self:Flash("breaths")
		end
	end
end

do
	local function rampageOver(spellId, spellName)
		mod:Message(spellId, "Positive", nil, CL["over"]:format(spellName))
		if frostOrFireDead then
			mod:OpenProximity("proximity", 5)
		end
	end
	function mod:Rampage(unit, spellName, _, _, spellId)
		if spellId == 139458 then
			self:Bar("breaths", 30, L["breaths"], L.breaths_icon) -- not sure if there is a point for this here, seeing it is as long as rampage duration
			self:Message(spellId, "Important", "Long")
			self:Bar(spellId, 20, CL["cast"]:format(spellName))
			self:ScheduleTimer(rampageOver, 20, spellId, spellName)
			breathCounter = 0
		end
	end
end

function mod:Deaths(args)
	self:CloseProximity("proximity") -- this happens lot before rampage is applied, might as well do stuff here
	self:Message(139458, "Attention", nil, CL["soon"]:format(self:SpellName(139458))) -- Rampage
	if args.mobId == 70212 then -- Fire
		frostOrFireDead = true
	elseif args.mobId == 70235 then -- Frost
		frostOrFireDead = true
	elseif args.mobId == 70247 then -- Poison
	elseif args.mobId == 70248 then -- Arcane
	elseif args.mobId == 68065 then -- Megaera
		self:Win()
	end
end

--------------------------------------------------------------------------------
-- Arcane Head
--

function mod:Suppression(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent")
end

function mod:NetherTear(args)
	self:Message(args.spellId, "Urgent", "Alarm", L["arcane_adds"])
	self:Bar(args.spellId, 6, CL["cast"]:format(L["arcane_adds"])) -- this is to help so you know when all the adds have spawned
end

function mod:Diffusion()
	if not breathTimerHandle then breathTimerHandle = self:ScheduleTimer(breaths, 0.7) end

end

--------------------------------------------------------------------------------
-- Poison Head
--

function mod:RotArmor()
	if not breathTimerHandle then breathTimerHandle = self:ScheduleTimer(breaths, 0.7) end
end

--------------------------------------------------------------------------------
-- Frost Head
--

function mod:ArcticFreeze()
	if not breathTimerHandle then breathTimerHandle = self:ScheduleTimer(breaths, 0.7) end
end

do
	local prev = 0
	function mod:IcyGround(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg)
	if msg:find("139866") then -- Torrent of Ice
		-- XXX this should have an icon too, but lets not bother implementing it till CLEU is fixed for this event
		self:Say(139866)
		self:Message(139866, "Personal", "Info", CL["you"]:format(self:SpellName(139866)))
		self:Flash(139866)
	end
end

--------------------------------------------------------------------------------
-- Fire Head
--

function mod:IgniteFlesh()
	if not breathTimerHandle then breathTimerHandle = self:ScheduleTimer(breaths, 0.7) end
end

do
	local prev = 0
	function mod:Cinders(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(139822, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(139822)
		end
	end
end

function mod:CindersRemoved(args)
	self:SecondaryIcon(args.spellId)
end

function mod:CindersApplied(args)
	self:SecondaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
		self:Flash(args.spellId)
	elseif self:Dispeller("magic") then
		self:TargetMessage(args.spellId, args.destName, "Important", "Alarm", nil, nil, true )
	end
end

