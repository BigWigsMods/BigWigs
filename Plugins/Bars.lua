--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Bars")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = "|cff" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. key .. "|r"
			return self[key]
		end
	})
end

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

local AceGUI = nil

local colors = nil
local superemp = nil
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local empUpdate = nil -- emphasize updater frame

--- custom bar locals
local times = nil
local messages = nil
local timers = nil

local clickHandlers = {}

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	scale = 1.0,
	texture = "BantoBar",
	font = "Friz Quadrata TT",
	growup = true,
	time = true,
	align = "LEFT",
	icon = true,
	emphasize = true,
	emphasizeFlash = true,
	emphasizeMove = true,
	emphasizeScale = 1.5,
	emphasizeGrowup = nil,
	BigWigsAnchor_width = 200,
	BigWigsEmphasizeAnchor_width = 300,
	interceptMouse = nil,
	LeftButton = {
		report = true,
	},
	MiddleButton = {
		remove = true,
	},
	RightButton = {
		emphasize = true,
	},
}

local clickOptions = {
	emphasize = {
		type = "toggle",
		name = colorize[L["Super Emphasize"]],
		desc = L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."],
		descStyle = "inline",
		order = 1,
	},
	report = {
		type = "toggle",
		name = colorize[L["Report"]],
		desc = L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."],
		descStyle = "inline",
		order = 2,
	},
	remove = {
		type = "toggle",
		name = colorize[L["Remove"]],
		desc = L["Temporarily removes the bar and all associated messages."],
		descStyle = "inline",
		order = 3,
	},
	removeOther = {
		type = "toggle",
		name = colorize[L["Remove other"]],
		desc = L["Temporarily removes all other bars (except this one) and associated messages."],
		descStyle = "inline",
		order = 4,
	},
	disable = {
		type = "toggle",
		name = colorize[L["Disable"]],
		desc = L["Permanently disables the boss encounter ability option that spawned this bar."],
		descStyle = "inline",
		order = 5,
	},
}

local function shouldDisable() return not plugin.db.profile.interceptMouse end

