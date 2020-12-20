
local API = {}
local type, next, error = type, next, error

--------------------------------------------------------------------------------
-- Locale
--

do
	local tbl = {}
	local myRegion = GetLocale()
	function API:NewLocale(locale, region)
		if region == "enUS" or region == myRegion then
			if not tbl[locale] then
				tbl[locale] = {}
			end
			return tbl[locale]
		end
	end
	function API:GetLocale(locale)
		if tbl[locale] then
			return tbl[locale]
		end
	end
end

--------------------------------------------------------------------------------
-- Voice
--

do
	local addons = {}
	function API.RegisterVoicePack(pack)
		if type(pack) ~= "string" then error("Voice pack name must be a string.") return end

		if not addons[pack] then
			addons[pack] = true
		else
			error(("Voice pack %s already registered."):format(pack))
		end
	end

	function API.HasVoicePack()
		if next(addons) then
			return true
		end
	end
end

--------------------------------------------------------------------------------
-- Countdown
--

do
	local voices = {}
	function API:RegisterCountdown(id, name, data)
		if not data then data, name = name, id end
		if type(id) ~= "string" then error("Countdown name must be a string.") end
		if type(data) ~= "table" or #data < 5 or #data > 10 then error("Countdown data must be an indexed table with 5-10 entries.") end
		if voices[id] then error(("Countdown %q already registered."):format(id)) end

		voices[id] = { name = name }
		for i = 1, #data do
			voices[id][i] = data[i]
		end
	end
	function API:GetCountdownList()
		local list = {}
		for k, v in next, voices do
			list[k] = v.name
		end
		return list
	end
	function API:HasCountdown(id)
		return voices[id] and true
	end
	function API:GetCountdownSound(id, index)
		return voices[id] and voices[id][index]
	end
end

--------------------------------------------------------------------------------
-- Bar Styles
--

do
	local currentAPIVersion = 1
	local errorWrongAPI = "The bar style API version is now %d; the bar style %q needs to be updated for this version of BigWigs."
	local errorAlreadyExist = "Trying to register %q as a bar styler, but it already exists."
	local function noop() end
	local barStyles = {}
	function API:RegisterBarStyle(key, styleData)
		if type(key) ~= "string" then error("Bar style must be a string.") end
		if type(styleData) ~= "table" then error("Bar style data must be a table.") end
		if type(styleData.version) ~= "number" then error("Bar style version must be a number.") end
		if type(styleData.apiVersion) ~= "number" then error("Bar style apiVersion must be a number.") end
		if type(styleData.GetStyleName) ~= "function" then error("Bar style GetStyleName must be a function.") end
		if type(styleData:GetStyleName()) ~= "string" then error("Bar style GetStyleName() return must be a string.") end
		if styleData.apiVersion ~= currentAPIVersion then error(errorWrongAPI:format(currentAPIVersion, key)) end
		if barStyles[key] and barStyles[key].version == styleData.version then error(errorAlreadyExist:format(key)) end
		if not barStyles[key] or barStyles[key].version < styleData.version then
			if not styleData.ApplyStyle then styleData.ApplyStyle = noop end
			if not styleData.BarStopped then styleData.BarStopped = noop end
			if not styleData.GetSpacing then styleData.GetSpacing = noop end
			barStyles[key] = styleData
		end
	end
	function API:GetBarStyle(key)
		if type(key) ~= "string" then error("Bar style must be a string.") end
		local style = barStyles[key]
		if style then
			return style
		end
	end
	function API:GetBarStyleList()
		local list = {}
		for k, v in next, barStyles do
			list[k] = v:GetStyleName()
		end
		return list
	end
end

-------------------------------------------------------------------------------
-- Global
--

BigWigsAPI = setmetatable({}, { __index = API, __newindex = function() end, __metatable = false })
