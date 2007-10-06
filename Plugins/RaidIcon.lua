assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRaidIcon")
local lastplayer = nil

local RL = nil
local UnitName = UnitName
local fmt = string.format
local SetIcon = SetRaidTargetIcon

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Raid Icons"] = true,
	["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = true,

	["RaidIcon"] = true,

	["Place"] = true,
	["Place Raid Icons"] = true,
	["Toggle placing of Raid Icons on players."] = true,

	["Icon"] = true,
	["Set Icon"] = true,
	["Set which icon to place on players."] = true,

	["Use the %q icon when automatically placing raid icons for boss abilities."] = true,

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
--	["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = true,

	["Place"] = "지정",
	["Place Raid Icons"] = "공격대 아이콘 지정",
	["Toggle placing of Raid Icons on players."] = "플레이어에 공격대 아이콘을 지정합니다.",

	["Icon"] = "아이콘",
	["Set Icon"] = "아이콘 설정",
	["Set which icon to place on players."] = "플레이어에 지정할 아이콘을 설정합니다.",

--	["Use the %q icon when automatically placing raid icons for boss abilities."] = true,

	["Star"] = "별",
	["Circle"] = "원",
	["Diamond"] = "다이아몬드",
	["Triangle"] = "세모",
	["Moon"] = "달",
	["Square"] = "네모",
	["Cross"] = "가위표",
	["Skull"] = "해골",
} end )

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	["Raid Icons"] = "团队标记",
	["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "为Bigwigs配置一个团队标记,以便为中了'炸弹'级别的玩家打上标记.以示提醒",

	["RaidIcon"] = "团队标记",

	["Place"] = "设置",
	["Place Raid Icons"] = "允许团队标记",
	["Toggle placing of Raid Icons on players."] = "选择是否在玩家身上显示团队图标标记 .",

	["Icon"] = "图标",
	["Set Icon"] = "设置标记",
	["Set which icon to place on players."] = "设置玩家身上团队标记.",

	["Use the %q icon when automatically placing raid icons for boss abilities."] = "当称为首领目标,使用%q标记自动为队员标上.",
	["Star"] = "星形",
	["Circle"] = "圆圈",
	["Diamond"] = "棱形",
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
	["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Justiere welches Symbol BigWigs benutzen soll wenn es Schlachzug Symbole auf Spielern plaziert für wichtige 'bomben'-typ Boss Fähigkeiten.",

	["Place"] = "Platzierung",
	["Place Raid Icons"] = "Schlachtzug-Symbole platzieren",
	["Toggle placing of Raid Icons on players."] = "Schlachtzug-Symbole auf Spieler setzen.",

	["Icon"] = "Symbol",
	["Set Icon"] = "Symbol platzieren",
	["Set which icon to place on players."] = "Wähle, welches Symbol auf Spieler gesetzt wird.",

	["Use the %q icon when automatically placing raid icons for boss abilities."] = "Benutze das %q Symbol wenn automatisch Schlachtzug Symbole für Boss Fähigkeiten verteillt werden.",

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
	["Raid Icons"] = "Icônes de raid",
	["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Détermine l'icône que Big Wigs doit utiliser lors du placement des icônes de raid sur les joueurs affectés par les capacités des boss (ex. la bombe de Geddon).",

	["RaidIcon"] = "IcôneRaid",

	["Place"] = "Placement",
	["Place Raid Icons"] = "Placer les icônes de raid",
	["Toggle placing of Raid Icons on players."] = "Place ou non les icônes de raid sur les joueurs.",

	["Icon"] = "Icône",
	["Set Icon"] = "Déterminer l'icône",
	["Set which icon to place on players."] = "Détermine quelle icône sera placée sur les joueurs.",

	["Use the %q icon when automatically placing raid icons for boss abilities."] = "Utilise l'icône %q lors des placements automatiques des icônes de raid pour les capacités des boss.",

	["Star"] = "Étoile",
	["Circle"] = "Cercle",
	["Diamond"] = "Diamant",
	["Triangle"] = "Triangle",
	["Moon"] = "Lune",
	["Square"] = "Carré",
	["Cross"] = "Croix",
	["Skull"] = "Crâne",
} end )

L:RegisterTranslations("esES", function() return {
	["Raid Icons"] = "Iconos de Banda",
	["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Configura que \195\173conos deber\195\173a usar BigWigs al colocarlos sobre jugadores en importantes habilidades del jefe tipo 'Bomba'",

	["RaidIcon"] = "Icono de banda",

	["Place"] = "Colocar",
	["Place Raid Icons"] = "Colocar \195\173conos de banda",
	["Toggle placing of Raid Icons on players."] = "Activa colocar iconos de banda sobre jugadores",

	["Icon"] = "Icono",
	["Set Icon"] = "Establecer Icono",
	["Set which icon to place on players."] = "Establece que Icono colocar sobre los jugadores",

	["Use the %q icon when automatically placing raid icons for boss abilities."] = "Usar el \195\173cono %q cuando coloque automaticamente \195\173conos de banda para habilidades de Jefes",

	["Star"] = "Estrella",
	["Circle"] = "Circulo",
	["Diamond"] = "Diamante",
	["Triangle"] = "Triangulo",
	["Moon"] = "Luna",
	["Square"] = "Cuadrado",
	["Cross"] = "Cruz",
	["Skull"] = "Calavera",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Raid Icons")

plugin.revision = tonumber(("$Revision$"):sub(12, -3))
plugin.defaultDB = {
	place = true,
	icon = 8,
}

local function get(key)
	return plugin.db.profile.icon == key
end
local function set(key, val)
	plugin.db.profile.icon = key
end
local function disabled()
	return not plugin.db.profile.place
end

plugin.consoleCmd = L["RaidIcon"]
plugin.consoleOptions = {
	type = "group",
	name = L["Raid Icons"],
	desc = L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."],
	args   = {
		place = {
			type = "toggle",
			name = L["Place Raid Icons"],
			desc = L["Toggle placing of Raid Icons on players."],
			get = function() return plugin.db.profile.place end,
			set = function(v) plugin.db.profile.place = v end,
			order = 1,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		Star = {
			type = "toggle",
			name = L["Star"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Star"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 101,
			passValue = 1,
		},
		Circle = {
			type = "toggle",
			name = L["Circle"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Circle"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 102,
			passValue = 2,
		},
		Diamond = {
			type = "toggle",
			name = L["Diamond"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Diamond"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 103,
			passValue = 3,
		},
		Triangle = {
			type = "toggle",
			name = L["Triangle"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Triangle"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 104,
			passValue = 4,
		},
		Moon = {
			type = "toggle",
			name = L["Moon"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Moon"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 105,
			passValue = 5,
		},
		Square = {
			type = "toggle",
			name = L["Square"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Square"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 106,
			passValue = 6,
		},
		Cross = {
			type = "toggle",
			name = L["Cross"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Cross"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 107,
			passValue = 7,
		},
		Skull = {
			type = "toggle",
			name = L["Skull"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Skull"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 108,
			passValue = 8,
		},
	},
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

	if AceLibrary:HasInstance("Roster-2.1") then
		RL = AceLibrary("Roster-2.1")
	end
end

function plugin:BigWigs_SetRaidIcon(player)
	if not player or not self.db.profile.place then return end
	local icon = self.db.profile.icon or 8
	local GetIndex = GetRaidTargetIndex
	if RL then
		local id = RL:GetUnitIDFromName(player)
		if id and not GetIndex(id) then
			SetIcon(id, icon)
			lastplayer = player
		end
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			local raid = fmt("%s%d", "raid", i)
			if UnitName(raid) == player then
				if not GetIndex(raid) then
					SetIcon(raid, icon)
					lastplayer = player
				end
			end
		end
	end
end

function plugin:BigWigs_RemoveRaidIcon()
	if not lastplayer or not self.db.profile.place then return end
	if RL then
		local id = RL:GetUnitIDFromName(lastplayer)
		if id then
			SetIcon(id, 0)
		end
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			local raid = fmt("%s%d", "raid", i)
			if UnitName(raid) == lastplayer then
				SetIcon(raid, 0)
			end
		end
	end
	lastplayer = nil
end


