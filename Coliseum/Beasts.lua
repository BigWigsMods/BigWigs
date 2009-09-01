--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["The Beasts of Northrend"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end

local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
local gormok = BB["Gormok the Impaler"]
local icehowl = BB["Icehowl"]
local acidmaw = BB["Acidmaw"]
local dreadscale = BB["Dreadscale"]

mod.zonename = BZ["Trial of the Crusader"]
mod.enabletrigger = {gormok, icehowl, acidmaw, dreadscale}
--mod.guid = 34796 -- Gormok
--mod.guid = 34799--Dreadscale, 35144 = Acidmaw
mod.guid = 34797 -- Icehowl
mod.toggleOptions = {67647, 67477, 67472, 67641, "spew", 67618, 66869, 68335, "proximity", 67654, "charge", 66758, 66759, "bosskill"}
mod.optionHeaders = {
	[67647] = gormok,
	[67641] = BB["Jormungars"],
	[67654] = icehowl,
	bosskill = CL.general,
}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.proximitySilent = true
mod.consoleCmd = "Beasts"

--------------------------------------------------------------------------------
-- Locals
--
local db = nil
local pName = UnitName("player")
local burn = mod:NewTargetList()
local toxin = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "%s incoming",

	-- Gormok
	impale_message = "%2$dx Impale on %1$s",
	stomp_warning = "Stomp in 5sec!",
	stomp_bar = "Next Stomp",
	firebomb_message = "Fire Bomb on you!",

	-- Jormungars
	spew = "Acidic/Molten Spew",
	spew_desc = "Warn for Acidic/Molten Spew.",
	burn_you = "Burning Bile on you!",
	burn_other = "Burning Bile: %s",

	-- Icehowl
	butt_bar = "~Butt Cooldown",
	charge = "Furious Charge",
	charge_desc = "Warn about Furious Charge on players.",
	charge_trigger = "^%%s",	--check
} end)
L:RegisterTranslations("koKR", function() return {
	engage_trigger = "폭풍우 봉우리의 가장 깊고 어두운 동굴에서 온, 꿰뚫는 자 고르목일세! 영웅들이여, 전투에 임하게!",
	jormungars_trigger = "마음을 단단히 먹게. 영웅들이여. 두 배의 공포, 산성아귀와 공포비늘이 투기장으로 들어온다네!",
	icehowl_trigger = "다음은, 소개하는 순간 공기마저 얼어붙게 하는 얼음울음일세! 죽이지 않으면 죽을 걸세, 용사들이여!",
	boss_incoming = "%s 가 곧 등장합니다!- 준비하십시오!",

	-- Gormok
	impale_message = "꿰뚫기 x%2$d: %1$s",
	stomp_warning = "5초 후 발구르기!",
	stomp_bar = "~다음 발구르기",
	firebomb_message = "당신은 불 폭탄!",

	-- Jormungars
	spew = "산성/용암 내뿜기",
	spew_desc = "산성/용암 내뿜기를 알립니다.",
	burn_you = "당신은 불타는 담즙!",
	burn_other = "불타는 담즙: %s",

	-- Icehowl
	butt_bar = "~박치기 대기시간",
	charge = "사나운 돌진",
	charge_desc = "사나운 돌진의 대상 플레이어를 알립니다.",
	charge_trigger = "([^%s]+)|1을;를; 노려보며 큰 소리로 울부짖습니다.$",
} end)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Arrivant tout droit des plus noires et profondes cavernes des pics Foudroyes, Gormok l'Empaleur?!",
	jormungars_trigger = "Appretez-vous, heros, car voici que les terreurs jumelles, Gueule-d'acide et Ecaille-d'effroi, penetrent dans l'arene?!",
	icehowl_trigger = "L'air se gele a l'entree de notre prochain combattant, Glace-hurlante?! Tuez ou soyez tues, champions?!",
	boss_incoming = "Arrivee de %s",

	-- Gormok
	impale_message = "%2$dx Empaler sur %1$s",
	stomp_warning = "Pietinement dans 5 sec.?!",
	stomp_bar = "Pietinement",
	firebomb_message = "Bombe incendiaire en dessous de VOUS?!",

	-- Jormungars
	spew = "Crachement acide/de lave",
	spew_desc = "Previent de l'arrivee des Crachements acides/de lave.",
	burn_you = "Bile brulante sur VOUS?!",
	burn_other = "Bile brulante?: %s",

	-- Icehowl
	butt_bar = "~Recharge Coup de tete",
	charge = "Charge furieuse",
	charge_desc = "Previent quand un joueur subit les effets d'une Charge furieuse.",
	charge_trigger = "lache un rugissement assourdissant?!$",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Er kommt aus den tiefsten, dunkelsten Hohlen der Sturmgipfel - Gormok der Pfahler! Voran, Helden!",
	jormungars_trigger = "Stahlt Euch, Helden, denn die Zwillingsschrecken Atzschlund und Schreckensmaul erscheinen in der Arena!",
	icehowl_trigger = "Mit der Ankundigung unseres nachsten Kampfers gefriert die Luft selbst: Eisheuler! Totet oder werdet getotet, Champions!",
	boss_incoming = "%s kommt",

	-- Gormok
	impale_message = "%2$dx Pfahlen: %1$s!",
	stomp_warning = "Stampfen in 5 sek!",
	stomp_bar = "~Stampfen",
	firebomb_message = "Feuerbombe auf DIR!",

	-- Jormungars
	spew = "Atzender/Geschmolzener Auswurf",
	spew_desc = "Warnt vor Atzender/Geschmolzener Auswurf.",
	burn_you = "Brennende Galle auf DIR!",
	burn_other = "Brennende Galle: %s!",

	-- Icehowl
	butt_bar = "~Kopfstoß",
	charge = "Wutender Ansturm",
	charge_desc = "Warnt vor Wutender Ansturm auf Spielern.",
	charge_trigger = "^%%s",	--check
} end)
L:RegisterTranslations("zhCN", function() return {
	--engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	--jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	--icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "??%s！",

	-- Gormok
	impale_message = "%2$dx Impale：>%1$s<！",
	stomp_warning = "5秒后，Staggering Stomp！",
	stomp_bar = "<下一Staggering Stomp>",
	firebomb_message = ">?< Fire Bomb！",

	-- Jormungars
	spew = "Acidic/Molten Spew",
	spew_desc = "?施放Acidic/Molten Spew??出警?。",
	burn_you = ">?< Burning Bile！",
	burn_other = "Burning Bile：>%s<！",

	-- Icehowl
	butt_bar = "<Ferocious Butt 冷却>",
	charge = "野性??",
	charge_desc = "?玩家中了野性????出警?。",
--	charge_trigger = "^%%s",	--check
} end)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "來自風暴群山最深邃，最黑暗的洞穴。歡迎『穿刺者』戈莫克!戰??，英雄們!",
	jormungars_trigger = "準備面對酸喉和懼鱗的雙重夢??，英雄們，快就定位!",
	--icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "?將%s！",

	-- Gormok
	impale_message = "%2$dx 刺穿：>%1$s<！",
	stomp_warning = "5秒後，驚恐踐踏！",
	stomp_bar = "<下一驚恐踐踏>",
	firebomb_message = ">?< 燃燒彈！",

	-- Jormungars
	spew = "酸液/熔火噴灑",
	spew_desc = "當施放酸液/熔火噴灑時發出警報。",
	burn_you = ">?< 燃燒膽汁！",
	burn_other = "燃燒膽汁：>%s<！",

	-- Icehowl
	butt_bar = "<兇猛頭擊 冷?>",
	charge = "狂烈衝鋒",
	charge_desc = "當玩家中了狂烈衝鋒時發出警報。",
