assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsColors")
local PaintChips = AceLibrary("PaintChips-2.0")

local shortBar
local longBar

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Colors"] = true,

	["Messages"] = true,
	["Bars"] = true,
	["Short"] = true,
	["Long"] = true,
	["Short bars"] = true,
	["Long bars"] = true,
	["Color %d"] = true,
	["Number of colors"] = true,
	["Background"] = true,
	["Text"] = true,
	["Reset"] = true,

	["Colors of messages and bars."] = true,
	["Change the color for %q messages."] = true,
	["Colors for short bars (< 1 minute)."] = true,
	["Colors for long bars (> 1 minute)."] = true,
	["Change the %s color."] = true,
	["Number of colors the bar has."] = true,
	["Change the bar background color."] = true,
	["Change the bar text color."] = true,
	["Resets all colors to defaults."] = true,

	["Important"] = true,
	["Personal"] = true,
	["Urgent"] = true,
	["Attention"] = true,
	["Positive"] = true,
	["Bosskill"] = true,
	["Core"] = true,

	["1st"] = true,
	["2nd"] = true,
	["3rd"] = true,
	["4th"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Colors"] = "색상",

	["Messages"] = "메세지",
	["Bars"] = "바",
	["Short bars"] = "짧은바",
	["Long bars"] = "긴바",
	["Color %d"] = "색상 %d",
	["Number of colors"] = "색상의 수",
	["Background"] = "배경",
	["Text"] = "글자",
	["Reset"] = "초기화",

	["Colors of messages and bars."] = "메세지와 바의 색상.",
	["Change the color for %q messages."] = "%q 메세지에 대한 색생 변경.",
	["Colors for short bars (< 1 minute)."] = "짧은 바에 대한 색상 (< 1 분).",
	["Colors for long bars (> 1 minute)."] = "긴 바에 대한 색상 (> 1 분).",
	["Change the %s color."] = "%s 색상 변경.",
	["Number of colors the bar has."] = "Number of colors the bar has.",
	["Change the bar background color."] = "배경 색상 변경.",
	["Change the bar text color."] = "글자 색상 변경.",
	["Resets all colors to defaults."] = "기본 설정으로 초기화.",

	["Important"] = "중요",
	["Personal"] = "개인",
	["Urgent"] = "긴급",
	["Attention"] = "주의",
	["Positive"] = "제안",
	["Bosskill"] = "보스사망",
	["Core"] = "코어",

	["1st"] = "첫째",
	["2nd"] = "둘째",
	["3rd"] = "셋째",
	["4th"] = "넷째",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Colors"] = "颜色",

	["Messages"] = "信息",
	["Bars"] = "计时条",
	["Short bars"] = "短计时条",
	["Long bars"] = "长计时条",
	["Color %d"] = "颜色 %d",
	["Number of colors"] = "颜色数量",
	["Background"] = "背景",
	["Text"] = "文本",
	["Reset"] = "重置",

	["Colors of messages and bars."] = "信息文字与计时条颜色。",
	["Change the color for %q messages."] = "变更%q信息的颜色。",
	["Colors for short bars (< 1 minute)."] = "短时计时条（小于一分钟）的颜色。",
	["Colors for long bars (> 1 minute)."] = "长时计时条（大于一分钟）的颜色。",
	["Change the %s color."] = "变更颜色%s。",
	["Number of colors the bar has."] = "计时条颜色数量。",
	["Change the bar background color."] = "变更背景颜色。",
	["Change the bar text color."] = "变更文本颜色。",
	["Resets all colors to defaults."] = "全部重置为默认状态。",

	["Important"] = "重要",
	["Personal"] = "个人",
	["Urgent"] = "紧急",
	["Attention"] = "注意",
	["Positive"] = "积极",
	["Bosskill"] = "首领击杀",
	["Core"] = "核心",

	["1st"] = "第一",
	["2nd"] = "第二",
	["3rd"] = "第三",
	["4th"] = "第四",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Colors"] = "顏色",

	["Messages"] = "訊息",
	["Bars"] = "計時條",
	["Short bars"] = "短計時條",
	["Long bars"] = "長計時條",
	["Color %d"] = "顏色 %d",
	["Number of colors"] = "顏色數量",
	["Background"] = "背景",
	["Text"] = "文字",
	["Reset"] = "重置",

	["Colors of messages and bars."] = "訊息文字與計時條顏色。",
	["Change the color for %q messages."] = "變更%q訊息的顏色。",
	["Colors for short bars (< 1 minute)."] = "短時計時條（小於一分鐘）的顏色。",
	["Colors for long bars (> 1 minute)."] = "長時計時條（大於一分鐘）的顏色。",
	["Change the %s color."] = "變更顏色%s。",
	["Number of colors the bar has."] = "計時條顏色數量。",
	["Change the bar background color."] = "變更背景顏色。",
	["Change the bar text color."] = "變更文字顏色。",
	["Resets all colors to defaults."] = "全部重置為預設狀態。",

	["Important"] = "重要",
	["Personal"] = "個人",
	["Urgent"] = "緊急",
	["Attention"] = "注意",
	["Positive"] = "積極",
	["Bosskill"] = "首領擊殺",
	["Core"] = "核心",

	["1st"] = "第一",
	["2nd"] = "第二",
	["3rd"] = "第三",
	["4th"] = "第四",
} end)

