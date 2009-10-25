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
	Important = { ["*"] = { 1, 0.2, 0.2 } }, -- Red
	Personal = { ["*"] = { 0.2, 0.4, 1 } }, -- Blue
	Urgent = { ["*"] = { 1, 0.5, 0.1 } }, -- Orange
	Attention = { ["*"] = { 1, 1, 0.1 } }, -- Yellow
	Positive = { ["*"] = { 0.2, 1, 0.2 } }, -- Green
	Bosskill = { ["*"] = { 0.2, 1, 0.2 } }, -- Green
	Core = { ["*"] = { 0.2, 1, 1 } }, -- Cyan

	barBackground = { ["*"] = { 0.5, 0.5, 0.5, 0.3 } },
	barText = { ["*"] = { 1, 1, 1 } },
	barColor = { ["*"] = { 0.25, 0.33, 0.68, 1 } },
	barEmphasized = { ["*"] = { 1, 0, 0, 1 } },
	
	flashshake = { ["*"] = { 0, 0, 1 } },
}
local defaultColorKey = plugin.name.."_Default" 

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

local function compareTable(a, b)
	for k, v in pairs(a) do
		if not b[k] or b[k] ~= v then return false end
	end
	for k, v in pairs(b) do
		if not a[k] or a[k] ~= v then return false end
	end
	return true
end

local function get(info)
	return plugin:GetColor(info[#info], info.arg)
end

local function set(info, r, g, b, a)
	plugin.db.profile[info[#info]][info.arg] = {r, g, b, a}
end

local function reset(info)
	for k, v in pairs(plugin.db.profile) do
		plugin.db.profile[k][info.arg] = nil
	end
end

local function resetAll()
	plugin.db:ResetProfile()
end

local colorOptions = {
	type = "group",
	name = L["Colors"],
	desc = L["Colors of messages and bars."],
	handler = plugin,
	get = get,
	set = set,
	inline = true,
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
			desc = L["Resets the above colors to defaults."],
			func = reset,
			order = 16,
			width = "full",
		},
	},
}

local function addKey(t, key)
	if t.type and ( t.type == "color" or t.type == "execute" ) then
		t.arg = key
	elseif t.args then
		for k, v in pairs(t.args) do
			t.args[k] = addKey(v, key)
		end
	end
	return t
end

function plugin:GetColorOptions(key)
	return addKey(colorOptions, key)
end

-- the pluginOptions are a slightly altered copy of the defaults
plugin.pluginOptions = copyTable({}, plugin:GetColorOptions(defaultColorKey))
plugin.pluginOptions.inline = nil
plugin.pluginOptions.args.reset.width = "half"
plugin.pluginOptions.args.resetAll = {
	type = "execute",
	name = L["Reset all"],
	desc = L["Resets all colors for all modules to defaults."],
	func = resetAll,
	order = 17,
	width = "half",
}

function plugin:HasColor(hint, key)
	if not self.db.profile[hint] then return end
	local t = self.db.profile[hint][key or defaultColorKey] -- no key passed -> return our default
	return not compareTable(t, self.defaultDB[hint]["*"])
end

function plugin:GetColor(hint, key)
	if not self.db.profile[hint] then return 1, 1, 1 end
	local t = self.db.profile[hint][key or defaultColorKey] -- no key passed -> return our default
	if compareTable(t, self.defaultDB[hint]["*"]) then -- unchanged profile entry, go with the defaultColors
		t = self.db.profile[hint][defaultColorKey]
	end
	return unpack(t)
end

