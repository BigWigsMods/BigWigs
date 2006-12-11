assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsMessages")
local paint = AceLibrary("PaintChips-2.0")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Messages"] = true,
	["msg"] = true,
	["Options for message display."] = true,

	["Show anchor"] = true,
	["anchor"] = true,
	["Show the message anchor frame."] = true,

	["Use colors"] = true,
	["color"] = true,
	["Toggles white only messages ignoring coloring."] = true,

	["Scale"] = true,
	["scale"] = true,
	["Set the message frame scale."] = true,

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = true,
	["White"] = true,
	["BigWigs frame"] = true,
	["RaidWarning frame"] = true,

	["Display"] = true,
	["display"] = true,
	["Set where messages are displayed."] = true,

	["Mik's Scrolling Battle Text"] = true,
	["Scrolling Combat Text"] = true,
	["Floating Combat Text"] = true,

	["Test"] = true,
	["Close"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Messages"] = "메세지",

--	["msg"] = "메시지",
--	["anchor"] = "위치",
--	["color"] = "색상",
--	["scale"] = "크기",

	["Options for message display."] = "메시지 창 옵션.",
	["Show the message anchor frame."] = "메시지 위치 조정 프레임 보이기.",
	["Use colors"] = "색상 사용",
	["Toggles white only messages ignoring coloring."] = "메시지를 하얀 색으로 변경.",

	["Show anchor"] = "앵커 보이기",
	["Set the message frame scale."] = "메세지 창 크기 설정",
	["Scale"] = "크기",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000색|cffff00ff상|r",
	["White"] = "화이트",
	["BigWigs frame"] = "BigWigs 창",
	["RaidWarning frame"] = "공격대경고 창",

	["display"] = "디스플레이",
	["Display"] = "디스플레이",
	["Set where messages are displayed."] = "메세지 디스플레이 설정",

	["Mik's Scrolling Battle Text"] = "MSBT",
	["Scrolling Combat Text"] = "SCT",
	["Floating Combat Text"] = "FCT",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Messages"] = "信息",

	["msg"] = "信息",
	["anchor"] = "锚点",
	["color"] = "颜色",
	["scale"] = "大小",

	["Options for message display."] = "信息框体设置。",
	["Show the message anchor frame."] = "显示信息框体锚点。",
	["Use colors"] = "发送彩色信息",
	["Toggles white only messages ignoring coloring."] = "切换是否只发送单色信息。",

	["Show anchor"] = "显示锚点",
	["Set the message frame scale."] = "设置信息框体缩放比例",
	["Scale"] = "缩放",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000颜|cffff00ff色|r",
	["White"] = "白色",
	["BigWigs frame"] = "BigWigs框体",
	["RaidWarning frame"] = "团队警告框体",

	["display"] = "显示",
	["Display"] = "显示",
	["Set where messages are displayed."] = "选择信息显示的位置",

	["Mik's Scrolling Battle Text"] = "Mik's滚动战斗信息",
	["Scrolling Combat Text"] = "滚动战斗信息",
	["Floating Combat Text"] = "浮动战斗信息",

	["Test"] = "测试",
	["Close"] = "关闭",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Messages"] = "訊息",

	["msg"] = "訊息",
	["anchor"] = "錨點",
	["color"] = "顏色",
	["scale"] = "大小",

	["Options for message display."] = "訊息框架設置。",
	["Show the message anchor frame."] = "顯示訊息訊息框架錨點。",
	["Use colors"] = "發送彩色訊息",
	["Toggles white only messages ignoring coloring."] = "切換是否只發送單色訊息。",

	["Show anchor"] = "顯示錨點",
	["Set the message frame scale."] = "設置訊息框架縮放比例",
	["Scale"] = "縮放",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000顏|cffff00ff色|r",
	["White"] = "白色",
	["BigWigs frame"] = "BigWigs框架",
	["RaidWarning frame"] = "團隊警告框架",

	["display"] = "顯示",
	["Display"] = "顯示",
	["Set where messages are displayed."] = "選擇訊息顯示的位置",

	["Mik's Scrolling Battle Text"] = "Mik's滾動戰鬥訊息",
	["Scrolling Combat Text"] = "滾動戰鬥訊息",
	["Floating Combat Text"] = "浮動戰鬥訊息",

	["Test"] = "測試",
	["Close"] = "關閉",
} end)

