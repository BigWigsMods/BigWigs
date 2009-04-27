assert( BigWigs, "BigWigs not found!")

-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

local plugin = BigWigs:New("Proximity", "$Revision$")
if not plugin then return end

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

-- /script BigWigs:GetModule("Proximity"):UpdateProximity({"Applebob", "Tysste", "Foobar", "Elgen"})

local dew = AceLibrary("Dewdrop-2.0")

local active = nil -- The module we're currently tracking proximity for.
local anchor = nil
local lastplayed = 0 -- When we last played an alarm sound for proximity.
local tooClose = {} -- List of players who are too close.

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

local hexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
	hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
end

-- Helper table to cache colored player names.
local coloredNames = setmetatable({}, {__index =
	function(self, key)
		if type(key) == "nil" then return nil end
		local _, class = UnitClass(key)
		if class then
			self[key] = hexColors[class] .. key .. "|r"
			return self[key]
		else
			return key
		end
	end
})

local bandages = {
	34722, -- Heavy Frostweave Bandage
	34721, -- Frostweave Bandage
	21991, -- Heavy Netherweave Bandage
	21990, -- Netherweave Bandage
	14530, -- Heavy Runecloth Bandage
	14529, -- Runecloth Bandage
	8545, -- Heavy Mageweave Bandage
	8544, -- Mageweave Bandage
	6451, -- Heavy Silk Bandage
	6450, -- Silk Bandage
	3531, -- Heavy Wool Bandage
	3530, -- Wool Bandage
	2581, -- Heavy Linen Bandage
	1251, -- Linen Bandage
}

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsProximity")
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

	["Close"] = true,
	["Closes the proximity display and prevents showing it ever again for the active boss module (if any), until you go into the options for the relevant boss module and toggle the 'Proximity' option back on."] = true,
	["Test"] = true,
	["Perform a Proximity test."] = true,
	["Display"] = true,
	["Options for the Proximity display window."] = true,
	["Lock"] = true,
	["Locks the display in place, preventing moving and resizing."] = true,
	["Title"] = true,
	["Shows or hides the title."] = true,
	["Background"] = true,
	["Shows or hides the background."] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Proximity"] = "近距离",
	["Close Players"] = "近距离玩家",
	["Options for the Proximity Display."] = "近距离显示选项。",
	["|cff777777Nobody|r"] = "|cff777777没有玩家|r",
	["Sound"] = "声效",
	["Play sound on proximity."] = "近距离时声效提示。",
	["Disabled"] = "禁用",
	["Disable the proximity display for all modules that use it."] = "禁止所有首领模块使用此功能。",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "为%s禁用近距离显示功能，若要再次使用请开启首领模块选项。",

	proximity = "近距离显示",
	proximity_desc = "显示近距离窗口，列出距离你很近的玩家。",

	font = "Fonts\\ZYKai_T.TTF",

	["Test"] = "测试",
	["Perform a Proximity test."] = "距离报警测试。",
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
	
	["Close"] = "닫기",
	["Closes the proximity display and prevents showing it ever again for the active boss module (if any), until you go into the options for the relevant boss module and toggle the 'Proximity' option back on."] = "활성화된 보스 모듈을 통해서 또는 표시된 접근 표시창을 닫습니다.",
	["Test"] = "테스트",
	["Perform a Proximity test."] = "접근 테스트를 실행합니다.",
	["Display"] = "표시",
	["Options for the Proximity display window."] = "접근 표시 창을 설정합니다.",
	["Lock"] = "고정",
	["Locks the display in place, preventing moving and resizing."] = "미리 이동 또는 크기조절을 하고 표시할 장소에 고정합니다.",
	["Title"] = "제목",
	["Shows or hides the title."] = "제목을 표시하거나 숨깁니다.",
	["Background"] = "배경",
	["Shows or hides the background."] = "배경을 표시하거나 숨깁니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	["Proximity"] = "Proximité",
	["Close Players"] = "Joueurs proches",
	["Options for the Proximity Display."] = "Options concernant l'affichage de proximité.",
	["|cff777777Nobody|r"] = "|cff777777Personne|r",
	["Sound"] = "Son",
	["Play sound on proximity."] = "Joue un son quand un autre joueur est trop proche de vous.",
	["Disabled"] = "Désactivé",
	["Disable the proximity display for all modules that use it."] = "Désactive l'affichage de proximité pour tous les modules l'utilisant.",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "L'affichage de proximité a été désactivé pour %s. Veuillez utiliser les options du module du boss pour l'activer à nouveau.",

	proximity = "Proximité",
	proximity_desc = "Affiche la fenêtre de proximité.",

	font = "Fonts\\FRIZQT__.TTF",

	["Close"] = "Fermer",
	["Closes the proximity display and prevents showing it ever again for the active boss module (if any), until you go into the options for the relevant boss module and toggle the 'Proximity' option back on."] = "Ferme l'affichage de proximité et empêche ce dernier de se montrer à nouveau pour le module de boss actif (s'il y en a un) jusqu'à ce que vous réactiviez l'affichage de proximité dans les options du boss en question.",
	["Test"] = "Test",
	["Perform a Proximity test."] = "Effectue un test de proximité.",
	["Display"] = "Affichage",
	["Options for the Proximity display window."] = "Options concernant la fenêtre d'affichage de proximité.",
	["Lock"] = "Verrouiller",
	["Locks the display in place, preventing moving and resizing."] = "Verrouille l'affichage à sa place actuelle, empêchant tout déplacement ou redimensionnement.",
	["Title"] = "Titre",
	["Shows or hides the title."] = "Affiche ou non le titre.",
	["Background"] = "Arrière-plan",
	["Shows or hides the background."] = "Affiche ou non l'arrière-plan.",
} end)

