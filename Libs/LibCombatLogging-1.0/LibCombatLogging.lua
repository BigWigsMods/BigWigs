local MAJOR, MINOR = "LibCombatLogging-1.0", 1
assert(LibStub, MAJOR .. " requires LibStub")

---@class LibCombatLogging @The core library table accessible by the library users to start, stop or get logging states. Add `---@type LibCombatLogging` where you import it to enable annotations.

---@class LibCombatLogging_AddOn @The addon handle is a unique string used to track your addon and it's used when printing state changes.

---@type LibCombatLogging
local Lib, PrevMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not Lib then return end

Lib._Logging = Lib._Logging or {} --- Internal `table` tracking active combat logging handles.
Lib._OrigLoggingCombat = Lib._OrigLoggingCombat or _G.LoggingCombat --- Reference to the original global API to start, stop and get combat log state.
Lib._Callbacks = Lib._Callbacks or LibStub("CallbackHandler-1.0"):New(Lib) -- Internal `table` tracking active callbacks to logging state changes.
Lib.CallbackEvents = Lib.CallbackEvents or {} -- Utility `table` over valid callback events.

local Logging = Lib._Logging
local OrigLoggingCombat = Lib._OrigLoggingCombat
local Callbacks = Lib._Callbacks
local CallbackEvents = Lib.CallbackEvents

CallbackEvents.STARTED_LOGGING = "STARTED_LOGGING"
CallbackEvents.STOPPED_LOGGING = "STOPPED_LOGGING"
CallbackEvents.ADDON_STARTED_LOGGING = "ADDON_STARTED_LOGGING"
CallbackEvents.ADDON_STOPPED_LOGGING = "ADDON_STOPPED_LOGGING"

local SLASH_COMBATLOG_NAME = "/combatlog"

--- Checks if the addon handle has logging enabled.
---@return boolean isLogging @`true` if the addon handle is logging, otherwise `false` if not.
---@param addon LibCombatLogging_AddOn
local function IsLogging(addon)
	return not not Logging[addon]
end

--- Counts how many addon handles have logging enabled.
---@return number numLoggers @Number of logging handles.
local function GetNumLogging()
	local c = 0
	for _, _ in pairs(Logging) do
		c = c + 1
	end
	return c
end

--- Returns a string of all the addon handles that are logging combat.
---@param excludeAddon LibCombatLogging_AddOn @Optional exception to exclude from the table, this would most likely be your own handle.
---@return string|nil @Example return could be `X`, or `X, Y and 2 undefined` or `nil` if nothing is currently logging combat.
local function GetLoggingAddOns(excludeAddon)
	local temp = {}
	local i = 0
	local undef = 0
	for k, _ in pairs(Logging) do
		if excludeAddon == nil or excludeAddon ~= k then
			if type(k) == "string" then
				i = i + 1
				temp[i] = k
			else
				undef = undef + 1
			end
		end
	end
	if i > 1 then
		table.sort(temp, function (a, b) return a > b end)
	end
	if undef > 0 then
		i = i + 1
		temp[i] = format("+%d undefined", undef)
	end
	if i > 0 then
		return table.concat(temp, ", ")
	end
end

--- Starts logging combat for the provided addon handle.
---@param addon LibCombatLogging_AddOn
---@return boolean @`true` indicates logging was successfully stopped, otherwise `false` if there is a queue issue and we need to retry.
local function StartLogging(addon)
	assert(type(addon) == "string", "LibCombatLogging.StartLogging(addon) expects addon to be a string.")
	local prev = Logging[addon]
	if prev == true then
		return true
	end
	local isFirst = prev ~= true and GetNumLogging() == 0
	if isFirst then
		OrigLoggingCombat(true)
	end
	if OrigLoggingCombat() == true then
		Logging[addon] = true
		if prev ~= true then
			Callbacks:Fire(CallbackEvents.ADDON_STARTED_LOGGING, addon)
			Callbacks:Fire(CallbackEvents.STARTED_LOGGING, addon)
		else
			Callbacks:Fire(CallbackEvents.STARTED_LOGGING)
		end
		return true
	end
	return false
end

--- Stops logging combat for the provided addon handle.
---@param addon LibCombatLogging_AddOn
---@return boolean @`true` indicates logging was successfully stopped, otherwise `false` if there is a queue issue and we need to retry.
local function StopLogging(addon)
	assert(type(addon) == "string", "LibCombatLogging.StopLogging(addon) expects addon to be a string.")
	local prev = Logging[addon]
	if prev ~= true then
		return true
	end
	local isLast = prev == true and GetNumLogging() == 1
	if isLast then
		OrigLoggingCombat(false)
	end
	if not isLast or OrigLoggingCombat() == false then
		Logging[addon] = nil
		if prev == true then
			Callbacks:Fire(CallbackEvents.ADDON_STOPPED_LOGGING, addon)
			Callbacks:Fire(CallbackEvents.STOPPED_LOGGING, addon)
		else
			Callbacks:Fire(CallbackEvents.STOPPED_LOGGING)
		end
		return true
	end
	return false
