
-- Script to parse boss module files and output ability=>color/sound mappings

local loadstring = loadstring or load -- 5.2 compat

local opt = {}

local visited_files = {}
local modules = {}
local modules_bosses = {}
local modules_locale = {}

local module_colors = {}
local module_sounds = {}
local options_path, options_file_name = nil, nil

local default_options = {
	altpower = {ALTPOWER = true},
	infobox = {INFOBOX = true},
	proximity = {PROXIMITY = true},
}
local valid_colors = {
	green = true,
	blue = true,
	yellow = true,
	orange = true,
	red = true,
	cyan = true,
	purple = true,
}
local valid_sounds = {
	info = true,
	alert = true,
	alarm = true,
	long = true,
	warning = true,
	underyou = true,
}
local color_methods = {
	MessageOld = 2,
	Message = 2,
	TargetMessageOld = 3,
	TargetMessage = 2,
	TargetsMessageOld = 2,
	TargetsMessage = 2,
	StackMessageOld = 4,
	StackMessage = 2,
	DelayedMessage = 3,
}
local sound_methods = {
	PlaySound = 2,
	MessageOld = 3,
	SetPrivateAuraSound = 3,
	TargetMessageOld = 4,
	StackMessageOld = 5,
	DelayedMessage = 6,
}
local icon_methods = {
	MessageOld = 5,
	Message = 4,
	TargetMessageOld = 6,
	TargetMessage = 5,
	TargetsMessageOld = 6,
	TargetsMessage = 6,
	StackMessageOld = 7,
	StackMessage = 7,
	PersonalMessage = 4,
	Bar = 4,
	CDBar = 4,
	CastBar = 4,
	TargetBar = 5,
	Flash = 2,
}
local removed_methods = {
	Message2 = true,
	TargetMessage2 = true,
	Yell2 = true,
	NameplateBar = true,
	NameplateCDBar = true,
	StopNameplateBar = true,
	SetPrivateAuraSound = true,
}
local valid_methods = {
	CastBar = "CASTBAR",
	PrimaryIcon = "ICON",
	SecondaryIcon = "ICON",
	Flash = "FLASH",
	Say = "SAY",
	SayCountdown = "SAY_COUNTDOWN",
	CancelSayCountdown = "SAY_COUNTDOWN",
	Yell = "SAY",
	YellCountdown = "SAY_COUNTDOWN",
	CancelYellCountdown = "SAY_COUNTDOWN",
	OpenAltPower = "ALTPOWER",
	CloseAltPower = "ALTPOWER",
	OpenProximity = "PROXIMITY",
	CloseProximity = "PROXIMITY",
	OpenInfo = "INFOBOX",
	SetInfoByTable = "INFOBOX",
	SetInfoTitle = "INFOBOX",
	SetInfo = "INFOBOX",
	SetInfoBar = "INFOBOX",
	CloseInfo = "INFOBOX",
	Nameplate = "NAMEPLATE",
	StopNameplate = "NAMEPLATE",
	PauseBar = true,
	ResumeBar = true,
}
local tracked_bitflags = {
	["CASTBAR"] = true,
	["ICON"] = true,
	["FLASH"] = true,
	["SAY"] = true,
	["SAY_COUNTDOWN"] = true,
	["ALTPOWER"] = true,
	["PROXIMITY"] = true,
	["INFOBOX"] = true,
	["NAMEPLATE"] = true,
}
local function add_valid_methods(t)
	for k in next, t do
		if not valid_methods[k] then
			valid_methods[k] = true
		end
	end
end
add_valid_methods(color_methods)
add_valid_methods(sound_methods)
add_valid_methods(icon_methods)
add_valid_methods(removed_methods)

