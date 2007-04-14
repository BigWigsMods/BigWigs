assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsBars")

local media = AceLibrary("SharedMedia-1.0")
local mType = media.MediaType and media.MediaType.STATUSBAR or "statusbar"

local colorModule = nil
local anchor = nil
local moduleBars = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Bars"] = true,
	["Options for the timer bars."] = true,

	["Show anchor"] = true,
	["Show the bar anchor frame."] = true,

	["Scale"] = true,
	["Set the bar scale."] = true,

	["Grow upwards"] = true,
	["Toggle bars grow upwards/downwards from anchor."] = true,

	["Texture"] = true,
	["Set the texture for the timer bars."] = true,

	["Test"] = true,
	["Close"] = true,

	["Reset position"] = true,
	["Reset the anchor position, moving it to the center of your screen."] = true,

	["Reverse"] = true,
	["Toggles if bars are reversed (fill up instead of emptying)."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Bars"] = "바",
	["Options for the timer bars."] = "타이머 바에 대한 설정입니다.",

	["Show anchor"] = "고정 위치 표시",
	["Show the bar anchor frame."] = "바의 고정 위치를 표시합니다.",

	["Scale"] = "크기",
	["Set the bar scale."] = "바의 크기를 조절합니다.",

	["Grow upwards"] = "생성 방향",
	["Toggle bars grow upwards/downwards from anchor."] = "바의 생성 방향을 위/아래로 전환합니다.",

	["Texture"] = "텍스쳐",
	["Set the texture for the timer bars."] = "타이머 바의 텍스쳐를 설정합니다.",

	["Test"] = "테스트",
	["Close"] = "닫기",

	["Reset position"] = "위치 초기화",
	["Reset the anchor position, moving it to the center of your screen."] = "화면의 중앙으로 고정위치를 초기화합니다.",

	["Reverse"] = "반전",
	["Toggles if bars are reversed (fill up instead of emptying)."] = "바의 반전을 전환합니다(채우기 혹은 비움).",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Bars"] = "计时条",

	["Options for the timer bars."] = "计时条设置/",
	["Show the bar anchor frame."] = "显示计时条框体锚点。",
	["Set the bar scale."] = "设置计时条缩放比例。",
	["Grow upwards"] = "向上排列",
	["Toggle bars grow upwards/downwards from anchor."] = "切换计时条从锚点向下/向上排列。",

	["Show anchor"] = "显示锚点",
	["Scale"] = "缩放",

	["Test"] = "测试",
	["Close"] = "关闭",

	["Texture"] = "材质",
	["Set the texture for the timer bars."] = "为计时条设定材质。",
} end)


L:RegisterTranslations("zhTW", function() return {
	["Bars"] = "計時條",

	["Options for the timer bars."] = "計時條設置",
	["Show the bar anchor frame."] = "顯示計時條框架錨點。",
	["Set the bar scale."] = "設置計時條縮放比例。",
	["Grow upwards"] = "向上排列",
	["Toggle bars grow upwards/downwards from anchor."] = "切換計時條從錨點向下/向上排列。",

	["Show anchor"] = "顯示錨點",
	["Scale"] = "縮放",

	["Test"] = "測試",
	["Close"] = "關閉",

	["Texture"] = "材質",
	["Set the texture for the timer bars."] = "設定計時條的材質花紋",
} end)

L:RegisterTranslations("deDE", function() return {
	["Bars"] = "Anzeigebalken",
	["Options for the timer bars."] = "Optionen f\195\188r die Anzeigebalken.",

	["Show anchor"] = "Verankerung anzeigen",
	["Show the bar anchor frame."] = "Verankerung der Anzeigebalken anzeigen.",

	["Scale"] = "Skalierung",
	["Set the bar scale."] = "Skalierung der Anzeigebalken w\195\164hlen.",

	["Grow upwards"] = "Nach oben fortsetzen",
	["Toggle bars grow upwards/downwards from anchor."] = "Anzeigebalken von der Verankerung aus nach oben/unten fortsetzen.",

	["Texture"] = "Textur",
	["Set the texture for the timer bars."] = "Textur der Anzeigebalken w\195\164hlen.",

	["Test"] = "Test",
	["Close"] = "Schlie\195\159en",
} end)

