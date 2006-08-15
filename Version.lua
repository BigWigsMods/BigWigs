assert(BigWigs, "BigWigs not found!")

local L = AceLibrary("AceLocale-2.0"):new("BigWigsVersionQuery")

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
} end )

L:RegisterTranslations("zhCN", function() return {
	["VersionQuery"] = "版本检测",
	["Options for Version Query."] = "版本检测设置。",
	["Query"] = "检测",
	["Query the raid for BigWig versions."] = "检测团队成员的BigWigs版本。",
	["Query already running, please wait 5 seconds before you query again."] = "检测正在进行，请5秒后再进行检测。",
	["Querying raid for BigWigs versions, please wait..."] = "正在检测团队成员的BigWigs版本，请稍侯……",
} end )

---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigsVersionQuery = BigWigs:NewModule("Version Query")

BigWigsVersionQuery.consoleCmd = L"versionquery"
BigWigsVersionQuery.consoleOptions = {
	type = "group",
	name = L"VersionQuery",
	desc = L"Options for Version Query.",
	args   = {
		[L"query"] = {
			type = "execute",
			name = L"Query",
			desc = L"Query the raid for BigWig versions.",
			func = function() BigWigsVersionQuery:QueryVersion() end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsVersionQuery:OnEnable()

	self.zoneRevisions = {}

	local BWL = AceLibrary("AceLocale-2.0"):new("BigWigs")

	-- Get the highest rev of the bosses in each zone.
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

	self.queryRunning = nil
	self.responseTable = {}

	self.responseString = ""

	for key, value in self.zoneRevisions do
		self.responseString = self.responseString.." "..key..":"..value
	end

	self:RegisterEvent("BigWigs_VersionQuery")
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsVersionQuery:PrintVersions()
	self.core:Print("Version replies:")
	for key, value in self.responseTable do
		self.core:Print(" - "..value[1]..": "..value[2])
	end
	self.responseTable = {}
	self.queryRunning = nil
end

function BigWigsVersionQuery:QueryVersion()
	if self.queryRunning then
		self.core:Print(L"Query already running, please wait 5 seconds before you query again.")
		return
	end

	self.core:Print(L"Querying raid for BigWigs versions, please wait...")

	self.queryRunning = true
	self:ScheduleEvent("bwvqstop", function() BigWigsVersionQuery:PrintVersions() end, 5)

	table.insert(self.responseTable, {UnitName("player"), self.responseString})

	self:TriggerEvent("BigWigs_VersionQuery")
end

function BigWigsVersionQuery:BigWigs_VersionQuery()
	self:TriggerEvent("BigWigs_SendSync", "BWVQ")
end

function BigWigsVersionQuery:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWVQ" and nick ~= UnitName("player") then
		self:TriggerEvent("BigWigs_SendSync", "BWVR "..self.responseString)
	elseif sync == "BWVR" then
		if self.queryRunning then
			table.insert(self.responseTable, {nick, rest})
		end
	end
end

