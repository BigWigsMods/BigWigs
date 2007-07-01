assert( BigWigs, "BigWigs not found!")

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsBars")

local paint = AceLibrary("PaintChips-2.0")
local media = AceLibrary("SharedMedia-1.0")
local mType = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
local dew = AceLibrary("Dewdrop-2.0")

local colorModule = nil
local anchor = nil
local emphasizeAnchor = nil

local DURATION = 0.5
local _abs, _cos, _pi = math.abs, math.cos, math.pi

local new, del
do
	local cache = setmetatable({},{__mode="k"})
	function new()
		local t = next(cache)
		if t then
			cache[t] = nil
			return t
		else
			return {}
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		cache[t] = true
		return nil
	end
end

local flashTimers = nil
local emphasizeTimers = nil
local moduleBars = nil
local movingBars = nil

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Bars"] = true,
	["Emphasized Bars"] = true,

	["Options for the timer bars."] = true,

	["Show anchor"] = true,
	["Show the bar anchor frame."] = true,

	["Enable menu"] = true,
	["Show the bar configuration menu on Alt-Rightclick.\n\nNote that when this option is enabled, you can no longer Alt-Click game world items beneath the bars."] = true,

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
	["Flash"] = true,
	["Flashes the background red for bars that are emphasized."] = true,
	["Move"] = true,
	["Move bars that are emphasized to a second anchor."] = true,
	["Set the scale for emphasized bars."] = true,

	["Reset position"] = true,
	["Reset the anchor position, moving it to the center of your screen."] = true,

	["Reverse"] = true,
	["Toggles if bars are reversed (fill up instead of emptying)."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Bars"] = "바",
	["Emphasized Bars"] = "강조 바",

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

	["Emphasize"] = "강조",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "만료에 가까워진 바를 강조합니다.(10초 이하).",

	["Enable"] = "사용",
	["Enables emphasizing bars."] = "바 강조를 사용합니다.",
	["Flash"] = "점멸",
	["Flashes the background red for bars that are emphasized."] = "강조된 바에 붉은색 배경을 점멸합니다.",
	["Move"] = "이동",
	["Move bars that are emphasized to a second anchor."] = "강조된 바를 두번째 고정위치로 이동합니다.",
	["Set the scale for emphasized bars."] = "강조된 바의 크기를 설정합니다.",

	["Reset position"] = "위치 초기화",
	["Reset the anchor position, moving it to the center of your screen."] = "화면의 중앙으로 고정위치를 초기화합니다.",

	["Reverse"] = "반전",
	["Toggles if bars are reversed (fill up instead of emptying)."] = "바의 반전을 전환합니다(채우기 혹은 비움).",
} end)

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	["Bars"] = "计时条",
	["Emphasized Bars"] = "醒目记时条",
	
	["Options for the timer bars."] = "计时条设置",

	["Show anchor"] = "显示计时条框体",
	["Show the bar anchor frame."] = "显示计时条框体，可以对其计时条进行移动。",

	["Enable menu"] = "菜单启用",
	["Show the bar configuration menu on Alt-Rightclick.\n\nNote that when this option is enabled, you can no longer Alt-Click game world items beneath the bars."] = "Alt+右击显示计时条设置菜单.\n\n备注:当设置被启用后,在计时条下方你不需要一直Alt+点击游戏世界物品.",
	
	["Scale"] = "缩放",
	["Set the bar scale."] = "调整计时条缩放比例。",

	["Grow upwards"] = "向上延伸",
	["Toggle bars grow upwards/downwards from anchor."] = "切换计时条向上/向下排列。",

	["Texture"] = "材质",
	["Set the texture for the timer bars."] = "为计时条设定材质",

	["Test"] = "测试",
	["Close"] = "关闭",

	["Emphasize"] = "醒目",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "高亮显示接近完成的计时条（小于10秒），同样要注意的是如果一个计时起始值小于15秒时会立刻被高亮显示.",
	
	["Enable"] = "启用",
	["Enables emphasizing bars."] = "启用醒目记时条",
	["Flash"] = "闪烁",
	["Flashes the background red for bars that are emphasized."] = "当记时条为醒目状态时,背景将红光闪烁.",
	["Move"] = "移动",
	["Move bars that are emphasized to a second anchor."] = "设置醒目记时条显示的位置.",
	["Set the scale for emphasized bars."] = "设置醒目记时条的比例.",

	["Reset position"] = "重置位置",
	["Reset the anchor position, moving it to the center of your screen."] = "重置计时条显示位置,移动到默认屏幕的中间位置。",

	["Reverse"] = "倒转",
	["Toggles if bars are reversed (fill up instead of emptying)."] = "切换记时条反向（记时条排列顺序反转）",
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
	["Emphasized Bars"] = "Barres en évidence",

	["Options for the timer bars."] = "Options concernant les barres temporelles.",

	["Show anchor"] = "Afficher l'ancre",
	["Show the bar anchor frame."] = "Affiche l'ancre du cadre des barres.",

	["Enable menu"] = "Activer le menu",
	["Show the bar configuration menu on Alt-Rightclick.\n\nNote that when this option is enabled, you can no longer Alt-Click game world items beneath the bars."] = "Affiche le menu de configuration des barres via un Alt-Clic droit.\n\nNotez qu'une fois cette option activée, vous ne pourrez plus faire de Alt-Clic sur ce qui se trouve sous les barres.",

	["Scale"] = "Taille",
	["Set the bar scale."] = "Détermine la taille des barres.",

	["Grow upwards"] = "Ajouter vers le haut",
	["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre.",

	["Texture"] = "Texture",
	["Set the texture for the timer bars."] = "Détermine la texture des barres temporelles.",

	["Test"] = "Test",
	["Close"] = "Fermer",

	["Emphasize"] = "Mise en évidence",
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "Met en évidence les barres proches de la fin (< 10 sec.). Les barres qui durent au total moins de 15 secondes seront directement mises en évidence.",

	["Enable"] = "Activer",
	["Enables emphasizing bars."] = "Active la mise en évidence des barres.",
	["Flash"] = "Clignoter",
	["Flashes the background red for bars that are emphasized."] = "Fais clignoter le fond rouge des barres mises en évidence.",
	["Move"] = "Déplacer",
	["Move bars that are emphasized to a second anchor."] = "Déplace les barres mises en évidence vers une seconde ancre.",
	["Set the scale for emphasized bars."] = "Détermine la taille des barres mises en évidence.",

	["Reset position"] = "RÀZ position",
	["Reset the anchor position, moving it to the center of your screen."] = "Réinitialise la position de l'ancre, la replaçant au centre de l'écran.",

	["Reverse"] = "Inverser",
	["Toggles if bars are reversed (fill up instead of emptying)."] = "Inverse ou non les barres (les remplir au lieu de les vider).",
} end)

