-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("General")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local FONT = LibSharedMedia.MediaType and LibSharedMedia.MediaType.FONT or "font"
local SOUND = LibSharedMedia.MediaType and LibSharedMedia.MediaType.SOUND or "sound"

local function refresh()
	plugin:SendMessage("BigWigs_ProfileUpdate")
end

local function fontOption(order, name, pluginName, dbKey)
	return {
		type = "select",
		name = name,
		order = order,
		width = "full",
		values = function() return LibSharedMedia:List(FONT) end,
		dialogControl = "SharedDropdown",
		itemControl = "DDI-Font",
		get = function()
			local db = BigWigs:GetPlugin(pluginName).db.profile
			for i, v in next, LibSharedMedia:List(FONT) do
				if v == db[dbKey] then return i end
			end
		end,
		set = function(_, value)
			BigWigs:GetPlugin(pluginName).db.profile[dbKey] = LibSharedMedia:List(FONT)[value]
			refresh()
		end,
	}
end

local function soundOption(order, name, dbKey)
	return {
		type = "select",
		name = name,
		order = order,
		width = "full",
		values = function() return LibSharedMedia:List(SOUND) end,
		dialogControl = "SharedDropdown",
		itemControl = "DDI-Sound",
		get = function()
			local media = BigWigs:GetPlugin("Sounds").db.profile.media
			for i, v in next, LibSharedMedia:List(SOUND) do
				if v == media[dbKey] then return i end
			end
		end,
		set = function(_, value)
			BigWigs:GetPlugin("Sounds").db.profile.media[dbKey] = LibSharedMedia:List(SOUND)[value]
			refresh()
		end,
	}
end

-------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	type = "group",
	name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Sliders:20|t ".. L.general,
	order = 0,
	args = {
		fonts = {
			type = "group",
			name = L.font,
			inline = true,
			order = 1,
			args = {
				bars = fontOption(1, L.bars, "Bars", "fontName"),
				messages = fontOption(2, L.messages, "Messages", "fontName"),
				messagesEmph = fontOption(3, L.messages .." (".. L.emphasized ..")", "Messages", "emphFontName"),
				countdown = fontOption(4, L.countdown, "Countdown", "fontName"),
			},
		},
		sounds = {
			type = "group",
			name = L.Sounds,
			inline = true,
			order = 2,
			args = {
				Alarm = soundOption(1, L.Alarm, "Alarm"),
				Alert = soundOption(2, L.Alert, "Alert"),
				Info = soundOption(3, L.Info, "Info"),
				Long = soundOption(4, L.Long, "Long"),
				Warning = soundOption(5, L.Warning, "Warning"),
			},
		},
	},
}
