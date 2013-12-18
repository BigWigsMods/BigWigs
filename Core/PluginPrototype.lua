
local core = BigWigs

local plugin = {}
core:GetModule("Plugins"):SetDefaultModulePrototype(plugin)

function plugin:OnInitialize()
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
	local raidList = {}
	for i = 1, 40 do
		raidList[i] = format("raid%d", i)
	end
	function plugin:GetRaidList()
		return raidList
	end
end

do
	local partyList = {}
	partyList[1] = "player"
	for i = 1, 4 do
		partyList[i+1] = format("party%d", i)
	end
	function plugin:GetPartyList()
		return partyList
	end
end

