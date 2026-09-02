-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("TextTimers")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local FONT = LibSharedMedia.MediaType and LibSharedMedia.MediaType.FONT or "font"
local GetTime = GetTime
local GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture
local tsort = table.sort
local db

-- Tracked timers are stored in a table of {module, text, eventId, expires, paused, remaining} tables.
local activeTimers = {}
local ticking = false

-------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	enabled = false,
	locked = false,
	threshold = 5,
	maxLines = 5,
	maxNameLength = 20,
	fontName = plugin:GetDefaultFont(),
	fontSize = 18,
	position = {"CENTER", "CENTER", 0, 150},
	urgentThreshold = 2,
	urgentColor = {1, 0, 0, 1},
	icon = true,
	iconPosition = "LEFT",
}

-------------------------------------------------------------------------------
-- Display
--

local display, fontStrings = CreateFrame("Frame", nil, UIParent), {}
do
	display:SetSize(280, 160)
	display:SetClampedToScreen(true)
	display:SetFrameStrata("HIGH")
	display:SetMovable(true)
	display:RegisterForDrag("LeftButton")
	display:SetScript("OnDragStart", function(self)
		if self:IsMovable() then self:StartMoving() end
	end)
	display:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		db.position[1], db.position[2], db.position[3], db.position[4] = point, relPoint, x, y
	end)
end

local icons = {}
local function layoutIcon(i)
	local icon = icons[i]
	if not db.icon then
		icon:Hide()
		return
	end
	local size = db.fontSize + 8
	icon:SetSize(size, size)
	icon:ClearAllPoints()
	if db.iconPosition == "LEFT" then
		icon:SetPoint("RIGHT", fontStrings[i], "LEFT", -4, 0)
	else
		icon:SetPoint("LEFT", fontStrings[i], "RIGHT", 4, 0)
	end
end

local function applyFont()
	local font = LibSharedMedia:Fetch(FONT, db.fontName)
	for i = 1, #fontStrings do
		fontStrings[i]:SetFont(font, db.fontSize, "OUTLINE")
		layoutIcon(i)
	end
end

local function acquireLine(i)
	local fs = fontStrings[i]
	if not fs then
		fs = display:CreateFontString(nil, "OVERLAY")
		fs:SetPoint("TOP", i == 1 and display or fontStrings[i-1], i == 1 and "TOP" or "BOTTOM", 0, i == 1 and 0 or -4)
		fs:SetJustifyH("CENTER")
		fs:SetShadowOffset(1, -1)
		fs:SetTextColor(1, 1, 1, 1)
		local font = LibSharedMedia:Fetch(FONT, db.fontName)
		fs:SetFont(font, db.fontSize, "OUTLINE")
		fontStrings[i] = fs

		local icon = display:CreateTexture(nil, "ARTWORK")
		icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		icons[i] = icon
		layoutIcon(i)
	end
	return fs
end

-------------------------------------------------------------------------------
-- Timer tracking
--

local function findTimer(module, text, eventId)
	for i = 1, #activeTimers do
		local t = activeTimers[i]
		if eventId then
			if t.eventId == eventId then return i end
		elseif t.module == module and t.text == text then
			return i
		end
	end
end

local function removeTimer(module, text, eventId)
	local i = findTimer(module, text, eventId)
	if i then table.remove(activeTimers, i) end
end

local function truncate(name)
	if db.maxNameLength > 0 and #name > db.maxNameLength then
		return name:sub(1, db.maxNameLength) .. "..."
	end
	return name
end

local shown = {}
local function sortByRemaining(a, b)
	return a.remaining < b.remaining
