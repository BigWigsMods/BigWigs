--[[
TODO:
	-- win trigger
	-- figure out tower add timers for 2nd tower -- it is not improved but still need feedback
	-- maybe try and add wave timers
]]--

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

local towerAddTimer
-- marking
local markableMobs = {}
local marksUsed = {}
local markTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.demolisher = "Demolisher"
	L.demolisher_desc = "Timers for when the Kor'kron Demolishers enter the fight."
	L.demolisher_icon = 125914

	L.towers = "Towers"
	L.towers_desc = "Warnings for when the towers are breached."
	L.towers_icon = "achievement_bg_winsoa"
	L.south_tower_trigger = "The door barring the South Tower has been breached!"
	L.south_tower = "South tower"
	L.north_tower_trigger = "The door barring the North Tower has been breached!"
	L.north_tower = "North tower"
	L.tower_defender = "Tower defender"

	L.drakes, L.drakes_desc = EJ_GetSectionInfo(8586)
	L.drakes_icon = "ability_mount_drake_proto"

	L.custom_off_shaman_marker = "Shaman marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the shamans is the fastest way to mark them.|r"
	L.custom_off_shaman_marker_icon = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		147328, 146765, 146757, 146899, 146753, -- Foot Soldiers
		"towers", "drakes", "demolisher", 146769, 146849, 147705, -- Ranking Officials
		"custom_off_shaman_marker",
		"stages", {147068, "ICON", "FLASH", "PROXIMITY"},-- Galakras
		"bosskill",
	}, {
		[147328] = -8421, -- Foot Soldiers
		["towers"] = -8427, -- Ranking Officials
		["custom_off_shaman_marker"] = L.custom_off_shaman_marker,
		["stages"] = -8418, -- Galakras
		["bosskill"] = "general",
	}
end

function mod:OnBossEnable()
	if self.lastKill and (GetTime() - self.lastKill) < 120 then -- Temp for outdated users enabling us
		self:ScheduleTimer("Disable", 5)
		return
	end

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Foot Soldiers
	self:Log("SPELL_CAST_START", "AddMarkedMob", 148520, 149187, 148522) -- Tidal Wave
	self:Log("SPELL_CAST_START", "ChainHeal", 146757, 146728)
	self:Log("SPELL_CAST_SUCCESS", "HealingTotem", 146753, 146722)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameArrows", 146765)
	self:Log("SPELL_DAMAGE", "FlameArrows", 146764)
	self:Log("SPELL_AURA_APPLIED", "FlameArrows", 146765)
	self:Log("SPELL_AURA_APPLIED", "Warbanner", 147328)
	self:Log("SPELL_AURA_APPLIED", "Fracture", 146899, 147200)
	-- Ranking Officials
	self:Log("SPELL_PERIODIC_DAMAGE", "PoisonCloud", 147705)
	self:Log("SPELL_AURA_APPLIED", "PoisonCloud", 147705)
	self:Log("SPELL_CAST_START", "CrushersCall", 146769)
	self:Log("SPELL_CAST_SUCCESS", "ShatteringCleave", 146849)
	self:Emote("Towers", L["south_tower_trigger"], L["north_tower_trigger"])
	self:Emote("Demolisher", "116040")
	-- Galakras
	self:Log("SPELL_AURA_APPLIED_DOSE", "FlamesOfGalakrondStacking", 147029)
	self:Log("SPELL_AURA_APPLIED", "FlamesOfGalakrondApplied", 147068)
	self:Log("SPELL_AURA_REMOVED", "FlamesOfGalakrondRemoved", 147068)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "LastPhase", "boss1")

	self:Death("ShamanDeath", 72367) -- Dragonmaw Tidal Shaman
	self:Death("Win", 72249) -- Galakras
end

local function warnTowerAdds()
	mod:Message("towers", "Attention", nil, L["tower_defender"], 85214)
	mod:Bar("towers", 60, L["tower_defender"], 85214) -- random orc icon
