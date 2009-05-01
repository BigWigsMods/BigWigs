----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Mimiron"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {boss, BB["Leviathan Mk II"], BB["VX-001"], BB["Aerial Command Unit"]}
mod.guid = 33350
--  Leviathan Mk II(33432), VX-001(33651), Aerial Command Unit(33670), 
mod.toggleoptions = {"phase", "hardmode", -1, "plasma", "shock", "laser", "magnetic", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local phase = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Mimiron",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	engage_warning = "Phase 1",
	engage_trigger = "^We haven't much time, friends!",
	phase2_warning = "Phase 2 incoming",
	phase2_trigger = "^WONDERFUL! Positively marvelous results!",
	phase3_warning = "Phase 3 incoming",
	phase3_trigger = "^Thank you, friends!",
	phase4_warning = "Phase 4 incoming",
	phase4_trigger = "^Preliminary testing phase complete",
	phase_bar = "Phase %d",

	hardmode = "Hard Mode Timer",
	hardmode_desc = "Show Timer for Hard Mode.",
	hardmode_trigger = "^Now why would you go and do something like that?",
	hardmode_message = "Hard Mode activated!",
	hardmode_warning = "Hard Mode ends",

	plasma = "Plasma Blast",
	plasma_desc = "Warns when Plasma Blast is casting.",
	plasma_warning = "Casting Plasma Blast!",
	plasma_soon = "Plasma soon!",
	plasma_bar = "Plasma",

	shock = "Shock Blast",
	shock_desc = "Warns when Shock Blast is casting.",
	shock_warning = "Shock Blast!",

	laser = "Laser Barrage",
	laser_desc = "Warn when Laser Barrage is active.",
	laser_soon = "Spinning up!",
	laser_bar = "Barrage",

	magnetic = "Magnetic Core",
	magnetic_desc = "Warn when Aerial Command Unit gains Magnetic Core.",
	magnetic_message = "ACU Rooted!",
	loot_message = "%s looted a core!",

	end_trigger = "^It would appear that I made a slight miscalculation.",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	engage_warning = "1 단계",
	engage_trigger = "^시간이 없어, 친구들!",
	phase2_warning = "곧 2 단계",
	phase2_trigger = "^멋지군!",
	phase3_warning = "곧 3 단계",
	phase3_trigger = "^고맙다, 친구들!",
	phase4_warning = "곧 4 단계",
	phase4_trigger = "^예비 시험은 이걸로 끝이다",
	phase_bar = "%d 단계",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	hardmode_trigger = "^아니 대체 왜 그런짓을 한거지?",	--check
	hardmode_message = "도전 모드 활성화!",
	hardmode_warning = "도전 모드 종료",

	plasma = "플라스마 폭발",
	plasma_desc = "플라스마 폭발 시전을 알립니다.",
	plasma_warning = "플라스마 폭발 시전!",
	plasma_soon = "곧 플라스마!",
	plasma_bar = "다음 플라스마",

	shock = "충격파",
	shock_desc = "충격파 시전을 알립니다.",
	shock_warning = "충격파!",

	laser = "레이저 탄막",
	laser_desc = "레이저 탄막 활동을 알립니다!",
	laser_soon = "회전 가속!",
	laser_bar = "레이저 탄막",

	magnetic = "자기 증폭기",
	magnetic_desc = "공중 지휘기의 자기 증폭기 상태를 알립니다.",
	magnetic_message = "공중 지휘기! 극딜!",
	loot_message = "%s - 증폭기 획득!",

	end_trigger = "^내가 계산을 좀 잘못한 것 같군",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	engage_warning = "Phase 1",
	engage_trigger = "^Nous n'avons pas beaucoup de temps, les amis !",
	phase2_warning = "Arrivée de la phase 2",
	phase2_trigger = "^MERVEILLEUX ! Résultats parfaitement formidables !",
	phase3_warning = "Arrivée de la phase 3",
	phase3_trigger = "^Merci, les amis !",
	phase4_warning = "Arrivée de la phase 4",
	phase4_trigger = "^Fin de la phase d'essais préliminaires",
	phase_bar = "Phase %d",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 8 minutes pour le mode difficile (mécanisme d'autodestruction activé).",
	hardmode_trigger = "^Mais, pourquoi avez-vous été faire une chose pareille ?",
	hardmode_message = "Mode difficile activé !",
	hardmode_warning = "Délai du mode difficile dépassé",

	plasma = "Explosion de plasma",
	plasma_desc = "Prévient quand une Explosion de plasma est incantée.",
	plasma_warning = "Explosion en incantation !",
	plasma_soon = "Explosion de plasma imminente !",
	plasma_bar = "Explosion de plasma",

	shock = "Horion explosif",
	shock_desc = "Prévient quand un Horion explosif est incanté.",
	shock_warning = "Horion explosif !",

	laser = "Barrage laser",
	laser_desc = "Prévient quand un Barrage laser est actif.",
	laser_soon = "Barrage laser imminent !",
	laser_bar = "Prochain Barrage laser",

	magnetic = "Noyau magnétique",
	magnetic_desc = "Prévient quand l'Unité de commandement aérien gagne Noyau magnétique.",
	magnetic_message = "UCA au sol !",
	loot_message = "%s a ramassé un noyau !",

	end_trigger = "^Il semblerait que j'aie pu faire une minime erreur de calcul.",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	engage_warning = "Phase 1",
	engage_trigger = "Wir haben nicht viel Zeit, Freunde! Ihr werdet mir dabei helfen, meine neueste und großartigste Kreation zu testen. Bevor Ihr nun Eure Meinung ändert, denkt daran, dass Ihr mir etwas schuldig seid, nach dem Unfug, den Ihr mit dem XT-002 angestellt habt.",
	phase2_warning = "Phase 2",
	phase2_trigger = "WUNDERBAR! Das sind Ergebnisse nach meinem Geschmack! Integrität der Hülle bei 98,9 Prozent! So gut wie keine Dellen! Und weiter geht's.",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Danke Euch, Freunde! Eure Anstrengungen haben fantastische Daten geliefert!",
	phase4_warning = "Phase 4",
	phase4_trigger = "^Vorversuchsphase abgeschlossen", -- NEED!
	phase_bar = "Phase %d",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",
	hardmode_trigger = "^Warum habt Ihr das denn jetzt gemacht?",
	hardmode_message = "Hard Mode aktiviert!",
	hardmode_warning = "Hard Mode beendet!",

	plasma = "Plasmaeruption",
	plasma_desc = "Warnung und Timer, wann Plasmaeruption gewirkt wird.",
	plasma_warning = "Wirkt Plasmaeruption!",
	plasma_soon = "Plasmaeruption bald!",
	plasma_bar = "Plasmaeruption",

	shock = "Schockschlag",
	shock_desc = "Warnung und Timer, wenn Schockschlag gewirkt wird.",
	shock_warning = "Wirkt Schockschlag!",

	laser = "Lasersalve",
	laser_desc = "Warnung und Timer für Lasersalve.",
	laser_soon = "Lasersalve bald!",
	laser_bar = "Lasersalve",

	magnetic = "Magnetischer Kern",
	magnetic_desc = "Warnung und Timer, wenn ein Magnetischer Kern geplündert wurde und die Luftkommandoeinheit am Boden ist.",
	magnetic_message = "Einheit am Boden!",
	loot_message = "%s hat Kern!",

	end_trigger = "^Es scheint, als wäre mir", -- NEED!
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	engage_warning = "第一阶段！",
--	engage_trigger = "^We haven't much time, friends!",
	phase2_warning = "即将 第二阶段！",
--	phase2_trigger = "^WONDERFUL! Positively marvelous results!",
	phase3_warning = "即将 第三阶段！",
--	phase3_trigger = "^Thank you, friends!",
	phase4_warning = "即将 第四阶段！",
--	phase4_trigger = "^Preliminary testing phase complete",
	phase_bar = "<阶段：%d>",

	hardmode = "困难模式计时器",
	hardmode_desc = "显示困难模式计时器。",
--	hardmode_trigger = "^Now why would you go and do something like that?",
	hardmode_message = "已开启困难模式！",
	hardmode_warning = "困难模式结束！",

	plasma = "Plasma Blast",
	plasma_desc = "当正在施放Plasma Blast时发出警报。",
	plasma_warning = "正在施放 Plasma Blast！",
	plasma_soon = "即将 Plasma Blast！",
	plasma_bar = "<Plasma Blast>",

	shock = "震爆",
	shock_desc = "当正在施放震爆时发出警报。",
	shock_warning = "震爆！",

	laser = "激光弹幕",
	laser_desc = "当激光弹幕启用时发出警报。",
	laser_soon = "即将 激光弹幕！",
	laser_bar = "<激光弹幕>",

	magnetic = "Magnetic Core",
	magnetic_desc = "当Aerial Command Unit获得Magnetic Core时发出警报。",
	magnetic_message = "Aerial Command Unit 已降落！",
	loot_message = ">%s< 拾取了Magnetic Core！",

--	end_trigger = "^It would appear that I made a slight miscalculation.",
} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	engage_warning = "第一階段！",
--	engage_trigger = "^We haven't much time, friends!",
	phase2_warning = "即將 第二階段！",
--	phase2_trigger = "^WONDERFUL! Positively marvelous results!",
	phase3_warning = "即將 第三階段！",
--	phase3_trigger = "^Thank you, friends!",
	phase4_warning = "即將 第四階段！",
--	phase4_trigger = "^Preliminary testing phase complete",
	phase_bar = "<階段：%d>",

	hardmode = "困難模式計時器",
	hardmode_desc = "顯示困難模式計時器。",
--	hardmode_trigger = "^Now why would you go and do something like that?",
	hardmode_message = "已開啟困難模式！",
	hardmode_warning = "困難模式結束！",

	plasma = "離子衝擊",
	plasma_desc = "當正在施放離子衝擊時發出警報。",
	plasma_warning = "正在施放 離子衝擊！",
	plasma_soon = "即將 離子衝擊！",
	plasma_bar = "<離子沖擊>",

	shock = "震爆",
	shock_desc = "當正在施放震爆時發出警報。",
	shock_warning = "震爆！",

	laser = "雷射彈幕",
	laser_desc = "當雷射彈幕啟用時發出警報。",
	laser_soon = "即將 雷射彈幕！",
	laser_bar = "<雷射彈幕>",

	magnetic = "磁能之核",
	magnetic_desc = "當空中指揮裝置獲得磁能之核時發出警報。",
	magnetic_message = "空中指揮裝置 已降落！",
	loot_message = ">%s< 拾取了磁能之核！",

--	end_trigger = "^It would appear that I made a slight miscalculation.",
} end )

