assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsMessages")
local paint = AceLibrary:HasInstance("PaintChips-2.0") and AceLibrary("PaintChips-2.0") or nil

local colorModule = nil
local testModule = nil
local messageFrame = nil
local anchor = nil
local GetSpellInfo = GetSpellInfo 

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Messages"] = true,
	["Options for message display."] = true,

	["BigWigs Anchor"] = true,
	["Output Settings"] = true,

	["Show anchor"] = true,
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = true,

	["Use colors"] = true,
	["Toggles white only messages ignoring coloring."] = true,

	["Scale"] = true,
	["Set the message frame scale."] = true,

	["Use icons"] = true,
	["Show icons next to messages, only works for Raid Warning."] = true,

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = true,
	["White"] = true,

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = true,

	["Chat frame"] = true,

	["Test"] = true,
	["Close"] = true,

	["Reset position"] = true,
	["Reset the anchor position, moving it to the center of your screen."] = true,

	Font = "Fonts\\FRIZQT__.TTF",
} end)

L:RegisterTranslations("koKR", function() return {
	["Messages"] = "메세지",
	["Options for message display."] = "메세지 표시에 대한 설정입니다.",

	["BigWigs Anchor"] = "BigWigs 메세지 위치",
	["Output Settings"] = "출력 설정",

	["Show anchor"] = "고정 위치 표시",
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "메세지의 고정 위치를 표시합니다.\n\n'BigWigs'로 출력이 선택되어 있을 때에만 표시합니다.",

	["Use colors"] = "색상 사용",
	["Toggles white only messages ignoring coloring."] = "메세지에 색상 사용을 설정합니다.",

	["Scale"] = "크기",
	["Set the message frame scale."] = "메세지창의 크기를 설정합니다.",

	["Use icons"] = "아이콘 사용",
	["Show icons next to messages, only works for Raid Warning."] = "레이드 경고를 위한, 메세지 옆에 아이콘 표시합니다.",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000색|cffff00ff상|r",
	["White"] = "흰색",

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "모든 BigWigs 메세지를 디스플레이 설정에 추가된 기본 대화창에 출력합니다.",

	["Chat frame"] = "대화창",

	["Test"] = "테스트",
	["Close"] = "닫기",

	["Reset position"] = "위치 초기화",
	["Reset the anchor position, moving it to the center of your screen."] = "화면의 중앙으로 고정 위치를 초기화합니다.",
	
	Font = "Fonts\\2002.TTF",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Messages"] = "信息提示",
	["Options for message display."] = "信息显示模式及相关设置。",

	["BigWigs Anchor"] = "BigWigs 锚点",
	["Output Settings"] = "输出设置",

	["Show anchor"] = "显示信息框体",
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "显示信息框，可以移动设置信息显示位置（仅针对使用 BigWigs 窗口模式）。",

	["Use colors"] = "发送彩色信息",
	["Toggles white only messages ignoring coloring."] = "选择是否只发送单色信息。",

	["Scale"] = "缩放",
	["Set the message frame scale."] = "调整信息文字大小。",

	["Use icons"] = "使用技能图标",
	["Show icons next to messages, only works for Raid Warning."] = "显示图标，目前只能使用在团队警告频道。",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000颜|cffff00ff色|r",
	["White"] = "白色",

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "除了增加显示设置之外，将所有 BigWigs 信息输出到默认聊天框。",

	["Chat frame"] = "聊天框",

	["Test"] = "测试",
	["Close"] = "关闭",

	["Reset position"] = "重置位置",
	["Reset the anchor position, moving it to the center of your screen."] = "重置信息显示位置，移动到默认屏幕的中间位置。",
	
	Font = "Fonts\\ZYKai_T.TTF",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Messages"] = "訊息",
	["Options for message display."] = "訊息框架選項",

	["BigWigs Anchor"] = "BigWigs 錨點",
	["Output Settings"] = "輸出設定",

	["Show anchor"] = "顯示錨點",
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "顯示訊息框架錨點",

	["Use colors"] = "發送彩色訊息",
	["Toggles white only messages ignoring coloring."] = "切換是否只發送單色訊息",

	["Scale"] = "縮放",
	["Set the message frame scale."] = "設定訊息框架縮放比例",

	["Use icons"] = "使用圖示",
	["Show icons next to messages, only works for Raid Warning."] = "顯示圖示，目前只能使用在團隊警告頻道。",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000顏|cffff00ff色|r",
	["White"] = "白色",

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "除了選擇的顯示位置外，也顯示在聊天頻道上。",

	["Chat frame"] = "聊天框架",

	["Test"] = "測試",
	["Close"] = "關閉",

	["Reset position"] = "重置位置",
	["Reset the anchor position, moving it to the center of your screen."] = "重置定位點，將它移至螢幕中央",
	
	Font = "Fonts\\bHEI01B.TTF"
} end)

