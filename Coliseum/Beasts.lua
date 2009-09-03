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
local jormungars = BB["Jormungars"]

mod.zonename = BZ["Trial of the Crusader"]
mod.enabletrigger = {gormok, icehowl, acidmaw, dreadscale}
--mod.guid = 34796 -- Gormok
--mod.guid = 34799--Dreadscale, 35144 = Acidmaw
mod.guid = 34797 -- Icehowl
mod.toggleOptions = {"snobold", 67477, 67472, 67641, "spew", 67618, 66869, 68335, "proximity", 67654, "charge", 66758, 66759, "bosskill"}
mod.optionHeaders = {
	snobold = gormok,
	[67641] = jormungars,
	[67654] = icehowl,
	bosskill = CL.general,
}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.proximitySilent = true
mod.consoleCmd = "Beasts"

--------------------------------------------------------------------------------
-- Locals
--

local difficulty = nil
local db = nil
local pName = UnitName("player")
local burn = mod:NewTargetList()
local toxin = mod:NewTargetList()
local snobolledWarned = {}
local snobolled = GetSpellInfo(66406)

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
	snobold = "Snobold",
	snobold_desc = "Warn who gets a Snobold on their heads.",
	snobold_message = "Add on %s!",
	impale_message = "%2$dx Impale on %1$s",
	firebomb_message = "Fire on YOU!",

	-- Jormungars
	spew = "Acidic/Molten Spew",
	spew_desc = "Warn for Acidic/Molten Spew.",

	slime_message = "Slime on YOU!",
	burn_spell = "Burn",
	toxin_spell = "Toxin",

	-- Icehowl
	butt_bar = "~Butt Cooldown",
	charge = "Furious Charge",
	charge_desc = "Warn about Furious Charge on players.",
	charge_trigger = "glares at",	--check
} end)
L:RegisterTranslations("koKR", function() return {
	engage_trigger = "폭풍우 봉우리의 가장 깊고 어두운 동굴에서 온, 꿰뚫는 자 고르목일세! 영웅들이여, 전투에 임하게!",
	jormungars_trigger = "마음을 굳게 하게, 영웅들이여. 두 배의 공포, 산성아귀와 공포비늘이 투기장으로 들어온다네!",
	icehowl_trigger = "소개하는 순간 공기마저 얼어붙게 하는 얼음울음이 다음 상대일세! 죽거나 죽이거나, 선택하게 용사들이여!",
	boss_incoming = "%s 곧 등장",

	-- Gormok
	snobold = "스노볼트",
	snobold_desc = "스노볼트가 누구의 머리위에 있는지를 알립니다.",
	snobold_message = "스노볼트: %s!",
	impale_message = "꿰뚫기 x%2$d: %1$s",
	firebomb_message = "당신은 불 폭탄!",

	-- Jormungars
	spew = "산성/용암 내뿜기",
	spew_desc = "산성/용암 내뿜기를 알립니다.",
	
	slime_message = "당신은 진흙 웅덩이!",
	burn_spell = "불타는 담즙",
	toxin_spell = "마비 독",

	-- Icehowl
	butt_bar = "~박치기 대기시간",
	charge = "사나운 돌진",
	charge_desc = "사나운 돌진의 대상 플레이어를 알립니다.",
	charge_trigger = "([^%s]+)|1을;를; 노려보며 큰 소리로 울부짖습니다.$",
} end)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Arrivant tout droit des plus noires et profondes cavernes des pics Foudroyés, Gormok l'Empaleur !",
	jormungars_trigger = "Apprêtez-vous, héros, car voici que les terreurs jumelles, Gueule-d'acide et Écaille-d'effroi, pénètrent dans l'arène !",
	icehowl_trigger = "L'air se gèle à l'entrée de notre prochain combattant, Glace-hurlante ! Tuez ou soyez tués, champions !",
	boss_incoming = "Arrivée de %s",

	-- Gormok
	snobold = "Frigbold",
	snobold_desc = "Prévient quand un joueur a un frigbold sur sa tête.",
	snobold_message = "Frigbold sur %s !",
	impale_message = "%2$dx Empaler sur %1$s",
	firebomb_message = "Bombe incendiaire en dessous de VOUS !",

	-- Jormungars
	spew = "Crachement acide/de lave",
	spew_desc = "Prévient de l'arrivée des Crachements acides/de lave.",

	slime_message = "Bave sur VOUS !",
	burn_spell = "Bile",
	toxin_spell = "Toxine",

	-- Icehowl
	butt_bar = "~Recharge Coup de tête",
	charge = "Charge furieuse",
	charge_desc = "Prévient quand un joueur subit les effets d'une Charge furieuse.",
	charge_trigger = "lâche un rugissement assourdissant !$",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Er kommt aus den tiefsten, dunkelsten Höhlen der Sturmgipfel - Gormok der Pfähler! Voran, Helden!",
	jormungars_trigger = "Stählt Euch, Helden, denn die Zwillingsschrecken Ätzschlund und Schreckensmaul erscheinen in der Arena!",
	icehowl_trigger = "Mit der Ankündigung unseres nächsten Kämpfers gefriert die Luft selbst: Eisheuler! Tötet oder werdet getötet, Champions!",
	boss_incoming = "%s kommt",

	-- Gormok
	snobold = "Schneebold",
	snobold_desc = "Warnt davor, wer einen Schneebold auf seinem Kopf hat.",
	snobold_message = "Schneebold: %s!",
	impale_message = "%2$dx Pfählen: %1$s!",
	firebomb_message = "Feuerbombe auf DIR!",

	-- Jormungars
	spew = "Ätzender/Geschmolzener Auswurf",
	spew_desc = "Warnt vor Ätzender/Geschmolzener Auswurf.",

	slime_message = "Schleimpfütze auf DIR!",
	burn_spell = "Galle",
	toxin_spell = "Toxin",

	-- Icehowl
	butt_bar = "~Kopfstoß",
	charge = "Wütender Ansturm",
	charge_desc = "Warnt vor Wütender Ansturm auf Spielern.",
	charge_trigger = "^zornig an und lässt einen gewaltigen Schrei ertönen!",
} end)
L:RegisterTranslations("zhCN", function() return {
	--engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	--jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	--icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "即将%s！",

	-- Gormok
	snobold = "Snobold",
	snobold_desc = "当玩家头上出现Snobold时发出警报。",
	snobold_message = "Snobold：>%s<！",
	impale_message = "%2$dx Impale：>%1$s<！",
	firebomb_message = ">你< Fire Bomb！",

	-- Jormungars
	spew = "Acidic/Molten Spew",
	spew_desc = "当施放Acidic/Molten Spew时发出警报。",

	slime_message = ">你< Slime pool！",
	burn_spell = "Burning Bile",
	toxin_spell = "Paralytic Toxin",

	-- Icehowl
	butt_bar = "<Ferocious Butt 冷却>",
	charge = "野性冲锋",
	charge_desc = "当玩家中了野性冲锋时发出警报。",

--	charge_trigger = "^%%s",	--check
} end)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "來自風暴群山最深邃，最黑暗的洞穴。歡迎『穿刺者』戈莫克!戰鬥吧，英雄們!",
	jormungars_trigger = "準備面對酸喉和懼鱗的雙重夢魘吧，英雄們，快就定位!",
	icehowl_trigger = "下一場參賽者的出場連空氣都會為之凝結:冰嚎!戰個你死我活吧，勇士們! ",
	boss_incoming = "即將%s！",

	-- Gormok
	snobold = "極地狗頭人奴僕",
	snobold_desc = "當玩家頭上出現極地狗頭人奴僕時發出警報。",
	snobold_message = "極地狗頭人奴僕：>%s<！",
	impale_message = "%2$dx 刺穿：>%1$s<！",
	firebomb_message = ">你< 燃燒彈！",

	-- Jormungars
	spew = "酸液/熔火噴灑",
	spew_desc = "當施放酸液/熔火噴灑時發出警報。",

	slime_message = ">你< 泥漿池！",
	burn_spell = "燃燒膽汁",
	toxin_spell = "痲痺劇毒",

	-- Icehowl
	butt_bar = "<兇猛頭擊 冷卻>",
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
	firebomb_message = "Огненная бомба на ВАС!",

	-- Jormungars
	spew = "Кислотная/Жгучая рвота",
	spew_desc = "Сообщать о Кислотной/Жгучей рвоте.",

	-- Icehowl
	butt_bar = "~Свирепое бодание",

	--Furious Charge - судя по транскриптору нет русского перевода :(
	charge = "Furious Charge",
	charge_desc = "Сообщать о Furious Charge.",
	--charge_trigger = "^%%s",	--check
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	-- Gormok
	self:AddCombatListener("SPELL_DAMAGE", "FireBomb", 67472, 66317, 67475)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Impale", 67477, 66331, 67478, 67479)
	--self:AddCombatListener("SPELL_CAST_START", "Stomp", 67647, 67648, 66330, 67649)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_AURA")

	-- Jormungars
	self:AddCombatListener("SPELL_CAST_SUCCESS", "SlimeCast", 67641, 67642, 67643)
	self:AddCombatListener("SPELL_DAMAGE", "Slime", 67640)
	self:AddCombatListener("SPELL_CAST_START", "Acidic", 66818)
	self:AddCombatListener("SPELL_CAST_START", "Molten", 66821)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Toxin", 67618, 67619, 67620, 66823)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Burn", 66869, 66870)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BurnRemoved", 66869, 66870)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 68335)

	-- Icehowl
	self:AddCombatListener("SPELL_AURA_APPLIED", "Rage", 66759, 67658)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Daze", 66758)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Butt", 67654, 67655, 66770)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- Common
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
	difficulty = GetRaidDifficulty()
	wipe(snobolledWarned)