L:RegisterTranslations("deDE", function() return {
	["Messages"] = "Nachrichten",

	["msg"] = "msg",
	["anchor"] = "verankerung",
	["color"] = "farbe",
	["scale"] = "skalierung",

	["Options for message display."] = "Optionen f\195\188r das Nachrichtenfenster.",
	["Show the message anchor frame."] = "Verankerung des Nachrichtenfensters anzeigen.",
	["Use colors"] = "Farben benutzen",
	["Toggles white only messages ignoring coloring."] = "Nachrichten farbig/wei\195\159 anzeigen.",

	["Show anchor"] = "Verankerung anzeigen",
	["Set the message frame scale."] = "Skalierung des Nachrichtenfensters w\195\164hlen.",
	["Scale"] = "Skalierung",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Fa|cffff00ffr|cff00ff00be|r",
	["White"] = "Wei\195\159",
	["BigWigs frame"] = "BigWigs",
	["RaidWarning frame"] = "RaidWarning",

	["display"] = "anzeige",
	["Display"] = "Anzeige",
	["Set where messages are displayed."] = "W\195\164hle, wo Nachrichten angezeigt werden sollen.",

	["Mik's Scrolling Battle Text"] = "MSBT",
	["Scrolling Combat Text"] = "SCT",
	["Floating Combat Text"] = "FCT",

	["Test"] = "Test",
	["Close"] = "Schlie\195\159en",
} end)

