------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Anetheron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local db = nil

local UnitName = UnitName
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Anetheron",

	engage_trigger = "You are defenders of a doomed world! Flee here, and perhaps you will prolong your pathetic lives!",

	inferno = "Inferno",
	inferno_desc = "Approximate Inferno cooldown timers.",
	inferno_message = "Casting Inferno on %s!",
	inferno_you = "Casting Inferno on you!",
	inferno_warning = "Inferno Soon!",
	inferno_bar = "~Inferno Cooldown",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player that Inferno is being cast on(requires promoted or higher).",

	swarm = "Carrion Swarm",
	swarm_desc = "Approximate Carrion Swarm cooldown timers.",
	swarm_trigger1 = "Pestilence upon you!",
	swarm_trigger2 = "The swarm is eager to feed.",
	swarm_message = "Swarm! - Next in ~11sec",
	swarm_bar = "~Swarm Cooldown",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous défendez un monde condamné ! Fuyez si vous voulez avoir une chance de faire durer vos vies pathétiques !",

	inferno = "Inferno",
	inferno_desc = "Temps de recharge approximatif pour l'Inferno.",
	inferno_message = "Incante un inferno sur %s !",
	inferno_warning = "Inferno imminent !",
	inferno_bar = "~Cooldown Inferno",

	swarm = "Vol de charognards",
	swarm_desc = "Temps de recharge approximatif pour le Vol de charognards.",
	swarm_trigger1 = "La peste soit sur vous !",
	swarm_trigger2 = "L'essaim est affamé.",
	swarm_message = "Essaim ! - Prochain dans ~11 sec.",
	swarm_bar = "~Cooldown Essaim",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "멸망에 처한 세계의 수호자들이여, 구차한 목숨이라도 건지려면 어서 달아나라!",

	inferno = "불지옥",
	inferno_desc = "대략적인 불지옥 대기시간 타이머입니다.",
	inferno_message = "%s에 불지옥 시전 중!",
	inferno_warning = "잠시 후 불지옥!",
	inferno_bar = "~불지옥 대기시간",

	icon = "전술 표시",
	icon_desc = "불지옥의 시전 대상의 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 요구).",

	swarm = "흡혈박쥐 떼",
	swarm_desc = "대략적인 흡혈박쥐 떼 대기시간 타이머입니다.",
	swarm_trigger1 = "역병에 뒤덮이리라!",
	swarm_trigger2 = "박쥐들이 많이 굶주렸구나.",
	swarm_message = "박쥐 떼! - 다음은 약 11초 이내",
	swarm_bar = "~박쥐 떼 대기시간",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ihr verteidigt eine verlorene Welt! Flieht! Vielleicht verlängert dies Euer erbärmliches Leben!",

	inferno = "Inferno",
	inferno_desc = "Geschätzter Inferno Cooldown Timer.",
	inferno_message = "zaubert Inferno auf %s!",
	inferno_warning = "Inferno bald!",
	inferno_bar = "~Inferno Cooldown",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziere ein Schlachtzug Symbol auf Spielern die von Inferno betroffen sind (benötigt Assistent oder höher).",

	swarm = "Aasschwarm",
	swarm_desc = "Geschätzter Aasschwarm Cooldown Timer.",
	swarm_trigger1 = "Möge die Pest über Euch kommen!",
	swarm_trigger2 = "Der Schwarm ist hungrig!",
	swarm_message = "Aasschwarm! - Nächster in ~11sec",
	swarm_bar = "~Aasschwarm Cooldown",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你們要守護的世界躲不了毀滅的命運!逃離這兒，也許可以延長你們那可悲的生命!",

	inferno = "地獄火",
	inferno_desc = "地獄火冷卻計時器",
	inferno_message = "地獄火: %s!",
	inferno_warning = "地獄火即將到來!",
	inferno_bar = "~地獄火 Cooldown",

	icon = "團隊標記",
	icon_desc = "在受到地獄火的隊友頭上標記 (需要權限)",

	swarm = "腐肉成群",
	swarm_desc = "腐肉成群冷卻計時器",
	swarm_trigger1 = "願瘟疫降臨在你身上!",
	swarm_trigger2 = "蟲群們渴望進食",
	swarm_message = "腐肉成群! - 11 秒後下一次",
	swarm_bar = "~腐肉成群冷卻",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "你们在守护一个注定要毁灭的世界！逃跑吧，那样也许你们还能多活几天！",

	inferno = "地狱火",
	inferno_desc = "显示地狱火冷却记时条",
	inferno_message = "正在施放 地狱火 >%s<!",
	inferno_warning = "即将 地狱火!",
	inferno_bar = "~地狱火 冷却",

	icon = "团队标记",
	icon_desc = "为在玩家上施放地狱火的玩家打上团队标记(需要权限).",

	swarm = "腐臭虫群",
	swarm_desc = "腐臭虫群冷却计时",
	swarm_trigger1 = "瘟疫降临！$",
	swarm_trigger2 = "虫群将吞噬你们的躯体。$",
	swarm_message = "虫群! - 下一波 ~11秒后",
	swarm_bar = "~虫群 冷却",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"inferno", "icon", "swarm", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_SPELLCAST_START")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AnethInf", 10)
	db = self.db.profile
	local pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync)
	if sync == "AnethInf" and db.inferno then
		self:DelayedMessage(45, L["inferno_warning"], "Positive")
		self:Bar(L["inferno_bar"], 50, "Spell_Fire_Incinerate")
		self:ScheduleEvent("BWInfernoToTScan", self.InfernoCheck, 0.5, self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if db.swarm and (msg == L["swarm_trigger1"] or msg == L["swarm_trigger2"]) then
		self:Message(L["swarm_message"], "Attention")
		self:Bar(L["swarm_bar"], 11, "Spell_Shadow_CarrionSwarm")
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["inferno"] then
		self:Sync("AnethInf")
	end
end

function mod:InfernoCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		if target == pName then
			self:Message(L["inferno_you"], "Personal", true, "Long")
			self:TriggerEvent("BigWigs_Personal")
		else
			self:Message(fmt(L["inferno_message"], target), "Important", nil, "Alert")
		end
		if db.icon then
			self:Icon(target)
			self:ScheduleEvent("ClearIcon", "BigWigs_RemoveRaidIcon", 5, self)
		end
	end
end
