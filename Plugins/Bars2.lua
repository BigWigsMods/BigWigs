--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:New("Bars 2", "$Revision$")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigsBars2")

local colors = nil
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local mType = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil

--------------------------------------------------------------------------------
-- Localization
--

L:RegisterTranslations("enUS", function() return {
	["Bars"] = true,
	["Emphasized Bars"] = true,
	["Options for the timer bars."] = true,
	["Toggle anchors"] = true,
	["Show or hide the bar anchors for both normal and emphasized bars."] = true,
	["Scale"] = true,
	["Set the bar scale."] = true,
	["Grow upwards"] = true,
	["Toggle bars grow upwards/downwards from anchor."] = true,
	["Texture"] = true,
	["Set the texture for the timer bars."] = true,
	["Test"] = true,
	["Close"] = true,
	["Emphasize"] = true,
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = true,
	["Enable"] = true,
	["Enables emphasizing bars."] = true,
	["Move"] = true,
	["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = true,
	["Set the scale for emphasized bars."] = true,
	["Reset position"] = true,
	["Reset the anchor positions, moving them to their default positions."] = true,
	["Test"] = true,
	["Creates a new test bar."] = true,
	["Hide"] = true,
	["Hides the anchors."] = true,
	["Flash"] = true,
	["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = true,
} end)

L:RegisterTranslations("ruRU", function() return {
	["Bars"] = "Полосы",
	["Emphasized Bars"] = "Увеличенные полосы",
	["Options for the timer bars."] = "Опции полос времени.",
	["Toggle anchors"] = "Переключение якоря",
	["Show or hide the bar anchors for both normal and emphasized bars."] = "Показать или скрыть якорь полосы для обычных и увеличенных полос.",
	["Scale"] = "Масштаб",
	["Set the bar scale."] = "Настройка масштаба полос.",
	["Grow upwards"] = "Рост вверх",
	["Toggle bars grow upwards/downwards from anchor."] = "Преключение роста полос от якоря вверх или вниз.",
	["Texture"] = "Текстуры",
	["Set the texture for the timer bars."] = "Установка текстур для полос времени.",
	["Test"] = "Тест",
	["Close"] = "Закрыть",
	["Emphasize"] = "Увеличение",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "Увеличение полос которые близятся к завершению (<10сек). Так же имейте ввиду что полосы продолжительностью менее 15 секунд буду увеличенные сразу.",
	["Enable"] = "Включить",
	["Enables emphasizing bars."] = "Включить увеличение полос.",
	["Move"] = "Перемещение",
	["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Перемещение увеличенных полос. Если эта опция отключена, увеличенные полосы просто можно будет изменить масштаб, окраску, и задать мигание.",
	["Set the scale for emphasized bars."] = "Установка масштаба увеличенных полос.",
	["Reset position"] = "Сброс позиции",
	["Reset the anchor positions, moving them to their default positions."] = "Сброс позиций якоря, вернув его в стандартное положение.",
	["Test"] = "Тест",
	["Creates a new test bar."] = "Создаёт новые тестовые полосы.",
	["Hide"] = "Скрыть",
	["Hides the anchors."] = "Скрыть якорь.",
	["Flash"] = "Мерцание",
	["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Мерцание фона увеличенных полос, что может подчеркнуть их заметность.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Bars"] = "计时条",
	["Emphasized Bars"] = "醒目计时条",
	["Options for the timer bars."] = "计时条选项。",
	["Toggle anchors"] = "切换锚点",
	["Show or hide the bar anchors for both normal and emphasized bars."] = "显示或隐藏计时条与醒目计时条锚点。",
	["Scale"] = "缩放",
	["Set the bar scale."] = "设置计时条缩放。",
	["Grow upwards"] = "向上成长",
	["Toggle bars grow upwards/downwards from anchor."] = "切换计时条在锚点向上或向下成长。",
	["Texture"] = "材质",
	["Set the texture for the timer bars."] = "设置计时条的材质。",
	["Test"] = "测试",
	["Close"] = "关闭",
	["Emphasize"] = "醒目",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "醒目计时条是当接近（小于10秒）。如果计时条开始时间小于15秒则会立刻醒目显示。",
	["Enable"] = "启用",
	["Enables emphasizing bars."] = "启用醒目计时条",
	["Move"] = "移动",
	["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "移动醒目计时条到醒目锚点。如果此选项关闭，醒目计时条将只改变缩放与颜色以及可能开始闪烁。",
	["Set the scale for emphasized bars."] = "设置醒目计时条缩放。",
	["Reset position"] = "重置位置",
	["Reset the anchor positions, moving them to their default positions."] = "重置锚点位置，移动它们到默认位置。",
	["Creates a new test bar."] = "新建测试计时条",
	["Hide"] = "隐藏",
	["Hides the anchors."] = "隐藏锚点",
	["Flash"] = "闪烁",
	["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "醒目计时条背景闪烁，方便你留意它。",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Bars"] = "計時條",
	["Emphasized Bars"] = "強調條",
	["Options for the timer bars."] = "計時條選項。",
	["Toggle anchors"] = "切換錨點",
	["Show or hide the bar anchors for both normal and emphasized bars."] = "顯示或隱藏計時條與強調條錨點。",
	["Scale"] = "縮放",
	["Set the bar scale."] = "設定計時條縮放。",
	["Grow upwards"] = "向上成長",
	["Toggle bars grow upwards/downwards from anchor."] = "切換計時條在錨點向上或向下成長。",
	["Texture"] = "材質",
	["Set the texture for the timer bars."] = "設定計時條的材質。",
	["Test"] = "測試",
	["Close"] = "關閉",
	["Emphasize"] = "強調",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "強調條是當接近（小於10秒）。如果計時條開始時間小於15秒則會立刻強調顯示。",
	["Enable"] = "啟用",
	["Enables emphasizing bars."] = "啟用強調條",
	["Move"] = "移動",
	["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "移動強調條到強調錨點。如果此選項關閉，強調條將只改變縮放與顏色以及可能開始閃爍。",
	["Set the scale for emphasized bars."] = "設定強調條縮放。",
	["Reset position"] = "重置位置",
	["Reset the anchor positions, moving them to their default positions."] = "重置錨點位置，移動它們到預設位置。",
	["Test"] = "測試",
	["Creates a new test bar."] = "新建測試計時條",
	["Hide"] = "隱藏",
	["Hides the anchors."] = "隱藏錨點",
	["Flash"] = "閃爍",
	["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "強調條背景閃爍，方便你留意它。",
} end)

L:RegisterTranslations("koKR", function() return {
	["Bars"] = "바",
	["Emphasized Bars"] = "강조 바",
	["Options for the timer bars."] = "타이머 바에 대한 설정입니다.",
	["Toggle anchors"] = "앵커 토글",
	["Show or hide the bar anchors for both normal and emphasized bars."] = "기본 바와 강조 바의 앵커를 숨기거나 표시합니다.",
	["Scale"] = "크기",
	["Set the bar scale."] = "바의 크기를 조절합니다.",
	["Grow upwards"] = "생성 방향",
	["Toggle bars grow upwards/downwards from anchor."] = "바의 생성 방향을 위/아래로 전환합니다.",
	["Texture"] = "텍스쳐",
	["Set the texture for the timer bars."] = "타이머 바의 텍스쳐를 설정합니다.",
	["Test"] = "테스트",
	["Close"] = "닫기",
	["Emphasize"] = "강조",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "만료에 가까워진 바를 강조합니다.(10초 이하).",
	["Enable"] = "사용",
	["Enables emphasizing bars."] = "강조 바를 사용합니다.",
	["Move"] = "이동",
	["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "강조 바를 두번째 고정위치로 이동합니다.",
	["Set the scale for emphasized bars."] = "강조 바의 크기를 설정합니다.",
	["Reset position"] = "위치 초기화",
	["Reset the anchor positions, moving them to their default positions."] = "화면의 중앙으로 고정위치를 초기화합니다.",
	["Test"] = "테스트",
	["Creates a new test bar."] = "새로운 테스트 바를 생성합니다.",
	["Hide"] = "숨김",
	["Hides the anchors."] = "앵커를 숨깁니다.",
	["Flash"] = "섬광",
	["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "강조 바에 붉은색 배경을 번쩍이게 합니다.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Bars"] = "Barres",
	["Emphasized Bars"] = "Barres en évidence",
	["Options for the timer bars."] = "Options concernant les barres temporelles.",
	["Show anchor"] = "Afficher l'ancre",
	["Show the bar anchors for both normal and emphasized bars."] = "Affiche l'ancre pour les barres normales et les barres en évidence.",
	["Scale"] = "Echelle",
	["Set the bar scale."] = "Détermine l'échelle des barres.",
	["Grow upwards"] = "Ajouter vers le haut",
	["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre.",
	["Texture"] = "Texture",
	["Set the texture for the timer bars."] = "Détermine la texture des barres temporelles.",
	["Test"] = "Test",
	["Close"] = "Fermer",
	["Emphasize"] = "Mise en évidence",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "Met en évidence les barres proches de la fin (< 10 sec.). Les barres d'une durée initiale de moins de 15 secondes seront directement mises en évidence.",
	["Enable"] = "Activer",
	["Enables emphasizing bars."] = "Active la mise en évidence des barres.",
	["Move"] = "Déplacer",
	["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Déplace les barres mises en évidence vers une ancre dédiée. Si cette option est désactivée, les barres mises en évidence vont simplement changer d'échelle et de couleur, et peut-être commencer à clignoter.",
	["Set the scale for emphasized bars."] = "Détermine l'échelle des barres mises en évidence.",
	["Reset position"] = "Réinit. la position",
	["Reset the anchor positions, moving them to their default positions."] = "Réinitialise la position des ancres, les déplaçant à leurs positions par défaut.",
	["Test"] = "Test",
	["Creates a new test bar."] = "Créé une nouvelle barre de test.",
	["Hide"] = "Cacher",
	["Hides the anchors."] = "Cacher les ancres",
	["Flash"] = "Clignoter",
	["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Fait clignoter l'arrière-plan des barres en évidence afin que vous puissiez mieux les voir.",
} end)

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	scale = 1.0,
	texture = "BantoBar",
	growup = true,
	emphasize = true,
	emphasizeFlash = true,
	emphasizeMove = true,
	emphasizeScale = 1.5,
	emphasizeGrowup = nil,
	BigWigsAnchor_width = 200,
	BigWigsEmphasizeAnchor_width = 300,
}

local function getOption(key) return plugin.db.profile[key] end
local function setOption(key, value) plugin.db.profile[key] = value end
local function shouldDisableEmphasizeOption() return not plugin.db.profile.emphasize end
plugin.consoleOptions = {
	type = "group",
	name = L["Bars"],
	desc = L["Options for the timer bars."],
	handler = plugin,
	pass = true,
	get = getOption,
	set = setOption,
	args = {
		anchor = {
			type = "execute",
			name = L["Toggle anchors"],
			desc = L["Show or hide the bar anchors for both normal and emphasized bars."],
			order = 1,
			func = "ShowAnchors",
		},
		reset = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor positions, moving them to their default positions."],
			order = 2,
			func = "ResetAnchors",
		},
		texture = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timer bars."],
			validate = media:List(mType),
			order = 3,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		normal_header = {
			type = "header",
			name = "Regular bars",
			order = 99,
		},
		growup = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			order = 100,
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the bar scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			order = 103,
		},
		spacer2 = {
			type = "header",
			name = " ",
			order = 200,
		},
		emp_header = {
			type = "header",
			name = "Emphasized bars",
			order = 299,
		},
		emphasize = {
			type = "toggle",
			name = L["Enable"],
			desc = L["Enables emphasizing bars."],
			order = 300,
		},
		emphasizeFlash = {
			type = "toggle",
			name = L["Flash"],
			desc = L["Flashes the background of emphasized bars, which could make it easier for you to spot them."],
			order = 301,
			disabled = shouldDisableEmphasizeOption,
		},
		emphasizeMove = {
			type = "toggle",
			name = L["Move"],
			desc = L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."],
			order = 302,
			disabled = shouldDisableEmphasizeOption,
		},
		emphasizeGrowup = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			order = 303,
			disabled = shouldDisableEmphasizeOption,
		},
		emphasizeScale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the scale for emphasized bars."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			disabled = shouldDisableEmphasizeOption,
			order = 304,
		},
	},
}

--------------------------------------------------------------------------------
-- Bar arrangement
--

local function barSorter(a, b)
	return a.remaining > b.remaining and true or false
end
local tmp = {}
local function rearrangeBars(anchor)
	wipe(tmp)
	for bar in pairs(anchor.bars) do
		table.insert(tmp, bar)
	end
	table.sort(tmp, barSorter)
	local lastBar = nil
	local up = anchor == normalAnchor and db.growup or db.emphasizeGrowup
	for i, bar in ipairs(tmp) do
		bar:ClearAllPoints()
		if up then
			bar:SetPoint("BOTTOMLEFT", lastBar or anchor, "TOPLEFT")
			bar:SetPoint("BOTTOMRIGHT", lastBar or anchor, "TOPRIGHT")
		else
			bar:SetPoint("TOPLEFT", lastBar or anchor, "BOTTOMLEFT")
			bar:SetPoint("TOPRIGHT", lastBar or anchor, "BOTTOMRIGHT")
		end
		lastBar = bar
	end
end

local function barStopped(event, bar)
	local a = bar:Get("anchor")
	if a and a.bars and a.bars[bar] then
		a.bars[bar] = nil
		rearrangeBars(a)
	end
end

--------------------------------------------------------------------------------
-- Anchors
--
local defaultPositions = {
	BigWigsAnchor = {"CENTER", "UIParent", "CENTER", 0, -50},
	BigWigsEmphasizeAnchor = {"CENTER", "UIParent", "CENTER", 0, 400},
}

local function onDragHandleMouseDown(self) self:GetParent():StartSizing("BOTTOMRIGHT") end
local function onDragHandleMouseUp(self, button) self:GetParent():StopMovingOrSizing() end
local function onResize(self, width)
	db[self.w] = width
	rearrangeBars(self)
end
local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

local function createAnchor(frameName, title)
	local display = CreateFrame("Frame", frameName, UIParent)
	local wKey, xKey, yKey = frameName .. "_width", frameName .. "_x", frameName .. "_y"
	display.w, display.x, display.y = wKey, xKey, yKey
	display:EnableMouse(true)
	display:SetMovable(true)
	display:SetResizable(true)
	display:RegisterForDrag("LeftButton")
	display:SetWidth(db[wKey] or 200)
	display:SetHeight(20)
	display:SetMinResize(80, 20)
	display:SetMaxResize(1920, 20)
	display:ClearAllPoints()
	if db[xKey] and db[yKey] then
		local s = display:GetEffectiveScale()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db[xKey] / s, db[yKey] / s)
	else
		display:SetPoint(unpack(defaultPositions[frameName]))
	end
	local bg = display:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
	local header = display:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontNormal)
	header:SetText(title)
	header:SetAllPoints(display)
	header:SetJustifyH("CENTER")
	header:SetJustifyV("MIDDLE")
	local drag = CreateFrame("Frame", nil, display)
	drag:SetFrameLevel(display:GetFrameLevel() + 10)
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", onDragHandleMouseDown)
	drag:SetScript("OnMouseUp", onDragHandleMouseUp)
	drag:SetAlpha(0.5)
	local tex = drag:CreateTexture(nil, "BACKGROUND")
	tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)
	local test = CreateFrame("Button", nil, display)
	test:SetPoint("BOTTOMLEFT", display, "BOTTOMLEFT", 3, 3)
	test:SetHeight(14)
	test:SetWidth(14)
	test.tooltipHeader = L["Test"]
	test.tooltipText = L["Creates a new test bar."]
	test:SetScript("OnEnter", onControlEnter)
	test:SetScript("OnLeave", onControlLeave)
	test:SetScript("OnClick", function() plugin:TriggerEvent("BigWigs_Test") end)
	test:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\test")
	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMLEFT", test, "BOTTOMRIGHT", 4, 0)
	close:SetHeight(14)
	close:SetWidth(14)
	close.tooltipHeader = L["Hide"]
	close.tooltipText = L["Hides the anchors."]
	close:SetScript("OnEnter", onControlEnter)
	close:SetScript("OnLeave", onControlLeave)
	close:SetScript("OnClick", function() plugin:ShowAnchors() end)
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
	display:SetScript("OnSizeChanged", onResize)
	display:SetScript("OnDragStart", onDragStart)
	display:SetScript("OnDragStop", onDragStop)
	display:SetScript("OnMouseDown", displayOnMouseDown)
	display.bars = {}
	display:Hide()
	return display
end

function plugin:ShowAnchors()
	if normalAnchor:IsShown() then
		normalAnchor:Hide()
		emphasizeAnchor:Hide()
	else
		normalAnchor:Show()
		emphasizeAnchor:Show()
	end
end

function plugin:ResetAnchors()
	normalAnchor:ClearAllPoints()
	normalAnchor:SetPoint(unpack(defaultPositions[normalAnchor:GetName()]))
	db[normalAnchor.x] = nil
	db[normalAnchor.y] = nil
	db[normalAnchor.w] = nil
	normalAnchor:SetWidth(self.defaultDB[normalAnchor.w])
	emphasizeAnchor:ClearAllPoints()
	emphasizeAnchor:SetPoint(unpack(defaultPositions[emphasizeAnchor:GetName()]))
	db[emphasizeAnchor.x] = nil
	db[emphasizeAnchor.y] = nil
	db[emphasizeAnchor.w] = nil
	emphasizeAnchor:SetWidth(self.defaultDB[emphasizeAnchor.w])
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	media:Register(mType, "Otravi", "Interface\\AddOns\\BigWigs\\Textures\\otravi")
	media:Register(mType, "Smooth", "Interface\\AddOns\\BigWigs\\Textures\\smooth")
	media:Register(mType, "Glaze", "Interface\\AddOns\\BigWigs\\Textures\\glaze")
	media:Register(mType, "Charcoal", "Interface\\AddOns\\BigWigs\\Textures\\Charcoal")
	media:Register(mType, "BantoBar", "Interface\\AddOns\\BigWigs\\Textures\\default")
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)
	
	db = self.db.profile
	normalAnchor = createAnchor("BigWigsAnchor", "Normal Bars")
	emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", "Emphasized Bars")
end

function plugin:OnEnable()
	if not media:Fetch(mType, db.texture, true) then db.texture = "BantoBar" end
	self:RegisterEvent("BigWigs_StartBar")
	self:RegisterEvent("BigWigs_StopBar")
	self:RegisterEvent("Ace2_AddonDisabled")
	colors = BigWigs:GetModule("Colors")
end

--------------------------------------------------------------------------------
-- Colors
--

local function colorNormal() return unpack(colors.db.profile.barColor) end
local function colorEmphasized() return unpack(colors.db.profile.barEmphasized) end
local function colorText() return unpack(colors.db.profile.barText) end
local function colorBackground() return unpack(colors.db.profile.barBackground) end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function stopBars(bars, module, text)
	local dirty = nil
	for k in pairs(bars) do
		if k:Get("module") == module and (not text or k.candyBarLabel:GetText() == text) then
			k:Stop()
			dirty = true
		end
	end
	return dirty
end

local function stop(module, text)
	local d = stopBars(normalAnchor.bars, module, text)
	if d then rearrangeBars(normalAnchor) end
	d = stopBars(emphasizeAnchor.bars, module, text)
	if d then rearrangeBars(emphasizeAnchor) end
end

function plugin:Ace2_AddonDisabled(module) stop(module) end
function plugin:BigWigs_StopBar(module, text) stop(module, text) end

do
	local f = CreateFrame("Frame")
	local total = 0
	f:SetScript("OnUpdate", function(self, elapsed)
		local dirty = nil
		for k in pairs(normalAnchor.bars) do
			if not k:Get("emphasized") and k.remaining <= 10 then
				plugin:EmphasizeBar(k)
				dirty = true
			end
		end
		if dirty then
			rearrangeBars(normalAnchor)
			rearrangeBars(emphasizeAnchor)
		end
	end)
end

function plugin:BigWigs_StartBar(module, text, time, icon)
	stop(module, text)
	local bar = candy:New(media:Fetch(mType, db.texture), 200, 14)
	normalAnchor.bars[bar] = true
	bar.candyBarBackground:SetVertexColor(colorBackground())
	bar:Set("module", module)
	bar:Set("anchor", normalAnchor)
	bar:SetColor(colorNormal())
	bar.candyBarLabel:SetTextColor(colorText())
	bar:SetLabel(text)
	bar:SetDuration(time)
	bar:SetTimeVisibility(true)
	bar:SetIcon(icon)
	bar:SetScale(db.scale)
	if db.emphasize and time < 15 then
		self:EmphasizeBar(bar)
	end
	bar:Start()
	rearrangeBars(bar:Get("anchor"))
end

--------------------------------------------------------------------------------
-- Emphasize
--

local function flash(self)
	local r, g, b, a = self.candyBarBackground:GetVertexColor()
	if self:Get("down") then
		r = r - 0.05
		if r <= 0 then self:Set("down", nil) end
	else
		r = r + 0.05
		if r >= 1 then self:Set("down", true) end
	end
	self.candyBarBackground:SetVertexColor(r, g, b, a)
end

function plugin:EmphasizeBar(bar)
	if db.emphasizeMove then
		normalAnchor.bars[bar] = nil
		emphasizeAnchor.bars[bar] = true
		bar:Set("anchor", emphasizeAnchor)
	end
	if db.emphasizeFlash then
		bar:AddUpdateFunction(flash)
	end
	bar:SetColor(colorEmphasized())
	bar:SetScale(db.emphasizeScale)
	bar:Set("emphasized", true)
end

