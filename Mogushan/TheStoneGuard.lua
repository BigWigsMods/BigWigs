
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Stone Guard", 896, 679)
if not mod then return end
mod:RegisterEnableMob(60051, 60043, 59915) --Cobalt Jade Jasper

--------------------------------------------------------------------------------
-- Locals
--

local jasperChainsTargets = mod:NewTargetList()

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
		"ej:5772",
		130774,
		{130395, "FLASHSHAKE", "PROXIMITY"},
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

	self:Death("Win", 60051) -- they share HP
end

function mod:OnEngage(diff)

	self:Berserk(480) -- assume

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Overload(msg, boss)
	self:Message("overload", msg:format(boss), "Important", L["overload_icon"], "Alarm")
end

do
	local scheduled = nil
	local function jasperChains(spellName)
		mod:TargetMessage(130395, spellName, jasperChainsTargets, "Attention", 130395, "Info")
		scheduled = nil
	end
	function mod:JasperChainsApplied(player, _, _, _, spellName)
		jasperChainsTargets[#jasperChainsTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(130395)
			-- this is kind of a reverse proximity now, it should help to know when you are actually close as you are supposed to be
			self:OpenProximity(10, 130395)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(jasperChains, 0.1, spellName)
		end
	end
end

function mod:JasperChainsRemoved(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(130395, CL["you"]:format(spellName), "Personal", 130395)
		self:CloseProximity(130395)
	end
end

do
	local prev = 0
	function mod:AmethystPool(player, _, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(130774, CL["underyou"]:format(spellName), "Personal", 130774, "Alert")
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
	if not unitId:match("boss") then return end
	-- we could be using the same colors as blizzard but they are too "faint" imo
	if spellId == 115852 then -- cobalt
		self:Message("petrifications", ("|c001E90FF%s|r"):format(spellName), nil, 115852, "Alert") -- blue
	elseif spellId == 116006 then -- jade
		self:Message("petrifications", ("|c00008000%s|r"):format(spellName), nil, 116006, "Alert") -- green
	elseif spellId == 116036 then -- jasper
		self:Message("petrifications", ("|c00FF0000%s|r"):format(spellName), nil, 116036, "Alert") -- red
	elseif spellId == 116057 then -- amethyst
		self:Message("petrifications", ("|c00800080%s|r"):format(spellName), nil, 116057, "Alert") -- purple
	end
end

