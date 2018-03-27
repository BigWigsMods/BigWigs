-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Respawn")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	respawnBar = true,
}

plugin.pluginOptions = {
	name = L.respawn,
	type = "group",
	childGroups = "tab",
	get = function(i) return plugin.db.profile[i[#i]] end,
	set = function(i, value)
		local n = i[#i]
		plugin.db.profile[n] = value
	end,
	args = {
		respawnBar = {
			type = "toggle",
			name = L.showRespawnBar,
			desc = L.showRespawnBarDesc,
			order = 1,
			width = "full",
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_EncounterEnd")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_EncounterEnd(_, module, _, _, _, _, status)
	if status == 0 and module.respawnTime and self.db.profile.respawnBar then
		self:SendMessage("BigWigs_StartBar", self, nil, L.respawn, module.respawnTime, 236372) -- 236372 = "Interface\\Icons\\achievement_bg_returnxflags_def_wsg"
	end
end

