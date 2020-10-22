
-- Script to parse boss module files and output ability=>color/sound mappings

local loadstring = loadstring or load -- 5.2 compat

local opt = {}

local modules = {}
local modules_l = nil
local module_colors = {}
local module_sounds = {}

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
	Info = true, info = true,
	Alert = true, alert = true,
	Alarm = true, alarm = true,
	Long = true, long = true,
	Warning = true, warning = true,
}
local color_methods = {
	Message = 2,
	Message2 = 2,
	TargetMessage = 3,
	TargetMessage2 = 2,
	TargetsMessage = 2,
	StackMessage = 4,
	DelayedMessage = 3,
}
local sound_methods = {
	PlaySound = 2,
	Message = 3,
	TargetMessage = 4,
	StackMessage = 5,
	DelayedMessage = 6,
}
local valid_methods = {
	Bar = true,
	CDBar = true,
	CastBar = true, --"CASTBAR",
	TargetBar = true,
	PersonalMessage = true,
	PrimaryIcon = "ICON",
	SecondaryIcon = "ICON",
	Flash = "FLASH",
	Say = "SAY",
	SayCountdown = "SAY_COUNTDOWN",
	CancelSayCountdown = "SAY_COUNTDOWN",
	Yell2 = "SAY",
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
	NameplateBar = "NAMEPLATEBAR",
	NameplateCDBar = "NAMEPLATEBAR",
	PauseNameplateBar = "NAMEPLATEBAR",
	ResumeNameplateBar = "NAMEPLATEBAR",
	NameplateBarTimeLeft = "NAMEPLATEBAR",
	StopNameplateBar = "NAMEPLATEBAR",
}
for k in next, color_methods do valid_methods[k] = true end
for k in next, sound_methods do valid_methods[k] = true end

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
	["ENVIRONMENTAL_DAMAGE"] = true,
	["DAMAGE_SHIELD"] = true,
	["DAMAGE_SHIELD_MISSED"] = true,
	["DAMAGE_SPLIT"] = true,
	["PARTY_KILL"] = true,
	["UNIT_DIED"] = true,
	["UNIT_DESTROYED"] = true,
	["UNIT_DISSIPATES"] = true,
}

local args_keys = {
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
	extraSpellId = true,
	extraSpellName = true,
	amount = true,
	mobId = true,
}

-- Set an exit code if we show an error.
local exit_code = 0
local error, warn
if package.config:sub(1,1) == "/" then -- linux path seperator
	function error(msg)
		print("\27[31m" .. msg .. "\27[0m") -- red
		exit_code = 1
	end
	function warn(msg)
		print("\27[33m" .. msg .. "\27[0m") -- yellow
	end
else
	function error(msg)
		print(msg)
		exit_code = 1
	end
	warn = print
end
local function print(...)
	if opt.quiet then return end
	_G.print(...)
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
	str = str:gsub(":Dispeller%b()", "")
	str = str:gsub(":format%b()", "")
	str = str:gsub("UnitBuff%b()", "UnitBuff")
	str = str:gsub("UnitDebuff%b()", "UnitDebuff")
	str = str:gsub("UnitIsUnit%b()", "UnitIsUnit")
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

-- Write out a module option values to [module dir]/Options/[value].lua
local function dumpValues(path, name, options_table)
	local file = path .. name .. ".lua"
	local old_data = ""
	local f = io.open(file, "r")
	if f then
		old_data = f:read("*all")
		f:close()
	end

	local data = ""
	for _, mod in ipairs(modules) do
		if options_table[mod] then
			data = data .. string.format("\r\nBigWigs:Add%s(%q, {\r\n", name, mod)
			for _, key in ipairs(sortKeys(options_table[mod])) do
				local values = options_table[mod][key]
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
		end
	end
	if data == "" then
		data = "-- Don't error because I'm empty, please.\r\n"
	end

	if data:gsub("\r", "") ~= old_data:gsub("\r", "") then
		if not opt.dryrun then
			f = io.open(file, "wb")
			if not f then
				error(string.format("    %s: File not found!", file))
			else
				f:write(data)
				f:close()
				warn("    Updated " .. file)
			end
		else
			warn("    Updated " .. file .. " (skipped)")
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
		local line = lines[i]
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

