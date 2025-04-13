-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, CL = BigWigs:NewPlugin("Rename", {
	"GetDefaultName",
	"GetName",
	"SetName",
})
if not plugin then return end

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {}

--------------------------------------------------------------------------------
-- API
--

function plugin:GetDefaultName(module, key)
	if type(module) == "string" then module = BigWigs:GetBossModule(module, true) end
	if not module or not key then
		BigWigs:Error(("Rename: Missing module or key (%q, %q)"):format(tostringall(module, key)))
		return
	end
	local altName = module.altNames and module.altNames[key]
	if altName == CL.mythic then altName = nil end -- XXX using altnames as labels/descriptors z.z
	return altName or module:SpellName(key, true)
end

function plugin:GetName(module, key)
	if type(module) == "string" then module = BigWigs:GetBossModule(module, true) end
	if not module or not key then
		BigWigs:Error(("Rename: Missing module or key (%q, %q)"):format(tostringall(module, key)))
		return
	end
	local altName = module.altNames and module.altNames[key]
	if altName == CL.mythic then altName = nil end
	local moduleDb = plugin.db.profile[module.name]
	return moduleDb and moduleDb[key] or altName
end

function plugin:SetName(module, key, value)
	if type(module) == "string" then module = BigWigs:GetBossModule(module, true) end
	if not module or not key then
		BigWigs:Error(("Rename: Missing module or key (%q, %q)"):format(tostringall(module, key)))
		return
	end
	if value == "" then
		value = nil
	end
	local moduleName = module.name
	if value and not plugin.db.profile[moduleName] then
		plugin.db.profile[moduleName] = {}
	end
	plugin.db.profile[moduleName][key] = value
	module:SetSpellRename(key, value)
end
