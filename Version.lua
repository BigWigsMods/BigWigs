assert(BigWigs, "BigWigs not found!")

local L = AceLibrary("AceLocale-2.0"):new("BigWigsVersionQuery")
local tablet = AceLibrary("Tablet-2.0")
local dewdrop = AceLibrary("Dewdrop-2.0")

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
	self.responseString = ""
	
	local BWL = AceLibrary("AceLocale-2.0"):new("BigWigs")
	for name,module in self.core:IterateModules() do
		if module:IsBossModule() and module.zonename and type(module.zonename) == "string" then
			local zone = BWL:HasTranslation(module.zonename) and BWL:GetTranslation(module.zonename) or module.zonename
			local revision = module.revision
			if not self.zoneRevisions[zone] or revision > self.zoneRevisions[zone] then
				self.zoneRevisions[zone] = revision
			end
		end
	end
	BWL = nil

	for key, value in self.zoneRevisions do
		self.responseString = self.responseString.." "..key..":"..value
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
			"showEverythingWhenDetached", true,
			"cantAttach", true,
			"menu", function()
					dewdrop:AddLine(
						'text', "Query",
						'func', function() self:QueryVersion() end)
					dewdrop:AddLine(
						'text', "Close",
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
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", "Player",
		"text2", "Version",
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)
	for name, version in self.responseTable do
		cat:AddLine("text", name, "text2", version)
	end
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
	self.responseTable[UnitName("player")] = self.responseString
	self:UpdateVersions()
	self:TriggerEvent("BigWigs_SendSync", "BWVQ")
end

function BigWigsVersionQuery:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWVQ" and nick ~= UnitName("player") then
		self:TriggerEvent("BigWigs_SendSync", "BWVR "..self.responseString)
	elseif sync == "BWVR" then
		if self.queryRunning and nick and rest then
			self.responseTable[nick] = rest
			self:UpdateVersions()
		end
	end
end
