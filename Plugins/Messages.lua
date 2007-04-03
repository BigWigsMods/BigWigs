assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsMessages")
local paint = AceLibrary("PaintChips-2.0")

local colorModule = nil
local messageFrame = nil
local anchor = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Messages"] = true,
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
	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = true,

	["Mik's Scrolling Battle Text"] = true,
	["Scrolling Combat Text"] = true,
	["Floating Combat Text"] = true,
	["Chat frame"] = true,
	["chat"] = true,

	["Test"] = true,
	["Close"] = true,

	["reset"] = true,
	["Reset position"] = true,
	["Reset the anchor position, moving it to the center of your screen."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Messages"] = "메세지",

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

	["Display"] = "디스플레이",
	["Set where messages are displayed."] = "메세지 디스플레이 설정",
--	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = true,

	["Mik's Scrolling Battle Text"] = "MSBT",
	["Scrolling Combat Text"] = "SCT",
	["Floating Combat Text"] = "FCT",
	["Chat frame"] = "대화창",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Messages"] = "信息",

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
	["Options for message display."] = "Optionen f\195\188r das Nachrichtenfenster.",

	["Show anchor"] = "Verankerung anzeigen",
	-- ["anchor"] = true,
	["Show the message anchor frame."] = "Verankerung des Nachrichtenfensters anzeigen.",

	["Use colors"] = "Farben benutzen",
	-- ["color"] = true,
	["Toggles white only messages ignoring coloring."] = "Nachrichten farbig/wei\195\159 anzeigen.",

	["Scale"] = "Skalierung",
	-- ["scale"] = true,
	["Set the message frame scale."] = "Skalierung des Nachrichtenfensters w\195\164hlen.",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Fa|cffff00ffr|cff00ff00be|r",
	["White"] = "Wei\195\159",
	["BigWigs frame"] = "BigWigs Fenster",
	["RaidWarning frame"] = "RaidWarning Fenster",

	["Display"] = "Anzeige",
	-- ["display"] = true,
	["Set where messages are displayed."] = "W\195\164hle, wo Nachrichten angezeigt werden sollen.",

	-- ["Mik's Scrolling Battle Text"] = true,
	-- ["Scrolling Combat Text"] = true,
	-- ["Floating Combat Text"] = true,

	["Test"] = "Test",
	["Close"] = "Schlie\195\159en",
} end)

L:RegisterTranslations("frFR", function() return {
	--["Messages"] = true,
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
	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Affiche tous les messages de BigWigs dans la fen\195\170tre de discussion par d\195\169faut, en plus de son affichage normal.",

	["Mik's Scrolling Battle Text"] = "Scrolling Battle Text de Mik",
	--["Scrolling Combat Text"] = true,
	["Floating Combat Text"] = "Message de combat flottant",
	["Chat frame"] = "Fen\195\170tre de discussion",
	--["chat"] = true,

	--["Test"] = true,
	["Close"] = "Fermer",

	--["reset"] = true,
	["Reset position"] = "R\195\128Z position",
	["Reset the anchor position, moving it to the center of your screen."] = "R\195\169initialise la position de l'ancre, la repla\195\167ant au centre de l'\195\169cran.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Messages")

plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.defaultDB = {
	display = L["RaidWarning frame"],
	usecolors = true,
	scale = 1.0,
	posx = nil,
	posy = nil,
	chat = nil,
}
plugin.consoleCmd = L["Messages"]
plugin.consoleOptions = {
	type = "group",
	name = L["Messages"],
	desc = L["Options for message display."],
	args   = {
		[L["anchor"]] = {
			type = "toggle",
			name = L["Show anchor"],
			desc = L["Show the message anchor frame."],
			get = function() return anchor:IsShown() end,
			set = function(v)
				if v then
					plugin:BigWigs_ShowAnchors()
				else
					plugin:BigWigs_HideAnchors()
				end
			end,
			disabled = function() return (plugin.db.profile.display ~= L["BigWigs frame"]) end,
			order = 1,
		},
		[L["reset"]] = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor position, moving it to the center of your screen."],
			func = function() plugin:ResetAnchor() end,
			order = 2,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		[L["color"]] = {
			type = "toggle",
			name = L["Use colors"],
			desc = L["Toggles white only messages ignoring coloring."],
			get = function() return plugin.db.profile.usecolors end,
			set = function(v) plugin.db.profile.usecolors = v end,
			map = {[true] = L["|cffff0000Co|cffff00fflo|cff00ff00r|r"], [false] = L["White"]},
			order = 100,
		},
		[L["scale"]] = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the message frame scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			get = function() return plugin.db.profile.scale end,
			set = function(v)
				plugin.db.profile.scale = v
				if messageFrame then messageFrame:SetScale(v) end
			end,
			disabled = function() return (plugin.db.profile.display ~= L["BigWigs frame"]) end,
			order = 101,
		},
		[L["display"]] = {
			type = "text",
			name = L["Display"],
			desc = L["Set where messages are displayed."],
			get = function() return plugin.db.profile.display end,
			validate = {L["BigWigs frame"], L["RaidWarning frame"]},
			set = function(v)
				plugin.db.profile.display = v
			end,
			order = 102,
		},
		[L["chat"]] = {
			type = "toggle",
			name = L["Chat frame"],
			desc = L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."],
			get = function() return plugin.db.profile.chat end,
			set = function(v) plugin.db.profile.chat = v end,
			order = 103,
		},
	},
}

