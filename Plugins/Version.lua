assert(BigWigs, "BigWigs not found!")

local BWL = nil
local BZ = AceLibrary("Babble-Zone-2.0")
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
	["Version Query"] = true,
	["Commands for querying the raid for Big Wigs versions."] = true,
	["Query already running, please wait 5 seconds before trying again."] = true,
	["Querying versions for "] = true,
	["Big Wigs Version Query"] = true,
	["Close window"] = true, -- I know, it's really a Tablet.
	["Showing version for "] = true,
	["Green versions are newer than yours, red are older, and white are the same."] = true,
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
	["N/A"] = true,
	["BigWigs"] = true,
	["Runs a version query on the BigWigs core."] = true,
	["Nr Replies"] = true,
	["Ancient"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	["Version Query"] = "버전 요청",
	["Commands for querying the raid for Big Wigs versions."] = "BigQigs 버전에 대한 공격대 요청 명령.",
	["Query already running, please wait 5 seconds before trying again."] = "이미 요청 중, 5초후 다시 시도하세요.",
	["Querying versions for "] = "버전 요청 중 : ",
	["Big Wigs Version Query"] = "BigWigs 버전 요청",
	["Close window"] = "창 닫기", -- I know, it's really a Tablet.
	["Showing version for "] = "버전 표시 중 ",
	["Green versions are newer than yours, red are older, and white are the same."] = "녹색 : 최신, 붉은색 : 이전, 흰색 : 같음(자신 기준)",
	["Player"] = "플레이어",
	["Version"] = "버전",
	["Current zone"] = "현재 지역",
	["<zone>"] = "<지역>",
	["Version query done."] = "버전 요청 완료.",
	["Runs a version query on your current zone."] = "현재 지역에 동작 모듈 버전 요청",
	["Closes the version query window."] = "버전 확인 창 닫기.",
	["Runs a version query on the given zone."] = "정해진 지역에 동작 모듈 버전 요청.",
	["Zone"] = "지역",
	["N/A"] = "N/A",
} end )

---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigsVersionQuery = BigWigs:NewModule("Version Query")

