----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:New("Colors", "$Revision$")
if not plugin then return end

local fmt = string.format

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Plugins")

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	Important = { 1, 0.2, 0.2 }, -- Red
	Personal = { 0.2, 0.4, 1 }, -- Blue
	Urgent = { 1, 0.5, 0.1 }, -- Orange
	Attention = { 1, 1, 0.1 }, -- Yellow
	Positive = { 0.2, 1, 0.2 }, -- Green
	Bosskill = { 0.2, 1, 0.2 }, -- Green
	Core = { 0.2, 1, 1 }, -- Cyan

	barBackground = { 0.5, 0.5, 0.5, 0.3 },
	barText = { 1, 1, 1 },
	barColor = { 0.25, 0.33, 0.68, 1 },
	barEmphasized = { 1, 0, 0, 1 },
}

local function get(key)
	if not key or key == "reset" then return end -- Work around AceConsole-2.0 problem.
	return unpack(plugin.db.profile[key])
end
local function set(key, r, g, b, a) plugin.db.profile[key] = {r, g, b, a} end

plugin.consoleCmd = L["Colors"]
plugin.consoleOptions = {
	type = "group",
	name = L["Colors"],
	desc = L["Colors of messages and bars."],
	handler = plugin,
	pass = true,
	get = get,
	set = set,
	args = {
		messages = {
			type = "header",
			name = L["Messages"],
			order = 1,
		},
		Important = {
			name = L["Important"],
			type = "color",
			desc = fmt(L["Change the color for %q messages."], L["Important"]),
			order = 2,
		},
		Personal = {
			name = L["Personal"],
			type = "color",
			desc = fmt(L["Change the color for %q messages."], L["Personal"]),
			order = 3,
		},
		Urgent = {
			name = L["Urgent"],
			type = "color",
			desc = fmt(L["Change the color for %q messages."], L["Urgent"]),
			order = 4,
		},
		Attention = {
			name = L["Attention"],
			type = "color",
			desc = fmt(L["Change the color for %q messages."], L["Attention"]),
			order = 5,
		},
		Positive = {
			name = L["Positive"],
			type = "color",
			desc = fmt(L["Change the color for %q messages."], L["Positive"]),
			order = 6,
		},
		Bosskill = {
			name = L["Bosskill"],
			type = "color",
			desc = fmt(L["Change the color for %q messages."], L["Bosskill"]),
			order = 7,
		},
		Core = {
			name = L["Core"],
			type = "color",
			desc = fmt(L["Change the color for %q messages."], L["Core"]),
			order = 8,
		},
		spacer1 = { type = "header", name = " ", order = 9, },
		bars = {
			type = "header",
			name = L["Bars"],
			order = 10,
		},
		barColor = {
			name = L["Bar"],
			type = "color",
			desc = L["Change the normal bar color."],
			hasAlpha = true,
			order = 11,
		},
		barEmphasized = {
			name = L["Emphasized bar"],
			type = "color",
			desc = L["Change the emphasized bar color."],
			hasAlpha = true,
			order = 11,
		},
		barBackground = {
			name = L["Background"],
			type = "color",
			desc = L["Change the bar background color."],
			hasAlpha = true,
			order = 13,
		},
		barText = {
			name = L["Text"],
			type = "color",
			desc = L["Change the bar text color."],
			order = 14,
		},
		spacer2 = { type = "header", name = " ", order = 15, },
		reset = {
			type = "execute",
			name = L["Reset"],
			desc = L["Resets all colors to defaults."],
			func = "ResetDB",
			order = 16,
		},
	},
}

function plugin:OnEnable()
	if not self.db.profile.upgraded then
		self:ResetDB()
		self.db.profile.upgraded = 1
		BigWigs:Print(L["color_upgrade"])
	end
end

local function copyTable(to, from)
	setmetatable(to, nil)
	for k,v in pairs(from) do
		if type(k) == "table" then
			k = copyTable({}, k)
		end
		if type(v) == "table" then
			v = copyTable({}, v)
		end
		to[k] = v
	end
	setmetatable(to, from)
	return to
end

function plugin:ResetDB()
	copyTable(self.db.profile, self.defaultDB)
end

function plugin:HasMessageColor(hint)
	return self.db.profile[hint] and true or nil
end

function plugin:MsgColor(hint)
	local t = self.db.profile[hint]
	if t then
		return unpack(t)
	else
		return 1, 1, 1
	end
end

