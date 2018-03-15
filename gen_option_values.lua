
-- Script to parse boss module files and output ability=>color/sound mappings

local modules = {}
local module_colors = {}
local module_sounds = {}

local valid_colors = {
	Positive = true, green = true,
	Personal = true, blue = true,
	Attention = true, yellow = true,
	Urgent = true, orange = true,
	Important = true, red = true,
	Neutral = true, cyan = true,
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
	TargetMessage = 3,
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
			for key, values in next, options_table[mod] do
				if type(key) == "string" then key = string.format("%q", key) end
				if #values == 1 then
					data = data .. string.format("\t[%s] = %q,\r\n", key, values[1])
				else
					for i = 1, #values do
						values[i] = string.format("%q", values[i])
					end
					data = data .. string.format("\t[%s] = {%s},\r\n", key, table.concat(values, ","))
				end
			end
			data = data .. "})\r\n"
		end
	end

	if data:gsub("\r", "") ~= old_data:gsub("\r", "") then
		f = assert(io.open(file, "w"))
		f:write(data)
		f:close()
		warn("    Updated " .. file)
	end
end

local function dump(module_dir)
	if not next(modules) then return end

	local path = module_dir .. "Options/"
	assert(os.execute("mkdir -p \"" .. path .. "\"")) -- XXX Remove this

	dumpValues(path, "Sounds", module_sounds)
	dumpValues(path, "Colors", module_colors)

	print(string.format("    Parsed %d modules.", #modules))
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

local function findCallingMethod(lines, start, local_func)
	local func, if_key = nil, nil
	for i = start+1, #lines do
		local line = lines[i]
		local res = line:match("^%s*function%s+%w+[.:]([%a0-9_]+)%s*%(")
		if res then
			func = res
			if_key = nil
		end
		res = line:match("^%s*local function%s+([%a0-9_.:]+)%s*%(")
		if res then
			func = nil
			if_key = nil
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
				return func, if_key
			end
		end
	end
end


-- Read modules.xml and return a table of boss module file paths.
local function parseXML(file)
	print(string.format("Checking %s", file))

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
			table.insert(list, path .. file_name)
		end
	end

	return list
end

-- Read boss module file and parse it for colors and sounds.
local function parseLua(file)
	local f = io.open(file, "r")
	if not f then return end

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

	local options = {}
	local current_func = nil
	local rep = {}
	for n, line in ipairs(lines) do
		local comment = line:match("%-%-%s*(.*)") or ""
		line = line:gsub("%-%-.*$", "") -- strip comments

		--- Build the callback map.
		-- Parse :Log calls and save the callback => spellId association so we can
		-- replace args.spellId with the actual spellId(s) based on the last function
		-- that was entered when a message function is called.
		local event, callback, spells = line:match("self:Log%(\"(.-)\",%s*(.-)%s*,%s*([^)]*)%)")
		if event then
			if callback ~= "nil" then
				callback = unquote(callback)
			else
				callback = event
			end
			spells = strsplit(spells)
			for i = 1, #spells do
				spells[i] = tonumber(spells[i])
			end
			options[callback] = spells
		end

		--- Set spellId replacement values.
		-- Record the function that was declared and use the callback map that was
		-- created earlier to set the associated spellId(s).
		local res = line:match("^%s*function%s+([%a0-9_.:]+)%s*%(")
		if res then
			current_func = res
			rep = {}
			rep.func_key = options[res:match(":(.+)")]
		end
		-- For local functions, look ahead and record the key for the first function
		-- that calls it.
		res = line:match("^%s*local function%s+([%a0-9_.:]+)%s*%(")
		if res then
			current_func = nil
			rep = {}
			local caller, if_key = findCallingMethod(lines, n, res)
			rep.local_func_key = options[caller] or if_key
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
			rep.if_key = unternary(res, "(-?%d+)") -- XXX doesn't allow for string keys
		end

		--- Parse message calls.
		-- Check for function calls that will trigger a sound, including calls
		-- delayed with ScheduleTimer.
		if line:find("Message", nil, true) or line:find("PlaySound", nil, true) then
			local key, sound, color = nil, nil, nil
			local method, args = line:match("%w+:(.-)%(%s*(.+)%s*%)")
			if sound_methods[method] or method == "ScheduleTimer" then
				args = strsplit(clean(args))
				if method == "ScheduleTimer" then
					-- boss:ScheduleTimer(callback, delay, args...)
					method = unquote(table.remove(args, 1))
					table.remove(args, 1) -- delay
				end
				local sound_index = sound_methods[method]
				if sound_index then
					-- boss:Message(key, color, sound, text, icon)
					-- boss:TargetMessage(key, player, color, sound, text, icon, alwaysPlaySound)
					-- boss:StackMessage(key, player, stack, color, sound, text, icon)
					-- boss:DelayedMessage(key, delay, color, text, icon, sound)
					-- boss:PlaySound(key, sound)
					local color_index = color_methods[method]
					key = unternary(args[1], "(-?%d+)") -- XXX doesn't allow for string keys
					sound = unternary(args[sound_index], "\"(.-)\"", valid_sounds)
					color = tablize(unternary(args[color_index], "\"(.-)\"", valid_colors))
					if method == "TargetMessage" or method == "StackMessage" then
						color[#color+1] = "Personal" -- Replaces the color with Personal for on me
					end
				end
			end

			-- Handle manually setting the key, color, and sound with a comment. Has to be on the
			-- same line as the function call. All three values can be a comma seperated list.
			-- e.g.: -- SetOption:1234,1235:Urgent:Info,Alert:
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
				local replaced = nil
				if k == "args.spellId" and rep.func_key then
					k = rep.func_key
					replaced = true
				end
				if k == "spellId" and rep.if_key then
					k = rep.if_key
					replaced = true
				end
				if k == "spellId" and rep.local_func_key then
					k = rep.local_func_key
					replaced = true
				end
				if not replaced then
					keys[#keys+1] = k
				else
					for _, nk in next, tablize(k) do
						keys[#keys+1] = nk
					end
				end
			end
			--- Validate keys.
			for i, k in next, keys do
				local unquoted = unquote(k)
				if not tonumber(k) and (k == unquoted or string.find(k, "%s")) then -- catch vars and expressions
					error(string.format("    %s:%d: Invalid key! func=%s, key=%s", file:match(".*/(.*)$"), n, f, k))
					errors = true
				end
				keys[i] = unquoted
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
					error(string.format("    %s:%d: Invalid color! func=%s, key=%s, color=%s", file:match(".*/(.*)$"), n, f, table.concat(keys, " "), c))
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
					error(string.format("    %s:%d: Invalid sound! func=%s, key=%s, sound=%s", file:match(".*/(.*)$"), n, f, table.concat(keys, " "), s))
				end
			end
		end
	end
end

local function parse(file)
	if type(file) == "table" then
		-- Run the results of parseXML.
		for _, f in next, file do
			parse(f)
		end
		-- Write the results.
		if #file > 0 then
			dump(file[1]:match(".*/") or "")
		end
		-- Reset!
		modules = {}
		module_colors = {}
		module_sounds = {}
	elseif file then
		file = file:gsub("\\", "/")
		if string.match(file, "%.lua$") then
			-- We have an actual lua file so parse it for sounds!
			parseLua(file)
		elseif string.match(file, "modules%.xml$") then
			-- Scan module includes for lua files.
			parse(parseXML(file))
		end
	end
end


-- aaaaaand start
local start_path = "modules.xml"
if arg then
	local path
	if arg[1] then
		path = arg[1]:gsub("\\", "/")
		if path:sub(-1) ~= "/" then
			path = path .. "/"
		end
	else
		path = arg[0]:gsub("\\", "/"):match(".*/")
	end
	if path then
		start_path = path:gsub("^./", "") .. start_path
	end
end
parse(start_path)

os.exit(exit_code)
