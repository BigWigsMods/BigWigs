-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Colors")
if not plugin then return end

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	Important = { ["*"] = { ["*"] = { 1, 0.2, 0.2 } } }, -- Red
	Personal = { ["*"] = { ["*"] = { 0.2, 0.4, 1 } } }, -- Blue
	Urgent = { ["*"] = { ["*"] = { 1, 0.5, 0.1 } } }, -- Orange
	Attention = { ["*"] = { ["*"] = { 1, 1, 0.1 } } }, -- Yellow
	Positive = { ["*"] = { ["*"] = { 0.2, 1, 0.2 } } }, -- Green
	Neutral = { ["*"] = { ["*"] = { 0.2, 1, 1 } } }, -- Cyan

	barBackground = { ["*"] = { ["*"] = { 0.5, 0.5, 0.5, 0.3 } } },
	barText = { ["*"] = { ["*"] = { 1, 1, 1, 1 } } },
	barTextShadow = { ["*"] = { ["*"] = { 0, 0, 0, 1 } } },
	barColor = { ["*"] = { ["*"] = { 0.25, 0.33, 0.68, 1 } } },
	barEmphasized = { ["*"] = { ["*"] = { 1, 0, 0, 1 } } },

	flash = { ["*"] = { ["*"] = { 0, 0, 1 } } },
}

local colorWrapper = {
	red = "Important",
	blue = "Personal",
	orange = "Urgent",
	yellow = "Attention",
	green = "Positive",
	cyan = "Neutral",
}

local function copyTable(to, from)
	setmetatable(to, nil)
	for k,v in next, from do
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
	if type(a) ~= "table" or type(b) ~= "table" then return false end
	for k, v in next, a do
		if not b[k] or b[k] ~= v then return false end
	end
	for k, v in next, b do
		if not a[k] or a[k] ~= v then return false end
	end
	return true
end

local function get(info) return plugin:GetColor(info[#info], unpack(info.arg)) end
local function set(info, r, g, b, a)
	local name, key = unpack(info.arg)
	plugin.db.profile[info[#info]][name][key] = {r, g, b, a}
end
local function reset(info)
	local name, key = unpack(info.arg)
	for k in next, plugin.db.profile do
		plugin.db.profile[k][name][key] = nil
	end
end
local function hidden(info)
	local name, key = unpack(info.arg)
	local module = BigWigs:GetBossModule(name:sub(16), true)
	if not module or not module.colorOptions then -- no module entry? show all colors
		return false
	end
	local optionColors = module.colorOptions[key]
	if not optionColors then
		return true
	end
	local optionName = info[#info]
	if type(optionColors) == "table" then
		for _, color in next, optionColors do
			if color == optionName then
				return false
			end
		end
	else
		return optionName ~= optionColors
	end
	return true
end

local function resetAll()
	plugin.db:ResetProfile()
end

local colorOptions = {
	type = "group",
	name = L.colors,
	handler = plugin,
	get = get,
	set = set,
	inline = true,
	args = {
		messages = {
			type = "group",
			name = L.messages,
			inline = true,
			order = 1,
			args = {
				Important = {
					name = L.Important,
					type = "color",
					hidden = hidden,
					order = 1,
				},
				Personal = {
					name = L.Personal,
					type = "color",
					hidden = hidden,
					order = 2,
				},
				Urgent = {
					name = L.Urgent,
					type = "color",
					hidden = hidden,
					order = 3,
				},
				Attention = {
					name = L.Attention,
					type = "color",
					hidden = hidden,
					order = 4,
				},
				Positive = {
					name = L.Positive,
					type = "color",
					hidden = hidden,
					order = 5,
				},
				Neutral = {
					name = L.Neutral,
					type = "color",
					hidden = hidden,
					order = 6,
				},
			},
		},
		bars = {
			type = "group",
			name = L.bars,
			inline = true,
			order = 2,
			args = {
				barColor = {
					name = L.normal,
					type = "color",
					hasAlpha = true,
					order = 1,
				},
				barEmphasized = {
					name = L.emphasized,
					type = "color",
					hasAlpha = true,
					order = 2,
				},
				barBackground = {
					name = L.background,
					type = "color",
					hasAlpha = true,
					order = 3,
				},
				barText = {
					name = L.text,
					type = "color",
					hasAlpha = true,
					order = 4,
				},
				barTextShadow = {
					name = L.textShadow,
					type = "color",
					hasAlpha = true,
					order = 5,
				},
			},
		},
		flash = {
			type = "group",
			name = L.flash,
			inline = true,
			order = 3,
			args = {
				flash = {
					name = L.flash,
					type = "color",
					order = 11,
				},
			},
		},
		reset = {
			type = "execute",
			name = L.reset,
			desc = L.resetDesc,
			func = reset,
			order = 4,
			width = "full",
		},
	},
}

local function addKey(t, key)
	if t.type and ( t.type == "color" or t.type == "execute" ) then
		t.arg = key
	elseif t.args then
		for k, v in next, t.args do
			t.args[k] = addKey(v, key)
		end
	end
	return t
end

local C = BigWigs.C
local keyTable = {}
function plugin:SetColorOptions(name, key, flags)
	wipe(keyTable)
	keyTable[1] = name
	keyTable[2] = key
	local t = addKey(colorOptions, keyTable)
	t.args.messages.hidden = nil
	t.args.bars.hidden = nil
	t.args.flash.hidden = nil
	if flags then
		if bit.band(flags, C.MESSAGE) ~= C.MESSAGE then
			t.args.messages.hidden = true
		end
		if bit.band(flags, C.BAR) ~= C.BAR then
			t.args.bars.hidden = true
		end
		if bit.band(flags, C.FLASH) ~= C.FLASH then
			t.args.flash.hidden = true
		end
	end
	return t
end

local defaultKey = "default"
-- the pluginOptions are a slightly altered copy of the defaults
plugin.pluginOptions = copyTable({}, plugin:SetColorOptions(plugin.name, defaultKey))
plugin.pluginOptions.inline = nil
plugin.pluginOptions.args.reset.width = nil --"half"
plugin.pluginOptions.args.resetAll = {
	type = "execute",
	name = L.resetAll,
	desc = L.resetAllDesc,
	func = resetAll,
	order = 17,
}

local white = { 1, 1, 1 }
function plugin:GetColorTable(hint, module, key)
	hint = colorWrapper[hint] or hint
	if not self.db.profile[hint] then return white end
	local name
	if not module or not key then
		name = plugin.name
		key = defaultKey
	elseif type(module) == "string" then
		name = module
	else
		name = module.name
	end
	local t = self.db.profile[hint][name][key] -- no key passed -> return our default
	if compareTable(t, self.defaultDB[hint]["*"]["*"]) then -- unchanged profile entry, go with the defaultColors
		t = self.db.profile[hint][plugin.name][defaultKey]
	end
	return t
end

function plugin:GetColor(hint, module, key)
	return unpack(self:GetColorTable(hint, module, key))
end
