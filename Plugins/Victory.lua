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

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	soundName = "BigWigs: Victory",
	blizzVictory = false,
	bigwigsVictory = true,
}

plugin.pluginOptions = {
	name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Victory:20|t ".. L.Victory,
	type = "group",
	childGroups = "tab",
	get = function(i) return plugin.db.profile[i[#i]] end,
	set = function(i, value)
		local n = i[#i]
		plugin.db.profile[n] = value
		if n == "blizzVictory" then
			if value then
				BossBanner:RegisterEvent("BOSS_KILL")
			else
				BossBanner:UnregisterEvent("BOSS_KILL")
			end
		end
	end,
	order = 7,
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
				bigwigsVictory = {
					type = "toggle",
					name = L.victoryMessageBigWigs,
					desc = L.victoryMessageBigWigsDesc,
					order = 1,
					width = "full",
				},
				blizzVictory = {
					type = "toggle",
					name = L.victoryMessageBlizzard,
					desc = L.victoryMessageBlizzardDesc,
					order = 2,
					width = "full",
					hidden = BigWigsLoader.isClassic,
				},
			},
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

do
	local function updateProfile()
		local db = plugin.db.profile

		for k, v in next, db do
			local defaultType = type(plugin.defaultDB[k])
			if defaultType == "nil" then
				db[k] = nil
			elseif type(v) ~= defaultType then
				db[k] = plugin.defaultDB[k]
			end
		end
	end

	function plugin:OnPluginEnable()
		if not self.db.profile.blizzVictory and BossBanner then
			BossBanner:UnregisterEvent("BOSS_KILL")
		end
		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_VictorySound")

		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossWin(event, module)
	if self.db.profile.bigwigsVictory then
		self:SendMessage("BigWigs_Message", self, nil, L.defeated:format(module.displayName), "green")
	end
end

function plugin:BigWigs_VictorySound()
	local soundName = self.db.profile.soundName
	if soundName ~= "None" then
		local sound = media:Fetch(SOUND, soundName, true)
		if sound then
			self:PlaySoundFile(sound)
		end
	end
end
