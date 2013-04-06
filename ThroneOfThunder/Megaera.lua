--[[
TODO:
	torrent of ice needs to be switched to CLEU events when they actually get added
	maybe try and figure out if there is a system to how the fogged heads cast stuff
]]--

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
local headCounter = 0

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
		{139822, "FLASH", "ICON", "DISPEL", "SAY"}, {137731, "HEALER"},
		{139866, "FLASH", "SAY"}, {139909, "FLASH"}, {139843, "TANK"}, 
		{139840, "HEALER"},
		139458, {"breaths", "FLASH"}, "proximity", "berserk", "bosskill",
	}, {
		[140138] = ("%s (%s)"):format(mod:SpellName(-7005), CL["heroic"]), -- Arcane Head
		[139822] = -6998, -- Fire Head
		[139866] = -7002, -- Frost Head
		[139840] = -7004, -- Poison Head
		[139458] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Arcane
	self:Log("SPELL_AURA_APPLIED", "Suppression", 140179)
	self:Log("SPELL_CAST_SUCCESS", "NetherTear", 140138)
	-- Frost
	self:Log("SPELL_PERIODIC_DAMAGE", "IcyGround", 139909)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- XXX Torrent of Ice needs to be switched to CLEU ASAP
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcticFreeze", 139843)
	-- Fire
	self:Log("SPELL_DAMAGE", "Cinders", 139836)
	self:Log("SPELL_AURA_APPLIED", "CindersApplied", 139822)
	self:Log("SPELL_AURA_REMOVED", "CindersRemoved", 139822)
	-- General
	self:Log("SPELL_DAMAGE", "BreathDamage", 137730, 139842, 139839, 139992)
	self:Log("SPELL_CAST_START", "Breaths", 137729, 139841, 139838, 139991)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Rampage", "boss1")
	self:Log("SPELL_AURA_APPLIED", "TankDebuffApplied", 137731, 139840) -- Fire, Poison, should probably add Diffusion
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankDebuffApplied", 137731, 139840)
	self:Log("SPELL_AURA_REMOVED", "TankDebuffRemoved", 137731, 139840)

	self:Death("Deaths", 70248, 70212, 70235, 70247) -- Arcane Head, Flaming Head, Frozen Head, Venomous Head
	self:Death("Win", 68065) -- Megaera
end

function mod:OnEngage()
	frostOrFireDead = nil
	breathCounter = 0
	headCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- General
--

function mod:TankDebuffApplied(args)
	local tank = self:Tank(args.destName)
	for i=1, 4 do
		local boss = ("boss%d"):format(i)
		if UnitDetailedThreatSituation(args.destName, boss) then
			tank = true
			break
		end
	end
	if tank then
		self:TargetBar(args.spellId, 45, args.destName)
	end
end

function mod:TankDebuffRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

do
	local prev = 0
	function mod:Breaths(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			breathCounter = breathCounter + 1
			self:Message("breaths", "Attention", nil, CL["count"]:format(L["breaths"], breathCounter), L.breaths_icon) -- neutral breath icon
			self:Bar("breaths", 16.5, L["breaths"], L.breaths_icon)
		end
	end
end

do
	local prev = 0
	function mod:BreathDamage(args)
		if not self:Me(args.destGUID) or self:Tank() then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message("breaths", "Personal", "Info", CL["you"]:format(args.spellName), args.spellId)
			self:Flash("breaths", args.spellId)
		end
	end
end

do
	local function rampageOver(spellId, spellName)
		mod:Message(spellId, "Positive", nil, CL["over"]:format(spellName))
		if frostOrFireDead and not mod:LFR() then
			mod:OpenProximity("proximity", 5)
		end
	end
	function mod:Rampage(unit, spellName, _, _, spellId)
		if spellId == 139458 then
			self:Bar("breaths", 30, L["breaths"], L.breaths_icon)
			self:Message(spellId, "Important", "Long", CL["count"]:format(spellName, headCounter))
			self:Bar(spellId, 20, CL["cast"]:format(spellName))
			self:ScheduleTimer(rampageOver, 20, spellId, spellName)
			breathCounter = 0
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 70235 or args.mobId == 70212 then
		frostOrFireDead = true
	end

	headCounter = headCounter + 1
	self:CloseProximity("proximity")
	self:Message(139458, "Attention", nil, CL["soon"]:format(CL["count"]:format(self:SpellName(139458), headCounter))) -- Rampage
	self:Bar(139458, 5, CL["incoming"]:format(self:SpellName(139458)))
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

--------------------------------------------------------------------------------
-- Frost Head
--

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

function mod:ArcticFreeze(args)
	if args.amount > 3 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Warning")
	end
end

--------------------------------------------------------------------------------
-- Fire Head
--

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

function mod:CindersApplied(args)
	self:SecondaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
		self:TargetBar(args.spellId, 30, args.destName)
		self:Flash(args.spellId)
		self:Say(args.spellId)
	elseif self:Dispeller("magic", nil, args.spellId) then
		self:TargetMessage(args.spellId, args.destName, "Important", "Alarm", nil, nil, true)
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

function mod:CindersRemoved(args)
	self:SecondaryIcon(args.spellId)
	self:StopBar(args.spellId, args.destName)
end