L:RegisterTranslations("deDE", function() return {
	["Messages"] = "Nachrichten",
	["Options for message display."] = "Optionen für die Anzeige von Nachrichten.",

	["BigWigs Anchor"] = "BigWigs Verankerung",
	["Output Settings"] = "Ausgabeeinstellungen",

	["Show anchor"] = "Verankerung anzeigen",
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Die Verankerung des Nachrichtenfensters anzeigen.",

	["Use colors"] = "Farben verwenden",
	["Toggles white only messages ignoring coloring."] = "Nachrichten farbig/weiß anzeigen.",

	["Scale"] = "Skalierung",
	["Set the message frame scale."] = "Die Skalierung des Nachrichtenfensters festlegen.",

	["Use icons"] = "Icons benutzen",
	["Show icons next to messages, only works for Raid Warning."] = "Icons neben Nachrichten anzeigen.",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Fa|cffff00ffr|cff00ff00be|r",
	["White"] = "Weiß",

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Gibt alle BigsWigs-Nachrichten im Standard-Chatfenster aus, zusätzlich zur Anzeige-Einstellung.",

	["Chat frame"] = "Chatfenster",

	["Test"] = "Test",
	["Close"] = "Schließen",

	["Reset position"] = "Position zurücksetzen",
	["Reset the anchor position, moving it to the center of your screen."] = "Die Verankerungsposition zurücksetzen (bewegt alles zur Mitte deines Interfaces).",
	
	Font = "Fonts\\FRIZQT__.TTF",
} end)

L:RegisterTranslations("frFR", function() return {
	["Messages"] = "Messages",
	["Options for message display."] = "Options concernant l'affichage des messages.",

	["BigWigs Anchor"] = "Ancre de BigWigs",
	["Output Settings"] = "Paramètres de sortie",

	["Show anchor"] = "Afficher l'ancre",
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Affiche l'ancre du cadre des messages.\n\nNotez que l'ancre est uniquement utilisable si vous avez choisi 'BigWigs' comme Sortie.",

	["Use colors"] = "Utiliser des couleurs",
	["Toggles white only messages ignoring coloring."] = "Utilise ou non des couleurs dans les messages à la place du blanc unique.",

	["Scale"] = "Échelle",
	["Set the message frame scale."] = "Détermine l'échelle du cadre des messages.",

	["Use icons"] = "Utiliser les icônes",
	["Show icons next to messages, only works for Raid Warning."] = "Affiche les icônes à côté des messages. Ne fonctionne que sur l'Avertissement raid.",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Co|cffff00ffule|cff00ff00ur|r",
	["White"] = "Blanc",

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Affiche tous les messages de BigWigs dans la fenêtre de discussion par défaut, en plus de son affichage normal.",

	["Chat frame"] = "Fenêtre de discussion",

	["Test"] = "Test",
	["Close"] = "Fermer",

	["Reset position"] = "RÀZ position",
	["Reset the anchor position, moving it to the center of your screen."] = "Réinitialise la position de l'ancre, la replaçant au centre de l'écran.",
	
	Font = "Fonts\\FRIZQT__.TTF",
} end)

