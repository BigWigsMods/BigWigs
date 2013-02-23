
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

	L.overload = "Overload"
	L.overload_desc = "Warning for all types of overloads."
	L.overload_icon = 77222 -- overload like icon
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		116529,
		-5772,
		130774,
		{130395, "FLASH", "PROXIMITY"},
		"overload", "petrifications", "berserk", "bosskill",
	}, {
		[116529] = "heroic",
		[-5772] = -5771,
		[130774] = -5691,
		[130395] = -5774,
		overload = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Petrifications", "boss1", "boss2", "boss3", "boss4")
	self:Log("SPELL_AURA_APPLIED", "JasperChainsApplied", 130395)
	self:Log("SPELL_AURA_REMOVED", "JasperChainsRemoved", 130395)
	self:Log("SPELL_CAST_SUCCESS", "AmethystPool", 130774)
	self:Emote("PowerDown", "spell:116529")
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

function mod:PowerDown()
	self:Message(116529, "Urgent", "Info", self:SpellName(116529))
end

function mod:Overload(msg, boss)
	self:Message("overload", "Important", "Long", msg:format(boss), L.overload_icon)
end

do
	local jasperChainsTargets = mod:NewTargetList()
	local prevPlayer = nil
	function mod:JasperChainsApplied(args)
		if not prevPlayer then
			prevPlayer = args.destName
			jasperChainsTargets[1] = args.destName
		elseif prevPlayer then
			jasperChainsTargets[2] = args.destName
			if self:Me(args.destGUID) or UnitIsUnit(prevPlayer, "player") then
				self:Flash(args.spellId)
				self:Message(args.spellId, "Personal", nil, CL["you"]:format(args.spellName))
				self:OpenProximity(args.spellId, 10, UnitIsUnit(prevPlayer, "player") and args.destName or prevPlayer, true)
			else
				self:TargetMessage(args.spellId, jasperChainsTargets, "Attention")
			end
			prevPlayer = nil
		end
	end
	function mod:JasperChainsRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", nil, CL["over"]:format(args.spellName))
			self:CloseProximity(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:AmethystPool(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL["underyou"]:format(args.spellName))
		end
	end
end

function mod:Petrifications(_, spellName, _, _, spellId)
	-- we could be using the same colors as blizzard but they are too "faint" imo
	if spellId == 115852 then -- cobalt
		self:Message("petrifications", nil, "Alert", ("|c001E90FF%s|r"):format(spellName), spellId) -- blue
	elseif spellId == 116006 then -- jade
		self:Message("petrifications", nil, "Alert", ("|c00008000%s|r"):format(spellName), spellId) -- green
	elseif spellId == 116036 then -- jasper
		self:Message("petrifications", nil, "Alert", ("|c00FF0000%s|r"):format(spellName), spellId) -- red
	elseif spellId == 116057 then -- amethyst
		self:Message("petrifications", nil, "Alert", ("|c00FF44FF%s|r"):format(spellName), spellId) -- purple
	elseif spellId == 129424 then
		self:Bar(-5772, cobaltTimer)
	end
end

function mod:Deaths()
	deathCount = deathCount + 1
	if deathCount > 2 then
		self:Win()
	end
end

