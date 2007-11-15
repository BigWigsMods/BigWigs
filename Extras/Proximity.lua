assert( BigWigs, "BigWigs not found!")

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsProximity")

local RL
local paintchips = AceLibrary("PaintChips-2.0")
local active = nil -- The module we're currently tracking proximity for.
local anchor = nil
local lastplayed = 0 -- When we last played an alarm sound for proximity.
local playername
local tooClose = {} -- List of players who are too close.

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

local table_insert = table.insert
local table_concat = table.concat
local fmt = string.format
local UnitName = UnitName
local UnitExists = UnitExists
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitAffectingCombat = UnitAffectingCombat
local pairs = pairs
local type = type


local coloredNames = setmetatable({}, {__index =
	function(self, key)
		if RL then
			local obj = RL:GetUnitObjectFromName(key)
			if not obj then return key end
			self[key] = "|cff" .. paintchips:GetHex(obj.class) .. key .. "|r"
		else
			local num = GetNumRaidMembers()
			local found
			for i = 1, num do
				if UnitExists(fmt("%s%d", "raid", i)) and UnitName(fmt("%s%d", "raid", i)) == key then
					local class = select(2, UnitClass(fmt("%s%d", "raid", i)) )
					self[key] = "|cff" .. paintchips:GetHex(class) .. key .."|r"
					found = true
				end
			end
			if not found then
				return key
			end
		end
		return self[key]
	end
})

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Proximity"] = true,
	["Close Players"] = true,
	["Options for the Proximity Display."] = true,
	["|cff777777Nobody|r"] = true,
	["Sound"] = true,
	["Play sound on proximity."] = true,
	["Disabled"] = true,
	["Disable the proximity display for all modules that use it."] = true,
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = true,

	proximity = "Proximity display",
	proximity_desc = "Show the proximity window when appropriate for this encounter, listing players who are standing too close to you.",

	font = "Fonts\\FRIZQT__.TTF",

	["Test"] = true,
	["Perform a Proximity test."] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Proximity"] = "近距离",
	["Close Players"] = "近距离玩家",
	["Options for the Proximity Display."] = "设置近距离显示。",
	["|cff777777Nobody|r"] = "|cff777777无人|r",
	["Sound"] = "声音",
	["Play sound on proximity."] = "近距离时声音提示。",
	["Disabled"] = "禁用",
	["Disable the proximity display for all modules that use it."] = "禁用所有 BOSS 模块使用此功能。",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "为%s禁用近距离显示功能，若要再次使用请设置 BOSS 模块选项。",

	proximity = "近距离显示",
	proximity_desc = "显示近距离窗口,列出距离你很近的玩家。",

	font = "Fonts\\ZYKai_T.TTF",
} end)

L:RegisterTranslations("koKR", function() return {
	["Proximity"] = "접근",
	["Close Players"] = "가까운 플레이어",
	["Options for the Proximity Display."] = "접근 표시에 대한 설정입니다.",
	["|cff777777Nobody|r"] = "|cff777777아무도 없음|r",
	["Sound"] = "효과음",
	["Play sound on proximity."] = "접근 표시에 효과음을 재생합니다.",
	["Disabled"] = "미사용",
	["Disable the proximity display for all modules that use it."] = "모든 모듈의 접근 표시를 비활성화 합니다.",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "%s에 대한 접근 표시가 비활성화 되었습니다. 다시 사용하려면 해당 보스 모듈의 설정을 사용하세요.",

	proximity = "접근 표시",
	proximity_desc = "해당 보스전에서 필요 시 자신과 근접해 있는 플레이어 목록을 표시하는 접근 표시창을 표시합니다.",

	font = "Fonts\\2002.TTF",
} end )

L:RegisterTranslations("frFR", function() return {
	["Proximity"] = "Proximité",
	["Close Players"] = "Joueurs proches",
	["Options for the Proximity Display."] = "Options concernant l'affichage de proximité.",
	["|cff777777Nobody|r"] = "|cff777777Personne|r",
	["Sound"] = "Son",
	["Play sound on proximity."] = "Joue un son quand un autre joueur est trop proche de vous.",
	["Disabled"] = "Désactivé",
	["Disable the proximity display for all modules that use it."] = "Désactive l'affichage de proximité.",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "L'affichage de proximité a été désactivé pour %s. Veuillez utiliser les options du module du boss pour l'activer à nouveau.",

	proximity = "Proximité",
	proximity_desc = "Affiche la fenêtre de proximité.",

	font = "Fonts\\FRIZQT__.TTF",

	["Test"] = "Test",
	["Perform a Proximity test."] = "Effectue un test de proximité.",
} end)

