
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

function BigWigsTargetMonitor:OnInitialize()
	for name,module in self.core:IterateModules() do
		self:BigWigs_RegisterForTargetting(module.zonename, module.enabletrigger)
	end
	self:RegisterEvent("BigWigs_RegisterForTargetting")
end


function BigWigsTargetMonitor:OnEnable()
	self:RegisterEvent("BigWigs_RegisterForTargetting")
	self:RegisterEvent("BigWigs_TargetSeen")
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
--~~ 		self:TriggerEvent("BigWigs_Message", L"Target monitoring enabled", "LtBlue", true, false)
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	elseif self.monitoring then
		self.monitoring = nil
--~~ 		self:TriggerEvent("BigWigs_Message", L"Target monitoring disabled", "LtBlue", true, false)
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


function BigWigsTargetMonitor:BigWigs_TargetSeen(mobname, unit)
	for name,module in self.core:IterateModules() do
		if module:IsBossModule() and self:ZoneIsTrigger(module, GetRealZoneText()) and self:MobIsTrigger(module, mobname)
			and (not module.VerifyEnable or module:VerifyEnable(unit)) then
				self.core:EnableModule(name)
		end
	end
end


function BigWigsTargetMonitor:ZoneIsTrigger(module, zone)
	local t = module.zonename
	if type(t) == "string" then return zone == t
	elseif type(t) == "table" then
		for _,mzone in pairs(t) do if mzone == zone then return true end end
	end
end

function BigWigsTargetMonitor:MobIsTrigger(module, name)
	local t = module.enabletrigger
	if type(t) == "string" then return name == t
	elseif type(t) == "table" then
		for _,mob in pairs(t) do if mob == name then return true end end
	end
end
