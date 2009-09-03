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
mod.toggleOptions = {62997, 63631, 63274, 64444, 63811, 64623, 64570, "phase", "hardmode", "proximity", "berserk", "bosskill"}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.consoleCmd = "Mimiron"

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

	hardmode = "Hard mode timer",
	hardmode_desc = "Show timer for hard mode.",
	hardmode_trigger = "^Now, why would you go and do something like that?",
	hardmode_message = "Hard mode activated!",
	hardmode_warning = "BOOM!",

	plasma_warning = "Casting Plasma Blast!",
	plasma_soon = "Plasma soon!",
	plasma_bar = "Plasma",

	shock_next = "Next Shock Blast",

	laser_soon = "Spinning up!",
	laser_bar = "Barrage",

	magnetic_message = "ACU Rooted!",

	suppressant_warning = "Suppressant incoming!",

	fbomb_soon = "Possible Frost Bomb soon!",
	fbomb_bar = "Next Frost Bomb",

	bomb_message = "Bomb Bot spawned!",

	end_trigger = "^It would appear that I've made a slight miscalculation.",
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
	hardmode_trigger = "^아니, 대체 왜 그런 짓을 한 게지?",
	hardmode_message = "도전 모드 활성화!",
	hardmode_warning = "폭발!",

	plasma_warning = "플라스마 폭발 시전!",
	plasma_soon = "곧 플라스마!",
	plasma_bar = "다음 플라스마",

	shock_next = "다음 충격파",

	laser_soon = "회전 가속!",
	laser_bar = "레이저 탄막",

	magnetic_message = "공중 지휘기! 극딜!",

	suppressant_warning = "곧 화염 억제!",

	fbomb_soon = "잠시후 서리 폭탄 가능!",
	fbomb_bar = "다음 서리 폭탄",

	bomb_message = "폭발로봇 소환!",

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

	hardmode = "Autodestruction",
	hardmode_desc = "Affiche une barre de 10 minutes pour le mode difficile (mécanisme d'autodestruction activé).",
	hardmode_trigger = "^Mais, pourquoi",
	hardmode_message = "Autodestruction activée !",
	hardmode_warning = "Autodestruction !",

	plasma_warning = "Plasma en incantation !",
	plasma_soon = "Explosion de plasma imminente !",
	plasma_bar = "Plasma",

	shock_next = "Prochain Horion",

	laser_soon = "Accélération !",
	laser_bar = "Barrage",

	magnetic_message = "UCA au sol !",

	suppressant_warning = "Arrivée d'un Coupe-flamme !",

	fbomb_soon = "Bombe de givre imminente !",
	fbomb_bar = "Prochaine Bombe de givre",

	bomb_message = "Robo-bombe apparu !",

	end_trigger = "^Il semblerait que j'aie pu faire une minime erreur de calcul.",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	engage_warning = "Phase 1",
	engage_trigger = "^Wir haben nicht viel Zeit, Freunde!",
	phase2_warning = "Phase 2",
	phase2_trigger = "WUNDERBAR! Das sind Ergebnisse nach meinem Geschmack! Integrität der Hülle bei 98,9 Prozent! So gut wie keine Dellen! Und weiter geht's.",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Danke Euch, Freunde! Eure Anstrengungen haben fantastische Daten geliefert!",
	phase4_warning = "Phase 4",
	phase4_trigger = "Vorversuchsphase abgeschlossen. Jetzt kommt der eigentliche Test!",
	phase_bar = "Phase %d",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",
	hardmode_trigger = "^Warum habt Ihr das denn jetzt gemacht?",
	hardmode_message = "Hard Mode aktiviert!",
	hardmode_warning = "BOOM!",

	plasma_warning = "Wirkt Plasmaeruption!",
	plasma_soon = "Plasmaeruption bald!",
	plasma_bar = "Plasmaeruption",

	shock_next = "~Schockschlag",

	laser_soon = "Lasersalve!",
	laser_bar = "Lasersalve",

	magnetic_message = "Einheit am Boden!",

	suppressant_warning = "Löschschaum kommt!",

	fbomb_soon = "Frostbombe bald!",
	fbomb_bar = "~Frostbombe",

	bomb_message = "Bombenbot!",

	end_trigger = "^Es scheint, als wäre mir",
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

	plasma_warning = "正在施放 等离子冲击！",
	plasma_soon = "即将 等离子冲击！",
	plasma_bar = "<等离子冲击>",

	shock_next = "下一震荡冲击！",

	laser_soon = "即将 P3Wx2激光弹幕！",
	laser_bar = "<P3Wx2激光弹幕>",

	magnetic_message = "空中指挥单位 已降落！",

	suppressant_warning = "即将 烈焰遏制！",

	fbomb_soon = "可能即将 冰霜炸弹！",
	fbomb_bar = "<下一冰霜炸弹>",

	bomb_message = "炸弹机器人 出现！",

