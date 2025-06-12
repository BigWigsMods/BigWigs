local LibKeystone = LibStub("LibKeystone")
local LibSpec = LibStub("LibSpecialization")

local guildList, partyList = {}, {}

LibKeystone.Register({}, function(keyLevel, keyMap, playerRating, playerName, channel)
	if channel == "PARTY" then
		partyList[playerName] = {keyLevel, keyMap, playerRating}
	elseif channel == "GUILD" then
		guildList[playerName] = {keyLevel, keyMap, playerRating}
	end
end)

local specs = {}
do
	local function addToTable(specID, _, _, playerName)
		specs[playerName] = specID
	end
	LibSpec:Register(specs, addToTable)
	LibSpec.RegisterGuild(specs, addToTable)
end

local roleIcons = {
	TANK = INLINE_TANK_ICON,
	HEALER = INLINE_HEALER_ICON,
	DAMAGER = INLINE_DAMAGER_ICON,
}

SLASH_BigWigsTestKS1 = "/bwks" -- temp
SlashCmdList.BigWigsTestKS = function()
	guildList, partyList = {}, {}
	LibKeystone.Request("PARTY")
	LibKeystone.Request("GUILD")
	LibSpec.RequestGuildSpecialization()
	C_Timer.After(1, function() -- Next step, make a UI
		print("---GUILD---")
		for playerName, playerTable in next, guildList do
			local keyLevel, keyMap, playerRating = playerTable[1], playerTable[2], playerTable[3]
			local specID = specs[playerName]
			if specID then
				local _, _, _, icon, role, classFile = GetSpecializationInfoByID(specID)
				local color = C_ClassColor.GetClassColor(classFile)
				playerName = format("|T%d:0|t%s|c%s%s|r", icon, roleIcons[role] or "", color:GenerateHexColor(), playerName)
			end
			print(("%s: Level %d, Rating %d, Map %s"):format(playerName, keyLevel, playerRating, GetRealZoneText(keyMap)))
		end
		print("---PARTY---")
		for playerName, playerTable in next, partyList do
			local keyLevel, keyMap, playerRating = playerTable[1], playerTable[2], playerTable[3]
			local specID = specs[playerName]
			if specID then
				local _, _, _, icon, role, classFile = GetSpecializationInfoByID(specID)
				local color = C_ClassColor.GetClassColor(classFile)
				playerName = format("|T%d:0|t%s|c%s%s|r", icon, roleIcons[role] or "", color:GenerateHexColor(), playerName)
			end
			print(("%s: Level %d, Rating %d, Map %s"):format(playerName, keyLevel, playerRating, GetRealZoneText(keyMap)))
		end
	end)
end
