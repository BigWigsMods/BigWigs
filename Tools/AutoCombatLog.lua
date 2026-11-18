local L, BigWigsLoader, BigWigsAPI
do
	local _, tbl = ...
	BigWigsAPI = tbl.API
	L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsLoader = tbl.loaderPublic
end

--------------------------------------------------------------------------------
-- Saved Settings
--

local ProfileUtils, db = {}
do
	local globalDefaults = {
		alwaysAsk = false,
		-- Raids
		raidType = 1,
		-- Dungeons
		dungeonType = 1,
		-- Delves
		delveType = 1,
		-- PvP
		pvpType = 1,
	}
	db = BigWigsLoader.db:RegisterNamespace("AutoCombatLog", {global = globalDefaults})

	ProfileUtils.ValidateMainSettings = function()
		for k, v in next, db.profile do
			local defaultType = type(defaults[k])
			if defaultType == "nil" then
				db.profile[k] = nil
			elseif type(v) ~= defaultType then
				db.profile[k] = defaults[k]
			end
		end
		if db.profile.countBegin < 3 or db.profile.countBegin > 9 then
			db.profile.countBegin = defaults.countBegin
		end
	end

	--ProfileUtils.ValidateMainSettings()
end

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Events
--

do
	local raidsForLogging = {
		[14] = true, -- Normal
		[15] = true, -- Heroic
		[16] = true, -- Mythic
		[17] = true, -- LFR
		[33] = true, -- Timewalking (Raid)
	}
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("PLAYER_LEAVING_WORLD")
	local function Check()
		local _, instanceType, difficultyID, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
		if instanceType == "raid" then
			if db.alwaysAsk then
				return
			end
		elseif instanceType == "party" then
			if db.alwaysAsk then
				return
			end
		elseif instanceType == "scenario" then
			if db.alwaysAsk then
				return
			end
		elseif instanceType == "pvp" then
			if db.alwaysAsk then
				return
			end
		elseif instanceType == "arena" then
			if db.alwaysAsk then
				return
			end
		end
	end
	frame:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			local _, _, diffID = BigWigsLoader.GetInstanceInfo()
			BigWigsLoader.CTimerAfter(0, Check) -- Difficulty info isn't accurate until 1 frame after PEW
		elseif event == "PLAYER_LEAVING_WORLD" then
			if LoggingCombat() then
				LoggingCombat(false)
			end
		end
	end)
end

--------------------------------------------------------------------------------
-- Options Table
--

do
	--BigWigsLoader.RegisterMessage({}, "BigWigs_ProfileUpdate", function()
	--	ProfileUtils.ValidateMainSettings()
	--	ProfileUtils.ValidateMediaSettings()
	--	UpdateWidgets()
	--end)

	local function GetSettings(info)
		return db.profile[info[#info]]
	end
	local function UpdateSettings(info, value)
		local key = info[#info]
		db.profile[key] = value
	end
	local function UpdateSettingsAndWidgets(info, value)
		local key = info[#info]
		db.profile[key] = value
		UpdateWidgets()
	end
	local function GetColor(info)
		local colorTable = db.profile[info[#info]]
		return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
	end
	local function UpdateColorAndWidgets(info, r, g, b, a)
		local key = info[#info]
		db.profile[key] = {r, g, b, a < 0.3 and 0.3 or a}
		UpdateWidgets()
	end
	local function IsDisabled() return db.profile.alwaysAsk end
	BigWigsAPI.RegisterToolOptions("AutoCombatLog", {
		name = "XXAuto Combat Log",
		desc = "XXDesc",
		type = "group",
		childGroups = "tab",
		order = 4,
		get = function(info)
			return db.profile[info[#info]]
		end,
		set = function(info, value)
			local entry = info[#info]
			db.profile[entry] = value
		end,
		args = {
			heading = {
				type = "description",
				name = "XXAutomatically activate the Blizzard combat log when entering specific zones.\n\n",
				order = 1,
				width = "full",
				fontSize = "medium",
			},
			alwaysAsk = {
				type = "toggle",
				name = "XXAsk every time you enter a dungeon/raid/etc",
				desc = "XXA popup will show asking you if you want to log every time you enter a dungeon/raid/etc.",
				width = "full",
				order = 2,
			},
			raid = {
				name = "XXRaids",
				type = "group",
				order = 3,
				disabled = IsDisabled,
				args = {
					raidType = {
						type = "select",
						name = "XXChoose the type of raid",
						order = 1,
						values = {
							L.none,
							"XXCurrent expansion raids\ntest",
							"XXAll raids",
							"XXSpecific Raids",
						},
						width = "full",
						style = "radio",
					},
				},
			},
			dungeon = {
				name = "XXDungeons",
				type = "group",
				order = 4,
				disabled = IsDisabled,
				args = {
					dungeonType = {
						type = "select",
						name = "XXChoose the type of dungeon",
						order = 1,
						values = {
							L.none,
							"XXCurrent season dungeons",
							"XXCurrent expansion dungeons",
							"XXAll dungeons",
							"XXSpecific Dungeons",
						},
						width = "full",
						style = "radio",
					},
				},
			},
			delve = {
				name = "XXDelves",
				type = "group",
				order = 5,
				disabled = IsDisabled,
				args = {
					delveType = {
						type = "select",
						name = "XXChoose the type of delve",
						order = 1,
						values = {
							L.none,
							"XXCurrent expansion delves",
							"XXAll delves",
							"XXSpecific delves",
						},
						width = "full",
						style = "radio",
					},
				},
				hidden = function() return not BigWigsLoader.isRetail end,
			},
			pvp = {
				name = "XXPvP",
				type = "group",
				order = 7,
				disabled = IsDisabled,
				args = {
					pvpType = {
						type = "select",
						name = "XXChoose the type of world boss",
						order = 1,
						values = {
							L.none,
							"XXArenas",
							"XXBattlegrounds",
							"XXAll PvP zones",
						},
						width = "full",
						style = "radio",
					},
				},
			},
		},
	})
end