end

local function firstTowerAdd()
	mod:Message("towers", "Attention", nil, L["tower_defender"], 85214)
	-- XXX this gets totally inaccurate at some point -- might be better now for north tower, still need feedback
	mod:Bar("towers", 60, L["tower_defender"], 85214) -- random orc icon
	if not towerAddTimer then
		towerAddTimer = mod:ScheduleRepeatingTimer(warnTowerAdds, 60)
	end
end

function mod:OnEngage()
	if self:Heroic() then
		self:Bar("towers", 13, L["tower_defender"], 85214) -- random orc icon
		self:ScheduleTimer(firstTowerAdd, 13)
	else
		self:Bar("towers", 116, L["south_tower"], "achievement_bg_winsoa")
	end
	self:Bar("drakes", 172, L["drakes"], "ability_mount_drake_proto")
	if self.db.profile.custom_off_shaman_marker then
		wipe(markableMobs)
		wipe(marksUsed)
		markTimer = nil
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
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
	if spellId == 50630 then
		self:Message("stages", "Neutral", "Warning", CL["incoming"]:format(UnitName(unitId)), "ability_mount_drake_proto")
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

function mod:CrushersCall(args)
	self:Bar(args.spellId, 48)
	self:Message(args.spellId, "Urgent", "Alert")
end

function mod:ShatteringCleave(args)
	self:Bar(args.spellId, 7)
end

function mod:Demolisher()
	self:Message("demolisher", "Attention", nil, L["demolisher"], L["demolisher_icon"])
end

function mod:Towers(msg)
	local tower = msg:find(L["north_tower_trigger"]) and L["north_tower"] or L["south_tower"] -- this will be kinda bad till every localization is done
	self:StopBar(tower)
	self:Message("towers", "Neutral", "Long", tower, "achievement_bg_winsoa")
	self:Bar("demolisher", 20, L["demolisher"], L["demolisher_icon"])

	if self:Heroic() then
		-- timer needs double checking
		self:CancelTimer(towerAddTimer)
		towerAddTimer = nil
		self:Bar("towers", 35, L["tower_defender"], 85214) -- random orc icon
		self:ScheduleTimer(firstTowerAdd, 35)
		if tower == L["north_tower"] then
			self:CancelTimer(towerAddTimer)
			towerAddTimer = nil
			self:StopBar(L["tower_defender"])
		end
	elseif tower == L["south_tower"] then
		self:Bar("towers", 150, L["north_tower"], "achievement_bg_winsoa") -- XXX verify
	end
end

-- Foot Soldiers
function mod:ChainHeal(args)
	self:Message(146757, "Important", "Warning")
	if self.db.profile.custom_off_shaman_marker then
		mod:AddMarkedMob(args)
	end
end

function mod:HealingTotem()
	self:Message(146753, "Urgent", "Warning")
end

do
	local prev = 0
	function mod:FlameArrows(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL["underyou"]:format(args.spellName))
		end
	end
end

function mod:Warbanner(args)
	self:Message(args.spellId, "Urgent")
end

function mod:Fracture(args)
	self:TargetMessage(146899, args.destName, "Urgent", "Info", nil, nil, true)
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
		local guid = UnitGUID("mouseover")
		if guid and markableMobs[guid] == true then
			setMark("mouseover", guid)
		end
	end

	function mod:AddMarkedMob(args)
		if not markableMobs[args.sourceGUID] then
			markableMobs[args.sourceGUID] = true
			if self.db.profile.custom_off_shaman_marker and not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.2)
			end
		end
	end

	function mod:ShamanDeath(args)
		if self.db.profile.custom_off_shaman_marker then
			markableMobs[args.destGUID] = nil
			for i=1, 5 do
				if marksUsed[i] == args.destGUID then
					marksUsed[i] = nil
					break
				end
			end
		end
	end
end