L:RegisterTranslations("deDE", function() return {
	["Proximity"] = "Nähe",
	--["Close Players"] = "",
	["Options for the Proximity Display."] = "Optionen für die Nähe Anzeige.",
	["|cff777777Nobody|r"] = "|cff777777Niemand|r",
	["Sound"] = "Sound",
	["Play sound on proximity."] = "Spielt einen Sound bei Nähe ab.",
	["Disabled"] = "Deaktivieren",
	["Disable the proximity display for all modules that use it."] = "Deaktiviert die Nähe Anzeige für alle Module die sie benutzen.",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "Die Nähe Anzeige wurde deaktiviert für %s, bitte benutze die Boss Modul Optionen um sie wieder zu aktivieren.",

	proximity = "Nähe Anzeige",
	proximity_desc = "Zeigt das Nähe Fenster wenn benötigt passsend zu diesem Encounter an, auflistend die Spieler die dir zu Nahe stehn.",

	font = "Fonts\\FRIZQT__.TTF",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Proximity"] = "鄰近顯示",
	--["Close Players"] = "",
	["Options for the Proximity Display."] = "設定鄰近顯示選項。",
	["|cff777777Nobody|r"] = "|cff777777無人|r",
	["Sound"] = "音效",
	["Play sound on proximity."] = "當有人太靠近時發出音效。",
	["Disabled"] = "停用",
	["Disable the proximity display for all modules that use it."] = "停用鄰近顯示功能。",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "模組 %s 的鄰近顯示功能已停用，請用模組選單啟用它。",

	proximity = "鄰近顯示",
	proximity_desc = "在適當的情形下，當有人太靠近時，現示清單。",

	font = "Fonts\\FZBWJW.TTF"
} end)

L:RegisterTranslations("esES", function() return {
	["Proximity"] = "Proximidad",
	--["Close Players"] = "",
	["Options for the Proximity Display."] = "Opciones para la ventana de proximidad",
	["|cff777777Nobody|r"] = "|cff777777Nadie|r",
	["Sound"] = "Sonido",
	["Play sound on proximity."] = "Tocar sonido cuando est\195\169 en proximidad",
	["Disabled"] = "Desactivado",
	["Disable the proximity display for all modules that use it."] = "Desactivar la ventana de proximidad para todos los m\195\179dulos que lo usen",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "La ventana de proximidad ha sido desactivada por %s, por favor use las opciones de los m\195\179dulos de jefes para activarlo de nuevo",

	proximity = "Ventana de proximidad",
	proximity_desc = "Muestra la ventana de proximidad cuando sea apropiado para este encuentro, listando los jugadores que est\195\161n demasiado cerca de t\195\173.",

	font = "Fonts\\FRIZQT__.TTF",
} end)

-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

local plugin = BigWigs:NewModule("Proximity")
plugin.revision = tonumber(("$Revision$"):sub(12, -3))
plugin.defaultDB = {
	posx = nil,
	posy = nil,
	sound = true,
	disabled = nil,
}
plugin.external = true

plugin.consoleCmd = L["Proximity"]
plugin.consoleOptions = {
	type = "group",
	name = L["Proximity"],
	desc = L["Options for the Proximity Display."],
	handler = plugin,
	pass = true,
	get = function( key )
		return plugin.db.profile[key]
	end,
	set = function( key, value )
		plugin.db.profile[key] = value
		if key == "disabled" then
			if value then
				plugin:CloseProximity()
			else
				plugin:OpenProximity()
			end
		end
	end,
	args = {
		sound = {
			type = "toggle",
			name = L["Sound"],
			desc = L["Play sound on proximity."],
			order = 100,
		},
		disabled = {
			type = "toggle",
			name = L["Disabled"],
			desc = L["Disable the proximity display for all modules that use it."],
			order = 101,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 102,
		},
		[L["Test"]] = {
			type = "execute",
			name = L["Test"],
			desc = L["Perform a Proximity test."],
			order = 103,
			handler = plugin,
			func = "TestProximity",
		},
	}
}

-----------------------------------------------------------------------
--      Initialization
-----------------------------------------------------------------------

function plugin:OnRegister()
	BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"], OnOptionToggled)

	playername = UnitName("player")
end

function plugin:OnEnable()
	self:RegisterEvent("Ace2_AddonDisabled")

	self:RegisterEvent("BigWigs_ShowProximity")
	self:RegisterEvent("BigWigs_HideProximity")

	if AceLibrary:HasInstance("Roster-2.1") then
		RL = AceLibrary("Roster-2.1")
	end
end

function plugin:OnDisable()
	self:CloseProximity()
end

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

function plugin:BigWigs_ShowProximity(module)
	if active and active ~= module then
		error("The proximity module is already running for another boss module.")
	end

	active = module

	self:OpenProximity()
end

function plugin:BigWigs_HideProximity(module)
	active = nil
	self:CloseProximity()
end

OnOptionToggled = function(module)
	if active and active == module then
		if active.db.profile.proximity then
			plugin:OpenProximity()
		else
			plugin:CloseProximity()
		end
	end
end

function plugin:Ace2_AddonDisabled(module)
	if active and active == module then
		self:BigWigs_HideProximity(active)
	end
