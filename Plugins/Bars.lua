assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsBars")
local surface = AceLibrary("Surface-1.0")

local anchor = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Bars"] = true,
	["Options for the timer bars."] = true,

	["Show anchor"] = true,
	["anchor"] = true,
	["Show the bar anchor frame."] = true,

	["Scale"] = true,
	["scale"] = true,
	["Set the bar scale."] = true,

	["Grow upwards"] = true,
	["up"] = true,
	["Toggle bars grow upwards/downwards from anchor."] = true,

	["Texture"] = true,
	["Set the texture for the timer bars."] = true,

	["Test"] = true,
	["Close"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Bars"] = "바",

	["Options for the timer bars."] = "Timer 바 옵션 조정.",
	["Show the bar anchor frame."] = "바 위치 조정 프레임 보이기.",
	["Set the bar scale."] = "바 크기 조절.",
	["Grow upwards"] = "바 위로 생성",
	["Toggle bars grow upwards/downwards from anchor."] = "바 표시 순서를 위/아래로 조정.",

	["Show anchor"] = "앵커 보이기",
	["Scale"]= "크기",

	["Test"] = "테스트",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Bars"] = "计时条",

	["anchor"] = "锚点",
	["scale"] = "大小",
	["up"] = "上",

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

	["anchor"] = "錨點",
	["scale"] = "大小",
	["up"] = "上",

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
	-- ["anchor"] = true,
	["Show the bar anchor frame."] = "Verankerung der Anzeigebalken anzeigen.",

	["Scale"] = "Skalierung",
	-- ["scale"] = true,
	["Set the bar scale."] = "Skalierung der Anzeigebalken w\195\164hlen.",

	["Grow upwards"] = "Nach oben fortsetzen",
	-- ["up"] = true,
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
	--["anchor"] = true,
	["Show the bar anchor frame."] = "Affiche l'ancre du cadre des barres.",

	["Scale"] = "Taille",
	--["scale"] = true,
	["Set the bar scale."] = "D\195\169termine la taille des barres.",

	["Grow upwards"] = "Ajouter vers le haut",
	--["up"] = true,
	["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre.",

	--["Texture"] = true,
	["Set the texture for the timer bars."] = "D\195\169termine la texture des barres temporelles.",

	--["Test"] = true,
	["Close"] = "Fermer",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBars = BigWigs:NewModule(L["Bars"])
BigWigsBars.revision = tonumber(string.sub("$Revision$", 12, -3))
BigWigsBars.defaultDB = {
	growup = false,
	scale = 1.0,
	texture = "BantoBar",
}
BigWigsBars.consoleCmd = L["Bars"]
BigWigsBars.consoleOptions = {
	type = "group",
	name = L["Bars"],
	desc = L["Options for the timer bars."],
	args   = {
		[L["anchor"]] = {
			type = "execute",
			name = L["Show anchor"],
			desc = L["Show the bar anchor frame."],
			func = function() BigWigsBars:BigWigs_ShowAnchors() end,
		},
		[L["up"]] = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			get = function() return BigWigsBars.db.profile.growup end,
			set = function(v) BigWigsBars.db.profile.growup = v end,
		},
		[L["scale"]] = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the bar scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			get = function() return BigWigsBars.db.profile.scale end,
			set = function(v) BigWigsBars.db.profile.scale = v end,
		},
		[L["Texture"]] = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timer bars."],
			get = function() return BigWigsBars.db.profile.texture end,
			set = function(v) BigWigsBars.db.profile.texture = v end,
			validate = surface:List(),
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsBars:OnRegister()
	local path = "Interface\\AddOns\\BigWigs\\Textures\\"
	surface:Register("Otravi",   path.."otravi")
	surface:Register("Smooth",   path.."smooth")
	surface:Register("Glaze",    path.."glaze")
	surface:Register("Charcoal", path.."Charcoal")
	surface:Register("BantoBar", path.."default")
end

function BigWigsBars:OnEnable()
	if not surface:Fetch(self.db.profile.texture) then self.db.profile.texture = "BantoBar" end

	if not anchor then
		self:SetupFrames()
	end

	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")
	self:RegisterEvent("BigWigs_StartBar")
	self:RegisterEvent("BigWigs_StopBar")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBars:BigWigs_ShowAnchors()
	anchor:Show()
end

function BigWigsBars:BigWigs_HideAnchors()
	anchor:Hide()
end

function BigWigsBars:BigWigs_StartBar(module, text, time, icon, otherc, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	if not text or not time then return end
	local id = "BigWigsBar "..text
	local u = self.db.profile.growup

	-- yes we try and register every time, we also set the point every time since people can change their mind midbar.
	module:RegisterCandyBarGroup("BigWigsGroup")
	module:SetCandyBarGroupPoint("BigWigsGroup", u and "BOTTOM" or "TOP", anchor, u and "TOP" or "BOTTOM", 0, 0)
	module:SetCandyBarGroupGrowth("BigWigsGroup", u)

	local bc, balpha, txtc
	if type(BigWigsColors) == "table" then
		if type(otherc) ~= "boolean" or not otherc then c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 = BigWigsColors:BarColor(time) end
		bc, balpha, txtc = BigWigsColors.db.profile.bgc, BigWigsColors.db.profile.bga, BigWigsColors.db.profile.txtc
	end

	module:RegisterCandyBar(id, time, text, icon, c1, c2, c3, c4, c5, c6, c8, c9, c10)
	module:RegisterCandyBarWithGroup(id, "BigWigsGroup")
	module:SetCandyBarTexture( id, surface:Fetch( self.db.profile.texture) )
	if bc then module:SetCandyBarBackgroundColor(id, bc, balpha) end
	if txtc then module:SetCandyBarTextColor(id, txtc) end

	module:SetCandyBarScale(id, self.db.profile.scale or 1)
	module:SetCandyBarFade(id, .5)
	module:StartCandyBar(id, true)
end

function BigWigsBars:BigWigs_StopBar(module, text)
	if not text then return end
	module:UnregisterCandyBar("BigWigsBar "..text)
end

------------------------------
--    Create the Anchor     --
------------------------------

function BigWigsBars:SetupFrames()
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

function BigWigsBars:SavePosition()
	local s = anchor:GetEffectiveScale()

	self.db.profile.posx = anchor:GetLeft() * s
	self.db.profile.posy = anchor:GetTop() * s
end

function BigWigsBars:RestorePosition()
	local x = self.db.profile.posx
	local y = self.db.profile.posy

	if not x or not y then return end

	local s = anchor:GetEffectiveScale()

	anchor:ClearAllPoints()
	anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
end


