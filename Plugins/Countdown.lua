-------------------------------------------------------------------------------
-- Module Declaration
--

local oldPlugin = BigWigs:NewPlugin("Super Emphasize") -- XXX temp 9.0.2
oldPlugin.defaultDB = {
	Countdown = {},
}
function oldPlugin:IsSuperEmphasized() -- Old WeakAuras versions
	return false -- Add a print?
end

local plugin = BigWigs:NewPlugin("Countdown")
if not plugin then return end

local voiceMap = {
	deDE = "Deutsch: Heroes of the Storm",
	esES = "Español: Heroes of the Storm",
	esMX = "Español: Heroes of the Storm",
	frFR = "Français: Heroes of the Storm",
	ruRU = "Русский: Heroes of the Storm",
	koKR = "한국어: Heroes of the Storm",
	itIT = "Italiano: Heroes of the Storm",
	ptBR = "Português: Heroes of the Storm",
	zhCN = "简体中文: Heroes of the Storm",
	zhTW = "繁體中文: Heroes of the Storm",
}

plugin.defaultDB = {
	textEnabled = true,
	fontName = plugin:GetDefaultFont(),
	outline = "THICKOUTLINE",
	fontSize = 48,
	monochrome = false,
	fontColor = { r = 1, g = 0, b = 0 },
	voice = voiceMap[GetLocale()] or "English: Amy",
	countdownTime = 5,
	position = {"TOP", "TOP", 0, -300},
	bossCountdowns = {},
}

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
local BigWigsAPI = BigWigsAPI
local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.countdown
local PlaySoundFile = PlaySoundFile

local countdownAnchor = nil
local countdownFrame = nil
local countdownText = nil
local inConfigMode = false

-------------------------------------------------------------------------------
-- Countdown Registration
--

BigWigsAPI:RegisterCountdown(L.none, { false, false, false, false, false })
BigWigsAPI:RegisterCountdown("English: Amy", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\10.ogg",
})
BigWigsAPI:RegisterCountdown("English: David", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\10.ogg",
})
BigWigsAPI:RegisterCountdown("English: Jim", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\10.ogg",
})
BigWigsAPI:RegisterCountdown("English: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Deutsch: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Español: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Français: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Русский: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\5.ogg",
})
BigWigsAPI:RegisterCountdown("한국어: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Italiano: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Português: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\5.ogg",
})
BigWigsAPI:RegisterCountdown("简体中文: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\5.ogg",
})
BigWigsAPI:RegisterCountdown("繁體中文: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\5.ogg",
})

--------------------------------------------------------------------------------
-- Anchors & Frames
--

local function showAnchors()
	inConfigMode = true
	countdownAnchor:Show()
	countdownFrame:Show()
	countdownText:SetText("5")
end

local function hideAnchors()
	inConfigMode = false
	countdownAnchor:Hide()
	countdownFrame:Hide()
end

