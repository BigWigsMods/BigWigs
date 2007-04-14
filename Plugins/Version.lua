assert(BigWigs, "BigWigs not found!")

local BZ = nil
local L = AceLibrary("AceLocale-2.2"):new("BigWigsVersionQuery")
local tablet = AceLibrary("Tablet-2.0")
local dewdrop = AceLibrary("Dewdrop-2.0")

local COLOR_GREEN = "00ff00"
local COLOR_RED = "ff0000"
local COLOR_WHITE = "ffffff"

local queryRunning = nil

local responseTable = {}
local numResponses = 0

local zoneRevisions = nil
local currentZone = ""

---------------------------------
--      Localization           --
---------------------------------

L:RegisterTranslations("enUS", function() return {
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
	["Not loaded"] = true,
	["BigWigs"] = true,
	["Runs a version query on the BigWigs core."] = true,
	["Replies"] = true,
	["Ancient"] = true,
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = true,
	["Notify people with older versions that there is a new version available."] = true,
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
	["Version Query"] = "Versionsabfrage",
	["Commands for querying the raid for Big Wigs versions."] = "Kommandos um den Schlachtzug nach verwendeten BigWigs Versionen abzufragen.",
	["Query already running, please wait 5 seconds before trying again."] = "Abfrage l\195\164uft bereits, bitte 5 Sekunden warten bis zum n\195\164chsten Versuch.",
	["Querying versions for "] = "Frage Versionen ab f\195\188r ",
	["Big Wigs Version Query"] = "BigWigs Versionsabfrage",
	["Close window"] = "Fenster Schlie\195\159en", -- I know, it's really a Tablet.
	["Showing version for "] = "Zeige Version f\195\188r ",
	["Green versions are newer than yours, red are older, and white are the same."] = "Gr\195\188ne Versionen sind neuer, rote sind \195\164lter, wei\195\159e sind gleich.",
	["Player"] = "Spieler",
	["Version"] = "Version",
	["Current zone"] = "Momentane Zone",
	-- ["<zone>"] = true,
	["Version query done."] = "Versionsabfrage beendet.",
	["Runs a version query on your current zone."] = "Versionsabfrage f\195\188r die momentane Zone durchf\195\188hren.",
	["Closes the version query window."] = "Schlie\195\159t das Versionsabfrage-Fenster.",
	-- ["current"] = true,
	["Runs a version query on the given zone."] = "Versionsabfrage in f\195\188r eine gegebene Zone durchf\195\188hren.",
	["Zone"] = "Zone",
	-- ["zone"] = true,
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "Versionsabfrage f\195\188r die BigWigs Kernkomponente durchf\195\188hren.",
	["Replies"] = "Anzahl der Antworten",
	["Ancient"] = "Alt",
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = "Es scheint eine neuere Version von BigWigs bereit zu stehen, bitte upgraden.",
	["Notify people with older versions that there is a new version available."] = "Personen mit einer \195\164lteren BigWigs Version benachrichtigen, dass eine neue Version bereit steht.",
} end )

L:RegisterTranslations("zhCN", function() return {
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
	["Replies"] = "回复的数量",
	["Ancient"] = "旧的",
} end )

L:RegisterTranslations("zhTW", function() return {
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
	["Replies"] = "回復的數量",
	["Ancient"] = "舊的",
} end )