--	charge_trigger = "^%%s",	--check
} end)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Из самых глубоких и темных пещер Грозовой Гряды был призван Гормок Пронзающий Бивень! В бой, герои!",
	jormungars_trigger = "Приготовьтесь к схватке с близнецами-чудовищами, Кислотной Утробой и Жуткой Чешуей!",
	icehowl_trigger = "В воздухе повеяло ледяным дыханием следующего бойца: на арену выходит Ледяной Рев! Сражайтесь или погибните, чемпионы!",
	boss_incoming = "На подходе %s",

	-- Gormok
	impale_message = "%2$dx Прокалывания на %1$s",
	stomp_warning = "Топот через 5 сек!",
	stomp_bar = "Следующий топот",
	firebomb_message = "Огненная бомба на ВАС!",

	-- Jormungars
	spew = "Кислотная/Жгучая рвота",
	spew_desc = "Сообщать о Кислотной/Жгучей рвоте.",
	burn_you = "Горящая желчь на ВАС!",
	burn_other = "Горящая желчь: %s",

	-- Icehowl
	butt_bar = "~Свирепое бодание",

	--Furious Charge - судя по транскриптору нет русского перевода :(
	charge = "Furious Charge",
	charge_desc = "Сообщать о Furious Charge.",
	charge_trigger = "^%%s",	--check
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	-- Gormok
	self:AddCombatListener("SPELL_DAMAGE", "FireBomb", 67472, 66317)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Impale", 67477, 66331)
	self:AddCombatListener("SPELL_CAST_START", "Stomp", 67647, 66330)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	-- Jormungars
	self:AddCombatListener("SPELL_CAST_SUCCESS", "SlimeCast", 67641)
	--self:AddCombatListener("SPELL_DAMAGE", "Slime", 67638)
	self:AddCombatListener("SPELL_CAST_START", "Acidic", 66818)
	self:AddCombatListener("SPELL_CAST_START", "Molten", 66821)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Toxin", 67618, 66823)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Burn", 66869, 66870)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BurnRemoved", 66869, 66870)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 68335)

	-- Icehowl
	self:AddCombatListener("SPELL_AURA_APPLIED", "Rage", 66759)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Daze", 66758)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Butt", 67654, 66770)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- Common
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Gormok the Impaler
--

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		self:TriggerEvent("BigWigs_HideProximity", self)
		if db.berserk then
			self:Enrage(900, true, true)
		end
	elseif msg == L["jormungars_trigger"] then
		local m = L["boss_incoming"]:format(BB["Jormungars"])
		self:IfMessage(m, "Positive")
		self:Bar(m, 15, "INV_Misc_MonsterScales_18")
	elseif msg == L["icehowl_trigger"] then
		local m = L["boss_incoming"]:format(icehowl)
		self:IfMessage(m, "Positive")
		self:Bar(m, 10, "INV_Misc_MonsterHorn_07")
	end
