-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("BossBlock")
if not plugin then return end

-------------------------------------------------------------------------------
-- Database
--

plugin.defaultDB = {
	affixes = {
		"afflicted",
	},
}

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
--plugin.displayName = L.dungeonTools
local CL = BigWigsAPI:GetLocale("BigWigs: Common")

-------------------------------------------------------------------------------
-- Options
--


local C = BigWigs.C
local bit_band = bit.band
local colors = nil -- key to message color map

-- for emphasized options
function mod:CheckOption(key, flag)
	return self.db.profile[key] and bit_band(self.db.profile[key], C[flag]) == C[flag]
end

plugin.pluginOptions = {
	name = "Dungeon Tools",
	--desc = L.bossBlockDesc,
	type = "group",
	childGroups = "tab",
	order = 8.5,
	get = function(info)
		return plugin.db.profile[info[#info]]
	end,
	set = function(info, value)
		local entry = info[#info]
		plugin.db.profile[entry] = value
	end,
	args = {
		general = {
			type = "group",
			name = CL.affixes,
			order = 1,
			args = {
				heading = {
					type = "description",
					name = L.bossBlockDesc,
					order = 0,
					width = "full",
					fontSize = "medium",
				},
				blockEmotes = {
					type = "toggle",
					name = L.blockEmotes,
					desc = L.blockEmotesDesc,
					width = "full",
					order = 1,
				},
			},
		},
		other = {
			type = "group",
			name = "Other",
			order = 2,
			disabled = function() return true end,
			args = {
				--heading = {
				--	type = "description",
				--	name = "",
				--	order = 0,
				--	width = "full",
				--	fontSize = "medium",
				--},
			},
		},
	},
}

--------------------------------------------------------------------------------
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
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()


	end
end

function plugin:OnPluginDisable()

end

-------------------------------------------------------------------------------
-- Event Handlers
--