L:RegisterTranslations("frFR", function() return {
	["Bars"] = "Barres",
	["Options for the timer bars."] = "Options concernant les barres temporelles.",

	["Show anchor"] = "Afficher l'ancre",
	["Show the bar anchor frame."] = "Affiche l'ancre du cadre des barres.",

	["Scale"] = "Taille",
	["Set the bar scale."] = "D\195\169termine la taille des barres.",

	["Grow upwards"] = "Ajouter vers le haut",
	["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre.",

	--["Texture"] = true,
	["Set the texture for the timer bars."] = "D\195\169termine la texture des barres temporelles.",

	--["Test"] = true,
	["Close"] = "Fermer",

	["Reset position"] = "R\195\128Z position",
	["Reset the anchor position, moving it to the center of your screen."] = "R\195\169initialise la position de l'ancre, la repla\195\167ant au centre de l'\195\169cran.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Bars", "CandyBar-2.0")
plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.defaultDB = {
	growup = false,
	scale = 1.0,
	texture = "BantoBar",
	posx = nil,
	posy = nil,
	width = nil,
	height = nil,
	reverse = nil,
}
plugin.consoleCmd = L["Bars"]
plugin.consoleOptions = {
	type = "group",
	name = L["Bars"],
	desc = L["Options for the timer bars."],
	handler = plugin,
	pass = true,
	func = "ResetAnchor",
	get = function(key)
		if key == "anchor" then
			return anchor and anchor:IsShown()
		else
			return plugin.db.profile[key]
		end
	end,
	set = function(key, value)
		if key == "anchor" then
			if value then
				plugin:BigWigs_ShowAnchors()
			else
				plugin:BigWigs_HideAnchors()
			end
		else
			plugin.db.profile[key] = value
		end
	end,
	args = {
		anchor = {
			type = "toggle",
			name = L["Show anchor"],
			desc = L["Show the bar anchor frame."],
			order = 1,
		},
		reset = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor position, moving it to the center of your screen."],
			order = 2,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		growup = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			order = 100,
		},
		reverse = {
			type = "toggle",
			name = L["Reverse"],
			desc = L["Toggles if bars are reversed (fill up instead of emptying)."],
			order = 101,
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the bar scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			order = 102,
		},
		texture = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timer bars."],
			validate = media:List(mType),
			order = 103,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnRegister()
	media:Register(mType, "Otravi", "Interface\\AddOns\\BigWigs\\Textures\\otravi")
	media:Register(mType, "Smooth", "Interface\\AddOns\\BigWigs\\Textures\\smooth")
	media:Register(mType, "Glaze", "Interface\\AddOns\\BigWigs\\Textures\\glaze")
	media:Register(mType, "Charcoal", "Interface\\AddOns\\BigWigs\\Textures\\Charcoal")
	media:Register(mType, "BantoBar", "Interface\\AddOns\\BigWigs\\Textures\\default")
end

function plugin:OnEnable()
	if not media:Fetch(mType, self.db.profile.texture, true) then self.db.profile.texture = "BantoBar" end

	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")
	self:RegisterEvent("BigWigs_StartBar")
	self:RegisterEvent("BigWigs_StopBar")
	self:RegisterEvent("Ace2_AddonDisabled")

	if BigWigs:HasModule("Colors") then
		colorModule = BigWigs:GetModule("Colors")
	else
		colorModule = nil
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:Ace2_AddonDisabled(module)
	if moduleBars[module] then
		for k in pairs(moduleBars[module]) do
			self:UnregisterCandyBar(k)
			moduleBars[module][k] = nil
		end
	end
end

function plugin:BigWigs_ShowAnchors()
	if not anchor then self:SetupFrames() end
	anchor:Show()
end

function plugin:BigWigs_HideAnchors()
	if not anchor then return end
	anchor:Hide()
end

function plugin:BigWigs_StartBar(module, text, time, icon, otherc, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	if not text or not time then return end
	local id = "BigWigsBar "..text
	local u = self.db.profile.growup

	-- yes we try and register every time, we also set the point every time since people can change their mind midbar.
	self:RegisterCandyBarGroup("BigWigsGroup")
	if not anchor then self:SetupFrames() end
	self:SetCandyBarGroupPoint("BigWigsGroup", u and "BOTTOM" or "TOP", anchor, u and "TOP" or "BOTTOM", 0, 0)
	self:SetCandyBarGroupGrowth("BigWigsGroup", u)

	local bc, balpha, txtc
	if type(colorModule) == "table" then
		if type(otherc) ~= "boolean" or not otherc then c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 = colorModule:BarColor(time) end
		bc, balpha, txtc = colorModule.db.profile.bgc, colorModule.db.profile.bga, colorModule.db.profile.txtc
	end

	if not moduleBars[module] then moduleBars[module] = {} end
	moduleBars[module][id] = true

	self:RegisterCandyBar(id, time, text, icon, c1, c2, c3, c4, c5, c6, c8, c9, c10)

	local groupId = "BigWigsGroup"
	if type(module.GetBarGroupId) == "function" then
		groupId = module:GetBarGroupId(text)
	end
	self:RegisterCandyBarWithGroup(id, groupId)

	local db = self.db.profile

	self:SetCandyBarTexture(id, media:Fetch(mType, db.texture))
	if bc then self:SetCandyBarBackgroundColor(id, bc, balpha) end
	if txtc then self:SetCandyBarTextColor(id, txtc) end

	if type(db.width) == "number" then
		self:SetCandyBarWidth(id, db.width)
	end
	if type(db.height) == "number" then
		self:SetCandyBarHeight(id, db.height)
	end

	self:SetCandyBarScale(id, db.scale or 1)
	self:SetCandyBarFade(id, .5)
	self:SetCandyBarReversed(id, db.reverse)
	self:StartCandyBar(id, true)
end

function plugin:BigWigs_StopBar(module, text)
	if not text then return end
	local id = "BigWigsBar "..text
	self:UnregisterCandyBar(id)
	if moduleBars[module] then
		moduleBars[module][id] = nil
	end
end

------------------------------
--    Create the Anchor     --
------------------------------

function plugin:SetupFrames()
	if anchor then return end

	anchor = CreateFrame("Frame", "BigWigsBarAnchor", UIParent)
	anchor:Hide()

	anchor:SetWidth(120)
	anchor:SetHeight(80)
	
	anchor:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\BigWigs\\Textures\\otravi-semi-full-border", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})

	anchor:SetBackdropColor(24/255, 24/255, 24/255)
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	anchor:EnableMouse(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetMovable(true)
	anchor:SetScript("OnDragStart", function() this:StartMoving() end)
	anchor:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SavePosition()
	end)

	local cheader = anchor:CreateFontString(nil,"OVERLAY")
	cheader:ClearAllPoints()
	cheader:SetWidth(110)
	cheader:SetHeight(15)
	cheader:SetPoint("TOP", anchor, "TOP", 0, -14)
	cheader:SetFont("Fonts\\FRIZQT__.TTF", 12)
	cheader:SetJustifyH("LEFT")
	cheader:SetText(L["Bars"])
	cheader:SetShadowOffset(.8, -.8)
	cheader:SetShadowColor(0, 0, 0, 1)

	local close = anchor:CreateTexture(nil, "ARTWORK")
	close:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\otravi-close")
	close:SetTexCoord(0, .625, 0, .9333)

	close:SetWidth(20)
	close:SetHeight(14)
	close:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", -7, -15)

	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( anchor )
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetPoint("CENTER", close, "CENTER")
	closebutton:SetScript( "OnClick", function() self:BigWigs_HideAnchors() end )

	local testbutton = CreateFrame("Button", nil, anchor, "UIPanelButtonTemplate")
	testbutton:SetWidth(60)
	testbutton:SetHeight(25)
	testbutton:SetText(L["Test"])
	testbutton:SetPoint("CENTER", anchor, "CENTER", 0, -16)
	testbutton:SetScript( "OnClick", function()  self:TriggerEvent("BigWigs_Test") end )

	self:RestorePosition()
end

function plugin:ResetAnchor()
	if not anchor then self:SetupFrames() end
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent, "CENTER")
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function plugin:SavePosition()
	if not anchor then self:SetupFrames() end

	local s = anchor:GetEffectiveScale()

	self.db.profile.posx = anchor:GetLeft() * s
	self.db.profile.posy = anchor:GetTop() * s
end

function plugin:RestorePosition()
	if not anchor then self:SetupFrames() end

	local x = self.db.profile.posx
	local y = self.db.profile.posy

	if x and y then
		local s = anchor:GetEffectiveScale()
		anchor:ClearAllPoints()
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self:ResetAnchor()
	end
end