-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

local plugin = BigWigs:NewModule("Bars", "CandyBar-2.0")
plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.defaultDB = {
	altclick = true,
	growup = false,
	scale = 1.0,
	texture = "BantoBar",

	posx = nil,
	posy = nil,

	emphasize = true,
	emphasizeMove = true,
	emphasizeFlash = true,
	emphasizePosX = nil,
	emphasizePosY = nil,
	emphasizeScale = 1.5,
	emphasizeGrowup = false,

	width = nil,
	height = nil,
	reverse = nil,
}
plugin.consoleCmd = L["Bars"]

local function getOption(key)
	if key == "anchor" then
		return anchor and anchor:IsShown()
	else
		return plugin.db.profile[key]
	end
end
local function setOption(key, value)
	if key == "anchor" then
		if value then
			plugin:BigWigs_ShowAnchors()
		else
			plugin:BigWigs_HideAnchors()
		end
	else
		plugin.db.profile[key] = value
	end
end
local function shouldDisableEmphasizeOption()
	return not plugin.db.profile.emphasize
end

plugin.consoleOptions = {
	type = "group",
	name = L["Bars"],
	desc = L["Options for the timer bars."],
	handler = plugin,
	args = {
		anchor = {
			type = "toggle",
			name = L["Show anchor"],
			desc = L["Show the bar anchor frame."],
			order = 1,
			get = getOption,
			set = setOption,
			passValue = "anchor",
		},
		reset = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor position, moving it to the center of your screen."],
			order = 2,
			func = "ResetAnchor",
		},
		altclick = {
			type = "toggle",
			name = L["Enable menu"],
			desc = L["Show the bar configuration menu on Alt-Rightclick.\n\nNote that when this option is enabled, you can no longer Alt-Click game world items beneath the bars."],
			order = 3,
			get = getOption,
			set = setOption,
			passValue = "altclick",
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
			get = getOption,
			set = setOption,
			passValue = "growup",
		},
		reverse = {
			type = "toggle",
			name = L["Reverse"],
			desc = L["Toggles if bars are reversed (fill up instead of emptying)."],
			order = 101,
			get = getOption,
			set = setOption,
			passValue = "reverse",
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the bar scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			order = 103,
			get = getOption,
			set = setOption,
			passValue = "scale",
		},
		texture = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timer bars."],
			validate = media:List(mType),
			order = 104,
			get = getOption,
			set = setOption,
			passValue = "texture",
		},
		spacer2 = {
			type = "header",
			name = " ",
			order = 200,
		},
		emphasize = {
			type = "group",
			name = L["Emphasize"],
			desc = L["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."],
			order = 201,
			args = {
				emphasize = {
					type = "toggle",
					name = L["Enable"],
					desc = L["Enables emphasizing bars."],
					get = getOption,
					set = setOption,
					passValue = "emphasize",
					order = 1,
				},
				flash = {
					type = "toggle",
					name = L["Flash"],
					desc = L["Flashes the background red for bars that are emphasized."],
					get = getOption,
					set = setOption,
					passValue = "emphasizeFlash",
					disabled = shouldDisableEmphasizeOption,
					order = 2,
				},
				move = {
					type = "toggle",
					name = L["Move"],
					desc = L["Move bars that are emphasized to a second anchor."],
					get = getOption,
					set = setOption,
					passValue = "emphasizeMove",
					disabled = shouldDisableEmphasizeOption,
					order = 3,
				},
				scale = {
					type = "range",
					name = L["Scale"],
					desc = L["Set the scale for emphasized bars."],
					min = 0.2,
					max = 2.0,
					step = 0.1,
					get = getOption,
					set = setOption,
					passValue = "emphasizeScale",
					disabled = function()
						if not plugin.db.profile.emphasizeMove then return true end
						return shouldDisableEmphasizeOption()
					end,
					order = 4,
				},
				growup = {
					type = "toggle",
					name = L["Grow upwards"],
					desc = L["Toggle bars grow upwards/downwards from anchor."],
					order = 5,
					get = getOption,
					set = setOption,
					passValue = "emphasizeGrowup",
					disabled = shouldDisableEmphasizeOption,
				},
			},
		},
	},
}

