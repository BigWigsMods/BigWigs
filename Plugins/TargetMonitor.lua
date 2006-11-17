
------------------------------
--      Are you local?      --
------------------------------

local enablezones, enablemobs = {}, {}


---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigsTargetMonitor = BigWigs:NewModule("Target Monitor")


------------------------------
--      Initialization      --
------------------------------

function BigWigsTargetMonitor:OnRegister()
	for name,module in self.core:IterateModules() do
		self:BigWigs_RegisterForTargetting(module.zonename, module.enabletrigger)
	end
	self:RegisterEvent("BigWigs_RegisterForTargetting")
end


function BigWigsTargetMonitor:OnEnable()
	self:RegisterEvent("BigWigs_RegisterForTargetting")
	self:RegisterEvent("BigWigs_ModulePackLoaded", "ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:ZONE_CHANGED_NEW_AREA()
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTargetMonitor:BigWigs_RegisterForTargetting(zone, mob)
	if type(zone) == "string" then enablezones[zone] = true
	elseif type(zone) == "table" then
		for _,z in pairs(zone) do enablezones[z] = true end
	end

	if type(mob) == "string" then enablemobs[mob] = true
	elseif type(mob) == "table" then
		for _,m in pairs(mob) do enablemobs[m] = true end
	end
end


function BigWigsTargetMonitor:ZONE_CHANGED_NEW_AREA()
	if enablezones[GetRealZoneText()] then
		self.monitoring = true
--~~ 		self:TriggerEvent("BigWigs_Message", L["Target monitoring enabled"], "LtBlue", true, false)
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	elseif self.monitoring then
		self.monitoring = nil
--~~ 		self:TriggerEvent("BigWigs_Message", L["Target monitoring disabled"], "LtBlue", true, false)
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end


function BigWigsTargetMonitor:UPDATE_MOUSEOVER_UNIT()
	self:TargetCheck("mouseover")
end


function BigWigsTargetMonitor:PLAYER_TARGET_CHANGED()
	self:TargetCheck("target")
end


function BigWigsTargetMonitor:TargetCheck(unit)
	local n = UnitName(unit)
	if not n or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then return end
	if enablemobs[n] then self:TriggerEvent("BigWigs_TargetSeen", n, unit) end
end