L:RegisterTranslations("deDE", function() return {
	["Proximity"] = "Nähe",
	["Close Players"] = "Zu nahe Spieler",
	["Options for the Proximity Display."] = "Optionen für die Nähe Anzeige.",
	["|cff777777Nobody|r"] = "|cff777777Niemand|r",
	["Sound"] = "Sound",
	["Play sound on proximity."] = "Spielt einen Sound bei Nähe ab.",
	["Disabled"] = "Deaktivieren",
	["Disable the proximity display for all modules that use it."] = "Deaktiviert die Nähe Anzeige für alle Module die sie benutzen.",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "Die Nähe Anzeige wurde deaktiviert für %s, bitte benutze die Boss Modul Optionen um sie wieder zu aktivieren.",

	proximity = "Nähe Anzeige",
	proximity_desc = "Zeigt das Nähe Fenster an, wenn es für diesen Encounter benötigt wird. Listet alle Spieler auf, die dir zu nahe stehen.",

	font = "Fonts\\FRIZQT__.TTF",

	["Test"] = "Test",
	["Perform a Proximity test."] = "Führe einen Nähe Test durch.",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Proximity"] = "鄰近顯示",
	["Close Players"] = "鄰近玩家",
	["Options for the Proximity Display."] = "設定鄰近顯示選項。",
	["|cff777777Nobody|r"] = "|cff777777沒有玩家|r",
	["Sound"] = "音效",
	["Play sound on proximity."] = "當有人太靠近時發出音效。",
	["Disabled"] = "禁用",
	["Disable the proximity display for all modules that use it."] = "禁用鄰近顯示功能。",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "%s模組的鄰近顯示功能已禁用，請用模組選單開啟。",

	proximity = "鄰近顯示",
	proximity_desc = "顯示近距離窗口，列出距離你很近的玩家。",

	font = "Fonts\\bHEI01B.TTF",

	["Test"] = "測試",
	["Perform a Proximity test."] = "鄰近顯示測試。",
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
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["Proximity"] = "Близость",
	["Close Players"] = "Близкие Игроки",
	["Options for the Proximity Display."] = "Опции отображения близости",
	["|cff777777Nobody|r"] = "|cff777777Никого|r",
	["Sound"] = "Звук",
	["Play sound on proximity."] = "Проиграть звук при приближении игроков",
	["Disabled"] = "Отключить",
	["Disable the proximity display for all modules that use it."] = "Отключить отображение окна сближения для всех модулей использующих его.",
	["The proximity display has been disabled for %s, please use the boss modules options to enable it again."] = "Отображение модуля сближения отключен в %s, пожалуйста воспользуйтесь опциями босс-модуля, для того чтобы включить его.",

	proximity = "Отображение близости",
	proximity_desc = "Показывать окно близости при соответствующей схватке, выводя список игроков которые стоят слишком близко к вам.",

	font = "Fonts\\NIM_____.ttf",

	["Test"] = "Тест",
	["Perform a Proximity test."] = "Тест близость",
} end)

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	posx = nil,
	posy = nil,
	title = true,
	background = true,
	lock = nil,
	width = 100,
	height = 80,
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
	get = function(key)
		return plugin.db.profile[key]
	end,
	set = function(key, value)
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
		test = {
			type = "execute",
			name = L["Test"],
			desc = L["Perform a Proximity test."],
			func = "TestProximity",
			order = 99,
		},
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
		display = {
			type = "group",
			name = L["Display"],
			desc = L["Options for the Proximity display window."],
			order = 103,
			pass = true,
			handler = plugin,
			set = function(key, value)
				plugin.db.profile[key] = value
				plugin:RestyleWindow()
			end,
			get = function(key)
				return plugin.db.profile[key]
			end,
			args = {
				lock = {
					type = "toggle",
					name = L["Lock"],
					desc = L["Locks the display in place, preventing moving and resizing."],
					order = 1,
				},
				title = {
					type = "toggle",
					name = L["Title"],
					desc = L["Shows or hides the title."],
					order = 2,
				},
				background = {
					type = "toggle",
					name = L["Background"],
					desc = L["Shows or hides the background."],
					order = 3,
				},
				close = {
					type = "execute",
					name = L["Close"],
					desc = L["Closes the proximity display and prevents showing it ever again for the active boss module (if any), until you go into the options for the relevant boss module and toggle the 'Proximity' option back on."],
					func = "CloseAndDisableProximity",
					order = 4,
				},
			},
		},
	}
}

