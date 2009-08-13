--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["The Beasts of Northrend"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end

local gormok = BB["Gormok the Impaler"]
local icehowl = BB["Icehowl"]
local acidmaw = BB["Acidmaw"]
local dreadscale = BB["Dreadscale"]

mod.zonename = BZ["Trial of the Crusader"]
mod.enabletrigger = gormok
--mod.guid = 34796 -- Gormok
--mod.guid = 34799--Dreadscale, 35144 = Acidmaw
mod.guid = 34797 -- Icehowl
mod.toggleoptions = {"stomp", "impale", "firebomb", -1, "slime", "spew", "toxin", "burn", "enrage", "proximity", -1, "butt", "charge", "daze", "rage", "bosskill"}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.proximitySilent = true

--------------------------------------------------------------------------------
-- Locals
--
local db = nil
local pName = UnitName("player")
local impale = GetSpellInfo(67477)
local burn = mod:NewTargetList()
local toxin = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "NorthrendBeasts",

	engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "%s incoming",

	-- Gormok
	impale = "Impale",
	impale_desc = "Warn when someone has 2 or more stacks of Impale.",
	impale_message = "%2$dx Impale on %1$s",

	stomp = "Staggering Stomp",
	stomp_desc = "Warn when Gormok casts Staggering Stomp.",
	stomp_message = "Stomp!",
	stomp_warning = "Stomp in 5sec!",
	stomp_bar = "Next Stomp",

	firebomb = "Fire Bomb",
	firebomb_desc = "Warn when you are in a Fire Bomb.",
	firebomb_message = "Fire Bomb on you!",

	-- Jormungars
	spew = "Acidic/Molten Spew",
	spew_desc = "Warn for Acidic/Molten Spew.",
	acidic_message = "Acidic Spew!",
	molten_message = "Molten Spew!",

	toxin = "Paralytic Toxin",
	toxin_desc = "Warn who has Paralytic Toxin.",
	toxin_you = "Paralytic Toxin on you!",
	toxin_other = "Paralytic Toxin: %s",

	burn = "Burning Bile",
	burn_desc = "Warn who has Burning Bile.",
	burn_you = "Burning Bile on you!",
	burn_other = "Burning Bile: %s",

	slime = "Slime Pool",
	slime_desc = "Warn for Slime Pool.",
	--slime_message = "Slime Pool on you!",
	slime_warning = "Slime Pool!",

	enrage = "Enrage",
	enrage_desc = "Warn for Enrage.",
	enrage_message = "Enrage!",

	jormungars_dies = "%s dead",

	-- Icehowl
	butt = "Ferocious Butt",
	butt_desc = "Warn for Ferocious Butt.",
	butt_message = "Ferocious Butt: %s!",
	butt_bar = "~Butt Cooldown",

	charge = "Furious Charge",
	charge_desc = "Warn about Furious Charge on players.",
	charge_trigger = "^%%s",	--check
	charge_other = "Furious Charge: %s!",
	charge_you = "Furious Charge YOU!",
	charge_warning = "Trample soon",

	daze = "Staggered Daze",
	daze_desc = "Warn when Icehowl gains Staggered Daze.",
	daze_message = "Staggered Daze!",

	rage = "Frothing Rage",
	rage_desc = "Warn when Icehowl gains Frothing Rage.",
	rage_message = "Frothing Rage!",
} end)
L:RegisterTranslations("koKR", function() return {
	-- Gormok
	impale = "꿰뚫기",
	impale_desc = "꿰뚫기 중첩이 2이상이 된 플레이어를 알립니다.",
	impale_message = "꿰뚫기 x%2$d: %1$s",

	stomp = "진동의 발구르기",
	stomp_desc = "고르목의 진동의 발구르기 시전을 알립니다.",
	stomp_message = "발구르기!",
	stomp_warning = "5초 후 발구르기!",
	stomp_bar = "~다음 발구르기",

	firebomb = "불 폭탄",
	firebomb_desc = "자신이 불 폭탄에 걸렸을 때 알립니다.",
	firebomb_message = "당신은 불 폭탄!",

	-- Jormungars
	spew = "산성/용암 내뿜기",
	spew_desc = "산성/용암 내뿜기를 알립니다.",
	acidic_message = "산성 내뿜기!",
	molten_message = "용암 내뿜기!",

	toxin = "마비 독",
	toxin_desc = "마비독에 걸린 플레이어를 알립니다.",
	toxin_you = "당신은 마비 독!",
	toxin_other = "마비 독: %s",

	burn = "불타는 담즙",
	burn_desc = "불타는 담즙에 걸린 플레이어를 알립니다.",
	burn_you = "당신은 불타는 담즙!",
	burn_other = "불타는 담즙: %s",

	slime = "진흙 웅덩이",
	slime_desc = "진흙 웅덩이를 알립니다.",
	--slime_message = "당신은 진흙 웅덩이!",
	slime_warning = "진흙 웅덩이!",

	enrage = "격노",
	enrage_desc = "격노를 알립니다.",
	enrage_message = "격노!",

	jormungars_dies = "%s 죽음",

	-- Icehowl
	butt = "흉포한 박치기",
	butt_desc = "흉포한 박치기를 알립니다.",
	butt_message = "흉포한 박치기: %s!",
	butt_bar = "~박치기 대기시간",

	charge = "사나운 돌진",
	charge_desc = "사나운 돌진의 대상 플레이어를 알립니다.",
	charge_trigger = "([^%s]+)|1을;를; 노려보며 큰 소리로 울부짖습니다.$",
	charge_other = "사나운 돌진: %s!",
	charge_you = "당신에게 사나운 돌진!",
	charge_warning = "곧 밟아 뭉개기",

	daze = "진동으로 멍해짐",
	daze_desc = "얼음울음의 진동으로 멍해짐 상태를 알립니다.",
	daze_message = "멍해짐!",

	rage = "거품 이는 분노",
	rage_desc = "얼음울음의 거품 이는 분노 상태를 알립니다.",
	rage_message = "분노!",
} end)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Arrivant tout droit des plus noires et profondes cavernes des pics Foudroyés, Gormok l'Empaleur !",
	jormungars_trigger = "Apprêtez-vous, héros, car voici que les terreurs jumelles, Gueule-d'acide et Écaille-d'effroi, pénètrent dans l'arène !",
	icehowl_trigger = "L'air se gèle à l'entrée de notre prochain combattant, Glace-hurlante ! Tuez ou soyez tués, champions !",
	boss_incoming = "Arrivée |2 %s",

	-- Gormok
	impale = "Empaler",
	impale_desc = "Prévient quand quelqu'un a 2 cumuls ou plus d'Empaler.",
	impale_message = "%2$dx Empaler sur %1$s",

	stomp = "Piétinement ahurissant",
	stomp_desc = "Prévient quand Gormok incante un Piétinement ahurissant.",
	stomp_message = "Piétinement !",
	stomp_warning = "Piétinement dans 5 sec. !",
	stomp_bar = "Piétinement",

	firebomb = "Bombe incendiaire",
	firebomb_desc = "Prévient quand vous vous trouvez sur une Bombe incendiaire.",
	firebomb_message = "Bombe incendiaire en dessous de VOUS !",

	-- Jormungars
	spew = "Crachement acide/de lave",
	spew_desc = "Prévient de l'arrivée des Crachements acides/de lave.",
	acidic_message = "Crachement acide !",
	molten_message = "Crachement de lave !",

	toxin = "Toxine paralysante",
	toxin_desc = "Prévient quand un joueur subit les effets d'une Toxine paralysante.",
	toxin_you = "Toxine paralysante sur VOUS !",
	toxin_other = "Toxine paralysante : %s",

	burn = "Bile brûlante",
	burn_desc = "Prévient quand un joueur subit les effets d'une Bile brûlante.",
	burn_you = "Bile brûlante sur VOUS !",
	burn_other = "Bile brûlante : %s",

	slime = "Flaque de bave",
	slime_desc = "Prévient de l'arrivée des Flaques de bave.",
	--slime_message = "Flaque de bave sur VOUS !",
	slime_warning = "Flaque de bave !",

	enrage = "Enrager",
	enrage_desc = "Prévient quand un jormungar devient enragé.",
	enrage_message = "Enrager !",

	jormungars_dies = "%s éliminé",

	-- Icehowl
	butt = "Coup de tête féroce",
	butt_desc = "Prévient quand un joueur subit les effets d'un Coup de tête féroce.",
	butt_message = "Coup de tête féroce : %s",
	butt_bar = "~Recharge Coup de tête",

	charge = "Charge furieuse",
	charge_desc = "Prévient quand un joueur subit les effets d'une Charge furieuse.",
	charge_trigger = "lâche un rugissement assourdissant !$",
	charge_other = "Charge furieuse : %s",
	charge_you = "Charge furieuse sur VOUS !",
	charge_warning = "Piétiner imminent",

	daze = "Chancellement hébété",
	daze_desc = "Prévient quand Glace-hurlante gagne Chancellement hébété.",
	daze_message = "Chancellement hébété !",

	rage = "Rage écumeuse",
	rage_desc = "Prévient quand Glace-hurlante gagne Rage écumeuse.",
	rage_message = "Rage écumeuse !",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Er kommt aus den tiefsten, dunkelsten Höhlen der Sturmgipfel - Gormok der Pfähler! Voran, Helden!",
	jormungars_trigger = "Stählt Euch, Helden, denn die Zwillingsschrecken Ätzschlund und Schreckensmaul erscheinen in der Arena!",
	icehowl_trigger = "Mit der Ankündigung unseres nächsten Kämpfers gefriert die Luft selbst: Eisheuler! Tötet oder werdet getötet, Champions!",
	boss_incoming = "%s kommt",-- should we really translate that??
	
	-- Gormok
	impale = "Pfähler",
	impale_desc = "Warnt, wenn jemand 2 oder mehr Stapel von Pfählen hat.",
	impale_message = "%2$dx Pfählen auf %1$s",

	stomp = "Erschütterndes Stampfen",
	stomp_desc = "Warnt, wenn Gormok Erschütterndes Stampfen wirkt.",
	stomp_message = "Stampfen!",
	stomp_warning = "Stampfen in 5 sek!",
	stomp_bar = "Stampfen",

	firebomb = "Feuerbombe",
	firebomb_desc = "Warnt, wenn du in einer Feuerbombe stehst.",
	firebomb_message = "Feuerbombe auf DIR!",

	-- Jormungars
	spew = "Ätzender/Geschmolzener Auswurf",
	spew_desc = "Warnt vor Ätzender/Geschmolzener Auswurf.",
	acidic_message = "Ätzender Auswurf!",
	molten_message = "Geschmolzener Auswurf!",

	toxin = "Paralysierendes Toxin",
	toxin_desc = "Warnt, wer von Paralysierendes Toxin betroffen ist.",
	toxin_you = "Paralysierendes Toxin auf DIR!",
	toxin_other = "Paralysierendes Toxin: %s",

	burn = "Brennende Galle",
	burn_desc = "Warnt, wer von Brennende Galle betroffen ist.",
	burn_you = "Brennende Galle auf DIR!",
	burn_other = "Brennende Galle: %s",

	slime = "Schleimpfütze",
	slime_desc = "Warnt vor Schleimpfütze.",
	--slime_message = "Schleimpfütze auf DIR!",
	slime_warning = "Schleimpfütze",

	enrage = "Wutanfall",
	enrage_desc = "Warnt vor Wutanfall.",
	enrage_message = "Wutanfall!",

	jormungars_dies = "%s getötet!",

	-- Icehowl
	butt = "Heftiger Kopfstoß",
	butt_desc = "Warnt vor Heftiger Kopfstoß.",
	butt_message = "Heftiger Kopfstoß: %s!",
	butt_bar = "~Kopfstoß",

	charge = "Wütender Ansturm",
	charge_desc = "Warnt vor Wütender Ansturm auf Spielern.",
	charge_trigger = "^%%s",	--check
	charge_other = "Wütender Ansturm: %s!",
	charge_you = "Wütender Ansturm auf DIR!",
	charge_warning = "Ansturm bald!",

	daze = "Betäubte Benommenheit",
	daze_desc = "Warnt, wenn Eisheuler Betäubte Benommenheit bekommt.",
	daze_message = "Betäubte Benommenheit!",

	rage = "Schäumende Wut",
	rage_desc = "Warnt, wenn Eisheuler Schäumende Wut bekommt.",
	rage_message = "Schäumende Wut!",
} end)
L:RegisterTranslations("zhCN", function() return {
--[[	--engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	--jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	--icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "即将%s！",

	-- Gormok

	impale = "Impale",
	impale_desc = "当玩家中了2层或更多Impale时发出警报。",
	impale_message = "%2$dx Impale：>%1$s<！",

	stomp = "Staggering Stomp",
	stomp_desc = "当 Gormok 施放Staggering Stomp时发出警报。",
	stomp_message = "Staggering Stomp！",
	stomp_warning = "5秒后，Staggering Stomp！",
	stomp_bar = "<下一Staggering Stomp>",

	firebomb = "Fire Bomb",
	firebomb_desc = "当你中了Fire Bomb时发出警报。",
	firebomb_message = ">你< Fire Bomb！",

	-- Jormungars

	spew = "Acidic/Molten Spew",
	spew_desc = "当施放Acidic/Molten Spew时发出警报。",
	acidic_message = "Acidic Spew！",
	molten_message = "Molten Spew！",

	toxin = "Paralytic Toxin",
	toxin_desc = "当玩家中了Paralytic Toxin时发出警报。",
	toxin_you = ">你< Paralytic Toxin！",
	toxin_other = "Paralytic Toxin：>%s<！",

	burn = "Burning Bile",
	burn_desc = "当玩家中了Burning Bile时发出警报。",
	burn_you = ">你< Burning Bile！",
	burn_other = "Burning Bile：>%s<！",

	slime = "Slime Pool",
	slime_desc = "当施放Slime Pool时发出警报。",
	--slime_message = ">你< Slime Pool！",
	slime_warning = "Slime Pool！",

	enrage = "激怒",
	enrage_desc = "当激怒时发出警报。",
	enrage_message = "激怒！",

	jormungars_dies = "%s死亡！",

	-- Icehowl

	butt = "Ferocious Butt",
	butt_desc = "当施放Ferocious Butt时发出警报。",
	butt_message = "Ferocious Butt：>%s<！",
	butt_bar = "<Ferocious Butt 冷却>",

	charge = "野性冲锋",
	charge_desc = "当玩家中了野性冲锋时发出警报。",
--	charge_trigger = "^%%s",	--check
	charge_other = "野性冲锋：>%s<！",
	charge_you = ">你< 野性冲锋！",
	charge_warning = "即将 践踏！",

	daze = "Staggered Daze",
	daze_desc = "当Icehowl获得Staggered Daze时发出警报。",
	daze_message = "Staggered Daze！",

	rage = "Frothing Rage",
	rage_desc = "当Icehowl获得Frothing Rage时发出警报。",
	rage_message = "Frothing Rage!",
]]
} end)
L:RegisterTranslations("zhTW", function() return {
	--engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	--jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	--icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "即將%s！",
	
	-- Gormok
	impale = "刺穿",
	impale_desc = "當玩家中了2層或更多刺穿時發出警報。",
	impale_message = "%2$dx 刺穿：>%1$s<！",

	stomp = "驚恐踐踏",
	stomp_desc = "當『穿刺者』戈莫克施放驚恐踐踏時發出警報。",
	stomp_message = "驚恐踐踏！",
	stomp_warning = "5秒後，驚恐踐踏！",
	stomp_bar = "<下一驚恐踐踏>",

	firebomb = "燃燒彈",
	firebomb_desc = "當你中了燃燒彈時發出警報。",
	firebomb_message = ">你< 燃燒彈！",

	-- Jormungars
	spew = "酸液/熔火噴灑",
	spew_desc = "當施放酸液/熔火噴灑時發出警報。",
	acidic_message = "酸液噴灑！",
	molten_message = "熔火噴灑！",

	toxin = "痲痺劇毒",
	toxin_desc = "當玩家中了痲痺劇毒時發出警報。",
	toxin_you = ">你< 痲痺劇毒！",
	toxin_other = "痲痺劇毒：>%s<！",

	burn = "燃燒膽汁",
	burn_desc = "當玩家中了燃燒膽汁時發出警報。",
	burn_you = ">你< 燃燒膽汁！",
	burn_other = "燃燒膽汁：>%s<！",

	slime = "泥漿池",
	slime_desc = "當施放泥漿池時發出警報。",
	--slime_message = ">你< 泥漿池！",
	slime_warning = "泥漿池！",

	enrage = "狂怒",
	enrage_desc = "當狂怒時發出警報。",
	enrage_message = "狂怒!",

	jormungars_dies = "%s死亡！",

	-- Icehowl
	butt = "兇猛頭擊",
	butt_desc = "Warn for 兇猛頭擊",
	butt_message = "兇猛頭擊：>%s<！",
	butt_bar = "<兇猛頭擊 冷卻>",

	charge = "狂烈衝鋒",
	charge_desc = "當玩家中了狂烈衝鋒時發出警報。",
--	charge_trigger = "^%%s",	--check
	charge_other = "狂烈衝鋒：>%s<！",
	charge_you = ">你< 狂烈衝鋒！",
	charge_warning = "即將 踐踏！",

	daze = "驚恐暈眩",
	daze_desc = "當冰嚎獲得驚恐暈眩時發出警報。",
	daze_message = "驚恐暈眩！",

	rage = "泡沫之怒",
	rage_desc = "當冰嚎獲得泡沫之怒時發出警報。",
	rage_message = "泡沫之怒！",
} end)
L:RegisterTranslations("ruRU", function() return {
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

function mod:Impale(player, spellId)
	if db.impale then
		local _, _, icon, stack = UnitDebuff(player, impale)
		if stack and stack > 1 then
			self:TargetMessage(L["impale_message"], player, "Urgent", icon, "Info", stack)
		end
	end
end

function mod:Stomp(_, spellId)
	if db.stomp then
		self:IfMessage(L["stomp_message"], "Attention", spellId, "Long")
		self:Bar(L["stomp_bar"], 21, spellId)
		self:DelayedMessage(16, L["stomp_warning"], "Attention")
	end
end

do
	local last = nil
	function mod:FireBomb(player, spellId)
		if player == pName and db.firebomb then
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

function mod:SlimeCast(_, spellId)
	if db.slime then
		self:IfMessage(L["slime_warning"], "Attention", spellId)
	end
end

function mod:Molten(_, spellId)
	if db.spew then
		self:IfMessage(L["molten_message"], "Attention", spellId)
	end
end

function mod:Acidic(_, spellId)
	if db.spew then
		self:IfMessage(L["acidic_message"], "Attention", spellId)
	end
end

local function toxinWarn()
	mod:TargetMessage(L["toxin_other"], toxin, "Urgent", 64292, "Alert")
end

function mod:Toxin(player, spellId)
	if db.toxin then
		toxin[#toxin + 1] = player
		self:ScheduleEvent("BWtoxinWarn", toxinWarn, 0.2)
		if player == pName then
			mod:LocalMessage(L["toxin_you"], "Personal", spellId, "Info")
		end
	end
end

local function burnWarn()
	mod:TargetMessage(L["burn_other"], burn, "Urgent", 64292, "Alert")
end

function mod:Burn(player, spellId)
	if db.burn then
		burn[#burn + 1] = player
		self:ScheduleEvent("BWburnWarn", burnWarn, 0.2)
		if player == pName then
			self:TriggerEvent("BigWigs_ShowProximity", self)
			mod:LocalMessage(L["burn_you"], "Important", spellId, "Info")
		end
	end
end

function mod:BurnRemoved(player, spellId)
	if db.burn and player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

function mod:Enraged(_, spellId)
	if db.enrage then
		self:IfMessage(L["enrage_message"], "Attention", spellId, "Long")
	end
end

--------------------------------------------------------------------------------
-- Icehowl
--

function mod:Rage(_, spellId)
	if db.rage then
		self:IfMessage(L["rage_message"], "Important", spellId)
		self:Bar(L["rage"], 15, spellId)
	end
end

function mod:Daze(_, spellId)
	if db.daze then
		self:IfMessage(L["daze_message"], "Positive", spellId)
		self:Bar(L["daze"], 15, spellId)
	end
end

function mod:Butt(player, spellId)
	if db.butt then
		self:TargetMessage(L["butt_message"], player, "Attention", spellId)
		self:Bar(L["butt_bar"], 12, spellId)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(message, unit, _, _, player)
	if unit == icehowl and db.charge and message:find(L["charge_trigger"]) then
		if player == pName then
			self:LocalMessage(L["charge_you"], "Personal", 52311, "Alarm")
			self:WideMessage(L["charge_other"]:format(player))
		else
			self:TargetMessage(L["charge_other"], player, "Attention", 52311)
		end
		self:Bar(L["charge_other"]:format(player), 7, 62374)
		self:DelayedMessage(4, L["charge_warning"], "Attention")
	end
end

