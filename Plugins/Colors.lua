assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsColors")
local PaintChips = AceLibrary("PaintChips-2.0")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["colors"] = true,
	["Colors"] = true,

	["Messages"] = true,
	["Bars"] = true,
	["Short"] = true,
	["Long"] = true,
	["Short bars"] = true,
	["Long bars"] = true,
	["Color %s"] = true,
	["Color%s"] = true,
	["Number of colors"] = true,
	["xColors"] = true,
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
	["Color %s"] = "색상 %s",
	["Color%s"] = "색상%s",
	["Number of colors"] = "색상의 수",
	["xColors"] = "x색상",
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
	["Color %s"] = "颜色 %s",
	["Color%s"] = "颜色%s",
	["Number of colors"] = "颜色数量",
	["xColors"] = "x颜色",
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
	["Color %s"] = "顏色 %s",
	["Color%s"] = "顏色%s",
	["Number of colors"] = "顏色數量",
	["xColors"] = "x顏色",
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
	["Short bars"] = "KurzerAnzeigebalken",
	["Long bars"] = "LangerAnzeigebalken",
	["Color %s"] =  "Farbe %s",
	["Color%s"] = "Farbe%s",
	["Number of colors"] = "Anzahl der Farben",
	["xColors"] = "xFarben",
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
	--["colors"] = true,
	["Colors"] = "Couleurs",

	["Messages"] = "Messages",
	["Bars"] = "Barres",
	["Short"] = "Court",
	--["Long"] = true,
	["Short bars"] = "BarresCourtes",
	["Long bars"] = "BarresLongues",
	["Color %s"] = "Couleur %s",
	["Color%s"] = "Couleur%s",
	["Number of colors"] = "Nombre de couleurs",
	["xColors"] = "nCouleurs",
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

