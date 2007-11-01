------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Terestian Illhoof"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local pName = nil
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Terestian",

	engage_trigger = "^Ah, you're just in time.",

	sacrifice = "Sacrifice",
	sacrifice_desc = "Warn for Sacrifice of players.",
	sacrifice_trigger = "^(%S+) (%S+) afflicted by Sacrifice%.$",
	sacrifice_fade = "^Sacrifice fades from ([^%s]+)%.$",
	sacrifice_message = "%s is being Sacrificed!",
	sacrifice_bar = "Sacrifice: %s",
	sacrifice_soon = "Sacrifice soon!",
	sacrifice_soonbar = "~Possible Sacrifice",

	icon = "Raid Icon",
	icon_desc = "Place a raid icon on the sacrificed player(requires promoted or higher).",

	weak = "Weakened",
	weak_desc = "Warn for weakened state.",
	weak_trigger = "afflicted by Broken Pact%.$",
	weak_message = "Weakened for ~45sec!",
	weak_warning1 = "Weakened over in ~5sec!",
	weak_warning2 = "Weakened over!",
	weak_bar = "~Weakened Fades",
	weak_fade = "^Broken Pact fades",
} end )

L:RegisterTranslations("deDE", function() return {
	--engage_trigger = "^Ah, you're just in time.",

	sacrifice = "Opferung",
	sacrifice_desc = "Warnt welcher Spieler geopfert wird",
	sacrifice_trigger = "^([^%s]+) ([^%s]+) von Opferung betroffen%.$",
	--sacrifice_fade = "^Sacrifice fades from ([^%s]+)%.$",
	sacrifice_message = "%s wird geopfert!",
	sacrifice_bar = "Opferung: %s",
	--sacrifice_soon = "Sacrifice soon!",
	--sacrifice_soonbar = "~Possible Sacrifice",

	--icon = "Raid Icon",
	--icon_desc = "Place a raid icon on the sacrificed player(requires promoted or higher).",

	weak = "Geschw\195\164cht",
	weak_desc = "Warnt wenn Terestian geschw\195\164cht ist",
	weak_trigger = "von Mal der Flamme betroffen",
	weak_message = "Geschw\195\164cht f\195\188r 45 Sek!",
	weak_warning1 = "Geschw\195\164cht vorbei in 5 Sek!",
	weak_warning2 = "Geschw\195\164cht vorbei!",
	weak_bar = "Geschw\195\164cht",
	--weak_fade = "^Broken Pact fades",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Ah, vous arrivez juste à temps.",

	sacrifice = "Sacrifice",
	sacrifice_desc = "Préviens quand un joueur est sacrifié.",
	sacrifice_trigger = "^(%S+) (%S+) les effets .* Sacrifice%.$",
	sacrifice_fade = "^Sacrifice sur ([^%s]+) vient de se dissiper%.$",
	sacrifice_message = "%s est sacrifié !",
	sacrifice_bar = "Sacrifice : %s",
	sacrifice_soon = "Sacrifice imminent !",
	sacrifice_soonbar = "~Sacrifice probable",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le joueur sacrifié (nécessite d'être promu ou mieux).",

	weak = "Affaibli",
	weak_desc = "Préviens quand Terestian est affaibli.",
	weak_trigger = "les effets .* Pacte rompu%.$",
	weak_message = "Affaibli pendant ~45 sec. !",
	weak_warning1 = "Fin de l'Affaiblissement dans ~5 sec. !",
	weak_warning2 = "Affaiblissement terminé !",
	weak_bar = "~Fin Affaiblissement",
	weak_fade = "^Pacte rompu sur Terestian Malsabot vient de se dissiper%.$",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^아, 때맞춰 와줬군.",

	sacrifice = "희생",
	sacrifice_desc = "플레이어의 희생에 대한 경고입니다.",
	sacrifice_trigger = "^([^|;%s]*)(.*)희생에 걸렸습니다%.$",
	sacrifice_fade = "^([^%s]+)의 몸에서 희생 효과가 사라졌습니다%.$",
	sacrifice_message = "%s님이 희생되었습니다!",
	sacrifice_bar = "희생: %s",
	sacrifice_soon = "잠시후 희생!",
	sacrifice_soonbar = "~희생 대기시간",

	icon = "전술 표시",
	icon_desc = "희생에 걸린 플레이어에게 전술 표시를 지정합니다 (승급자 이상 요구).",

	weak = "약화",
	weak_desc = "약화 상태에 대한 경고입니다.",
	weak_trigger = "깨진 서약에 걸렸습니다%.$",
	weak_message = "약 45초간 약화!",
	weak_warning1 = "약 5초 후 약화 종료!",
	weak_warning2 = "약화 종료!",
	weak_bar = "~약화 사라짐",
	weak_fade = "깨진 서약 효과가 사라졌습니다.", -- check
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "^啊，你们来的正是时候。仪式就要开始了！",

	sacrifice = "牺牲",
	sacrifice_desc = "当玩家受到牺牲时发出警报",
	sacrifice_trigger = "^(%S+)受(%S+)了牺牲效果的影响。$",
	sacrifice_fade = "^牺牲效果从%s身上消失。$",
	sacrifice_message = "%s 牺牲了 -- 注意停手!",
	sacrifice_bar = "牺牲: %s",
	sacrifice_soon = "即将 牺牲!",
	sacrifice_soonbar = "~可能 牺牲",

	icon = "团队标记",
	icon_desc = "受到牺牲效果的队友打上标记(需要助理或更高权利).",

	weak = "虚弱",
	weak_desc = "虚弱阶段发出警报",
	weak_trigger = "受到了破碎契约效果的影响。$",
	weak_message = "进入虚弱状态! ~45秒!",
	weak_warning1 = "~5秒后 虚弱状态结束!",
	weak_warning2 = "虚弱结束!",
	weak_bar = "~虚弱",
	weak_fade = "^破碎契约效果从",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "啊，你來的正好。儀式正要開始!",

	sacrifice = "犧牲警告",
	sacrifice_desc = "當有玩家被犧牲時發送警告",
	sacrifice_trigger = "^(.+)受(到[了]*)犧牲效果的影響。$",
	sacrifice_fade = "^犧牲效果從%s身上消失。$",
	sacrifice_message = "%s 犧牲了 - 注意停手及治療",
	sacrifice_bar = "犧牲：[%s]",
	sacrifice_soon = "即將施放犧牲!",
	sacrifice_soonbar = "~可能施放犧牲",

	icon = "團隊標記",
	icon_desc = "為犧牲的玩家設置標記（需要權限）",

	weak = "虛弱提示",
	weak_desc = "當泰瑞斯提安進入虛弱狀態時發送警告",
	weak_trigger = "受到破碎契印效果的影響。",
	weak_message = "進入虛弱狀態 45 秒！",
	weak_warning1 = "虛弱狀態 5 秒後結束！",
	weak_warning2 = "虛弱狀態結束！",
	weak_bar = "虛弱",
	weak_fade = "破碎契印效果從",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "Ah, justo a tiempo. Los rituales están a punto de empezar.",

	sacrifice = "Sacrificio",
	sacrifice_desc = "Avisa del Sacrificio de los jugadores.",
	sacrifice_trigger = "^([^%s]+) ([^%s]+) sufre Sacrificio%.$",
	--sacrifice_fade = "^Sacrifice fades from ([^%s]+)%.$",
	sacrifice_message = "%s esta siendo sacrificado!",
	sacrifice_bar = "Sacrificio: %s",
	--sacrifice_soon = "Sacrifice soon!",
	--sacrifice_soonbar = "~Possible Sacrifice",

	icon = "Icono de Raid",
	icon_desc = "Pone un icono de raid en el jugador sacrificado (requiere promoted o mayor).",

	weak = "Debilitado",
	weak_desc = "Avisa de estado de debilidad.",
	weak_trigger = "sufre Pacto roto.",
	weak_message = "Debilitado por ~45sec!",
	weak_warning1 = "Debilitado finaliza en ~5sec!",
	weak_warning2 = "Debilidad finalizado!",
	weak_bar = "~Debilidad desaparece",
	weak_fade = "^Pacto roto desaparece",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"weak", "enrage", -1, "sacrifice", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "AuraGone")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "AuraGone")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckSacrifice")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg:find(L["engage_trigger"]) then
		self:Message(fmt(L2["enrage_start"], boss, 10), "Attention")
		self:DelayedMessage(300, fmt(L2["enrage_min"], 5), "Positive")
		self:DelayedMessage(420, fmt(L2["enrage_min"], 3), "Positive")
		self:DelayedMessage(540, fmt(L2["enrage_min"], 1), "Positive")
		self:DelayedMessage(570, fmt(L2["enrage_sec"], 30), "Positive")
		self:DelayedMessage(590, fmt(L2["enrage_sec"], 10), "Urgent")
		self:DelayedMessage(600, fmt(L2["enrage_end"], boss), "Attention", nil, "Alarm")
		self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CheckSacrifice(msg)
	if not self.db.profile.sacrifice then return end
	local splayer, stype = select(3, msg:find(L["sacrifice_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = pName
		end
		self:Message(fmt(L["sacrifice_message"], splayer), "Attention")
		self:Bar(fmt(L["sacrifice_bar"], splayer), 30, "Spell_Shadow_AntiMagicShell")
		if self.db.profile.icon then
			self:Icon(splayer)
		end
		self:ScheduleEvent("sac1", "BigWigs_Message", 40, L["sacrifice_soon"], "Positive")
		self:Bar(L["sacrifice_soonbar"], 42, "Spell_Shadow_Cripple")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if self.db.profile.weak and msg:find(L["weak_trigger"]) then
		self:Message(L["weak_message"], "Important", nil, "Alarm")
		self:ScheduleEvent("weak1", "BigWigs_Message", 40, L["weak_warning1"], "Attention")
		self:Bar(L["weak_bar"], 45, "Spell_Shadow_Cripple")
	end
end

function mod:AuraGone(msg)
	if self.db.profile.weak and msg:find(L["weak_fade"]) then
		self:Message(L["weak_warning2"], "Attention", nil, "Info")
		self:CancelScheduledEvent("weak1")
		self:TriggerEvent("BigWigs_StopBar", self, L["weak_bar"])
	end

	if self.db.profile.sacrifice then
		local sfade = select(3, msg:find(L["sacrifice_fade"]))
		if sfade then
			self:TriggerEvent("BigWigs_StopBar", self, fmt(L["sacrifice_bar"], sfade))
			self:TriggerEvent("BigWigs_RemoveRaidIcon")
		end
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if self.db.profile.sacrifice and msg:find(L["sacrifice_fade"]) then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["sacrifice_bar"], pName))
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end
