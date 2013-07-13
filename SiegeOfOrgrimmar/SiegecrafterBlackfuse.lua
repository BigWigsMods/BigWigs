--[[
TODO:
	timers have to be double checked
]]--

if GetBuildInfo() ~= "5.4.0" then return end -- 4th return is 50300 on the PTR ATM so can't use that
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Siegecrafter Blackfuse", 953, 865)
if not mod then return end
mod:RegisterEnableMob(71504)

--------------------------------------------------------------------------------
-- Locals
--

local assemblyLineCounter = 1
local shredder = EJ_GetSectionInfo(8199)
local sawbladeTarget

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
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{-8195, "FLASH", "SAY", "ICON"}, {145365, "TANK_HEALER"}, {143385, "TANK"}, -- Siegecrafter Blackfuse
		-8199, 144208, -- Automated Shredders
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
	self:Log("SPELL_AURA_APPLIED", "ShockwaveMissile", 143639)
	self:Log("SPELL_AURA_APPLIED", "PatternRecognitionApplied", 144236)
	self:Log("SPELL_AURA_REMOVED", "PatternRecognitionRemoved", 144236)
	-- Automated Shredders
	self:Emote("ShredderEngage", L["shredder_engage_trigger"])
	self:Log("SPELL_CAST_START", "DeathFromAbove", 144208)
	self:Log("SPELL_CAST_START", "DeathFromAboveApplied", 144210)
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
	self:Bar(-8199, 35) -- Shredder Engage
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

function mod:CrawlerMine(args)
	self:Message(-8212, "Urgent", nil, args.destName, 77976) -- mine like icon
end

function mod:MagneticCrush(args)
	self:Message(args.spellId, "Important", "Long")
end

function mod:Superheated(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
	end
end

function mod:RAID_BOSS_WHISPER(msg, sender)
	if msg:find("Ability_Siege_Engineer_Superheated") then -- laser fixate
		-- might wanna do syncing to get range message working
		self:Message(-8208, "Personal", "Info", L.laser_on_you, 144040)
		self:Flash(-8208)
		self:Say(-8208, L.laser_say, true)
	elseif msg:find("Ability_Siege_Engineer_Detonate") then -- mine fixate
		self:Message(-8212, "Persoanl", "Info", CL["you"]:format(sender))
		self:Flash(-8212)
	elseif msg:find("143266") then -- Sawblade
		-- this is faster than target scanning, hence why we do it
		sawbladeTarget = UnitGUID("player")
		self:TargetMessage(-8195, self:UnitName("player"), "Positive", "Info")
		self:PrimaryIcon(-8195, "player")
		self:Flash(-8195)
		self:Say(-8195)
	end
end

function mod:ShockwaveMissile(args)
	self:Message(args.spellId, "Urgent")
end

function mod:PatternRecognitionApplied(args)
	if self:Me(args.destGUID) then
		self:Bar(-8207, 60)
	end
end

function mod:PatternRecognitionRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(-8207, "Positive")
	end
end

-- Automated Shredders

function mod:ShredderEngage()
	self:Message(-8199, "Attention", self:Tank() and "Long", shredder)
	self:Bar(-8199, 121, shredder)
	self:Bar(144208, 16)
end

function mod:DeathFromAboveApplied(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:DeathFromAbove(args)
	self:Message(args.spellId, "Attention", nil, CL["casting"]:format(args.spellName))
	self:Bar(args.spellId, 41)
end

function mod:ShredderDied()
	self:StopBar(144208)
end

-- Siegecrafter Blackfuse

function mod:ElectrostaticCharge(args)
	self:CDBar(args.spellId, 18)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Info")
end

function mod:ProtectiveFrenzy(args)
	self:Message(args.spellId, "Attention", "Long")
end

do
	-- rather do this than syncing
	local timer = nil
	local function warnSawblade(player, guid)
		mod:TargetMessage(-8195, player, "Positive", "Info")
		mod:PrimaryIcon(-8195, player)
		if mod:Me(guid) then
			mod:Flash(-8195)
			mod:Say(-8195)
		end
		if mod:Range(player) < 8 then -- 8 is guessed
			mod:RangeMessage(-8195)
			mod:Flash(-8195)
		end
	end
	local function checkSawblade()
		local player = mod:UnitName("boss1target")
		if player and (not UnitDetailedThreatSituation("boss1target", "boss1") and not mod:Tank("boss1target")) then
			sawbladeTarget = UnitGUID("boss1target")
			warnSawblade(player, sawbladeTarget)
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

