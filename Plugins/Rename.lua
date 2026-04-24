-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Rename", {
	"GetDefaultName",
	"GetName",
	"SetName",
})
if not plugin then return end

local CL = BigWigsAPI:GetLocale("BigWigs: Common")

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {}

--------------------------------------------------------------------------------
-- API
--

function plugin:GetDefaultName(module, key)
	if not module or not key then
		BigWigs:Error(("Rename: Missing module or key (%q, %q)"):format(tostring(module), tostring(key)))
		return
	end

	local moduleLocale = module:GetLocale()

	-- Check if there is a module set rename
	if module.renameOptions and module.renameOptions[key] then
		local replacementKey = module.renameOptions[key][1]
		if replacementKey then
			return moduleLocale[replacementKey] or CL[replacementKey]
		end
	end
	-- Return spell name or localized string
	if type(key) == "number" then
		return module:SpellName(key)
	end
	return moduleLocale[key]
end

function plugin:GetName(module, key)
	if not module or not key then
		BigWigs:Error(("Rename: Missing module or key (%q, %q)"):format(tostring(module), tostring(key)))
		return
	end

	local moduleName = module.name
	local name = plugin.db.profile[moduleName] and plugin.db.profile[moduleName][key]
	if not name and module.renameOptions and module.renameOptions[key] then
		local replacementKey = module.renameOptions[key][1]
		if replacementKey then
			local moduleLocale = module:GetLocale()
			name = moduleLocale[replacementKey] or CL[replacementKey]
		end
	end
	return name
end

function plugin:SetName(module, key, value)
	if not module or not key then
		BigWigs:Error(("Rename: Missing module or key (%q, %q)"):format(tostring(module), tostring(key)))
		return
	end

	if value == "" or value == self:GetDefaultName(module, key) then
		value = nil
	elseif value then
		value = strtrim(value)
		if value == "" then
			value = nil
		end
	end

	local moduleName = module.name
	if value and not plugin.db.profile[moduleName] then
		plugin.db.profile[moduleName] = {}
	end
	plugin.db.profile[moduleName][key] = value
end
