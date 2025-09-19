local BigWigsLoader
do
	local _, tbl = ...
	BigWigsLoader = tbl.loaderPublic
end

--------------------------------------------------------------------------------
-- Saved Settings
--

local ProfileUtils, db = {}
do
	local defaults
	do
		local loc = GetLocale()
		local isWest = loc ~= "koKR" and loc ~= "zhCN" and loc ~= "zhTW" and true
		local fontName = isWest and "Noto Sans Medium" or LibStub("LibSharedMedia-3.0"):GetDefault("font")

		defaults = {
			imported = false,
			disabled = true,
			mode = 1,
			lock = false,
			size = 50,
			position = {"CENTER", "CENTER", 500, -50},
			textXPositionDuration = 0,
			textYPositionDuration = 0,
			textXPositionCharges = 0,
			textYPositionCharges = 0,
			fontName = fontName,
			durationFontSize = 14,
			durationEmphasizeFontSize = 14,
			chargesNoneFontSize = 14,
			chargesAvailableFontSize = 14,
			durationAlign = "LEFT",
			chargesAlign = "RIGHT",
			monochrome = false,
			outline = "OUTLINE",
			borderName = "Solid",
			borderColor = {0, 0, 0, 1},
			borderOffset = 0,
			borderSize = 2,
			durationColor = {1, 1, 1, 1},
			durationEmphasizeColor = {1, 1, 1, 1},
			chargesNoneColor = {1, 1, 1, 1},
			chargesAvailableColor = {1, 1, 1, 1},
			newResAvailableSound = "None",
			durationEmphasizeTime = 0,
			iconColor = {1, 1, 1, 1},
			iconTextureFromSpellID = 20484, -- Rebirth icon
			iconDesaturate = 3,
			cooldownEdge = true,
			cooldownSwipe = true,
			cooldownInverse = false,
		}
	end
	db = BigWigsLoader.db:RegisterNamespace("BattleRes", {profile = defaults})
end