-----------------------------------------------------------------------
--      Initialization
-----------------------------------------------------------------------

function plugin:OnRegister()
	BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"], OnOptionToggled)
end

function plugin:OnEnable()
	self:RegisterEvent("Ace2_AddonDisabled")
	self:RegisterEvent("BigWigs_ShowProximity")
	self:RegisterEvent("BigWigs_HideProximity")
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
		BigWigs:Print(L["The proximity display has been disabled for %s, please use the boss modules options to enable it again."]:format(active:ToString()))
		active = nil
	end
	dew:Close()
end

function plugin:CloseProximity()
	if anchor then anchor:Hide() end
	self:CancelScheduledEvent("bwproximityupdate")
end

function plugin:OpenProximity()
	if self.db.profile.disabled or not active or not active.proximityCheck or not active.db.profile.proximity then return end

	self:SetupFrames()

	wipe(tooClose)
	anchor.text:SetText(L["|cff777777Nobody|r"])

	anchor.header:SetText(active.proximityHeader or L["Close Players"])
	anchor:Show()
	if not self:IsEventScheduled("bwproximityupdate") then
		self:ScheduleRepeatingEvent("bwproximityupdate", self.UpdateProximity, .5, self)
	end
end

function plugin:TestProximity()
	self:SetupFrames()

	anchor.text:SetText(L["|cff777777Nobody|r"])
	anchor:Show()
end

