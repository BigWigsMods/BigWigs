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

local temporaryEmphasizes = {}
local emphasizeFlag = nil

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	upper = true,
	countdown = true,
	font = "Friz Quadrata TT",
	outline = "THICKOUTLINE",
	fontSize = 32,
	fontColor = { r = 1, g = 0, b = 0 },
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
						plugin.anchorEmphasizedCountdownText:SetFont(media:Fetch("font", plugin.db.profile.font), plugin.db.profile.fontSize, plugin.db.profile.outline)
					end
				end,
				args = {
					heading = {
						type = "description",
						name = L.superEmphasizeDesc,
						order = 0.1,
						width = "full",
						--fontSize = "medium",
					},
					font = {
						type = "select",
						name = L["Font"],
						order = 1,
						values = media:List("font"),
						get = function()
							for i, v in next, media:List("font") do
								if v == plugin.db.profile.font then return i end
							end
						end,
						set = function(info, value)
							local list = media:List("font")
							plugin.db.profile.font = list[value]
							if plugin.anchorEmphasizedCountdownText then
								plugin.anchorEmphasizedCountdownText:SetFont(media:Fetch("font", plugin.db.profile.font), plugin.db.profile.fontSize, plugin.db.profile.outline)
							end
						end,
					},
					outline = {
						type = "select",
						name = L["Outline"],
						order = 2,
						values = {
							NONE = L["None"],
							OUTLINE = L["Thin"],
							THICKOUTLINE = L["Thick"],
						},
						get = function()
							return plugin.db.profile.outline or "NONE"
						end,
						set = function(info, value)
							if value == "NONE" then value = nil end
							plugin.db.profile[info[#info]] = value
							if plugin.anchorEmphasizedCountdownText then
								plugin.anchorEmphasizedCountdownText:SetFont(media:Fetch("font", plugin.db.profile.font), plugin.db.profile.fontSize, plugin.db.profile.outline)
							end
						end,
					},
					fontSize = {
						type = "range",
						name = L["Font size"],
						order = 3,
						max = 40,
						min = 8,
						step = 1,
						width = "full",
					},
					fontColor = {
						order = 4,
						type = "color",
						name = L["Font color"],
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
						name = L["Monochrome"],
						desc = L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."],
						order = 5,
					},
					newline = {
						type = "description",
						name = "\n",
						order = 5.5,
					},
					upper = {
						type = "toggle",
						name = L["UPPERCASE"],
						desc = L["Uppercases all messages related to a super emphasized option."],
						order = 6,
					},
					countdown = {
						type = "toggle",
						name = L["Countdown"],
						desc = L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."],
						order = 7,
					},
				},
			}
		end
		return pluginOptions
	end
end
-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	emphasizeFlag = BigWigs.C.EMPHASIZE
end

function plugin:IsSuperEmphasized(module, key)
	if not module or not key then return end
	if temporaryEmphasizes[key] then return true end
	if type(key) == "number" then key = GetSpellInfo(key) end
	return module.db.profile[key] and bit.band(module.db.profile[key], emphasizeFlag) == emphasizeFlag or nil
end

local function endEmphasize(module, key)
	temporaryEmphasizes[key] = nil
	plugin:SendMessage("BigWigs_SuperEmphasizeEnd", module, key)
end

function plugin:Emphasize(module, key, timeSpan)
	if not module or not key then return end
	temporaryEmphasizes[key] = true
	self:ScheduleTimer(endEmphasize, timeSpan, module, key)
	self:SendMessage("BigWigs_SuperEmphasizeStart", module, key, timeSpan)
end