L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	engage_warning = "1ая фаза",
--	engage_trigger = "^We haven't much time, friends!",
	phase2_warning = "Наступление 2ой фазы",
--	phase2_trigger = "^WONDERFUL! Positively marvelous results!",
	phase3_warning = "Наступление 3ей фазы",
--	phase3_trigger = "^Thank you, friends!",
	phase4_warning = "Наступление 4ой фазы",
--	phase4_trigger = "^Preliminary testing phase complete",
	phase_bar = "%d фаза",

	hardmode = "Таймеры сложного режима",
	hardmode_desc = "Отображения таймера для сложного режима.",
--	hardmode_trigger = "^Now why would you go and do something like that?",
	hardmode_message = "Сложный режим активирован!",
	hardmode_warning = "Завершение сложного режима",

	plasma = "Взрыв плазмы",
	plasma_desc = "Сообщать о применении Взрыва плазмы.",
	plasma_warning = "Применение Взрыва плазмы!",
	plasma_soon = "Скоро Взрыв плазмы!",
	plasma_bar = "Следующий Взрыв плазмы",

	shock = "Шоковый удар",
	shock_desc = "Сообщать о применении Шокового удара.",
	shock_warning = "Применение Шокового удара!",

	laser = "Лазерный обстрел",
	laser_desc = "Сообщает об активации Лазерного обстрела!",
	laser_soon = "Скоро Лазерный обстрел!",
	laser_bar = "Следующий обстрел",

	magnetic = "Магнитное ядро",
	magnetic_desc = "Сообщает когда Воздушное судно находится под воздействием Магнитного ядра",
	magnetic_message = "Магнитное ядро! БОМБИТЕ!",
	loot_message = "Ядро у |3-1(%s)!",

