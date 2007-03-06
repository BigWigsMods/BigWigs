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

function plugin:OnRegister()
	for name,module in self.core:IterateModules() do
		self:BigWigs_RegisterForTargetting(module.zonename, module.enabletrigger)
	end
	self:RegisterEvent("BigWigs_RegisterForTargetting")
end

function plugin:OnEnable()
	monitoring = nil

	self:RegisterEvent("BigWigs_RegisterForTargetting")
	self:RegisterEvent("BigWigs_ModulePackLoaded", "ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:ZONE_CHANGED_NEW_AREA()
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:BigWigs_RegisterForTargetting(zone, mob)
	if type(zone) == "string" then enablezones[zone] = true
	elseif type(zone) == "table" then
		for _,z in pairs(zone) do enablezones[z] = true end
	end

	if type(mob) == "string" then enablemobs[mob] = true
	elseif type(mob) == "table" then
		for _,m in pairs(mob) do enablemobs[m] = true end
	end
end

function plugin:ZONE_CHANGED_NEW_AREA()
	if not monitoring and (enablezones[GetRealZoneText()] or enablezones[GetSubZoneText()] or enablezones[GetZoneText()]) then
		monitoring = true
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
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