end

--------------------------------------------------------------------------------
-- Gormok the Impaler
--

function mod:UNIT_AURA(unit)
	local name, _, icon = UnitDebuff(unit, snobolled)
	local n = UnitName(unit)
	if snobolledWarned[n] and not name then
		snobolledWarned[n] = nil
	elseif name and not snobolledWarned[n] then
		self:IfMessage(L["snobold_message"]:format(n), "Attention", icon)
		snobolledWarned[n] = true
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		self:TriggerEvent("BigWigs_HideProximity", self)
		if difficulty > 2 then
			self:Bar(L["boss_incoming"]:format(jormungars), 180, "INV_Misc_MonsterScales_18")
		elseif db.berserk then
			self:Enrage(900, true, true)
		end
	elseif msg == L["jormungars_trigger"] then
		local m = L["boss_incoming"]:format(BB["Jormungars"])
		self:IfMessage(m, "Positive")
		self:Bar(m, 15, "INV_Misc_MonsterScales_18")
		if difficulty > 2 then
			self:Bar(L["boss_incoming"]:format(icehowl), 195, "INV_Misc_MonsterHorn_07")
		end
	elseif msg == L["icehowl_trigger"] then
		local m = L["boss_incoming"]:format(icehowl)
		self:IfMessage(m, "Positive")
		self:Bar(m, 10, "INV_Misc_MonsterHorn_07")
		if difficulty > 2 then
			self:Bar(CL.berserk, 190)
		end
	end
