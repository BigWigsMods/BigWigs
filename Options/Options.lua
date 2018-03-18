
local BigWigs = BigWigs
local options = BigWigs:NewModule("Options")
options:SetEnabledState(true)

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

local L = BigWigsAPI:GetLocale("BigWigs")

local icon = LibStub("LibDBIcon-1.0", true)
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local loader = BigWigsLoader
local API = BigWigsAPI
options.SendMessage = loader.SendMessage

local colorModule
local soundModule
local isOpen

local showToggleOptions, getAdvancedToggleOption = nil, nil

local getOptions
local acOptions = {
	type = "group",
	name = "BigWigs",
	get = function(info)
		return BigWigs.db.profile[info[#info]]
	end,
	set = function(info, value)
		local key = info[#info]
		BigWigs.db.profile[key] = value
		options:SendMessage("BigWigs_CoreOptionToggled", key, value)
	end,
	args = {
		general = {
			order = 20,
			type = "group",
			name = "BigWigs",
			args = {
				minimap = {
					type = "toggle",
					name = L.minimapIcon,
					desc = L.minimapToggle,
					order = 13,
					get = function() return not BigWigsIconDB.hide end,
					set = function(_, v)
						if v then
							BigWigsIconDB.hide = nil
							icon:Show("BigWigs")
						else
							BigWigsIconDB.hide = true
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
				gitHubTitle = {
					type = "description",
					name = "\n\n|cFFFED000GitHub:|r  |cFF74BBFBgithub.com/BigWigsMods|r  |cFFFED000Discord:|r  |cFF74BBFBdiscord.gg/jGveg85|r",
					fontSize = "large",
					order = 51,
					width = "full",
				},
				gitHubDesc = {
					type = "description",
					name = "\n".. L.gitHubDesc,
					fontSize = "medium",
					order = 52,
					width = "full",
				},
			},
		},
	},
}

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

		colorModule = BigWigs:GetPlugin("Colors")
		soundModule = BigWigs:GetPlugin("Sounds")
		acr:RegisterOptionsTable("BigWigs: Colors Override", colorModule:SetColorOptions("dummy", "dummy"), true)
		acr:RegisterOptionsTable("BigWigs: Sounds Override", soundModule:SetSoundOptions("dummy", "dummy"), true)

		f:UnregisterEvent("ADDON_LOADED")
		-- Wait with nilling, we don't know how many addons will load during this same execution.
		loader.CTimerAfter(5, function() f:SetScript("OnEvent", nil) end)
	end
	f:SetScript("OnEvent", Initialize)
end

function options:OnEnable()
	loader.RegisterMessage(self, "BigWigs_BossModuleRegistered", "Register")
	loader.RegisterMessage(self, "BigWigs_PluginRegistered", "Register")

	for name, module in BigWigs:IterateBossModules() do
		self:Register("BigWigs_BossModuleRegistered", name, module)
	end
	for name, module in BigWigs:IteratePlugins() do
		self:Register("BigWigs_PluginRegistered", name, module)
	end

	loader.RegisterMessage(self, "BigWigs_StartConfigureMode")
	loader.RegisterMessage(self, "BigWigs_StopConfigureMode")

	self.OnEnable = nil
end

function options:Open()
	if isOpen then
		isOpen:Hide()
	else
		options:OpenConfig()
	end
end

function options:IsOpen()
	return isOpen
end

-------------------------------------------------------------------------------
-- Plugin options
--

do
	local configMode = nil
	function options:InConfigureMode() return configMode end
	function options:BigWigs_StartConfigureMode()
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
		module.db.profile[key] = value or false
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
			elseif key == "VOICE" then
				if API:HasVoicePack() then
					local name, desc = BigWigs:GetOptionDetails(key)
					advancedOptions[#advancedOptions + 1] = getSlaveToggle(name, desc, dbKey, module, flag, check)
				end
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
		acd:Open("BigWigs: Sounds Override", group)
	elseif tab == "colors" then
		local group = AceGUI:Create("SimpleGroup")
		group:SetFullWidth(true)
		widget:AddChild(group)
		colorModule:SetColorOptions(module.name, key, module.toggleDefaults[key])
		acd:Open("BigWigs: Colors Override", group)
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
	local dbKey, name, desc, icon = BigWigs:GetBossOptionDetails(module, bossOption)
	local back = AceGUI:Create("Button")
	back:SetText(L.back)
	back:SetFullWidth(true)
	back:SetCallback("OnClick", function()
		showToggleOptions(dropdown, nil, dropdown:GetUserData("bossIndex"))
	end)
	local check = AceGUI:Create("CheckBox")
	check:SetLabel(colorize[name])
	if icon then check:SetImage(icon, 0.07, 0.93, 0.07, 0.93) end
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
			local roleName, roleDesc = BigWigs:GetOptionDetails(key)
			roleRestrictionCheckbox = getSlaveToggle(roleName, roleDesc, dbKey, module, flag, check)
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
	if icon then check:SetImage(icon, 0.07, 0.93, 0.07, 0.93) end

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
		output(channel, "BigWigs: ", module.displayName or module.moduleName or module.name)
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
						BigWigs:Print(("Failed to fetch the link for spell id %d."):format(o))
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
					local tbl = C_EncounterJournal.GetSectionInfo(-o)
					if not tbl or not tbl.link then
						BigWigs:Print(("Failed to fetch the link for journal id (-)%d."):format(-o))
					else
						local link = tbl.link
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
	scrollFrame:PauseLayout()

	local id = module.instanceId

	local sDB = BigWigsStatsDB
	if module.journalId and id and id > 0 and BigWigs:GetPlugin("Statistics").db.profile.enabled and sDB and sDB[id] and sDB[id][module.journalId] then
		sDB = sDB[id][module.journalId]

		if next(sDB) then -- Create statistics table
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
		end -- End statistics table
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
	scrollFrame:ResumeLayout()
	scrollFrame:PerformLayout()
end

function showToggleOptions(widget, event, group)
	local module = BigWigs:GetBossModule(group)
	widget:SetUserData("bossIndex", group)
	populateToggleOptions(widget, module)
end

local function onZoneShow(treeWidget, id)
	-- Make sure all the bosses for this zone are loaded.
	loader:LoadZone(id)

	-- Grab the module list from this zone
	local moduleList = loader:GetZoneMenus()[id]
	if type(moduleList) ~= "table" then return end -- No modules registered

	local zoneList, zoneSort = {}, {}
	for i = 1, #moduleList do
		local module = moduleList[i]
		zoneList[module.moduleName] = module.displayName
		zoneSort[i] = module.moduleName
	end

	local outerContainer = AceGUI:Create("SimpleGroup")
	outerContainer:PauseLayout() -- Stop drawing (improves performance) until we've added everything
	outerContainer:SetLayout("Fill")
	outerContainer:SetFullWidth(true)
	treeWidget:AddChild(outerContainer)

	local innerContainer = AceGUI:Create("DropdownGroup")
	innerContainer:SetTitle(L.selectEncounter)
	innerContainer:SetLayout("Flow")
	innerContainer:SetCallback("OnGroupSelected", showToggleOptions)
	innerContainer:SetUserData("zone", id)
	innerContainer:SetGroupList(zoneList, zoneSort)

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
	outerContainer:PerformLayout() -- Everything added, gogo

	-- Find the first enabled module and select that in the dropdown if possible.
	local index = 1
	for i = 1, #zoneSort do
		local name = zoneSort[i]
		local m = BigWigs:GetBossModule(name)
		if m:IsEnabled() and m.journalId then
			index = i
			break
		end
	end
	innerContainer:SetGroup(zoneSort[index])
	innerContainer:DoLayout() -- One last refresh to adjust height
end

do
	local expansionHeader = {
		"Classic",
		"BurningCrusade",
		"WrathOfTheLichKing",
		"Cataclysm",
		"MistsOfPandaria",
		"WarlordsOfDraenor",
		"Legion",
		"BattleForAzeroth"
	}

	local statusTable = {}
	local playerName = nil

	local function toggleAnchors()
		if not BigWigs:IsEnabled() then BigWigs:Enable() end
		if options:InConfigureMode() then
			options:SendMessage("BigWigs_StopConfigureMode")
		else
			options:SendMessage("BigWigs_StartConfigureMode")
			options:SendMessage("BigWigs_SetConfigureTarget", BigWigs:GetPlugin("Bars"))
		end
	end

	local GameTooltip = CreateFrame("GameTooltip", "BigWigsOptionsTooltip", UIParent, "GameTooltipTemplate")
	local function onControlEnter(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(widget.text:GetText(), 1, 0.82, 0, true)
		GameTooltip:AddLine(widget:GetUserData("desc"), 1, 1, 1, true)
		GameTooltip:Show()
	end

	local function onControlLeave()
		GameTooltip:Hide()
	end

	local function onTreeGroupSelected(widget, event, value)
		widget:ReleaseChildren()
		local zoneId = value:match("\001(-?%d+)$")
		if zoneId then
			onZoneShow(widget, tonumber(zoneId))
		elseif value:match("^BigWigs_") and value ~= "BigWigs_Legion" and GetAddOnEnableState(playerName, value) == 0 then
				local missing = AceGUI:Create("Label")
				missing:SetText(L.missingAddOn:format(value))
				missing:SetFontObject(GameFontHighlight)
				missing:SetFullWidth(true)
				widget:AddChild(missing)
		elseif value:match("^LittleWigs_") and GetAddOnEnableState(playerName, "LittleWigs") == 0 then
				local missing = AceGUI:Create("Label")
				missing:SetText(L.missingAddOn:format("LittleWigs"))
				missing:SetFontObject(GameFontHighlight)
				missing:SetFullWidth(true)
				widget:AddChild(missing)
		else
			statusTable.groups[value] = true
			widget:RefreshTree()
		end
	end

	local function onTabGroupSelected(widget, event, value)
		widget:ReleaseChildren()

		if value == "options" then
			-- Embed the AceConfig options in our AceGUI frame
			local container = AceGUI:Create("SimpleGroup")
			container.type = "BigWigsOptions" -- We want ACD to create a ScrollFrame, so we change the type to bypass it's group control check
			container:SetFullHeight(true)
			container:SetFullWidth(true)

			-- Have to use :Open instead of just :FeedGroup because some widget types (range, color) call :Open to refresh on change
			acd:Open("BigWigs", container)

			widget:AddChild(container)
		else
			local treeTbl = {}
			local addonNameToHeader = {}
			local defaultHeader
			if value == "bigwigs" then
				defaultHeader = C_ChatInfo and "BigWigs_BattleForAzeroth" or "BigWigs_Legion" -- XXX Temp
				for i = 1, C_ChatInfo and 8 or 7 do -- XXX Temp
					local value = "BigWigs_" .. expansionHeader[i]
					treeTbl[i] = {
						text = EJ_GetTierInfo(i),
						value = value,
						enabled = (value == defaultHeader or GetAddOnEnableState(playerName, value) > 0),
					}
					addonNameToHeader[value] = i
				end
			elseif value == "littlewigs" then
				defaultHeader =  C_ChatInfo and "LittleWigs_BattleForAzeroth" or "LittleWigs_Legion" -- XXX Temp
				local enabled = GetAddOnEnableState(playerName, "LittleWigs") > 0
				for i = 1,  C_ChatInfo and 8 or 7 do -- XXX Temp
					local value = "LittleWigs_" .. expansionHeader[i]
					treeTbl[i] = {
						text = EJ_GetTierInfo(i),
						value = value,
						enabled = enabled,
					}
					addonNameToHeader[value] = i
				end
			end

			do
				local zoneToId, alphabeticalZoneList = {}, {}
				for k in next, loader:GetZoneMenus() do
					local zone = k < 0 and GetMapNameByID(-k) or GetRealZoneText(k)
					if zone then
						if zoneToId[zone] then
							zone = zone .. "1" -- When instances exist more than once (Karazhan)
						end
						zoneToId[zone] = k
						alphabeticalZoneList[#alphabeticalZoneList+1] = zone
					end
				end

				sort(alphabeticalZoneList) -- Make alphabetical
				for i = 1, #alphabeticalZoneList do
					local zoneName = alphabeticalZoneList[i]
					local id = zoneToId[zoneName]

					local parent = loader.zoneTbl[id] and addonNameToHeader[loader.zoneTbl[id]] -- Get expansion number for this zone
					local treeParent = treeTbl[parent] -- Grab appropriate expansion name
					if treeParent and treeParent.enabled then -- third-party plugins can add empty zones if you don't have the expansion addon enabled
						if not treeParent.children then treeParent.children = {} end -- Create sub menu table
						tinsert(treeParent.children, { -- Add new instance/zone sub menu
							value = id,
							text = zoneName,
						})
					end
				end
			end

			local tree = AceGUI:Create("TreeGroup")
			tree:SetFullWidth(true)
			tree:SetFullHeight(true)
			tree:SetStatusTable(statusTable)
			tree:SetTree(treeTbl)
			tree:SetLayout("Fill")
			tree:SetCallback("OnGroupSelected", onTreeGroupSelected)

			-- Do we have content for the zone we're in? Then open straight to that zone.
			local id, parent
			if not IsInInstance() then
				local mapId = GetPlayerMapAreaID("player")
				if mapId then
					id = loader.zoneTblWorld[-mapId]
				else
					local _, _, _, _, _, _, _, instanceId = GetInstanceInfo()
					id = instanceId
				end
				parent = loader.zoneTbl[id] and addonNameToHeader[loader.zoneTbl[id]]
			else
				local _, _, _, _, _, _, _, instanceId = loader.GetInstanceInfo()
				id = instanceId
				parent = loader.zoneTbl[instanceId] and addonNameToHeader[loader.zoneTbl[instanceId]]
			end
			if parent then
				local moduleList = id and loader:GetZoneMenus()[id]
				local value = treeTbl[parent].value
				tree:SelectByValue(moduleList and ("%s\001%d"):format(value, id) or value)
			else
				tree:SelectByValue(defaultHeader)
			end

			widget:AddChild(tree)
		end
	end

	function options:OpenConfig()
		playerName = UnitName("player")

		local bw = AceGUI:Create("Frame")
		isOpen = bw
		bw:SetTitle("BigWigs")
		bw:SetStatusText(" "..loader:GetReleaseString())
		bw:SetWidth(858)
		bw:SetHeight(660)
		bw:EnableResize(false)
		bw:SetLayout("Flow")
		bw:SetCallback("OnClose", function(widget)
			AceGUI:Release(widget)
			wipe(statusTable)
			isOpen = nil
		end)

		local introduction = AceGUI:Create("Label")
		introduction:SetText(L.introduction)
		introduction:SetFontObject(GameFontHighlight)
		introduction:SetFullWidth(true)
		bw:AddChild(introduction)

		local anchors = AceGUI:Create("Button")
		anchors:SetText(L.toggleAnchorsBtn)
		anchors:SetUserData("desc", L.toggleAnchorsBtn_desc)
		anchors:SetRelativeWidth(0.5)
		anchors:SetCallback("OnClick", toggleAnchors)
		anchors:SetCallback("OnEnter", onControlEnter)
		anchors:SetCallback("OnLeave", onControlLeave)

		local testing = AceGUI:Create("Button")
		testing:SetText(L.testBarsBtn)
		testing:SetUserData("desc", L.testBarsBtn_desc)
		testing:SetRelativeWidth(0.5)
		testing:SetCallback("OnClick", BigWigs.Test)
		testing:SetCallback("OnEnter", onControlEnter)
		testing:SetCallback("OnLeave", onControlLeave)

		bw:AddChildren(anchors, testing)

		local tabs = AceGUI:Create("TabGroup")
		tabs:SetLayout("Flow")
		tabs:SetFullWidth(true)
		tabs:SetFullHeight(true)
		tabs:SetTabs({
			{ text = L.options, value = "options" },
			{ text = L.raidBosses, value = "bigwigs" },
			{ text = L.dungeonBosses, value = "littlewigs" },
		})
		tabs:SetCallback("OnGroupSelected", onTabGroupSelected)
		tabs:SelectTab("options")
		bw:AddChild(tabs)

		bw:Show()
	end
end

do
	local registered, subPanelRegistry, pluginRegistry = {}, {}, {}
	function options:Register(_, _, module)
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
			local opts = module.subPanelOptions.options
			if type(opts) == "function" then
				subPanelRegistry[key] = opts
			else
				acOptions.args[key] = opts
			end
		end
	end

	function getOptions()
		for key, opts in next, pluginRegistry do
			acOptions.args.general.args[key] = opts()
		end
		for key, opts in next, subPanelRegistry do
			acOptions.args[key] = opts()
		end
		return acOptions
	end
end

BigWigsOptions = options -- Set global
