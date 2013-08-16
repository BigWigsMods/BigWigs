--[[
TODO:
	-- figure out where the south tower timer starts
	-- figure out tower add timers for 2nd tower
	-- maybe try and add wave timers
]]--
if select(4, GetBuildInfo()) < 50400 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Galakras", 953, 868)
if not mod then return end
mod:RegisterEnableMob(72249, 72560, 72311) -- Galakras, Lor'themar Theron (Horde), King Varian Wrynn (Alliance)

--------------------------------------------------------------------------------
-- Locals
--

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
	L.demolisher_desc = "Timers for when the Kor'kron Demolishers enter the fight"
	L.demolisher_icon = 125914
	L.towers = "Towers"
	L.towers_desc = "Warnings for when the towers get breached"
	L.towers_icon = "achievement_bg_winsoa"
	L.south_tower_trigger = "The door barring the South Tower has been breached!"
	L.south_tower = "South tower"
	L.north_tower_trigger = "The door barring the North Tower has been breached!"
	L.north_tower = "North tower"
	L.tower_defender = "Tower defender"

	L.custom_off_shaman_marker = "Shaman marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."
end
L = mod:GetLocale()
L.custom_off_shaman_marker_desc = L.custom_off_shaman_marker_desc:format(
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7.blp:15\124t"
)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		147328, 146765, 146757, -- Foot Soldiers
		"towers", "demolisher", 146849, 147705, -- Ranking Officials
		"custom_off_shaman_marker",
		"stages", -- Galakras
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
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Foot Soldiers
	self:Log("SPELL_CAST_START", "AddMarkedMob", 148520) -- Tidal Wave
	self:Log("SPELL_CAST_START", "ChainHeal", 146757)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameArrows", 146765)
	self:Log("SPELL_DAMAGE", "FlameArrows", 146764)
	self:Log("SPELL_AURA_APPLIED", "FlameArrows", 146765)
	self:Log("SPELL_AURA_APPLIED", "Warbanner", 147328)
	-- Ranking Officials
	self:Log("SPELL_PERIODIC_DAMAGE", "PoisonCloud", 147705)
	self:Log("SPELL_AURA_APPLIED", "PoisonCloud", 147705)
	self:Log("SPELL_CAST_START", "CrushersCall", 146769)
	self:Log("SPELL_CAST_SUCCESS", "ShatteringCleave", 146849)
	self:Emote("Towers", L["south_tower_trigger"], L["north_tower_trigger"])
	self:Emote("Demolisher", "116040")
	-- Galakras
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "LastPhase", "boss1")

	self:Death("Deaths", 72249, 72367) -- Galakras, Dragonmaw Tidal Shaman
end

local function warnTowerAdds()
	mod:Message("towers", "Attention", nil, L["tower_defender"], 85214)
	mod:Bar("towers", 60, L["tower_defender"], 85214) -- random orc icon
end

local function firstTowerAdd()
	mod:Message("towers", "Attention", nil, L["tower_defender"], 85214)
	mod:Bar("towers", 60, L["tower_defender"], 85214) -- random orc icon
	mod:ScheduleRepeatingTimer(warnTowerAdds, 60)
end

function mod:OnEngage()
	if self:Heroic() then
		self:Bar("towers", 13, L["tower_defender"], 85214) -- random orc icon
		self:ScheduleTimer(firstTowerAdd, 13)
	else
		self:Bar("towers", 120, L["south_tower"], "achievement_bg_winsoa")
		self:CDBar("towers", 270, L["north_tower"], "achievement_bg_winsoa") -- XXX need to figure out timer
	end
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
	self:Message(args.spellId, "Urgent")
end

function mod:ShatteringCleave(args)
	self:Bar(args.spellId, 7)
end

function mod:Demolisher()
	self:Message("demolisher", "Attention", nil, L["demolisher"], L["demolisher_icon"])
end

function mod:Towers(msg)
	local tower = msg:find(L["north_tower_trigger"]) and L["north_tower"] or L["south_tower"] -- this will be kinda bad till every localization is done
	self:Message("towers", "Neutral", "Long", tower, "achievement_bg_winsoa")
	self:Bar("demolisher", 20, L["demolisher"], L["demolisher_icon"])
end

-- Foot Soldiers
function mod:ChainHeal(args)
	self:Message(args.spellId, "Important")
	if self.db.profile.custom_off_shaman_marker then
		mod:AddMarkedMob(args)
	end
end

do
	local prev = 0
	function mod:FlameArrows(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

function mod:Warbanner(args)
	self:Message(args.spellId, "Urgent")
end

function mod:Deaths(args)
	if args.mobId == 72249 then
		self:Win()
	elseif args.mobId == 72367 and self.db.profile.custom_off_shaman_marker then
		for i = 1, 7 do
			if not marksUsed[i] then
				marksUsed[i] = nil
				markableMobs[args.destGUID] = nil
				return
			end
		end
	end
end

-- marking
do
	local function setMark(unit, guid)
		for mark = 1, 7 do
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
end