#!/usr/bin/env lua

local results = {}
local locale_names = {
	["deDE"] = "German", -- German
	["esES"] = "Spanish (Spain)", -- Spanish (Spain)
	["esMX"] = "Spanish (Mexico)", -- Spanish (Mexico)
	["frFR"] = "French", -- French
	["itIT"] = "Italian", -- Italian
	["koKR"] = "Korean", -- Korean
	["ptBR"] = "Portuguese (Brazil)", -- Portuguese (Brazil)
	["ruRU"] = "Russian", -- Russian
	["zhCN"] = "Chinese (Simplified)", -- Chinese (Simplified)
	["zhTW"] = "Chinese (Traditional)"  -- Chinese (Traditional)
}

-- Set an exit code if we show an error.
local exit_code = 0
local error, info
if os.execute("tput colors >/dev/null 2>&1") then
	function error(msg)
		print("\27[31m" .. msg .. "\27[0m") -- red
		exit_code = 1
	end
	function info(msg)
		print("\27[36m" .. msg .. "\27[0m") -- cyan
	end
else
	function error(msg)
		print(msg)
		exit_code = 1
	end
	info = print
end

-- Strip whitespace from the start and end of a string.
local function strtrim(str)
	return str:match("^%s*(.-)%s*$")
end

-- Split a string at commas and return a table with the results.
local function strsplit(str)
	local t = {}
	str:gsub("([^,]+)", function(s)
		t[#t + 1] = strtrim(s)
	end)
	return t
end

-- Check whether a line is a commented-out entry.
local function is_commented_assignment(line)
	local body = line:match("^%s*%-%-+%s*(.*)$")
	if body then
		-- L.someKey = "value"
		if body:match("^%s*L%.[%w_]*%s*=") then
			return true
		end

		-- L["someKey"] = "value"
		if body:match('^%s*L%b[]%s*=') then
			return true
		end

		-- someKey = "value",
		if body:match('^%s*[%a][%w_]*%s*=%s*%b""%s*,') then
			return true
		end

		-- [someKey] = "value",
		if body:match('^%s*%b[]%s*=%s*%b""%s*,') then
			return true
		end
	end

	return false
end

-- Parse a file containing localized strings and record the number of commented-out entries.
local function parseLocale(file, locale)
	local file_handle = io.open(file, "r")
	if not file_handle then
		error(string.format("    %s: File not found!", file))
		return
	end

	local count = 0
	local line_number = 0
	for line in file_handle:lines() do
		line_number = line_number + 1
		if is_commented_assignment(line) then
			count = count + 1
		end
	end
	file_handle:close()

	table.insert(results, { path = file, count = count, locale = locale })
end

-- Parse a .toc file and return a list of files.
local function parseTOC(file)
	local file_handle = io.open(file, "r")
	if not file_handle then
		error(string.format("    %s: File not found!", file))
		return
	end

	local list = {}
	for line in file_handle:lines() do
		-- ignore carriage returns and commented lines
		line = line:gsub("\r", ""):gsub("^#.*$", ""):gsub("\\", "/")
		if line ~= "" then
			table.insert(list, line)
		end
	end

	return list
end

local function parse(file, relative_path)
	if type(file) == "table" then
		for _, f in next, file do
			parse(f, relative_path)
		end
	elseif file then
		-- split any optional [AllowLoad] condition out from the file name
		local file_name, condition = string.match(file, "^(%S+)%s*(%[?.-%]?)$")
		local file_path = relative_path and relative_path .. file_name or file_name
		if string.match(file_name, "%.lua$") then
			if string.find(file_name, "[TextLocale]", nil, true) then
				-- if the file path contains [TextLocale] then we have to figure out what to replace it with
				-- first look for [AllowLoadTextLocale ...]
				local allowed_locales = string.match(condition, "^%[AllowLoadTextLocale (.+)%]$")
				if not allowed_locales then
					-- if [AllowLoadTextLocale ...] isn't found then substitute all locales
					allowed_locales = { "deDE", "esES", "esMX", "frFR", "itIT", "koKR", "ptBR", "ruRU", "zhCN", "zhTW" }
				else
					allowed_locales = strsplit(allowed_locales)
				end
				for _, locale in next, allowed_locales do
					-- shortcut to parseLocale, assuming any path with [TextLocale] is directly pointing to a locale file
					parseLocale(file_path:gsub("%[TextLocale%]", locale), locale)
				end
			end
		elseif string.match(file_name, "%.toc$") then
			local toc_relative_path = file_name:match("^(.+/).+$")
			parse(parseTOC(file_name), toc_relative_path)
		end
	end
end

local function main()
	local start_path = "BigWigs.toc"
	local arg_paths = {}
	local output_file = "Missing-Localization.md"

	if arg and #arg > 0 then
		local i = 1
		while i <= #arg do
			local a = arg[i]
			if a == "-o" or a == "--output" then
				i = i + 1
				output_file = arg[i]
			else
				local path = a:gsub("\\", "/")
				local ext = path:sub(-4)
				local is_file = ext == ".lua" or ext == ".toc"
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
			i = i + 1
		end
	end
	if  #arg_paths == 0 then
		arg_paths[#arg_paths + 1] = start_path
	end

	parse(arg_paths)

	if exit_code ~= 0 then
		return
	end

	local file_handle, err = io.open(output_file, "w")
	if not file_handle then
		error(string.format("Unable to write report to %s", tostring(err)))
		return
	end

	local total = 0
	local out = {}

	local current_locale = nil
	table.sort(results, function(a, b) return a.path < b.path end)
	for _, r in ipairs(results) do
		if r.locale ~= current_locale then
			current_locale = r.locale
			table.insert(out, "")
			table.insert(out, string.format("## %s", locale_names[current_locale] or current_locale))
			table.insert(out, "")
			table.insert(out, "| File | Missing |")
			table.insert(out, "|---|---|")
		end
		total = total + r.count
		local repo, path = r.path:match("(.-)/(.*)$")
		local link = path and string.format("[%s](https://github.com/BigWigsMods/%s/blob/master/%s)", r.path, repo, path)
		table.insert(out, string.format("| %s | %d |", link or r.path, r.count))
	end
	table.insert(out, "")

	file_handle:write(table.concat(out, "\n"))
	file_handle:close()

	local summary = string.format("%d entries missing translation.", total)
	os.execute(string.format("echo '%s' >> $GITHUB_STEP_SUMMARY", summary))
	info(summary)
	print(string.format("Wrote report to %s", output_file))
end

main()
os.exit(exit_code)