L:RegisterTranslations("esES", function() return {
	["Messages"] = "Mensajes",
	["Options for message display."] = "Opciones para mostrar mensajes.",

	["BigWigs Anchor"] = "Ancla de BigWigs",
	["Output Settings"] = "Parámetros de salida",
	
	["Show anchor"] = "Mostrar ancla",
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Mostrar la ventana del ancla de los mensajes.\n\nLa ventana de ancla es utilizable solo si seleccionas BigWigs como salida.",

	["Use colors"] = "Usar colores",
	["Toggles white only messages ignoring coloring."] = "Mostrar solo mensajes en blanco, ignorando colores.",

	["Scale"] = "Escala",
	["Set the message frame scale."] = "Establece la escala del mensaje.",

	["Use icons"] = "Usar iconos",
	["Show icons next to messages, only works for Raid Warning."] = "mostrar iconos al lado de los mensajes. Solo funciona para avisos de banda.",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Co|cffff00fflo|cff00ff00r|r",
	["White"] = "Blanco",

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Envía también a la ventana de chat por defecto todos los mensaje de BigWigs.",

	["Chat frame"] = "Ventana de chat",

	["Test"] = "Probar",
	["Close"] = "Cerrar",

	["Reset position"] = "Reiniciar posición",
	["Reset the anchor position, moving it to the center of your screen."] = "Reinicia la posición del ancla, moviéndola al centro de la pantalla.",
	
	Font = "Fonts\\FRIZQT__.TTF",
} end)
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["Messages"] = "Сообщения",
	["Options for message display."] = "Опции отображения сообщений",

	["BigWigs Anchor"] = "Якорь BigWigsа",
	["Output Settings"] = "Настройки вывода",

	["Show anchor"] = "Показать якорь",
	["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Отображение якоря сообщений\n\nЗамете что якорь если вы выбрали 'BigWigs' для вывода сообщений.",

	["Use colors"] = "Использовать цвета",
	["Toggles white only messages ignoring coloring."] = "Вкл/Выкл окраску игнорируемых сообщений, отображать белыми.",

	["Scale"] = "Масштаб",
	["Set the message frame scale."] = "Настройка масштаба фрейма сообщений.",

	["Use icons"] = "Использовать иконки",
	["Show icons next to messages, only works for Raid Warning."] = "Отображать иконки сообщений, работает только для объявлений рейда.",

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Co|cffff00fflo|cff00ff00r|r",
	["White"] = "Белый",

	["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Выводить все сообщения BigWigs в стандартное окно чата в дополнении с настройками отображения",

	["Chat frame"] = "Фрейм чата",

	["Test"] = "Тест",
	["Close"] = "Закрыть",

	["Reset position"] = "Сброс",
	["Reset the anchor position, moving it to the center of your screen."] = "Сброс позиции якоря, переместив его в центр вашего экрана.",

	Font = "Fonts\\NIM_____.ttf",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Messages")
local sink = LibStub("LibSink-2.0")
sink:Embed(plugin)

plugin.revision = tonumber(("$Revision$"):sub(12, -3))
plugin.defaultDB = {
	sink20OutputSink = "RaidWarning",
	usecolors = true,
	scale = 1.0,
	posx = nil,
	posy = -150,
	chat = nil,
	useicons = true,
}
plugin.consoleCmd = L["Messages"]

local function bwAnchorDisabled()
	return plugin.db.profile.sink20OutputSink ~= "BigWigs"
end

plugin.consoleOptions = {
	type = "group",
	name = L["Messages"],
	desc = L["Options for message display."],
	handler = plugin,
	pass = true,
	get = function(key)
		if key == "anchor" then
			return anchor and anchor:IsShown()
		else
			return plugin.db.profile[key]
		end
	end,
	set = function(key, val)
		if key == "anchor" then
			if val then
				plugin:BigWigs_ShowAnchors()
			else
				plugin:BigWigs_HideAnchors()
			end
		else
			plugin.db.profile[key] = val
		end
	end,
	args = {
		generalHeader = {
			type = "header",
			name = L["Output Settings"],
			order = 1,
		},
		chat = {
			type = "toggle",
			name = L["Chat frame"],
			desc = L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."],
			order = 101,
		},
		usecolors = {
			type = "toggle",
			name = L["Use colors"],
			desc = L["Toggles white only messages ignoring coloring."],
			map = {[true] = L["|cffff0000Co|cffff00fflo|cff00ff00r|r"], [false] = L["White"]},
			order = 102,
			disabled = function() return not colorModule end,
		},
		useicons = {
			type = "toggle",
			name = L["Use icons"],
			desc = L["Show icons next to messages, only works for Raid Warning."],
			order = 103,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 200,
		},
		bigWigsHeader = {
			type = "header",
			name = L["BigWigs Anchor"],
			order = 300,
		},
		anchor = {
			type = "toggle",
			name = L["Show anchor"],
			desc = L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."],
			disabled = bwAnchorDisabled,
			order = 400,
		},
		reset = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor position, moving it to the center of your screen."],
			func = "ResetAnchor",
			disabled = bwAnchorDisabled,
			order = 401,
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the message frame scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			disabled = bwAnchorDisabled,
			order = 402,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnRegister()
	self:SetSinkStorage(self.db.profile)

	self:RegisterSink("BigWigs", "BigWigs", nil, "Print")

	self.consoleOptions.args.output = self:GetSinkAce2OptionsDataTable().output
	self.consoleOptions.args.output.order = 100
end

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")

	if BigWigs:HasModule("Colors") then
		colorModule = BigWigs:GetModule("Colors")
	else
		colorModule = nil
	end

	if BigWigs:HasModule("Test") then
		testModule = BigWigs:GetModule("Test")
	else
		testModule = nil
	end
end

function plugin:OnDisable()
	self:BigWigs_HideAnchors()
end

local function createMsgFrame()
	if messageFrame then return end
	messageFrame = CreateFrame("MessageFrame", "BWMessageFrame", UIParent)
	messageFrame:SetWidth(512)
	messageFrame:SetHeight(80)

	if not anchor then plugin:SetupFrames() end
	messageFrame:SetPoint("TOP", anchor, "BOTTOM", 0, 0)
	messageFrame:SetScale(plugin.db.profile.scale or 1)
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
	if not anchor then self:SetupFrames() end
	anchor:Show()
end

function plugin:BigWigs_HideAnchors()
	if not anchor then return end
	anchor:Hide()
end

function plugin:Print(addon, text, r, g, b, _, _, _, _, _, icon)
	if not messageFrame then createMsgFrame() end
	messageFrame:SetScale(self.db.profile.scale)
	if icon then text = "|T"..icon..":20:20:-5|t"..text end
	messageFrame:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
end

function plugin:BigWigs_Message(text, color, noraidsay, sound, broadcastonly, icon)
	if broadcastonly or not text then return end

	local db = self.db.profile
	local r, g, b = 1, 1, 1 -- Default to white.
	if db.usecolors then
		if type(color) == "table" and type(color.r) == "number" and type(color.g) == "number" and type(color.b) == "number" then
			r, g, b = color.r, color.g, color.b
		elseif type(colorModule) == "table" and colorModule:HasMessageColor(color) then
			r, g, b = colorModule:MsgColor(color)
		elseif paint then
			r, g, b = select(2, paint:GetRGBPercent(color or "white"))
		end
	end

	if icon and db.useicons then
		local _, _, gsiIcon = GetSpellInfo(icon)
		icon = gsiIcon or icon
	else
		icon = nil
	end

	self:Pour(text, r, g, b, nil, nil, nil, nil, nil, icon)
	if db.chat then
		BigWigs:CustomPrint(r, g, b, nil, nil, nil, text)
	end
end

------------------------------
--    Anchor                --
------------------------------

function plugin:SetupFrames()
	if anchor then return end

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
	anchor:SetPoint("TOP", UIParent, "TOP", 0, -150)
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
	cheader:SetFont(L["Font"], 12)
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

	if not testModule then testbutton:Hide() end

	self:RestorePosition()
end

function plugin:ResetAnchor()
	if not anchor then self:SetupFrames() end

	anchor:ClearAllPoints()
	anchor:SetPoint("TOP", UIParent, "TOP", 0, -150)
	self.db.profile.posx = nil
	self.db.profile.posy = -150
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

