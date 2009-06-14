-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

local plugin = BigWigs:New("Proximity", "$Revision$")
if not plugin then return end

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local dew = AceLibrary("Dewdrop-2.0")

local mute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\mute"
local unmute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\unmute"

local lockWarned = nil
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
	["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = true,
	["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = true,

	proximity = "Proximity display",
	proximity_desc = "Show the proximity window when appropriate for this encounter, listing players who are standing too close to you.",

	font = "Fonts\\FRIZQT__.TTF",

	["Close"] = true,
	["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = true,
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
	["Toggle sound"] = true,
	["Toggle whether or not the proximity window should beep when you're too close to another player."] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Proximity"] = "近距离",
	["Close Players"] = "近距离玩家",
	["Options for the Proximity Display."] = "近距离显示选项。",
	["|cff777777Nobody|r"] = "|cff777777没有玩家|r",
	["Sound"] = "声效",
	["Play sound on proximity."] = "近距离时声效提示。",
	["Disabled"] = "禁用",
	["Disable the proximity display for all modules that use it."] = "禁止所有首领模块使用近距离。",
	["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "近距离显示已被锁定，需要移动或其他选项，右击 Big Wigs 图标，附加功能 -> 近距离 -> 显示可以切换锁定选项。",

	proximity = "近距离显示",
	proximity_desc = "显示近距离窗口，列出距离你很近的玩家。",

	font = "Fonts\\ZYKai_T.TTF",

	["Close"] = "关闭",
	["Test"] = "测试",
	["Perform a Proximity test."] = "距离报警测试。",
	["Display"] = "显示",
	["Options for the Proximity display window."] = "近距离显示窗口选项。",
	["Lock"] = "锁定",
	["Locks the display in place, preventing moving and resizing."] = "锁定显示窗口，防止被移动和缩放。",
	["Title"] = "标题",
	["Shows or hides the title."] = "显示或隐藏标题。",
	["Background"] = "背景",
	["Shows or hides the background."] = "显示或隐藏背景。",
	["Toggle sound"] = "切换声效",
	["Toggle whether or not the proximity window should beep when you're too close to another player."] = "当近距离窗口有其他过近玩家时切换任一或关闭声效。",
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
	["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "다음 표시때 접근 표시를 표시하도록 합니다. 이것을 비활성화 하려면 옵션을 통해 전환하세요.",
	["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "접근 표시가 고정되어 있습니다. 고정을 해제하길 원하거나 설정하려면 Big Wigs 아이콘의 우클릭하여 기타 -> 접근 -> 표시 이곳을 통해 이동 또는 기타 설정을 할 수 있습니다.",

	proximity = "접근 표시",
	proximity_desc = "해당 보스전에서 필요 시 자신과 근접해 있는 플레이어 목록을 표시하는 접근 표시창을 표시합니다.",

	font = "Fonts\\2002.TTF",
	
	["Close"] = "닫기",
	["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "접근 표시를 닫습니다.\n\n완전히 비활성화기 위해서는 해당 보스 모듈에 있는 옵션의 접근 표시를 끄세요.",
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
	["Toggle sound"] = "소리 전환",
	["Toggle whether or not the proximity window should beep when you're too close to another player."] = "접근 창에 다른 플에이어와 가까이 있을 경에 알리는 경고음을 켜거나 끌수있게 합니다.",
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
	["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "L'affichage de proximité sera affiché la prochaine fois. Pour le désactiver complètement, rendez-vous dans les options du boss et décochez \"Proximité\".",
	["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "L'affichage de proximité a été verrouillé. Vous devez faire un clic droit sur l'icône de BigWigs, puis allez dans Extras -> Proximité -> Affichage et décocher l'option Verrouiller si vous voulez le déplacer ou accédez aux autres options.",

	proximity = "Proximité",
	proximity_desc = "Affiche la fenêtre de proximité quand approprié pour cette rencontre, indiquant la liste des joueurs qui se trouvent trop près de vous.",

	font = "Fonts\\FRIZQT__.TTF",

	["Close"] = "Fermer",
	["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Ferme l'affichage de proximité.\nPour le désactiver complètement, rendez-vous dans les options du boss et décochez \"Proximité\".",
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
	["Toggle sound"] = "Son",
	["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Fait ou non bipper la fenêtre de proximité quand vous êtes trop près d'un autre joueur.",
} end)

L:RegisterTranslations("deDE", function() return {
	["Proximity"] = "Nähe",
	["Close Players"] = "Nahe Spieler",
	["Options for the Proximity Display."] = "Optionen für die Anzeige naher Spieler.",
	["|cff777777Nobody|r"] = "|cff777777Niemand|r",
	["Sound"] = "Sound",
	["Play sound on proximity."] = "Spielt einen Sound ab, wenn du zu nahe an einem anderen Spieler stehst.",
	["Disabled"] = "Deaktivieren",
	["Disable the proximity display for all modules that use it."] = "Deaktiviert die Anzeige naher Spieler für alle Module, die sie benutzen.",
	["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Die Anzeige naher Spieler wird beim nächsten Mal angezeigt werden. Um sie für diesen Boss vollständig zu deaktivieren, musst du die Option 'Nähe' im Bossmodul ausschalten.",
	["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "Die Anzeige naher Spieler wurde gesperrt. Falls du das Fenster wieder bewegen oder Zugang zu den anderen Optionen haben willst, musst du das Big Wigs Symbol rechts-klicken, zu Extras -> Nähe -> Anzeige gehen und die Option 'Sperren' ausschalten.",

	proximity = "Nähe",
	proximity_desc = "Zeigt das Fenster für nahe Spieler an. Es listet alle Spieler auf, die dir zu nahe stehen.",

	font = "Fonts\\FRIZQT__.TTF",

	["Close"] = "Schließen",
	["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Schließt die Anzeige naher Spieler.\n\nFalls du die Anzeige für alle Bosse deaktivieren willst, musst du die Option 'Nähe' seperat in den jeweiligen Bossmodulen ausschalten.",
	["Test"] = "Test",
	["Perform a Proximity test."] = "Führt einen Test der Anzeige naher Spieler durch.",
	["Display"] = "Anzeige",
	["Options for the Proximity display window."] = "Optionen für das Fenster der Anzeige naher Spieler.",
	["Lock"] = "Sperren",
	["Locks the display in place, preventing moving and resizing."] = "Sperrt die Anzeige und verhindert weiteres Verschieben und Anpassen der Größe.",
	["Title"] = "Titel",
	["Shows or hides the title."] = "Zeigt oder versteckt den Titel der Anzeige.",
	["Background"] = "Hintergrund",
	["Shows or hides the background."] = "Zeigt oder versteckt den Hintergrund der Anzeige.",
	["Toggle sound"] = "Sound an/aus",
	["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Schaltet den Sound ein oder aus, der gespielt wird, wenn du zu nahe an einem anderen Spieler stehst.",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Proximity"] = "鄰近顯示",
	["Close Players"] = "鄰近玩家",
	["Options for the Proximity Display."] = "設定鄰近顯示選項。",
	["|cff777777Nobody|r"] = "|cff777777沒有玩家|r",
	["Sound"] = "音效",
	["Play sound on proximity."] = "接近時發出音效。",
	["Disabled"] = "禁用",
	["Disable the proximity display for all modules that use it."] = "禁止所有首領模组使用。",
	["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "鄰近顯示視窗已經鎖定,你需要右鍵點擊BigWigs圖示,移到附加功能 -> 鄰近顯示 -> 切換鎖定選項如果你想要移動視窗或是透過其他設定.",

	proximity = "鄰近顯示",
	proximity_desc = "顯示鄰近顯示視窗，列出距離你很近的玩家。",

	font = "Fonts\\bHEI01B.TTF",

	["Close"] = "關閉",
	["Test"] = "測試",
	["Perform a Proximity test."] = "進行鄰近顯示測試。",
	["Display"] = "顯示",
	["Options for the Proximity display window."] = "鄰近顯示視窗選項。。",
	["Lock"] = "鎖定",
	["Locks the display in place, preventing moving and resizing."] = "鎖定顯示視窗，防止被移動和縮放。",
	["Title"] = "標題",
	["Shows or hides the title."] = "顯示或隱藏標題。",
	["Background"] = "背景",
	["Shows or hides the background."] = "顯示或隱藏背景。",
	["Toggle sound"] = "切換聲效",
	["Toggle whether or not the proximity window should beep when you're too close to another player."] = "當鄰近顯示視窗有其他過近玩家時切換任一或關閉聲效。",
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

	proximity = "Ventana de proximidad",
	proximity_desc = "Muestra la ventana de proximidad cuando sea apropiado para este encuentro, listando los jugadores que est\195\161n demasiado cerca de t\195\173.",

	font = "Fonts\\FRIZQT__.TTF",
} end)
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["Proximity"] = "Близость",
	["Close Players"] = "Слишком близко",
	["Options for the Proximity Display."] = "Опции отображения близости.",
	["|cff777777Nobody|r"] = "|cff777777Никого|r",
	["Sound"] = "Звук",
	["Play sound on proximity."] = "Проиграть звук при приближении игроков.",
	["Disabled"] = "Отключить",
	["Disable the proximity display for all modules that use it."] = "Отключить отображение окна близости для всех модулей использующих его.",
	["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "Отображение модуля близости зафиксировано, вам нужно нажать правую клавишу мыши по иконке Big Wigs, перейти в Extras -> Близость -> Отображение и переключить опцию Фиксировать, если вы хотите его переместить или получить доступ к другим опциям.",

	proximity = "Отображение близости",
	proximity_desc = "Показывать окно близости при соответствующей схватке, выводя список игроков которые стоят слишком близко к вам.",

	font = "Fonts\\NIM_____.ttf",

	["Close"] = "Закрыть",
	["Test"] = "Тест",
	["Perform a Proximity test."] = "Тест близости",
	["Display"] = "Отображение",
	["Options for the Proximity display window."] = "Настройки окна близости.",
	["Lock"] = "Фиксировать",
	["Locks the display in place, preventing moving and resizing."] = "Фиксирование рамки, предотвращает перемещение и изменение размера.",
	["Title"] = "Заглавие",
	["Shows or hides the title."] = "Показать или скрыть заглавие.",
	["Background"] = "Фон",
	["Shows or hides the background."] = "Показать или скрыть фон.",
	["Toggle sound"] = "Вкл/Выкл звук",
	["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Включить/выключить звуковое оповещение окна близости, когда вы находитесь слишком близко к другому игроку.",
} end)

--------------------------------------------------------------------------------
-- Options
--

local function updateSoundButton()
	anchor.sound:SetNormalTexture(plugin.db.profile.sound and unmute or mute)
end
local function toggleSound()
	plugin.db.profile.sound = not plugin.db.profile.sound
	updateSoundButton()
end

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
	proximity = true,
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
		elseif key == "sound" then
			updateSoundButton()
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
				if key == "lock" and value and not lockWarned then
					BigWigs:Print(L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."])
					lockWarned = true
				end
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
					desc = L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."],
					func = "CloseProximity",
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
	if CUSTOM_CLASS_COLORS then
		local function update()
			wipe(coloredNames)
			for k, v in pairs(CUSTOM_CLASS_COLORS) do
				hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
			end
		end
		CUSTOM_CLASS_COLORS:RegisterCallback(update)
		update()
	end
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
	if active then error("The proximity window is already running for another module.") end
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

function plugin:CloseProximity()
	if anchor then anchor:Hide() end
	self:CancelScheduledEvent("bwproximityupdate")
	dew:Close()
end

function plugin:OpenProximity()
	if self.db.profile.disabled then return end
	if active and (not active.proximityCheck or not active.db.profile.proximity) then return end
	self:SetupFrames()

	wipe(tooClose)
	anchor.text:SetText(L["|cff777777Nobody|r"])

	if not active or active.proximitySilent then
		anchor.sound:Hide()
	else
		anchor.sound:Show()
	end

	anchor.header:SetText(active and active.proximityHeader or L["Close Players"])
	anchor:Show()
	if not self:IsEventScheduled("bwproximityupdate") then
		self:ScheduleRepeatingEvent("bwproximityupdate", self.UpdateProximity, .5, self)
	end
end

function plugin:TestProximity()
	if active then error("The proximity module is already running for another boss module.") end
	self:OpenProximity()
end

function plugin:UpdateProximity()
	local num = GetNumRaidMembers()
	for i = 1, num do
		local n = GetRaidRosterInfo(i)
		if UnitExists(n) and not UnitIsDeadOrGhost(n) and not UnitIsUnit(n, "player") then
			if not active or not active.proximityCheck or active.proximityCheck == "bandage" then
				for i, v in next, bandages do
					if IsItemInRange(v, n) == 1 then
						table.insert(tooClose, coloredNames[n])
						break
					end
				end
			elseif active and type(active.proximityCheck) == "function" then
				if active.proximityCheck(n) then
					table.insert(tooClose, coloredNames[n])
				end
			end
		end
		if #tooClose > 4 then break end
	end

	if #tooClose == 0 then
		anchor.text:SetText(L["|cff777777Nobody|r"])
	else
		anchor.text:SetText(table.concat(tooClose, "\n"))
		wipe(tooClose)
		local t = time()
		if t > lastplayed + 1 then
			lastplayed = t
			if active and self.db.profile.sound and UnitAffectingCombat("player") and not active.proximitySilent then
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
	anchor.close:Hide()
	anchor.sound:Hide()
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
	anchor.close:Show()
	anchor.sound:Show()
	locked = nil
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

function plugin:SetupFrames()
	if anchor then return end

	local display = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
	display:SetWidth(self.db.profile.width)
	display:SetHeight(self.db.profile.height)
	display:SetMinResize(100, 30)
	display:SetClampedToScreen(true)
	local bg = display:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
	display.background = bg

	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
	close:SetHeight(16)
	close:SetWidth(16)
	close.tooltipHeader = L["Close"]
	close.tooltipText = L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."]
	close:SetScript("OnEnter", onControlEnter)
	close:SetScript("OnLeave", onControlLeave)
	close:SetScript("OnClick", function()
		if active then
			BigWigs:Print(L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."])
		end
		plugin:CloseProximity()
	end)
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
	display.close = close

	local sound = CreateFrame("Button", nil, display)
	sound:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	sound:SetHeight(16)
	sound:SetWidth(16)
	sound.tooltipHeader = L["Toggle sound"]
	sound.tooltipText = L["Toggle whether or not the proximity window should beep when you're too close to another player."]
	sound:SetScript("OnEnter", onControlEnter)
	sound:SetScript("OnLeave", onControlLeave)
	sound:SetScript("OnClick", toggleSound)
	display.sound = sound

	local header = display:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontNormal)
	header:SetText(L["Proximity"])
	header:SetPoint("BOTTOM", display, "TOP", 0, 4)
	display.header = header

	local text = display:CreateFontString(nil, "OVERLAY")
	text:SetFontObject(GameFontNormal)
	text:SetFont(L["font"], 12)
	text:SetText("")
	text:SetAllPoints(display)
	display.text = text

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
	if not anchor then return end
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
	updateSoundButton()
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

