
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Siegecrafter Blackfuse", 953, 865)
if not mod then return end
mod:RegisterEnableMob(71504, 72981) -- Siegecrafter Blackfuse, Aggron
mod.engageId = 1601

--------------------------------------------------------------------------------
-- Locals
--

local overloadCounter = 1
local markableMobs = {}
local marksUsed = {}
local markTimer
local assemblyLineCounter = 1
local sawbladeTarget

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.overcharged_crawler_mine = "Overcharged Crawler Mine" -- sadly this is needed since they have same mobId

	L.saw_blade_near_you = "Saw blade near you (not on you)"
	L.saw_blade_near_you_desc = "You might want to turn this off to avoid spam if your raid is mostly bunched up according to your tactics."
	L.saw_blade_near_you_icon = 143265

	L.disabled = "Disabled"

	L.shredder_engage_trigger = "An Automated Shredder draws near!"
	L.laser_on_you = "Laser on you PEW PEW!"

	L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."
	L.assembly_line_message = "Unfinished weapons (%d)"
	L.assembly_line_items = "Items (%d): %s"
	L.item_missile = "Missile"
	L.item_mines = "Mines"
	L.item_laser = "Laser"
	L.item_magnet = "Magnet"
	L.item_deathdealer = "Deathdealer"

	L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!"

	L.custom_off_mine_marker = "Mine marker"
	L.custom_off_mine_marker_desc = "Mark the mines for specific stun assignments. (All the marks are used)"
end
L = mod:GetLocale()

local itemNames = {
	[71606] = L.item_missile, -- Deactivated Missile Turret
	[71790] = L.item_mines, -- Disassembled Crawler Mines
	[71751] = L.item_laser, -- Deactivated Laser Turret
	[71694] = L.item_magnet, -- Deactivated Electromagnet
	[72904] = L.item_deathdealer, -- Deactivated Deathdealer Turret
	[71638] = L.item_missile, -- Activated Missile Turret
	[71795] = L.item_mines, -- Activated Crawler Mine Vehicle
	[71752] = L.item_laser, -- Activated Laser Turret
	[71696] = L.item_magnet, -- Activated Electromagnet
	[72905] = L.item_deathdealer, -- Activated Deathdealer Turret
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_off_mine_marker",
		-8408,
		{-8195, "FLASH", "SAY", "ICON"}, "saw_blade_near_you", 145365, {143385, "TANK"}, -- Siegecrafter Blackfuse
		-8199, 144208, 145444, -- Automated Shredders
		-8202, -8207, 143639, {-8208, "FLASH", "SAY"}, 143856, 144466, {-8212, "FLASH"},
		{146479, "FLASH", "SAY", "ICON"}, "berserk", "bosskill",
	}, {
		["custom_off_mine_marker"] = L.custom_off_mine_marker,
		[-8408] = "mythic",
		[-8195] = -8194, -- Siegecrafter Blackfuse
		[-8199] = -8199, -- Automated Shredders
		[-8202] = -8202, -- The Assembly Line
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "Overcharge", 145774)
	-- The Assembly Line
	self:Emote("AssemblyLine", L.assembly_line_trigger)
	self:Log("SPELL_AURA_APPLIED", "CrawlerMine", 145269)
	self:Log("SPELL_AURA_APPLIED", "MagneticCrush", 144466)
	self:Log("SPELL_AURA_APPLIED", "Superheated", 143856)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Superheated", 143856)
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:Yell("ShockwaveMissile", L.shockwave_missile_trigger)
	self:Log("SPELL_AURA_APPLIED", "ShockwaveMissileOver", 143639)
	self:Log("SPELL_AURA_APPLIED", "PatternRecognitionApplied", 144236)
	self:Log("SPELL_AURA_REMOVED", "PatternRecognitionRemoved", 144236)
	-- Automated Shredders
	self:Log("SPELL_CAST_SUCCESS", "AddMarkedMob", 145269) -- break in
	self:Emote("ShredderEngage", L.shredder_engage_trigger)
	self:Log("SPELL_CAST_START", "DeathFromAbove", 144208)
	self:Log("SPELL_CAST_START", "DeathFromAboveApplied", 144210)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Overload", 145444)
	self:Log("SPELL_AURA_APPLIED", "Overload", 145444)
	-- Siegecrafter Blackfuse
	self:Log("SPELL_CAST_SUCCESS", "ElectrostaticCharge", 143385)
	self:Log("SPELL_AURA_APPLIED", "ElectrostaticChargeApplied", 143385)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ElectrostaticChargeApplied", 143385)
	self:Log("SPELL_AURA_APPLIED", "ProtectiveFrenzy", 145365)
	self:Log("SPELL_CAST_START", "Sawblade", 143265)
	self:Log("SPELL_CAST_SUCCESS", "SawbladeFallback", 143265)
	-- Goro'dan (trash)
	self:Log("SPELL_AURA_APPLIED", "Drillstorm", 146479)
	self:Log("SPELL_AURA_REMOVED", "DrillstormRemoved", 146479)

	self:Death("ShredderDied", 71591)