-----------------------------------------------------------------------
--      Initialization
-----------------------------------------------------------------------

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
	self:RegisterEvent("MODIFIER_STATE_CHANGED")

	if BigWigs:HasModule("Colors") then
		colorModule = BigWigs:GetModule("Colors")
	else
		colorModule = nil
	end

	flashTimers = new()
	emphasizeTimers = new()
	moduleBars = new()
	movingBars = new()
end

function plugin:OnDisable()
	self:BigWigs_HideAnchors()

	flashTimers = del(flashTimers)
	emphasizeTimers = del(emphasizeTimers)
	moduleBars = del(moduleBars)
	movingBars = del(movingBars)
end

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

function plugin:Ace2_AddonDisabled(module)
	if moduleBars[module] then
		if emphasizeTimers[module] then
			for k, v in pairs(emphasizeTimers[module]) do
				self:CancelScheduledEvent(v)
				emphasizeTimers[module][k] = nil
			end
		end

		if flashTimers[module] then
			for k, v in pairs(flashTimers[module]) do
				self:CancelScheduledEvent(v)
				flashTimers[module][k] = nil
			end
		end

		for k in pairs(moduleBars[module]) do
			if movingBars[k] then
				movingBars[k] = del(movingBars[k])
			end
			self:UnregisterCandyBar(k)
			moduleBars[module][k] = nil
		end

		if not next(movingBars) then
			self:CancelScheduledEvent("BigWigsBarMover")
		end
	end