local function parseGetOptions(lines, start)
	local chunk = nil
	for i = start, #lines do
		if i == start and lines[i]:match("^%s*return {.+}%s*$") then
			-- old style one line options
			chunk = lines[i]
			break
		end
		if lines[i]:match("^%s*},%s*{") then
			-- we don't want to parse headers (to avoid setfenv) so stop here
			chunk = table.concat(lines, "\n", start, i-1) .. "\n}"
			break
		end
		if lines[i]:match("^%s*end") then
			chunk = table.concat(lines, "\n", start, i-1) -- no headers, so we need to back up to the }
			break
		end
	end
	if not chunk or chunk == "" then
		return false, "Something is wrong."
	end

	local success, result = pcall(loadstring(chunk))
	if success then
		local options, option_flags = {}, {}
		for _, opt in next, result do
			local flags = true
			if type(opt) == "table" then
				flags = {}
				for i=2, #opt do
					flags[opt[i]] = true
				end
				opt = opt[1]
			end
			if opt then -- marker option vars will be nil
				if default_options[opt] then
					flags = default_options[opt]
				end
				options[opt] = flags
			end
		end
		return options
	end
	return success, result
end

local function checkForAPI(line)
	for method in next, valid_methods do
		if line:find(method, nil, true) then
			return true
		end
	end
	return false
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
	local module_name = data:match("\nlocal mod.*= BigWigs:NewBoss%(\"(.-)\"")
	if not module_name then
		return
	end

	-- `modules` is used output the boss modules in the order they were parsed.
	table.insert(modules, module_name)

	-- Split the file into a table
	local lines = {}
	for line in data:gmatch("(.-)\r?\n") do
		lines[#lines+1] = line
	end
	data = nil

	local options, option_keys = {}, {}
	local methods, registered_methods = {Win=true}, {}
	local event_callbacks = {}
	local current_func = nil
	local rep = {}
	for n, line in ipairs(lines) do
		local comment = line:match("%-%-%s*(.*)") or ""
		line = line:gsub("%-%-.*$", "") -- strip comments

		--- loadstring the options table
		if line == "function mod:GetOptions()" or line == "function mod:GetOptions(CL)" then
			local opts, err = parseGetOptions(lines, n+1)
			if not opts then
				-- rip keys
				error(string.format("    %s:%d: Error parsing GetOptions! %s", file_name, n, err))
				-- return
			else
				option_keys = opts
			end
		end
		local toggle_options = line:match("^mod%.toggleOptions = ({.+})")
		if toggle_options then
			local success, result = pcall(loadstring("return " .. toggle_options))
			if success then
				for _, opt in next, result do
					local flags = true
					if type(opt) == "table" then
						flags = {}
						for i=2, #opt do
							flags[opt[i]] = true
						end
						opt = opt[1]
					end
					if opt then -- marker option vars will be nil
						if default_options[opt] then
							flags = default_options[opt]
						end
						option_keys[opt] = flags
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

		--- Set spellId replacement values.
		-- Record the function that was declared and use the callback map that was
		-- created earlier to set the associated spellId(s).
		local res = line:match("^%s*function%s+([%w_]+:[%w_]+)%s*%(")
		if res then
			current_func = res
			local name = res:match(":(.+)")
			methods[name] = true
			rep = {}
			rep.func_key = options[name]
		end
		-- For local functions, look ahead and record the key for the first function
		-- that calls it.
		res = line:match("^%s*local function%s+([%w_]+)%s*%(") or line:match("^%s*function%s+([%w_]+)%s*%(")
		if res then
			current_func = res
			methods[res] = true
			rep = {}
			rep.local_func_key = findCalls(lines, n, current_func, options)
		end
		-- For UNIT functions, record the last spellId checked to use as the key.
		res = line:match("if (.+) then")
		if res and line:match("spellId == %d+") then
			rep.if_key = {}
			for m in res:gmatch("spellId == (%d+)") do
				rep.if_key[#rep.if_key+1] = m
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
				rep.if_key = unternary(res, "(-?%d+)") -- XXX doesn't allow for string keys
			end
		end

		--- Check callback args
		for key in string.gmatch(line, "[^%w]*args%.([%w]+)[^%w]*") do
			if not args_keys[key] then
				error(string.format("    %s:%d: Invalid args key \"%s\"", file_name, n, key))
			end
		end

		--- Parse message calls.
		-- Check for function calls that will trigger a sound, including calls
		-- delayed with ScheduleTimer.
		if checkForAPI(line) then
			local key, sound, color, bitflag = nil, nil, nil, nil
			local method, args = line:match("%w+:(.-)%(%s*(.+)%s*%)")
			local offset = 0
			if method == "ScheduleTimer" or method == "ScheduleRepeatingTimer" then
				method = args:match("^\"(.-)\"")
				offset = 2
			end
			if valid_methods[method] then
				args = strsplit(clean(args))
				key = unternary(args[1+offset], "(-?%d+)") -- XXX doesn't allow for string keys
				local sound_index = sound_methods[method]
				if sound_index then
					sound = unternary(args[sound_index+offset], "\"(.-)\"", valid_sounds)
				end
				local color_index = color_methods[method]
				if color_index then
					color = tablize(unternary(args[color_index+offset], "\"(.-)\"", valid_colors))
					if method:sub(1, 6) == "Target" or method == "StackMessage" then
						color[#color+1] = "blue" -- used when on the player
					end
				end
				if method == "PersonalMessage" then
					color = {"blue"}
				end
				if valid_methods[method] ~= true then
					bitflag = valid_methods[method]
				end
			end

			-- Handle manually setting the key, color, and sound with a comment. Has to be on the
			-- same line as the function call. All three values can also be a comma seperated list
			-- or left empty.
			-- e.g.: -- SetOption:1234,1235:Urgent:Info,Alert:  or  -- SetOption:1234:::
			local set_key, set_color, set_sound = comment:match("SetOption:(.*):(.*):(.*):")
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

			local f = tostring(current_func)
			if rep.func_key then f = string.format("%s(%s)", f, table.concat(rep.func_key, ",")) end

			local errors = nil
			local keys = {}
			-- Do key replacements.
			for _, k in next, tablize(key) do
				if k == "args.spellId" and rep.func_key then
					k = rep.func_key
				end
				if k == "spellId" and rep.if_key then
					k = rep.if_key
				end
				if k == "spellId" and rep.local_func_key then
					k = rep.local_func_key
				end
				for _, nk in next, tablize(k) do
					keys[#keys+1] = nk
				end
			end
			--- Validate keys.
			for i, k in next, keys do
				local key = tonumber(k) or unquote(k)
				if not option_keys[key] then
					error(string.format("    %s:%d: Invalid key! func=%s, key=%s", file_name, n, f, key))
					errors = true
				elseif bitflag and (type(option_keys[key]) ~= "table" or not option_keys[key][bitflag]) then
					error(string.format("    %s:%d: Missing %s flag! func=%s, key=%s", file_name, n, bitflag, f, key))
					errors = true
				end
				keys[i] = key
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
					error(string.format("    %s:%d: Invalid color! func=%s, key=%s, color=%s", file_name, n, f, table.concat(keys, " "), c))
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
					error(string.format("    %s:%d: Invalid sound! func=%s, key=%s, sound=%s", file_name, n, f, table.concat(keys, " "), s))
				end
			end
		end
	end

	-- Check for callbacks that were registered but don't exist.
	-- This will also error when using a local function as a callback.
	for f, n in next, registered_methods do
		if not methods[f] then
			error(string.format("    %s:%d: %q was registered as a callback, but it does not exist.", file_name, n, f))
		end
	end
end

local function parseLocale(file)
	local file_locale = file:match("Locales/(.-)%.lua$")
	local file_name = file
	if not opt.quiet then
		file_name = "Locales/"..file_locale..".lua"
	end

	local f = io.open(file, "r")
	if not f then
		error(string.format("    \"%s\" not found!", file))
		return
	end

	local data = f:read("*all")
	f:close()

	local n = 0
	for line in data:gmatch("(.-)\r?\n") do
		n = n + 1

		local module_name, module_locale
		if file_locale == "esES" then
			-- El español es muy especial
			local module_name2, module_locale2
			module_name, module_locale, module_name2, module_locale2 = line:match("L = BigWigs:NewBossLocale%(\"(.-)\", \"(.-)\"%) or BigWigs:NewBossLocale%(\"(.-)\", \"(.-)\"%)")
			if module_name then
				-- Make sure both NewBossLocale calls match
				if module_name ~= module_name2 then
					error(string.format("    %s:%d: Module name mismatch! %q != %q", file_name, n, module_name, module_name2))
				end
				if module_locale2 ~= "esMX" then
					error(string.format("    %s:%d: Invalid locale! %q should be %q", file_name, n, module_locale2, "esMX"))
				end
			end
		else
			module_name, module_locale = line:match("L = BigWigs:NewBossLocale%(\"(.-)\", \"(.-)\"%)")
		end

		if module_name then
			if module_locale ~= file_locale then
				error(string.format("    %s:%d: Invalid locale! %q should be %q", file_name, n, module_locale, file_locale))
			end
			if not contains(modules_l, module_name) then
				error(string.format("    %s:%d: Invalid module name %q", file_name, n, module_name))
			end
		end
	end
end


-- Read modules.xml and return a table of file paths.
local function parseXML(file)
	local f = io.open(file, "r")
	if not f then
		error("    File not found!")
		return
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

local function parse(file)
	if type(file) == "table" then
		-- Run the results of parseXML.
		for _, f in next, file do
			parse(f)
		end
		-- Write the results.
		if #file > 0 and #modules > 0 then
			local path = (file[1]:match(".*/") or "") .. "Options/"
			dumpValues(path, "Colors", module_colors)
			dumpValues(path, "Sounds", module_sounds)
			print(string.format("    Parsed %d modules.", #modules))
		end
		-- Still need you for locales if they're processed from a parent xml file (old style)
		modules_l = modules
		-- Reset!
		modules = {}
		module_colors = {}
		module_sounds = {}
	elseif file then
		if string.match(file, "%.lua$") then
			-- We have an actual lua file so parse it!
			parseLua(file)
		elseif string.match(file, "modules%.xml$") then
			-- Scan module includes for lua files.
			print(string.format("Checking %s", file))
			parse(parseXML(file))
		elseif string.match(file, "locales%.xml$") then
			-- Parse locale files to check NewBossLocale lines.
			if #modules ~= 0 then
				-- The locales are in the same xml file as the module files,
				-- so data hasn't been dumped and reset yet
				modules_l = modules
			end
			for _, f in next, parseXML(file) do
				parseLocale(f)
			end
		end
	end
end


-- aaaaaand start
local start_path = "modules.xml"

-- simple arg parser
if arg then
	for k, v in ipairs(arg) do
		if string.sub(v, 1, 1) == "-" then
			v = string.match(v, "^[-]+(.+)$")
			if v == "q" or v == "quiet" then
				opt.quiet = true
			end
			if v == "n" or v == "dry-run" then
				opt.dryrun = true
			end
		else
			local path = arg[1]:gsub("\\", "/")
			local is_file = path:sub(-4) == ".lua"
			if path:sub(-1) ~= "/" and not is_file then
				path = path .. "/"
			end
			path = path:gsub("^./", "")
			if is_file then
				start_path = path
			else
				start_path = path .. start_path
			end
		end
	end
end

parse(start_path)

os.exit(exit_code)
