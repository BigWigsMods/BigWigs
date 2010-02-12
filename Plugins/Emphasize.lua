-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Super Emphasize", "AceTimer-3.0")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

local temporaryEmphasizes = {}
local emphasizeFlag = nil

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = "|cff" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. key .. "|r"
			return self[key]
		end
	})
end

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	upper = true,
	size = true,
	countdown = true,
	flash = false,
}

plugin.subPanelOptions = {
	key = "Big Wigs: Super Emphasize",
	name = L["Super Emphasize"],
	options = {
		name = L["Super Emphasize"],
		type = "group",
		get = function(info) return plugin.db.profile[info[#info]] end,
		set = function(info, value) plugin.db.profile[info[#info]] = value end,
		args = {
			heading = {
				type = "description",
				name = L.superEmphasizeDesc,
				order = 10,
				width = "full",
				fontSize = "medium",
			},
			upper = {
				type = "toggle",
				name = colorize[L["UPPERCASE"]],
				desc = L["Uppercases all messages related to a super emphasized option."],
				order = 10,
				width = "full",
				descStyle = "inline",
			},
			size = {
				type = "toggle",
				name = colorize[L["Double size"]],
				desc = L["Doubles the size of super emphasized bars and messages."],
				order = 11,
				width = "full",
				descStyle = "inline",
				hidden = true,
			},
			countdown = {
				type = "toggle",
				name = colorize[L["Countdown"]],
				desc = L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."],
				order = 12,
				width = "full",
				descStyle = "inline",
			},
			flash = {
				type = "toggle",
				name = colorize[L["Flash"]],
				desc = L["Flashes the screen red during the last 3 seconds of any related timer."],
				order = 13,
				width = "full",
				descStyle = "inline",
			},
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	emphasizeFlag = BigWigs.C.EMPHASIZE
end

function plugin:IsSuperEmphasized(module, key)
	if not module or not key then return end
	if temporaryEmphasizes[key] then return true end
	if type(key) == "number" then key = GetSpellInfo(key) end
	return module.db.profile[key] and bit.band(module.db.profile[key], emphasizeFlag) == emphasizeFlag or nil
end

local function endEmphasize(data)
	local module, key = unpack(data)
	temporaryEmphasizes[key] = nil
	plugin:SendMessage("BigWigs_SuperEmphasizeEnd", module, key)
end

function plugin:Emphasize(module, key, timeSpan)
	if not module or not key then return end
	temporaryEmphasizes[key] = true
	self:ScheduleTimer(endEmphasize, timeSpan, {module, key}) -- XXX wts one table per emphasize
	self:SendMessage("BigWigs_SuperEmphasizeStart", module, key, timeSpan)
end

