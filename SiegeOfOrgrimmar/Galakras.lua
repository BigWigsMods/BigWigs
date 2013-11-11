
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Galakras", 953, 868)
if not mod then return end
mod:RegisterEnableMob(
	72249, 72358, -- Galakras, Kor'kron Cannon
	72560, 72561, 73909, -- Horde: Lor'themar Theron, Lady Sylvanas Windrunner, Archmage Aethas Sunreaver
	72311, 72302, 73910 -- Alliance: King Varian Wrynn, Lady Jaina Proudmoore, Vereesa Windrunner
)

--------------------------------------------------------------------------------
-- Locals
--

local towerAddTimer = nil
-- marking
local markableMobs = {}
local marksUsed = {}
local markTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.demolisher, L.demolisher_desc = EJ_GetSectionInfo(8533)
	L.demolisher_message = "Demolisher"
	L.demolisher_icon = 125914

	L.towers = "Towers"
	L.towers_desc = "Warnings for when the towers are breached."
	L.towers_icon = "achievement_bg_winsoa"
	L.south_tower_trigger = "The door barring the South Tower has been breached!"
	L.south_tower = "South tower"
	L.north_tower_trigger = "The door barring the North Tower has been breached!"
	L.north_tower = "North tower"
	L.tower_defender = "Tower defender"

	L.adds = CL.adds
	L.adds_desc = "Timers for when a new set of adds enter the fight."
	L.adds_icon = "achievement_character_orc_female" -- female since Zaela is calling them (and to be not the same as tower add icon)
	L.adds_trigger1 = "Bring her down quick so I can wrap my fingers around her neck." -- Lady Sylvanas Windrunner
	L.adds_trigger2 = "Here they come!" -- Lady Jaina Proudmoore
	L.adds_trigger3 = "Dragonmaw, advance!"
	L.adds_trigger4 = "For Hellscream!"
	L.adds_trigger5 = "Next squad, push forward!"

	L.drakes = "Proto-Drakes"
	L.drakes_desc = select(2, EJ_GetSectionInfo(8586))
	L.drakes_icon = "ability_mount_drake_proto"

	L.custom_off_shaman_marker = "Shaman marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the shamans is the fastest way to mark them.|r"
	L.custom_off_shaman_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"towers", 146769, 146849, 147705, -8443, -- Ranking Officials
		"adds", "drakes", "demolisher", 147328, 146765, 146757, -8489, 146899, -- Foot Soldiers
		"custom_off_shaman_marker",
		{147068, "ICON", "FLASH", "PROXIMITY"},-- Galakras
		"stages", "bosskill",
	}, {
		["towers"] = -8421, -- Ranking Officials
		["adds"] = -8427, -- Foot Soldiers
		["custom_off_shaman_marker"] = L.custom_off_shaman_marker,
		[147068] = -8418, -- Galakras
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	if self.lastKill and (GetTime() - self.lastKill) < 120 then -- Temp for outdated users enabling us
		self:ScheduleTimer("Disable", 5)
		return
	end

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	--self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Adds") -- could just check for sender = Warlord Zaela, target = player to avoid localization?
	self:Yell("AddsInitial", L.adds_trigger1, L.adds_trigger2)
	self:Yell("Adds", L.adds_trigger3, L.adds_trigger4, L.adds_trigger5)

	-- Shaman marking, enabled here for trash
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:Log("SPELL_CAST_START", "TidalWave", 149187, 148522)
	self:Death("ShamanDeath", 72367, 72958)
	-- Foot Soldiers
	self:Log("SPELL_CAST_START", "ChainHeal", 146757, 146728)
	self:Log("SPELL_CAST_SUCCESS", "HealingTotem", 146753, 146722)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameArrows", 146765)
	self:Log("SPELL_DAMAGE", "FlameArrows", 146764)
	self:Log("SPELL_AURA_APPLIED", "FlameArrows", 146765)
	self:Log("SPELL_AURA_APPLIED", "Warbanner", 147328)
	self:Log("SPELL_AURA_APPLIED", "Fracture", 146899, 147200)
	self:Emote("Demolisher", "116040")
	-- Ranking Officials
	self:Log("SPELL_CAST_SUCCESS", "CurseOfVenom", 147711)
	self:Log("SPELL_PERIODIC_DAMAGE", "PoisonCloud", 147705)
	self:Log("SPELL_AURA_APPLIED", "PoisonCloud", 147705)
	self:Log("SPELL_CAST_START", "CrushersCall", 146769)
	self:Log("SPELL_CAST_SUCCESS", "ShatteringCleave", 146849)
	self:Emote("SouthTower", L["south_tower_trigger"])
	self:Emote("NorthTower", L["north_tower_trigger"])
	-- Galakras
	self:Log("SPELL_AURA_APPLIED_DOSE", "FlamesOfGalakrondStacking", 147029)
	self:Log("SPELL_AURA_APPLIED", "FlamesOfGalakrondApplied", 147068)
	self:Log("SPELL_AURA_REMOVED", "FlamesOfGalakrondRemoved", 147068)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "LastPhase", "boss1", "boss2", "boss3", "boss4")

	self:Death("Win", 72249) -- Galakras
