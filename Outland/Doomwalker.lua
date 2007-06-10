------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doomwalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started = nil
local enrageAnnounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Doomwalker",

	engage_trigger = "Do not proceed. You will be eliminated.", --verify

	overrun = "Overrun",
	overrun_desc = "Alert when Doomwalker uses his Overrun ability.",
	overrun_trigger = "^Doomwalker.-Overrun",
	overrun_message = "Overrun!",
	overrun_soon_message = "Possible Overrun soon!",
	overrun_bar = "~Overrun Cooldown",

	earthquake = "Earthquake",
	earthquake_desc = "Alert when Doomwalker uses his Earthquake ability.",
	earthquake_message = "Earthquake! ~70sec to next!",
	earthquake_bar = "~Earthquake Cooldown",
	earthquake_trigger = "You are afflicted by Earthquake.",

	enrage = "Enrage",
	enrage_desc = "Warn about enrage around 20% hitpoints.",
	engage_message = "Doomwalker engaged, Earthquake in ~30sec!",
	enrage_soon_message = "Enrage soon!",
} end)

L:RegisterTranslations("frFR", function() return {
	overrun = "Renversement",
	overrun_desc = "Préviens quand Marche-funeste utilise sa capacité Renversement.",
	overrun_trigger = "^Marche-funeste.-Renversement",
	overrun_message = "Renversement !",
	overrun_soon_message = "Renversement imminent !",
	overrun_bar = "~Cooldown Renversement",

	earthquake = "Séisme",
	earthquake_desc = "Préviens quand Marche-funeste utilise sa capacité Séisme.",
	earthquake_message = "Séisme ! Prochain dans ~70 sec. !",
	earthquake_bar = "~Cooldown Séisme",
	earthquake_trigger = "Vous subissez les effets de Séisme.",

	enrage = "Enrager",
	enrage_desc = "Préviens quand Marche-funeste devient enragé à ~20%.",
	engage_message = "Marche-funeste engagé, Séisme dans ~30 sec. !",
	enrage_soon_message = "Bientôt enragé !",
} end)

L:RegisterTranslations("koKR", function() return {
	overrun = "괴멸",
	overrun_desc = "파멸의 절단기의 괴멸 사용 가능 시 경고",
	overrun_trigger = "^파멸의 절단기.-괴멸", -- check "^Doomwalker.-Overrun",
	overrun_message = "괴멸!",
	overrun_soon_message = "잠시 후 괴멸 가능!",
	overrun_bar = "~괴멸 대기시간",

	earthquake = "지진",
	earthquake_desc = "파멸의 절단기의 지진 사용 가능 시 경고",
	earthquake_message = "지진! 다음은 약 70초 후!",
	earthquake_bar = "~지진 대기시간",
	earthquake_trigger = "당신은 지진에 걸렸습니다.",

	enrage = "격노",
	enrage_desc = "체력 20%시 격노에 대한 경고",
	engage_message = "파멸의 절단기 전투 개시, 약 30초 이내 지진!",
	enrage_soon_message = "잠시 후 격노!",
} end)

L:RegisterTranslations("deDE", function() return {
	overrun = "\195\156berrennen",
	overrun_desc = "Warnt, wenn Verdammniswandler \195\156berrennen benutzt.",

	earthquake = "Erdbeben",
	earthquake_desc = "Warnt, wenn Verdammniswandler Erdbeben benutzt.",

	enrage = "Wutanfall",
	enrage_desc = "Warnt vor Wutanfall bei 20% Gesundheit.",

	engage_message = "Verdammniswandler angegriffen, Erdbeben in ~30sec!",
	enrage_soon_message = "Wutanfall bald!",

	earthquake_trigger = "Ihr seid von Erdbeben betroffen.",

	earthquake_message = "Erdbeben! ~70sec to next!",
	earthquake_bar = "~Erdbeben Cooldown",

	overrun_trigger = "^Verdammniswandler.-\195\156berrennen",
	overrun_message = "\195\156berrennen!",
	overrun_soon_message = "M\195\182gliches \195\156berrennen bald!",
	overrun_bar = "~\195\156berrennen Cooldown",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss, "AceHook-2.1")
mod.zonename = AceLibrary("Babble-Zone-2.2")["Shadowmoon Valley"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"overrun", "earthquake", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	enrageAnnounced = nil

	self:Hook("ChatFrame_MessageEventHandler", "ChatFrame_MessageEventHandler", true)

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "DoomwalkerEarthquake", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "DoomwalkerOverrun", 10)
end

------------------------------
--         Hooks               --
------------------------------
--need to check if we even still need this in wow 2.1
function mod:ChatFrame_MessageEventHandler(event, ...)
	if event:find("EMOTE") and (type(arg2) == "nil" or not arg2) then
		arg2 = boss
	end
	return self.hooks["ChatFrame_MessageEventHandler"](event, ...)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.earthquake then
			self:Message(L["engage_message"], "Attention")
			self:Bar(L["earthquake_bar"], 30, "Spell_Nature_Earthquake")
		end
		if self.db.profile.overrun then
			self:Bar(L["overrun_bar"], 30, "Ability_BullRush")
			self:DelayedMessage(28, L["overrun_soon_message"], "Attention")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif sync == "DoomwalkerEarthquake" and self.db.profile.earthquake then
		self:Message(L["earthquake_message"], "Important")
		self:Bar(L["earthquake_bar"], 70, "Spell_Nature_Earthquake")
	elseif sync == "DoomwalkerOverrun" and self.db.profile.overrun then
		self:Message(L["overrun_message"], "Important")
		self:Bar(L["overrun_bar"], 30, "Ability_BullRush")
		self:DelayedMessage(28, L["overrun_soon_message"], "Attention")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if msg:find(L["earthquake_trigger"]) then
		self:Sync("DoomwalkerEarthquake")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["overrun_trigger"]) then
		self:Sync("DoomwalkerOverrun")
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(arg1)
		if health > 20 and health <= 25 and not enrageAnnounced then
			self:Message(L["enrage_soon_message"], "Urgent")
			enrageAnnounced = true
		elseif health > 40 and enrageAnnounced then
			enrageAnnounced = false
		end
	end
end