BigWigsVersionQuery.consoleCmd = L["versionquery"]
BigWigsVersionQuery.consoleOptions = {
	type = "group",
	name = L["Version Query"],
	desc = L["Commands for querying the raid for Big Wigs versions."],
	args = {
		[L["BigWigs"]] = {
			type = "execute",
			name = L["BigWigs"],
			desc = L["Runs a version query on the BigWigs core."],
			func = function() BigWigsVersionQuery:QueryVersion("BigWigs") end,
		},
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
	self.zoneRevisions = nil
	self.currentZone = ""

	BWL = AceLibrary("AceLocale-2.0"):new("BigWigs")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWVQ", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "BWVR", 0)
end

function BigWigsVersionQuery:PopulateRevisions()
	self.zoneRevisions = {}
	for name, module in self.core:IterateModules() do
		if module:IsBossModule() and module.zonename and type(module.zonename) == "string" then
			-- Make sure to get the enUS zone name.
			local zone = BZ:HasReverseTranslation(module.zonename) and BZ:GetReverseTranslation(module.zonename) or module.zonename
			-- Get the abbreviated name from BW Core.
			local zoneAbbr = BWL:HasTranslation(zone) and BWL:GetTranslation(zone) or nil
			if not self.zoneRevisions[zone] or module.revision > self.zoneRevisions[zone] then
				self.zoneRevisions[zone] = module.revision
			end
			if zoneAbbr and (not self.zoneRevisions[zoneAbbr] or module.revision > self.zoneRevisions[zoneAbbr]) then
				self.zoneRevisions[zoneAbbr] = module.revision
			end
		end
	end
	self.zoneRevisions["BigWigs"] = self.core.revision
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsVersionQuery:UpdateVersions()
	if not tablet:IsRegistered("BigWigs_VersionQuery") then
		tablet:Register("BigWigs_VersionQuery",
			"children", function() tablet:SetTitle(L["Big Wigs Version Query"])
				self:OnTooltipUpdate() end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true,
			"menu", function()
					dewdrop:AddLine(
						"text", L["BigWigs"],
						"tooltipTitle", L["BigWigs"],
						"tooltipText", L["Runs a version query on the BigWigs core."],
						"func", function() self:QueryVersion("BigWigs") end)
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
	local playerscat = tablet:AddCategory(
		"columns", 1,
		"text", L["Nr Replies"],
		"child_justify1", "LEFT"
	)
	playerscat:AddLine("text", self.responses)
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Version"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)
	for name, version in self.responseTable do
		if version == -1 then
			cat:AddLine("text", name, "text2", "|cff"..COLOR_RED..L["N/A"].."|r")
		else
			if not self.zoneRevisions then self:PopulateRevisions() end
			local color = COLOR_WHITE
			if self.zoneRevisions[self.currentZone] and version > self.zoneRevisions[self.currentZone] then
				color = COLOR_GREEN
			elseif self.zoneRevisions[self.currentZone] and version < self.zoneRevisions[self.currentZone] then
				color = COLOR_RED
			end
			cat:AddLine("text", name, "text2", "|cff"..color..version.."|r")
		end
	end

	tablet:SetHint(L["Green versions are newer than yours, red are older, and white are the same."])
end

function BigWigsVersionQuery:QueryVersion(zone)
	if not self.zoneRevisions then self:PopulateRevisions() end
	if self.queryRunning then
		self.core:Print(L["Query already running, please wait 5 seconds before trying again."])
		return
	end
	if not zone or zone == "" then zone = GetRealZoneText() end
	-- If this is a shorthand zone, convert it to enUS full.
	-- Also, if this is a shorthand, we can't really know if the user is enUS or not.
	if BWL:HasReverseTranslation(zone) then
		zone = BWL:GetReverseTranslation(zone)
		-- If there is a translation for this to GetLocale(), get it, so we can
		-- print the zone name in the correct locale.
		if BZ:HasTranslation(zone) then
			zone = BZ:GetTranslation(zone)
		end
	end

	-- ZZZ |zone| should be translated here.
	self.core:Print(L["Querying versions for "].."|cff"..COLOR_GREEN..zone.."|r.")

	-- If this is a non-enUS zone, convert it to enUS.
	if BZ:HasReverseTranslation(zone) then zone = BZ:GetReverseTranslation(zone) end

	self.currentZone = zone

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
	self.responses = 1
	self:UpdateVersions()
	self:TriggerEvent("BigWigs_SendSync", "BWVQ "..zone)
end

--[[ Parses the new style reply, which is "1111 <nick>" ]]
function BigWigsVersionQuery:ParseReply2(reply)
	-- If there's no space, it's just a version number we got.
	local first, last = string.find(reply, " ")
	if not first or not last then return reply, nil end

	local rev = string.sub(reply, 1, first)
	local nick = string.sub(reply, last + 1, string.len(reply))

	-- We need to check if rev or nick contains ':' - if it does, this is an old
	-- style reply.
	if tonumber(rev) == nil or string.find(rev, ":") or string.find(nick, ":") then
		return self:ParseReply(reply), nil
	end
	return tonumber(rev), nick
end

--[[ Parses the old style reply, which was MC:REV BWL:REV, etc. ]]
function BigWigsVersionQuery:ParseReply(reply)
	if not string.find(reply, ":") then return -1 end
	local zone = BWL:HasTranslation(self.currentZone) and BWL:GetTranslation(self.currentZone) or self.currentZone

	local zoneIndex, zoneEnd = string.find(reply, zone)
	if not zoneIndex then return -1 end

	local revision = string.sub(reply, zoneEnd + 2, zoneEnd + 6)
	local convertedRev = tonumber(revision)
	if revision and convertedRev ~= nil then return convertedRev end

	return -1
end

--[[
-- Version reply syntax history:
--  Old Style:           MC:REV BWL:REV ZG:REV
--  First Working Style: REV
--  New Style:           REV QuereeNick
--]]

function BigWigsVersionQuery:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWVQ" and nick ~= UnitName("player") and rest then
		if not self.zoneRevisions then self:PopulateRevisions() end
		if not self.zoneRevisions[rest] then
			self:TriggerEvent("BigWigs_SendSync", "BWVR -1 "..nick)
		else
			self:TriggerEvent("BigWigs_SendSync", "BWVR " .. self.zoneRevisions[rest] .. " " .. nick)
		end
	elseif sync == "BWVR" and self.queryRunning and nick and rest then
		-- Means it's either a old style or new style reply.
		-- The "working style" is just the number, which was the second type of
		-- version reply we had.
		local revision, queryNick = nil, nil
		if tonumber(rest) == nil then
			revision, queryNick = self:ParseReply2(rest)
		else
			revision = tonumber(rest)
		end
		if queryNick == nil or queryNick == UnitName("player") then
			self.responseTable[nick] = tonumber(revision)
			self.responses = self.responses + 1
			self:UpdateVersions()
		end
	end
end