--	end_trigger = "^It would appear that I made a slight miscalculation.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Plasma", 62997, 64529)
	self:AddCombatListener("SPELL_CAST_START", "Shock", 63631)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spinning", 63414)
	self:AddCombatListener("SPELL_SUMMON", "Magnetic", 64444)

	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_LOOT")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(2, "MimiLoot")
	self:Throttle(10, "MimiBarrage")

	db = self.db.profile
end

function mod:VerifyEnable(unit)
	return UnitIsEnemy(unit, "player") and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Plasma(_, spellID)
	if db.plasma then
		self:IfMessage(L["plasma_warning"], "Important", spellID)
		self:Bar(L["plasma_warning"], 3, spellID)
		self:Bar(L["plasma_bar"], 30, spellID)
		self:ScheduleEvent("PlasmaWarning", "BigWigs_Message", 27, L["plasma_soon"], "Attention")
	end
end

function mod:Shock(_, spellID)
	if db.shock then
		self:IfMessage(L["shock_warning"], "Important", spellID)
		self:Bar(L["shock"], 5, spellID)
	end
end

function mod:Spinning(_, spellId)
	if db.laser then
		self:IfMessage(L["laser_soon"], "Personal", 63414, "Long")
	end
end

do
	local laser = GetSpellInfo(63274)
	function mod:UNIT_SPELLCAST_CHANNEL_START(unit, spell)
		if spell == laser then
			self:Sync("MimiBarrage")
		end
	end
