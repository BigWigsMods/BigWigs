
local plugin = BigWigs:NewPlugin("Super Emphasize")
if not plugin then return end

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

plugin.defaultDB = {
	upper = true,
	size = true,
	countdown = true,
	flash = false,
}

local options = {
	name = "Super Emphasize",
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
	}
}

function plugin:OnRegister()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Big Wigs: Super Emphasize", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Big Wigs: Super Emphasize", L["Super Emphasize"], "Big Wigs")
end

function plugin:OnPluginEnable()
	emphasizeFlag = BigWigs.C.EMPHASIZE
end

function plugin:IsSuperEmphasized(module, key)
	if type(key) == "number" then key = GetSpellInfo(key) end
	if temporaryEmphasizes[key] then return true end
	return bit.band(module.db.profile[key], emphasizeFlag) == emphasizeFlag
end

