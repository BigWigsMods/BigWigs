-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Rename")
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
	return module.altNames and module.altNames[key] or module:SpellName(key, true)
end

function plugin:GetName(module, key)
	if type(module) == "string" then module = BigWigs:GetBossModule(module, true) end
	if not module or not key then
		BigWigs:Error(("Rename: Missing module or key (%q, %q)"):format(tostringall(module, key)))
		return
	end
	local altName = module.altNames and module.altNames[key]
	local moduleDb = self.db.profile[module.name]
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
	if value and not self.db.profile[moduleName] then
		self.db.profile[moduleName] = {}
	end
	self.db.profile[moduleName][key] = value
	module:SetSpellRename(key, value)
end
