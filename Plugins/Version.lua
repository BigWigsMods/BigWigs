assert(BigWigs, "BigWigs not found!")

local BWL = nil
local BZ = AceLibrary("Babble-Zone-2.2")
local L = AceLibrary("AceLocale-2.2"):new("BigWigsVersionQuery")
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

L:RegisterTranslations("deDE", function() return {
	["versionquery"] = "Versionsabfrage",
	["Version Query"] = "Versionsabfrage",
	["Commands for querying the raid for Big Wigs versions."] = "Kommandos um den Schlachtzug nach verwendeten BigWigs Versionen abzufragen.",
	["Query already running, please wait 5 seconds before trying again."] = "Abfrage l\195\164uft bereits, bitte 5 Sekunden warten bis zum n\195\164chsten Versuch.",
	["Querying versions for "] = "Frage Versionen ab f\195\188r ",
	["Big Wigs Version Query"] = "BigWigs Versionsabfrage",
	["Close window"] = "Schlie\195\159e Fenster", -- I know, it's really a Tablet.
	["Showing version for "] = "Zeige Version f\195\188r ",
	["Green versions are newer than yours, red are older, and white are the same."] = "Gr\195\188ne Versionen sind neuer, rote sind \195\164lter, wei\195\159e sind gleich.",
	["Player"] = "Spieler",
	["Version"] = "Version",
	["Current zone"] = "Momentane Zone",
	["<zone>"] = "<zone>",
	["Version query done."] = "Versionsabfrage beendet.",
	["Runs a version query on your current zone."] = "Versionsabfrage f\195\188r die momentane Zone starten.",
	["Closes the version query window."] = "Schlie\195\159t das Versionsabfrage-Fenster.",
	["current"] = "gegenw\195\164rtig",
	["Runs a version query on the given zone."] = "Versionsabfrage in f\195\188r eine gegebene Zone starten.",
	["Zone"] = "Zone",
	["zone"] = "Zone",
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "Versionsabfrage f\195\188r die BigWigs Kernkomponente starten.",
	["Nr Replies"] = "Anzahl der Antworten",
	["Ancient"] = "Alt",
} end )

L:RegisterTranslations("zhCN", function() return {
	["versionquery"] = "检查版本",
	["Version Query"] = "检查版本",
	["Commands for querying the raid for Big Wigs versions."] = "这个命令检查Big Wigs的版本",
	["Query already running, please wait 5 seconds before trying again."] = "检查中，请等5秒后再尝试",
	["Querying versions for "] = "检查版本 ",
	["Big Wigs Version Query"] = "Big Wigs版本检查",
	["Close window"] = "关闭窗口", -- I know, it's really a Tablet.
	["Showing version for "] = "显示版本 ",
	["Green versions are newer than yours, red are older, and white are the same."] = "绿色的版本比你的新，红色的比你的旧，白色的是相同",
	["Player"] = "玩家",
	["Version"] = "版本",
	["Current zone"] = "目前区域",
	["<zone>"] = "<区域>",
	["Version query done."] = "完成检查版本",
	["Runs a version query on your current zone."] = "检查当前区域的版本",
	["Closes the version query window."] = "关掉目前的检查版本窗口",
	["current"] = "目前",
	["Runs a version query on the given zone."] = "检查指定区域的版本",
	["Zone"] = "区域",
	["zone"] = "区域",
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "检查BigWigs内核的版本",
	["Nr Replies"] = "回复的数量",
	["Ancient"] = "旧的",
} end )

L:RegisterTranslations("zhTW", function() return {
	["versionquery"] = "檢查版本",
	["Version Query"] = "檢查版本",
	["Commands for querying the raid for Big Wigs versions."] = "用於檢查BigWigs的版本",
	["Query already running, please wait 5 seconds before trying again."] = "檢查中，若要再次檢查，請稍後5秒",
	["Querying versions for "] = "檢查版本 ",
	["Big Wigs Version Query"] = "Big Wigs版本檢查",
	["Close window"] = "關閉窗口", -- I know, it's really a Tablet.
	["Showing version for "] = "顯示版本 ",
	["Green versions are newer than yours, red are older, and white are the same."] = "綠色的版本比你的新，紅色的比較舊，白色則表示版本相同",
	["Player"] = "玩家",
	["Version"] = "版本",
	["Current zone"] = "目前區域",
	["<zone>"] = "<區域>",
	["Version query done."] = "完成檢查版本",
	["Runs a version query on your current zone."] = "檢查目前區域的版本",
	["Closes the version query window."] = "關掉目前的檢查版本視窗",
	["current"] = "目前",
	["Runs a version query on the given zone."] = "檢查指定區域的版本",
	["Zone"] = "區域",
	["zone"] = "區域",
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "檢查BigWigs核心的版本",
	["Nr Replies"] = "回復的數量",
	["Ancient"] = "舊的",
} end )

L:RegisterTranslations("frFR", function() return {
	["Version Query"] = "Vérification des versions",
	["Commands for querying the raid for Big Wigs versions."] = "Commandes de vérification des version de BigWigs du raid.",	
	["Query already running, please wait 5 seconds before trying again."] = "Une vérification est déjà en cours, veuillez réessayer dans 5 secondes.",
	["Querying versions for "] = "Vérification des versions pour ",
	["Big Wigs Version Query"] = "Vérification des versions de BigWigs",
	["Close window"] = "Fermer la fenêtre", -- I know, it's really a Tablet.
	["Showing version for "] = "Affichage des versions pour ",
	["Green versions are newer than yours, red are older, and white are the same."] = "Les versions en verte sont plus récentes que vous, celles en rouge plus anciennes, et celles en blanc les mêmes que vous.",
	["Player"] = "Joueur",
	--["Version"] = "Version",
	["Current zone"] = "Zone actuelle",
	--["<zone>"] = "<zone>",
	["Version query done."] = "Vérification des versions terminée.",
	["Runs a version query on your current zone."] = "Effectue une vérification des versions dans votre zone.",
	["Closes the version query window."] = "Ferme la fenêtre de vérification des versions.",
	["Runs a version query on the given zone."] = "Effectue une vérification des versions dans la zone donnée.",
	--["Zone"] = "Zone",
	--["N/A"] = "N/A",
	--["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "Effectue une vérification des versions du noyau de BigWigs.",
	["Nr Replies"] = "Nbre de réponses",
	["Ancient"] = "Ancien",	
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

	BWL = AceLibrary("AceLocale-2.2"):new("BigWigs")

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
	for name, version in pairs(self.responseTable) do
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
	if self.queryRunning then
		self.core:Print(L["Query already running, please wait 5 seconds before trying again."])
		return
	end
	if not zone or zone == "" or type(zone) ~= "string" then zone = GetRealZoneText() end
	-- If this is a shorthand zone, convert it to enUS full.
	-- Also, if this is a shorthand, we can't really know if the user is enUS or not.

	if not BWL then BWL = AceLibrary("AceLocale-2.2"):new("BigWigs") end
	if BWL ~= nil and zone ~= nil and type(zone) == "string" and BWL:HasReverseTranslation(zone) then
		zone = BWL:GetReverseTranslation(zone)
		-- If there is a translation for this to GetLocale(), get it, so we can
		-- print the zone name in the correct locale.
		if BZ:HasTranslation(zone) then
			zone = BZ:GetTranslation(zone)
		end
	end

	if not zone then
		error("The given zone is invalid.")
		return
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

	if not self.zoneRevisions then self:PopulateRevisions() end
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