end
local function refresh()
	if not db.enabled then
		for i = 1, #fontStrings do
			fontStrings[i]:Hide()
			icons[i]:Hide()
		end
		ticking = false
		return
	end

	local now = GetTime()
	table.wipe(shown)
	for i = 1, #activeTimers do
		local t = activeTimers[i]
		if not t.paused then
			local remaining = t.expires - now
			if remaining <= db.threshold and remaining > 0 then
				shown[#shown+1] = {text = t.text, remaining = remaining, icon = t.icon}
			end
		end
	end
	tsort(shown, sortByRemaining)

	local count = math.min(#shown, db.maxLines)
	for i = 1, count do
		local fs = acquireLine(i)
		fs:SetText(("%s  %.1f"):format(truncate(shown[i].text), shown[i].remaining))
		if shown[i].remaining <= db.urgentThreshold then
			fs:SetTextColor(unpack(db.urgentColor))
		else
			fs:SetTextColor(1, 1, 1, 1)
		end
		fs:Show()

		local icon = icons[i]
		if db.icon and shown[i].icon then
			local texture = shown[i].icon
			icon:SetTexture(type(texture) == "number" and GetSpellTexture(texture) or texture)
			icon:Show()
		else
			icon:Hide()
		end
	end
	for i = count + 1, #fontStrings do
		fontStrings[i]:Hide()
		icons[i]:Hide()
	end

	if #activeTimers == 0 then
		ticking = false
		return
	end
	BigWigsLoader.CTimerAfter(0.1, refresh)
end

local function startTicking()
	if not ticking then
		ticking = true
		refresh()
	end
end

-------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	type = "group",
	name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\EmphasizeMessage:20|t ".. L.textTimers,
	get = function(info) return db[info[#info]] end,
	set = function(info, value) db[info[#info]] = value end,
	order = 4,
	args = {
		heading = {
			type = "description",
			name = L.textTimersDesc,
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		enabled = {
			type = "toggle",
			name = L.enable,
			order = 2,
			width = "full",
			set = function(_, value)
				db.enabled = value
				startTicking()
			end,
		},
		threshold = {
			type = "range",
			name = L.textTimersThreshold,
			desc = L.textTimersThresholdDesc,
			min = 1, max = 15, step = 0.5,
			order = 3,
		},
		maxLines = {
			type = "range",
			name = L.textTimersMaxLines,
			desc = L.textTimersMaxLinesDesc,
			min = 1, max = 10, step = 1,
			order = 4,
		},
		maxNameLength = {
			type = "range",
			name = L.textTimersMaxNameLength,
			desc = L.textTimersMaxNameLengthDesc,
			min = 0, max = 40, step = 1,
			order = 5,
		},
		urgentThreshold = {
			type = "range",
			name = L.textTimersUrgentThreshold,
			desc = L.textTimersUrgentThresholdDesc,
			min = 0, max = 15, step = 0.5,
			order = 5.1,
		},
		urgentColor = {
			type = "color",
			name = L.textTimersUrgentColor,
			order = 5.2,
			get = function() return unpack(db.urgentColor) end,
			set = function(_, r, g, b) db.urgentColor = {r, g, b, 1} end,
		},
		icon = {
			type = "toggle",
			name = L.icon,
			desc = L.textTimersIconDesc,
			order = 5.3,
			set = function(_, value)
				db.icon = value
				for i = 1, #fontStrings do layoutIcon(i) end
			end,
		},
		iconPosition = {
			type = "select",
			name = L.iconPosition,
			desc = L.textTimersIconPositionDesc,
			order = 5.4,
			values = {
				LEFT = L.LEFT,
				RIGHT = L.RIGHT,
			},
			disabled = function() return not db.icon end,
			set = function(_, value)
				db.iconPosition = value
				for i = 1, #fontStrings do layoutIcon(i) end
			end,
		},
		fontName = {
			type = "select",
			name = L.font,
			order = 6,
			width = "full",
			values = function() return LibSharedMedia:List(FONT) end,
			dialogControl = "BigWigsSharedDropdown",
			itemControl = "DDI-Font",
			get = function()
				for i, v in next, LibSharedMedia:List(FONT) do
					if v == db.fontName then return i end
				end
			end,
			set = function(_, value)
				db.fontName = LibSharedMedia:List(FONT)[value]
				applyFont()
			end,
		},
		fontSize = {
			type = "range",
			name = L.fontSize,
			min = 8, max = 40, step = 1,
			order = 7,
			set = function(_, value)
				db.fontSize = value
				applyFont()
			end,
		},
		locked = {
			type = "toggle",
			name = L.lock,
			desc = L.lockDesc,
			order = 8,
			set = function(_, value)
				db.locked = value
				display:EnableMouse(not value)
			end,
		},
		resetPosition = {
			type = "execute",
			name = L.reset,
			order = 9,
			func = function()
				db.position[1], db.position[2], db.position[3], db.position[4] = unpack(plugin.defaultDB.position)
				display:ClearAllPoints()
				display:SetPoint(db.position[1], UIParent, db.position[2], db.position[3], db.position[4])
			end,
		},
		testButton = {
			type = "execute",
			name = L.test,
			order = 10,
			func = function() plugin:Test() end,
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

local function updateProfile()
	db = plugin.db.profile

	for k, v in next, plugin.db.profile do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			db[k] = plugin.defaultDB[k]
		end
	end
	if type(db.position[1]) ~= "string" or type(db.position[2]) ~= "string"
	or type(db.position[3]) ~= "number" or type(db.position[4]) ~= "number" then
		db.position[1], db.position[2], db.position[3], db.position[4] = unpack(plugin.defaultDB.position)
	end
	if not LibSharedMedia:IsValid(FONT, db.fontName) then
		db.fontName = plugin.defaultDB.fontName
	end
	if db.iconPosition ~= "LEFT" and db.iconPosition ~= "RIGHT" then
		db.iconPosition = plugin.defaultDB.iconPosition
	end

	display:ClearAllPoints()
	display:SetPoint(db.position[1], UIParent, db.position[2], db.position[3], db.position[4])
	display:EnableMouse(not db.locked)
	applyFont()
end

function plugin:OnPluginEnable()
	updateProfile()
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	self:RegisterMessage("BigWigs_StartBar")
	self:RegisterMessage("BigWigs_PauseBar")
	self:RegisterMessage("BigWigs_ResumeBar")
	self:RegisterMessage("BigWigs_StopBar")
	self:RegisterMessage("BigWigs_StopBars")
	self:RegisterMessage("BigWigs_OnBossDisable", "BigWigs_StopBars")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_StopBars")
	self:RegisterMessage("BigWigs_OnPluginDisable", "BigWigs_StopBars")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_StartBar(_, module, key, text, time, icon, isApprox, maxTime, eventId)
	text = text or ""
	removeTimer(module, text, eventId)
	activeTimers[#activeTimers+1] = {module = module, text = text, eventId = eventId, expires = GetTime() + time, icon = icon}
	startTicking()
end

function plugin:BigWigs_PauseBar(_, module, text, eventId)
	local i = findTimer(module, text, eventId)
	if i and not activeTimers[i].paused then
		local t = activeTimers[i]
		t.remaining = t.expires - GetTime()
		t.paused = true
	end
end

function plugin:BigWigs_ResumeBar(_, module, text, eventId)
	local i = findTimer(module, text, eventId)
	if i and activeTimers[i].paused then
		local t = activeTimers[i]
		t.expires = GetTime() + t.remaining
		t.remaining = nil
		t.paused = nil
	end
end

function plugin:BigWigs_StopBar(_, module, text, eventId)
	removeTimer(module, text, eventId)
end

function plugin:BigWigs_StopBars(_, module)
	for i = #activeTimers, 1, -1 do
		if activeTimers[i].module == module then
			table.remove(activeTimers, i)
		end
	end
end

function plugin:Test()
	local now = GetTime()
	activeTimers[#activeTimers+1] = {module = plugin, text = "Fire Blast", eventId = "textTimersTest1", expires = now + 4.8, icon = 133} -- Fireball
	activeTimers[#activeTimers+1] = {module = plugin, text = "Meteor", eventId = "textTimersTest2", expires = now + 3.2, icon = 116} -- Frostbolt
	startTicking()
end