end

function mod:Magnetic(_, spellID)
	if db.magnetic then
		self:IfMessage(L["magnetic_message"], "Important", spellID)
		self:Bar(L["magnetic"], 15, spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["hardmode_trigger"]) then
		phase = 1
		if db.phase then
			self:IfMessage(L["engage_warning"], "Attention")
		end
		if db.plasma then
			self:Bar(L["plasma_bar"], 20, 62997)
			self:DelayedMessage(17, L["plasma_soon"], "Attention")
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 480, 64582)
			self:IfMessage(L["hardmode_message"], "Attention", 64582)
			self:DelayedMessage(480, L["hardmode_warning"], "Attention")
		end
	elseif msg:find(L["engage_trigger"]) then
		phase = 1
		if db.phase then
			self:IfMessage(L["engage_warning"], "Attention")
		end
		if db.plasma then
			self:Bar(L["plasma_bar"], 20, 62997)
			self:DelayedMessage(17, L["plasma_soon"], "Attention")
		end
	elseif msg:find(L["phase2_trigger"]) then
		phase = 2
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["plasma_bar"])
		if db.phase then
			self:IfMessage(L["phase2_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 40, "INV_Gizmo_01")
		end
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:TriggerEvent("BigWigs_StopBar", self, L["laser"])
		self:TriggerEvent("BigWigs_StopBar", self, L["laser_bar"])
		if db.phase then
			self:IfMessage(L["phase3_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
		end
	elseif msg:find(L["phase4_trigger"]) then
		phase = 4
		self:TriggerEvent("BigWigs_StopBar", self, L["magnetic"])
		if db.phase then
			self:IfMessage(L["phase4_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
		end
	elseif msg:find(L["end_trigger"]) then
		self:BossDeath(nil, self.guid)
	end
end

do
	local lootItem = '^' .. LOOT_ITEM:gsub("%%s", "(.-)") .. '$'
	local lootItemSelf = '^' .. LOOT_ITEM_SELF:gsub("%%s", "(.*)") .. '$'
	function mod:CHAT_MSG_LOOT(msg)
		local player, item = select(3, msg:find(lootItem))
		if not player then
			item = select(3, msg:find(lootItemSelf))
			if item then
				player = pName
			end
		end

		if type(item) == "string" and type(player) == "string" then
			local itemLink, itemRarity = select(2, GetItemInfo(item))
			if itemRarity and itemRarity == 1 and itemLink then
				local itemId = select(3, itemLink:find("item:(%d+):"))
				if not itemId then return end
				itemId = tonumber(itemId:trim())
				if type(itemId) ~= "number" or itemId ~= 46029 then return end
				self:Sync("MimiLoot", player)
			end
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MimiLoot" and rest and db.magnetic then
		self:IfMessage(L["loot_message"]:format(rest), "Positive", "Interface\\Icons\\INV_Gizmo_KhoriumPowerCore", "Info")
	elseif sync == "MimiBarrage" and db.laser then
		self:IfMessage(L["laser_bar"], "Important", 63274)
		self:Bar(L["laser_bar"], 60, 63274)
	end
end

