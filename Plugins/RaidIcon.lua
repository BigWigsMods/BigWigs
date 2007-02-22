assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRaidIcon")
local lastplayer = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Raid Icons"] = true,

	["RaidIcon"] = true,
	["place"] = true,
	["icon"] = true,

	["Place"] = true,
	["Place Raid Icons"] = true,
	["Toggle placing of Raid Icons on players."] = true,

	["Icon"] = true,
	["Set Icon"] = true,
	["Set which icon to place on players."] = true,

	["Options for Raid Icons."] = true,

	["Star"] = true,
	["Circle"] = true,
	["Diamond"] = true,
	["Triangle"] = true,
	["Moon"] = true,
	["Square"] = true,
	["Cross"] = true,
	["Skull"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	["Raid Icons"] = "공격대 아이콘",

	["Place"] = "지정",
	["Place Raid Icons"] = "공격대 아이콘 지정",
	["Toggle placing of Raid Icons on players."] = "플레이어에 공격대 아이콘 지정 토글",

	["Icon"] = "아이콘",
	["Set Icon"] = "아이콘 설정",
	["Set which icon to place on players."] = "플레이어에 아이콘 지정을 위한 설정",

	["Options for Raid Icons."] = "공격대 아이콘에 대한 설정",

	["Star"] = "별",
	["Circle"] = "원",
	["Diamond"] = "다이아몬드",
	["Triangle"] = "세모",
	["Moon"] = "달",
	["Square"] = "네모",
	["Cross"] = "가위표",
	["Skull"] = "해골",
} end )

L:RegisterTranslations("zhCN", function() return {
	["Raid Icons"] = "团队图标",

	["Place"] = "标记",
	["Place Raid Icons"] = "标记团队图标",
	["Toggle placing of Raid Icons on players."] = "切换是否在玩家身上标记团队图标",

	["Icon"] = "图标",
	["Set Icon"] = "设置图标",
	["Set which icon to place on players."] = "设置玩家身上标记的图标。",

	["Options for Raid Icons."] = "团队图标设置",

	["Star"] = "星星",
	["Circle"] = "圆圈",
	["Diamond"] = "钻石",
	["Triangle"] = "三角",
	["Moon"] = "月亮",
	["Square"] = "方形",
	["Cross"] = "十字",
	["Skull"] = "骷髅",
} end )

L:RegisterTranslations("zhTW", function() return {
	["Raid Icons"] = "團隊圖示",

	["Place"] = "標記",
	["Place Raid Icons"] = "標記團隊圖示",
	["Toggle placing of Raid Icons on players."] = "切換是否在玩家身上標記團隊圖示",

	["Icon"] = "圖標",
	["Set Icon"] = "設置圖示",
	["Set which icon to place on players."] = "設置玩家身上標記的圖示。",

	["Options for Raid Icons."] = "團隊圖示設置",

	["Star"] = "星星",
	["Circle"] = "圓圈",
	["Diamond"] = "方塊",
	["Triangle"] = "三角",
	["Moon"] = "月亮",
	["Square"] = "方形",
	["Cross"] = "十字",
	["Skull"] = "骷髏",
} end )

L:RegisterTranslations("deDE", function() return {
	["Raid Icons"] = "Schlachtzug-Symbole",

	-- ["RaidIcon"] = true,
	-- ["place"] = true,
	-- ["icon"] = true,

	["Place"] = "Platzierung",
	["Place Raid Icons"] = "Schlachtzug-Symbole platzieren",
	["Toggle placing of Raid Icons on players."] = "Schlachtzug-Symbole auf Spieler setzen.",

	["Icon"] = "Symbol",
	["Set Icon"] = "Symbol platzieren",
	["Set which icon to place on players."] = "W\195\164hle, welches Symbol auf Spieler gesetzt wird.",

	["Options for Raid Icons."] = "Optionen f\195\188r Schlachtzug-Symbole.",

	["Star"] = "Stern",
	["Circle"] = "Kreis",
	["Diamond"] = "Diamant",
	["Triangle"] = "Dreieck",
	["Moon"] = "Mond",
	["Square"] = "Quadrat",
	["Cross"] = "Kreuz",
	["Skull"] = "Totenkopf",
} end )

L:RegisterTranslations("frFR", function() return {
	["Raid Icons"] = "Ic\195\180nes de raid",

	--["RaidIcon"] = true,
	--["place"] = true,
	--["icon"] = true,

	["Place"] = "Placement",
	["Place Raid Icons"] = "Placer les ic\195\180nes de raid",
	["Toggle placing of Raid Icons on players."] = "Place ou non les ic\195\180nes de raid sur les joueurs.",

	["Icon"] = "Ic\195\180ne",
	["Set Icon"] = "D\195\169terminer l'ic\195\180ne",
	["Set which icon to place on players."] = "D\195\169termine quelle ic\195\180ne sera plac\195\169e sur les joueurs.",

	["Options for Raid Icons."] = "Options concernant les ic\195\180nes de raid.",

	["Star"] = "\195\169toile",
	["Circle"] = "cercle",
	["Diamond"] = "diamant",
	["Triangle"] = "triangle",
	["Moon"] = "lune",
	["Square"] = "carr\195\169",
	["Cross"] = "croix",
	["Skull"] = "cr\195\162ne",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Raid Icons")

plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.defaultDB = {
	place = true,
	icon = 8,
}
plugin.consoleCmd = L["RaidIcon"]
plugin.consoleOptions = {
	type = "group",
	name = L["Raid Icons"],
	desc = L["Options for Raid Icons."],
	args   = {
		[L["place"]] = {
			type = "toggle",
			name = L["Place Raid Icons"],
			desc = L["Toggle placing of Raid Icons on players."],
			get = function() return plugin.db.profile.place end,
			set = function(v) plugin.db.profile.place = v end,
		},
		[L["icon"]] = {
			type = "text",
			name = L["Set Icon"],
			desc = L["Set which icon to place on players."],
			get = function() return tostring(plugin.db.profile.icon) end,
			set = function(v) plugin.db.profile.icon = tonumber(v) end,
			validate = {
				["1"] = L["Star"],
				["2"] = L["Circle"],
				["3"] = L["Diamond"],
				["4"] = L["Triangle"],
				["5"] = L["Moon"],
				["6"] = L["Square"],
				["7"] = L["Cross"],
				["8"] = L["Skull"]
			},
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_SetRaidIcon")
	self:RegisterEvent("BigWigs_RemoveRaidIcon")

	if type(self.db.profile.icon) ~= "number" then
		self.db.profile.icon = 8
	end
end

function plugin:BigWigs_SetRaidIcon(player)
	if not player or not self.db.profile.place then return end
	local icon = self.db.profile.icon or 8
	local num = GetNumRaidMembers()
	for i = 1, num do
		if UnitName("raid"..i) == player then
			if not GetRaidTargetIndex("raid"..i) then
				SetRaidTargetIcon("raid"..i, icon)
				lastplayer = player
			end
		end
	end
end

function plugin:BigWigs_RemoveRaidIcon()
	if not lastplayer or not self.db.profile.place then return end
	local num = GetNumRaidMembers()
	for i = 1, num do
		if UnitName("raid"..i) == lastplayer then
			SetRaidTargetIcon("raid"..i, 0)
		end
	end
	lastplayer = nil
end


