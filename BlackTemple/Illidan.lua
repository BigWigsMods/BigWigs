------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Illidan Stormrage"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local pName = UnitName("player")
local db = nil
local bCount = 0
local p2Announced = nil
local p2 = nil
local p4Announced = nil
local flamesDead = 0
local flamed = { }
local fmt = string.format
local CheckInteractDistance = CheckInteractDistance

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Illidan",

	berserk_trigger = "You are not prepared!",

	parasite = "Parasitic Shadowfiend",
	parasite_desc = "Warn who has Parasitic Shadowfiend.",
	parasite_you = "You have a Parasite!",
	parasite_other = "%s has a Parasite!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Parasitic Shadowfiend.",

	barrage = "Dark Barrage",
	barrage_desc = "Warn who has Dark Barrage.",
	barrage_message = "%s is being Barraged!",
	barrage_warn = "Barrage Soon!",
	barrage_warn_bar = "~Next Barrage",
	barrage_bar = "Barrage: %s",

	eyeblast = "Eye Blast",
	eyeblast_desc = "Warn when Eye Blast is cast.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!",
	eyeblast_message = "Eye Blast!",

	shear = "Shear",
	shear_desc = "Warn about Shear on players.",
	shear_message = "Shear on %s!",
	shear_bar = "Shear: %s",

	flame = "Agonizing Flames",
	flame_desc = "Warn who has Agonizing Flames.",
	flame_message = "%s has Agonizing Flames!",

	demons = "Shadow Demons",
	demons_desc = "Warn when Illidan is summoning Shadow Demons.",
	demons_message = "Shadow Demons!",
	demons_warn = "Demons Soon!",

	phase = "Phases",
	phase_desc = "Warns when Illidan goes into different stages.",
	phase2_soon_message = "Phase 2 soon!",
	phase2_message = "Phase 2 - Blades of Azzinoth!",
	phase3_message = "Phase 3!",
	demon_phase_trigger = "Behold the power... of the demon within!",
	demon_phase_message = "Demon Form!",
	demon_bar = "Next Normal Phase",
	demon_warning = "Demon over in ~ 5 sec!",
	normal_bar = "~Possible Demon Phase",
	normal_warning = "Possible Demon Phase in ~5 sec!",
	phase4_trigger = "Is this it, mortals? Is this all the fury you can muster?",
	phase4_soon_message = "Phase 4 soon!",
	phase4_message = "Phase 4 - Maiev Incoming!",

	burst = "Flame Burst",
	burst_desc = "Warns when Illidan will use Flame Burst",
	burst_message = "Flame Burst!",
	burst_cooldown_bar = "Flame Burst cooldown",
	burst_cooldown_warn = "Flame Burst soon!",
	burst_warn = "Flame Burst in 5sec!",

	enrage_trigger = "Feel the hatred of ten thousand years!",
	enrage_message = "Enraged!",

	["Flame of Azzinoth"] = true,

	--very first yell to start engage timer
	illi_start = "Akama. Your duplicity is hardly surprising. I should have slaughtered you and your malformed brethren long ago.",
} end )