end

function plugin:BigWigs_StopBar(module, text)
	if not text then return end
	if moduleBars[module] then
		local id = "BigWigsBar "..text

		if movingBars[id] then
			movingBars[id] = del(movingBars[id])
		end

		if not next(movingBars) then
			self:CancelScheduledEvent("BigWigsBarMover")
		end

		if emphasizeTimers[module] and emphasizeTimers[module][id] then
			self:CancelScheduledEvent(emphasizeTimers[module][id])
			emphasizeTimers[module][id] = nil
		end

		if flashTimers[module] and flashTimers[module][id] then
			self:CancelScheduledEvent(flashTimers[module][id])
			flashTimers[module][id] = nil
		end

		self:UnregisterCandyBar(id)
		moduleBars[module][id] = nil
	end
end

function plugin:BigWigs_ShowAnchors()
	if not anchor then self:SetupFrames() end
	anchor:Show()

	if self.db.profile.emphasize and self.db.profile.emphasizeMove then
		if not emphasizeAnchor then self:SetupFrames(true) end
		emphasizeAnchor:Show()
	end
end

function plugin:BigWigs_HideAnchors()
	if not anchor then return end
	anchor:Hide()
	if emphasizeAnchor then
		emphasizeAnchor:Hide()
	end
end

local function setupEmphasizedGroup()
	local u = plugin.db.profile.emphasizeGrowup
	plugin:RegisterCandyBarGroup("BigWigsEmphasizedGroup")
	if not emphasizeAnchor then plugin:SetupFrames(true) end
	plugin:SetCandyBarGroupPoint("BigWigsEmphasizedGroup", u and "BOTTOM" or "TOP", emphasizeAnchor, u and "TOP" or "BOTTOM", 0, 0)
	plugin:SetCandyBarGroupGrowth("BigWigsEmphasizedGroup", u)
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

	-- We really need to clean up in the mess that is colors right now, and
	-- possibly move away from PaintChips.
	local bc, balpha, txtc
	if type(colorModule) == "table" then
		if type(otherc) ~= "boolean" or not otherc then c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 = colorModule:BarColor(time) end
		bc, balpha, txtc = colorModule.db.profile.bgc, colorModule.db.profile.bga, colorModule.db.profile.txtc
	end

	if not moduleBars[module] then moduleBars[module] = {} end
	moduleBars[module][id] = true

	self:RegisterCandyBar(id, time, text, icon, c1, c2, c3, c4, c5, c6, c8, c9, c10)

	local db = self.db.profile

	local groupId = "BigWigsGroup"
	local scale = db.scale or 1
	if db.emphasize and (db.emphasizeMove or db.emphasizeFlash) then
		-- If the bar is started at more than 15 seconds, it won't be emphasized
		-- right away, but if it's started at 15 or less, it will be.
		if time > 15 then
			if db.emphasizeMove then
				if not emphasizeTimers[module] then emphasizeTimers[module] = {} end
				if emphasizeTimers[module][id] then self:CancelScheduledEvent(emphasizeTimers[module][id]) end
				emphasizeTimers[module][id] = "BigWigs-EmphasizeBar-" .. math.random()
				self:ScheduleEvent(emphasizeTimers[module][id], self.EmphasizeBar, time - 10, self, module, id)
			end
			if db.emphasizeFlash then
				if not flashTimers[module] then flashTimers[module] = {} end
				if flashTimers[module][id] then self:CancelScheduledEvent(flashTimers[module][id]) end
				flashTimers[module][id] = "BigWigs-FlashBar-" .. math.random()
				self:ScheduleEvent(flashTimers[module][id], self.FlashBar, time - 10, self, module, id)
			end
		else
			-- Since it's 15 or less, just start it at the emphasized group
			-- right away.
			if db.emphasizeMove then
				groupId = "BigWigsEmphasizedGroup"
				setupEmphasizedGroup()
				scale = db.emphasizeScale or 1
			end
			if db.emphasizeFlash then
				self:FlashBar(module, id)
			end
		end
	end

	self:SetCandyBarScale(id, scale)

	-- When using the emphasize option, custom bar groups from the modules are
	-- not used when the bar reaches 10 seconds left, but moved to the
	-- emphasized group regardless of custom groups.
	if groupId == "BigWigsGroup" and type(module.GetBarGroupId) == "function" then
		groupId = module:GetBarGroupId(text)
	end
	self:RegisterCandyBarWithGroup(id, groupId)

	self:SetCandyBarTexture(id, media:Fetch(mType, db.texture))
	if bc then self:SetCandyBarBackgroundColor(id, bc, balpha) end
	if txtc then self:SetCandyBarTextColor(id, txtc) end

	if type(db.width) == "number" then
		self:SetCandyBarWidth(id, db.width)
	end
	if type(db.height) == "number" then
		self:SetCandyBarHeight(id, db.height)
	end

	self:SetCandyBarFade(id, .5)
	if db.reverse then
		self:SetCandyBarReversed(id, db.reverse)
	end

	self:StartCandyBar(id, true)