--	end_trigger = "^It would appear that I've made a slight miscalculation.",
} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	engage_warning = "第一階段！",
	engage_trigger = "我們沒有太多時間，朋友們!你們要幫我測試我最新也是最偉大的創作。在你們改變心意之前，別忘了就是你們把XT-002搞得一團糟，你們欠我一次。",
	phase2_warning = "即將 第二階段！",
	phase2_trigger = "太好了!絕妙的良好結果!外殼完整度98.9%!幾乎只有一點擦痕!繼續下去。",
	phase3_warning = "即將 第三階段！",
	phase3_trigger = "感謝你，朋友們!我們的努力讓我獲得了一些絕佳的資料!現在，我把東西放在哪兒了--噢，在這裡。",
	phase4_warning = "即將 第四階段！",
	phase4_trigger = "初步測試階段完成。現在要玩真的啦!",
	phase_bar = "<階段：%d>",

	hardmode = "困難模式計時器",
	hardmode_desc = "顯示困難模式計時器。",
	hardmode_trigger = "為什麼你要做出這種事?難道你沒看見標示上寫著「請勿觸碰這個按鈕!」嗎?現在自爆裝置已經啟動了，我們要怎麼完成測試呢?",
	hardmode_message = "已開啟困難模式！",
	hardmode_warning = "困難模式結束！",

	plasma_warning = "正在施放 離子衝擊！",
	plasma_soon = "即將 離子衝擊！",
	plasma_bar = "<離子沖擊>",

	shock_next = "下一震爆！",

	laser_soon = "即將 P3Wx2雷射彈幕！",
	laser_bar = "<P3Wx2雷射彈幕>",

	magnetic_message = "空中指揮裝置 已降落！",

	suppressant_warning = "即將 熾焰抑制劑！",

	fbomb_soon = "可能即將 冰霜炸彈！",
	fbomb_bar = "<下一冰霜炸彈>",

	bomb_message = "炸彈機器人 出現！",

	end_trigger = "看來我還是產生了些許計算錯誤。任由我的心智受到囚牢中魔鬼的腐化，棄我的首要職責於不顧。所有的系統看起來都正常運作。報告完畢。",
} end )

L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	engage_warning = "1ая фаза",
	engage_trigger = "^У нас мало времени, друзья!",
	phase2_warning = "Наступает 2-ая фаза",
	phase2_trigger = "^ПРЕВОСХОДНО! Просто восхитительный результат!",
	phase3_warning = "Наступает 3-ая фаза",
	phase3_trigger = "^Спасибо, друзья!",
	phase4_warning = "Наступает 4-ая фаза",
	phase4_trigger = "^Фаза предварительной проверки завершена.",
	phase_bar = "%d фаза",

	hardmode = "Таймеры сложного режима",
	hardmode_desc = "Отображения таймера для сложного режима.",
	hardmode_trigger = "^Так, зачем вы это сделали?",
	hardmode_message = "Сложный режим активирован!",
	hardmode_warning = "Завершение сложного режима",

	plasma_warning = "Применяется Взрыв плазмы!",
	plasma_soon = "Скоро Взрыв плазмы!",
	plasma_bar = "Взрыв плазмы",

	shock_next = "Следующий Шоковый удар!",

	laser_soon = "Вращение!",
	laser_bar = "Обстрел",

	magnetic_message = "Магнитное ядро! БОМБИТЕ!",

	suppressant_warning = "Подавитель пламени!",

	fbomb_soon = "Скоро Ледяная бомба!",
	fbomb_bar = "Следущая Ледяная бомба",

	bomb_message = "Появился Бомбот!",

	end_trigger = "^Очевидно, я совершил небольшую ошибку в расчетах.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Plasma", 62997, 64529)
	self:AddCombatListener("SPELL_CAST_START", "Suppressant", 64570)
	self:AddCombatListener("SPELL_CAST_START", "FBomb", 64623)
	self:AddCombatListener("SPELL_CAST_START", "Shock", 63631)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spinning", 63414)
	--self:AddCombatListener("SPELL_AURA_APPLIED", "Shell", 63666, 65026)
	self:AddCombatListener("SPELL_SUMMON", "Magnetic", 64444)
	self:AddCombatListener("SPELL_SUMMON", "Bomb", 63811)
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_LOOT")
	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:Throttle(2, "MimiLoot")
	self:Throttle(10, "MimiBarrage")
	db = self.db.profile
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Bomb(_, spellId, _, _, spellName)
	self:IfMessage(L["bomb_message"], "Important", 63811, "Alert")