------------------------------
--   Optional Dependancies  --
------------------------------

if MikSBT then
	table.insert(plugin.consoleOptions.args[L["display"]].validate, L["Mik's Scrolling Battle Text"])
end

if SCT_Display_Message or ( SCT and SCT.DisplayMessage ) then
	table.insert(plugin.consoleOptions.args[L["display"]].validate, L["Scrolling Combat Text"])
end

if CombatText_AddMessage then
	table.insert(plugin.consoleOptions.args[L["display"]].validate, L["Floating Combat Text"])
end

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	if not self.frames then
		self:SetupFrames()
	end

	if not messageFrame then
		self:CreateMsgFrame()
	end

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")

	if BigWigs:HasModule("Colors") then
		colorModule = BigWigs:GetModule("Colors")
	else
		colorModule = nil
	end
end

function plugin:CreateMsgFrame()
	messageFrame = CreateFrame("MessageFrame")
	messageFrame:SetWidth(512)
	messageFrame:SetHeight(80)

	messageFrame:SetPoint("TOP", anchor, "BOTTOM", 0, 0)
	messageFrame:SetScale(self.db.profile.scale or 1)
	messageFrame:SetInsertMode("TOP")
	messageFrame:SetFrameStrata("HIGH")
	messageFrame:SetToplevel(true)
	messageFrame:SetFontObject(GameFontNormalLarge)
	messageFrame:Show()
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:BigWigs_ShowAnchors()
	anchor:Show()
end

function plugin:BigWigs_HideAnchors()
	anchor:Hide()
end

function plugin:BigWigs_Message(text, color, noraidsay, sound, broadcastonly)
	if broadcastonly or not text then return end

	local db = self.db.profile

	local r, g, b = 1, 1, 1 -- Default to white.
	if db.usecolors then
		if type(color) == "table" and type(color.r) == "number" and type(color.g) == "number" and type(color.b) == "number" then
			r, g, b = color.r, color.g, color.b
		else
			if type(colorModule) == "table" and type(colorModule.MsgColor) == "function" then
				color = colorModule:MsgColor(color)
			end
			r, g, b = select(2, paint:GetRGBPercent(color or "white"))
		end
	end

	local display = db.display

	if display == L["RaidWarning frame"] then
		RaidWarningFrame:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
	elseif MikSBT and display == L["Mik's Scrolling Battle Text"] then
		MikSBT.DisplayMessage(text, MikSBT.DISPLAYTYPE_NOTIFICATION, false, r * 255, g * 255, b * 255)
	elseif SCT and SCT_MSG_FRAME and display == L["Scrolling Combat Text"] then -- SCT 5.x
		SCT_MSG_FRAME:AddMessage( text, r, g, b, 1 )
	elseif CombatText_AddMessage and display == L["Floating Combat Text"] then -- Blizzards FCT
		CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, r, g, b, "sticky", nil)
	else -- Default BigWigs Frame fallback
		messageFrame:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
	end

	if db.chat then
		BigWigs:CustomPrint(r, g, b, nil, nil, nil, text)
	end
end

------------------------------
--    Anchor                --
------------------------------

function plugin:SetupFrames()
	anchor = CreateFrame("Frame", "BigWigsMessageAnchor", UIParent)
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
	cheader:SetText(L["Messages"])
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
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent, "CENTER")
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function plugin:SavePosition()
	local s = anchor:GetEffectiveScale()

	self.db.profile.posx = anchor:GetLeft() * s
	self.db.profile.posy = anchor:GetTop() * s
end

function plugin:RestorePosition()
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