end

-----------------------------------------------------------------------
--    Emphasized Background Flashing
-----------------------------------------------------------------------

local flashColors
local generateColors
do
	local function ColorGradient(perc, ...)
		if perc >= 1 then
			local r, g, b = select(select("#", ...) - 2, ...)
			return r, g, b
		elseif perc <= 0 then
			local r, g, b = ...
			return r, g, b
		end
		local num = select("#", ...) / 3
		local segment, relperc = math.modf(perc*(num-1))
		local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)
		return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
	end
	generateColors = function()
		flashColors = {}
		for i = 0.1, 1, 0.1 do
			local r, g, b = ColorGradient(i, 255,0,0, 0,0,0)
			local hex = ("%02x%02x%02x"):format(r, g, b)
			paint:RegisterHex(hex) -- We have to do this because CandyBar fails silently on hex codes not registered with paintchips ...
			table.insert(flashColors, hex:lower()) -- hex:lower() because that's what PaintChips uses for the "name" .. wtf.
		end
	end
end

local flashBarUp, flashBarDown

local currentColor = {}
flashBarUp = function(id)
	plugin:SetCandyBarBackgroundColor(id, flashColors[currentColor[id]], 0.5)
	if currentColor[id] == #flashColors then
		plugin:ScheduleRepeatingEvent(id, flashBarDown, 0.1, id)
		return
	end
	currentColor[id] = currentColor[id] + 1
end
flashBarDown = function(id)
	plugin:SetCandyBarBackgroundColor(id, flashColors[currentColor[id]], 0.5)
	if currentColor[id] == 1 then
		plugin:ScheduleRepeatingEvent(id, flashBarUp, 0.1, id)
		return
	end
	currentColor[id] = currentColor[id] - 1
end

function plugin:FlashBar(module, id)
	if not flashColors then generateColors() end
	if flashTimers[module] then flashTimers[module][id] = nil end
	-- Start flashing the bar
	currentColor[id] = 1
	self:ScheduleRepeatingEvent(id, flashBarUp, 0.1, id)
	self:ScheduleEvent(self.CancelScheduledEvent, 10, self, id)
end

-----------------------------------------------------------------------
--    Smooth Moving of Emphasized Bars
-----------------------------------------------------------------------

-- copied from PitBull_BarFader
local function CosineInterpolate(y1, y2, mu)
	local mu2 = (1-_cos(mu*_pi))/2
	return y1*(1-mu2)+y2*mu2
end

