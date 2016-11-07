-------------------------------------------------------------------------------
-- Plugin Prototype
-- @module PluginPrototype
-- @alias plugin

local core = BigWigs

local plugin = {}
core:GetModule("Plugins"):SetDefaultModulePrototype(plugin)

function plugin:Initialize()
	core:RegisterPlugin(self)
end

function plugin:OnEnable()
	if type(self.OnPluginEnable) == "function" then
		self:OnPluginEnable()
	end
	self:SendMessage("BigWigs_OnPluginEnable", self)
end

function plugin:OnDisable()
	if type(self.OnPluginDisable) == "function" then
		self:OnPluginDisable()
	end
	self:SendMessage("BigWigs_OnPluginDisable", self)
end

--- Module type check.
-- A module is either from BossPrototype or PluginPrototype.
-- @return nil
function plugin:IsBossModule() return end

do
	local UnitName = UnitName
	--- Get the full name of a unit.
	-- @string unit unit token or name
	-- @bool[opt] trimServer append * instead of the server name
	-- @return unit name with the server appended if appropriate
	function plugin:UnitName(unit, trimServer)
		local name, server = UnitName(unit)
		if not name then
			return
		elseif server and server ~= "" then
			name = name .. (trimServer and "*" or "-"..server)
		end
		return name
	end
end

do
	local raidList = {
		"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
		"raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
		"raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
		"raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
	}
	local partyList = {"player", "party1", "party2", "party3", "party4"}
	local GetNumGroupMembers, IsInRaid = GetNumGroupMembers, IsInRaid
	--- Iterate over your group.
	-- Automatically uses "party" or "raid" tokens depending on your group type.
	-- @return iterator
	function plugin:IterateGroup()
		local num = GetNumGroupMembers() or 0
		local i = 0
		local size = num > 0 and num+1 or 2
		local function iter(t)
			i = i + 1
			if i < size then
				return t[i]
			end
		end
		return iter, IsInRaid() and raidList or partyList
	end

	--- Get raid group unit tokens.
	-- @return indexed table of raid unit tokens
	function plugin:GetRaidList()
		return raidList
	end

	--- Get party unit tokens.
	-- @return indexed table of party unit tokens
	function plugin:GetPartyList()
		return partyList
	end
end

--- Force the options panel to update.
function plugin:UpdateGUI()
	local acr = LibStub("AceConfigRegistry-3.0", true)
	if acr then
		acr:NotifyChange("BigWigs")
	end
end

do
	local hexColors = {}
	local format, gsub = string.format, string.gsub
	local UnitClass = UnitClass
	for k, v in next, (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		hexColors[k] = format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	end
	local coloredNames = setmetatable({}, {__index =
		function(self, key)
			if key then
				local shortKey = gsub(key, "%-.+", "*") -- Replace server names with *
				local _, class = UnitClass(key)
				if class then
					local newKey = hexColors[class] .. shortKey .. "|r"
					self[key] = newKey
					return newKey
				else
					return shortKey
				end
			end
		end
	})

	--- Get a table that colors player names based on class.
	-- @return list of names colored by class with server names trimmed
	function plugin:GetColoredNameTable()
		return coloredNames
	end
end

do
	local SendAddonMessage, IsInGroup = BigWigsLoader.SendAddonMessage, IsInGroup
	local pName = UnitName("player")
	--- Send an addon sync to other players.
	-- @param msg the sync message/prefix
	-- @param[opt] extra other optional value you want to send
	-- @usage self:Sync("pluginName", data)
	function plugin:Sync(msg, extra)
		if msg then
			self:SendMessage("BigWigs_PluginComm", msg, extra, pName)
			if IsInGroup() then
				msg = "P^".. msg
				if extra then
					msg = msg .."^".. extra
				end
				SendAddonMessage("BigWigs", msg, IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
			end
		end
	end
end
