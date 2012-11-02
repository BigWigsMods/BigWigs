
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Stone Guard", 896, 679)
if not mod then return end
mod:RegisterEnableMob(60051, 60047, 60043, 59915) -- Cobalt, Amethyst, Jade, Jasper

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.petrifications = "Petrification"
	L.petrifications_desc = "Warning for when bosses start petrification"
	L.petrifications_icon = 125092

	L.overload = "Overload" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "Warning for all types of overloads."
	L.overload_icon = 77222 -- overload like icon
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"ej:5772", "SAY"},
		130774,
		{130395, "FLASHSHAKE", "PROXIMITY", "SAY"},
		"overload", "petrifications", "berserk", "bosskill",
	}, {
		["ej:5772"] = "ej:5771",
		[130774] = "ej:5691",
		[130395] = "ej:5774",
		overload = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_AURA_APPLIED", "JasperChainsApplied", 130395)
	self:Log("SPELL_AURA_REMOVED", "JasperChainsRemoved", 130395)
	self:Log("SPELL_CAST_SUCCESS", "AmethystPool", 130774)
	self:Emote("Overload", L["overload"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 60051, 60047, 60043, 59915)
end

function mod:OnEngage(diff)
	self:Berserk(480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Overload(msg, boss)
	self:Message("overload", msg:format(boss), "Important", L["overload_icon"], "Long")
end

do
	local scheduled = nil
	local jasperChainsTargets = mod:NewTargetList()
	local function jasperChains(spellName)
		mod:TargetMessage(130395, spellName, jasperChainsTargets, "Attention", 130395, "Info")
		scheduled = nil
	end
	function mod:JasperChainsApplied(player, spellId, _, _, spellName)
		jasperChainsTargets[#jasperChainsTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(spellId)
			self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId)
			self:Say(spellId, CL["say"]:format(spellName))
			-- this is kind of a reverse proximity now, it should help to know when you are actually close as you are supposed to be
			self:OpenProximity(10, spellId)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(jasperChains, 0.2, spellName)
		end
	end
	function mod:JasperChainsRemoved(player, spellId, _, _, spellName)
		if UnitIsUnit("player", player) then
			self:LocalMessage(spellId, CL["over"]:format(spellName), "Personal", spellId)
			self:CloseProximity(spellId)
		end
	end
end

do
	local prev = 0
	function mod:AmethystPool(player, spellId, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(spellId, CL["underyou"]:format(spellName), "Personal", spellId, "Alarm")
		end
	end
end

do
	local timer, fired = nil, 0
	local cobaltMine = mod:SpellName(129424)
	local function mineWarn(unitId)
		fired = fired + 1
		local unitIdTarget = unitId.."target"
		local player = UnitName(unitIdTarget)
		if player and (not UnitDetailedThreatSituation(unitIdTarget, unitId) or fired > 13) then
			-- If we've done 14 (0.7s) checks and still not passing the threat check, it's probably being cast on the tank
			mod:TargetMessage("ej:5772", cobaltMine, player, "Urgent", 129424, "Alarm")
			mod:CancelTimer(timer, true)
			timer = nil
			if UnitIsUnit(unitIdTarget, "player") then
				mod:Say("ej:5772", CL["say"]:format(cobaltMine))
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer, true)
			timer = nil
		end
	end
	function mod:CobaltMine(unitId)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(mineWarn, 0.05, unitId)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
	if not unitId:match("boss") then return end
	-- we could be using the same colors as blizzard but they are too "faint" imo
	if spellId == 115852 then -- cobalt
		self:Message("petrifications", ("|c001E90FF%s|r"):format(spellName), nil, spellId, "Alert") -- blue
	elseif spellId == 116006 then -- jade
		self:Message("petrifications", ("|c00008000%s|r"):format(spellName), nil, spellId, "Alert") -- green
	elseif spellId == 116036 then -- jasper
		self:Message("petrifications", ("|c00FF0000%s|r"):format(spellName), nil, spellId, "Alert") -- red
	elseif spellId == 116057 then -- amethyst
		self:Message("petrifications", ("|c00FF44FF%s|r"):format(spellName), nil, spellId, "Alert") -- purple
	elseif spellId == 129424 then
		self:Bar("ej:5772", spellName, 10.7, spellId)
		self:CobaltMine(unitId)
	end
end

do
	local count = 0
	function mod:Deaths()
		count = count + 1
		if count > 2 then
			self:Win()
		end
	end
end

