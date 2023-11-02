
local _, tbl = ...

tbl.guildVersion = 0 -- Must use rounded values e.g. 1, 2, 3, you can always reset this after an expansion if high numbers triggers you
tbl.guildName = "" -- Guild name, used as identification for your version. e.g. "coolguild" or "coolwigs" try to keep it unique
tbl.guildWarn = "Your guild version of BigWigs is old" -- Message displayed for being 1 version out of date
-- Most guilds will want to ignore everything below here
tbl.guildDisableContentWarnings = false -- For guilds with unusual custom setups (everything combined into 1 addon but is auto packaged instead of being detected as REPO)