do
	local function OnDragStart(self)
		self:StartMoving()
	end
	local function OnDragStop(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		plugin.db.profile.position = {point, relPoint, x, y}
		plugin:UpdateGUI() -- Update X/Y if GUI is open.
	end
	local function RefixPosition(self)
		self:ClearAllPoints()
		local point, relPoint = plugin.db.profile.position[1], plugin.db.profile.position[2]
		local x, y = plugin.db.profile.position[3], plugin.db.profile.position[4]
		self:SetPoint(point, UIParent, relPoint, x, y)
	end

	countdownAnchor = CreateFrame("Frame", nil, UIParent)
	countdownAnchor:EnableMouse(true)
	countdownAnchor:SetClampedToScreen(true)
	countdownAnchor:SetMovable(true)
	countdownAnchor:RegisterForDrag("LeftButton")
	countdownAnchor:SetWidth(80)
	countdownAnchor:SetHeight(80)
	countdownAnchor:SetFrameStrata("HIGH")
	countdownAnchor:SetFixedFrameStrata(true)
	countdownAnchor:SetFrameLevel(20)
	countdownAnchor:SetFixedFrameLevel(true)
	countdownAnchor:SetScript("OnDragStart", OnDragStart)
	countdownAnchor:SetScript("OnDragStop", OnDragStop)
	countdownAnchor.RefixPosition = RefixPosition
	local point, relPoint = plugin.defaultDB.position[1], plugin.defaultDB.position[2]
	local x, y = plugin.defaultDB.position[3], plugin.defaultDB.position[4]
	countdownAnchor:SetPoint(point, UIParent, relPoint, x, y)
	countdownAnchor:Hide()
	local bg = countdownAnchor:CreateTexture()
	bg:SetAllPoints(countdownAnchor)
	bg:SetColorTexture(0, 0, 0, 0.3)
	local header = countdownAnchor:CreateFontString()
	header:SetFont(plugin:GetDefaultFont(12))
	header:SetShadowOffset(1, -1)
	header:SetTextColor(1,0.82,0,1)
	header:SetText(L.textCountdown)
	header:SetPoint("BOTTOM", countdownAnchor, "TOP", 0, 5)
	header:SetJustifyV("MIDDLE")
	header:SetJustifyH("CENTER")
end

-------------------------------------------------------------------------------
-- Options
--

local function voiceList() -- select values
	return BigWigsAPI:GetCountdownList()
end

local function UpdateFont()
	local flags = nil
	if plugin.db.profile.monochrome and plugin.db.profile.outline ~= "NONE" then
		flags = "MONOCHROME," .. plugin.db.profile.outline
	elseif plugin.db.profile.monochrome then
		flags = "MONOCHROME"
	elseif plugin.db.profile.outline ~= "NONE" then
		flags = plugin.db.profile.outline
	end
	countdownText:SetFont(media:Fetch(FONT, plugin.db.profile.fontName), plugin.db.profile.fontSize, flags)
	countdownText:SetTextColor(plugin.db.profile.fontColor.r, plugin.db.profile.fontColor.g, plugin.db.profile.fontColor.b)
end

do
	local disabled = function() return plugin.db.profile.disabled end
	plugin.pluginOptions = {
		name = L.countdown,
		type = "group",
		childGroups = "tab",
		get = function(info) return plugin.db.profile[info[#info]] end,
		set = function(info, value)
			plugin.db.profile[info[#info]] = value
			UpdateFont()
		end,
		args = {
			general = {
				type = "group",
				name = L.general,
				order = 1,
				args = {
					heading = {
						type = "description",
						name = L.countdownDesc.. "\n\n",
						order = 1,
						width = "full",
						fontSize = "medium",
					},
					countdownTime = {
						name = L.countdownAt,
						desc = L.countdownAt_desc,
						type = "range", min = 3, max = 10, step = 1,
						order = 2,
						width = 2,
					},
					countdownTest = {
						name = L.countdownTest,
						type = "execute",
						handler = plugin,
						func = "TestCountdown",
						order = 3,
					},
					audioSpacer = {
						type = "description",
						name = "\n\n",
						order = 4,
						width = "full",
						fontSize = "medium",
					},
					audioHeader = {
						type = "header",
						name = L.countdownAudioHeader,
						order = 5,
					},
					voice = {
						name = L.countdownVoice,
						type = "select",
						values = voiceList,
						order = 6,
						width = "full",
					},
					textSpacer = {
						type = "description",
						name = "\n\n",
						order = 7,
						width = "full",
						fontSize = "medium",
					},
					textHeader = {
						type = "header",
						name = L.countdownTextHeader,
						order = 8,
					},
					textEnabled = {
						type = "toggle",
						name = L.textCountdown,
						desc = L.textCountdownDesc,
						order = 9,
						width = "full",
					},
					fontName = {
						type = "select",
						name = L.font,
						order = 10,
						values = media:List(FONT),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, media:List(FONT) do
								if v == plugin.db.profile.fontName then return i end
							end
						end,
						set = function(_, value)
							local list = media:List(FONT)
							plugin.db.profile.fontName = list[value]
							UpdateFont()
						end,
						width = 2,
					},
					outline = {
						type = "select",
						name = L.outline,
						order = 11,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
					},
					fontColor = {
						type = "color",
						name = L.countdownColor,
						get = function(info)
							return plugin.db.profile.fontColor.r, plugin.db.profile.fontColor.g, plugin.db.profile.fontColor.b
						end,
						set = function(info, r, g, b)
							plugin.db.profile.fontColor.r, plugin.db.profile.fontColor.g, plugin.db.profile.fontColor.b = r, g, b
							UpdateFont()
						end,
						order = 12,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 13,
						softMax = 100, max = 200, min = 20, step = 1,
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 14,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 15,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetCountdownDesc,
						func = function()
							local restoreCountdowns = plugin.db.profile.bossCountdowns
							plugin.db:ResetProfile()
							plugin.db.profile.bossCountdowns = restoreCountdowns
						end,
						order = 16,
					},
					resetAll = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetAllCountdownDesc,
						func = function() plugin.db:ResetProfile() end,
						order = 17,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 2,
				args = {
					posx = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 1,
						width = "full",
						get = function()
							return plugin.db.profile.position[3]
						end,
						set = function(_, value)
							plugin.db.profile.position[3] = value
							countdownAnchor:RefixPosition()
						end,
					},
					posy = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 2,
						width = "full",
						get = function()
							return plugin.db.profile.position[4]
						end,
						set = function(_, value)
							plugin.db.profile.position[4] = value
							countdownAnchor:RefixPosition()
						end,
					},
				},
			},
		},
	}
end

local function createOptions()
	local sModule = BigWigs:GetPlugin("Sounds", true)
	if sModule then
		-- ability options
		sModule.soundOptions.args.separator1 = {
			name = "",
			type = "description",
			order = 3,
		}
		sModule.soundOptions.args.countdown = {
			name = "Countdown",
			type = "select",
			values = voiceList,
			get = function(info)
				local name, key = unpack(info.arg)
				return plugin.db.profile.bossCountdowns[name] and plugin.db.profile.bossCountdowns[name][key] or plugin.db.profile.voice
			end,
			set = function(info, value)
				local name, key = unpack(info.arg)
				if value ~= plugin.db.profile.voice then
					if not plugin.db.profile.bossCountdowns[name] then plugin.db.profile.bossCountdowns[name] = {} end
					plugin.db.profile.bossCountdowns[name][key] = value
				else -- clean up
					if plugin.db.profile.bossCountdowns[name] then
						plugin.db.profile.bossCountdowns[name][key] = nil
					end
					if not next(plugin.db.profile.bossCountdowns[name]) then
						plugin.db.profile.bossCountdowns[name] = nil
					end
				end
			end,
			order = 4,
			width = "full",
		}
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

do
	local function updateProfile()
		local db = plugin.db.profile

		for k, v in next, db do
			if type(plugin.defaultDB[k]) == "nil" then
				db[k] = nil
			elseif type(v) ~= "boolean" then
				db[k] = plugin.defaultDB[k]
			end
		end

		if db.outline ~= "NONE" and db.outline ~= "OUTLINE" and db.outline ~= "THICKOUTLINE" then
			db.outline = plugin.defaultDB.outline
		end
		if db.fontSize < 20 or db.fontSize > 200 then
			db.fontSize = plugin.defaultDB.fontSize
		end
		if type(db.fontColor.r) ~= "number" or db.fontColor.r < 0 or db.fontColor.r > 1
		or type(db.fontColor.g) ~= "number" or db.fontColor.g < 0 or db.fontColor.g > 1
		or type(db.fontColor.b) ~= "number" or db.fontColor.b < 0 or db.fontColor.b > 1 then
			db.fontColor = plugin.defaultDB.fontColor
		end
		if db.countdownTime < 3 or db.countdownTime > 10 then
			db.countdownTime = plugin.defaultDB.countdownTime
		end

		UpdateFont()
		countdownAnchor:RefixPosition()

		-- Reset invalid voice selections
		if not BigWigsAPI:HasCountdown(db.voice) then
			db.voice = voiceMap[GetLocale()] or "English: Amy"
		end
		for boss, tbl in next, db.bossCountdowns do
			for ability, chosenVoice in next, tbl do
				if not BigWigsAPI:HasCountdown(chosenVoice) then
					db.bossCountdowns[boss][ability] = nil
				end
			end
		end
		-- XXX temp 9.0.2
		oldPlugin.db:ResetProfile(nil, true) -- no callbacks
	end

	function plugin:OnPluginEnable()
		self:RegisterMessage("BigWigs_StartCountdown")
		self:RegisterMessage("BigWigs_StopCountdown")
		self:RegisterMessage("BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
		self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
		updateProfile()
		createOptions()
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

local latestCountdown = nil
do
	countdownFrame = CreateFrame("Frame", nil, UIParent)
	countdownFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	countdownFrame:SetFixedFrameStrata(true)
	countdownFrame:SetFrameLevel(20) -- Behind GUI (level 100)
	countdownFrame:SetFixedFrameLevel(true)
	countdownFrame:SetPoint("CENTER", countdownAnchor, "CENTER")
	countdownFrame:SetWidth(80)
	countdownFrame:SetHeight(80)
	countdownFrame:Hide()

	countdownText = countdownFrame:CreateFontString()
	countdownText:SetPoint("CENTER", countdownFrame, "CENTER")

	local updater = countdownFrame:CreateAnimationGroup()
	updater:SetScript("OnFinished", function()
		if inConfigMode then
			countdownText:SetText("5")
		else
			countdownFrame:Hide()
		end
	end)
	local anim = updater:CreateAnimation("Alpha")
	anim:SetFromAlpha(1)
	anim:SetToAlpha(0)
	anim:SetDuration(1)
	anim:SetStartDelay(1.1)

	function plugin:SetText(text, timer)
		latestCountdown = timer
		countdownText:SetText(text)
		updater:Stop()
		countdownFrame:Show()
		updater:Play()
	end
end

do
	local timers = {}
	function plugin:BigWigs_StartCountdown(_, module, key, text, time, customVoice, audioOnly)
		if module and time > 1.3 then
			self:BigWigs_StopCountdown(nil, module, text)
			if not timers[module] then
				timers[module] = {}
			end
			local cancelTimer = {false}
			timers[module][text] = cancelTimer

			local voice = customVoice or plugin.db.profile.bossCountdowns[module.name] and plugin.db.profile.bossCountdowns[module.name][key] or plugin.db.profile.voice
			for i = 1, self.db.profile.countdownTime do
				local t = i + 0.3
				if time <= t then return end
				self:SimpleTimer(function()
					if not cancelTimer[1] then
						if not audioOnly and plugin.db.profile.textEnabled then
							plugin:SetText(i, cancelTimer)
						end
						local sound = BigWigsAPI:GetCountdownSound(voice, i)
						if sound then
							PlaySoundFile(sound, "Master")
						end
					end
				end, time-t)
			end
		end
	end
	function plugin:BigWigs_StopCountdown(_, module, text)
		local moduleTimers = timers[module]
		if moduleTimers and moduleTimers[text] then
			moduleTimers[text][1] = true
			if latestCountdown == moduleTimers[text] then
				self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
			end
		end
	end
	function plugin:BigWigs_OnBossDisable(_, module)
		if timers[module] then
			for _, timer in next, timers[module] do
				timer[1] = true
				if latestCountdown == timer then
					self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
				end
			end
			timers[module] = nil
		end
	end
end

function plugin:TestCountdown()
	self:SendMessage("BigWigs_StartCountdown", self, nil, "test countdown", 5.5)
end
