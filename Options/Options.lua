
local BIGWIGS_AUTHORS = "rabbit, ammo, 7destiny, pettigrow, ananhaid, mojosdojo, Wetxius, jongt23, tekkub, fenlis, _yusaku_, shyva, StingerSoft, dynaletik, cwdg, gamefaq, yoshimo, sayclub, saroz, nevcairiel, s8095324, handdol, durcyn, chuanhsing, scorpio0920, kebinusan, Dynaletik, flyflame, zhTW, stanzilla, onyxmaster, MysticalOS, grimwald, lcf_hell, starinnia, chinkuwaila, arrowmaster, next96, tnt2ray, ackis, Leialyn, cremor, moonsorrow, jerry, fryguy, xinsonic, beerke, shari83, tsigo, hk2717, pigmonkey, ulic, mecdemort, Carlos, gnarfoz, a9012456, Cybersea, cronan, hyperactiveChipmunk, darchon, neriak, nirek, mikk, darkwings, hshh, otravi, yhpdoit, kjheng, AnarkiQ3, kergoth, dessa, ethancentaurai, Sayclub, erwanoops, Swix, Gothwin, illiaster, oojoo, nymbia, kyahx, valdriethien, phyber, oxman, profalbert, Traeumer, Zidomo, Anadale, tazmanyak, tain, thiana, ckknight, kemayo, zealotonastick, archarodim, coalado, silverwind, lucen, Adam77."

local BigWigs = BigWigs
local options = BigWigs:NewModule("Options")
options:SetEnabledState(true)

-- Embed callback handler
options.RegisterMessage = BigWigs.RegisterMessage
options.UnregisterMessage = BigWigs.UnregisterMessage
options.SendMessage = BigWigs.SendMessage

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, key)
			return self[key]
		end
	})
end

local C = BigWigs.C

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")

local icon = LibStub("LibDBIcon-1.0", true)
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local loader = BigWigsLoader
local GetAreaMapInfo = loader.GetAreaMapInfo
local fakeWorldZones = loader.fakeWorldZones

local colorModule
local soundModule
local translateZoneID

local showToggleOptions, getAdvancedToggleOption = nil, nil
local zoneModules = {}

