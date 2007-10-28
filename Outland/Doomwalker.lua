------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doomwalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local enrageAnnounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Doomwalker",

	engage_trigger = "Do not proceed. You will be eliminated.",
	engage_message = "Doomwalker engaged, Earthquake in ~30sec!",

	overrun = "Overrun",
	overrun_desc = "Alert when Doomwalker uses his Overrun ability.",
	overrun_trigger1 = "Engage maximum speed.",
	overrun_trigger2 = "Trajectory locked.",
	overrun_message = "Overrun!",
	overrun_soon_message = "Possible Overrun soon!",
	overrun_bar = "~Overrun Cooldown",

	earthquake = "Earthquake",
	earthquake_desc = "Alert when Doomwalker uses his Earthquake ability.",
	earthquake_message = "Earthquake! ~70sec to next!",
	earthquake_bar = "~Earthquake Cooldown",
	earthquake_trigger1 = "Tectonic disruption commencing.",
	earthquake_trigger2 = "Magnitude set. Release.",

	enrage_soon_message = "Enrage soon!",
	enrage_trigger = "%s becomes enraged!",
	enrage_message = "Enrage!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Cessez toute activité. Vous allez être éliminés.",
	engage_message = "Marche-funeste engagé, Séisme dans ~30 sec. !",

	overrun = "Renversement",
	overrun_desc = "Préviens quand Marche-funeste utilise sa capacité Renversement.",
	overrun_trigger1 = "Vitesse maximale enclenchée.",
	overrun_trigger2 = "Trajectoire verrouillée.",
	overrun_message = "Renversement !",
	overrun_soon_message = "Renversement imminent !",
	overrun_bar = "~Cooldown Renversement",

	earthquake = "Séisme",
	earthquake_desc = "Préviens quand Marche-funeste utilise sa capacité Séisme.",
	earthquake_message = "Séisme ! Prochain dans ~70 sec. !",
	earthquake_bar = "~Cooldown Séisme",
	earthquake_trigger1 = "Début de la perturbation tectonique.",
	earthquake_trigger2 = "Magnitude réglée. Déclenchement.",

	enrage_soon_message = "Enrager imminent !",
	enrage_trigger = "%s devient fou furieux !",
	enrage_message = "Enrager !",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "접근 금지. 너희는 제거될 것이다.",
	engage_message = "파멸의 절단기 전투 개시, 약 30초 이내 지진!",

	overrun = "괴멸",
	overrun_desc = "파멸의 절단기의 괴멸 사용 가능 시 경고합니다.",
	overrun_trigger1 = "전속력 추진.", -- check
	overrun_trigger2 = "경로 설정 완료.", -- check
	overrun_message = "괴멸!",
	overrun_soon_message = "잠시 후 괴멸 가능!",
	overrun_bar = "~괴멸 대기시간",

	earthquake = "지진",
	earthquake_desc = "파멸의 절단기의 지진 사용 가능 시 경고합니다.",
	earthquake_message = "지진! 다음은 약 70초 후!",
	earthquake_bar = "~지진 대기시간",
	earthquake_trigger1 = "지각 붕괴 실행 중...",
	earthquake_trigger2 = "진도 조정 완료. 방출!",

	enrage_soon_message = "잠시 후 격노!",
	enrage_trigger = "%s|1이;가; 분노에 휩싸입니다!", -- check
	enrage_message = "격노!",
} end)

L:RegisterTranslations("deDE", function() return {
	overrun = "\195\156berrennen",
	overrun_desc = "Warnt, wenn Verdammniswandler \195\156berrennen benutzt.",

	earthquake = "Erdbeben",
	earthquake_desc = "Warnt, wenn Verdammniswandler Erdbeben benutzt.",

	engage_message = "Verdammniswandler angegriffen, Erdbeben in ~30sec!",
	enrage_soon_message = "Wutanfall bald!",

	--earthquake_trigger1 = "",
	--earthquake_trigger2 = "",

	earthquake_message = "Erdbeben! ~70sec to next!",
	earthquake_bar = "~Erdbeben Cooldown",

	--overrun_trigger1 = "",
	--overrun_trigger2 = "",
	overrun_message = "\195\156berrennen!",
	overrun_soon_message = "M\195\182gliches \195\156berrennen bald!",
	overrun_bar = "~\195\156berrennen Cooldown",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "別在繼續下去。你將會被消除的。",
	engage_message = "與厄運行者進入戰鬥，30 秒後發動地震！",

	overrun = "超越",
	overrun_desc = "當厄運行者發動 超越 技能時發出警報",
	overrun_trigger1 = "啟用最大速度。",
	overrun_trigger2 = "軌道鎖定。",
	overrun_message = "發動超越！",
	overrun_soon_message = "即將發動超越！",
	overrun_bar = "超越冷卻",

	earthquake = "地震術",
	earthquake_desc = "當厄運行者發動地震術時發出警報",
	earthquake_message = "地震術！ 70 秒後再次發動！",
	earthquake_bar = "地震術 冷卻",
	earthquake_trigger1 = "構造瓦解開始。",
	earthquake_trigger2 = "強度設定。卸除。",

	enrage_soon_message = "即將狂怒！",
	enrage_trigger = "%s變得憤怒了!",
	enrage_message = "狂怒！",
} end)

--末日行者
L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "停止前进。否则你们将被消灭。",
	engage_message = "末日行者激活,30秒后发动地震术!",

	overrun = "泛滥",
	overrun_desc = "当末日行者使用泛滥技能时发出警报.",
	overrun_trigger1 = "提升至最高速度。",
	overrun_trigger2 = "轨道锁定。",
	overrun_message = "泛滥!",
	overrun_soon_message = "即将发动 泛滥!",
	overrun_bar = "~泛滥 冷却",

	earthquake = "地震术",
	earthquake_desc = "当末日行者施放地震术时发出警告.",
	earthquake_message = "地震术! ~70秒后再次发动!",
	earthquake_bar = "~地震术 冷却",
	earthquake_trigger1 = "地面破坏程序启动。",
	earthquake_trigger2 = "范围确认。释放。",

	enrage_soon_message = "即将狂怒!",
	enrage_trigger = "%s变得愤怒了！",
	enrage_message = "狂怒!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Shadowmoon Valley"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"overrun", "earthquake", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		enrageAnnounced = nil
		self:TriggerEvent("BigWigs_ShowProximity", self)
		if self.db.profile.earthquake then
			self:Message(L["engage_message"], "Attention")
			self:Bar(L["earthquake_bar"], 30, "Spell_Nature_Earthquake")
		end
		if self.db.profile.overrun then
			self:Bar(L["overrun_bar"], 26, "Ability_BullRush")
			self:DelayedMessage(24, L["overrun_soon_message"], "Attention")
		end
	elseif self.db.profile.overrun and (msg == L["overrun_trigger1"] or msg == L["overrun_trigger2"]) then
		self:Message(L["overrun_message"], "Important")
		self:Bar(L["overrun_bar"], 30, "Ability_BullRush")
		self:DelayedMessage(28, L["overrun_soon_message"], "Attention")
	elseif self.db.profile.earthquake and (msg == L["earthquake_trigger1"] or msg == L["earthquake_trigger2"]) then
		self:Message(L["earthquake_message"], "Important")
		self:Bar(L["earthquake_bar"], 70, "Spell_Nature_Earthquake")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important", nil, "Alarm")
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 20 and health <= 25 and not enrageAnnounced then
			self:Message(L["enrage_soon_message"], "Urgent")
			enrageAnnounced = true
		elseif health > 40 and enrageAnnounced then
			enrageAnnounced = false
		end
	end
end