end

function mod:Impale(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 1 then
		self:TargetMessage(L["impale_message"], player, "Urgent", icon, "Info", stack)
	end
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

do
	local dontWarn = nil
	
	local function toxinWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(L["toxin_spell"], toxin, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(toxin)
		end
	end
	function mod:Toxin(player, spellId)
		toxin[#toxin + 1] = player
		self:ScheduleEvent("BWtoxinWarn", toxinWarn, 0.2, spellId)
		if player == pName then
			dontWarn = true
			self:TargetMessage(L["toxin_spell"], player, "Personal", spellId, "Info")
		end
	end
end

do
	local dontWarn = nil

	local function burnWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(L["burn_spell"], burn, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(burn)
		end
	end
	function mod:Burn(player, spellId)
		burn[#burn + 1] = player
		self:ScheduleEvent("BWburnWarn", burnWarn, 0.2, spellId)
		if player == pName then
			dontWarn = true
			self:TriggerEvent("BigWigs_ShowProximity", self)
			self:TargetMessage(L["burn_spell"], player, "Important", spellId, "Info")
		end
	end
end

function mod:BurnRemoved(player)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

function mod:Enraged(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId, "Long")
end

do
	local last = nil
	function mod:Slime(player, spellId)
		if player == pName then
			if not last or (t > last + 4) then
				self:LocalMessage(L["slime_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
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