end

function mod:OnEngage()
	self:Berserk(self:Mythic() and 540 or 600)
	assemblyLineCounter = 1
	self:Bar(-8199, 35, nil, "INV_MISC_ARMORKIT_27") -- Shredder Engage
	self:CDBar(-8195, 9) -- Sawblade
	if self.db.profile.custom_off_mine_marker then
		wipe(markableMobs)
		wipe(marksUsed)
		markTimer = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Mythic
-- Marking
do
	local function setMark(unit, guid)
		for mark = 1, 8 do
			if not marksUsed[mark] then
				SetRaidTarget(unit, mark)
				markableMobs[guid] = "marked"
				marksUsed[mark] = guid
				return
			end
		end
	end

	local function markMobs()
		for guid in next, markableMobs do
			if markableMobs[guid] == true then
				local unit = mod:GetUnitIdByGUID(guid)
				if unit then
					setMark(unit, guid)
				end
			end
		end
	end

	function mod:UPDATE_MOUSEOVER_UNIT()
		local guid = UnitGUID("mouseover")
		if guid and markableMobs[guid] == true then
			setMark("mouseover", guid)
		elseif guid and UnitName("mouseover") == L.overcharged_crawler_mine and not markableMobs[guid] then -- overcharged crawler mine
			markableMobs[guid] = true
			setMark("mouseover", guid)
		end
	end

	function mod:AddMarkedMob(args)
		if not markableMobs[args.sourceGUID] and L.overcharged_crawler_mine == args.sourceName then
			markableMobs[args.sourceGUID] = true
			if self.db.profile.custom_off_mine_marker and not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.1)
			end
		end
	end

	function mod:Overcharge(args)
		local mobId = self:MobId(args.destGUID)
		self:Message(-8408, "Important", nil, CL.other:format(args.spellName, itemNames[mobId]), false)
		if self.db.profile.custom_off_mine_marker and mobId == 71790 then -- mines
			wipe(markableMobs)
			wipe(marksUsed)
			markTimer = nil
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
			if not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.1)
			end
		end
	end
end

-- The Assembly Line

