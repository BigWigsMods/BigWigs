assert(BigWigs, "BigWigs not found!")

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:New("Flash", tonumber(("$Revision$"):sub(12, -3)))
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

-- Frames
local flasher = nil
local shaker = nil

-- Shake properties
local shaking = nil
local SHAKE_DURATION = 0.8
local SHAKE_X = 10
local SHAKE_Y = 10
local fail = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsFlashNShake")
L:RegisterTranslations("enUS", function() return {
	["FlashNShake"] = true,
	["Flash'N'Shake"] = true,
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = true,

	["Flash"] = true,
	["Toggle Flash on or off."] = true,

	["Shake"] = true,
	["Toggle Shake on or off."] = true,

	["Test"] = true,
	["Perform a Flash/Shake test."] = true,

	flash_warning = "Screen Shake failed. This is usually caused when nameplates are on.\nTurn off nameplates and reload UI or turn off BigWigs 'Shake'. (Flash is NOT affected)",
} end)

L:RegisterTranslations("koKR", function() return {
	["FlashNShake"] = "번쩍임N진동",
	["Flash'N'Shake"] = "번쩍임과 진동",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "당신에게 직접적으로 중요한 무언가가 영향을 미칠때 화면을 흔들거나 파란색으로 번쩍입니다.",

	["Flash"] = "번쩍임",
	["Toggle Flash on or off."] = "번쩍임을 켜거나 끕니다.",

	["Shake"] = "진동",
	["Toggle Shake on or off."] = "진동을 켜거나 끕니다.",

	["Test"] = "테스트",
	["Perform a Flash/Shake test."] = "번쩍임/진동 테스트를 실행합니다.",

	flash_warning = "화면 번쩍임은 실패했습니다. 이것은 보통 nameplates(이름표 표시)가 켜져 있을 때 일어납니다.\n nameplates(이름표 표시)를 끄고 UI를 다시 로딩을 하거나 BigWigs의 '진동'을 끄세요. (번쩍임은 영향 받지 않습니다)",
} end)

L:RegisterTranslations("frFR", function() return {
	["Flash'N'Shake"] = "Flash'N'Shake",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "Secoue et/ou fais flasher l'écran en bleu quand quelque chose d'important vous affecte directement.",

	["Flash"] = "Flash",
	["Toggle Flash on or off."] = "Fais flasher ou non l'écran.",

	["Shake"] = "Secousse",
	["Toggle Shake on or off."] = "Fais secouer ou non l'écran.",

	["Test"] = "Test",
	["Perform a Flash/Shake test."] = "Effectue un test du flash/de la secousse.",

	flash_warning = "Échec de la secousse de l'écran. Ceci arrive habituellement quand les \"nameplates\" (l'affichage des noms et des barres de vie au dessus des personnages dans le champ de jeu) sont activés.\nDésactivez-les et rechargez l'IU, ou désactivez la 'Secousse' de BigWigs (le flash n'est PAS affecté).",
} end)

L:RegisterTranslations("zhCN", function() return {
	["FlashNShake"] = "屏幕闪烁/震动",
	["Flash'N'Shake"] = "屏幕闪烁/震动",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "如有重要事件发生，屏幕将会蓝色闪烁/震动告知玩家。",

	["Flash"] = "闪烁",
	["Toggle Flash on or off."] = "启用或禁用屏幕闪烁通知。",

	["Shake"] = "震动",
	["Toggle Shake on or off."] = "启用或禁用屏幕震动通知。",

	["Test"] = "测试",
	["Perform a Flash/Shake test."] = "屏幕闪烁/震动测试。",

	flash_warning = "屏幕震动失效。请至 界面>>名字 中关闭除 敌方玩家 之外的项目。\n关闭标示并重置 UI 或关闭 BigWigs“震动”模块。（屏幕闪烁无效）",
} end)

L:RegisterTranslations("zhTW", function() return {
	["FlashNShake"] = "螢幕閃爍/震動",
	["Flash'N'Shake"] = "螢幕閃爍/震動",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "如有重要事件發生，螢幕將會閃爍藍光/震動告知玩家。",

	["Flash"] = "閃爍",
	["Toggle Flash on or off."] = "啟用或關閉螢幕閃爍",

	["Shake"] = "震動",
	["Toggle Shake on or off."] = "啟用或關閉螢幕閃震動",

	["Test"] = "測試",
	["Perform a Flash/Shake test."] = "測試螢幕閃爍/震動",
} end)

L:RegisterTranslations("deDE", function() return {
	["FlashNShake"] = "Aufblitzen/Beben",
	["Flash'N'Shake"] = "Aufblitzen/Beben",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "Lässt den Bildschirm beben und/oder blau aufblitzen, wenn etwas Wichtiges passiert, das direkt dich betrifft.",

	["Flash"] = "Aufblitzen",
	["Toggle Flash on or off."] = "Schaltet Aufblitzen ein oder aus.",

	["Shake"] = "Beben",
	["Toggle Shake on or off."] = "Schaltet Beben ein oder aus.",

	["Test"] = "Test",
	["Perform a Flash/Shake test."] = "Führe einen Aufblitzen/Beben Test durch.",

	flash_warning = "Bildschirmbeben fehlgeschlagen. Dies passiert, wenn die Gesundheitsanzeige unter den Namen eingeschaltet ist.\nSchalte diese aus und lade das UI neu oder schalte das Beben von BigWigs aus (Aufblitzen ist nicht betroffen).",
} end)

