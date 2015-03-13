
local addonName = ...
if addonName == "BigWigs_Core" then
	BigWigs:Initialize()
else
	BigWigs:RegisterMessage("Private_InitLoader", "Initialize")
end

