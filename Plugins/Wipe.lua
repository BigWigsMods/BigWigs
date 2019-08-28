-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Wipe")
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
	wipeSound = "None",
	respawnBar = true,
}

plugin.pluginOptions = {
	name = L.wipe,
	type = "group",
	childGroups = "tab",
	get = function(i) return plugin.db.profile[i[#i]] end,
	set = function(i, value)
		local n = i[#i]
		plugin.db.profile[n] = value
	end,
	args = {
		wipeSound = {
			type = "select",
			name = L.wipeSoundTitle,
			order = 1,
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
			width = 2,
			itemControl = "DDI-Sound",
		},
		spacer = {
			type = "description",
			name = "\n",
			order = 1.1,
			width = "full",
		},
		respawnBar = {
			type = "toggle",
			name = L.showRespawnBar,
			desc = L.showRespawnBarDesc,
			order = 2,
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
	if status == 0 and module and module.journalId then
		if module.respawnTime and self.db.profile.respawnBar then
			self:SendMessage("BigWigs_StartBar", self, nil, L.respawn, module.respawnTime, 236372) -- 236372 = "Interface\\Icons\\achievement_bg_returnxflags_def_wsg"
		end
		local soundName = self.db.profile.wipeSound
		if soundName ~= "None" then
			local sound = media:Fetch(SOUND, soundName, true)
			if sound then
				PlaySoundFile(sound, "Master")
			end
		end
	end
end