local getOptions
local acOptions = {
	type = "group",
	name = "Big Wigs",
	get = function(info)
		return BigWigs.db.profile[info[#info]]
	end,
	set = function(info, value)
		local key = info[#info]
		BigWigs.db.profile[key] = value
		options:SendMessage("BigWigs_CoreOptionToggled", key, value)
	end,
	args = {
		introduction = {
			type = "description",
			name = L.introduction,
			fontSize = "medium",
			order = 1,
			width = "full",
		},
		anchors = {
			type = "execute",
			name = L.toggleAnchorsBtn,
			desc = L.toggleAnchorsBtn_desc,
			func = function()
				if not BigWigs:IsEnabled() then BigWigs:Enable() end
				if options:InConfigureMode() then
					options:SendMessage("BigWigs_StopConfigureMode")
				else
					options:SendMessage("BigWigs_StartConfigureMode")
					options:SendMessage("BigWigs_SetConfigureTarget", BigWigs:GetPlugin("Bars"))
				end
			end,
			order = 2,
			width = "double",
		},
		testing = {
			type = "execute",
			name = L.testBarsBtn,
			desc = L.testBarsBtn_desc,
			func = function()
				BigWigs:Test()
			end,
			order = 3,
			width = "double",
		},
		bosses = {
			type = "execute",
			name = BOSSES:gsub(":", ""),
			--desc = "Bosses",
			descStyle = "", -- kill tooltip
			func = function()
				acd:Close("BigWigs")
				for name, module in BigWigs:IterateBossModules() do
					if module:IsEnabled() then
						local menu = translateZoneID(module.otherMenu) or translateZoneID(module.zoneId)
						if not menu then return end
						InterfaceOptionsFrame_OpenToCategory(options:GetZonePanel(module.otherMenu or module.zoneId))
						InterfaceOptionsFrame_OpenToCategory(options:GetZonePanel(module.otherMenu or module.zoneId))
					end
				end
				if not InterfaceOptionsFrame:IsShown() then
					InterfaceOptionsFrame_OpenToCategory("Big Wigs |cFF62B1F6".. EJ_GetTierInfo(6) .."|r")
					InterfaceOptionsFrame_OpenToCategory("Big Wigs |cFF62B1F6".. EJ_GetTierInfo(6) .."|r")
				end
			end,
			order = 4,
			width = "half",
		},
		general = {
			order = 20,
			type = "group",
			name = "Big Wigs",
			args = {
				minimap = {
					type = "toggle",
					name = L.minimapIcon,
					desc = L.minimapToggle,
					order = 13,
					get = function() return not BigWigs3IconDB.hide end,
					set = function(info, v)
						if v then
							BigWigs3IconDB.hide = nil
							icon:Show("BigWigs")
						else
							BigWigs3IconDB.hide = true
							icon:Hide("BigWigs")
						end
					end,
					hidden = function() return not icon end,
					width = "full",
				},
				separator2 = {
					type = "description",
					name = " ",
					order = 14,
					width = "full",
				},
				flash = {
					type = "toggle",
					name = L.flashScreen,
					desc = L.flashScreenDesc,
					order = 22,
				},
				raidicon = {
					type = "toggle",
					name = L.raidIcons,
					desc = L.raidIconsDesc,
					set = function(info, value)
						local key = info[#info]
						local plugin = BigWigs:GetPlugin("Raid Icons")
						plugin:Disable()
						BigWigs.db.profile[key] = value
						options:SendMessage("BigWigs_CoreOptionToggled", key, value)
						plugin:Enable()
					end,
					order = 24,
				},
				chat = {
					type = "toggle",
					name = L.chatMessages,
					desc = L.chatMessagesDesc,
					order = 25,
					width = "full",
					get = function() return BigWigs:GetPlugin("Messages").db.profile.chat end,
					set = function(_, v) BigWigs:GetPlugin("Messages").db.profile.chat = v end,
				},
				separator3 = {
					type = "description",
					name = " ",
					order = 30,
					width = "full",
				},
				showZoneMessages = {
					type = "toggle",
					name = L.zoneMessages,
					desc = L.zoneMessagesDesc,
					order = 32,
					width = "full",
				},
				separator4 = {
					type = "description",
					name = " ",
					order = 40,
					width = "full",
				},
				fakeDBMVersion = {
					type = "toggle",
					name = L.dbmFaker,
					desc = L.dbmFakerDesc,
					order = 41,
					width = "full",
				},
				slashDescTitle = {
					type = "description",
					name = "\n".. L.slashDescTitle,
					fontSize = "large",
					order = 43,
					width = "full",
				},
				slashDescPull = {
					type = "description",
					name = "  ".. L.slashDescPull,
					fontSize = "medium",
					order = 44,
					width = "full",
				},
				slashDescBreak = {
					type = "description",
					name = "  ".. L.slashDescBreak,
					fontSize = "medium",
					order = 45,
					width = "full",
				},
				slashDescBar = {
					type = "description",
					name = "  ".. L.slashDescRaidBar,
					fontSize = "medium",
					order = 46,
					width = "full",
				},
				slashDescLocalBar = {
					type = "description",
					name = "  ".. L.slashDescLocalBar,
					fontSize = "medium",
					order = 47,
					width = "full",
				},
				slashDescRange = {
					type = "description",
					name = "  ".. L.slashDescRange,
					fontSize = "medium",
					order = 48,
					width = "full",
				},
				slashDescVersion = {
					type = "description",
					name = "  ".. L.slashDescVersion,
					fontSize = "medium",
					order = 49,
					width = "full",
				},
				slashDescConfig = {
					type = "description",
					name = "  ".. L.slashDescConfig,
					fontSize = "medium",
					order = 50,
					width = "full",
				},
			},
		},
	},
}

function translateZoneID(id)
	if not id or type(id) ~= "number" then return end
	local name
	if id < 10 then
		name = select(id * 2, GetMapContinents())
	else
		name = GetMapNameByID(id)
	end
	return name
end

local function findPanel(name, parent)
	for i, button in next, InterfaceOptionsFrameAddOns.buttons do
		if button.element then
			if name and button.element.name == name then return button
			elseif parent and button.element.parent == parent then return button
			end
		end
	end
end

do
	local addonName = ...
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	local function Initialize(_, _, addon)
		if addon ~= addonName then return end

		acOptions.args.general.args.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(BigWigs.db)
		acOptions.args.general.args.profileOptions.order = 1
		LibStub("LibDualSpec-1.0"):EnhanceOptions(acOptions.args.general.args.profileOptions, BigWigs.db)

		acr:RegisterOptionsTable("BigWigs", getOptions, true)
		acd:SetDefaultSize("BigWigs", 858, 660)
		--local mainOpts = acd:AddToBlizOptions("BigWigs", "Big Wigs")
		--mainOpts:HookScript("OnShow", function()
		--	BigWigs:Enable()
		--	local p = findPanel("Big Wigs")
		--	if p and p.element.collapsed then OptionsListButtonToggle_OnClick(p.toggle) end
		--end)
		--
		--local about = self:GetPanel(L.about, "Big Wigs")
		--about:SetScript("OnShow", function(frame)
		--	local fields = {
		--		L.developers,
		--		L.license,
		--		L.website,
		--		L.contact,
		--	}
		--	local fieldData = {
		--		"Funkydude, Maat, Nebula169",
		--		L.allRightsReserved,
		--		"http://www.wowace.com/addons/big-wigs/",
		--		L.ircChannel,
		--	}
		--	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		--	title:SetPoint("TOPLEFT", 16, -16)
		--	title:SetText(L.about)
		--
		--	local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		--	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		--	subtitle:SetWidth(frame:GetWidth() - 24)
		--	subtitle:SetJustifyH("LEFT")
		--	subtitle:SetJustifyV("TOP")
		--	local noteKey = "Notes"
		--	if GetAddOnMetadata("BigWigs", "Notes-" .. GetLocale()) then noteKey = "Notes-" .. GetLocale() end
		--	local notes = GetAddOnMetadata("BigWigs", noteKey)
		--	subtitle:SetText(notes .. " |cff44ff44" .. loader:GetReleaseString() .. "|r")
		--
		--	local anchor = nil
		--	for i, field in next, fields do
		--		local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		--		title:SetWidth(120)
		--		if not anchor then
		--			title:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -16)
		--		else
		--			title:SetPoint("TOP", anchor, "BOTTOM", 0, -6)
		--			title:SetPoint("LEFT", subtitle)
		--		end
		--		title:SetNonSpaceWrap(true)
		--		title:SetJustifyH("LEFT")
		--		title:SetText(field)
		--		local detail = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		--		detail:SetPoint("TOPLEFT", title, "TOPRIGHT")
		--		detail:SetWidth(frame:GetWidth() - 144)
		--		detail:SetJustifyH("LEFT")
		--		detail:SetJustifyV("TOP")
		--		detail:SetText(fieldData[i])
		--
		--		anchor = detail
		--	end
		--	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		--	title:SetPoint("TOP", anchor, "BOTTOM", 0, -16)
		--	title:SetPoint("LEFT", subtitle)
		--	title:SetWidth(frame:GetWidth() - 24)
		--	title:SetJustifyH("LEFT")
		--	title:SetJustifyV("TOP")
		--	title:SetText(L.thanks)
		--	local detail = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		--	detail:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
		--	detail:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, -24)
		--	detail:SetJustifyH("LEFT")
		--	detail:SetJustifyV("TOP")
		--	detail:SetText(BIGWIGS_AUTHORS)
		--
		--	frame:SetScript("OnShow", nil)
		--end)

		colorModule = BigWigs:GetPlugin("Colors")
		soundModule = BigWigs:GetPlugin("Sounds")
		acr:RegisterOptionsTable("Big Wigs: Colors Override", colorModule:SetColorOptions("dummy", "dummy"), true)
		acr:RegisterOptionsTable("Big Wigs: Sounds Override", soundModule:SetSoundOptions("dummy", "dummy"), true)

		f:UnregisterEvent("ADDON_LOADED")
		-- Wait with nilling, we don't know how many addons will load during this same execution.
		loader.CTimerAfter(5, function() f:SetScript("OnEvent", nil) end)
	end
	f:SetScript("OnEvent", Initialize)
end

function options:OnEnable()
	self:RegisterMessage("BigWigs_BossModuleRegistered", "Register")
	self:RegisterMessage("BigWigs_PluginRegistered", "Register")

	for name, module in BigWigs:IterateBossModules() do
		self:Register("BigWigs_BossModuleRegistered", name, module)
	end
	for name, module in BigWigs:IteratePlugins() do
		self:Register("BigWigs_PluginRegistered", name, module)
	end

	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")

	local tmp, tmpZone = {}, {}
	for k in next, loader:GetZoneMenus() do
		local zone = translateZoneID(k)
		if zone then
			tmp[zone] = k
			tmpZone[#tmpZone+1] = zone
		end
	end
	sort(tmpZone)
	for i=1, #tmpZone do
		local zone = tmpZone[i]
		self:GetZonePanel(tmp[zone])
	end

	self.OnEnable = nil
end

function options:Open()
	acd:Open("BigWigs")
end

-------------------------------------------------------------------------------
-- Plugin options
--

do
	local configMode = nil
	function options:InConfigureMode() return configMode end
	function options:BigWigs_StartConfigureMode(event, hideFrame)
		configMode = true
	end
	function options:BigWigs_StopConfigureMode()
		configMode = nil
	end
end

local function getMasterOption(self)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	if type(key) == "string" and key:find("^custom_") then
		return module.db.profile[key]
	end
	if type(module.db.profile[key]) ~= "number" then
		module.db.profile[key] = module.toggleDefaults[key]
	end
	if module.db.profile[key] == 0 then
		return false -- nothing go away
	end
	if bit.band(module.db.profile[key], module.toggleDefaults[key]) == module.toggleDefaults[key] then
		return true -- all default baby
	end
	return nil -- some options set
end

local notNumberError = "The option %q for module %q either has a mismatched current value (%q) or target value (%q)."
local function getSlaveOption(self)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	local flag = self:GetUserData("flag")
	local current = module.db.profile[key]
	if type(current) ~= "number" or type(flag) ~= "number" then
		error(notNumberError:format(tostringall(key, module.moduleName, current, flag)))
	end
	return bit.band(current, flag) == flag
end

local function masterOptionToggled(self, event, value)
	if value == nil then self:SetValue(false) end -- toggling the master toggles all (we just pretend to be a tristate)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	if type(key) == "string" and key:find("custom_", nil, true) then
		module.db.profile[key] = value
	else
		if value then
			module.db.profile[key] = module.toggleDefaults[key]
		else
			module.db.profile[key] = 0
		end
		local scrollFrame = self:GetUserData("scrollFrame")
		-- This data ONLY exists if we're looking at the advanced options tab,
		-- we force a refresh of all checkboxes when enabling/disabling the master option.
		if scrollFrame then
			local dropdown = self:GetUserData("dropdown")
			local module = self:GetUserData("module")
			local bossOption = self:GetUserData("option")
			scrollFrame:ReleaseChildren()
			scrollFrame:AddChildren(getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption))
			scrollFrame:PerformLayout()
		end
	end
end

local function slaveOptionToggled(self, event, value)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	local flag = self:GetUserData("flag")
	local master = self:GetUserData("master")
	if value then
		module.db.profile[key] = module.db.profile[key] + flag
	else
		module.db.profile[key] = module.db.profile[key] - flag
	end
	master:SetValue(getMasterOption(master))
end

local function getSlaveToggle(label, desc, key, module, flag, master)
	local toggle = AceGUI:Create("CheckBox")
	toggle:SetLabel(colorize[label])
	if flag == C.MESSAGE or flag == C.ME_ONLY or flag == C.FLASH or flag == C.PULSE or flag == C.EMPHASIZE or flag == C.COUNTDOWN then
		toggle:SetRelativeWidth(0.5)
	else
		toggle:SetFullWidth(true)
	end
	toggle:SetDescription(desc)
	toggle:SetUserData("key", key)
	toggle:SetUserData("module", module)
	toggle:SetUserData("flag", flag)
	toggle:SetUserData("master", master)
	toggle:SetCallback("OnValueChanged", slaveOptionToggled)
	toggle:SetValue(getSlaveOption(toggle))
	return toggle
end

local function advancedToggles(dbKey, module, check)
	local dbv = module.toggleDefaults[dbKey]
	local advancedOptions = {}
	for i, key in next, BigWigs:GetOptions() do
		local flag = C[key]
		if bit.band(dbv, flag) == flag then
			if key == "MESSAGE" then
				local messageGroup = AceGUI:Create("InlineGroup")
				messageGroup:SetLayout("Flow")
				messageGroup:SetFullWidth(true)

				local name, desc = BigWigs:GetOptionDetails(key)
				local message = getSlaveToggle(name, desc, dbKey, module, flag, check)
				messageGroup:AddChild(message)

				local onMe = getSlaveToggle(L.ME_ONLY, L.ME_ONLY_desc, dbKey, module, C.ME_ONLY, check)
				messageGroup:AddChild(onMe)

				advancedOptions[#advancedOptions + 1] = messageGroup
			elseif key == "FLASH" then
				local flashGroup = AceGUI:Create("InlineGroup")
				flashGroup:SetLayout("Flow")
				flashGroup:SetFullWidth(true)

				local name, desc = BigWigs:GetOptionDetails(key)
				local flash = getSlaveToggle(name, desc, dbKey, module, flag, check)
				flashGroup:AddChild(flash)

				local pulse = getSlaveToggle(L.PULSE, L.PULSE_desc, dbKey, module, C.PULSE, check)
				flashGroup:AddChild(pulse)

				advancedOptions[#advancedOptions + 1] = flashGroup
			else
				local name, desc = BigWigs:GetOptionDetails(key)
				advancedOptions[#advancedOptions + 1] = getSlaveToggle(name, desc, dbKey, module, flag, check)
			end
		end
	end

	local emphasizeGroup = AceGUI:Create("InlineGroup")
	emphasizeGroup:SetLayout("Flow")
	emphasizeGroup:SetFullWidth(true)

	local emphasize = getSlaveToggle(L.EMPHASIZE, L.EMPHASIZE_desc, dbKey, module, C.EMPHASIZE, check)
	emphasizeGroup:AddChild(emphasize)

	local countdown = getSlaveToggle(L.COUNTDOWN, L.COUNTDOWN_desc, dbKey, module, C.COUNTDOWN, check)
	emphasizeGroup:AddChild(countdown)

	advancedOptions[#advancedOptions + 1] = emphasizeGroup

	return unpack(advancedOptions)
end

local function advancedTabSelect(widget, callback, tab)
	if widget:GetUserData("tab") == tab then return end
	widget:SetUserData("tab", tab)
	widget:PauseLayout()
	widget:ReleaseChildren()
	local module = widget:GetUserData("module")
	local key = widget:GetUserData("key")
	local master = widget:GetUserData("master")

	if tab == "options" then
		widget:AddChildren(advancedToggles(key, module, master))
	elseif tab == "sounds" then
		local group = AceGUI:Create("SimpleGroup")
		group:SetFullWidth(true)
		widget:AddChild(group)
		soundModule:SetSoundOptions(module.name, key, module.db.profile[key])
		acd:Open("Big Wigs: Sounds Override", group)
	elseif tab == "colors" then
		local group = AceGUI:Create("SimpleGroup")
		group:SetFullWidth(true)
		widget:AddChild(group)
		colorModule:SetColorOptions(module.name, key, module.toggleDefaults[key])
		acd:Open("Big Wigs: Colors Override", group)
	end
	widget:ResumeLayout()
	widget:GetUserData("scrollFrame"):PerformLayout()
	widget:PerformLayout()
end

local advancedTabs = {
	{
		text = L.advanced,
		value = "options",
	},
	{
		text = L.colors,
		value = "colors",
	},
	{
		text = L.sound,
		value = "sounds",
	},
}

function getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc = BigWigs:GetBossOptionDetails(module, bossOption)
	local back = AceGUI:Create("Button")
	back:SetText(L.back)
	back:SetFullWidth(true)
	back:SetCallback("OnClick", function()
		showToggleOptions(dropdown, nil, dropdown:GetUserData("bossIndex"))
	end)
	local check = AceGUI:Create("CheckBox")
	check:SetLabel(colorize[name])
	check:SetTriState(true)

	check:SetFullWidth(true)
	check:SetDescription(desc)
	check:SetUserData("key", dbKey)
	check:SetUserData("scrollFrame", scrollFrame)
	check:SetUserData("dropdown", dropdown)
	check:SetUserData("module", module)
	check:SetUserData("option", bossOption)
	check:SetCallback("OnValueChanged", masterOptionToggled)
	check:SetValue(getMasterOption(check))

	-- Create role-specific secondary checkbox
	local roleRestrictionCheckbox = nil
	for i, key in next, BigWigs:GetRoleOptions() do
		local flag = C[key]
		if bit.band(module.toggleDefaults[dbKey], flag) == flag then
			local name, desc = BigWigs:GetOptionDetails(key)
			roleRestrictionCheckbox = getSlaveToggle(name, desc, dbKey, module, flag, check)
		end
	end

	local tabs = AceGUI:Create("TabGroup")
	tabs:SetLayout("Flow")
	tabs:SetTabs(advancedTabs)
	tabs:SetFullWidth(true)
	tabs:SetCallback("OnGroupSelected", advancedTabSelect)
	tabs:SetUserData("tab", "")
	tabs:SetUserData("key", dbKey)
	tabs:SetUserData("module", module)
	tabs:SetUserData("master", check)
	tabs:SetUserData("scrollFrame", scrollFrame)
	tabs:SelectTab("options")

	if roleRestrictionCheckbox then
		return back, check, roleRestrictionCheckbox, tabs
	else
		return back, check, tabs
	end
end

local function buttonClicked(widget)
	local scrollFrame = widget:GetUserData("scrollFrame")
	local dropdown = widget:GetUserData("dropdown")
	local module = widget:GetUserData("module")
	local bossOption = widget:GetUserData("bossOption")
	scrollFrame:ReleaseChildren()
	scrollFrame:AddChildren(getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption))
	scrollFrame:PerformLayout()
end

local function getDefaultToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc, icon = BigWigs:GetBossOptionDetails(module, bossOption)

	local check = AceGUI:Create("CheckBox")
	check:SetLabel(colorize[name])
	check:SetTriState(true)
	check:SetRelativeWidth(0.85)
	check:SetUserData("key", dbKey)
	check:SetUserData("module", module)
	check:SetUserData("option", bossOption)
	check:SetDescription(desc)
	check:SetCallback("OnValueChanged", masterOptionToggled)
	check:SetValue(getMasterOption(check))
	if type(icon) == "string" then check:SetImage(icon, 0.07, 0.93, 0.07, 0.93) end

	if type(dbKey) == "string" and dbKey:find("^custom_") then
		return check
	else
		local button = AceGUI:Create("Button")
		button:SetText(">>")
		button:SetRelativeWidth(0.15)
		-- userdata baby
		button:SetUserData("scrollFrame", scrollFrame)
		button:SetUserData("dropdown", dropdown)
		button:SetUserData("module", module)
		button:SetUserData("bossOption", bossOption)
		button:SetCallback("OnClick", buttonClicked)
		return check, button
	end
end

local listAbilitiesInChat = nil
do
	local SendChatMessage = loader.SendChatMessage
	local function output(channel, ...)
		if channel then
			SendChatMessage(strjoin(" ", ...), channel)
		else
			print(...)
		end
	end

	local function printList(channel, header, list)
		if #list == 0 then return end
		if header then output(channel, header, unpack(list))
		else output(channel, unpack(list)) end
	end

	function listAbilitiesInChat(widget)
		local module = widget:GetUserData("module")
		local channel = IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		local abilities = {}
		local header = nil
		output(channel, "Big Wigs: ", module.displayName or module.moduleName or module.name)
		local currentSize = 0
		for i, option in next, module.toggleOptions do
			local o = option
			if type(o) == "table" then o = option[1] end
			if module.optionHeaders and module.optionHeaders[o] then
				-- print what we have so far
				printList(channel, header, abilities)
				wipe(abilities)
				header = module.optionHeaders[o]
				currentSize = #header
			end
			if type(o) == "number" then
				if o > 0 then
					local link = GetSpellLink(o)
					if not link then
						BigWigs:Print(("Failed to fetch the link for spell id %d."):format(key))
					else
						if currentSize + #link + 1 > 255 then
							printList(channel, header, abilities)
							wipe(abilities)
							currentSize = 0
						end
						abilities[#abilities + 1] = link
						currentSize = currentSize + #link + 1
					end
				else
					local _, _, _, _, _, _, _, _, link = EJ_GetSectionInfo(-o)
					if currentSize + #link + 1 > 255 then
						printList(channel, header, abilities)
						wipe(abilities)
						currentSize = 0
					end
					abilities[#abilities + 1] = link
					currentSize = currentSize + #link + 1
				end
			end
		end
		printList(channel, header, abilities)
	end
end

local function SecondsToTime(time)
	local m = floor(time/60)
	local s = mod(time, 60)
	return ("%d:%02d"):format(m, s)
end

local function populateToggleOptions(widget, module)
	local scrollFrame = widget:GetUserData("parent")
	scrollFrame:ReleaseChildren()

	local sDB = BigWigsStatisticsDB
	if module.journalId and module.zoneId and BigWigs:GetPlugin("Statistics").db.profile.enabled and sDB and sDB[module.zoneId] and sDB[module.zoneId][module.journalId] then
		sDB = sDB[module.zoneId][module.journalId]

		if sDB.LFR or sDB.normal or sDB.heroic or sDB.mythic then -- Create NEW statistics table
			local statGroup = AceGUI:Create("InlineGroup")
			statGroup:SetTitle(L.statistics)
			statGroup:SetLayout("Flow")
			statGroup:SetFullWidth(true)
			scrollFrame:AddChild(statGroup)

			local statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.lfr)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.normal)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.heroic)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.mythic)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.wipes)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.LFR and sDB.LFR.wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.normal and sDB.normal.wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.heroic and sDB.heroic.wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.mythic and sDB.mythic.wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.kills)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.LFR and sDB.LFR.kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.normal and sDB.normal.kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.heroic and sDB.heroic.kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.mythic and sDB.mythic.kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.best)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.LFR and sDB.LFR.best and SecondsToTime(sDB.LFR.best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.normal and sDB.normal.best and SecondsToTime(sDB.normal.best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.heroic and sDB.heroic.best and SecondsToTime(sDB.heroic.best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(sDB.mythic and sDB.mythic.best and SecondsToTime(sDB.mythic.best) or "-")
			statGroup:AddChild(statistics)
		end -- End NEW statistics table

		---------------------------------------------------------------------------
		---------------------------------------------------------------------------
		---------------------------------------------------------------------------

		if sDB["25"] or sDB["25h"] or sDB["10"] or sDB["10h"] or sDB.lfr or sDB.flex then -- Create OLD statistics table
			local statGroup = AceGUI:Create("InlineGroup")
			statGroup:SetTitle(L.statistics)
			statGroup:SetLayout("Flow")
			statGroup:SetFullWidth(true)
			scrollFrame:AddChild(statGroup)

			local statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.norm25)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.heroic25)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.norm10)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.heroic10)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.lfr)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.flex)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.wipes)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["25"] and sDB["25"].wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["25h"] and sDB["25h"].wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["10"] and sDB["10"].wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["10h"] and sDB["10h"].wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB.lfr and sDB.lfr.wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB.flex and sDB.flex.wipes or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.kills)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["25"] and sDB["25"].kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["25h"] and sDB["25h"].kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["10"] and sDB["10"].kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["10h"] and sDB["10h"].kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB.lfr and sDB.lfr.kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB.flex and sDB.flex.kills or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(L.best)
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["25"] and sDB["25"].best and SecondsToTime(sDB["25"].best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["25h"] and sDB["25h"].best and SecondsToTime(sDB["25h"].best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["10"] and sDB["10"].best and SecondsToTime(sDB["10"].best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB["10h"] and sDB["10h"].best and SecondsToTime(sDB["10h"].best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB.lfr and sDB.lfr.best and SecondsToTime(sDB.lfr.best) or "-")
			statGroup:AddChild(statistics)

			statistics = AceGUI:Create("Label")
			statistics:SetWidth(77)
			statistics:SetText(sDB.flex and sDB.flex.best and SecondsToTime(sDB.flex.best) or "-")
			statGroup:AddChild(statistics)
		end -- End OLD statistics table
	end

	if module.SetupOptions then module:SetupOptions() end
	for i, option in next, module.toggleOptions do
		local o = option
		if type(o) == "table" then o = option[1] end
		if module.optionHeaders and module.optionHeaders[o] then
			local header = AceGUI:Create("Heading")
			header:SetText(module.optionHeaders[o])
			header:SetFullWidth(true)
			scrollFrame:AddChild(header)
		end
		scrollFrame:AddChildren(getDefaultToggleOption(scrollFrame, widget, module, option))
	end
	local list = AceGUI:Create("Button")
	list:SetFullWidth(true)
	list:SetText(L.listAbilities)
	list:SetUserData("module", module)
	list:SetCallback("OnClick", listAbilitiesInChat)
	scrollFrame:AddChild(list)
	scrollFrame:PerformLayout()
end

function showToggleOptions(widget, event, group)
	if widget:GetUserData("zone") then
		-- If we don't have any modules registered to the zone then "group" will be nil.
		-- In this case we skip this step and draw an empty panel.
		if group then
			local module = BigWigs:GetBossModule(group)
			widget:SetUserData("bossIndex", group)
			populateToggleOptions(widget, module)
		end
	else
		populateToggleOptions(widget, widget:GetUserData("module"))
	end
end

local function onZoneShow(frame)
	local zoneId = frame.id
	if zoneId then
		local instanceId = fakeWorldZones[zoneId] and zoneId or GetAreaMapInfo(zoneId)

		-- Make sure all the bosses for this zone are loaded.
		loader:LoadZone(instanceId)
	end

	-- Does this zone have a module list?
	local moduleList = loader:GetZoneMenus()[zoneId]

	-- This zone has no modules, nor is the panel related to a module.
	if not moduleList and not frame.module then
		error(("We wanted to show options for the zone %q, but it does not have any modules registered."):format(tostring(zoneId)))
		return
	end

	local zoneList, zoneSort = {}, {}
	if type(moduleList) == "table" then
		for i = 1, #moduleList do
			local module = moduleList[i]
			zoneList[module.moduleName] = module.displayName
			zoneSort[i] = module.moduleName
		end
	end

	local outerContainer = AceGUI:Create("SimpleGroup")
	outerContainer:PauseLayout()
	outerContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
	outerContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
	outerContainer:SetLayout("Fill")
	outerContainer:SetFullWidth(true)

	local innerContainer = nil
	if moduleList then
		innerContainer = AceGUI:Create("DropdownGroup")
		innerContainer:SetTitle(L.selectEncounter)
		innerContainer:SetLayout("Flow")
		innerContainer:SetCallback("OnGroupSelected", showToggleOptions)
		innerContainer:SetUserData("zone", zoneId)

		innerContainer:SetGroupList(zoneList, zoneSort)
	else
		innerContainer = AceGUI:Create("SimpleGroup")
		innerContainer:SetLayout("Fill")
		innerContainer:SetUserData("module", frame.module)
	end

	-- scroll is where we actually put stuff in case things
	-- overflow vertically
	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	innerContainer:SetUserData("parent", scroll)
	innerContainer:AddChild(scroll)

	outerContainer:AddChild(innerContainer)

	outerContainer:ResumeLayout()
	outerContainer:PerformLayout()

	-- Need to parent the AceGUI container to the actual
	-- zone panel frame so that the AceGUI container will
	-- show at all.
	outerContainer.frame:SetParent(frame)
	outerContainer.frame:Show()

	-- Need a reference to the outer container so that we can
	-- release all children when the zone panel is hidden.
	frame.container = outerContainer

	if moduleList then
		-- Find the first enabled module and select that in the
		-- dropdown if possible.
		local index = 1
		for i = 1, #zoneSort do
			local name = zoneSort[i]
			local m = BigWigs:GetBossModule(name)
			if m:IsEnabled() then
				index = i
				break
			end
		end
		innerContainer:SetGroup(zoneSort[index])
	else
		populateToggleOptions(innerContainer, frame.module)
	end
end

local function onZoneHide(frame)
	if frame.container then
		frame.container:ReleaseChildren()
		frame.container:Release()
		frame.container = nil
	end
end

do
	local addonNameToHeader = {
		BigWigs_Classic = "Big Wigs ".. EJ_GetTierInfo(1),
		BigWigs_BurningCrusade = "Big Wigs ".. EJ_GetTierInfo(2),
		BigWigs_WrathOfTheLichKing = "Big Wigs ".. EJ_GetTierInfo(3),
		BigWigs_Cataclysm = "Big Wigs ".. EJ_GetTierInfo(4),
		BigWigs_MistsOfPandaria = "Big Wigs ".. EJ_GetTierInfo(5),
		BigWigs_WarlordsOfDraenor = "Big Wigs |cFF62B1F6".. EJ_GetTierInfo(6) .."|r",
		LittleWigs = "Little Wigs",
	}

	local panels = {}
	local noop = function() end
	function options:GetPanel(zone, parent, zoneId, setScript)
		if parent and parent ~= "Big Wigs" and not panels[parent] then -- This zone doesn't have a parent panel, create it first
			self:GetPanel(parent, nil, nil, true)
		end
		if not panels[zone] then
			local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
			frame.name = zone
			frame.id = zoneId
			frame.parent = parent
			frame.addonname = "BigWigs"
			frame.okay = noop
			frame.cancel = noop
			frame.default = noop
			frame.refresh = noop
			frame:Hide()
			InterfaceOptions_AddCategory(frame)
			if setScript then
				frame:SetScript("OnShow", function(self)
					BigWigs:Enable()
					-- First we need to expand ourselves if collapsed.
					local p = findPanel(self.name)
					if p and p.element.collapsed then OptionsListButtonToggle_OnClick(p.toggle) end
					-- InterfaceOptionsFrameAddOns.buttons has changed here to include the zones
					-- if we were collapsed.
					-- So now we need to select the first zone.
					p = findPanel(nil, self.name)
					if p then
						InterfaceOptionsFrame_OpenToCategory(p.element.name)
						InterfaceOptionsFrame_OpenToCategory(p.element.name)
					end
				end)
			end

			panels[zone] = frame
			return panels[zone], true
		end
		return panels[zone]
	end

	function options:GetZonePanel(zoneId)
		local zoneName = translateZoneID(zoneId)
		local instanceId = fakeWorldZones[zoneId] and zoneId or GetAreaMapInfo(zoneId)
		local parent = loader.zoneTbl[instanceId] and addonNameToHeader[loader.zoneTbl[instanceId]] or addonNameToHeader.BigWigs_WarlordsOfDraenor
		local panel, justCreated = self:GetPanel(zoneName, parent, zoneId)
		if justCreated then
			panel:SetScript("OnShow", onZoneShow)
			panel:SetScript("OnHide", onZoneHide)
		end
		return panel
	end
end

do
	local registered, subPanelRegistry, pluginRegistry = {}, {}, {}
	function options:Register(message, moduleName, module)
		if registered[module.name] then return end
		registered[module.name] = true
		if module.pluginOptions then
			if type(module.pluginOptions) == "function" then
				pluginRegistry[module.name] = module.pluginOptions
			else
				acOptions.args.general.args[module.name] = module.pluginOptions
			end
		elseif module.subPanelOptions then
			local key = module.subPanelOptions.key
			local options = module.subPanelOptions.options
			if type(options) == "function" then
				subPanelRegistry[key] = options
			else
				acOptions.args[key] = options
			end
		end
	end

	function getOptions()
		for key, options in next, pluginRegistry do
			acOptions.args.general.args[key] = options()
		end
		for key, options in next, subPanelRegistry do
			acOptions.args[key] = options()
		end
		return acOptions
	end
end

BigWigsOptions = options -- Set global

