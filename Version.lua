assert(BigWigs, "BigWigs not found!")

local L = AceLibrary("AceLocale-2.0"):new("BigWigsVersionQuery")
local tablet = AceLibrary("Tablet-2.0")
local dewdrop = AceLibrary("Dewdrop-2.0")

local COLOR_GREEN = "00ff00"
local COLOR_RED = "ff0000"
local COLOR_WHITE = "ffffff"

---------------------------------
--      Localization           --
---------------------------------

L:RegisterTranslations("enUS", function() return {
	["versionquery"] = true,
	["VersionQuery"] = true,
	["Options for Version Query."] = true,
	["query"] = true,
	["Query"] = true,
	["Query the raid for BigWig versions."] = true,
	["Query already running, please wait 5 seconds before you query again."] = true,
	["Querying raid for BigWigs versions, please wait..."] = true,
	["BigWigs Version Query"] = true,
	["Close window"] = true, -- I know, it's really a Tablet.
	["Showing version for "] = true,
	["Green versions are newer than yours, red are older, and white are the same. A version of -1 means that the user does not have any modules for this zone."] = true,
	["Player"] = true,
	["Version"] = true,
	["Current zone"] = true,
} end )

L:RegisterTranslations("zhCN", function() return {
	["VersionQuery"] = "版本检测",
	["Options for Version Query."] = "版本检测设置。",
	["Query"] = "检测",
	["Query the raid for BigWig versions."] = "检测团队成员的BigWigs版本。",
	["Query already running, please wait 5 seconds before you query again."] = "检测正在进行，请5秒后再进行检测。",
	["Querying raid for BigWigs versions, please wait..."] = "正在检测团队成员的BigWigs版本，请稍侯……",
} end )

L:RegisterTranslations("deDE", function() return {
	-- ["versionquery"] = true,
	["VersionQuery"] = "Versions Abfrage",
	["Options for Version Query."] = "Optionen f\195\188r die Versions Abfrage.",
	-- ["query"] = true,
	["Query"] = "Abfrage",
	["Query the raid for BigWig versions."] = "Abfrage des Raids nach verwendeten BigWigs Versionen.",
	["Query already running, please wait 5 seconds before you query again."] = "Abfrage l\195\164uft bereits, bitte warte 5 Sekunden bevor du erneut abfragst.",
	["Querying raid for BigWigs versions, please wait..."] = "Abfrage des Raids nach verwendeten BigWigs Versionen, bitte warten...",
} end )

---------------------------------
--      Addon Declaration      --
---------------------------------

--[[
--
-- Todo: Make the query command accept text input to check for other zones
--       than the one you are currently in.
--
--]]

BigWigsVersionQuery = BigWigs:NewModule("Version Query")

BigWigsVersionQuery.consoleCmd = L["versionquery"]
BigWigsVersionQuery.consoleOptions = {
	type = "group",
	name = L["VersionQuery"],
	desc = L["Options for Version Query."],
	args   = {
		[L["query"]] = {
			type = "execute",
			name = L["Query"],
			desc = L["Query the raid for BigWig versions."],
			func = function() BigWigsVersionQuery:QueryVersion() end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsVersionQuery:OnEnable()
	self.queryRunning = nil
	self.responseTable = {}
	self.zoneRevisions = {}

	for name,module in self.core:IterateModules() do
		if module:IsBossModule() and module.zonename and type(module.zonename) == "string" then
			if not self.zoneRevisions[module.zonename] or module.revision > self.zoneRevisions[module.zonename] then
				self.zoneRevisions[module.zonename] = module.revision
			end
		end
	end

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsVersionQuery:UpdateVersions()
	if not tablet:IsRegistered("BigWigs_VersionQuery") then
		tablet:Register("BigWigs_VersionQuery",
			"children", function() tablet:SetTitle(L["BigWigs Version Query"])
				self:OnTooltipUpdate() end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true,
			"menu", function()
					dewdrop:AddLine(
						'text', L["Query"],
						'func', function() self:QueryVersion() end)
					dewdrop:AddLine(
						'text', L["Close window"],
						'func', function() tablet:Attach("BigWigs_VersionQuery"); dewdrop:Close() end)
				end
		)
	end
	if tablet:IsAttached("BigWigs_VersionQuery") then
		tablet:Detach("BigWigs_VersionQuery")
	else
		tablet:Refresh("BigWigs_VersionQuery")
	end
end

function BigWigsVersionQuery:OnTooltipUpdate()
	local zoneCat = tablet:AddCategory(
		"columns", 1,
		"text", L["Current zone"],
		"child_justify1", "LEFT"
	)
	zoneCat:AddLine("text", GetRealZoneText())
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Version"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)
	local zone = GetRealZoneText()	
	for name, version in self.responseTable do
		local color = COLOR_WHITE
		if self.zoneRevisions[zone] and version > self.zoneRevisions[zone] then
			color = COLOR_GREEN
		elseif self.zoneRevisions[zone] and version < self.zoneRevisions[zone] then
			color = COLOR_RED
		end
		cat:AddLine("text", name, "text2", "|cff"..color..version.."|r")
	end

	tablet:SetHint(L["Green versions are newer than yours, red are older, and white are the same. A version of -1 means that the user does not have any modules for this zone."])
end

function BigWigsVersionQuery:QueryVersion()
	if self.queryRunning then
		self.core:Print(L["Query already running, please wait 5 seconds before you query again."])
		return
	end

	self.core:Print(L["Querying raid for BigWigs versions, please wait..."])

	self.queryRunning = true
	self:ScheduleEvent(function() BigWigsVersionQuery.queryRunning = nil end, 5)

	self.responseTable = {}
	if not self.zoneRevisions[GetRealZoneText()] then
		self.responseTable[UnitName("player")] = -1
	else
		self.responseTable[UnitName("player")] = self.zoneRevisions[GetRealZoneText()]
	end
	self:UpdateVersions()
	self:TriggerEvent("BigWigs_SendSync", "BWVQ "..GetRealZoneText())
end

function BigWigsVersionQuery:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWVQ" and nick ~= UnitName("player") and rest then
		if not self.zoneRevisions[rest] then
			self:TriggerEvent("BigWigs_SendSync", "BWVR -1")
		else
			self:TriggerEvent("BigWigs_SendSync", "BWVR " .. self.zoneRevisions[rest])
		end
	elseif sync == "BWVR" and self.queryRunning and nick and rest and tonumber(rest) ~= nil then
		self.responseTable[nick] = tonumber(rest)
		self:UpdateVersions()
	end
end
