-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Victory")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	sound = true,
	blizzMsg = true,
	bigwigsMsg = true,
}

plugin.pluginOptions = {
	name = "Victory",
	type = "group",
	childGroups = "tab",
	get = function(i) return plugin.db.profile[i[#i]] end,
	set = function(i, value)
		local n = i[#i]
		plugin.db.profile[n] = value
		if n == "blizzMsg" then
			if value then
				BossBanner:RegisterEvent("BOSS_KILL")
			else
				BossBanner:UnregisterEvent("BOSS_KILL")
			end
		end
	end,
	args = {
		heading = {
			type = "description",
			name = "Configure the actions that should be taken after you defeat a boss encounter.".."\n\n",
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		sound = {
			type = "toggle",
			name = "Play the Victory sound",
			order = 2,
			width = "full",
		},
		messages = {
			type = "group",
			name = "Show boss defeat messages",
			desc = "The Victory sound is configurable in the Sound options.",
			order = 3,
			inline = true,
			args = {
				bigwigsMsg = {
					type = "toggle",
					name = "Show the Big Wigs message",
					order = 1,
					width = "full",
				},
				blizzMsg = {
					type = "toggle",
					name = "Show the Blizzard message",
					order = 2,
					width = "full",
				},
			},
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	if not self.db.profile.blizzMsg then
		BossBanner:UnregisterEvent("BOSS_KILL")
	end
	self:RegisterMessage("BigWigs_OnBossWin")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossWin(event, module)
	if self.db.profile.bigwigsMsg then
		self:SendMessage("BigWigs_Message", self, nil, L.defeated:format(module.displayName), "Positive")
	end
	if self.db.profile.sound then
		self:SendMessage("BigWigs_Sound", self, nil, "Victory")
	end
end