end

function mod:Suppressant(_, spellId, _, _, spellName)
	self:IfMessage(L["suppressant_warning"], "Important", spellId)
	self:Bar(spellName, 3, spellId)
end

function mod:FBomb(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 2, spellId)
	self:Bar(L["fbomb_bar"], 30, spellId)
	self:ScheduleEvent("fbombWarning", "BigWigs_Message", 28, L["fbomb_soon"], "Attention")
end

function mod:Plasma(_, spellId, _, _, spellName)
	self:IfMessage(L["plasma_warning"], "Important", spellId)
	self:Bar(L["plasma_warning"], 3, spellId)
	self:Bar(L["plasma_bar"], 30, spellId)
	self:ScheduleEvent("plasmaWarning", "BigWigs_Message", 27, L["plasma_soon"], "Attention")
end

function mod:Shock(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 3.5, spellId)
	self:Bar(L["shock_next"], 34, spellId)
end

function mod:Spinning(_, spellId)
	if self:GetOption(63274) then
		self:IfMessage(L["laser_soon"], "Personal", spellId, "Long")
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

function mod:Magnetic(_, spellId, _, _, spellName)
	self:IfMessage(L["magnetic_message"], "Important", spellId)
	self:Bar(spellName, 15, spellId)
end

local function start()
	ishardmode = nil
	phase = 1
	if db.phase then
		mod:IfMessage(L["engage_warning"], "Attention")
		mod:Bar(L["phase_bar"]:format(phase), 7, "INV_Gizmo_01")
	end
	if mod:GetOption(63631) then
		mod:Bar(L["shock_next"], 30, 63631)
	end
	if mod:GetOption(62997) then
		mod:Bar(L["plasma_bar"], 20, 62997)
		mod:DelayedMessage(17, L["plasma_soon"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["hardmode_trigger"]) then
		start()
		ishardmode = true
		if db.hardmode then
			self:Bar(L["hardmode"], 600, 64582)
			self:IfMessage(L["hardmode_message"], "Attention", 64582)
			self:DelayedMessage(600, L["hardmode_warning"], "Important")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif msg:find(L["engage_trigger"]) then
		start()
		if db.berserk then
			self:Enrage(900, true, true)
		end
	elseif msg:find(L["phase2_trigger"]) then
		phase = 2
		self:CancelScheduledEvent("plasmaWarning")
		self:TriggerEvent("BigWigs_StopBar", L["plasma_bar"])
		self:TriggerEvent("BigWigs_StopBar", L["shock_next"])
		if db.phase then
			self:IfMessage(L["phase2_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 40, "INV_Gizmo_01")
		end
		if self:GetOption(64623) and ishardmode then
			self:Bar(L["fbomb_bar"], 45, 64623)
		end
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg:find(L["phase3_trigger"]) then
		self:CancelScheduledEvent("fbombWarning")
		phase = 3
		if db.phase then
			self:IfMessage(L["phase3_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
		end
	elseif msg:find(L["phase4_trigger"]) then
		phase = 4
		if db.phase then
			self:IfMessage(L["phase4_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
		end
		if self:GetOption(64623) and ishardmode then
			self:Bar(L["fbomb_bar"], 30, 64623)
		end
		if self:GetOption(63631) then
			self:Bar(L["shock_next"], 48, 63631)
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
	if sync == "MimiLoot" and rest and self:GetOption(64444) then
		self:TargetMessage(GetSpellInfo(64444), rest, "Positive", "Interface\\Icons\\INV_Gizmo_KhoriumPowerCore", "Info")
	elseif sync == "MimiBarrage" and self:GetOption(63274) then
		self:IfMessage(L["laser_bar"], "Important", 63274)
		self:Bar(L["laser_bar"], 60, 63274)
	end
end

