----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("Colors")
if not plugin then return end

local fmt = string.format

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

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
	
	flashshake = { 0, 0, 1 },
}

local function get(info)
	return unpack(plugin.db.profile[info[#info]])
end
local function set(info, r, g, b, a)
	plugin.db.profile[info[#info]] = {r, g, b, a}
end

plugin.pluginOptions = {
	type = "group",
	name = L["Colors"],
	desc = L["Colors of messages and bars."],
	handler = plugin,
	get = get,
	set = set,
	args = {
		messages = {
			type = "group",
			name = L["Messages"],
			inline = true,
			order = 1,
			args = {
				Important = {
					name = L["Important"],
					type = "color",
					desc = fmt(L["Change the color for %q messages."], L["Important"]),
					order = 2,
					width = "half",
				},
				Personal = {
					name = L["Personal"],
					type = "color",
					desc = fmt(L["Change the color for %q messages."], L["Personal"]),
					order = 3,
					width = "half",
				},
				Urgent = {
					name = L["Urgent"],
					type = "color",
					desc = fmt(L["Change the color for %q messages."], L["Urgent"]),
					order = 4,
					width = "half",
				},
				Attention = {
					name = L["Attention"],
					type = "color",
					desc = fmt(L["Change the color for %q messages."], L["Attention"]),
					order = 5,
					width = "half",
				},
				Positive = {
					name = L["Positive"],
					type = "color",
					desc = fmt(L["Change the color for %q messages."], L["Positive"]),
					order = 6,
					width = "half",
				},
				Bosskill = {
					name = L["Bosskill"],
					type = "color",
					desc = fmt(L["Change the color for %q messages."], L["Bosskill"]),
					order = 7,
					width = "half",
				},
				Core = {
					name = L["Core"],
					type = "color",
					desc = fmt(L["Change the color for %q messages."], L["Core"]),
					order = 8,
					width = "half",
				},
			},
		},
		bars = {
			type = "group",
			name = L["Bars"],
			inline = true,
			order = 10,
			args = {
				barColor = {
					name = L["Bar"],
					type = "color",
					desc = L["Change the normal bar color."],
					hasAlpha = true,
					order = 11,
					width = "half",
				},
				barEmphasized = {
					name = L["Emphasized bar"],
					type = "color",
					desc = L["Change the emphasized bar color."],
					hasAlpha = true,
					order = 11,
					width = "half",
				},
				barBackground = {
					name = L["Background"],
					type = "color",
					desc = L["Change the bar background color."],
					hasAlpha = true,
					order = 13,
					width = "half",
				},
				barText = {
					name = L["Text"],
					type = "color",
					desc = L["Change the bar text color."],
					order = 14,
					width = "half",
				},
			},
		},
		flashshake = {
			type = "group",
			name = L["Flash and shake"],
			inline = true,
			order = 12,
			args = {
				flashshake = {
					name = L["Flash and shake"],
					type = "color",
					desc = L["Change the color of the flash and shake."],
					order = 11,
				},
			},
		},
		reset = {
			type = "execute",
			name = L["Reset"],
			desc = L["Resets all colors to defaults."],
			func = "ResetDB",
			order = 16,
			width = "full",
		},
	},
}

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

function plugin:HasColor(hint)
	return self.db.profile[hint] and true or nil
end

function plugin:GetColor(hint)
	local t = self.db.profile[hint]
	if t then
		return unpack(t)
	else
		return 1, 1, 1
	end
end

