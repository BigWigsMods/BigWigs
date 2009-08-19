---------------------------------
--      Addon Declaration      --
---------------------------------

local plugin = BigWigs:New("Target Monitor", "$Revision$")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local enablezones, enablemobs, enableyells = {}, {}, {}
local monitoring = nil

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	monitoring = nil
	for name, module in BigWigs:IterateModules() do
		if module.zonename and module.enabletrigger then
			self:RegisterZone(module.zonename)
			self:RegisterMob(module)
		end
	end

	self:RegisterEvent("BigWigs_ModulePackLoaded", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	self:RegisterEvent("BigWigs_ModuleRegistered")
	self:RegisterEvent("Ace2_AddonDisabled")
	self:RegisterEvent("Ace2_AddonEnabled")
	self:ZoneChanged()
end

function plugin:RegisterZone(zone)
	if type(zone) == "string" then enablezones[zone] = true
	else for i,z in next, zone do enablezones[z] = true end end
end
function plugin:RegisterMob(mod)
	local mob = mod.enabletrigger
	if type(mob) == "function" then enableyells[mob] = mod
	elseif type(mob) == "string" then enablemobs[mob] = mod
	else for i,m in next, mob do enablemobs[m] = mod end end
end
function plugin:UnregisterMob(mob)
	if type(mob) == "function" then enableyells[mob] = nil
	elseif type(mob) == "string" then enablemobs[mob] = nil
	else for i,m in next, mob do enablemobs[m] = nil end end
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:Ace2_AddonEnabled(mod)
	if mod and mod.enabletrigger then
		self:UnregisterMob(mod.enabletrigger)
	end
end

function plugin:Ace2_AddonDisabled(mod)
	if mod and mod.enabletrigger then
		self:RegisterMob(mod)
	end
end

function plugin:BigWigs_ModuleRegistered(m)
	local mod = BigWigs:GetModule(m)
	if mod and mod.enabletrigger then
		self:RegisterZone(mod.zonename)
		self:RegisterMob(mod)
	end
end

function plugin:ZoneChanged()
	if enablezones[GetRealZoneText()] or enablezones[GetSubZoneText()] or enablezones[GetZoneText()] then
		if not monitoring then
			monitoring = true
			self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
			self:RegisterEvent("PLAYER_TARGET_CHANGED")
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		end
	elseif monitoring then
		monitoring = nil
		self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end

local function targetCheck(unit)
	local n = UnitName(unit)
	if not n or not enablemobs[n] or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then return end
	plugin:TriggerEvent("BigWigs_TargetSeen", n, unit, enablemobs[n].name)
end

function plugin:CHAT_MSG_MONSTER_YELL(msg, source)
	for func, mod in pairs(enableyells) do
		local yell = func()
		if yell == msg then
			self:TriggerEvent("BigWigs_TargetSeen", source, "player", mod.name)
		end
	end
end
function plugin:UPDATE_MOUSEOVER_UNIT() targetCheck("mouseover") end
function plugin:PLAYER_TARGET_CHANGED() targetCheck("target") end