end

-----------------------------------------------------------------------
--      Util
-----------------------------------------------------------------------

function plugin:CloseAndDisableProximity()
	self:CloseProximity()

	if active then
		active.db.profile.proximity = nil
		BigWigs:Print(fmt(L["The proximity display has been disabled for %s, please use the boss modules options to enable it again."], active:ToString()))
	end
end

function plugin:CloseProximity()
	if anchor then anchor:Hide() end
	self:CancelScheduledEvent("bwproximityupdate")
end

function plugin:OpenProximity()
	if self.db.profile.disabled or not active or type(active.proximityCheck) ~= "function" or not active.db.profile.proximity then return end

	self:SetupFrames()

	local text = L["Close Players"]
	for k in pairs(tooClose) do tooClose[k] = nil end
	anchor.text:SetText(L["|cff777777Nobody|r"])

	anchor.cheader:SetText(text)
	anchor:Show()
	if not self:IsEventScheduled("bwproximityupdate") then
		self:ScheduleRepeatingEvent("bwproximityupdate", self.UpdateProximity, .1, self)
	end
end

function plugin:TestProximity()
	self:SetupFrames()

	local text = L["Close Players"]
	anchor.text:SetText(L["|cff777777Nobody|r"])
	anchor.cheader:SetText(text)
	anchor:Show()
end

function plugin:UpdateProximity()
	if not active or type(active.proximityCheck) ~= "function" then return end

	if RL then
		for n, u in pairs(RL.roster) do
			if u and u.name and u.class ~= "PET" and not UnitIsDeadOrGhost(u.unitid) and u.name ~= playername then
				if active.proximityCheck(u.unitid) then
					table_insert(tooClose, coloredNames[u.name])
				end
			end
			if #tooClose > 4 then break end
		end
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			local unit = fmt("%s%d", "raid", i)
			if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitName(unit) ~= playername then
				if active.proximityCheck(unit) then
					table_insert(tooClose, coloredNames[UnitName(unit)])
				end
			end
			if #tooClose > 4 then break end
		end
	end
	if #tooClose == 0 then
		anchor.text:SetText(L["|cff777777Nobody|r"])
	else
		anchor.text:SetText(table_concat(tooClose, "\n"))
		for k in pairs(tooClose) do tooClose[k] = nil end
		local t = time()
		if t > lastplayed + 1 then
			lastplayed = t
			if self.db.profile.sound and UnitAffectingCombat("player") and not active.proximitySilent then
				self:TriggerEvent("BigWigs_Sound", "Alarm")
			end
		end
	end
end

------------------------------
--    Create the Anchor     --
------------------------------

function plugin:SetupFrames()
	if anchor then return end

	local frame = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
	frame:Hide()

	frame:SetWidth(200)
	frame:SetHeight(100)

	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\BigWigs\\Textures\\otravi-semi-full-border", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})

	frame:SetBackdropColor(24/255, 24/255, 24/255)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", function() this:StartMoving() end)
	frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SavePosition()
	end)

	local cheader = frame:CreateFontString(nil, "OVERLAY")
	cheader:ClearAllPoints()
	cheader:SetWidth(190)
	cheader:SetHeight(15)
	cheader:SetPoint("TOP", frame, "TOP", 0, -14)
	cheader:SetFont(L["font"], 12)
	cheader:SetJustifyH("LEFT")
	cheader:SetText(L["Proximity"])
	cheader:SetShadowOffset(.8, -.8)
	cheader:SetShadowColor(0, 0, 0, 1)
	frame.cheader = cheader

	local text = frame:CreateFontString(nil, "OVERLAY")
	text:ClearAllPoints()
	text:SetWidth( 190 )
	text:SetHeight( 80 )
	text:SetPoint( "TOP", frame, "TOP", 0, -35 )
	text:SetJustifyH("CENTER")
	text:SetJustifyV("TOP")
	text:SetFont(L["font"], 12)
	frame.text = text

	local close = frame:CreateTexture(nil, "ARTWORK")
	close:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\otravi-close")
	close:SetTexCoord(0, .625, 0, .9333)

	close:SetWidth(20)
	close:SetHeight(14)
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -15)

	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( frame )
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetPoint("CENTER", close, "CENTER")
	closebutton:SetScript( "OnClick", function() self:CloseAndDisableProximity() end )

	anchor = frame

	local x = self.db.profile.posx
	local y = self.db.profile.posy
	if x and y then
		local s = anchor:GetEffectiveScale()
		anchor:ClearAllPoints()
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self:ResetAnchor()
	end
end

function plugin:ResetAnchor()
	if not anchor then self:SetupFrames() end
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent, "CENTER")
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function plugin:SavePosition()
	if not anchor then self:SetupFrames() end

	local s = anchor:GetEffectiveScale()
	self.db.profile.posx = anchor:GetLeft() * s
	self.db.profile.posy = anchor:GetTop() * s
end

