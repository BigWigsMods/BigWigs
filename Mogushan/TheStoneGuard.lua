
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Stone Guard", 896, 679)
if not mod then return end
mod:RegisterEnableMob(60051, 60047, 60043, 59915) -- Cobalt, Amethyst, Jade, Jasper

local cobaltTimer = 10.7
local deathCount = 0

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

	self:Death("Deaths", 60051, 60047, 60043, 59915)
end

function mod:OnEngage(diff)
	cobaltTimer = (diff == 3 or diff == 5) and 8.4 or 10.7
	deathCount = (diff == 4 or diff == 6) and -1 or 0
	self:Berserk(self:Heroic() and 420 or 480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Overload(msg, boss)
	self:Message("overload", msg:format(boss), "Important", L["overload_icon"], "Long")
end

do
	local jasperChainsTargets = mod:NewTargetList()
	local prevPlayer = nil
	function mod:JasperChainsApplied(player, spellId, _, _, spellName)
		if not prevPlayer then
			prevPlayer = player
			jasperChainsTargets[1] = player
		elseif prevPlayer then
			jasperChainsTargets[2] = player
			if UnitIsUnit(player, "player") or UnitIsUnit(prevPlayer, "player") then
				self:FlashShake(spellId)
				self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId)
				self:OpenProximity(10, spellId, UnitIsUnit(prevPlayer, "player") and player or prevPlayer, true)
			else
				self:TargetMessage(spellId, spellName, jasperChainsTargets, "Attention", spellId)
			end
			prevPlayer = nil
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
		self:Bar("ej:5772", spellName, cobaltTimer, spellId)
	end
end

function mod:Deaths()
	deathCount = deathCount + 1
	if deathCount > 2 then
		self:Win()
	end
end