L:RegisterTranslations("esES", function() return {
	["FlashNShake"] = "Destello/Temblor",
	["Flash'N'Shake"] = "Destello / Temblor",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "Hacer temblar la pantalla y/o emitir un destello cuando ocurre algo importante que te afecta.",

	["Flash"] = "Destello",
	["Toggle Flash on or off."] = "Activar / Desactivar el destello.",

	["Shake"] = "Temblor",
	["Toggle Shake on or off."] = "Activar / Desactivar el temblor.",

	["Test"] = "Probar",
	["Perform a Flash/Shake test."] = "Efectua una prueba de Destello/Temblor.",

	flash_warning = "Temblor de pantalla fallido. Suele ocurrir cuando las placas de nombre están activadas.\nDesactiva las placas de nombre y reinicia la interfaz o desactiva la función 'Temblor' de BigWigs. (la función de Destello NO se ve afectada)",
} end)

-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["FlashNShake"] = "МерцаниеИСотрясение",
	["Flash'N'Shake"] = "Мерцание и Сотрясение",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "Сотрясение и/или Мерцание экрана когда чтото важное случается непосредственно с вами",

	["Flash"] = "Мерцание",
	["Toggle Flash on or off."] = "Вкл/Выкл мерцание экрана",

	["Shake"] = "Сотрясение",
	["Toggle Shake on or off."] = "Вкл/Выкл сотрясение экрана",

	["Test"] = "Тест",
	["Perform a Flash/Shake test."] = "Тест Мерцание/Сотрясение.",

	flash_warning = "Мерцание экрана неудалась. Это обычно бывает когда таблица с именами включена.\nСократите таблицу и перезагрузите UI или отключите BigWigs 'Сотрясение'. (Мерцание НЕ затронуто)",
} end)

--------------------------------------------------------------------------------
-- Options
--

mod.defaultDB = {
	flash = false,
	shake = false,
}
mod.external = true
mod.consoleCmd = L["FlashNShake"]
mod.consoleOptions = {
	type = "group",
	name = L["Flash'N'Shake"],
	desc = L["Shake and/or Flash the screen blue when something important happens that directly affects you."],
	args = {
		[L["Flash"]] = {
			type = "toggle",
			name = L["Flash"],
			desc = L["Toggle Flash on or off."],
			order = 1,
			get = function() return mod.db.profile.flash end,
			set = function(v)
				mod.db.profile.flash = v
			end,
		},
		[L["Shake"]] = {
			type = "toggle",
			name = L["Shake"],
			desc = L["Toggle Shake on or off."],
			order = 2,
			get = function() return mod.db.profile.shake end,
			set = function(v)
				mod.db.profile.shake = v
			end,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 3,
		},
		[L["Test"]] = {
			type = "execute",
			name = L["Test"],
			desc = L["Perform a Flash/Shake test."],
			order = 4,
			handler = mod,
			func = "BigWigs_Test",
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("BigWigs_Message")
end

------------------------------
--      Shaking             --
------------------------------

local originalPoints = nil
local function startShake()
	if not shaking then
		-- store old worldframe positions, we need them all, people have frame modifiers for it etc.
		if not originalPoints then
			originalPoints = {}
			for i = 1, WorldFrame:GetNumPoints() do
				table.insert(originalPoints, {WorldFrame:GetPoint(i)})
			end
		end
		shaking = SHAKE_DURATION -- don't think we want to make this a setting.
		shaker:Show()
	end
end

local function shakeOnUpdate(frame, elapsed)
	shaking = shaking - elapsed
	local x, y = 0, 0 -- Resets to original position if we're supposed to stop.
	if shaking <= 0 then -- stop shaking
		shaking = nil
		shaker:Hide()
	else
		x = math.random(-SHAKE_X,SHAKE_X)
		y = math.random(-SHAKE_Y,SHAKE_Y)
	end
	WorldFrame:ClearAllPoints()
	for i, v in ipairs(originalPoints) do
		WorldFrame:SetPoint(v[1], v[2], v[3], v[4] + x, v[5] + y)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_Message(msg, color)
	if color and color == "Personal" then
		if self.db.profile.flash then
			if not flasher then --frame creation
				flasher = CreateFrame("Frame", "BWFlash", UIParent)
				flasher:SetFrameStrata("BACKGROUND")
				flasher:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
				flasher:SetBackdropColor(0,0,1,0.55)
				flasher:SetAllPoints( UIParent)
				flasher:SetScript("OnShow", function (self)
					self.elapsed = 0
					self:SetAlpha(0)
				end)
				flasher:SetScript("OnUpdate", function (self, elapsed)
					elapsed = self.elapsed + elapsed
					if elapsed >= 0.8 then
						self:Hide()
						self:SetAlpha(0)
						return
					end
					local alpha = elapsed % 0.4
					if elapsed > 0.2 then
						alpha = 0.4 - alpha
					end
					self:SetAlpha(alpha * 5)
					self.elapsed = elapsed
				end)
				flasher:Hide()
			end
			flasher:Show()
		end

		if self.db.profile.shake then
			if not shaker then
				shaker = CreateFrame("Frame", "BWShaker", UIParent)
				shaker:Hide()
				shaker:SetScript("OnUpdate", shakeOnUpdate)
			end
			local check = WorldFrame:IsProtected()
			if not check then
				startShake()
			elseif check and not fail then
				BigWigs:Print(L["flash_warning"])
				fail = true
			end
		end
	end
end

function mod:BigWigs_Test()
	self:TriggerEvent("BigWigs_Message", L["Test"], "Personal", true)
end

