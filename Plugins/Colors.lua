----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("Colors")
if not plugin then return end

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

local function get(info) return plugin:GetColor(info[#info], info.arg) end
local function set(info, r, g, b, a) plugin.db.profile[info[#info]][info.arg] = {r, g, b, a} end
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
					order = 2,
					width = "half",
				},
				Personal = {
					name = L["Personal"],
					type = "color",
					order = 3,
					width = "half",
				},
				Urgent = {
					name = L["Urgent"],
					type = "color",
					order = 4,
					width = "half",
				},
				Attention = {
					name = L["Attention"],
					type = "color",
					order = 5,
					width = "half",
				},
				Positive = {
					name = L["Positive"],
					type = "color",
					order = 6,
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
					name = L["Normal"],
					type = "color",
					hasAlpha = true,
					order = 11,
					width = "half",
				},
				barEmphasized = {
					name = L["Emphasized"],
					type = "color",
					hasAlpha = true,
					order = 11,
					width = "half",
				},
				barBackground = {
					name = L["Background"],
					type = "color",
					hasAlpha = true,
					order = 13,
					width = "half",
				},
				barText = {
					name = L["Text"],
					type = "color",
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
					order = 11,
				},
			},
		},
		reset = {
			type = "execute",
			name = L["Reset"],
			desc = L["Resets the above colors to their defaults."],
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

local C = BigWigs.C
function plugin:GetColorOptions(key, flags)
	local t = addKey(colorOptions, key)
	t.args.messages.hidden = nil
	t.args.bars.hidden = nil
	t.args.flashshake.hidden = nil
	if flags then
		if bit.band(flags, C.MESSAGE) ~= C.MESSAGE then
			t.args.messages.hidden = true
		end
		if bit.band(flags, C.BAR) ~= C.BAR then
			t.args.bars.hidden = true
		end
		if bit.band(flags, C.FLASHSHAKE) ~= C.FLASHSHAKE then
			t.args.flashshake.hidden = true
		end
	end
	return t
end

-- the pluginOptions are a slightly altered copy of the defaults
plugin.pluginOptions = copyTable({}, plugin:GetColorOptions(defaultColorKey))
plugin.pluginOptions.inline = nil
plugin.pluginOptions.args.reset.width = "half"
plugin.pluginOptions.args.resetAll = {
	type = "execute",
	name = L["Reset all"],
	desc = L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."],
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

