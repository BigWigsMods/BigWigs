
local API = {}

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
-- BarStyles
--

BigWigsAPI = API
