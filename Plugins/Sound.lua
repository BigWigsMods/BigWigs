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
local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Plugins")

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
		local n = L[k] or k
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

