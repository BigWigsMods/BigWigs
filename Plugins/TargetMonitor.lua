------------------------------
--      Are you local?      --
------------------------------

local enablezones, enablemobs = {}, {}

local monitoring = nil

---------------------------------
--      Addon Declaration      --
---------------------------------

local plugin = BigWigs:NewModule("Target Monitor")
plugin.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	monitoring = nil

	for name, module in BigWigs:IterateModules() do
		if module.zonename and module.enabletrigger then
			self:RegisterForTargetting(module.zonename, module.enabletrigger)
		end
	end

	self:RegisterEvent("BigWigs_ModulePackLoaded", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	self:RegisterEvent("BigWigs_ModuleRegistered")
	self:ZoneChanged()
end

function plugin:RegisterForTargetting(zone, mob)
	if type(zone) == "string" then enablezones[zone] = true
	elseif type(zone) == "table" then
		for _,z in pairs(zone) do enablezones[z] = true end
	end

	if type(mob) == "string" then enablemobs[mob] = true
	elseif type(mob) == "table" then
		for _,m in pairs(mob) do enablemobs[m] = true end
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:BigWigs_ModuleRegistered(name)
	local mod = BigWigs:GetModule(name)
	if mod and mod.zonename and mod.enabletrigger then
		self:RegisterForTargetting(mod.zonename, mod.enabletrigger)
	end
end

function plugin:ZoneChanged()
	if enablezones[GetRealZoneText()] or enablezones[GetSubZoneText()] or enablezones[GetZoneText()] then
		if not monitoring then
			monitoring = true
			self:RegisterEvent("PLAYER_TARGET_CHANGED")
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		end
	elseif monitoring then
		monitoring = nil
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end

function plugin:UPDATE_MOUSEOVER_UNIT()
	self:TargetCheck("mouseover")
end

function plugin:PLAYER_TARGET_CHANGED()
	self:TargetCheck("target")
end

function plugin:TargetCheck(unit)
	local n = UnitName(unit)
	if not n or not enablemobs[n] or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then return end
	self:TriggerEvent("BigWigs_TargetSeen", n, unit)
end