end

--- Similar to the original API for LoggingCombat, but you must provide an addon handle, then you can provide a new state, or omit and return the status for the addon handle.
--- ```
--- local addonName = ...
--- local LibCombatLogging = LibStub("LibCombatLogging-1.0")
--- local LoggingCombat = function(...) return LibCombatLogging.LoggingCombat(addonName, ...) end
--- ```
---@param addon LibCombatLogging_AddOn
---@param newstate boolean|nil @`true` to enable logging, `false` to disable, and `nil` to not change the state and only return logging state for the addon handle.
---@return boolean|nil isLogging @`true` if the addon handle is logging, otherwise `false` if not. `nil` would mean that the start/stop state change was attempted, but the API is not in a state to apply it, so you need to retry again later.
---@return number numLoggers @Number of logging handles.
local function LoggingCombat(addon, newstate)
	assert(type(addon) == "string", "LibCombatLogging.LoggingCombat(addon[, newstate]) expects addon to be a string.")
	local success = true
	if newstate then
		success = StartLogging(addon)
	elseif newstate ~= nil then
		success = StopLogging(addon)
	end
	local count = GetNumLogging()
	if not success then
		return nil, count
	end
	return IsLogging(addon), count
end

--- A crude implementation, it's not recommended that you use this, instead please look at the `LoggingCombat` function with a more proper example how to implement this library in your addon. I'm adding this for completeness but please do not use this code:
--- ```
--- local LibCombatLogging = LibStub("LibCombatLogging-1.0")
--- local LoggingCombat = LibCombatLogging.WrapLoggingCombat
--- ```
local function WrapLoggingCombat(...)
	local addon
	local stack = debugstack(3)
	if stack then
		stack = {strsplit("[\r\n]", stack)}
		for i = #stack, 1, -1 do
			local text = stack[i]
			addon = text:match("[\\/]-[Aa][Dd][Dd][Oo][Nn][Ss][\\/]-([^\\/]+)[\\/]-")
			if addon then
				break
			end
		end
	end
	return LoggingCombat(addon or SLASH_COMBATLOG_NAME, ...)
end

--- Override /combatlog to use our library so we can track the default interface state
function SlashCmdList.COMBATLOG(msg)
	local addon = SLASH_COMBATLOG_NAME
	if LoggingCombat(addon) then
		LoggingCombat(addon, false)
	else
		LoggingCombat(addon, true)
	end
end

--- On start and stop events print the appropriate text in the chat to inform the user about what is going on
do

	local function OnEvent(event, addon, ...)
		local info = ChatTypeInfo.SYSTEM
		if event == CallbackEvents.ADDON_STARTED_LOGGING then
			local otherAddons = GetLoggingAddOns(addon)
			local suffix = otherAddons and " (" .. otherAddons .. " also logging)" or ""
			local prefix = addon == SLASH_COMBATLOG_NAME and "" or (type(addon) == "string" and "|cffFFFFFF" .. addon .. "|r: " or "")
			DEFAULT_CHAT_FRAME:AddMessage(prefix .. COMBATLOGENABLED .. suffix, info.r, info.g, info.b, info.id)
		elseif event == CallbackEvents.ADDON_STOPPED_LOGGING then
			local otherAddons = GetLoggingAddOns(addon)
			local suffix = otherAddons and " (" .. otherAddons .. " still logging)" or ""
			local prefix = addon == SLASH_COMBATLOG_NAME and "" or (type(addon) == "string" and "|cffFFFFFF" .. addon .. "|r: " or "")
			DEFAULT_CHAT_FRAME:AddMessage(prefix .. COMBATLOGDISABLED .. suffix, info.r, info.g, info.b, info.id)
		elseif event == CallbackEvents.STARTED_LOGGING then
			if not addon then
				DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGENABLED, info.r, info.g, info.b, info.id)
			end
		elseif event == CallbackEvents.STOPPED_LOGGING then
			if not addon then
				DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGDISABLED, info.r, info.g, info.b, info.id)
			end
		end
	end

	Lib.RegisterCallback(Callbacks, CallbackEvents.ADDON_STARTED_LOGGING, OnEvent)
	Lib.RegisterCallback(Callbacks, CallbackEvents.ADDON_STOPPED_LOGGING, OnEvent)
	Lib.RegisterCallback(Callbacks, CallbackEvents.STARTED_LOGGING, OnEvent)
	Lib.RegisterCallback(Callbacks, CallbackEvents.STOPPED_LOGGING, OnEvent)

end

-- Public API
Lib.IsLogging = IsLogging
Lib.GetNumLogging = GetNumLogging
Lib.GetLoggingAddOns = GetLoggingAddOns
Lib.StartLogging = StartLogging
Lib.StopLogging = StopLogging
Lib.LoggingCombat = LoggingCombat
-- Lib.WrapLoggingCombat = WrapLoggingCombat

--[[ DEBUG:
_G.LoggingCombat = WrapLoggingCombat -- dangerous, but nice for debugging all combat logging addons that are running, as it forces everyone that calls the global API through our library
--]]