L:RegisterTranslations("deDE", function() return {
	["Colors"] = "Farben",

	["Messages"] = "Nachrichten",
	["Bars"] = "Anzeigebalken",
	["Short"] = "Kurz",
	["Long"] = "Lang",
	["Short bars"] = "Kurze Anzeigebalken",
	["Long bars"] = "Lange Anzeigebalken",
	["Color %d"] =  "Farbe %d",
	["Number of colors"] = "Anzahl der Farben",
	["Background"] = "Hintergrund",
	["Text"] = "Text",
	["Reset"] = "Zur\195\188cksetzen",

	["Colors of messages and bars."] = "Farben der Nachrichten und Anzeigebalken.",
	["Change the color for %q messages."] = "Farbe \195\164ndern f\195\188r %q Nachrichten.",
	["Colors for short bars (< 1 minute)."] = "Farben f\195\188r kurze Anzeigebalken (< 1 Minute).",
	["Colors for long bars (> 1 minute)."] = "Farben f\195\188r lange Anzeigebalken (> 1 Minute).",
	["Change the %s color."] = "Die %s Farbe \195\164ndern.",
	["Number of colors the bar has."] = "Anzahl der Farben eines Anzeigebalkens.",
	["Change the bar background color."] = "Hintergrund Farbe \195\164ndern.",
	["Change the bar text color."] = "Textfarbe \195\164ndern.",
	["Resets all colors to defaults."] = "Auf Standard zur\195\188cksetzen.",

	["Important"] = "Wichtig",
	["Personal"] = "Pers\195\182hnlich",
	["Urgent"] = "Dringend",
	["Attention"] = "Achtung",
	["Positive"] = "Positiv",
	["Bosskill"] = "Bosskill",
	["Core"] = "Core",

	["1st"] = "1te",
	["2nd"] = "2te",
	["3rd"] = "3te",
	["4th"] = "4te",
} end)

