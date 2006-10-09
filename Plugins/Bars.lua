
assert( BigWigs, "BigWigs not found!")


------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsBars")
local paint = AceLibrary("PaintChips-2.0")
local minscale, maxscale = 0.25, 2


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Bars"] = true,

	["bars"] = true,
	["anchor"] = true,
	["scale"] = true,
	["up"] = true,

	["Options for the timer bars."] = true,
	["Show the bar anchor frame."] = true,
	["Set the bar scale."] = true,
	["Group upwards"] = true,
	["Toggle bars grow upwards/downwards from anchor."] = true,

	["Timer bars"] = true,
	["Show anchor"] = true,
	["Grow bars upwards"] = true,
	["Scale"] = true,
	["Bar scale"] = true,

	["Bars now grow %2$s"] = true,
	["Scale is set to %2$s"] = true,

	["Up"] = true,
	["Down"] = true,
	
	["Test"] = true,
	["Close"] = true,

	["Texture"] = true,
	["Set the texture for the timerbars."] = true,

	["default"] = true,
	["smooth"] = true,
	["otravi"] = true,
	["Charcoal"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Bars"] = "바",

	["Options for the timer bars."] = "Timer 바 옵션 조정.",
	["Show the bar anchor frame."] = "바 위치 조정 프레임 보이기.",
	["Set the bar scale."] = "바 크기 조절.",
	["Group upwards"] = "바 위로 생성",
	["Toggle bars grow upwards/downwards from anchor."] = "바 표시 순서를 위/아래로 조정.",

	["Timer bars"] = "타이머 바",
	["Show anchor"] = "앵커 보이기",
	["Grow bars upwards"] = "바 위로 생성",
	["Scale"]= "크기",
	["Bar scale"] = "바 크기",
	["Bars now grow %2$s"] = "바 생성 방향 : %2$s",
	["Scale is set to %2$s"] = "크기 설정 : %2$s",
  
	["Up"] = "위",
	["Down"] = "아래",

	["Test"] = "테스트",

	["default"] = "Default",
	["smooth"] = "Smooth",
	["otravi"] = "Otravi",
	["Charcoal"] = "Charcoal",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Bars"] = "计时条",

	["Options for the timer bars."] = "计时条设置/",
	["Show the bar anchor frame."] = "显示计时条框体锚点。",
	["Set the bar scale."] = "设置计时条缩放比例。",
	["Group upwards"] = "向上排列",
	["Toggle bars grow upwards/downwards from anchor."] = "切换计时条从锚点向下/向上排列。",

	["Timer bars"] = "计时条",
	["Show anchor"] = "显示锚点",
	["Grow bars upwards"] = "向上延展",
	["Scale"] = "缩放",
	["Bar scale"] = "计时条缩放",

	["Bars now grow %2$s"] = "计时条设置为向%2$s延展。",
	["Scale is set to %2$s"] = "缩放比例设置为%2$s",

	["Up"] = "上",
	["Down"] = "下",
	["Texture"] = "材质",
	["default"] = "默认",
	["smooth"] = "平滑",
	["Charcoal"] = "Charcoal",
} end)

L:RegisterTranslations("deDE", function() return {
	["Bars"] = "Anzeigebalken",

	-- ["bars"] = true,
	-- ["anchor"] = true,
	-- ["scale"] = true,
	-- ["up"] = true,

	["Options for the timer bars."] = "Optionen f\195\188r die Timer Anzeigebalken.",
	["Show the bar anchor frame."] = "Zeige die Verankerung der Anzeigebalken.",
	["Set the bar scale."] = "W\195\164hle die Skalierung der Anzeigebalken.",
	["Group upwards"] = "Nach oben fortsetzen",
	["Toggle bars grow upwards/downwards from anchor."] = "Anzeigebalken von der Verankerung aus nach Oben/Unten fortsetzen.",

	["Timer bars"] = "Timer Anzeigebalken",
	["Show anchor"] = "Zeige Verankerung",
	["Grow bars upwards"] = "Anzeigebalken nach oben fortsetzen lassen",
	["Scale"] = "Skalierung",
	["Bar scale"] = "Anzeigebalken Skalierung",

	["Bars now grow %2$s"] = "Anzeigebalken werden nun fortgesetzt nach %2$s",
	["Scale is set to %2$s"] = "Skalierung jetzt %2$s",

	["Up"] = "Oben",
	["Down"] = "Unten",
	
	["Test"] = "Test",

	["default"] = "Default",
	["smooth"] = "Smooth",
	["otravi"] = "Otravi",
	["Charcoal"] = "Charcoal",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBars = BigWigs:NewModule(L"Bars")
BigWigsBars.revision = tonumber(string.sub("$Revision: 13134 $", 12, -3))
BigWigsBars.defaultDB = {
	growup = false,
	scale = 1.0,
	texture = L["default"],
}
BigWigsBars.consoleCmd = L["bars"]
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
			name = L["Group upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			get = function() return BigWigsBars.db.profile.growup end,
			set = function(v) BigWigsBars.db.profile.growup = v end,
			message = L["Bars now grow %2$s"],
			current = L["Bars now grow %2$s"],
			map = {[true] = L["Up"], [false] = L["Down"]},
		},
		[L["scale"]] = {
			type = "range",
			name = L["Bar scale"],
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
			desc = L["Set the texture for the timerbars."],
			get = function() return BigWigsBars.db.profile.texture end,
			set = function(v) BigWigsBars.db.profile.texture = v end,
			validate = { L["default"], L["otravi"], L["smooth"], L["Charcoal"] },
		}
	},
}


