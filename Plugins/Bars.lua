assert( BigWigs, "BigWigs not found!")

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsBars")

local paint = AceLibrary("PaintChips-2.0")
local media = AceLibrary("SharedMedia-1.0")
local mType = media.MediaType and media.MediaType.STATUSBAR or "statusbar"

local colorModule = nil
local anchor = nil
local emphasizeAnchor = nil

local flashTimers = {}
local emphasizeTimers = {}
local moduleBars = {}

local movingBars = {}
local DURATION = 0.5
local _abs, _cos, _pi = math.abs, math.cos, math.pi

local new, del
do
	local cache = setmetatable({},{__mode='k'})
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

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Bars"] = true,
	["Emphasized Bars"] = true,

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

	["Emphasize"] = true,
	["Emphasize bars that are close to completion (<10sec) by moving them to a second anchor."] = true,

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
	["Set the bar scale."] = "Détermine la taille des barres.",

	["Grow upwards"] = "Ajouter vers le haut",
	["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre.",

	["Texture"] = "Texture",
	["Set the texture for the timer bars."] = "Détermine la texture des barres temporelles.",

	["Test"] = "Test",
	["Close"] = "Fermer",

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
	growup = false,
	scale = 1.0,
	texture = "BantoBar",

	posx = nil,
	posy = nil,

	emphasize = nil,
	emphasizeFlash = true,
	emphasizePosX = nil,
	emphasizePosY = nil,
	emphasizeScale = 1.0,

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
		emphasize = {
			type = "toggle",
			name = L["Emphasize"],
			desc = L["Emphasize bars that are close to completion (<10sec) by moving them to a second anchor."],
			order = 102,
			-- When AceConsole-2.0, Dewdrop and Waterfall-1.0 have been fixed,
			-- we need to provide proper options for emphasized bars.
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
		emphasizeScale = {
			type = "range",
			name = "Emphasize Scale",
			desc = "Set the emphasize bar scale.",
			min = 0.2,
			max = 2.0,
			step = 0.1,
			order = 104,
		},
		texture = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timer bars."],
			validate = media:List(mType),
			order = 105,
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

	if BigWigs:HasModule("Colors") then
		colorModule = BigWigs:GetModule("Colors")
	else
		colorModule = nil
	end
end

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

function plugin:Ace2_AddonDisabled(module)
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

	if self.db.profile.emphasize then
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
	local u = plugin.db.profile.growup
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
	if db.emphasize then
		-- If the bar is started at more than 11 seconds, it won't be emphasized
		-- right away, but if it's started at 11 or less, it will be.
		if time > 11 then
			if not emphasizeTimers[module] then emphasizeTimers[module] = {} end
			emphasizeTimers[module][id] = self:ScheduleEvent(self.EmphasizeBar, time - 10, self, module, id)
			if db.emphasizeFlash then
				if not flashTimers[module] then flashTimers[module] = {} end
				flashTimers[module][id] = self:ScheduleEvent(self.FlashBar, time - 10, self, module, id)
			end
			self:SetCandyBarScale(id, db.scale or 1)
		else
			-- Since it's 11 or less, just start it at the emphasized group
			-- right away.
			groupId = "BigWigsEmphasizedGroup"
			setupEmphasizedGroup()
			if db.emphasizeFlash then
				self:FlashBar(module, id)
			end
			self:SetCandyBarScale(id, db.emphasizeScale or 1)
		end
	else
		self:SetCandyBarScale(id, db.scale or 1)
	end
	-- When using the emphasize option, custom bar groups from the modules are
	-- not used when the bar reaches 10 seconds left, but moved to the
	-- emphasized group regardless of custom groups.
	if (not db.emphasize or (db.emphasize and time > 11)) and type(module.GetBarGroupId) == "function" then
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

function plugin:BigWigs_StopBar(module, text)
	if not text then return end
	local id = "BigWigsBar "..text

	if emphasizeTimers[module] and emphasizeTimers[module][id] then
		self:CancelScheduledEvent(emphasizeTimers[module][id])
		emphasizeTimers[module][id] = nil
	end
	if flashTimers[module] and flashTimers[module][id] then
		self:CancelScheduledEvent(flashTimers[module][id])
		flashTimers[module][id] = nil
	end

	self:UnregisterCandyBar(id)

	if moduleBars[module] then
		moduleBars[module][id] = nil
	end
end

-----------------------------------------------------------------------
--    Emphasized Background Flashing
-----------------------------------------------------------------------

local flashColors
local generateColors
do
	local function ColorGradient(perc, ...)
		if perc >= 1 then
			local r, g, b = select(select('#', ...) - 2, ...)
			return r, g, b
		elseif perc <= 0 then
			local r, g, b = ...
			return r, g, b
		end
		local num = select('#', ...) / 3
		local segment, relperc = math.modf(perc*(num-1))
		local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)
		return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
	end
	generateColors = function()
		flashColors = {}
		for i = 0.1, 1, 0.1 do
			local r, g, b = ColorGradient(i, 255,0,0, 0,0,0)
			local hex = string.format("%02x%02x%02x", r, g, b)
			paint:RegisterHex(hex) -- We have to do this because CandyBar fails silently on hex codes not registered with paintchips ...
			table.insert(flashColors, hex:lower()) -- hex:lower() because that's what PaintChips uses for the "name" .. wtf.
		end
	end
end

local flashBarUp, flashBarDown

local currentColor = {}
flashBarUp = function(id)
	if not currentColor[id] then currentColor[id] = 1 end
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
	-- Start flashing the bar
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
		
		local point, rframe, rpoint = self:GetCandyBarPoint(bar)
		local effscale = self:GetCandyBarEffectiveScale(bar)
		local centerX, centerY = self:GetCandyBarCenter(bar)
		local tempX, tempY = centerX*effscale, centerY*effscale
		
		tempX = CosineInterpolate(tempX, opt.targetX, 1 - ((stop - now) / DURATION) )
		tempY = CosineInterpolate(tempY, opt.targetY, 1 - ((stop - now) / DURATION) )
		scale = (opt.stopScale - opt.startScale) * (1 - ((stop - now) / DURATION))
		
		self:SetCandyBarScale(bar, scale + opt.startScale)
		effscale = self:GetCandyBarEffectiveScale(bar)
		self:SetCandyBarPoint(bar, point, rframe, rpoint, tempX/effscale, tempY/effscale)
	end

	if count == 0 then
		self:CancelScheduledEvent("BigWigsBarMover")
	end
end

function plugin:EmphasizeBar(module, id)
	setupEmphasizedGroup()

	if not self:IsEventScheduled("BigWigsBarMover") then
		self:ScheduleRepeatingEvent("BigWigsBarMover",self.UpdateBars,0,self)
	end

	local centerX, centerY = self:GetCandyBarCenter(id)
	local point, _, rpoint, xoffset, yoffset = self:GetCandyBarPoint(id)
	local offsetLeft, offsetTop, offsetBottom, _ = self:GetCandyBarOffsets(id)
	local effscale = self:GetCandyBarEffectiveScale(id)
	local db = plugin.db.profile
	
	self:UnregisterCandyBarWithGroup(id, "BigWigsGroup")
	self:SetCandyBarPoint(id, "CENTER", "UIParent", "BOTTOMLEFT", centerX, centerY)

	local targetX, targetY = self:GetCandyBarNextBarPointInGroup("BigWigsEmphasizedGroup")
	local u = db.growup
	local frameX = emphasizeAnchor:GetCenter()
	local frameY = u and emphasizeAnchor:GetTop() or emphasizeAnchor:GetBottom()
	local frameScale = emphasizeAnchor:GetEffectiveScale()

	local offsetY = u and centerY - offsetBottom or centerY - offsetTop
	
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

function plugin:SetupFrames(emphasize)
	if not emphasize and anchor then return end
	if emphasize and emphasizeAnchor then return end

	local frame = CreateFrame("Frame", emphasize and "BigWigsEmphasizedBarAnchor" or "BigWigsBarAnchor", UIParent)
	frame:Hide()

	frame:SetWidth(120)
	frame:SetHeight(80)
	
	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\BigWigs\\Textures\\otravi-semi-full-border", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})

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
		anchor:SetPoint("CENTER", UIParent, "CENTER")
		self.db.profile.posx = nil
		self.db.profile.posy = nil
	end

	if (not specific or specific == "reset" or specific == "emphasize") and self.db.profile.emphasize then
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

	if self.db.profile.emphasize then
		if not emphasizeAnchor then self:SetupFrames(true) end
		s = emphasizeAnchor:GetEffectiveScale()
		self.db.profile.emphasizePosX = emphasizeAnchor:GetLeft() * s
		self.db.profile.emphasizePosY = emphasizeAnchor:GetTop() * s
	end
end


