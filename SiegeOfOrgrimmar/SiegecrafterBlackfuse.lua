--[[
TODO:

]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Siegecrafter Blackfuse", 953, 865)
if not mod then return end
mod:RegisterEnableMob(71504)

--------------------------------------------------------------------------------
-- Locals
--

local overloadCounter = 1
local assemblyLineCounter = 1
local shredder = EJ_GetSectionInfo(8199)
local sawbladeTarget
local function getBossByMobId(mobId)
	for i=1, 5 do
		if mod:MobId(UnitGUID("boss"..i)) == mobId then
			return "boss"..i
		end
	end
	return
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.shredder_engage_trigger = "An Automated Shredder draws near!"
	L.laser_on_you = "Laser on you PEW PEW!"
	L.laser_say = "Laser PEW PEW!"

	L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."
	L.assembly_line_message = "Unfinished weapons (%d)"

	L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{-8195, "FLASH", "SAY", "ICON"}, {145365, "TANK_HEALER"}, {143385, "TANK"}, -- Siegecrafter Blackfuse
		-8199, 144208, 145444, -- Automated Shredders
		-8202, -8207, 143639, {-8208, "FLASH", "SAY"}, 143856, 144466, {-8212, "FLASH"},
		"berserk", "bosskill",
	}, {
		[-8195] = -8194, -- Siegecrafter Blackfuse
		[-8199] = -8199, -- Automated Shredders
		[-8202] = -8202, -- The Assembly Line
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- The Assembly Line
	self:Emote("AssemblyLine", L["assembly_line_trigger"])
	self:Log("SPELL_AURA_APPLIED", "CrawlerMine", 145269)
	self:Log("SPELL_AURA_APPLIED", "MagneticCrush", 144466)
	self:Log("SPELL_AURA_APPLIED", "Superheated", 143856)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Superheated", 143856)
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:Yell("ShockwaveMissile", L["shockwave_missile_trigger"])
	self:Log("SPELL_AURA_APPLIED", "ShockwaveMissileOver", 143639)
	self:Log("SPELL_AURA_APPLIED", "PatternRecognitionApplied", 144236)
	self:Log("SPELL_AURA_REMOVED", "PatternRecognitionRemoved", 144236)
	-- Automated Shredders
	self:Emote("ShredderEngage", L["shredder_engage_trigger"])
	self:Log("SPELL_CAST_START", "DeathFromAbove", 144208)
	self:Log("SPELL_CAST_START", "DeathFromAboveApplied", 144210)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Overload", 145444)
	self:Log("SPELL_AURA_APPLIED", "Overload", 145444)
	-- Siegecrafter Blackfuse
	self:Log("SPELL_AURA_APPLIED_DOSE", "ElectrostaticCharge", 143385)
	self:Log("SPELL_AURA_APPLIED", "ProtectiveFrenzy", 145365)
	self:Log("SPELL_CAST_START", "Sawblade", 143265)
	self:Log("SPELL_CAST_SUCCESS", "SawbladeFallback", 143265)

	self:Death("ShredderDied", 71591)
	self:Death("Win", 71504)
end

function mod:OnEngage()
	assemblyLineCounter = 1
	self:Bar(-8199, 35, shredder, "INV_MISC_ARMORKIT_27") -- Shredder Engage
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- The Assembly Line

function mod:AssemblyLine()
	self:Message(-8202, "Neutral", "Warning", L["assembly_line_message"]:format(assemblyLineCounter), "Inv_crate_03")
	assemblyLineCounter = assemblyLineCounter + 1
	self:Bar(-8202, 40, CL["count"]:format((EJ_GetSectionInfo(8202)), assemblyLineCounter), "Inv_crate_03")
end

do
	local prev = 0
	function mod:CrawlerMine(args)
		local t = GetTime()
		if t-prev > 5 then -- XXX this still spams, rethink it maybe
			prev = t
			self:Message(-8212, "Urgent", nil, args.destName, 77976) -- mine like icon
		end
	end
end

do
	local prev = 0
	function mod:MagneticCrush(args)
		local t = GetTime()
		if t-prev > 15 then
			prev = t
			self:Message(args.spellId, "Important", "Long")
		end
	end
end

function mod:Superheated(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
	end
end

function mod:RAID_BOSS_WHISPER(_, msg, sender)
	if msg:find("Ability_Siege_Engineer_Superheated") then -- laser fixate
		-- might wanna do syncing to get range message working
		self:Message(-8208, "Personal", "Info", L.laser_on_you, 144040)
		self:Flash(-8208)
		self:Say(-8208, L.laser_say, true)
	elseif msg:find("Ability_Siege_Engineer_Detonate") then -- mine fixate
		self:Message(-8212, "Personal", "Info", CL["you"]:format(sender))
		self:Flash(-8212)
	elseif msg:find("143266") then -- Sawblade
		-- this is faster than target scanning, hence why we do it
		sawbladeTarget = UnitGUID("player")
		self:Message(-8195, "Positive", "Info", CL["you"]:format(self:SpellName(143266)))
		self:PrimaryIcon(-8195, "player")
		self:Flash(-8195)
		self:Say(-8195)
	end
end

function mod:ShockwaveMissile()
	self:Message(143639, "Urgent")
end

function mod:ShockwaveMissileOver(args)
	self:Message(args.spellId, "Urgent", nil, CL["over"]:format(args.spellName))
end

function mod:PatternRecognitionApplied(args)
	if self:Me(args.destGUID) then
		self:Bar(-8207, 60)
	end
end

function mod:PatternRecognitionRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(-8207, "Positive", CL["over"]:format(args.spellName))
	end
end

-- Automated Shredders

function mod:ShredderEngage()
	self:Message(-8199, "Attention", self:Tank() and "Long", shredder, "INV_MISC_ARMORKIT_27")
	self:Bar(-8199, 60, shredder, "INV_MISC_ARMORKIT_27")
	self:Bar(144208, 16) -- Death from Above
	overloadCounter = 1
	self:Bar(145444, 7, CL["count"]:format(self:SpellName(145444), overloadCounter)) -- Overload
end

function mod:DeathFromAboveApplied(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:DeathFromAbove(args)
	self:Message(args.spellId, "Attention", nil, CL["casting"]:format(args.spellName))
	self:Bar(args.spellId, 41)
end

function mod:Overload(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "Urgent", nil, CL["count"]:format(args.spellName, amount))
	overloadCounter = amount + 1
	self:Bar(args.spellId, 11, CL["count"]:format(args.spellName, overloadCounter))
end

function mod:ShredderDied()
	self:StopBar(144208) -- Death from Above
	self:StopBar(CL["count"]:format(self:SpellName(145444), overloadCounter)) -- Overload
end

-- Siegecrafter Blackfuse

function mod:ElectrostaticCharge(args)
	self:CDBar(args.spellId, 17)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Info")
end

function mod:ProtectiveFrenzy(args)
	self:Message(args.spellId, "Attention", "Long")
end

do
	-- rather do this than syncing
	local timer = nil
	local function warnSawblade(target, guid)
		local player = mod:UnitName(target)
		mod:PrimaryIcon(-8195, target)
		if mod:Range(target) < 8 then -- 8 is guessed
			mod:RangeMessage(-8195)
			mod:Flash(-8195)
		elseif not mod:Me(guid) then -- we warn for ourself from the BOSS_WHISPER
			mod:TargetMessage(-8195, player, "Positive", "Info")
		end
	end
	local function checkSawblade()
		local boss = getBossByMobId(71504)
		local target
		if boss and UnitExists(boss.."target") then
			target = boss.."target"
		end
		if target and (not UnitDetailedThreatSituation(target, boss) and not mod:Tank(target)) then
			sawbladeTarget = UnitGUID(target)
			warnSawblade(target, sawbladeTarget)
			mod:CancelTimer(timer)
			timer = nil
		end
	end
	function mod:Sawblade(args)
		self:CDBar(-8195, 11)
		sawbladeTarget = nil
		if not timer then
			timer = self:ScheduleRepeatingTimer(checkSawblade, 0.05)
		end
	end
	function mod:SawbladeFallback(args)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
		 -- don't do anything if we warned for the target already
		if args.destGUID ~= sawbladeTarget then
			warnSawblade(args.destName, args.destGUID)
		end
	end
end

