
local core = BigWigs

local plugin = {}
core:GetModule("Plugins"):SetDefaultModulePrototype(plugin)

function plugin:Initialize()
	core:RegisterPlugin(self)
end

function plugin:OnEnable()
	if type(self.OnPluginEnable) == "function" then
		self:OnPluginEnable()
	end
	self:SendMessage("BigWigs_OnPluginEnable", self)
end

function plugin:OnDisable()
	if type(self.OnPluginDisable) == "function" then
		self:OnPluginDisable()
	end
	self:SendMessage("BigWigs_OnPluginDisable", self)
end

function plugin:IsBossModule() return end

do
	local UnitName = UnitName
	function plugin:UnitName(unit, trimServer)
		local name, server = UnitName(unit)
		if not name then
			return
		elseif server and server ~= "" then
			name = name .. (trimServer and "*" or "-"..server)
		end
		return name
	end
end

do
	local raidList = {
		"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
		"raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
		"raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
		"raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
	}
	function plugin:GetRaidList()
		return raidList
	end
end

do
	local partyList = {"player", "party1", "party2", "party3", "party4"}
	function plugin:GetPartyList()
		return partyList
	end
end

function plugin:UpdateGUI()
	local acr = LibStub("AceConfigRegistry-3.0", true)
	if acr then
		acr:NotifyChange("BigWigs")
	end
end