L:RegisterTranslations("frFR", function() return {
	--["Messages"] = true,
	--["msg"] = true,
	["Options for message display."] = "Options concernant l'affichage des messages.",

	["Show anchor"] = "Afficher l'ancre",
	--["anchor"] = true,
	["Show the message anchor frame."] = "Affiche l'ancre du cadre des messages.",

	["Use colors"] = "Utiliser des couleurs",
	--["color"] = true,
	["Toggles white only messages ignoring coloring."] = "Utilise ou non des couleurs dans les messages à la place du blanc unique.",

	["Scale"] = "Taille",
	--["scale"] = true,
	["Set the message frame scale."] = "D\195\169termine la taille du cadre des messages.",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Co|cffff00ffule|cff00ff00ur|r",
	["White"] = "Blanc",
	["BigWigs frame"] = "Cadre de BigWigs",
	["RaidWarning frame"] = "Cadre des Avertissements Raid",

	["Display"] = "Affichage",
	--["display"] = true,
	["Set where messages are displayed."] = "D\195\169termine o\195\185 les messages sont affich\195\169s.",

	["Mik's Scrolling Battle Text"] = "Scrolling Battle Text de Mik",
	--["Scrolling Combat Text"] = true,
	["Floating Combat Text"] = "Message de combat flottant",

	--["Test"] = true,
	["Close"] = "Fermer",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMessages = BigWigs:NewModule(L["Messages"])
BigWigsMessages.defaultDB = {
	display = L["RaidWarning frame"],
	usecolors = true,
	scale = 1.0,
}
BigWigsMessages.consoleCmd = L["msg"]
BigWigsMessages.consoleOptions = {
	type = "group",
	name = L["Messages"],
	desc = L["Options for message display."],
	args   = {
		[L["anchor"]] = {
			type = "execute",
			name = L["Show anchor"],
			desc = L["Show the message anchor frame."],
			func = function() BigWigsMessages:BigWigs_ShowAnchors() end,
			disabled = function() return (BigWigsMessages.db.profile.display ~= L["BigWigs frame"]) end,
		},
		[L["color"]] = {
			type = "toggle",
			name = L["Use colors"],
			desc = L["Toggles white only messages ignoring coloring."],
			get = function() return BigWigsMessages.db.profile.usecolors end,
			set = function(v) BigWigsMessages.db.profile.usecolors = v end,
			map = {[true] = L["|cffff0000Co|cffff00fflo|cff00ff00r|r"], [false] = L["White"]},
		},
		[L["scale"]] = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the message frame scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			get = function() return BigWigsMessages.db.profile.scale end,
			set = function(v)
				BigWigsMessages.db.profile.scale = v
				if BigWigsMessages.msgframe then BigWigsMessages.msgframe:SetScale(v) end
			end,
			disabled = function() return (BigWigsMessages.db.profile.display ~= L["BigWigs frame"]) end,
		},
		[L["display"]] = {
			type = "text",
			name = L["Display"],
			desc = L["Set where messages are displayed."],
			get = function() return BigWigsMessages.db.profile.display end,
			validate = {L["BigWigs frame"], L["RaidWarning frame"]},
			set = function(v)
				BigWigsMessages.db.profile.display = v
			end,
		}
	},
}

------------------------------
--   Optional Dependancies  --
------------------------------

if MikSBT then
	table.insert(BigWigsMessages.consoleOptions.args[L["display"]].validate, L["Mik's Scrolling Battle Text"])
end

if SCT_Display_Message or ( SCT and SCT.DisplayMessage ) then
	table.insert(BigWigsMessages.consoleOptions.args[L["display"]].validate, L["Scrolling Combat Text"])
end

if CombatText_AddMessage then
	table.insert(BigWigsMessages.consoleOptions.args[L["display"]].validate, L["Floating Combat Text"])
end

------------------------------
--      Initialization      --
------------------------------

function BigWigsMessages:OnRegister()
	self:SetupFrames()
	self:CreateMsgFrame()
end

function BigWigsMessages:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")
end

function BigWigsMessages:CreateMsgFrame()
	self.msgframe = CreateFrame("MessageFrame")
	self.msgframe:SetWidth(512)
	self.msgframe:SetHeight(80)

	self.msgframe:SetPoint("TOP", self.frames.anchor, "BOTTOM", 0, 0)
	self.msgframe:SetScale(self.db.profile.scale or 1)
	self.msgframe:SetInsertMode("TOP")
	self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetToplevel(true)
	self.msgframe:SetFontObject(GameFontNormalLarge)
	self.msgframe:Show()
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMessages:BigWigs_ShowAnchors()
	self.frames.anchor:Show()
end

function BigWigsMessages:BigWigs_HideAnchors()
	self.frames.anchor:Hide()
end

function BigWigsMessages:BigWigs_Message(text, color, noraidsay, sound, broadcastonly)
	if not text then return end
	if broadcastonly then return end
	local r, g, b = 1, 1, 1 -- Default to white.
	if self.db.profile.usecolors then
		if color ~= nil and type(color) == "table" and type(color.r) == "number" and type(color.g) == "number" and type(color.b) == "number" then
			r, g, b = color.r, color.g, color.b
		else
			if type(BigWigsColors) == "table" and type(BigWigsColors.MsgColor) == "function" then
				color = BigWigsColors:MsgColor(color)
			end
			_, r, g, b = paint:GetRGBPercent(color or "white")
		end
	end

	if self.db.profile.display == L["RaidWarning frame"] then
		RaidWarningFrame:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
	elseif MikSBT and self.db.profile.display == L["Mik's Scrolling Battle Text"] then
		MikSBT.DisplayMessage(text, MikSBT.DISPLAYTYPE_NOTIFICATION, false, r * 255, g * 255, b * 255)
	elseif SCT_Display_Message and self.db.profile.display == L["Scrolling Combat Text"] then -- SCT 4.x
		local colorStruct = {}
		colorStruct.r, colorStruct.g, colorStruct.b = r, g, b
		SCT_Display_Message( text, colorStruct )
	elseif SCT and SCT_MSG_FRAME and self.db.profile.display == L["Scrolling Combat Text"] then -- SCT 5.x
		SCT_MSG_FRAME:AddMessage( text, r, g, b, 1 )
	elseif CombatText_AddMessage and self.db.profile.display == L["Floating Combat Text"] then -- Blizzards FCT
		CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, r, g, b, "sticky", nil)
	else -- Default BigWigs Frame fallback
		self.msgframe:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
	end
end

------------------------------
--    Create the Anchor     --
------------------------------