end

local function warnTowerAdds()
	mod:Message("towers", "Attention", nil, L["tower_defender"], 85214)
	mod:Bar("towers", 60, L["tower_defender"], 85214) -- random orc icon
end

local function firstTowerAdd()
	warnTowerAdds()
	if not towerAddTimer then
		towerAddTimer = mod:ScheduleRepeatingTimer(warnTowerAdds, 60)
	end
end

function mod:OnEngage()
	if self:Heroic() then
		self:Bar("towers", 6, L["tower_defender"], 85214) -- random orc icon
		self:ScheduleTimer(firstTowerAdd, 6)
	else
		self:Bar("towers", 116, L["south_tower"], L.towers_icon)
	end

	if self.db.profile.custom_off_shaman_marker then
		wipe(markableMobs)
		wipe(marksUsed)
		if markTimer then
			self:CancelTimer(markTimer)
			markTimer = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--Galakras
function mod:FlamesOfGalakrondStacking(args)
	if args.amount > 2 then
		if self:Me(args.destGUID) or (self:Tank() and self:Tank(args.destName)) then
			self:StackMessage(147068, args.destName, args.amount, "Attention", nil, 71393, args.spellId) -- 71393 = "Flames"
		end
	end
end

function mod:FlamesOfGalakrondRemoved(args)
	self:PrimaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:FlamesOfGalakrondApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning", 88986, args.spellId) -- 88986 = "Fireball"
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 8)
		self:Flash(args.spellId)
	end
end

function mod:LastPhase(unitId, _, _, _, spellId)
	if spellId == 50630 then -- Eject All Passengers
		self:Message("stages", "Neutral", "Warning", CL["incoming"]:format(UnitName(unitId)), "ability_mount_drake_proto")
		self:StopBar(L["adds"])
		self:StopBar(L["drakes"])
		self:CancelDelayedMessage(CL["incoming"]:format(L["drakes"]))
	end
end