L:RegisterTranslations("frFR", function() return {
	berserk_trigger = "Vous n'êtes pas prêts !",

	parasite = "Ombrefiel parasite",
	parasite_desc = "Préviens quand un joueur subit les effets de l'Ombrefiel parasite.",
	parasite_you = "Vous avez un parasite !",
	parasite_other = "%s a un parasite !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Ombrefiel parasite (nécessite d'être promu ou mieux).",

	barrage = "Barrage noir",
	barrage_desc = "Préviens quand un joueur subit les effets du Barrage noir.",
	barrage_message = "%s subit le Barrage !",
	barrage_warn = "Barrage imminent !",
	barrage_warn_bar = "~Prochain Barrage",
	barrage_bar = "Barrage : %s",

	eyeblast = "Energie oculaire",
	eyeblast_desc = "Préviens quand l'Energie oculaire est incanté.",
	eyeblast_trigger = "Soutenez le regard du Traître !",
	eyeblast_message = "Energie oculaire !",

	shear = "Tonte",
	shear_desc = "Préviens quand un joueur subit les effets de la Tonte.",
	shear_message = "Tonte sur %s !",
	shear_bar = "Tonte : %s",

	flame = "Flammes déchirantes",
	flame_desc = "Préviens quand un joueur subit les effets des Flammes déchirantes.",
	flame_message = "%s a les Flammes déchirantes !",

	demons = "Démons des ombres",
	demons_desc = "Préviens quand Illidan invoque des démons des ombres.",
	demons_message = "Démons des ombres !",
	demons_warn = "Démons imminent !",

	phase = "Phases",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase2_soon_message = "Phase 2 imminente !",
	phase2_message = "Phase 2 - Lames d'Azzinoth !",
	phase3_message = "Phase 3 !",
	demon_phase_trigger = "Contemplez la puissance... du démon intérieur !",
	demon_phase_message = "Forme de démon !",
	demon_bar = "Prochaine phase normale",
	demon_warning = "Fin du démon dans ~5 sec. !",
	normal_bar = "~Phase démon probable",
	normal_warning = "Phase démon probablement dans ~5 sec. !",
	phase4_trigger = "C'est tout, mortels ? Est-ce là toute la fureur que vous pouvez évoquer ?",
	phase4_soon_message = "Phase 4 imminente !",
	phase4_message = "Phase 4 - Arrivée de Maiev !",

	burst = "Explosion de flammes",
	burst_desc = "Préviens quand Illidan utilise son Explosion de flammes.",
	burst_message = "Explosion de flammes !",
	burst_cooldown_bar = "~Cooldown Explosion",
	burst_cooldown_warn = "Explosion de flammes imminente !",
	burst_warn = "Explosion de flammes dans 5 sec. !",

	enrage_trigger = "Goûtez à dix mille ans de haine !",
	enrage_message = "Enragé !",

	["Flame of Azzinoth"] = "Flamme d'Azzinoth",

	--very first yell to start engage timer
	illi_start = "Akama. Ta duplicité n'est pas très étonnante. J'aurai dû vous massacrer depuis longtemps, toi et ton frère déformé.",
} end )

L:RegisterTranslations("koKR", function() return {
	berserk_trigger = "너흰 아직 준비가 안 됐다!",

	parasite = "어둠의 흡혈마귀",
	parasite_desc = "어둠의 흡혈마귀에 걸린 플레이어를 알립니다.",
	parasite_you = "당신에 흡혈마귀!",
	parasite_other = "%s에 흡혈마귀!",

	icon = "전술 표시",
	icon_desc = "어둠의 흡혈마귀에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	barrage = "암흑의 보호막",
	barrage_desc = "암흑의 보호막에 걸린 플레이어를 알립니다.",
	barrage_message = "%s에 집중포화!",
	barrage_warn = "잠시 후 집중포화!",
	barrage_warn_bar = "집중포화 대기시간",
	barrage_bar = "집중포화: %s",

	eyeblast = "안광",
	eyeblast_desc = "안광 시전 시 알립니다.",
	eyeblast_trigger = "배신자의 눈을 똑바로 쳐다봐라!",
	eyeblast_message = "안광!",

	shear = "베어내기",
	shear_desc = "베어내기에 걸린 플레이어를 알립니다.",
	shear_message = "%s에 베어내기!",
	shear_bar = "베어내기: %s",

	flame = "고뇌의 불꽃",
	flame_desc = "고뇌의 불꽃에 걸린 플레이어를 알립니다.",
	flame_message = "%s에 고뇌의 불꽃!",

	demons = "어둠의 악마",
	demons_desc = "어둠의 악마 소환 시 알립니다.",
	demons_message = "어둠의 악마!",
	demons_warn = "잠시 후 어둠의 악마 소환!",

	phase = "단계",
	phase_desc = "일리단이 다른 형상으로 변경 시 알립니다.",
	phase2_soon_message = "잠시 후 2 단계!",
	phase2_message = "2 단계 - 아지노스의 칼날!",
	phase3_message = "3 단계!",
	demon_phase_trigger = "내 안에 깃든... 악마의 힘을 보여주마!",
	demon_phase_message = "악마 형상!",
	demon_bar = "다음 보통 형상",
	demon_warning = "5초이내 악마 형상 종료!",
	normal_bar = "~악마 형상 가능",
	normal_warning = "5초이내 악마 형상 가능!",
	phase4_trigger = "나만큼 널 증오하는 이가 또 있을까? 일리단! 네게 받아야 할 빚이 남았다!",
	phase4_soon_message = "잠시 후 4 단계!",
	phase4_message = "4 단계 - 마이에브 등장!",

	burst = "화염 폭발",
	burst_desc = "일리단이 화염 폭발 사용 시 알립니다.",
	burst_message = "화염 폭발!",
	burst_cooldown_bar = "화염 폭발 대기시간",
	burst_cooldown_warn = "잠시 후 화염 폭발!",
	burst_warn = "약 5초 이내 화염 폭발!",

	enrage_trigger = "만년 동안 응어리진 증오를 보여주마!",
	enrage_message = "격노!",

	["Flame of Azzinoth"] = "아지노스의 불꽃",

	--맨처음 외침에 공격시작되는 타이머
	illi_start = "아카마, 너의 불충은 그리 놀랍지도 않구나. 너희 흉측한 형제들을 벌써 오래전에 없애버렸어야 했는데...",
} end )