plugin.subPanelOptions = {
	key = "Big Wigs: Clickable Bars",
	name = L["Clickable Bars"],
	options = {
		name = L["Clickable Bars"],
		type = "group",
		childGroups = "tab",
		args = {
			heading = {
				type = "description",
				name = L.clickableBarsDesc,
				order = 1,
				width = "full",
				fontSize = "medium",
			},
			interceptMouse = {
				type = "toggle",
				name = colorize[L["Enable"]],
				desc = L["Enables bars to receive mouse clicks."],
				order = 2,
				width = "full",
				get = function() return plugin.db.profile.interceptMouse end,
				set = function(_, value) plugin.db.profile.interceptMouse = value end,
			},
			left = {
				type = "group",
				name = KEY_BUTTON1 or "Left",
				order = 10,
				args = clickOptions,
				disabled = shouldDisable,
				get = function(info) return plugin.db.profile.LeftButton[info[#info]] end,
				set = function(info, value) plugin.db.profile.LeftButton[info[#info]] = value end,
			},
			middle = {
				type = "group",
				name = KEY_BUTTON3 or "Middle",
				order = 11,
				args = clickOptions,
				disabled = shouldDisable,
				get = function(info) return plugin.db.profile.MiddleButton[info[#info]] end,
				set = function(info, value) plugin.db.profile.MiddleButton[info[#info]] = value end,
			},
			right = {
				type = "group",
				name = KEY_BUTTON2 or "Right",
				order = 12,
				args = clickOptions,
				disabled = shouldDisable,
				get = function(info) return plugin.db.profile.RightButton[info[#info]] end,
				set = function(info, value) plugin.db.profile.RightButton[info[#info]] = value end,
			},
		},
	},
}

--------------------------------------------------------------------------------
-- Bar arrangement
--

local function barSorter(a, b)
	return a.remaining < b.remaining and true or false
end
local tmp = {}
local function rearrangeBars(anchor)
	wipe(tmp)
	for bar in pairs(anchor.bars) do
		tmp[#tmp + 1] = bar
	end
	table.sort(tmp, barSorter)
	local lastDownBar, lastUpBar = nil, nil
	local up = nil
	if anchor == normalAnchor then up = db.growup else up = db.emphasizeGrowup end
	for i, bar in next, tmp do
		bar:ClearAllPoints()
		if up or (db.emphasizeGrowup and bar:Get("bigwigs:emphasized")) then
			bar:SetPoint("BOTTOMLEFT", lastUpBar or anchor, "TOPLEFT")
			bar:SetPoint("BOTTOMRIGHT", lastUpBar or anchor, "TOPRIGHT")
			lastUpBar = bar
		else
			bar:SetPoint("TOPLEFT", lastDownBar or anchor, "BOTTOMLEFT")
			bar:SetPoint("TOPRIGHT", lastDownBar or anchor, "BOTTOMRIGHT")
			lastDownBar = bar
		end
	end
	if anchor == normalAnchor then -- only show the empupdater when there are bars on the normal anchor running
		if #tmp > 0 and db.emphasize then
			empUpdate:Show()
		else
			empUpdate:Hide()
		end
	end
end

local function barStopped(event, bar)
	local a = bar:Get("bigwigs:anchor")
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
	BigWigsEmphasizeAnchor = {"TOP", RaidWarningFrame, "BOTTOM", 0, -35}, --Below the default BigWigs message frame
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
	display:SetClampedToScreen(true)
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
	display.background = bg
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
	display:SetScript("OnSizeChanged", onResize)
	display:SetScript("OnDragStart", onDragStart)
	display:SetScript("OnDragStop", onDragStop)
	display:SetScript("OnMouseUp", function(self, button)
		if button ~= "LeftButton" then return end
		plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
	end)
	display.bars = {}
	display:Hide()
	return display
end

local function createAnchors()
	if not normalAnchor then
		normalAnchor = createAnchor("BigWigsAnchor", L["Regular bars"])
		emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", L["Emphasized bars"])
	end
end

local function showAnchors()
	if not normalAnchor then createAnchors() end
	normalAnchor:Show()
	emphasizeAnchor:Show()
end

local function hideAnchors()
	normalAnchor:Hide()
	emphasizeAnchor:Hide()
end

local function resetAnchors()
	normalAnchor:ClearAllPoints()
	normalAnchor:SetPoint(unpack(defaultPositions[normalAnchor:GetName()]))
	db[normalAnchor.x] = nil
	db[normalAnchor.y] = nil
	db[normalAnchor.w] = nil
	normalAnchor:SetWidth(plugin.defaultDB[normalAnchor.w])
	emphasizeAnchor:ClearAllPoints()
	emphasizeAnchor:SetPoint(unpack(defaultPositions[emphasizeAnchor:GetName()]))
	db[emphasizeAnchor.x] = nil
	db[emphasizeAnchor.y] = nil
	db[emphasizeAnchor.w] = nil
	emphasizeAnchor:SetWidth(plugin.defaultDB[emphasizeAnchor.w])
end

local function updateAnchor(anchor)
	local frameName = anchor:GetName()
	local wKey, xKey, yKey = frameName .. "_width", frameName .. "_x", frameName .. "_y"
	anchor.w, anchor.x, anchor.y = wKey, xKey, yKey
	if db[xKey] and db[yKey] then
		local s = anchor:GetEffectiveScale()
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db[xKey] / s, db[yKey] / s)
	else
		anchor:SetPoint(unpack(defaultPositions[frameName]))
	end
	anchor:SetWidth(db[wKey] or 200)
end

local function updateProfile()
	db = plugin.db.profile
	if normalAnchor then
		updateAnchor(normalAnchor)
		updateAnchor(emphasizeAnchor)
	end
end

--------------------------------------------------------------------------------
-- Initialization
--
function plugin:OnRegister()
	media:Register("statusbar", "Otravi", "Interface\\AddOns\\BigWigs\\Textures\\otravi")
	media:Register("statusbar", "Smooth", "Interface\\AddOns\\BigWigs\\Textures\\smooth")
	media:Register("statusbar", "Glaze", "Interface\\AddOns\\BigWigs\\Textures\\glaze")
	media:Register("statusbar", "Charcoal", "Interface\\AddOns\\BigWigs\\Textures\\Charcoal")
	media:Register("statusbar", "BantoBar", "Interface\\AddOns\\BigWigs\\Textures\\default")
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)

	db = self.db.profile
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
end

function plugin:OnPluginEnable()
	times = times or {}
	messages = messages or {}
	timers = timers or {}

	colors = BigWigs:GetPlugin("Colors")
	superemp = BigWigs:GetPlugin("Super Emphasize", true)

	if not media:Fetch("statusbar", db.texture, true) then db.texture = "BantoBar" end
	self:RegisterMessage("BigWigs_StartBar")
	self:RegisterMessage("BigWigs_StopBar")
	self:RegisterMessage("BigWigs_StopBars", "BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnPluginDisable", "BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchors)
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	self:RegisterMessage("BigWigs_SuperEmphasizeStart")

	--  custom bars
	BigWigs:AddSyncListener(self, "BWCustomBar")
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		normalAnchor.background:SetTexture(0.2, 1, 0.2, 0.3)
		emphasizeAnchor.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		normalAnchor.background:SetTexture(0, 0, 0, 0.3)
		emphasizeAnchor.background:SetTexture(0, 0, 0, 0.3)
	end
end

do
	local function onControlEnter(widget, event, value)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR")
		GameTooltip:AddLine(widget.text and widget.text:GetText() or widget.label:GetText())
		GameTooltip:AddLine(widget:GetUserData("tooltip"), 1, 1, 1, 1)
		GameTooltip:Show()
	end
	local function onControlLeave() GameTooltip:Hide() end

	local function standardCallback(widget, event, value)
		local key = widget:GetUserData("key")
		db[key] = value
	end

	local function dropdownCallback(widget, event, value)
		local list = media:List(widget:GetUserData("type"))
		db[widget:GetUserData("key")] = list[value]
	end

	function plugin:GetPluginConfig()
		if not AceGUI then AceGUI = LibStub("AceGUI-3.0") end
		local tex = AceGUI:Create("Dropdown")
		do
			local list = media:List("statusbar")
			local selected = nil
			for k, v in pairs(list) do
				if v == db.texture then
					selected = k
					break
				end
			end
			tex:SetList(list)
			tex:SetValue(selected)
			tex:SetLabel(L["Texture"])
			tex:SetUserData("type", "statusbar")
			tex:SetUserData("key", "texture")
			tex:SetCallback("OnValueChanged", dropdownCallback)
			tex:SetFullWidth(true)
		end

		local font = AceGUI:Create("Dropdown")
		do
			local list = media:List("font")
			local selected = nil
			for k, v in pairs(list) do
				if v == db.font then
					selected = k
					break
				end
			end
			font:SetList(list)
			font:SetValue(selected)
			font:SetLabel(L["Font"])
			font:SetUserData("type", "font")
			font:SetUserData("key", "font")
			font:SetCallback("OnValueChanged", dropdownCallback)
			font:SetFullWidth(true)
		end

		local align = AceGUI:Create("InlineGroup")
		align:SetTitle(L["Align"])
		align:SetFullWidth(true)
		align:SetLayout("Flow")

		do
			local left = AceGUI:Create("CheckBox")
			local center = AceGUI:Create("CheckBox")
			local right = AceGUI:Create("CheckBox")

			local function set(widget, event, value)
				db.align = widget:GetUserData("value")
				left:SetValue(db.align == "LEFT")
				center:SetValue(db.align == "CENTER")
				right:SetValue(db.align == "RIGHT")
			end

			left:SetValue(db.align == "LEFT")
			left:SetUserData("value", "LEFT")
			left:SetType("radio")
			left:SetLabel(L["Left"])
			left:SetCallback("OnValueChanged", set)
			left:SetRelativeWidth(0.33)

			center:SetValue(db.align == "CENTER")
			center:SetUserData("value", "CENTER")
			center:SetType("radio")
			center:SetLabel(L["Center"])
			center:SetCallback("OnValueChanged", set)
			center:SetRelativeWidth(0.33)

			right:SetValue(db.align == "RIGHT")
			right:SetUserData("value", "RIGHT")
			right:SetType("radio")
			right:SetLabel(L["Right"])
			right:SetCallback("OnValueChanged", set)
			right:SetRelativeWidth(0.33)

			align:AddChildren(left, center, right)
		end

		local icon = AceGUI:Create("CheckBox")
		icon:SetValue(db.icon)
		icon:SetLabel(L["Icon"])
		icon:SetUserData("key", "icon")
		icon:SetCallback("OnValueChanged", standardCallback)
		icon:SetUserData("tooltip", L["Shows or hides the bar icons."])
		icon:SetCallback("OnEnter", onControlEnter)
		icon:SetCallback("OnLeave", onControlLeave)
		icon:SetFullWidth(true)

		local duration = AceGUI:Create("CheckBox")
		duration:SetValue(db.time)
		duration:SetLabel(L["Time"])
		duration:SetUserData("key", "time")
		duration:SetCallback("OnValueChanged", standardCallback)
		duration:SetUserData("tooltip", L["Whether to show or hide the time left on the bars."])
		duration:SetCallback("OnEnter", onControlEnter)
		duration:SetCallback("OnLeave", onControlLeave)
		duration:SetFullWidth(true)

		local normal = AceGUI:Create("InlineGroup")
		normal:SetTitle(L["Regular bars"])
		normal:SetFullWidth(true)

		do
			local growup = AceGUI:Create("CheckBox")
			growup:SetValue(db.growup)
			growup:SetLabel(L["Grow upwards"])
			growup:SetUserData("key", "growup")
			growup:SetCallback("OnValueChanged", standardCallback)
			growup:SetUserData("tooltip", L["Toggle bars grow upwards/downwards from anchor."])
			growup:SetCallback("OnEnter", onControlEnter)
			growup:SetCallback("OnLeave", onControlLeave)
			growup:SetFullWidth(true)

			local scale = AceGUI:Create("Slider")
			scale:SetValue(db.scale)
			scale:SetSliderValues(0.2, 2.0, 0.1)
			scale:SetLabel(L["Scale"])
			scale:SetUserData("key", "scale")
			scale:SetCallback("OnValueChanged", standardCallback)
			scale:SetFullWidth(true)
			normal:AddChildren(growup, scale)
		end

		local emphasize = AceGUI:Create("InlineGroup")
		emphasize:SetTitle(L["Emphasized bars"])
		emphasize:SetFullWidth(true)

		do
			local enable = AceGUI:Create("CheckBox")
			enable:SetValue(db.emphasize)
			enable:SetLabel(L["Enable"])
			enable:SetUserData("key", "emphasize")
			enable:SetCallback("OnValueChanged", standardCallback)
			enable:SetFullWidth(true)

			local flash = AceGUI:Create("CheckBox")
			flash:SetValue(db.emphasizeFlash)
			flash:SetLabel(L["Flash"])
			flash:SetUserData("key", "emphasizeFlash")
			flash:SetCallback("OnValueChanged", standardCallback)
			flash:SetUserData("tooltip", L["Flashes the background of emphasized bars, which could make it easier for you to spot them."])
			flash:SetCallback("OnEnter", onControlEnter)
			flash:SetCallback("OnLeave", onControlLeave)
			flash:SetFullWidth(true)

			local move = AceGUI:Create("CheckBox")
			move:SetValue(db.emphasizeMove)
			move:SetLabel(L["Move"])
			move:SetUserData("key", "emphasizeMove")
			move:SetCallback("OnValueChanged", standardCallback)
			move:SetUserData("tooltip", L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."])
			move:SetCallback("OnEnter", onControlEnter)
			move:SetCallback("OnLeave", onControlLeave)
			move:SetFullWidth(true)

			local growup = AceGUI:Create("CheckBox")
			growup:SetValue(db.emphasizeGrowup)
			growup:SetLabel(L["Grow upwards"])
			growup:SetUserData("key", "emphasizeGrowup")
			growup:SetCallback("OnValueChanged", standardCallback)
			growup:SetUserData("tooltip", L["Toggle bars grow upwards/downwards from anchor."])
			growup:SetCallback("OnEnter", onControlEnter)
			growup:SetCallback("OnLeave", onControlLeave)
			growup:SetFullWidth(true)

			local scale = AceGUI:Create("Slider")
			scale:SetValue(db.emphasizeScale)
			scale:SetSliderValues(0.2, 2.0, 0.1)
			scale:SetLabel(L["Scale"])
			scale:SetUserData("key", "emphasizeScale")
			scale:SetCallback("OnValueChanged", standardCallback)
			scale:SetFullWidth(true)

			emphasize:AddChildren(enable, flash, move, growup, scale)
		end

		return tex, font, align, icon, duration, normal, emphasize
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function stopBars(bars, module, text)
	local dirty = nil
	for k in pairs(bars) do
		if k:Get("bigwigs:module") == module and (not text or k.candyBarLabel:GetText() == text) then
			k:Stop()
			dirty = true
		end
	end
	return dirty
end

local function stop(module, text)
	if not normalAnchor then return end
	local d = stopBars(normalAnchor.bars, module, text)
	if d then rearrangeBars(normalAnchor) end
	d = stopBars(emphasizeAnchor.bars, module, text)
	if d then rearrangeBars(emphasizeAnchor) end
end

function plugin:BigWigs_OnBossDisable(message, module) stop(module) end
function plugin:BigWigs_StopBar(message, module, text) stop(module, text) end

do
	empUpdate = CreateFrame("Frame")
	empUpdate:Hide()
	local total = 0
	local dirty = nil
	empUpdate:SetScript("OnUpdate", function(self, elapsed)
		if dirty then return end
		for k in pairs(normalAnchor.bars) do
			if not k:Get("bigwigs:emphasized") and k.remaining <= 10 then
				plugin:EmphasizeBar(k)
				dirty = true
			end
		end
		if dirty then
			rearrangeBars(normalAnchor)
			rearrangeBars(emphasizeAnchor)
			dirty = nil
		end
	end)
end

-- Super Emphasize the clicked bar
clickHandlers.emphasize = function(bar)
	if superemp then
		-- Add 0.2sec here to catch messages for this option triggered when the bar ends.
		superemp:Emphasize(bar:Get("bigwigs:module"), bar:Get("bigwigs:option"), bar.remaining + 0.2)
	end
end

-- Report the bar status to the active group type (raid, party, solo)
do
	local tformat1 = "%d:%02d"
	local tformat2 = "%1.1f"
	local tformat3 = "%.0f"
	local function timeDetails(t)
		if t >= 3600 then -- > 1 hour
			local h = floor(t/3600)
			local m = t - (h*3600)
			return tformat1:format(h, m)
		elseif t >= 60 then -- 1 minute to 1 hour
			local m = floor(t/60)
			local s = t - (m*60)
			return tformat1:format(m, s)
		elseif t < 10 then -- 0 to 10 seconds
			return tformat2:format(t)
		else -- 10 seconds to one minute
			return tformat3:format(floor(t + .5))
		end
	end
	clickHandlers.report = function(bar)
		local channel = "SAY"
		if UnitInBattleground("player") then
			channel = "BATTLEGROUND"
		elseif UnitInRaid("player") then
			channel = "RAID"
		elseif GetNumPartyMembers() > 1 then
			channel = "PARTY"
		end
		local text = ("%s: %s"):format(bar.candyBarLabel:GetText(), timeDetails(bar.remaining))
		SendChatMessage(text, channel)
	end
end

-- Removes the clicked bar
clickHandlers.remove = function(bar)
	local anchor = bar:Get("bigwigs:anchor")
	plugin:SendMessage("BigWigs_SilenceOption", bar:Get("bigwigs:option"), bar.remaining + 0.3)
	bar:Stop()
	rearrangeBars(anchor)
end

-- Removes all bars EXCEPT the clicked one
clickHandlers.removeOther = function(bar)
	if normalAnchor then
		for k in pairs(normalAnchor.bars) do
			if k ~= bar then
				plugin:SendMessage("BigWigs_SilenceOption", k:Get("bigwigs:option"), k.remaining + 0.3)
				k:Stop()
			end
		end
		rearrangeBars(normalAnchor)
	end
	if emphasizeAnchor then
		for k in pairs(emphasizeAnchor.bars) do
			if k ~= bar then
				plugin:SendMessage("BigWigs_SilenceOption", k:Get("bigwigs:option"), k.remaining + 0.3)
				k:Stop()
			end
		end
		rearrangeBars(emphasizeAnchor)
	end
end

-- Disables the option that launched this bar
clickHandlers.disable = function(bar)
	local m = bar:Get("bigwigs:module")
	if m and m.db and m.db.profile and bar:Get("bigwigs:option") then
		m.db.profile[bar:Get("bigwigs:option")] = 0
	end
end

local function barClicked(bar, button)
	for action, enabled in pairs(plugin.db.profile[button]) do
		if enabled then clickHandlers[action](bar) end
	end
end

local function barOnEnter(bar)
	bar.candyBarLabel:SetJustifyH("CENTER")
	bar.candyBarBackground:SetVertexColor(1, 1, 1, 0.8)
end
local function barOnLeave(bar)
	bar.candyBarLabel:SetJustifyH(db.align)
	bar.candyBarBackground:SetVertexColor(0.5, 0.5, 0.5, 0.3)
end

local function countdown(bar)
	if bar.remaining <= bar:Get("bigwigs:count") then
		local count = bar:Get("bigwigs:count")
		bar:Set("bigwigs:count", count - 1)
		PlaySoundFile("Interface\\AddOns\\BigWigs\\Sounds\\"..floor(count)..".mp3")
		if count > 0.9 then
			plugin:SendMessage("BigWigs_EmphasizedMessage", floor(count), 1, 0, 0)
		end
	end
end
local function flash(bar)
	if bar.remaining <= bar:Get("bigwigs:flashcount") then
		local count = bar:Get("bigwigs:flashcount")
		bar:Set("bigwigs:flashcount", count - 1)
		plugin:SendMessage("BigWigs_FlashShake")
	end
end

local function actuallyEmphasize(bar, time)
	if time > 5 and superemp.db.profile.countdown then
		bar:Set("bigwigs:count", math.min(5, floor(time)) + .3) -- sounds last approx .3 seconds this makes them right on the ball
		bar:AddUpdateFunction(countdown)
	end
	if time > 3 and superemp.db.profile.flash then
		bar:Set("bigwigs:flashcount", math.min(3, floor(time)) + .3)
		bar:AddUpdateFunction(flash)
	end
end

local function findBar(module, key)
	for k in pairs(normalAnchor.bars) do
		if k:Get("bigwigs:module") == module and k:Get("bigwigs:option") == key then
			return k
		end
	end
	for k in pairs(emphasizeAnchor.bars) do
		if k:Get("bigwigs:module") == module and k:Get("bigwigs:option") == key then
			return k
		end
	end
end

function plugin:BigWigs_SuperEmphasizeStart(event, module, key, time)
	local bar = findBar(module, key)
	if not bar then return end
	actuallyEmphasize(bar, time)
end

function plugin:BigWigs_StartBar(message, module, key, text, time, icon)
	if not normalAnchor then createAnchors() end
	stop(module, text)
	local bar = candy:New(media:Fetch("statusbar", db.texture), 200, 14)
	normalAnchor.bars[bar] = true
	bar.candyBarBackground:SetVertexColor(colors:GetColor("barBackground", module, key))
	bar:Set("bigwigs:module", module)
	bar:Set("bigwigs:anchor", normalAnchor)
	bar:Set("bigwigs:empColor", colors:GetColorTable("barEmphasized", module, key))
	bar:Set("bigwigs:option", key)
	bar:SetColor(colors:GetColor("barColor", module, key))
	bar.candyBarLabel:SetTextColor(colors:GetColor("barText", module, key))
	bar.candyBarLabel:SetJustifyH(db.align)
	bar.candyBarLabel:SetFont(media:Fetch("font", db.font), 10)
	bar.candyBarDuration:SetFont(media:Fetch("font", db.font), 10)
	bar:SetLabel(text)
	bar:SetClampedToScreen(true)
	bar:SetDuration(time)
	bar:SetTimeVisibility(db.time)
	bar:SetIcon(db.icon and icon or nil)
	bar:SetScale(db.scale)
	if db.emphasize and time < 15 then
		self:EmphasizeBar(bar)
	end
	if db.interceptMouse then
		bar:EnableMouse(true)
		bar:SetScript("OnMouseDown", barClicked)
		bar:SetScript("OnEnter", barOnEnter)
		bar:SetScript("OnLeave", barOnLeave)
	end
	if superemp and superemp:IsSuperEmphasized(module, key) then
		actuallyEmphasize(bar, time)
	end
	bar:Start()
	rearrangeBars(bar:Get("bigwigs:anchor"))
end

--------------------------------------------------------------------------------
-- Emphasize
--

local function flash(self)
	local r, g, b, a = self.candyBarBackground:GetVertexColor()
	if self:Get("bigwigs:down") then
		r = r - 0.05
		if r <= 0 then self:Set("bigwigs:down", nil) end
	else
		r = r + 0.05
		if r >= 1 then self:Set("bigwigs:down", true) end
	end
	self.candyBarBackground:SetVertexColor(r, g, b, a)
end

function plugin:EmphasizeBar(bar)
	if db.emphasizeMove then
		normalAnchor.bars[bar] = nil
		emphasizeAnchor.bars[bar] = true
		bar:Set("bigwigs:anchor", emphasizeAnchor)
		bar:Start() -- restart the bar -> remaining time is a full length bar again after moving it to the emphasize anchor
	end
	if db.emphasizeFlash then
		bar:AddUpdateFunction(flash)
	end
	bar:SetColor(unpack(bar:Get("bigwigs:empColor")))
	bar:SetScale(db.emphasizeScale)
	bar:Set("bigwigs:emphasized", true)
end

--------------------------------------------------------------------------------
-- Custom Bars
--

local function parseTime(input)
	if type(input) == "nil" then return end
	if tonumber(input) then return tonumber(input) end
	if type(input) == "string" then
		input = input:trim()
		if input:find(":") then
			local m, s = select(3, input:find("^(%d+):(%d+)$"))
			if not tonumber(m) or not tonumber(s) then return end
			return (tonumber(m) * 60) + tonumber(s)
		elseif input:find("^%d+mi?n?$") then
			return tonumber(select(3, input:find("^(%d+)mi?n?$"))) * 60
		end
	end
end

local function sendCustomMessage(msg)
	if not messages[msg] then return end
	plugin:SendMessage("BigWigs_Message", nil, nil, unpack(messages[msg]))
	wipe(messages[msg])
	messages[msg] = nil
end

local function startCustomBar(bar, nick, localOnly)
	local time, barText = select(3, bar:find("(%S+) (.*)"))
	local seconds = parseTime(time)
	if type(seconds) ~= "number" or type(barText) ~= "string" then
		BigWigs:Print(L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."]:format(tostring(time), nick or UnitName("player")))
		return
	end

	if not nick then nick = L["Local"] end
	local id = "bwcb" .. nick .. barText
	if seconds == 0 then
		if timers[id] then
			plugin:CancelTimer(timers[id], true)
			wipe(messages[id])
			timers[id] = nil
		end
		plugin:SendMessage("BigWigs_StopBar", plugin, nick..": "..barText)
	else
		messages[id] = { L["%s: Timer [%s] finished."]:format(nick, barText), "Attention", localOnly }
		timers[id] = plugin:ScheduleTimer(sendCustomMessage, seconds, id)
		plugin:SendMessage("BigWigs_StartBar", plugin, nil, nick..": "..barText, seconds, "Interface\\Icons\\INV_Misc_PocketWatch_01")
	end
end

function plugin:OnSync(sync, rest, nick)
	if sync ~= "BWCustomBar" or not rest or not nick then return end
	if not UnitIsRaidOfficer(nick) then return end
	startCustomBar(rest, nick, false)
end

-------------------------------------------------------------------------------
-- Slashcommand
--

_G["SlashCmdList"]["BWCB_SHORTHAND"] = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	local t = GetTime()
	if not times[input] or (times[input] and (times[input] + 2) < t) then
		times[input] = t
		BigWigs:Transmit("BWCustomBar", input)
	end
end
_G["SLASH_BWCB_SHORTHAND1"] = "/bwcb"
_G["SlashCmdList"]["BWLCB_SHORTHAND"] = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	startCustomBar(input, nil, true)
end
_G["SLASH_BWLCB_SHORTHAND1"] = "/bwlcb"

-------------------------------------------------------------------------------
-- Interactive bars
--