local log_events = {
	["SWING_DAMAGE"] = true,
	["SWING_MISSED"] = true,
	["RANGE_DAMAGE"] = true,
	["RANGE_MISSED"] = true,
	["SPELL_ABSORBED"] = true,
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_APPLIED_DOSE"] = true,
	["SPELL_AURA_BROKEN"] = true,
	["SPELL_AURA_BROKEN_SPELL"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_REMOVED"] = true,
	["SPELL_AURA_REMOVED_DOSE"] = true,
	["SPELL_CAST_FAILED"] = true,
	["SPELL_CAST_START"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_CREATE"] = true,
	["SPELL_DAMAGE"] = true,
	["SPELL_DISPEL"] = true,
	["SPELL_DISPEL_FAILED"] = true,
	["SPELL_DRAIN"] = true,
	["SPELL_DURABILITY_DAMAGE"] = true,
	["SPELL_DURABILITY_DAMAGE_ALL"] = true,
	["SPELL_ENERGIZE"] = true,
	["SPELL_EXTRA_ATTACKS"] = true,
	["SPELL_HEAL"] = true,
	["SPELL_INSTAKILL"] = true,
	["SPELL_INTERRUPT"] = true,
	["SPELL_LEECH"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_RESURRECT"] = true,
	["SPELL_STOLEN"] = true,
	["SPELL_SUMMON"] = true,
	["SPELL_PERIODIC_DAMAGE"] = true,
	["SPELL_PERIODIC_DRAIN"] = true,
	["SPELL_PERIODIC_ENERGIZE"] = true,
	["SPELL_PERIODIC_HEAL"] = true,
	["SPELL_PERIODIC_LEECH"] = true,
	["SPELL_PERIODIC_MISSED"] = true,
	["SPELL_BUILDING_DAMAGE"] = true,
	["SPELL_BUILDING_HEAL"] = true,
	["SPELL_EMPOWER_START"] = true,
	["SPELL_EMPOWER_END"] = true,
	["SPELL_EMPOWER_INTERRUPT"] = true,
	["ENVIRONMENTAL_DAMAGE"] = true,
	["DAMAGE_SHIELD"] = true,
	["DAMAGE_SHIELD_MISSED"] = true,
	["DAMAGE_SPLIT"] = true,
	["PARTY_KILL"] = true,
	["UNIT_DIED"] = true,
	["UNIT_DESTROYED"] = true,
	["UNIT_DISSIPATES"] = true,
}

local standard_args_keys = {
	time = true,
	sourceGUID = true,
	sourceName = true,
	sourceFlags = true,
	sourceRaidFlags = true,
	destGUID = true,
	destName = true,
	destFlags = true,
	destRaidFlags = true,
	spellId = true,
	spellName = true,
	spellSchool = true,
	extraSpellId = true,
	extraSpellName = true,
	amount = true,
}

local unit_died_args_keys = {
	mobId = true,
	destGUID = true,
	destName = true,
	destFlags = true,
	destRaidFlags = true,
	time = true,
}

-- Set an exit code if we show an error.
local exit_code = 0
local error, warn, info
if os.execute("tput colors >/dev/null 2>&1") then
	function error(msg)
		print("\27[31m" .. msg .. "\27[0m") -- red
		exit_code = 1
	end
	function warn(msg)
		print("\27[33m" .. msg .. "\27[0m") -- orange
	end
	function info(msg)
		print("\27[36m" .. msg .. "\27[0m") -- cyan
	end
else
	function error(msg)
		print(msg)
		exit_code = 1
	end
	warn = print
	info = print
end
local function print(...)
	if opt.quiet then return end
	_G.print(...)
end

-- visit a file, return true if the file has already been parsed
local function visit(file)
	if visited_files[file] then
		return true
	end
	visited_files[file] = true
end

-- Return a table containing the value if value is not a table.
local function tablize(value)
	if type(value) ~= "table" then
		value =  { value }
	end
	return value
end

-- Remove outer quotes.
local function unquote(str)
	if type(str) == "string" then
		return str:match("^%s*\"(.-)\"%s*$") or str
	end
	return str
end

-- Break apart and/or assignments and return the conditional results.
local function unternary(str, pattern, validate_table)
	if type(str) == "string" then
		local matches = {}
		for m in str:gmatch(" and "..pattern) do
			if not validate_table or validate_table[m] then
				matches[#matches+1] = m
			end
		end
		for m in str:gmatch(" or "..pattern) do
			if not validate_table or validate_table[m] then
				matches[#matches+1] = m
			end
		end
		if #matches > 0 then
			return matches
		end
	end
	return str
end

local function contains(t, v)
	for _, value in next, t do
		if value == v then
			return true
		end
	end
	return false
end

-- Removes some things that break simple comma splitting.
local function clean(str)
	-- :Dispeller() || :format() || UnitIsUnit()
	str = str:gsub("(:?%a+)%b()", "%1")
	return str
end

-- Strip whitespace from the start and end of a string.
local function strtrim(str)
	return str:match("^%s*(.-)%s*$")
end

-- Split a string at commas and return a table with the results.
local function strsplit(str)
	local t = {}
	str:gsub("([^,]+)", function(s) t[#t+1] = strtrim(s) end)
	return t
end

local function cmp(a, b)
	if type(a) == "number" and type(b) == "number" then
		return a < b
	end
	return string.lower(a) < string.lower(b)
end

local function sortKeys(keys)
	local t = {}
	for key in next, keys do
		t[#t+1] = key
	end
	table.sort(t, cmp)
	return t
end

local function buildOptionString(data, mod, option_type, options_table)
	local options = options_table[mod] or {}
	data = data .. string.format("\r\nBigWigs:Add%s(%q, {\r\n", option_type, mod)
	for _, key in ipairs(sortKeys(options)) do
		local values = options[key]
		if type(key) == "string" then key = string.format("%q", key) end
		if #values == 1 then
			data = data .. string.format("\t[%s] = %q,\r\n", key, values[1])
		else
			table.sort(values, cmp)
			for i = 1, #values do
				values[i] = string.format("%q", values[i])
			end
			data = data .. string.format("\t[%s] = {%s},\r\n", key, table.concat(values, ","))
		end
	end
	data = data .. "})\r\n"
	return data
end

-- Write out module option values to !Options.lua (or any defined !Options file)
local function dumpValues(path, fileName, modules_table, colors_table, sounds_table)
	local file = path .. fileName
	local old_data = ""
	local f = io.open(file, "r")
	if f then
		old_data = f:read("*all")
		f:close()
	end

	-- XXX temp cleanup old files
	local modulesFile = path .. "modules.xml"
	f = io.open(modulesFile, "r")
	if f then
		local modulesfile_data = f:read("*all")
		f:close()
		if modulesfile_data:find('<Include file="Options\\options.xml"/>') then
			-- remove old files
			local oldOptionsFile = path .. "Options\\Options.xml"
			local oldSoundFile = path .. "Options\\Sounds.lua"
			local oldColorsFile = path .. "Options\\Colors.lua"
			os.remove(oldOptionsFile)
			os.remove(oldSoundFile)
			os.remove(oldColorsFile)
			-- update path to new file
			modulesfile_data = modulesfile_data:gsub('<Include file="Options\\options.xml"/>', '<Script file="!Options.lua"/>')
			f = io.open(modulesFile, "w")
			f:write(modulesfile_data)
			f:close()
		end
	end
	-- XXX end temp

	local data = "-- This file is automatically generated for packaged releases. Changes made here are only relevant when running from source.\r\n"
	for _, mod in ipairs(modules_table) do
		data = buildOptionString(data, mod, "Colors", colors_table)
		data = buildOptionString(data, mod, "Sounds", sounds_table)
	end

	if data:gsub("\r", "") ~= old_data:gsub("\r", "") then
		if not opt.dryrun then
			f = io.open(file, "wb")
			if not f then
				error(string.format("    %s: File not found!", file))
			else
				f:write(data)
				f:close()
				info("    Updated " .. file)
			end
		else
			info("    Updated " .. file .. " (skipped)")
		end
	end
end


local function add(module_name, option_table, keys, value)
	if not option_table[module_name] then
		option_table[module_name] = {}
	end
	for _, key in next, tablize(keys) do
		key = tonumber(key) or key
		if not option_table[module_name][key] then
			option_table[module_name][key] = {}
		end
		-- Only add once per key.
		local found = nil
		for _, v in next, option_table[module_name][key] do
			if value == v then
				found = true
				break
			end
		end
		if not found then
			table.insert(option_table[module_name][key], value)
		end
	end
end

local function findCalls(lines, start, local_func, options)
	local keys = {}
	local func, if_key = nil, nil
	for i = start+1, #lines do
		local line = lines[i]:gsub("%s*%-%-.+$", "") -- strip out comments
		local res = line:match("^%s*function%s+[%w_]+[.:]([%w_]+)%s*%(")
		if res then
			func = res
			if_key = nil
		end
		res = line:match("^%s*local function%s+([%w_]+)%s*%(")
		if res then
			func = nil
			if_key = nil
			if res == local_func then
				-- redefined?! we shouldn't be here...
				break
			end
		end
		res = line:match("if (.+) then")
		if res and line:match("spellId == %d+") then
			if_key = {}
			for m in res:gmatch("spellId == (%d+)") do
				if_key[#if_key+1] = m
			end
		end
		if func then -- make sure we're out of the local function
			if line:match(":ScheduleTimer%(%s*"..local_func.."%s*,") or
				 line:match(":ScheduleRepeatingTimer%(%s*"..local_func.."%s*,") or
				 line:match("^%s*"..local_func.."%s*%(")
			then
				if func and options[func] then
					for _, k in next, options[func] do
						keys[#keys+1] = k
					end
				end
				if if_key then
					for _, k in next, if_key do
						keys[#keys+1] = k
					end
				end
				func, if_key = nil, nil
			end
		end
	end
	return #keys > 0 and keys or nil
end

local function parseGetOptions(file_name, lines, start, special_options)
	local chunk = nil
	for i = start, #lines do
		if i == start and lines[i]:match("^%s*return {.+}%s*$") then
			-- old style one line options
			chunk = lines[i]
			break
		end
		-- if lines[i]:match("^%s*},%s*{") or lines[i]:match("^%s*},%s*nil,%s*{") then
		-- 	-- we don't want to parse headers or altnames (to avoid setfenv) so stop here
		-- 	chunk = table.concat(lines, "\n", start, i-1) .. "\n}"
		-- 	-- TODO string parse the other tables for duplicates
		-- 	break
		-- -- end
		-- if lines[i]:match("^%s*end") then
		-- 	chunk = table.concat(lines, "\n", start, i-1) -- no headers, so we need to back up to the }
		-- 	break
		-- end
		if lines[i]:match("^%s*}%s*$") then
			chunk = table.concat(lines, "\n", start, i)
			break
		end
	end
	if not chunk or chunk == "" then
		return false, "Something is wrong."
	end

	local chunk_func
	do
		-- sigh.
		local s = setmetatable({}, { __index = function(t, k) return tostring(k) end })
		local mod = {
			SpellName = function(k) return tostring(k) end
		}
		local options_env = setmetatable({
			CL = s,
			L = s,
			self = mod,
			mod = mod,
		}, {
			__index = function(t, k)
				if special_options[k] then return "custom_off_" .. k end
				return k
			end
		})

		if setfenv then
			local f, err = loadstring(chunk, "optionstable")
			if err then
				return false, err
			end
			setfenv(f, options_env)
			chunk_func = f
		else
			local f, err = load(chunk, "optionstable", "t", options_env)
			if err then
				return false, err
			end
			chunk_func = f
		end
	end
	local success, toggles, headers, altNames = pcall(chunk_func)
	if not success then
		return success, toggles
	end

	local options, option_flags = {}, {}
	for _, entry in next, toggles do
		local flags = true
		if type(entry) == "table" then
			flags = {}
			for i=2, #entry do
				flags[entry[i]] = true
			end
			entry = entry[1]
		end
		if entry then -- marker option vars will be nil
			if default_options[entry] then
				flags = default_options[entry]
			end
			if options[entry] then
				error(string.format("    %s:%d: Duplicate option key %q", file_name, start, tostring(entry)))
			else
				options[entry] = flags
			end
		end
	end
	if headers then
		for key in next, headers do
			if not options[key] then
				error(string.format("    %s:%d: Invalid option header key %q", file_name, start, tostring(key)))
			end
		end
	end
	if altNames then
		for key, name in next, altNames do
			if not options[key] then
				error(string.format("    %s:%d: Invalid option alt name key %q", file_name, start, tostring(key)))
			end
		end
	end
	return options
end

local function checkForAPI(line)
	for method in next, valid_methods do
		if line:find(method, nil, true) then
			return true
		end
	end
	return false
end

-- check that all module keys are defined in the locale file
local function reverseCheck(file, keys, current_module, current_module_line)
	if current_module and modules_locale[current_module] then
		for key, value in next, modules_locale[current_module] do
			if value and not key:match("_icon$") and keys[current_module][key] == nil then
				warn(string.format("    %s:%d: %s: Missing locale key %q", file, current_module_line, current_module, key))
			end
		end
	end
end

local function parseLocale(file)
	-- check if this file has already been visited
	if visit(file) then
		return
	end

	-- determine which locale this file is named for based on the file name
	local file_locale = file:match("Locales/(.-)%.lua$")
	if not file_locale then
		error(string.format("    %s: Unable to determine locale from file name!", file))
		return
	end
	file_locale = file_locale:gsub("^.*%.", "") -- Extract what locale this file should be from files with the naming structure of xyz.enUS
	file_locale = file_locale:gsub("^(%l%l%u%u)_.*$", "%1") -- Extract what locale this file should be from files with the naming structure of enUS_xyz

	-- open the file
	local f = io.open(file, "r")
	if not f then
		error(string.format("    \"%s\" not found!", file))
		return
	end

	-- read the file
	local data = f:read("*all")
	f:close()

	-- validate the file line by line
	local keys = {}
	local current_module, current_module_line
	local line_number = 0
	for line in data:gmatch("(.-)\r?\n") do
		line_number = line_number + 1

		-- check for a new locale block in the locale file, and parse out the module name and locale from the block
		local module_name, locale
		if file_locale == "esES" then
			-- special handling for combined esES and esMX locales
			local module_name2, locale2
			module_name, locale, module_name2, locale2 = line:match("L = BigWigs:NewBossLocale%(\"(.-)\", \"(.-)\"%) or BigWigs:NewBossLocale%(\"(.-)\", \"(.-)\"%)")
			if module_name then
				-- Check :NewBossLocale args
				if module_name ~= module_name2 then
					error(string.format("    %s:%d: Module name mismatch! %q != %q", file, line_number, module_name, module_name2))
				end
				if locale2 ~= "esMX" then
					error(string.format("    %s:%d: Invalid locale! %q should be %q", file, line_number, locale2, "esMX"))
				end
			end
		end
		if not module_name then
			-- standard parsing for single-locale files
			module_name, locale = line:match("L = BigWigs:NewBossLocale%(\"(.-)\", \"(.-)\"%)")
			if not module_name then
				module_name, locale = line:match("L = BigWigsAPI:NewLocale%(\"(.-)\", \"(.-)\"%)")
			end
		end

		-- if we found the start of a new locale block
		if module_name then
			-- reverse check the previous locale block in the file
			reverseCheck(file, keys, current_module, current_module_line)
			-- update state for the new locale block
			current_module = module_name
			current_module_line = line_number
			if not keys[module_name] then
				keys[module_name] = {}
			else
				error(string.format("    %s:%d: Duplicate module name %q", file, line_number, module_name))
			end
			-- Save base keys for non-boss locales
			if file_locale == "enUS" then
				modules_locale[module_name] = keys[module_name]
			end
			-- Check API args
			if locale ~= file_locale then
				error(string.format("    %s:%d: Invalid locale! %q should be %q", file, line_number, locale, file_locale))
			end
			if not modules_locale[module_name] then
				error(string.format("    %s:%d: Invalid module name %q", file, line_number, module_name))
			end
		end

		-- validate all locale entries
		if modules_locale[current_module] then
			-- parse out standard string keys
			local comment, key = line:match("^%s*(%-?%-?)%s*L%.([%w_]+)%s*=") -- L.key =
			if not key then
				comment, key = line:match("^%s*(%-?%-?)%s*L%[\"(.+)\"%]%s*=") -- L.["key"] =
			end
			-- ensure there are no duplicate string keys in the same file
			if key and keys[current_module][key] ~= nil then
				error(string.format("    %s:%d: %s: Duplicate locale key %q", file, line_number, current_module, key))
			end
			-- parse special-case keys whose values are tables
			if not key then
				comment, key = line:match("^%s*(%-?%-?)%s*L%.([%w_]+)%b[]%s*=") -- L.key[sub_key] =
			end
			-- validate that the locale key exists in the module
			if key then
				keys[current_module][key] = comment == ""
				if not modules_locale[current_module][key] then
					error(string.format("    %s:%d: %s: Invalid locale key %q", file, line_number, current_module, key))
				end
			end
		end
	end

	-- reverse check the last locale block in the file
	if current_module and not current_module:match("^BigWigs") then
		reverseCheck(file, keys, current_module, current_module_line)
	end

	-- Check that all enUS strings exist in the foreign locale
	if file_locale ~= "enUS" then
		-- Only reverse check non-boss locales
		local module_name, L = next(keys)
		if module_name and module_name:match("^BigWigs") then
			for key in next, modules_locale[module_name] do
				if L[key] == nil then
					error(string.format("    %s:%d: %s: Missing locale key %q", file, 1, module_name, key))
				end
			end
		end
	end
end

-- Read boss module file and parse it for colors and sounds.
local function parseLua(file)
	local file_name = file:match(".*/(.*)$") or file
	if opt.quiet then
		file_name = file
	end

	local f = io.open(file, "r")
	if not f then
		error(string.format("    \"%s\" not found!", file_name))
		return
	end

	local data = f:read("*all")
	f:close()

	-- First, check to make sure this is actually a boss module file.
	local module_name, module_args = data:match("\nlocal mod.*= BigWigs:NewBoss%(\"(.-)\",?%s*([^)]*)")
	if not module_name then
		-- redirect any Locale files which are loaded from toc, modules.xml, etc
		if data:match("L = BigWigsAPI:NewLocale") or data:match("L = BigWigs:NewBossLocale") then
			parseLocale(file)
		else
			-- mark this non-boss, non-locale lua file as visited
			visit(file)
		end
		return
	end

	-- check if this file has already been visited
	if visit(file) then
		return
	end

	if module_args ~= "" then
		local args = strsplit(module_args)
		if #args > 1 then
			local journalId = args[#args]
			if string.sub(journalId, -1) ~= "}" then -- filter mods with multiple zoneIds and no journalId
				local ej_id = tonumber(journalId)
				if ej_id and ej_id > 0 then
					if modules_bosses[ej_id] then
						error(string.format("    %s:%d: Module \"%s\" is using journal id %d, which is already used by module \"%s\"", file_name, 1, module_name, ej_id, modules_bosses[ej_id]))
					else -- execution isn't stopped, don't overwrite the original module name
						modules_bosses[ej_id] = module_name
					end
				end
			end
		end
	end

	-- `modules` is used output the boss modules in the order they were parsed.
	table.insert(modules, module_name)
	modules_locale[module_name] = {}

	-- Split the file into a table
	local lines = {}
	for line in data:gmatch("(.-)\r?\n") do
		lines[#lines+1] = line
	end

	local module_encounter_id, module_set_stage = nil, nil
	local locale, common_locale = modules_locale[module_name], modules_locale["BigWigs: Common"]
	local options, option_keys, option_key_used, bitflag_used = {}, {}, {}, {}
	local options_block_start = 0
	local special_options = {}
	local methods, registered_methods, unit_died_methods, mob_engaged_methods = {Win=true,Disable=true}, {}, {}, {}
	local event_callbacks = {}
	local current_func = nil
	local args_keys = standard_args_keys
	local rep = {} -- key replacements

	for n, line in ipairs(lines) do
		-- save and strip comment
		local comment = ""
		if line:match("^%s*%-%-") then -- shortcut for full line comments
			comment = line:gsub("^%s*%-%-%s*", "")
			line = ""
		else
			-- pop off comments from the end (trying to protect strings)
			while line:gsub('%b""', ''):match("%-%-") do
				local new_line = line:reverse()
				local start, stop = new_line:find("--", nil, true)
				comment = comment .. new_line:sub(1, stop):reverse()
				line = new_line:sub(stop + 1):reverse()
			end
		end

		-- set some module flags
		if line:match("^mod:SetEncounterID") then
			module_encounter_id = true
		end
		if line:match("^mod:SetStage") then
			module_set_stage = true
		else
			local method = line:match(":([GS]etStage)%(")
			if method and not module_set_stage then
				error(string.format("    %s:%d: %s: Missing initial mod:SetStage!", file_name, n, method))
				module_set_stage = true
			end
		end

		-- save marker and autotalk options
		do
			local var = line:match("(%w+) = .*:AddMarkerOption%(")
			if var then
				special_options[var] = true
			end
			var = line:match("(%w+) = .*:AddAutoTalkOption%(")
			if var then
				special_options[var] = true
			end
		end

		-- locale checking
		do
			-- save module locale
			-- multiple definitions on one line
			if line:match("^%sL%.[%w_]+%s*,.+=.+") then -- we're setting things, right?
				for locale_key in line:gmatch("L%.([%w_]+)%s*,%s*") do
					locale[locale_key] = true
				end
			end
			local locale_key, locale_value = line:match("L%.([%w_]+)%s*=%s*(.*)")
			if not locale_key then
				locale_key, locale_value = line:match("L%[\"(.+)\"%]%s*=%s*(.*)")
			end
			if locale_key and locale[locale_key] == nil then
				locale_value = strtrim(locale_value)
				-- check if we're all replacement tokens
				local v = locale_value:gsub("%b{}", ""):gsub("\\n", "")
				if v == '""' then locale_value = "" end

				locale[locale_key] = locale_value:sub(1,1) == "{" or locale_value ~= unquote(locale_value)
			end
		end

		-- check usage
		for locale_type, locale_key, extra in line:gsub("L%[\"([%w_]+)\"%]", "L.%1"):gmatch("(C?L)%.([%w_]+)(%(?)") do
			if locale_type == "CL" then
				-- CL is only set in the main project
				if common_locale and not common_locale[locale_key] then
					error(string.format("    %s:%d: Invalid locale string \"CL.%s\"", file_name, n, locale_key))
				end
			elseif locale_type == "L" and locale[locale_key] == nil then
				error(string.format("    %s:%d: Invalid locale string \"L.%s\"", file_name, n, locale_key))
			end
			-- trying to invoke the string (missing :format)
			if extra == "(" then
				error(string.format("    %s:%d: Missing locale string format \"%s.%s(\"", file_name, n, locale_type, locale_key))
			end
		end

		--- loadstring the options table
		if line:find("function mod:GetOptions(", nil, true) then
			local opts, err = parseGetOptions(file_name, lines, n+1, special_options)
			if not opts then
				-- rip keys
				error(string.format("    %s:%d: Error parsing GetOptions! %s", file_name, n, err))
				return
			else
				if not next(option_keys) then
					option_keys = opts
					options_block_start = n + 1
				else -- merge multiple :GetOptions
					for key, flags in next, opts do
						if type(option_keys[key]) == "table" and type(flags) == "table" then
							for flag, v in next, flags do
								option_keys[key][flag] = v
							end
						elseif not option_keys[key] or type(flags) == "table" then
							option_keys[key] = flags
						end
					end
				end
				-- check string keys
				local custom_options = {
					berserk = true,
					altpower = true,
					infobox = true,
					proximity = true,
					stages = true,
					warmup = true,
					adds = true,
					health = true,
				}
				for key in next, option_keys do
					if type(key) == "string" and not custom_options[key] and not key:find("^custom_") and locale[key] == nil then
						error(string.format("    %s:%d: Missing option key locale for \"%s\"", file_name, options_block_start, key))
					end
				end
			end
		end
		local toggle_options = line:match("^mod%.toggleOptions = ({.+})")
		if toggle_options then
			local success, result = pcall(loadstring("return " .. toggle_options))
			if success then
				for _, entry in next, result do
					local flags = true
					if type(entry) == "table" then
						flags = {}
						for i=2, #entry do
							flags[entry[i]] = true
						end
						entry = entry[1]
					end
					if entry then -- marker option vars will be nil
						if default_options[entry] then
							flags = default_options[entry]
						end
						option_keys[entry] = flags
					end
				end
			end
		end

		--- Build the callback map.
		-- Parse :Log calls and save the callback => spellId association so we can
		-- replace args.spellId with the actual spellId(s) based on the last function
		-- that was entered when a message function is called.
		local event, callback, spells = line:match("self:Log%(\"(.-)\"%s*,%s*(.-)%s*,%s*([^)]*)%)")
		if event then
			if not log_events[event] then
				error(string.format("    %s:%d: Invalid Log event \"%s\"", file_name, n, event))
			end
			if callback ~= "nil" then
				callback = unquote(callback)
			else
				callback = event
			end
			if not options[callback] then
				options[callback] = {}
			end
			if not event_callbacks[event] then
				event_callbacks[event] = {}
			end
			for _, v in next, strsplit(spells) do
				v = tonumber(v)
				if not contains(options[callback], v) then
					table.insert(options[callback], v)
				end
				if not contains(event_callbacks[event], v) then
					table.insert(event_callbacks[event], v)
				else
					error(string.format("    %s:%d: Registered Log event \"%s\" with spell id \"%d\" multiple times", file_name, n, event, v))
				end
			end
			if not next(options[callback]) then
				options[callback] = nil
			end
			registered_methods[callback] = n
		end
		-- Record other registered events to check at the end
		event, callback = line:match(":RegisterUnitEvent%(\"(.-)\"%s*,%s*(.-)%s*,.-%)")
		-- if not event then
		--	-- XXX need to filter proto methods for this
		-- 	event, callback = line:match(":RegisterEvent%(\"(.-)\"%s*,?%s*(.*)%)")
		-- end
		if event then
			if callback == "" or callback == "nil" then
				callback = event
			else
				callback = unquote(callback)
			end
			registered_methods[callback] = n
		end
		event = line:match(":Death%(\"(.-)\"%s*,.*")
		if event then
			callback = event
			registered_methods[callback] = n
			unit_died_methods[callback] = true
		end
		event = line:match(":RegisterEngageMob%(\"(.-)\"%s*,.*")
		if event then
			callback = event
			registered_methods[callback] = n
			mob_engaged_methods[callback] = true
		end

		--- Set spellId replacement values.
		-- Record the function that was declared and use the callback map that was
		-- created earlier to set the associated spellId(s).
		local res, params = line:match("^%s*function%s+([%w_]+:[%w_]+)%s*(%b())")
		if res then
			current_func = res
			local name = res:match(":(.+)")
			methods[name] = true
			rep = {}
			rep.func_key = options[name]
			if unit_died_methods[name] then
				args_keys = unit_died_args_keys
			elseif mob_engaged_methods[name] then
				args_keys = {}
			else
				args_keys = standard_args_keys
			end
		end
		-- For local functions, look ahead and record the key for the first function
		-- that calls it.
		res = line:match("^%s*local function%s+([%w_]+)%s*%(") or line:match("^%s*function%s+([%w_]+)%s*%(")
		if res then
			current_func = res
			methods[res] = true
			rep = {}
			rep.local_func_key = findCalls(lines, n, current_func, options)
			args_keys = {}
		end
		-- For UNIT functions, record the last spellId checked to use as the key.
		res = line:match("if (.+) then")
		if res then
			if line:match("spellId == %d+") then
				rep.if_key = {}
				for m in res:gmatch("spellId == (%d+)") do
					rep.if_key[#rep.if_key+1] = m
				end
			end
		end
		-- For expression keys used multiple times
		res = line:match("%s*local spellId%s*=%s*(.+)")
		if res then
			-- fuck off Elerethe
			local set_key = comment:match("SetOption:(.-):")
			if set_key and set_key ~= "" then
				rep.if_key = {}
				for k, v in next, strsplit(set_key) do
					rep.if_key[#rep.if_key+1] = tonumber(v) or string.format("%q", unquote(v)) -- string keys are expected to be quoted
				end
			else
				if res == "args.spellId" then
					rep.if_key = rep.func_key
				else
					rep.if_key = unternary(res, "(-?%d+)") -- XXX doesn't allow for string keys
				end
			end
		else
			res = line:match("%s*local spellId,.+=%s*(.+),")
			if res then
				local set_key = comment:match("SetOption:(.-):")
				if set_key and set_key ~= "" then
					rep.if_key = {}
					for k, v in next, strsplit(set_key) do
						rep.if_key[#rep.if_key+1] = tonumber(v) or string.format("%q", unquote(v)) -- string keys are expected to be quoted
					end
				else
					rep.if_key = unternary(res, "(-?%d+)") -- XXX doesn't allow for string keys
				end
			end
		end

		--- Check callback args
		for key in string.gmatch(line, "[^%w]*args%.([%w]+)[^%w]*") do
			if not args_keys[key] then
				error(string.format("    %s:%d: func=%s, Invalid args key \"%s\"", file_name, n, tostring(current_func), key))
			end
		end

		--- Check timer args (callback, timer)
		local method, timerArgs = line:match(":(%a+Timer)(%b())")
		if method == "ScheduleTimer" or method == "ScheduleRepeatingTimer" or method == "SimpleTimer" then
			timerArgs = strsplit(timerArgs:sub(2, -2))
			if tonumber(timerArgs[1]) then
				error(string.format("    %s:%d: Invalid args for \":%s\" callback=%s, delay=%s", file_name, n, method, tostring(timerArgs[1]), tostring(timerArgs[2])))
			end
		end

		-- Check :Me args
		local meArgs = line:match(":Me(%b())")
		if meArgs then
			meArgs = meArgs:sub(2, -2)
			if not string.find(string.lower(meArgs), "guid", nil, true) then
				error(string.format("    %s:%d: Me: Invalid guid(1)! guid=%s", file_name, n, meArgs))
			end
		end

		-- Check :CheckOption
		local checkOptionArgs = line:match(":CheckOption(%b())")
		if checkOptionArgs then
			checkOptionArgs = strsplit(clean(checkOptionArgs:sub(2, -2)))
			local funcAsString = tostring(current_func)
			if rep.func_key then funcAsString = string.format("%s(%s)", funcAsString, table.concat(rep.func_key, ",")) end

			local key = tonumber(checkOptionArgs[1]) or unquote(checkOptionArgs[1])
			if key == "args.spellId" then
				if rep.func_key and #rep.func_key == 1 then
					key = rep.func_key[1]
				else
					error(string.format("    %s:%d: CheckOption: Invalid key! func=%s, key=%s", file_name, n, funcAsString, key))
					key = nil
				end
			end
			if key then
				if not option_keys[key] then
					error(string.format("    %s:%d: CheckOption: Invalid key! func=%s, key=%s", file_name, n, funcAsString, key))
				end
				local bitflag = unquote(checkOptionArgs[2])
				if tracked_bitflags[bitflag] and type(option_keys[key]) == "table" and option_keys[key][bitflag] then
					if not bitflag_used[key] then
						bitflag_used[key] = {}
					end
					bitflag_used[key][bitflag] = true
				end
				option_key_used[key] = true
			end
		end

		-- Check :Berserk
		local args = line:match(":Berserk(%b())")
		if args then
			args = strsplit(clean(args:sub(2, -2)))
			local funcAsString = tostring(current_func)
			if rep.func_key then funcAsString = string.format("%s(%s)", funcAsString, table.concat(rep.func_key, ",")) end

			local key = tonumber(args[4]) -- only numbers are used as a replacement key
			if not key then
				key = unquote(args[4])
				if key == "args.spellId" then
					if rep.func_key and #rep.func_key == 1 then
						key = rep.func_key[1]
					else
						error(string.format("    %s:%d: Berserk: Invalid key! func=%s, key=%s", file_name, n, funcAsString, key))
						key = nil
					end
				else -- arg is a string to use as the name
					key = "berserk"
				end
			end
			if key then
				if not option_keys[key] then
					error(string.format("    %s:%d: Berserk: Missing option key! func=%s, key=%s", file_name, n, funcAsString, key))
				end
				option_key_used[key] = true
			end
		end

		-- Check registering IEEU when it could overwrite the encounter start handler
		if line:match(":RegisterEvent%(\"INSTANCE_ENCOUNTER_ENGAGE_UNIT\"") and current_func == "mod:OnBossEnable" then
			if module_encounter_id and not line:match(":RegisterEvent%(\"INSTANCE_ENCOUNTER_ENGAGE_UNIT\", \"CheckBossStatus\"%)") then
				error(string.format("    %s:%d: Overwriting IEEU handler! Register in OnEngage instead. func=%s", file_name, n, tostring(current_func)))
			end
		end

		--- Parse toggle option API calls.
		if checkForAPI(line) then
			local key, sound, color, bitflag = nil, nil, nil, nil
			local obj, sugar, functionName, argsList = line:gsub("^.* = ", ""):match("(%w+)([.:])(.-)(%b())")
			if argsList then argsList = argsList:sub(2, -2) end
			local offset = 0
			if functionName == "ScheduleTimer" or functionName == "ScheduleRepeatingTimer" then
				functionName = argsList:match("^\"(.-)\"")
				offset = 2
			end
			if removed_methods[functionName] then
				error(string.format("    %s:%d: Invalid API method! func=%s, method=%s", file_name, n, tostring(current_func), functionName))
			elseif valid_methods[functionName] then
				argsList = strsplit(clean(argsList))
				key = unternary(argsList[1+offset], "(-?%d+)") -- XXX doesn't allow for string keys
				local sound_index = sound_methods[functionName]
				if sound_index then
					sound = unternary(argsList[sound_index+offset], "\"(.-)\"", valid_sounds)
					if functionName == "SetPrivateAuraSound" and not sound then
						sound = "warning"
					end
				end
				local color_index = color_methods[functionName]
				if color_index then
					color = tablize(unternary(argsList[color_index+offset], "\"(.-)\"", valid_colors))
					if functionName:sub(1, 6) == "Target" or functionName == "StackMessageOld" or functionName == "StackMessage" then
						color[#color+1] = "blue" -- used when on the player
					end
				end
				if functionName == "PersonalMessage" then
					color = {"blue"}
					local locale_string = argsList[2+offset]
					if (locale_string == "nil" or locale_string == "false") then locale_string = nil end
					if common_locale and (locale_string and not common_locale[unquote(locale_string)]) then
						local text = argsList[3+offset]
						error(string.format("    %s:%d: PersonalMessage: Invalid localeString(2)! func=%s, key=%s, localeString=%s, text=%s", file_name, n, tostring(current_func), key, tostring(locale_string), tostring(text)))
					end
				end
				local icon_index = icon_methods[functionName]
				if icon_index then
					local icon = argsList[icon_index+offset]
					-- Make sure methods with a string key set an icon.
					if type(key) == "string" and key:match('^".*"$') and icon == nil then
						-- Also check if text is nil or a (formatted)string if the method isn't :Flash
						local text = argsList[icon_index+offset-1]
						if functionName == "Flash" or (not text or text:match('^".*"$') or text:match(":format") or text:match("C?L%.%a")) then
							error(string.format("    %s:%d: Missing icon! func=%s, key=%s, text=%s, icon=%s", file_name, n, tostring(current_func), key, tostring(text), tostring(icon)))
						end
					end
				end
				if valid_methods[functionName] ~= true then
					bitflag = valid_methods[functionName]
				end

				-- Check for method call typo (API should always be invoked with ":" syntax)
				-- Note, may need to add a check for using table notation with SimpleTimer or
				-- such, but local functions are typically used for repeating callbacks
				if sugar == "." then
					local call = obj..sugar..functionName
					error(string.format("    %s:%d: Invalid API call \"%s\"! func=%s, key=%s", file_name, n, call, tostring(current_func), key))
				end
				-- Check for wrong API (Message instead of TargetMessage)
				if functionName == "Message" and (argsList[3+offset] == "destName" or argsList[3+offset] == "args.destName" or argsList[3+offset] == "name" or argsList[3+offset] == "args.sourceName" or argsList[3+offset] == "sourceName") then
					error(string.format("    %s:%d: Message text is a player name? func=%s, key=%s, text=%s", file_name, n, tostring(current_func), key, argsList[3]))
				end
				-- Check that noEmphUntil is set
				if functionName == "StackMessage" and (not argsList[5+offset] or argsList[5+offset] == "nil") then
					error(string.format("    %s:%d: StackMessage: Missing noEmphUntil(5)! func=%s, key=%s", file_name, n, tostring(current_func), key))
				end
				-- Check that voice wasn't forgotten (like the feature was >.>), passes simple expressions like `self:Dispeller("magic") and "dispel"`
				if functionName == "PlaySound" and argsList[3+offset] and argsList[3+offset] ~= "nil" and not argsList[3+offset]:match("^\"(.-)\"$") and not argsList[3+offset]:match(" and \"(.-)\"$") then
					error(string.format("    %s:%d: PlaySound: Invalid voice(3)! func=%s, key=%s, voice=%s", file_name, n, tostring(current_func), key, tostring(argsList[3+offset])))
				end
				-- Check chat directPrint
				if (functionName == "Say" or functionName == "Yell") and (argsList[2+offset] == "nil" and argsList[3+offset] == "true") then
					error(string.format("    %s:%d: %s: Missing msg(2) with directPrint(3)! func=%s, key=%s", file_name, n, functionName, tostring(current_func), key))
				end
				-- Check for English chat messages (unless using directPrint)
				if (functionName == "Say" or functionName == "Yell") and (argsList[3+offset] ~= "true" and (not argsList[4+offset] or argsList[4+offset] == "nil")) then
					error(string.format("    %s:%d: %s: Missing englishText(4)! func=%s, key=%s", file_name, n, functionName, tostring(current_func), key))
				end
				-- Set default keys
				if functionName == "CloseAltPower" and not key then
					key = "\"altpower\""
				end
				if functionName == "CloseProximity" and not key then
					key = "\"proximity\""
				end
			end

			-- -- SetOption:key:color:sound:
			-- Handle manually setting the key, color, and sound with a comment. Has to be on the
			-- same line as the function call. All three values can also be a comma seperated list
			-- or left empty.
			-- e.g.: -- SetOption:1234,1235:yellow:info,alert:  or  -- SetOption::1234,1235::info:  or  -- SetOption:1234:
			do
				local set_key, set_color, set_sound = comment:match("SetOption:(.*):(.*):(.*):")
				if not set_key then
					set_key, set_color = comment:match("SetOption:(.*):(.*):")
					set_sound = ""
				end
				if not set_key then
					set_key = comment:match("SetOption:(.*):")
					set_color, set_sound = "", ""
				end
				if set_key then
					if set_key ~= "" then
						key = strsplit(set_key)
						for k, v in next, key do
							if not tonumber(v) then
								-- string keys are expected to be quoted
								key[k] = string.format("%q", unquote(v))
							end
						end
					end
					if set_color ~= "" then
						color = strsplit(set_color)
					end
					if set_sound ~= "" then
						sound = strsplit(set_sound)
					end
				end
			end

			local funcAsString = tostring(current_func)
			if rep.func_key then funcAsString = string.format("%s(%s)", funcAsString, table.concat(rep.func_key, ",")) end

			local errors = nil
			local keys = {}
			-- Do key replacements.
			for _, k in next, tablize(key) do
				if k == "args.spellId" and rep.func_key then
					k = rep.func_key
				end
				if k == "spellId" then
					if rep.if_key then
						k = rep.if_key
					end
					if rep.local_func_key then
						k = rep.local_func_key
					end
				end
				for _, nk in next, tablize(k) do
					keys[#keys+1] = nk
				end
			end
			--- Validate keys.
			for i, nk in next, keys do
				local k = tonumber(nk) or unquote(nk)
				if key ~= "false" then
					if not default_options[k] then
						if not option_keys[k] then
							error(string.format("    %s:%d: Invalid key! func=%s, key=%s", file_name, n, funcAsString, k))
							errors = true
						elseif bitflag and (type(option_keys[k]) ~= "table" or not option_keys[k][bitflag]) then
							error(string.format("    %s:%d: Missing %s flag! func=%s, key=%s", file_name, n, bitflag, funcAsString, k))
							errors = true
						end
					end
					if bitflag and type(option_keys[k]) == "table" and option_keys[k][bitflag] then
						if not bitflag_used[k] then
							bitflag_used[k] = {}
						end
						bitflag_used[k][bitflag] = true
					end
					option_key_used[k] = true
				end
				keys[i] = k
			end

			-- Add the color entries.
			for _, c in next, tablize(color) do
				c = unquote(c)
				if valid_colors[c] then
					if not errors then
						add(module_name, module_colors, keys, c)
					end
				elseif c and c ~= "nil" then
					-- A color was set but didn't match an actual color, so warn about it.
					error(string.format("    %s:%d: Invalid color! func=%s, key=%s, color=%s", file_name, n, funcAsString, table.concat(keys, " "), c))
				end
			end

			-- Add the sound entries.
			for _, s in next, tablize(sound) do
				s = unquote(s)
				if valid_sounds[s] then
					if not errors then
						add(module_name, module_sounds, keys, s)
					end
				elseif s and s ~= "nil" then
					-- A sound was set but didn't match an actual sound, so warn about it.
					error(string.format("    %s:%d: Invalid sound! func=%s, key=%s, sound=%s", file_name, n, funcAsString, table.concat(keys, " "), s))
				end
			end
		end
	end

	-- Check for callbacks that were registered but don't exist.
	-- This will also error when using a local function as a callback.
	for functionName, n in next, registered_methods do
		if not methods[functionName] then
			error(string.format("    %s:%d: %q was registered as a callback, but it does not exist.", file_name, n, functionName))
		end
	end

	-- Check for options that were set but never used.
	for key in next, option_keys do
		if not option_key_used[key] and not tostring(key):match("^custom_") then
			error(string.format("    %s:%d: %q was registered as an option key, but was not used.", file_name, options_block_start, key))
		end
	end

	-- Check for bitflags that were set but never used.
	for key, flags in next, option_keys do
		if type(flags) == "table" then
			for flag in next, flags do
				if tracked_bitflags[flag] and (not bitflag_used[key] or not bitflag_used[key][flag]) then
					error(string.format("    %s:%d: %q was added as a bitflag to option key %q, but was not used.", file_name, options_block_start, flag, key))
				end
			end
		end
	end
end

-- Read modules.xml and return a table of file paths.
local function parseXML(file)
	-- check if this file has already been visited
	if visit(file) then
		return {}
	end

	local f = io.open(file, "r")
	if not f then
		if opt.quiet then
			error(string.format("    %s: File not found!", file))
		else
			error("    File not found!")
		end
		return {}
	end

	local list = {}
	-- The includes are relative, so we need to prepend the path of the current
	-- xml file for opening the file relative to the project root.
	local path = file:match(".*/") or ""

	for line in f:lines() do
		local file_name = line:match("^%s*<Include file=\"(.-)\"") or line:match("^%s*<Script file=\"(.-)\"")
		if file_name then
			file = path .. file_name
			file = file:gsub("\\", "/")
			table.insert(list, file)
		end
	end

	return list
end

local function parseTOC(file)
	-- check if this file has already been visited
	if visit(file) then
		return
	end

	local f = io.open(file, "r")
	if not f then
		if opt.quiet then
			error(string.format("    %s: File not found!", file))
		else
			error("    File not found!")
		end
		return
	end

	local list = {}
	for line in f:lines() do
		line = line:gsub("\r", ""):gsub("^#.*$", ""):gsub("\\", "/")
		if line ~= "" then
			table.insert(list, line)
		end
	end

	return list
end

local function parse(file, relativePath)
	if type(file) == "table" then
		-- Run the results of parseXML.
		for _, f in next, file do
			parse(f, relativePath)
		end
		-- Write the results.
		if #file > 0 and #modules > 0 then
			-- prefer a defined !Options path with a fallback of writing to !Options.lua in the same directory as the module
			local path = options_path or file[1]:match(".*/") or ""
			local file_name = options_file_name or "!Options.lua"
			dumpValues(path, file_name, modules, module_colors, module_sounds)
			print(string.format("    Parsed %d modules.", #modules))
		end
		-- Reset!
		modules = {}
		module_colors = {}
		module_sounds = {}
		options_path = nil
		options_file_name = nil
	elseif file then
		local file_path = relativePath and relativePath..file or file
		local options_file = string.match(file, "!Options.*%.lua$") -- matches !Options.lua or !Options_Vanilla.lua, etc
		if options_file then
			if options_path then
				error(string.format("    %s: Multiple !Options paths found!", options_path))
				error(string.format("    %s: Multiple !Options paths found!", file:match(".*/")))
			end
			-- if a file has defined a path to a specific !Options file, save it to write to later
			options_file_name = options_file
			options_path = file:match(".*/")
		elseif string.match(file, "%.lua$") then
			-- We have an actual lua file so parse it!
			parseLua(file_path)
		elseif string.match(file, "modules.*%.xml$") or file == "bosses.xml" then
			-- Scan module includes for lua files.
			print(string.format("Checking %s", file_path))
			parse(parseXML(file_path))
		elseif string.match(file, "locales%.xml$") then
			for _, f in next, parseXML(file_path) do
				parseLocale(f)
			end
		elseif string.match(file, "%.toc$") then
			print(string.format("Checking %s", file))
			local tocRelativePath = file:match("^(.+/)(.+)$")
			parse(parseTOC(file), tocRelativePath)
		end
	end
end

local function setCommonLocale(path)
	-- For repos other than BigWigs proper, try to load the CL without erroring
	path = path:match("^(.*)/") or "."
	local file = path .. "/Locales/enUS_common.lua"
	local f = io.open(file, "r")
	if not f then
		-- module(s) file directly?
		file = path .. "../Locales/enUS_common.lua"
		f = io.open(file, "r")
		if not f then
			return
		end
	end
	f:close()

	parseLocale(file)
end


-- aaaaaand start
local start_path = "modules.xml"
local arg_paths = {}

-- simple arg parser
if arg then
	for _, v in ipairs(arg) do
		if string.sub(v, 1, 1) == "-" then
			v = string.match(v, "^[-]+(.+)$")
			if v == "q" or v == "quiet" then
				opt.quiet = true
			end
			if v == "n" or v == "dry-run" then
				opt.dryrun = true
			end
		else
			local path = v:gsub("\\", "/")
			local ext = path:sub(-4)
			local is_file = ext == ".lua" or ext == ".xml" or ext == ".toc"
			if path:sub(-1) ~= "/" and not is_file then
				path = path .. "/"
			end
			path = path:gsub("^./", "")
			if is_file then
				start_path = path
			else
				start_path = path .. start_path
			end
			arg_paths[#arg_paths + 1] = start_path
		end
	end
end

setCommonLocale(start_path)
parse(arg_paths)

os.exit(exit_code)