BigWigsColors = BigWigs:NewModule(L["Colors"])
BigWigsColors.defaultDB = {
	important = "ff0000", -- Red
	personal = "ff0000", -- Red
	urgent = "ff7f00", -- Orange
	attention = "ffff00", -- Yellow
	positive = "00ff00", -- Green
	bosskill = "00ff00", -- Green
	core = "00ffff", -- Cyan

	shortbar = {"ffff00", "ff7f00", "ff0000"},
	shortnr = 3,
	longbar = {"00ff00", "ffff00", "ff7f00", "ff0000"},
	longnr = 4,
}
BigWigsColors.consoleCmd = L["colors"]
BigWigsColors.consoleOptions = {
	type = "group",
	name = L["Colors"],
	desc = L["Colors of messages and bars."],
	args = {
		[L["Messages"]] = {
			type = "header",
			name = L["Messages"],
			order = 1,
		},
		[L["Important"]] = {
			name = L["Important"],
			type = "color",
			desc = string.format("Change the color for %q messages.", L["Important"]),
			get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.important); return r, g, b end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.important = hex end,
			order = 2,
		},
		[L["Personal"]] = {
			name = L["Personal"],
			type = "color",
			desc = string.format(L["Change the color for %q messages."], L["Personal"]),
			get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.personal); return r, g, b end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.personal = hex end,
			order = 3,
		},
		[L["Urgent"]] = {
			name = L["Urgent"],
			type = "color",
			desc = string.format(L["Change the color for %q messages."], L["Urgent"]),
			get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.urgent); return r, g, b end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.urgent = hex end,
			order = 4,
		},
		[L["Attention"]] = {
			name = L["Attention"],
			type = "color",
			desc = string.format(L["Change the color for %q messages."], L["Attention"]),
			get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.attention); return r, g, b end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.attention = hex end,
			order = 5,
		},
		[L["Positive"]] = {
			name = L["Positive"],
			type = "color",
			desc = string.format(L["Change the color for %q messages."], L["Positive"]),
			get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.positive); return r, g, b end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.positive = hex end,
			order = 6,
		},
		[L["Bosskill"]] = {
			name = L["Bosskill"],
			type = "color",
			desc = string.format(L["Change the color for %q messages."], L["Bosskill"]),
			get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.bosskill); return r, g, b end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.bosskill = hex end,
			order = 7,
		},
		[L["Core"]] = {
			name = L["Core"],
			type = "color",
			desc = string.format(L["Change the color for %q messages."], L["Core"]),
			get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.core); return r, g, b end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.core = hex end,
			order = 8,
		},
		["spacer1"] = { type = "header", name = " ", order = 9, },
		[L["Bars"]] = {
			type = "header",
			name = L["Bars"],
			order = 10,
		},
		[L["Short"]] = {
			type = "group",
			name = L["Short bars"],
			desc = L["Colors for short bars (< 1 minute)."],
			order = 11,
			args = {
				[string.format(L["Color%s"], 1)] = {
					name = string.format(L["Color %s"], 1),
					type = "color",
					desc = string.format(L["Change the %s color."], L["1st"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[1]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[1] = hex end,
					order = 1,
				},
				[string.format(L["Color%s"], 2)] = {
					name = string.format(L["Color %s"], 2),
					type = "color",
					desc = string.format(L["Change the %s color."], L["2nd"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[2]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[2] = hex end,
					disabled = function() return BigWigsColors.db.profile.shortnr < 2 end,
					order = 2,
				},
				[string.format(L["Color%s"], 3)] = {
					name = string.format(L["Color %s"], 3),
					type = "color",
					desc = string.format(L["Change the %s color."], L["3rd"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[3]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[3] = hex end,
					disabled = function() return BigWigsColors.db.profile.shortnr < 3 end,
					order = 3,
				},
				[string.format(L["Color%s"], 4)] = {
					name = string.format(L["Color %s"], 4),
					type = "color",
					desc = string.format(L["Change the %s color."], L["4th"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[4]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[4] = hex end,
					disabled = function() return BigWigsColors.db.profile.shortnr < 4 end,
					order = 4,
				},
				[L["xColors"]] = {
					name = L["Number of colors"],
					type = "range",
					desc = L["Number of colors the bar has."],
					min = 1,
					max = 4,
					step = 1,
					get = function() return BigWigsColors.db.profile.shortnr end,
					set = function(v) BigWigsColors.db.profile.shortnr = v end,
					order = 5,
				},
			},
		},
		[L["Long"]] = {
			type = "group",
			name = L["Long bars"],
			desc = L["Colors for long bars (> 1 minute)."],
			order = 12,
			args = {
				[string.format(L["Color%s"], 1)] = {
					name = string.format(L["Color %s"], 1),
					type = "color",
					desc = string.format(L["Change the %s color."], L["1st"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[1]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[1] = hex end,
					order = 1,
				},
				[string.format(L["Color%s"], 2)] = {
					name = string.format(L["Color %s"], 2),
					type = "color",
					desc = string.format(L["Change the %s color."], L["2nd"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[2]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[2] = hex end,
					disabled = function() return BigWigsColors.db.profile.longnr < 2 end,
					order = 2,
				},
				[string.format(L["Color%s"], 3)] = {
					name = string.format(L["Color %s"], 3),
					type = "color",
					desc = string.format(L["Change the %s color."], L["3rd"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[3]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[3] = hex end,
					disabled = function() return BigWigsColors.db.profile.longnr < 3 end,
					order = 3,
				},
				[string.format(L["Color%s"], 4)] = {
					name = string.format(L["Color %s"], 4),
					type = "color",
					desc = string.format(L["Change the %s color."], L["4th"]),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[4]); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[4] = hex end,
					disabled = function() return BigWigsColors.db.profile.longnr < 4 end,
					order = 4,
				},
				[L["xColors"]] = {
					name = L["Number of colors"],
					type = "range",
					desc = L["Number of colors the bar has."],
					min = 1,
					max = 4,
					step = 1,
					get = function() return BigWigsColors.db.profile.longnr end,
					set = function(v) BigWigsColors.db.profile.longnr = v end,
					order = 5,
				},
			},
		},
		[L["Background"]] = {
			name = L["Background"],
			type = "color",
			desc = L["Change the bar background color."],
			hasAlpha = true,
			get = function() if BigWigsColors.db.profile.bgc then local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.bgc); return r, g, b, BigWigsColors.db.profile.bga else return  0, .5, .5, .5 end end,
			set = function(r, g, b, a) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.bgc = hex; BigWigsColors.db.profile.bga = a end,
			order = 13,
		},
		[L["Text"]] = {
			name = L["Text"],
			type = "color",
			desc = L["Change the bar text color."],
			get = function() if BigWigsColors.db.profile.txtc then local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.txtc); return r, g, b else return 1, 1, 1 end end,
			set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.txtc = hex end,
			order = 14,
		},
		["spacer2"] = { type = "header", name = " ", order = 15, },
		[L["Reset"]] = {
			name = L["Reset"],
			type = "execute",
			desc = L["Resets all colors to defaults."],
			func = function() BigWigsColors:ResetDB() end,
			order = 16,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsColors:OnRegister()
	self:RegHex(self.db.profile)
end

function BigWigsColors:RegHex(hex)
	if type(hex) == "string" then
		PaintChips:RegisterHex(hex)
	elseif type(hex) == "table" then
		for _,hexx in pairs(hex) do
			self:RegHex(hexx)
		end
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

function BigWigsColors:ResetDB()
	copyTable(self.db.profile, self.defaultDB)
end

function BigWigsColors:RGBToHex(r, g, b)
	return format("%02x%02x%02x", r*255, g*255, b*255)
end

function BigWigsColors:MsgColor(type)
	if type == "Important" then type = self.db.profile.important
	elseif type == "Personal" then type = self.db.profile.personal
	elseif type == "Urgent" then type = self.db.profile.urgent
	elseif type == "Attention" then type = self.db.profile.attention
	elseif type == "Positive" then type = self.db.profile.positive
	elseif type == "Bosskill" then type = self.db.profile.bosskill
	elseif type == "Core" then type = self.db.profile.core end

	return type
end

function BigWigsColors:BarColor(time)
	local d, n
	if time <= 60 then
		d = self.db.profile.shortbar
		n = self.db.profile.shortnr
	else
		d = self.db.profile.longbar
		n = self.db.profile.longnr
	end
	if n == 4 then return d[1], d[2], d[3], d[4]
	elseif n == 3 then return d[1], d[2], d[3]
	elseif n == 2 then return d[1], d[2]
	elseif n == 1 then return d[1] end
end