end

function mod:Impale(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 1 then
		self:TargetMessage(L["impale_message"], player, "Urgent", icon, "Info", stack)
	end
end

function mod:Stomp(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId, "Long")
	self:Bar(L["stomp_bar"], 21, spellId)
	self:DelayedMessage(16, L["stomp_warning"], "Attention")
end

do
	local last = nil
	function mod:FireBomb(player, spellId)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["firebomb_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Jormungars
--

function mod:SlimeCast(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
end

function mod:Molten(_, spellId, _, _, spellName)
	if db.spew then
		self:IfMessage(spellName, "Attention", spellId)
	end
end

function mod:Acidic(_, spellId, _, _, spellName)
	if db.spew then
		self:IfMessage(spellName, "Attention", spellId)
	end
end

local function toxinWarn(spellId, spellName)
	mod:TargetMessage(spellName, toxin, "Urgent", spellId, "Alert")
end

function mod:Toxin(player, spellId, _, _, spellName)
	toxin[#toxin + 1] = player
	self:ScheduleEvent("BWtoxinWarn", toxinWarn, 0.2, spellId, spellName)
	if player == pName then
		self:TargetMessage(spellName, player, "Personal", spellId, "Info")
	end
end

local function burnWarn(spellId, spellName)
	mod:TargetMessage(spellName, burn, "Urgent", spellId, "Alert")
end

function mod:Burn(player, spellId, _, _, spellName)
	burn[#burn + 1] = player
	self:ScheduleEvent("BWburnWarn", burnWarn, 0.2, spellId, spellName)
	if player == pName then
		self:TriggerEvent("BigWigs_ShowProximity", self)
		self:TargetMessage(spellName, player, "Important", spellId, "Info")
	end
end

function mod:BurnRemoved(player, spellId)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

function mod:Enraged(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId, "Long")
end

--------------------------------------------------------------------------------
-- Icehowl
--

function mod:Rage(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:Daze(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Positive", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:Butt(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
	self:Bar(L["butt_bar"], 12, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(message, unit, _, _, player)
	if unit == icehowl and db.charge and message:find(L["charge_trigger"]) then
		local spellName = GetSpellInfo(52311)
		self:TargetMessage(spellName, player, "Personal", 52311, "Alarm")
		self:Bar(spellName..": "..player, 7, 52311)
	end
end