function plugin:UpdateBars()
	local now, count = GetTime(), 0

	for bar, opt in pairs(movingBars) do
		local stop, scale = opt.stop
		count = count + 1
		if stop < now then
			movingBars[bar] = del(movingBars[bar])
			self:RegisterCandyBarWithGroup(bar, "BigWigsEmphasizedGroup")
			self:SetCandyBarScale(bar, plugin.db.profile.emphasizeScale or 1)
			return
		end

		local centerX, centerY = self:GetCandyBarCenter(bar)
		if type(centerX) == "number" and type(centerY) == "number" then
			local effscale = self:GetCandyBarEffectiveScale(bar)
			local tempX, tempY = centerX*effscale, centerY*effscale

			tempX = CosineInterpolate(tempX, opt.targetX, 1 - ((stop - now) / DURATION) )
			tempY = CosineInterpolate(tempY, opt.targetY, 1 - ((stop - now) / DURATION) )
			scale = (opt.stopScale - opt.startScale) * (1 - ((stop - now) / DURATION))

			self:SetCandyBarScale(bar, scale + opt.startScale)
			effscale = self:GetCandyBarEffectiveScale(bar)

			local point, rframe, rpoint = self:GetCandyBarPoint(bar)
			self:SetCandyBarPoint(bar, point, rframe, rpoint, tempX/effscale, tempY/effscale)
		end
	end

	if count == 0 then
		self:CancelScheduledEvent("BigWigsBarMover")
	end
end

function plugin:EmphasizeBar(module, id)
	local centerX, centerY = self:GetCandyBarCenter(id)
	if type(centerX) ~= "number" or type(centerY) ~= "number" then return end

	if emphasizeTimers[module] then emphasizeTimers[module][id] = nil end

	setupEmphasizedGroup()

	if not self:IsEventScheduled("BigWigsBarMover") then
		self:ScheduleRepeatingEvent("BigWigsBarMover", self.UpdateBars, 0, self)
	end

	self:UnregisterCandyBarWithGroup(id, "BigWigsGroup")
	self:SetCandyBarPoint(id, "CENTER", "UIParent", "BOTTOMLEFT", centerX, centerY)

	local targetX, targetY = self:GetCandyBarNextBarPointInGroup("BigWigsEmphasizedGroup")

	local db = plugin.db.profile
	local u = db.emphasizeGrowup

	local offsetTop, offsetBottom = select(2, self:GetCandyBarOffsets(id))
	local offsetY = u and centerY - offsetBottom or centerY - offsetTop

	local frameX = emphasizeAnchor:GetCenter()
	local frameY = u and emphasizeAnchor:GetTop() or emphasizeAnchor:GetBottom()
	local frameScale = emphasizeAnchor:GetEffectiveScale()

	movingBars[id] = new()
	movingBars[id].stop = GetTime() + DURATION
	movingBars[id].targetX = (targetX * (UIParent:GetEffectiveScale() * db.emphasizeScale or 1)) + (frameX * frameScale)
	movingBars[id].targetY = (targetY * (UIParent:GetEffectiveScale() * db.emphasizeScale or 1)) + ((frameY + offsetY) * frameScale)
	movingBars[id].startScale = db.scale or 1
	movingBars[id].stopScale = db.emphasizeScale or 1
end

------------------------------
--    Create the Anchors    --
------------------------------

local anchorBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	edgeFile = "Interface\\AddOns\\BigWigs\\Textures\\otravi-semi-full-border", edgeSize = 32,
	insets = {left = 1, right = 1, top = 20, bottom = 1},
}
function plugin:SetupFrames(emphasize)
	if not emphasize and anchor then return end
	if emphasize and emphasizeAnchor then return end

	local frame = CreateFrame("Frame", emphasize and "BigWigsEmphasizedBarAnchor" or "BigWigsBarAnchor", UIParent)
	frame:Hide()

	frame:SetWidth(120)
	frame:SetHeight(80)

	frame:SetBackdrop(anchorBackdrop)

	frame:SetBackdropColor(24/255, 24/255, 24/255)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", function() this:StartMoving() end)
	frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SavePosition()
	end)

	local cheader = frame:CreateFontString(nil, "OVERLAY")
	cheader:ClearAllPoints()
	cheader:SetWidth(110)
	cheader:SetHeight(15)
	cheader:SetPoint("TOP", frame, "TOP", 0, -14)
	cheader:SetFont("Fonts\\FRIZQT__.TTF", 12)
	cheader:SetJustifyH("LEFT")
	cheader:SetText(emphasize and L["Emphasized Bars"] or L["Bars"])
	cheader:SetShadowOffset(.8, -.8)
	cheader:SetShadowColor(0, 0, 0, 1)

	local close = frame:CreateTexture(nil, "ARTWORK")
	close:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\otravi-close")
	close:SetTexCoord(0, .625, 0, .9333)

	close:SetWidth(20)
	close:SetHeight(14)
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -15)

	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( frame )
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetPoint("CENTER", close, "CENTER")
	closebutton:SetScript( "OnClick", function() self:BigWigs_HideAnchors() end )

	local testbutton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	testbutton:SetWidth(60)
	testbutton:SetHeight(25)
	testbutton:SetText(L["Test"])
	testbutton:SetPoint("CENTER", frame, "CENTER", 0, -16)
	testbutton:SetScript( "OnClick", function()  self:TriggerEvent("BigWigs_Test") end )

	if emphasize then
		emphasizeAnchor = frame

		local x = self.db.profile.emphasizePosX
		local y = self.db.profile.emphasizePosY
		if x and y then
			local scale = emphasizeAnchor:GetEffectiveScale()
			emphasizeAnchor:ClearAllPoints()
			emphasizeAnchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
		else
			self:ResetAnchor("emphasize")
		end

	else
		anchor = frame

		local x = self.db.profile.posx
		local y = self.db.profile.posy
		if x and y then
			local s = anchor:GetEffectiveScale()
			anchor:ClearAllPoints()
			anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
		else
			self:ResetAnchor("normal")
		end
	end
end

function plugin:ResetAnchor(specific)
	if not specific or specific == "reset" or specific == "normal" then
		if not anchor then self:SetupFrames() end
		anchor:ClearAllPoints()
		if self.db.profile.emphasize and self.db.profile.emphasizeMove then
			local y = (UIParent:GetHeight() / 4) * 1.3
			local scale = anchor:GetEffectiveScale()
			anchor:SetPoint("CENTER", UIParent, "CENTER", 0, y / scale)
		else
			anchor:SetPoint("CENTER", UIParent, "CENTER")
		end
		self.db.profile.posx = nil
		self.db.profile.posy = nil
	end

	if (not specific or specific == "reset" or specific == "emphasize") and self.db.profile.emphasize and self.db.profile.emphasizeMove then
		if not emphasizeAnchor then self:SetupFrames(true) end
		emphasizeAnchor:ClearAllPoints()
		emphasizeAnchor:SetPoint("CENTER", UIParent, "CENTER")
		self.db.profile.emphasizePosX = nil
		self.db.profile.emphasizePosY = nil
	end
end

function plugin:SavePosition()
	if not anchor then self:SetupFrames() end

	local s = anchor:GetEffectiveScale()
	self.db.profile.posx = anchor:GetLeft() * s
	self.db.profile.posy = anchor:GetTop() * s

	if self.db.profile.emphasize and self.db.profile.emphasizeMove then
		if not emphasizeAnchor then self:SetupFrames(true) end
		s = emphasizeAnchor:GetEffectiveScale()
		self.db.profile.emphasizePosX = emphasizeAnchor:GetLeft() * s
		self.db.profile.emphasizePosY = emphasizeAnchor:GetTop() * s
	end
end


-------------------------------
-- Alt+Click / Drag handling --
-------------------------------

local function feed()
	dew:FeedAceOptionsTable(plugin.consoleOptions)
end

local function onClickCandybar(barname,button)
	if button == "RightButton" then
		dew:Open(this,
			"children", feed,
			"cursorX", true,
			"cursorY", true
		)
	elseif button=="LeftButton" then
		if anchor and anchor:IsShown() then
			plugin:BigWigs_HideAnchors()
		else
			plugin:BigWigs_ShowAnchors()
		end
	end
end

function plugin:MODIFIER_STATE_CHANGED(key,state)
	if key == "ALT" and plugin.db.profile.altclick then
		for _,v in pairs(moduleBars) do
			for k in pairs(v) do
				self:SetCandyBarOnClick(k, state == 1 and onClickCandybar or nil)
			end
		end
	end
end