function BigWigsMessages:SetupFrames()
	local f, t

	f, _, _ = GameFontNormal:GetFont()

	self.frames = {}
	self.frames.anchor = CreateFrame("Frame", "BigWigsMessageAnchor", UIParent)
	self.frames.anchor.owner = self
	self.frames.anchor:Hide()

	self.frames.anchor:SetWidth(175)
	self.frames.anchor:SetHeight(75)
	self.frames.anchor:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
		})
	self.frames.anchor:SetBackdropBorderColor(.5, .5, .5)
	self.frames.anchor:SetBackdropColor(0,0,0)
	self.frames.anchor:ClearAllPoints()
	self.frames.anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	self.frames.anchor:EnableMouse(true)
	self.frames.anchor:RegisterForDrag("LeftButton")
	self.frames.anchor:SetMovable(true)
	self.frames.anchor:SetScript("OnDragStart", function() this:StartMoving() end)
	self.frames.anchor:SetScript("OnDragStop", function() this:StopMovingOrSizing() this.owner:SavePosition() end)

	self.frames.cfade = self.frames.anchor:CreateTexture(nil, "BORDER")
	self.frames.cfade:SetWidth(169)
	self.frames.cfade:SetHeight(25)
	self.frames.cfade:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	self.frames.cfade:SetPoint("TOP", self.frames.anchor, "TOP", 0, -4)
	self.frames.cfade:SetBlendMode("ADD")
	self.frames.cfade:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .25, .25, .25, 1)
	self.frames.anchor.Fade = self.frames.fade

	self.frames.cheader = self.frames.anchor:CreateFontString(nil,"OVERLAY")
	self.frames.cheader:SetFont(f, 14)
	self.frames.cheader:SetWidth(150)
	self.frames.cheader:SetText(L["Messages"])
	self.frames.cheader:SetTextColor(1, .8, 0)
	self.frames.cheader:ClearAllPoints()
	self.frames.cheader:SetPoint("TOP", self.frames.anchor, "TOP", 0, -10)

	self.frames.leftbutton = CreateFrame("Button", nil, self.frames.anchor)
	self.frames.leftbutton.owner = self
	self.frames.leftbutton:SetWidth(40)
	self.frames.leftbutton:SetHeight(25)
	self.frames.leftbutton:SetPoint("RIGHT", self.frames.anchor, "CENTER", -10, -15)
	self.frames.leftbutton:SetScript( "OnClick", function()  self:TriggerEvent("BigWigs_Test") end )

	t = self.frames.leftbutton:CreateTexture()
	t:SetWidth(50)
	t:SetHeight(32)
	t:SetPoint("CENTER", self.frames.leftbutton, "CENTER")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	self.frames.leftbutton:SetNormalTexture(t)

	t = self.frames.leftbutton:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.leftbutton)
	self.frames.leftbutton:SetPushedTexture(t)

	t = self.frames.leftbutton:CreateTexture()
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.leftbutton)
	t:SetBlendMode("ADD")
	self.frames.leftbutton:SetHighlightTexture(t)
	self.frames.leftbuttontext = self.frames.leftbutton:CreateFontString(nil,"OVERLAY")
	self.frames.leftbuttontext:SetFontObject(GameFontHighlight)
	self.frames.leftbuttontext:SetText(L["Test"])
	self.frames.leftbuttontext:SetAllPoints(self.frames.leftbutton)

	self.frames.rightbutton = CreateFrame("Button", nil, self.frames.anchor)
	self.frames.rightbutton.owner = self
	self.frames.rightbutton:SetWidth(40)
	self.frames.rightbutton:SetHeight(25)
	self.frames.rightbutton:SetPoint("LEFT", self.frames.anchor, "CENTER", 10, -15)
	self.frames.rightbutton:SetScript( "OnClick", function() self:BigWigs_HideAnchors() end )

	t = self.frames.rightbutton:CreateTexture()
	t:SetWidth(50)
	t:SetHeight(32)
	t:SetPoint("CENTER", self.frames.rightbutton, "CENTER")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	self.frames.rightbutton:SetNormalTexture(t)

	t = self.frames.rightbutton:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.rightbutton)
	self.frames.rightbutton:SetPushedTexture(t)

	t = self.frames.rightbutton:CreateTexture()
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.rightbutton)
	t:SetBlendMode("ADD")
	self.frames.rightbutton:SetHighlightTexture(t)
	self.frames.rightbuttontext = self.frames.rightbutton:CreateFontString(nil,"OVERLAY")
	self.frames.rightbuttontext:SetFontObject(GameFontHighlight)
	self.frames.rightbuttontext:SetText(L["Close"])
	self.frames.rightbuttontext:SetAllPoints(self.frames.rightbutton)

	self:RestorePosition()
end

function BigWigsMessages:SavePosition()
	local f = self.frames.anchor
	local s = f:GetEffectiveScale()

	self.db.profile.posx = f:GetLeft() * s
	self.db.profile.posy = f:GetTop() * s
end

function BigWigsMessages:RestorePosition()
	local x = self.db.profile.posx
	local y = self.db.profile.posy

	if not x or not y then return end

	local f = self.frames.anchor
	local s = f:GetEffectiveScale()

	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
end

