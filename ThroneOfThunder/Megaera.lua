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
mod:RegisterEnableMob(70212, 70235, 70247, 68065) -- Flaming Head, Frozen Head, Venomous Head, Megaera

--------------------------------------------------------------------------------
-- Locals
--
local frostOrFireDead = false
local breathCounter = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.breaths = "Breaths"
	L.breaths_desc = "Warnings related to all the different types of breaths."
	L.breaths_icon = 105050
	L.rampage_over = "Rampage over!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{139822, "FLASH", "ICON"},
		{139866, "FLASH", "SAY"}, {139909, "FLASH"},

		139458, {"breaths", "FLASH"}, "proximity", "berserk", "bosskill",
	}, {
		[139822] = "ej:6998", -- Fire Head
		[139866] = "ej:7002", -- Frost Head
		--[] = "ej:7004", -- Poison Head
		[139458] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Poison
		self:Log("SPELL_DAMAGE", "BreathDamage", 139839)
		self:Log("SPELL_CAST_START", "RotArmor", 139838)
	-- Frost
		self:Log("SPELL_DAMAGE", "BreathDamage", 139842)
		self:Log("SPELL_CAST_START", "ArcticFreeze", 139841)
		self:Log("SPELL_PERIODIC_DAMAGE", "IcyGround", 139909)
		self:RgisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- XXX Torrent of Ice needs to be switched to CLEU ASAP
	-- Fire
	self:Log("SPELL_DAMAGE", "BreathDamage", 137730)
	self:Log("SPELL_CAST_START", "IgniteFlesh", 137729)
	self:Log("SPELL_DAMAGE", "Cinders", 139836)
	self:Log("SPELL_AURA_APPLIED", "CindersApplied", 139822)
	self:Log("SPELL_AURA_REMOVED", "CindersRemoved", 139822)
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Rampage", "boss1")

	self:Death("Deaths", 70212, 70235, 70247, 68065)
end

function mod:OnEngage()
	frostOrFireDead = false
	breathCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- General
--

local function breaths()
	breathCounter = breathCounter + 1
	mod:Message("breaths", ("%s (%d)"):format(L["breaths"], breathCounter), "Attention", 105050) -- neutral breath icon
	mod:Bar("breaths", L["breaths"], 16.5, 105050)
end

do
	local prev = 0
	function mod:BreathDamage(args)
		if not UnitIsUnit(args.destName, "player") or self:Tank() then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage("breaths", CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash("breaths")
		end
	end
end

do
	local function rampageOver(spellId)
		mod:Message(spellId, L["rampage_over"], "Positive", spellId)
		if frostOrFireDead then
			mod:OpenProximity("proximity", 5)
		end
	end
	function mod:Rampage(unit, spellName, _, _, spellId)
		if spellId == 139458 then
			self:Bar("breaths", L["breaths"], 30, 105050) -- not sure if there is a point for this here, seeing it is as long as rampage duration
			self:Message(spellId, spellName, "Important", spellId, "Long")
			self:Bar(spellId, CL["cast"]:format(spellName), 30, spellId)
			self:ScheduleTimer(rampageOver, 30, spellId)
			self:CloseProximity("proximity")
			breathCounter = 0
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 70212 then -- Fire
		frostOrFireDead = true
	elseif args.mobId == 70235 then -- Frost
		frostOrFireDead = true
	elseif args.mobId == 70247 then -- Poison

	elseif args.mobId == 68065 then -- Megaera
		self:Win()
	end
end

--------------------------------------------------------------------------------
-- Poison Head
--

function mod:RotArmor()
	self:ScheduleTimer(breaths, 0.5)
end

--------------------------------------------------------------------------------
-- Frost Head
--

function mod:ArcticFreeze()
	self:ScheduleTimer(breaths, 0.5)
end

do
	local prev = 0
	function mod:IcyGround(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg)
	if msg:find("139866") then -- orrent of Ice
		-- XXX this should have an icon too, but lets not bother implementing it till CLEU is fixed for this event
		self:Say(139866, CL["say"]:format(self:SpellName(139866)))
		self:LocalMessage(139866, CL["you"]:format(self:SpellName(139866)), "Personal", 139866, "Info")
		self:Flash(139866)
	end
end

--------------------------------------------------------------------------------
-- Fire Head
--

function mod:IgniteFlesh()
	self:ScheduleTimer(breaths, 0.5)
end

do
	local prev = 0
	function mod:Cinders(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(139822, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(139822)
		end
	end
end

function mod:CindersRemoved(args)
	self:SecondaryIcon(args.spellId)
end

function mod:CindersApplied(args)
	self:SecondaryIcon(args.spellId, args.destName)
	if UnitIsUnit("player", args.destName) then
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
		self:Flash(args.spellId)
	elseif self:Dispeller("magic") then
		self:LocalMessage(args.spellId, args.spellName, "Important", args.spellId, "Alarm", args.destName)
	end
end