L:RegisterTranslations("zhCN", function() return {
	berserk_trigger = "你们这是自寻死路！",

	parasite = "寄生暗影魔",
	parasite_desc = "当队员中寄生暗影魔时发出警告。",
	parasite_you = ">你< 寄生暗影魔！",
	parasite_other = "寄生暗影魔：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了寄生暗影魔的队员打上团队标记。(需要权限)",

	barrage = "黑暗壁垒",
	barrage_desc = "当玩家中了黑暗壁垒时发出警报。",
	barrage_message = "黑暗壁垒：>%s<！",
	barrage_warn = "即将 黑暗壁垒！",
	barrage_warn_bar = "<下一黑暗壁垒>",
	barrage_bar = "<黑暗壁垒：%s>",

	eyeblast = "魔眼冲击",
	eyeblast_desc = "当施放魔眼冲击时发出警报。",
	eyeblast_trigger = "直视背叛者的双眼吧！",
	eyeblast_message = "魔眼冲击！",

	shear = "剪切",
	shear_desc = "剪切玩家警报。",
	shear_message = "剪切：>%s<！",
	shear_bar = "<剪切：%s>",

	flame = "苦痛之焰",
	flame_desc = "当中了苦痛之焰时发出警报。",
	flame_message = "苦痛之焰：>%s<！",

	demons = "影魔",
	demons_desc = "当伊利丹召唤影魔时发出警报。",
	demons_message = "影魔！",
	demons_warn = "即将 影魔！",

	phase = "阶段",
	phase_desc = "当伊利丹进入不同阶段发出警报。",
	phase2_soon_message = "即将 -  第二阶段！",
	phase2_message = "第二阶段 - 埃辛诺斯双刃！",
	phase3_message = "第三阶段！",
	demon_phase_trigger = "感受我体内的恶魔之力吧！",
	demon_phase_message = "恶魔形态！",
	demon_bar = "<下一普通阶段>",
	demon_warning = "恶魔阶段 约5秒后结束！",
	normal_bar = "<可能 恶魔阶段>",
	normal_warning = "约5秒后, 可能恶魔阶段！",
	phase4_trigger = "你们就这点本事吗？这就是你们全部的能耐？",
	phase4_soon_message = "即将 - 第四阶段！",
	phase4_message = "第四阶段 - 玛维·影歌来临！",

	burst = "烈焰爆击",
	burst_desc = "当伊利丹使用烈焰爆击发出警报",
	burst_message = "烈焰爆击!",
	burst_cooldown_bar = "烈焰爆击 冷却",
	burst_cooldown_warn = "即将 烈焰爆击!",
	burst_warn = "5秒后 烈焰爆击!",

	enrage_trigger = "感受一万年的仇恨吧！",
	enrage_message = "狂暴！",

	["Flame of Azzinoth"] = "埃辛诺斯之焰",

	--第一次触发伊利丹时计时器
	illi_start = "阿卡玛。你的两面三刀并没有让我感到意外。我早就应该把你和你那些畸形的同胞全部杀掉。",
} end )

