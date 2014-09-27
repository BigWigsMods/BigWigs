-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Super Emphasize")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
plugin.displayName = L.superEmphasize

local temporaryEmphasizes = {}
local emphasizeFlag = nil

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	upper = true,
	countdown = true,
	font = nil,
	outline = "THICKOUTLINE",
	fontSize = 32,
	fontColor = { r = 1, g = 0, b = 0 },
	disabled = false,
}

do
	local pluginOptions = nil
	function plugin:GetPluginConfig()
		if not pluginOptions then
			pluginOptions = {
				type = "group",
				get = function(info) return plugin.db.profile[info[#info]] end,
				set = function(info, value)
					plugin.db.profile[info[#info]] = value
					if plugin.anchorEmphasizedCountdownText then
						plugin.anchorEmphasizedCountdownText:SetFont(media:Fetch("font", plugin.db.profile.font), plugin.db.profile.fontSize, plugin.db.profile.outline ~= "NONE" and plugin.db.profile.outline)
					end
				end,
				disabled = function() return plugin.db.profile.disabled end,
				args = {

					heading = {
						type = "description",
						name = L.superEmphasizeDesc,
						order = 0.1,
						width = "full",
						--fontSize = "medium",
					},
					disabled = {
						type = "toggle",
						name = L.disabled,
						desc = L.superEmphasizeDisableDesc,
						order = 0.5,
						width = "full",
						disabled = false,
					},
					font = {
						type = "select",
						name = L.font,
						order = 1,
						values = media:List("font"),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, media:List("font") do
								if v == plugin.db.profile.font then return i end
							end
						end,
						set = function(info, value)
							local list = media:List("font")
							plugin.db.profile.font = list[value]
							if plugin.anchorEmphasizedCountdownText then
								plugin.anchorEmphasizedCountdownText:SetFont(media:Fetch("font", plugin.db.profile.font), plugin.db.profile.fontSize, plugin.db.profile.outline ~= "NONE" and plugin.db.profile.outline)
							end
						end,
					},
					outline = {
						type = "select",
						name = L.outline,
						order = 2,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						order = 3,
						max = 40,
						min = 8,
						step = 1,
						width = "full",
					},
					fontColor = {
						order = 4,
						type = "color",
						name = L.fontColor,
						get = function(info)
							return plugin.db.profile[info[#info]].r, plugin.db.profile[info[#info]].g, plugin.db.profile[info[#info]].b
						end,
						set = function(info, r, g, b)
							plugin.db.profile[info[#info]].r, plugin.db.profile[info[#info]].g, plugin.db.profile[info[#info]].b = r, g, b
							if plugin.anchorEmphasizedCountdownText then
								plugin.anchorEmphasizedCountdownText:SetTextColor(r, g, b)
							end
						end,
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 5,
					},
					newline = {
						type = "description",
						name = "\n",
						order = 5.5,
					},
					upper = {
						type = "toggle",
						name = L.uppercase,
						desc = L.uppercaseDesc,
						order = 6,
					},
					countdown = {
						type = "toggle",
						name = L.countdown,
						desc = L.countdownDesc,
						order = 7,
					},
				},
			}
		end
		return pluginOptions
	end
end

local function updateProfile()
	if not plugin.db.profile.font then
		plugin.db.profile.font = media:GetDefault("font")
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	emphasizeFlag = BigWigs.C.EMPHASIZE
	self:RegisterMessage("BigWigs_StartEmphasize")
	self:RegisterMessage("BigWigs_StopEmphasize")
	self:RegisterMessage("BigWigs_TempSuperEmphasize")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

do
	local timers = {}
	local function printEmph(num, text)
		PlaySoundFile(("Interface\\AddOns\\BigWigs\\Sounds\\%d.ogg"):format(num), "Master")
		plugin:SendMessage("BigWigs_EmphasizedCountdownMessage", num)
		if text and timers[text] then wipe(timers[text]) end
	end
	function plugin:BigWigs_StartEmphasize(_, module, text, time)
		if not self.db.profile.disabled and self.db.profile.countdown then
			self:BigWigs_StopEmphasize(nil, module, text)
			if time > 1.3 then
				if not timers[text] then timers[text] = {} end
				timers[text][1] = module:ScheduleTimer(printEmph, time-1.3, 1, text)
				if time > 2.3 then
					timers[text][2] = module:ScheduleTimer(printEmph, time-2.3, 2)
					if time > 3.3 then
						timers[text][3] = module:ScheduleTimer(printEmph, time-3.3, 3)
						if time > 4.3 then
							timers[text][4] = module:ScheduleTimer(printEmph, time-4.3, 4)
							if time > 5.3 then
								timers[text][5] = module:ScheduleTimer(printEmph, time-5.3, 5)
							end
						end
					end
				end
			end
		end
	end
	function plugin:BigWigs_StopEmphasize(_, module, text)
		if text and timers[text] and #timers[text] > 0 then
			for i = 1, #timers[text] do
				module:CancelTimer(timers[text][i])
			end
			wipe(timers[text])
		end
	end
end

function plugin:IsSuperEmphasized(module, key)
	if not module or not key or self.db.profile.disabled then return end
	if temporaryEmphasizes[key] and temporaryEmphasizes[key] > GetTime() then return true else temporaryEmphasizes[key] = nil end
	if type(key) == "number" and key > 0 then key = GetSpellInfo(key) end
	return module.db.profile[key] and bit.band(module.db.profile[key], emphasizeFlag) == emphasizeFlag or nil
end

function plugin:BigWigs_TempSuperEmphasize(_, module, key, text, time)
	if not module or not key or text == "" then return end
	temporaryEmphasizes[key] = GetTime() + time
	self:BigWigs_StartEmphasize(nil, module, text, time)
end

