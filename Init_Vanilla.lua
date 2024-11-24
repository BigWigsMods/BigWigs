
local _, tbl = ...
tbl.isClassic = true
tbl.isVanilla = true
tbl.season = C_Seasons and C_Seasons.GetActiveSeason() or 0
tbl.isSeasonOfDiscovery = tbl.season == 2
