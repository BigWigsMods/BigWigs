-- Very empty for now
local plugin = {}

BigWigs.pluginCore:SetDefaultModulePrototype(plugin)

function plugin:OnInitialize()
	BigWigs:RegisterPlugin(self)
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

