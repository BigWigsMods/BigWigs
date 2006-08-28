assert(BigWigs, "BigWigs not found!")

local BWL = nil
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
	["Query already running, please wait 5 seconds before trying again."] = true,
	["Querying versions for "] = true,
	["BigWigs Version Query"] = true,
	["Close window"] = true, -- I know, it's really a Tablet.
	["Showing version for "] = true,
	["Green versions are newer than yours, red are older, and white are the same. A version of -1 means that the user does not have any modules for this zone."] = true,
	["Player"] = true,
	["Version"] = true,
	["Current zone"] = true,
	["<zone>"] = true,
	["Version query done."] = true,
	["Runs a version query on your current zone."] = true,
	["Closes the version query window."] = true,
	["current"] = true,
	["Runs a version query on the given zone."] = true,
	["Zone"] = true,
	["zone"] = true,
} end )

---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigsVersionQuery = BigWigs:NewModule("Version Query")

BigWigsVersionQuery.consoleCmd = L["versionquery"]
BigWigsVersionQuery.consoleOptions = {
	type = "group",
	name = L["VersionQuery"],
	desc = L["Options for Version Query."],
	args = {
		[L["current"]] = {
			type = "execute",
			name = L["Current zone"],
			desc = L["Runs a version query on your current zone."],
			func = function() BigWigsVersionQuery:QueryVersion() end,
		},
		[L["zone"]] = {
			type = "text",
			name = L["Zone"],
			desc = L["Runs a version query on the given zone."],
			usage = L["<zone>"],
			get = false,
			set = function(zone) BigWigsVersionQuery:QueryVersion(zone) end,
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
	self.currentZone = ""

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
						"text", L["Current zone"],
						"tooltipTitle", L["Current zone"],
						"tooltipText", L["Runs a version query on your current zone."],
						"func", function() self:QueryVersion() end)
					dewdrop:AddLine(
						"text", L["Close window"],
						"tooltipTitle", L["Close window"],
						"tooltipText", L["Closes the version query window."],
						"func", function() tablet:Attach("BigWigs_VersionQuery"); dewdrop:Close() end)
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
		"text", L["Zone"],
		"child_justify1", "LEFT"
	)
	zoneCat:AddLine("text", self.currentZone)
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Version"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)
	for name, version in self.responseTable do
		local color = COLOR_WHITE
		if self.zoneRevisions[self.currentZone] and version > self.zoneRevisions[self.currentZone] then
			color = COLOR_GREEN
		elseif self.zoneRevisions[self.currentZone] and version < self.zoneRevisions[self.currentZone] then
			color = COLOR_RED
		end
		cat:AddLine("text", name, "text2", "|cff"..color..version.."|r")
	end

	tablet:SetHint(L["Green versions are newer than yours, red are older, and white are the same. A version of -1 means that the user does not have any modules for this zone."])
end

function BigWigsVersionQuery:QueryVersion(zone)
	if self.queryRunning then
		self.core:Print(L["Query already running, please wait 5 seconds before trying again."])
		return
	end
	if not zone or zone == "" then zone = GetRealZoneText() end

	self.currentZone = zone

	self.core:Print(L["Querying versions for "].."|cff"..COLOR_GREEN..zone.."|r.")

	self.queryRunning = true
	self:ScheduleEvent(	function()
							self.queryRunning = nil
							self.core:Print(L["Version query done."])
						end, 5)

	self.responseTable = {}
	if not self.zoneRevisions[zone] then
		self.responseTable[UnitName("player")] = -1
	else
		self.responseTable[UnitName("player")] = self.zoneRevisions[zone]
	end
	self:UpdateVersions()
	self:TriggerEvent("BigWigs_SendSync", "BWVQ "..zone)
end

--[[ Parses the old style reply, which was MC:REV BWL:REV, etc. ]]
function BigWigsVersionQuery:ParseReply(reply)
	local pos = 1
	local zonePairs = {}

	while 1 do
		local first, last = strfind(reply, " ", pos)
		if first then -- found?
			tinsert(zonePairs, strsub(reply, pos, first-1))
			pos = last+1
		else
			tinsert(zonePairs, strsub(reply, pos))
			break
		end
	end

	if not BWL then BWL = AceLibrary("AceLocale-2.0"):new("BigWigs") end

	for key, zonePair in zonePairs do
		local colonIndex = strfind(zonePair, ":")
		if colonIndex then
			local zone = strsub(zonePair, 1, colonIndex - 1)
			local realZone = BWL:HasReverseTranslation(zone) and BWL:GetReverseTranslation(zone) or zone
			if realZone == self.currentZone or zone == self.currentZone then
				local revision = strsub(zonePair, colonIndex + 1)
				if tonumber(revision) ~= nil then
					return tonumber(revision)
				end
			end
		end
	end
	return -1
end

function BigWigsVersionQuery:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWVQ" and nick ~= UnitName("player") and rest then
		if not self.zoneRevisions[rest] then
			self:TriggerEvent("BigWigs_SendSync", "BWVR -1")
		else
			self:TriggerEvent("BigWigs_SendSync", "BWVR " .. self.zoneRevisions[rest])
		end
	elseif sync == "BWVR" and self.queryRunning and nick and rest then
		if tonumber(rest) == nil then rest = self:ParseReply(rest) end
		self.responseTable[nick] = tonumber(rest)
		self:UpdateVersions()
	end
end
