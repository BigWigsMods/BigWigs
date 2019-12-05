-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Victory")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
local SOUND = media.MediaType and media.MediaType.SOUND or "sound"
local PlaySoundFile = PlaySoundFile

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	soundName = "BigWigs: Victory",
	--blizzMsg = true,
	bigwigsMsg = false,
}

plugin.pluginOptions = {
	name = L.Victory,
	type = "group",
	childGroups = "tab",
	get = function(i) return plugin.db.profile[i[#i]] end,
	set = function(i, value)
		local n = i[#i]
		plugin.db.profile[n] = value
		--if n == "blizzMsg" then
		--	if value then
		--		BossBanner:RegisterEvent("BOSS_KILL")
		--	else
		--		BossBanner:UnregisterEvent("BOSS_KILL")
		--	end
		--end
	end,
	args = {
		heading = {
			type = "description",
			name = L.victoryHeader.."\n\n",
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		soundName = {
			type = "select",
			name = L.victorySound,
			order = 2,
			get = function(info)
				for i, v in next, media:List(SOUND) do
					if v == plugin.db.profile[info[#info]] then
						return i
					end
				end
			end,
			set = function(info, value)
				plugin.db.profile[info[#info]] = media:List(SOUND)[value]
			end,
			values = media:List(SOUND),
			width = "full",
			itemControl = "DDI-Sound",
		},
		messages = {
			type = "group",
			name = L.victoryMessages,
			order = 3,
			inline = true,
			args = {
				bigwigsMsg = {
					type = "toggle",
					name = L.victoryMessageBigWigs,
					desc = L.victoryMessageBigWigsDesc,
					order = 1,
					width = "full",
				},
				--blizzMsg = {
				--	type = "toggle",
				--	name = L.victoryMessageBlizzard,
				--	desc = L.victoryMessageBlizzardDesc,
				--	order = 2,
				--	width = "full",
				--},
			},
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	--if not self.db.profile.blizzMsg then
	--	BossBanner:UnregisterEvent("BOSS_KILL")
	--end
	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_VictorySound")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossWin(event, module)
	if self.db.profile.bigwigsMsg then
		self:SendMessage("BigWigs_Message", self, nil, L.defeated:format(module.displayName), "green")
	end
end

function plugin:BigWigs_VictorySound()
	local soundName = self.db.profile.soundName
	if soundName ~= "None" then
		local sound = media:Fetch(SOUND, soundName, true)
		if sound then
			PlaySoundFile(sound, "Master")
		end
	end
end