L:RegisterTranslations("deDE", function() return {
	berserk_trigger = "Ihr wisst nicht, was Euch erwartet!",

	parasite = "Schädlicher Schattengeist",
	parasite_desc = "Warnt wer von Schädlicher Schattengeist betroffen ist.",
	parasite_you = "Du hast einen Parasiten!",
	parasite_other = "%s hat einen Parasiten!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziere ein Schlachtzug Symbol auf Spielern die von Schädlicher Schattengeist betroffen sind.",

	barrage = "Dunkles Sperrfeuer",
	barrage_desc = "Warnt wer von Dunkles Sperrfeuer betroffen ist.",
	barrage_message = "%s hat Dunkles Sperrfeuer!",
	barrage_warn = "Sperrfeuer bald!",
	barrage_warn_bar = "~Nächstes Sperrfeuer",
	barrage_bar = "Sperrfeuer: %s",

	eyeblast = "Augenfeuer",
	eyeblast_desc = "Warnt wenn Augenfeuer gezaubert wird.",
	eyeblast_trigger = "Blickt in die Augen des Verräters!",
	eyeblast_message = "Augenfeuer!",

	shear = "Abscheren",
	shear_desc = "Warnt bei Abscheren auf Spielern.",
	shear_message = "Abscheren auf %s!",
	shear_bar = "Abscheren: %s",

	flame = "Peinigende Flammen",
	flame_desc = "Warnt wer von Peinigende Flammen betroffen ist.",
	flame_message = "%s hat Peinigende Flammen!",

	demons = "Schattendämonen",
	demons_desc = "Warnt wenn Illidan Schattendämonen beschwört.",
	demons_message = "Schattendämonen!",
	demons_warn = "Dämonen Bald!",

	phase = "Phasen",
	phase_desc = "Warnt wenn Illidan in die verschiedenen Phasen geht.",
	phase2_soon_message = "Phase 2 Bald!",
	phase2_message = "Phase 2 - Klingen von Azzinoth!",
	phase3_message = "Phase 3!",
	demon_phase_trigger = "Erzittert vor der Macht des Dämonen!",
	demon_phase_message = "Dämonen Form!",
	demon_bar = "Nächste Normale Phase",
	demon_warning = "Dämon vorbei in ~ 5 sek!",
	normal_bar = "~Mögliche Dämon Phase",
	normal_warning = "Mögliche Dämon Phase in ~5 sek!",
	phase4_trigger = "War's das schon. Sterbliche? Ist das alles was Ihr zu bieten habt??",
	phase4_soon_message = "Phase 4 bald!",
	phase4_message = "Phase 4 - Maiev kommt!",

	burst = "Flammenschlag",
	burst_desc = "Warnt wenn Illidan Flammenschlag benutzen wird.",
	burst_message = "Flammenschlag!",
	burst_cooldown_bar = "Flammenschlag cooldown",
	burst_cooldown_warn = "Flammenschlag bald!",
	burst_warn = "Flammenschlag in 5sek!",

	enrage_trigger = "Fühlt dem Haß von 10 tausend Jahren!",
	enrage_message = "Wütend!",

	["Flame of Azzinoth"] = "Flamme von Azzinoth",

	--very first yell to start engage timer
	illi_start = "Akama. Euer falsches Spiel überrascht mich nicht. Ich hätte Euch und Eure missgestalteten Brüder schon vor langer Zeit abschlachten sollen.",
} end )