do
	-- this helps people trying to figure out tactics
	local items = {}
	local function beltItems(count)
		for i=1, 5 do
			local mobId = mod:MobId(UnitGUID("boss"..i))
			if mobId > 0 and mobId ~= 71504 then
				items[#items+1] = itemNames[mobId]
			end
		end
		mod:Message(-8202, "Neutral", nil, L.assembly_line_items:format(count, table.concat(items, " - ")), false)
		wipe(items)
	end
	function mod:AssemblyLine()
		self:ScheduleTimer(beltItems, 13, assemblyLineCounter)
		self:Message(-8202, "Neutral", "Warning", L.assembly_line_message:format(assemblyLineCounter), "Inv_crate_03")
		assemblyLineCounter = assemblyLineCounter + 1
		self:Bar(-8202, 40, CL.count:format(self:SpellName(-8202), assemblyLineCounter), "Inv_crate_03")
	end
end

do
	local prev = 0
	function mod:CrawlerMine(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(-8212, "Urgent", nil, -8212, 77976) -- mine like icon
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
		self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
	end
end

function mod:RAID_BOSS_WHISPER(_, msg, sender)
	if msg:find("Ability_Siege_Engineer_Superheated", nil, true) then -- laser fixate
		-- might wanna do syncing to get range message working
		self:Message(-8208, "Personal", "Info", L.laser_on_you, 144040)
		self:Flash(-8208)
		self:Say(-8208, 143444) -- 143444 = "Laser"
	elseif msg:find("Ability_Siege_Engineer_Detonate", nil, true) then -- mine fixate
		self:Message(-8212, "Personal", "Info", CL.you:format(sender))
		self:Flash(-8212)
	elseif msg:find("143266", nil, true) then -- Sawblade
		-- this is faster than target scanning, hence why we do it
		sawbladeTarget = UnitGUID("player")
		self:Message(-8195, "Positive", "Info", CL.you:format(self:SpellName(143266)))
		self:PrimaryIcon(-8195, "player")
		self:Flash(-8195)
		self:Say(-8195)
	end
end

function mod:ShockwaveMissile()
	self:Message(143639, "Urgent")
end

function mod:ShockwaveMissileOver(args)
	self:Message(args.spellId, "Urgent", nil, CL.over:format(args.spellName))
end

function mod:PatternRecognitionApplied(args)
	if self:Me(args.destGUID) then
		self:Bar(-8207, 60)
	end
end

function mod:PatternRecognitionRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(-8207, "Positive", CL.over:format(args.spellName))
	end
end

-- Automated Shredders

function mod:ShredderEngage()
	self:Message(-8199, "Attention", self:Tank() and "Long", nil, "INV_MISC_ARMORKIT_27")
	self:Bar(-8199, 60, nil, "INV_MISC_ARMORKIT_27")
	self:Bar(144208, 16) -- Death from Above
	overloadCounter = 1
	self:Bar(145444, 7, CL.count:format(self:SpellName(145444), overloadCounter)) -- Overload
end

function mod:DeathFromAboveApplied(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:DeathFromAbove(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 41)
end

function mod:Overload(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "Urgent", nil, CL.count:format(args.spellName, amount))
	overloadCounter = amount + 1
	self:Bar(args.spellId, 11, CL.count:format(args.spellName, overloadCounter))
end

function mod:ShredderDied()
	self:StopBar(144208) -- Death from Above
	self:StopBar(CL.count:format(self:SpellName(145444), overloadCounter)) -- Overload
end

-- Siegecrafter Blackfuse

function mod:ElectrostaticCharge(args)
	self:CDBar(args.spellId, 17)
end

function mod:ElectrostaticChargeApplied(args)
	if UnitIsPlayer(args.destName) then -- Shows up for pets, etc.
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Info")
	end
end

function mod:ProtectiveFrenzy(args)
	self:Message(args.spellId, "Attention", "Long")
	for i=1, 5 do
		local boss = "boss"..i
		if UnitExists(boss) and UnitIsDead(boss) then
			local mobId = self:MobId(UnitGUID(boss))
			self:Message(-8202, "Positive", nil, CL.other:format(L.disabled, itemNames[mobId]), false)
		end
	end
end

do
	-- rather do this than syncing
	local timer = nil
	local function warnSawblade(self, target, guid)
		sawbladeTarget = guid
		self:PrimaryIcon(-8195, target)
		if not self:Me(guid) then -- we warn for ourself from the BOSS_WHISPER
			if self:Range(target) < 8 then -- 8 is guessed
				self:RangeMessage("saw_blade_near_you", "Personal", "Alarm", mod:SpellName(-8195), 143265)
			else
				self:TargetMessage(-8195, target, "Positive", "Info")
			end
		end
	end
	function mod:Sawblade(args)
		self:CDBar(-8195, 11)
		sawbladeTarget = nil
		self:GetBossTarget(warnSawblade, 0.4, args.sourceGUID)
	end
	function mod:SawbladeFallback(args)
		 -- don't do anything if we warned for the target already
		if args.destGUID ~= sawbladeTarget then
			warnSawblade(self, args.destName, args.destGUID)
		end
	end
end

function mod:Drillstorm(args)
	if args.sourceGUID ~= args.destGUID then -- Not the NPC
		self:TargetMessage(args.spellId, args.destName, "Attention", "Alarm")
		self:TargetBar(args.spellId, 15, args.destName)
		self:PrimaryIcon(args.spellId, args.destName)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
	end
end

function mod:DrillstormRemoved(args)
	if args.sourceGUID ~= args.destGUID then -- Not the NPC
		self:PrimaryIcon(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