L:RegisterTranslations("frFR", function() return {
	["Colors"] = "Couleurs",

	["Messages"] = "Messages",
	["Bars"] = "Barres",
	["Short"] = "Court",
	--["Long"] = true,
	["Short bars"] = "BarresCourtes",
	["Long bars"] = "BarresLongues",
	["Color %d"] = "Couleur %d",
	["Number of colors"] = "Nombre de couleurs",
	["Background"] = "Fond",
	["Text"] = "Texte",
	["Reset"] = "R\195\128Z",

	["Colors of messages and bars."] = "Couleurs des messages et des barres.",
	["Change the color for %q messages."] = "Change la couleur des messages %q.",
	["Colors for short bars (< 1 minute)."] = "Couleurs des barres de courte dur\195\169e (< 1 minute).",
	["Colors for long bars (> 1 minute)."] = "Couleurs des barres de longue dur\195\169e (> 1 minute).",
	["Change the %s color."] = "Change la couleur de %s.",
	["Number of colors the bar has."] = "Nombre de couleurs que poss\195\168de la barre.",
	["Change the bar background color."] = "Change la couleur du fond.",
	["Change the bar text color."] = "Change la couleur du texte.",
	["Resets all colors to defaults."] = "R\195\169initialise tous les param\195\168tres à leurs valeurs par d\195\169faut.",

	["Important"] = "Important",
	["Personal"] = "Personnel",
	["Urgent"] = "Urgent",
	["Attention"] = "Attention",
	["Positive"] = "Positif",
	["Bosskill"] = "D\195\169faite",
	["Core"] = "Noyau",

	["1st"] = "1er",
	["2nd"] = "2\195\168me",
	["3rd"] = "3\195\168me",
	["4th"] = "4\195\168me",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Colors")

plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.defaultDB = {
	important = "ff0000", -- Red
	personal = "ff0000", -- Red
	urgent = "ff7f00", -- Orange
	attention = "ffff00", -- Yellow
	positive = "00ff00", -- Green
	bosskill = "00ff00", -- Green
	core = "00ffff", -- Cyan

	short1 = "ffff00",
	short2 = "ff7f00",
	short3 = "ff0000",
	short4 = "ff0000",
	short = 3,

	long1 = "00ff00",
	long2 = "ffff00",
	long3 = "ff7f00",
	long4 = "ff0000",
	long = 4,
}

local function get(key)
	return select(2, PaintChips:GetRGBPercent(plugin.db.profile[key]))
end

local function set(key, r, g, b)
	local hex = plugin:RGBToHex(r, g, b)
	PaintChips:RegisterHex(hex)
	plugin.db.profile[key] = hex
end

plugin.consoleCmd = L["Colors"]
plugin.consoleOptions = {
	type = "group",
	name = L["Colors"],
	desc = L["Colors of messages and bars."],
	args = {
		["messages"] = {
			type = "header",
			name = L["Messages"],
			order = 1,
		},
		["important"] = {
			name = L["Important"],
			type = "color",
			desc = L["Change the color for %q messages."]:format(L["Important"]),
			get = function() return get("important") end,
			set = function(r, g, b) set("important", r, g, b) end,
			order = 2,
		},
		["personal"] = {
			name = L["Personal"],
			type = "color",
			desc = L["Change the color for %q messages."]:format(L["Personal"]),
			get = function() return get("personal") end,
			set = function(r, g, b) set("personal", r, g, b) end,
			order = 3,
		},
		["urgent"] = {
			name = L["Urgent"],
			type = "color",
			desc = L["Change the color for %q messages."]:format(L["Urgent"]),
			get = function() return get("urgent") end,
			set = function(r, g, b) set("urgent", r, g, b) end,
			order = 4,
		},
		["attention"] = {
			name = L["Attention"],
			type = "color",
			desc = L["Change the color for %q messages."]:format(L["Attention"]),
			get = function() return get("attention") end,
			set = function(r, g, b) set("attention", r, g, b) end,
			order = 5,
		},
		["positive"] = {
			name = L["Positive"],
			type = "color",
			desc = L["Change the color for %q messages."]:format(L["Positive"]),
			get = function() return get("positive") end,
			set = function(r, g, b) set("positive", r, g, b) end,
			order = 6,
		},
		["bosskill"] = {
			name = L["Bosskill"],
			type = "color",
			desc = L["Change the color for %q messages."]:format(L["Bosskill"]),
			get = function() return get("bosskill") end,
			set = function(r, g, b) set("bosskill", r, g, b) end,
			order = 7,
		},
		["core"] = {
			name = L["Core"],
			type = "color",
			desc = L["Change the color for %q messages."]:format(L["Core"]),
			get = function() return get("core") end,
			set = function(r, g, b) set("core", r, g, b) end,
			order = 8,
		},
		["spacer1"] = { type = "header", name = " ", order = 9, },
		["bars"] = {
			type = "header",
			name = L["Bars"],
			order = 10,
		},
		["short"] = {
			type = "group",
			name = L["Short bars"],
			desc = L["Colors for short bars (< 1 minute)."],
			order = 11,
			pass = true,
			get = function(key)
				if key == "amount" then
					return plugin.db.profile.short
				else
					return select(2, PaintChips:GetRGBPercent(plugin.db.profile[key]))
				end
			end,
			set = function(key, r, g, b)
				if key == "amount" then
					plugin.db.profile.short = r
				else
					local hex = plugin:RGBToHex(r, g, b)
					PaintChips:RegisterHex(hex)
					plugin.db.profile[key] = hex
				end
			end,
			args = {
				["short1"] = {
					name = L["Color %d"]:format(1),
					type = "color",
					desc = L["Change the %s color."]:format(L["1st"]),
					order = 1,
				},
				["short2"] = {
					name = L["Color %d"]:format(2),
					type = "color",
					desc = L["Change the %s color."]:format(L["2nd"]),
					disabled = function() return plugin.db.profile.short < 2 end,
					order = 2,
				},
				["short3"] = {
					name = L["Color %d"]:format(3),
					type = "color",
					desc = L["Change the %s color."]:format(L["3rd"]),
					disabled = function() return plugin.db.profile.short < 3 end,
					order = 3,
				},
				["short4"] = {
					name = L["Color %d"]:format(4),
					type = "color",
					desc = L["Change the %s color."]:format(L["4th"]),
					disabled = function() return plugin.db.profile.short < 4 end,
					order = 4,
				},
				["amount"] = {
					name = L["Number of colors"],
					type = "range",
					desc = L["Number of colors the bar has."],
					min = 1,
					max = 4,
					step = 1,
					order = 5,
				},
			},
		},
		[L["Long"]] = {
			type = "group",
			name = L["Long bars"],
			desc = L["Colors for long bars (> 1 minute)."],
			order = 12,
			pass = true,
			get = function(key)
				if key == "amount" then
					return plugin.db.profile.long
				else
					return select(2, PaintChips:GetRGBPercent(plugin.db.profile[key]))
				end
			end,
			set = function(key, r, g, b)
				if key == "amount" then
					plugin.db.profile.long = r
				else
					local hex = plugin:RGBToHex(r, g, b)
					PaintChips:RegisterHex(hex)
					plugin.db[key] = hex
				end
			end,
			args = {
				["long1"] = {
					name = L["Color %d"]:format(1),
					type = "color",
					desc = L["Change the %s color."]:format(L["1st"]),
					order = 1,
				},
				["long2"] = {
					name = L["Color %d"]:format(2),
					type = "color",
					desc = L["Change the %s color."]:format(L["2nd"]),
					disabled = function() return plugin.db.profile.long < 2 end,
					order = 2,
				},
				["long3"] = {
					name = L["Color %d"]:format(3),
					type = "color",
					desc = L["Change the %s color."]:format(L["3rd"]),
					disabled = function() return plugin.db.profile.long < 3 end,
					order = 3,
				},
				["long4"] = {
					name = L["Color %d"]:format(4),
					type = "color",
					desc = L["Change the %s color."]:format(L["4th"]),
					disabled = function() return plugin.db.profile.long < 4 end,
					order = 4,
				},
				["amount"] = {
					name = L["Number of colors"],
					type = "range",
					desc = L["Number of colors the bar has."],
					min = 1,
					max = 4,
					step = 1,
					order = 5,
				},
			},
		},
		[L["Background"]] = {
			name = L["Background"],
			type = "color",
			desc = L["Change the bar background color."],
			hasAlpha = true,
			get = function()
				if plugin.db.profile.bgc then
					local r, g, b = select(2, PaintChips:GetRGBPercent(plugin.db.profile.bgc))
					return r, g, b, plugin.db.profile.bga
				else
					return 0, .5, .5, .5
				end
			end,
			set = function(r, g, b, a)
				local hex = plugin:RGBToHex(r, g, b)
				PaintChips:RegisterHex(hex)
				plugin.db.profile.bgc = hex
				plugin.db.profile.bga = a
			end,
			order = 13,
		},
		[L["Text"]] = {
			name = L["Text"],
			type = "color",
			desc = L["Change the bar text color."],
			get = function()
				if plugin.db.profile.txtc then
					return get("txtc")
				else
					return 1, 1, 1
				end
			end,
			set = function(r, g, b) set("txtc", r, g, b) end,
			order = 14,
		},
		["spacer2"] = { type = "header", name = " ", order = 15, },
		[L["Reset"]] = {
			type = "execute",
			name = L["Reset"],
			desc = L["Resets all colors to defaults."],
			handler = plugin,
			func = "ResetDB",
			order = 16,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

local function RegHex(hex)
	if type(hex) == "string" then
		PaintChips:RegisterHex(hex)
	elseif type(hex) == "table" then
		for _,hexx in pairs(hex) do
			RegHex(hexx)
		end
	end
end

function plugin:OnEnable()
	RegHex(self.db.profile)
end

function plugin:UpdateColorTables()
	if type(shortBar) == "table" then
		for k in ipairs(shortBar) do shortBar[k] = nil end
	end
	if type(longBar) == "table" then
		for k in ipairs(longBar) do longBar[k] = nil end
	end
	local db = self.db.profile
	for i = 1, db.short do
		shortBar[i] = db["short"..i]
	end
	for i = 1, db.long do
		longBar[i] = db["long"..i]
	end
end

------------------------------
--         Handlers         --
------------------------------

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

function plugin:RGBToHex(r, g, b)
	return format("%02x%02x%02x", r*255, g*255, b*255)
end

function plugin:MsgColor(hint)
	local color = self.db.profile[hint:lower()]
	if type(color) ~= "string" then return hint end
	return color
end

function plugin:BarColor(time)
	if time <= 60 then
		return unpack(shortBar)
	else
		return unpack(longBar)
	end
end