L:RegisterTranslations("frFR", function() return {
	["Version Query"] = "V\195\169rification des versions",
	["Commands for querying the raid for Big Wigs versions."] = "Commandes de v\195\169rification des version de BigWigs du raid.",
	["Query already running, please wait 5 seconds before trying again."] = "Une v\195\169rification est d\195\169jà en cours, veuillez r\195\169essayer dans 5 secondes.",
	["Querying versions for "] = "V\195\169rification des versions pour ",
	["Big Wigs Version Query"] = "V\195\169rification des versions de BigWigs",
	["Close window"] = "Fermer la fen\195\170tre", -- I know, it's really a Tablet.
	["Showing version for "] = "Affichage des versions pour ",
	["Green versions are newer than yours, red are older, and white are the same."] = "Les versions en vert sont plus r\195\169centes que la votre, celles en rouge plus anciennes, et celles en blanc les m\195\170mes.",
	["Player"] = "Joueur",
	["Current zone"] = "Zone actuelle",
	--["<zone>"] = true,
	["Version query done."] = "V\195\169rification des versions termin\195\169e.",
	["Runs a version query on your current zone."] = "Effectue une v\195\169rification des versions dans votre zone.",
	["Closes the version query window."] = "Ferme la fen\195\170tre de v\195\169rification des versions.",
	--["current"] = true,
	["Runs a version query on the given zone."] = "Effectue une v\195\169rification des versions dans la zone donn\195\169e.",
	--["Zone"] = true,
	--["zone"] = true,
	--["N/A"] = true,
	--["BigWigs"] = true,
	["Runs a version query on the BigWigs core."] = "Effectue une v\195\169rification des versions du noyau de BigWigs.",
	["Replies"] = "Nbre de r\195\169ponses",
	["Ancient"] = "Ancien",
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = "Une nouvelle version de Big Wigs est disponible. Mise \195\160 jour conseill\195\169e !",
	["Notify people with older versions that there is a new version available."] = "Pr\195\169viens les personnes poss\195\169dant des versions anciennes qu'une nouvelle version est disponible.",
} end )

---------------------------------
--      Addon Declaration      --
---------------------------------

local plugin = BigWigs:NewModule("Version Query")

plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.consoleCmd = L["Version"]
plugin.consoleOptions = {
	type = "group",
	name = L["Version Query"],
	desc = L["Commands for querying the raid for Big Wigs versions."],
	handler = plugin,
	args = {
		[L["BigWigs"]] = {
			type = "execute",
			name = L["BigWigs"],
			desc = L["Runs a version query on the BigWigs core."],
			passValue = "BigWigs",
			func = "QueryVersion",
		},
		[L["current"]] = {
			type = "execute",
			name = L["Current zone"],
			desc = L["Runs a version query on your current zone."],
			func = "QueryVersion",
		},
		[L["zone"]] = {
			type = "text",
			name = L["Zone"],
			desc = L["Runs a version query on the given zone."],
			usage = L["<zone>"],
			get = false,
			set = "QueryVersion",
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWVQ", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "BWVR", 0)

	self:RegisterEvent("BigWigs_ModulePackLoaded", "PopulateRevisions")
end

function plugin:PopulateRevisions()
	if not zoneRevisions then zoneRevisions = {} end

	if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end
	for name, module in BigWigs:IterateModules() do
		if module:IsBossModule() and type(module.zonename) == "string" then
			-- Make sure to get the enUS zone name.
			local zone = BZ:HasReverseTranslation(module.zonename) and BZ:GetReverseTranslation(module.zonename) or module.zonename
			if not zoneRevisions[zone] or module.revision > zoneRevisions[zone] then
				zoneRevisions[zone] = module.revision
			end
		end
	end
	zoneRevisions["BigWigs"] = BigWigs.revision
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:UpdateVersions()
	if not tablet:IsRegistered("BigWigs_VersionQuery") then
		tablet:Register("BigWigs_VersionQuery",
			"children", function()
				tablet:SetTitle(L["Big Wigs Version Query"])
				self:OnTooltipUpdate()
			end,
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
					"func", function()
						tablet:Attach("BigWigs_VersionQuery")
						dewdrop:Close()
					end)
			end
		)
	end
	if tablet:IsAttached("BigWigs_VersionQuery") then
		tablet:Detach("BigWigs_VersionQuery")
	else
		tablet:Refresh("BigWigs_VersionQuery")
	end
end

function plugin:OnTooltipUpdate()
	local infoCat = tablet:AddCategory(
		"columns", 2,
		"child_textR", 1,
		"child_textG", 1,
		"child_textB", 0,
		"child_text2R", 1,
		"child_text2G", 1,
		"child_text2B", 1
    )
	infoCat:AddLine("text", L["Zone"], "text2", currentZone)
	infoCat:AddLine("text", L["Replies"], "text2", numResponses)
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Version"]
	)
	local hasOld = nil
	for name, version in pairs(responseTable) do
		if version == -1 then
			cat:AddLine("text", name, "text2", "|cff"..COLOR_RED..L["N/A"].."|r")
		elseif version == -2 then
			cat:AddLine("text", name, "text2", "|cff"..COLOR_RED..L["Not loaded"].."|r")
		else
			if not zoneRevisions then self:PopulateRevisions() end
			local color = COLOR_WHITE
			if zoneRevisions[currentZone] and version > zoneRevisions[currentZone] then
				color = COLOR_GREEN
			elseif zoneRevisions[currentZone] and version < zoneRevisions[currentZone] then
				hasOld = true
				color = COLOR_RED
			end
			cat:AddLine("text", name, "text2", "|cff"..color..version.."|r")
		end
	end

	if responseTable and hasOld and (IsRaidLeader() or IsRaidOfficer()) then
		local alertCat = tablet:AddCategory("columns", 1)
		alertCat:AddLine(
			"text", L["Notify people with older versions that there is a new version available."],
			"wrap", true,
			"func", self.AlertOldRevisions,
			"arg1", self
		)
	end

	tablet:SetHint(L["Green versions are newer than yours, red are older, and white are the same."])
end

function plugin:AlertOldRevisions()
	if not responseTable or (not IsRaidLeader() and not IsRaidOfficer()) then return end
	local myVersion = zoneRevisions[currentZone]
	if not myVersion then return end
	for name, version in pairs(responseTable) do
		if version < myVersion then
			self:TriggerEvent("BigWigs_SendTell", name, L["There seems to be a newer version of Big Wigs available for you, please upgrade."])
		end
	end
end

local function resetQueryRunning()
	queryRunning = nil
	BigWigs:Print(L["Version query done."])
end

function plugin:QueryVersion(zone)
	if queryRunning then
		BigWigs:Print(L["Query already running, please wait 5 seconds before trying again."])
		return
	end
	if type(zone) ~= "string" or zone == "" then zone = GetRealZoneText() end
	-- If this is a shorthand zone, convert it to enUS full.
	-- Also, if this is a shorthand, we can't really know if the user is enUS or not.

	if not zone then
		error("The given zone is invalid.")
		return
	end

	-- ZZZ |zone| should be translated here.
	BigWigs:Print(L["Querying versions for "].."|cff"..COLOR_GREEN..zone.."|r.")

	-- If this is a non-enUS zone, convert it to enUS.
	if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end
	if BZ:HasReverseTranslation(zone) then zone = BZ:GetReverseTranslation(zone) end

	currentZone = zone

	queryRunning = true
	self:ScheduleEvent(resetQueryRunning, 5)

	responseTable = {}

	if not zoneRevisions then self:PopulateRevisions() end
	responseTable[UnitName("player")] = self:GetVersion(zone)
	numResponses = 1

	self:UpdateVersions()
	self:TriggerEvent("BigWigs_SendSync", "BWVQ "..zone)
end

function plugin:GetVersion(zone)
	if not zoneRevisions then self:PopulateRevisions() end
	local rev = -1
	if zoneRevisions[zone] then
		rev = zoneRevisions[zone]
	elseif BigWigs:HasModule(zone) then
		rev = BigWigs:GetModule(zone).revision
	elseif BigWigsLoD and BigWigsLoD:HasAddOnsForZone(zone) then
		rev = -2
	end
	if type(rev) ~= "number" then rev = -1 end
	return rev
end

--[[ Parses the new style reply, which is "1111 <nick>" ]]
function plugin:ParseReply(reply)
	local first, last = reply:find(" ")
	if not first or not last then return reply, nil end

	local rev = reply:sub(1, first)
	local nick = reply:sub(last + 1, reply:len())

	return tonumber(rev), nick
end

--[[
-- Version reply syntax history:
--  Old Style:           MC:REV BWL:REV ZG:REV
--  First Working Style: REV
--  New Style:           REV QuereeNick
--]]

function plugin:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWVQ" and nick ~= UnitName("player") and rest then
		self:TriggerEvent("BigWigs_SendSync", "BWVR " .. self:GetVersion(rest) .. " " .. nick)
	elseif sync == "BWVR" and queryRunning and nick and rest then
		local revision, queryNick = self:ParseReply(rest)
		if revision and queryNick and queryNick == UnitName("player") then
			responseTable[nick] = tonumber(revision)
			numResponses = numResponses + 1
			self:UpdateVersions()
		end
	end
end

