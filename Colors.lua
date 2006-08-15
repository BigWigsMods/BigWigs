assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsColors")
local PaintChips = AceLibrary("PaintChips-2.0")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Colors"] = true,

	["Messages"] = true,
	["Bars"] = true,
	["Shortbar"] = true,
	["Longbar"] = true,
	["Color %s"] = true,
	["Color%s"] = true,
	["Number of colors"] = true,
	["xColors"] = true,
	["Background"] = true,
	["Text"] = true,
	["Reset"] = true,

	["Colors of messages and bars."] = true,
	["Colors of messages."] = true,
	["Change the color for \"%s\" messages."] = true,
	["Colors of bars."] = true,
	["Colors for short bars (< 1 minute)."] = true,
	["Colors for long bars (> 1 minute)."] = true,
	["Change the %s color."] = true,
	["Number of colors the bar has."] = true,
	["Change the background color."] = true,
	["Change the text color."] = true,
	["Resets all ranges to defaults."] = true,

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

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsColors = BigWigs:NewModule(L"Colors")
BigWigsColors.defaultDB = {
	important = "ff0000", -- Red
	personal = "ff0000", -- Red
	urgent = "ff7f00", -- Orange
	attention = "ffff00", -- Yellow
	positive = "00ff00", -- Green
	bosskill = "00ff00", -- Green
	core = "00ffff", -- Cyan
	
	shortbar = {"ffff00", "ff7f00", "ff0000"; n=3},
	longbar = {"00ff00", "ffff00", "ff7f00", "ff0000"; n=4},
}
BigWigsColors.consoleCmd = L"Colors"
BigWigsColors.consoleOptions = {
	type = "group",
	name = L"Colors",
	desc = L"Colors of messages and bars.",
	args = {
		[L"Messages"] = {
			type = "group",
			name = L"Messages",
			desc = L"Colors of messages.",
			order = 1,
			args = {
				[L"Important"] = {
					name = L"Important",
					type = "color",
					desc = string.format(L"Change the color for \"%s\" messages.", L"Important"),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.important); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.important = hex end,
					order = 1,
				},
				[L"Personal"] = {
					name = L"Personal",
					type = "color",
					desc = string.format(L"Change the color for \"%s\" messages.", L"Personal"),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.personal); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.personal = hex end,
					order = 2,
				},
				[L"Urgent"] = {
					name = L"Urgent",
					type = "color",
					desc = string.format(L"Change the color for \"%s\" messages.", L"Urgent"),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.urgent); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.urgent = hex end,
					order = 3,
				},
				[L"Attention"] = {
					name = L"Attention",
					type = "color",
					desc = string.format(L"Change the color for \"%s\" messages.", L"Attention"),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.attention); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.attention = hex end,
					order = 4,
				},
				[L"Positive"] = {
					name = L"Positive",
					type = "color",
					desc = string.format(L"Change the color for \"%s\" messages.", L"Positive"),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.positive); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.positive = hex end,
					order = 5,
				},
				[L"Bosskill"] = {
					name = L"Bosskill",
					type = "color",
					desc = string.format(L"Change the color for \"%s\" messages.", L"Bosskill"),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.bosskill); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.bosskill = hex end,
					order = 6,
				},
				[L"Core"] = {
					name = L"Core",
					type = "color",
					desc = string.format(L"Change the color for \"%s\" messages.", L"Core"),
					get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.core); return r, g, b end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.core = hex end,
					order = 7,
				},
			},
		},
		[L"Bars"] = {
			type = "group",
			name = L"Bars",
			desc = L"Colors of bars.",
			order = 2,
			args = {
				[L"Shortbar"] = {
					type = "group",
					name = L"Shortbar",
					desc = L"Colors for short bars (< 1 minute).",
					order = 1,
					args = {
						[string.format(L"Color%s", 1)] = {
							name = string.format(L"Color %s", 1),
							type = "color",
							desc = string.format(L"Change the %s color.", L"1st"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[1]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[1] = hex end,
							order = 1,
						},
						[string.format(L"Color%s", 2)] = {
							name = string.format(L"Color %s", 2),
							type = "color",
							desc = string.format(L"Change the %s color.", L"2nd"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[2]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[2] = hex end,
							hidden = function() if getn(BigWigsColors.db.profile.shortbar) < 2 then return true end end,
							order = 2,
						},
						[string.format(L"Color%s", 3)] = {
							name = string.format(L"Color %s", 3),
							type = "color",
							desc = string.format(L"Change the %s color.", L"3rd"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[3]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[3] = hex end,
							hidden = function() if getn(BigWigsColors.db.profile.shortbar) < 3 then return true end end,
							order = 3,
						},
						[string.format(L"Color%s", 4)] = {
							name = string.format(L"Color %s", 4),
							type = "color",
							desc = string.format(L"Change the %s color.", L"4th"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.shortbar[4]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.shortbar[4] = hex end,
							hidden = function() if getn(BigWigsColors.db.profile.shortbar) < 4 then return true end end,
							order = 4,
						},
						[L"xColors"] = {
							name = L"Number of colors",
							type = "range",
							desc = L"Number of colors the bar has.",
							min = 1,
							max = 4,
							step = 1,
							get = function() return getn(BigWigsColors.db.profile.shortbar) end,
							set = function(v) table.setn(BigWigsColors.db.profile.shortbar, v) end,
							order = 5,
						},
					},
				},
				[L"Longbar"] = {
					type = "group",
					name = L"Longbar",
					desc = L"Colors for long bars (> 1 minute).",
					order = 2,
					args = {
						[string.format(L"Color%s", 1)] = {
							name = string.format(L"Color %s", 1),
							type = "color",
							desc = string.format(L"Change the %s color.", L"1st"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[1]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[1] = hex end,
							order = 1,
						},
						[string.format(L"Color%s", 2)] = {
							name = string.format(L"Color %s", 2),
							type = "color",
							desc = string.format(L"Change the %s color.", L"2nd"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[2]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[2] = hex end,
							hidden = function() if getn(BigWigsColors.db.profile.longbar) < 2 then return true end end,
							order = 2,
						},
						[string.format(L"Color%s", 3)] = {
							name = string.format(L"Color %s", 3),
							type = "color",
							desc = string.format(L"Change the %s color.", L"3rd"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[3]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[3] = hex end,
							hidden = function() if getn(BigWigsColors.db.profile.longbar) < 3 then return true end end,
							order = 3,
						},
						[string.format(L"Color%s", 4)] = {
							name = string.format(L"Color %s", 4),
							type = "color",
							desc = string.format(L"Change the %s color.", L"4th"),
							get = function() local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.longbar[4]); return r, g, b end,
							set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.longbar[4] = hex end,
							hidden = function() if getn(BigWigsColors.db.profile.longbar) < 4 then return true end end,
							order = 4,
						},
						[L"xColors"] = {
							name = L"Number of colors",
							type = "range",
							desc = L"Number of colors the bar has.",
							min = 1,
							max = 4,
							step = 1,
							get = function() return getn(BigWigsColors.db.profile.longbar) end,
							set = function(v) table.setn(BigWigsColors.db.profile.longbar, v) end,
							order = 5,
						},
					},
				},
				[L"Background"] = {
					name = L"Background",
					type = "color",
					desc = L"Change the background color.",
					hasAlpha = true,
					get = function() if BigWigsColors.db.profile.bgc then local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.bgc); return r, g, b, BigWigsColors.db.profile.bga else return  0, .5, .5, .5 end end,
					set = function(r, g, b, a) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.bgc = hex; BigWigsColors.db.profile.bga = a end,
					order = 3,
				},
				[L"Text"] = {
					name = L"Text",
					type = "color",
					desc = L"Change the text color.",
					get = function() if BigWigsColors.db.profile.txtc then local _, r, g, b = PaintChips:GetRGBPercent(BigWigsColors.db.profile.txtc); return r, g, b else return 1, 1, 1 end end,
					set = function(r, g, b) local hex = BigWigsColors:RGBToHex(r, g, b); PaintChips:RegisterHex(hex); BigWigsColors.db.profile.txtc = hex end,
					order = 4,
				},
			}
		},
		[L"Reset"] = {
			name = L"Reset",
			type = "execute",
			desc = L"Resets all ranges to defaults.",
			func = function() BigWigsColors:ResetDB() end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsColors:OnInitialize()
	self:RegHex(self.db.profile)
end

function BigWigsColors:ResetDB()
	BigWigsColors.db.profile.important = BigWigsColors.defaultDB.important
	BigWigsColors.db.profile.personal = BigWigsColors.defaultDB.personal
	BigWigsColors.db.profile.urgent = BigWigsColors.defaultDB.urgent
	BigWigsColors.db.profile.attention = BigWigsColors.defaultDB.attention
	BigWigsColors.db.profile.positive = BigWigsColors.defaultDB.positive
	BigWigsColors.db.profile.bosskill = BigWigsColors.defaultDB.bosskill
	BigWigsColors.db.profile.core = BigWigsColors.defaultDB.core
	BigWigsColors.db.profile.shortbar[1] = BigWigsColors.defaultDB.shortbar[1]
	BigWigsColors.db.profile.shortbar[2] = BigWigsColors.defaultDB.shortbar[2]
	BigWigsColors.db.profile.shortbar[3] = BigWigsColors.defaultDB.shortbar[3]
	BigWigsColors.db.profile.shortbar[4] = BigWigsColors.defaultDB.shortbar[4]
	table.setn(BigWigsColors.db.profile.shortbar, getn(BigWigsColors.defaultDB.shortbar))
	BigWigsColors.db.profile.longbar[1] = BigWigsColors.defaultDB.longbar[1]
	BigWigsColors.db.profile.longbar[2] = BigWigsColors.defaultDB.longbar[2]
	BigWigsColors.db.profile.longbar[3] = BigWigsColors.defaultDB.longbar[3]
	BigWigsColors.db.profile.longbar[4] = BigWigsColors.defaultDB.longbar[4]
	table.setn(BigWigsColors.db.profile.longbar, getn(BigWigsColors.defaultDB.longbar))
	BigWigsColors.db.profile.bgc = BigWigsColors.defaultDB.bgc
	BigWigsColors.db.profile.bga = BigWigsColors.defaultDB.bga
	BigWigsColors.db.profile.txtc = BigWigsColors.defaultDB.txtc
end

function BigWigsColors:RegHex(hex)
	if type(hex) == "string" then
		PaintChips:RegisterHex(hex)
	elseif type(hex) == "table" then
		for _,hexx in hex do
			self:RegHex(hexx)
		end
	end
end

------------------------------
--         Handlers         --
------------------------------

function BigWigsColors:RGBToHex(r, g, b)
	return format("%02x%02x%02x", r*255, g*255, b*255)
end

function BigWigsColors:MsgColor(type)
	-- Make it compatible with old code
	if type == "Red" then type = self.db.profile.important
	elseif type == "Orange" then type = self.db.profile.urgent
	elseif type == "Yellow" then type = self.db.profile.attention
	elseif type == "Green" then type = self.db.profile.positive
	elseif type == "Cyan" then type = self.db.profile.core end

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
	local d = time <= 60 and self.db.profile.shortbar or self.db.profile.longbar
	local n = getn(d)
	if n == 4 then return d[1], d[2], d[3], d[4]
	elseif n == 3 then return d[1], d[2], d[3]
	elseif n == 2 then return d[1], d[2]
	elseif n == 1 then return d[1] end
end