L:RegisterTranslations("zhTW", function() return {
	berserk_trigger = "你們還沒準備好!",

	parasite = "寄生暗影惡魔",
	parasite_desc = "當隊員中寄生暗影惡魔時發出警告",
	parasite_you = "你中了>寄生暗影惡魔<!",
	parasite_other = "寄生暗影惡魔：[%s]",

	icon = "團隊標記",
	icon_desc = "為中了寄生暗影魔的隊員打上團隊標記.",

	barrage = "黑暗侵襲",
	barrage_desc = "當玩家中了黑暗侵襲時發出警報",
	barrage_message = "%s 中了黑暗侵襲!",
	barrage_warn = "侵襲即將來臨!",
	barrage_warn_bar = "~下一次侵襲",
	barrage_bar = "侵襲：[%s]",

	eyeblast = "暗眼衝擊波",
	eyeblast_desc = "當施放暗眼衝擊波時發出警報",
	eyeblast_trigger = "直視背叛者的雙眼吧!",
	eyeblast_message = "暗眼衝擊波!",

	shear = "銳減",
	shear_desc = "當玩家受到銳減時警報",
	shear_message = "銳減：[%s]",
	shear_bar = "銳減：[%s]",

	flame = "苦惱之焰",
	flame_desc = "當玩家中了苦惱之焰時發出警報",
	flame_message = "苦惱之焰：[%s]",

	demons = "暗影惡魔",
	demons_desc = "當召喚暗影惡魔時發出警報",
	demons_message = "暗影惡魔!",
	demons_warn = "暗影惡魔即將來臨!",

	phase = "階段",
	phase_desc = "當變換不同階段時發出警報",
	phase2_soon_message = "階段 2 即將來臨!",
	phase2_message = "階段 2 - 埃辛諾斯之刃!",
	phase3_message = "階段 3!",
	demon_phase_trigger = "感受我體內的惡魔之力吧!",
	demon_phase_message = "惡魔型態!",
	demon_bar = "下一個普通階段",
	demon_warning = "5 秒後惡魔型態!",
	normal_bar = "~可能惡魔型態",
	normal_warning = "5 秒後可能惡魔型態",
	phase4_trigger = "你們就這點本事嗎?這就是你們全部的能耐?",
	phase4_soon_message = "階段 4 即將來臨!",
	phase4_message = "階段 4 - 瑪翼夫來臨!",

	burst = "烈焰爆擊",
	burst_desc = "當即將施放烈焰爆擊時發出警報",
	burst_message = "烈焰爆擊!",
	burst_cooldown_bar = "烈焰爆擊冷卻",
	burst_cooldown_warn = "烈焰爆擊即將來臨!",
	burst_warn = "烈焰爆擊 5 秒內來臨!",

	enrage_trigger = "感受一萬年的仇恨吧!",
	enrage_message = "狂怒!",

	["Flame of Azzinoth"] = "埃辛諾斯火焰",

	--very first yell to start engage timer
	illi_start = "阿卡瑪。你的謊言真是老套。我很久前就該殺了你和你那些畸形的同胞。",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"berserk", "phase", "parasite", "shear", "eyeblast", "barrage", "flame", "demons", "burst", "enrage", "proximity", "bosskill"}
mod.wipemobs = {L["Flame of Azzinoth"]}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "FlameBurst", 41126)
	self:AddCombatListener("SPELL_SUMMON", "Phase2", 39855)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Parasite", 41914, 41917)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Barrage", 40585)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shear", 41032)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 40932)
	self:AddCombatListener("SPELL_CAST_START", "Demons", 41117)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:FlameBurst(_, spellID)
	if db.burst then
		bCount = bCount + 1
		self:IfMessage(L["burst_message"], "Important", spellID, "Alert")
		if bCount < 3 then -- He'll only do three times before transforming again
			self:Bar(L["burst"], 20, spellID)
			self:DelayedMessage(15, L["burst_warn"], "Positive")
		end
	end
end

function mod:Phase2()
	if p2 then return end
	p2 = true

	self:TriggerEvent("BigWigs_RemoveRaidIcon")
	flamesDead = 0
	if db.barrage then
		self:Bar(L["barrage_warn_bar"], 80, "Spell_Shadow_PainSpike")
		self:DelayedMessage(77, L["barrage_warn"], "Important")
	end
	if db.phase then
		self:Message(L["phase2_message"], "Important", nil, "Alarm")
	end
end