------------------------------
--      Initialization      --
------------------------------

function BigWigsBars:OnEnable()
	if not self.db.profile.texture then self.db.profile.texture = L["default"] end
	self:SetupFrames()
	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")
	self:RegisterEvent("BigWigs_StartBar")
	self:RegisterEvent("BigWigs_StopBar")
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBars:BigWigs_ShowAnchors()
	self.frames.anchor:Show()
end


function BigWigsBars:BigWigs_HideAnchors()
	self.frames.anchor:Hide()
end

function BigWigsBars:BigWigs_StartBar(module, text, time, icon, otherc, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	if not text or not time then return end
	local id = "BigWigsBar "..text
	local u = self.db.profile.growup

	-- yes we try and register every time, we also set the point every time since people can change their mind midbar.
	module:RegisterCandyBarGroup("BigWigsGroup")
	module:SetCandyBarGroupPoint("BigWigsGroup", u and "BOTTOM" or "TOP", self.frames.anchor, u and "TOP" or "BOTTOM", 0, 0)
	module:SetCandyBarGroupGrowth("BigWigsGroup", u)

	if type(otherc) ~= "boolean" or not otherc then c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 = BigWigsColors:BarColor(time) end
	local bc, balpha = BigWigsColors.db.profile.bgc, BigWigsColors.db.profile.bga
	local txtc = BigWigsColors.db.profile.txtc

 	module:RegisterCandyBar(id, time, text, icon, c1, c2, c3, c4, c5, c6, c8, c9, c10)
 	module:RegisterCandyBarWithGroup(id, "BigWigsGroup")
	local texture = "Interface\\AddOns\\BigWigs\\Textures\\" .. (L:HasReverseTranslation(self.db.profile.texture) and L:GetReverseTranslation( self.db.profile.texture ) or "default")
	module:SetCandyBarTexture( id, texture )
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
--      Slash Handlers      --
------------------------------

function BigWigsBars:SetScale(msg, supressreport)
	local scale = tonumber(msg)
	if scale and scale >= minscale and scale <= maxscale then
		self.db.profile.scale = scale
		if not supressreport then self.core:Print(L["Scale is set to %s"], scale) end
	end
end

function BigWigsBars:ToggleUp(supressreport)
	self.db.profile.growup = not self.db.profile.growup
	local t = self.db.profile.growup
	if not supressreport then self.core:Print(L["Bars now grow %s"], (t and L["Up"] or L["Down"])) end
end


------------------------------
--    Create the Anchor     --
------------------------------

function BigWigsBars:SetupFrames()
	local f, t	

	f, _, _ = GameFontNormal:GetFont()

	self.frames = {}
	self.frames.anchor = CreateFrame("Frame", "BigWigsBarAnchor", UIParent)
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
	self.frames.anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
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
	self.frames.cheader:SetText(L["Bars"])
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


function BigWigsBars:SavePosition()
	local f = self.frames.anchor
	local s = f:GetEffectiveScale()
		
	self.db.profile.posx = f:GetLeft() * s
	self.db.profile.posy = f:GetTop() * s	
end


function BigWigsBars:RestorePosition()
	local x = self.db.profile.posx
	local y = self.db.profile.posy
		
	if not x or not y then return end
				
	local f = self.frames.anchor
	local s = f:GetEffectiveScale()

	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
end