function plugin:UpdateProximity(list)
	if not list then
		if not active or not active.proximityCheck then return end
		local num = GetNumRaidMembers()
		for i = 1, num do
			local n = GetRaidRosterInfo(i)
			if UnitExists(n) and not UnitIsDeadOrGhost(n) and not UnitIsUnit(n, "player") then
				if type(active.proximityCheck) == "function" then
					if active.proximityCheck(n) then
						table.insert(tooClose, coloredNames[n])
					end
				elseif active.proximityCheck == "bandage" then
					for i, v in ipairs(bandages) do
						if IsItemInRange(v, n) == 1 then
							table.insert(tooClose, coloredNames[n])
							break
						end
					end
				end
			end
			if #tooClose > 4 then break end
		end
	else
		tooClose = list
	end

	if #tooClose == 0 then
		anchor.text:SetText(L["|cff777777Nobody|r"])
	else
		anchor.text:SetText(table.concat(tooClose, "\n"))
		wipe(tooClose)
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

local function showConfig()
	dew:FeedAceOptionsTable(plugin.consoleOptions.args.display)
end

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	plugin:SavePosition()
end
local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
local function OnDragHandleMouseUp(self, button) self.frame:StopMovingOrSizing() end
local function onResize(self, width, height)
	plugin.db.profile.width = width
	plugin.db.profile.height = height
end
local function displayOnMouseDown(self, button)
	if button == "RightButton" then
		dew:Open(self, "children", showConfig)
	end
end

local locked = nil
function lockDisplay()
	if locked then return end
	anchor:EnableMouse(false)
	anchor:SetMovable(false)
	anchor:SetResizable(false)
	anchor:RegisterForDrag()
	anchor:SetScript("OnSizeChanged", nil)
	anchor:SetScript("OnDragStart", nil)
	anchor:SetScript("OnDragStop", nil)
	anchor:SetScript("OnMouseDown", nil)
	anchor.drag:Hide()
	anchor.header:Hide()
	locked = true
end
function unlockDisplay()
	if not locked then return end
	anchor:EnableMouse(true)
	anchor:SetMovable(true)
	anchor:SetResizable(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetScript("OnSizeChanged", onResize)
	anchor:SetScript("OnDragStart", onDragStart)
	anchor:SetScript("OnDragStop", onDragStop)
	anchor:SetScript("OnMouseDown", displayOnMouseDown)
	anchor.drag:Show()
	anchor.header:Show()
	locked = nil
end

function plugin:SetupFrames()
	if anchor then return end

	local display = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
	display:SetWidth(self.db.profile.width)
	display:SetHeight(self.db.profile.height)
	display:SetMinResize(100, 30)
	local bg = display:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
	display.background = bg
	local header = display:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontNormal)
	header:SetText("Proximity")
	header:SetPoint("BOTTOM", display, "TOP", 0, 4)
	local text = display:CreateFontString(nil, "OVERLAY")
	text:SetFontObject(GameFontNormal)
	text:SetFont(L["font"], 12)
	text:SetText("")
	text:SetAllPoints(display)
	display.text = text
	display.header = header

	local drag = CreateFrame("Frame", nil, display)
	drag.frame = display
	drag:SetFrameLevel(display:GetFrameLevel() + 10) -- place this above everything
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
	drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
	drag:SetAlpha(0.5)
	display.drag = drag

	local tex = drag:CreateTexture(nil, "BACKGROUND")
	tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)

	anchor = display
	self:RestyleWindow()

	local x = self.db.profile.posx
	local y = self.db.profile.posy
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self:ResetAnchor()
	end
end

function plugin:RestyleWindow()
	if self.db.profile.lock then
		locked = nil
		lockDisplay()
	else
		locked = true
		unlockDisplay()
	end
	if self.db.profile.title then
		anchor.header:Show()
	else
		anchor.header:Hide()
	end
	if self.db.profile.background then
		anchor.background:Show()
	else
		anchor.background:Hide()
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