-- Ranking Officials
do
	local prev = 0
	function mod:PoisonCloud(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

function mod:CurseOfVenom(args)
	self:Message(-8443, "Urgent", "Alert")
end

function mod:CrushersCall(args)
	self:Bar(args.spellId, 48)
	self:Message(args.spellId, "Urgent", "Alert")
end

function mod:ShatteringCleave(args)
	self:Bar(args.spellId, 7)
end

function mod:Demolisher()
	self:Message("demolisher", "Attention", nil, L["demolisher_message"], L.demolisher_icon)
end

function mod:SouthTower()
	self:StopBar(L["south_tower"])
	self:Message("towers", "Neutral", "Long", L["south_tower"], L.towers_icon)
	self:Bar("demolisher", 20, L["demolisher_message"], L.demolisher_icon)

	if self:Heroic() then
		self:CancelTimer(towerAddTimer)
		towerAddTimer = nil
		self:Bar("towers", 35, L["tower_defender"], 85214) -- random orc icon
		self:ScheduleTimer(firstTowerAdd, 35)
	else
		self:Bar("towers", 150, L["north_tower"], L.towers_icon) -- XXX verify
	end
end

function mod:NorthTower()
	self:StopBar(L["north_tower"])
	self:Message("towers", "Neutral", "Long", L["north_tower"], L.towers_icon)
	self:Bar("demolisher", 20, L["demolisher_message"], L.demolisher_icon)

	if self:Heroic() then
		self:CancelTimer(towerAddTimer)
		towerAddTimer = nil
		self:StopBar(L["tower_defender"])
	end
end

-- Foot Soldiers
function mod:ChainHeal(args)
	self:Message(146757, "Important", "Warning")
end

function mod:HealingTotem(args)
	self:Message(-8489, "Urgent", "Warning")
end

do
	local prev = 0
	function mod:FlameArrows(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", nil, CL["underyou"]:format(args.spellName))
		end
	end
end

function mod:Warbanner(args)
	self:Message(args.spellId, "Urgent")
end

function mod:Fracture(args)
	self:TargetMessage(146899, args.destName, "Urgent", "Alarm", nil, nil, true)
end

do
	local addsCounter = 1
	function mod:AddsInitial()
		-- is actually ~6s or so after the first wave, but a better starting point than engage
		addsCounter = 1
		self:Bar("adds", 49, L["adds"], L.adds_icon)
		self:Bar("drakes", 158, L["drakes"], L.drakes_icon)
	end

	function mod:Adds()
		self:Message("adds", "Attention", "Info", CL["incoming"]:format(L["adds"]), L.adds_icon)
		addsCounter = addsCounter + 1
		if (addsCounter + 1) % 4  == 0 then
			self:DelayedMessage("drakes", 55, "Attention", CL["incoming"]:format(L["drakes"]), L.drakes_icon, "Info")
			self:Bar("adds", 110, L["adds"], L.adds_icon)
		else
			if addsCounter % 4 == 0 then -- start the drakes timer on the wave after drakes
				self:Bar("drakes", 220, L["drakes"], L.drakes_icon)
			end
			self:Bar("adds", 55, L["adds"], L.adds_icon)
		end
	end
end

-- marking
do
	local function setMark(unit, guid)
		for mark = 1, 5 do
			if not marksUsed[mark] then
				SetRaidTarget(unit, mark)
				markableMobs[guid] = "marked"
				marksUsed[mark] = guid
				return
			end
		end
	end

	local function markMobs()
		local continue
		for guid in next, markableMobs do
			if markableMobs[guid] == true then
				local unit = mod:GetUnitIdByGUID(guid)
				if unit then
					setMark(unit, guid)
				else
					continue = true
				end
			end
		end
		if not continue or not mod.db.profile.custom_off_shaman_marker then
			mod:CancelTimer(markTimer)
			markTimer = nil
		end
	end

	function mod:UPDATE_MOUSEOVER_UNIT()
		if self.db.profile.custom_off_shaman_marker then
			local guid = UnitGUID("mouseover")
			if guid and markableMobs[guid] == true then
				setMark("mouseover", guid)
			end
		end
	end

	function mod:TidalWave(args)
		if self.db.profile.custom_off_shaman_marker and not markableMobs[args.sourceGUID] then
			markableMobs[args.sourceGUID] = true
			if not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.2)
			end
		end
	end

	function mod:ShamanDeath(args)
		if self.db.profile.custom_off_shaman_marker then
			markableMobs[args.destGUID] = nil
			for i = 1, 5 do
				if marksUsed[i] == args.destGUID then
					marksUsed[i] = nil
					break
				end
			end
		end
	end
end

