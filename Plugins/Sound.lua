assert(BigWigs, "BigWigs not found!")

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:New("Sounds", "$Revision$")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local media = LibStub("LibSharedMedia-3.0")
local mType = media.MediaType and media.MediaType.SOUND or "sound"
local db = nil

local sounds = {
	Long = "BigWigs: Long",
	Info = "BigWigs: Info",
	Alert = "BigWigs: Alert",
	Alarm = "BigWigs: Alarm",
	Victory = "BigWigs: Victory",
}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsSound")
L:RegisterTranslations("enUS", function() return {
	["Sounds"] = true,
	["Options for sounds."] = true,

	["Alarm"] = true,
	["Info"] = true,
	["Alert"] = true,
	["Long"] = true,
	["Victory"] = true,

	["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = true,
	["Use sounds"] = true,
	["Toggle all sounds on or off."] = true,
	["Default only"] = true,
	["Use only the default sound."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Sounds"] = "효과음",
	["Options for sounds."] = "효과음에 대한 설정입니다.",

	["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "%q에 사용할 효과음을 설정합니다.\n\n미리듣기는 CTRL-클릭하세요.",
	["Use sounds"] = "효과음 사용",
	["Toggle all sounds on or off."] = "모든 효과음을 켜거나 끕니다.",
	["Default only"] = "기본음",
	["Use only the default sound."] = "기본음만을 사용합니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Sounds"] = "声音",
	["Options for sounds."] = "声音设置。",

	["Alarm"] = "警报",
	["Info"] = "信息",
	["Alert"] = "报警",
	["Long"] = "长计时",
	["Victory"] = "胜利",

	["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "设置使用%q声音（Ctrl-点击可以预览效果）。",
	["Use sounds"] = "使用声音",
	["Toggle all sounds on or off."] = "选择声音的开或关。",
	["Default only"] = "预设",
	["Use only the default sound."] = "只选用预设声音。",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Sounds"] = "聲音",
	["Options for sounds."] = "聲音選項",

	["Alarm"] = "鬧鈴",
	["Info"] = "資訊",
	["Alert"] = "警告",
	["Long"] = "長響",
	["Victory"] = "勝利",

	["Use sounds"] = "使用聲音",
	["Toggle all sounds on or off."] = "切換是否使用聲音",
	["Default only"] = "僅用預設",
	["Use only the default sound."] = "只用預設聲音",
} end)

L:RegisterTranslations("deDE", function() return {
	["Sounds"] = "Sounds",
	["Options for sounds."] = "Optionen für die Sounds.",

	["Alarm"] = "Alarm",
	["Info"] = "Info",
	["Alert"] = "Warnung",
	["Long"] = "Lang",
	["Victory"] = "Sieg",

	["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Legt den Sound fest, der für %q verwendet wird.\n\nStrg-Klicken, um reinzuhören.",
	["Use sounds"] = "Sounds verwenden",
	["Toggle all sounds on or off."] = "Schaltet alle Sounds ein oder aus.",
	["Default only"] = "Nur Standards",
	["Use only the default sound."] = "Verwendet nur die Standard-Sounds.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Sounds"] = "Sons",
	["Options for sounds."] = "Options concernant les sons.",

	["Alarm"] = "Alarme",
	["Info"] = "Info",
	["Alert"] = "Alerte",
	["Long"] = "Long",
	["Victory"] = "Victoire",

	["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Détermine le son à utiliser pour %q (Ctrl-clic sur un son pour avoir un aperçu).",
	["Use sounds"] = "Utiliser les sons",
	["Toggle all sounds on or off."] = "Joue ou non les sons.",
	["Default only"] = "Son par défaut uniquement",
	["Use only the default sound."] = "Utilise uniquement le son par défaut.",
} end)

L:RegisterTranslations("esES", function() return {
	["Sounds"] = "Sonidos",
	["Options for sounds."] = "Opciones de los sonidos",

	["Alarm"] = "Alarma",
	["Info"] = "Información",
	["Alert"] = "Alerta",
	["Long"] = "Largo",
	["Victory"] = "Victoria",

	["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Establece el sonido a usar para %q (Ctrl-Click en un sonido para escucharlo).",
	["Toggle all sounds on or off."] = "Activa o desactiva todos los sonidos.",
	["Default only"] = "Solo por defecto",
	["Use only the default sound."] = "Usar solo el sonido por defecto",
} end)
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["Sounds"] = "Звуки",
	["Options for sounds."] = "Опции звуков",

	["Alarm"] = "Тревога",
	["Info"] = "Информация",
	["Alert"] = "Предупреждения",
	["Long"] = "Длинный",
	["Victory"] = "Победа",

	["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Установите звук для использования в %q.\n\nCtrl-Клик для предварительного просмотра звука.",
	["Use sounds"] = "Использовать звуки",
	["Toggle all sounds on or off."] = "Вкл/Выкл все звуки",
	["Default only"] = "Только стандартные",
	["Use only the default sound."] = "Использовать только стандартные звуки.",
} end)

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	defaultonly = false,
	sound = true,
	media = {
		Long = "BigWigs: Long",
		Info = "BigWigs: Info",
		Alert = "BigWigs: Alert",
		Alarm = "BigWigs: Alarm",
		Victory = "BigWigs: Victory",
	},
}
plugin.consoleCmd = L["Sounds"]
plugin.consoleOptions = {
	type = "group",
	name = L["Sounds"],
	desc = L["Options for sounds."],
	args = {
		spacer1 = {
			type = "header",
			name = " ",
			order = 200,
		},
		default = {
			type = "toggle",
			name = L["Default only"],
			desc = L["Use only the default sound."],
			get = function() return plugin.db.profile.defaultonly end,
			set = function(v) plugin.db.profile.defaultonly = v end,
			order = 201,
			disabled = function() return not BigWigs:IsModuleActive(plugin) end,
		},
		toggle = {
			type = "toggle",
			name = L["Sounds"],
			desc = L["Toggle all sounds on or off."],
			get = function() return plugin.db.profile.sound end,
			set = function(v)
				plugin.db.profile.sound = v
				BigWigs:ToggleModuleActive(plugin, v)
			end,
			order = 202,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

local function ShouldDisable()
	return not BigWigs:IsModuleActive(plugin) or plugin.db.profile.defaultonly
end

function plugin:OnRegister()
	db = self.db.profile

	media:Register(mType, "BigWigs: Long", "Interface\\AddOns\\BigWigs\\Sounds\\Long.mp3")
	media:Register(mType, "BigWigs: Info", "Interface\\AddOns\\BigWigs\\Sounds\\Info.mp3")
	media:Register(mType, "BigWigs: Alert", "Interface\\AddOns\\BigWigs\\Sounds\\Alert.mp3")
	media:Register(mType, "BigWigs: Alarm", "Interface\\AddOns\\BigWigs\\Sounds\\Alarm.mp3")
	media:Register(mType, "BigWigs: Victory", "Interface\\AddOns\\BigWigs\\Sounds\\Victory.mp3")
	media:Register(mType, "BigWigs: Victory Long", "Interface\\AddOns\\BigWigs\\Sounds\\VictoryLong.mp3")
	media:Register(mType, "BigWigs: Victory Classic", "Interface\\AddOns\\BigWigs\\Sounds\\VictoryClassic.mp3")

	local function get(sound)
		return db.media[sound]
	end

	local function set(sound, value)
		if IsControlKeyDown() then
			PlaySoundFile(media:Fetch(mType, value))
		else
			db.media[sound] = value
		end
	end

	for k in pairs(sounds) do
		local n = L:HasTranslation(k) and L[k] or k
		self.consoleOptions.args[k] = {
			type = "text",
			name = n,
			desc = L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."]:format(n),
			passValue = k,
			get = get,
			set = set,
			disabled = ShouldDisable,
			validate = media:List(mType),
		}
	end
end

function plugin:OnEnable()
	if not db.sound then
		BigWigs:ToggleModuleActive(self, false)
		return
	end

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_Sound")
end

local function play(sound)
	if type(sound) == "string" and not db.defaultonly then
		local s = db.media[sound] and media:Fetch(mType, db.media[sound]) or media:Fetch(mType, sound)
		if type(s) == "string" then
			PlaySoundFile(s)
			return
		end
	end
	PlaySound("RaidWarning")
end

function plugin:BigWigs_Message(text, color, noraidsay, sound, broadcastonly)
	if not text or sound == false or broadcastonly or not db.sound then return end
	play(sound)
end

function plugin:BigWigs_Sound(sound)
	if not db.sound or sound == false then return end
	play(sound)
end