function mod:Parasite(player, spellID)
	if db.parasite then
		local other = fmt(L["parasite_other"], player)
		if player == pName then
			self:LocalMessage(L["parasite_you"], "Personal", spellID, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", spellID)
		end
		self:Icon(player, "icon")
		self:Bar(other, 10, spellID)
	end
end

function mod:Barrage(player, spellID)
	if db.barrage then
		self:IfMessage(fmt(L["barrage_message"], player), "Important", spellID, "Alert")
		self:Bar(fmt(L["barrage_bar"], player), 10, spellID)

		self:Bar(L["barrage_warn_bar"], 50, spellID)
		self:ScheduleEvent("BarrageWarn", "BigWigs_Message", 47, L["barrage_warn"], "Important")
	end
end

function mod:Shear(player, spellID)
	if db.shear then
		self:IfMessage(fmt(L["shear_message"], player), "Important", spellID, "Alert")
		self:Bar(fmt(L["shear_bar"], player), 7, spellID)
	end
end

function mod:Flame(player)
	if db.flame then
		flamed[player] = true
		self:ScheduleEvent("FlameCheck", self.FlameWarn, 0.5, self)
	end
end

function mod:Demons()
	if db.demons then
		self:IfMessage(L["demons_message"], "Important", 41117, "Alert")
	end
end

function mod:Normal()
	self:Bar(L["normal_bar"], 70, "Spell_Shadow_Metamorphosis")
	self:ScheduleEvent("BWIlliNormalSoon", "BigWigs_Message", 65, L["normal_warning"], "Attention")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["eyeblast_trigger"] and db.eyeblast then
		self:Message(L["eyeblast_message"], "Important", nil, "Alert")
	elseif msg == L["demon_phase_trigger"] then
		bCount = 0
		if db.demons then
			self:Bar(L["demons"], 30, "Spell_Shadow_SoulLeech_3")
			self:DelayedMessage(25, L["demons_warn"], "Positive")
		end
		if db.phase then
			self:Message(L["demon_phase_message"], "Important", nil, "Alarm")
			self:Bar(L["demon_bar"], 65, "Spell_Shadow_Metamorphosis")
			self:ScheduleEvent("BWIlliDemonOver", "BigWigs_Message", 60, L["demon_warning"], "Attention")
			self:ScheduleEvent("BWIlliNormal", self.Normal, 60, self)
		end
		if db.burst then
			self:DelayedMessage(15, L["burst_cooldown_warn"], "Positive")
			self:Bar(L["burst_cooldown_bar"], 20, "Spell_Fire_BlueRainOfFire")
		end
	elseif msg == L["phase4_trigger"] then
		if db.phase then
			self:Message(L["phase4_message"], "Important", nil, "Alarm")
		end
		self:CancelScheduledEvent("BWIlliNormal")
		self:CancelScheduledEvent("BWIlliDemonOver")
		self:CancelScheduledEvent("BWIlliNormalSoon")
		self:TriggerEvent("BigWigs_StopBar", self, L["demon_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["normal_bar"])
		if db.phase then
			self:Bar(L["normal_bar"], 90, "Spell_Shadow_Metamorphosis")
			self:ScheduleEvent("BWIlliNormalSoon", "BigWigs_Message", 85, L["normal_warning"], "Attention")
		end
	elseif db.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important", nil, "Alert")
	elseif db.berserk and msg == L["berserk_trigger"] then
		self:Enrage(1500, true)
	elseif msg == L["illi_start"] then
		self:Bar(boss, 37, "Spell_Shadow_Charm")
		p2 = nil
	end
end

function mod:UNIT_HEALTH(msg)
	if UnitName(msg) == boss and db.phase then
		local hp = UnitHealth(msg)
		if hp > 65 and hp < 70 and not p2Announced then
			self:Message(L["phase2_soon_message"], "Attention")
			p2Announced = true
			for k in pairs(flamed) do flamed[k] = nil end
		elseif hp > 70 and p2Announced then
			p2Announced = nil
			p2 = nil
		elseif hp > 30 and hp < 35 and not p4Announced then
			self:Message(L["phase4_soon_message"], "Attention")
			p4Announced = true
			p2 = nil
		elseif hp > 35 and p4Announced then
			p4Announced = nil
		end
	end
end

function mod:Deaths(unit)
	if unit == L["Flame of Azzinoth"] then
		flamesDead = flamesDead + 1
		if flamesDead == 2 then
			if db.phase then
				self:Message(L["phase3_message"], "Important", nil, "Alarm")
				self:Bar(L["normal_bar"], 75, "Spell_Shadow_Metamorphosis")
				self:ScheduleEvent("BWIlliNormalSoon", "BigWigs_Message", 70, L["normal_warning"], "Attention")
			end
			self:CancelScheduledEvent("BarrageWarn")
			self:TriggerEvent("BigWigs_StopBar", self, L["barrage_warn_bar"])
			self:TriggerEvent("BigWigs_ShowProximity", self) -- Proximity Warning
		end
	elseif unit == boss then
		self:GenericBossDeath(unit)
	end
end

function mod:FlameWarn()
	local msg = nil
	for k in pairs(flamed) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(fmt(L["flame_message"], msg), "Important", 40932, "Alert")
	for k in pairs(flamed) do flamed[k] = nil end
end

