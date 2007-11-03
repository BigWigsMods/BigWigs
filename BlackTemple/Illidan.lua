------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Illidan Stormrage"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil
local db = nil
local bCount = 0
local p2Announced = nil
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
	demons_trigger = "Summon Shadow Demons",
	demons_message = "Shadow Demons!",
	demons_warn = "Demons Soon!",

	phase = "Phases",
	phase_desc = "Warns when Illidan goes into different stages.",
	phase2_soon_message = "Phase 2 soon!",
	phase2_trigger = "Blade of Azzinoth casts Summon Tear of Azzinoth.",
	phase2_message = "Phase 2 - Blades of Azzinoth!",
	phase3_message = "Phase 3!",
	demon_phase_trigger = "Behold the power... of the demon within!",
	demon_phase_message = "Demon Form!",
	demon_bar = "Next Normal Phase",
	phase4_trigger = "Is this it, mortals? Is this all the fury you can muster?",
	phase4_soon_message = "Phase 4 soon!",
	phase4_message = "Phase 4 - Maiev Incoming!",

	flameburst = "Flame Burst",
	flameburst_desc = "Warns when Illidan will use Flame Burst",
	flameburst_message = "Flame Burst!",
	flameburst_cooldown_bar = "Flame Burst cooldown",
	flameburst_cooldown_warn = "Flame Burst soon!",
	flameburst_warn = "Flame Burst in 5sec!",

	enrage_trigger = "Feel the hatred of ten thousand years!",
	enrage_message = "Enraged!",

	afflict_trigger = "^(%S+) (%S+) afflicted by (.+)%.$",
	["Flame of Azzinoth"] = true,
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
	demons_trigger = "Invocation de démons des ombres",
	demons_message = "Démons des ombres !",
	demons_warn = "Démons imminent !",

	phase = "Phases",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase2_soon_message = "Phase 2 imminente !",
	phase2_trigger = "Lame d'Azzinoth lance Invocation de la Larme d'Azzinoth.",
	phase2_message = "Phase 2 - Lames d'Azzinoth !",
	phase3_message = "Phase 3 !",
	demon_phase_trigger = "Contemplez la puissance... du démon intérieur !",
	demon_phase_message = "Forme de démon !",
	demon_bar = "Prochaine phase normale",
	phase4_trigger = "C'est tout, mortels ? Est-ce là toute la fureur que vous pouvez évoquer ?",
	phase4_soon_message = "Phase 4 imminente !",
	phase4_message = "Phase 4 - Arrivée de Maiev !",

	flameburst = "Explosion de flammes",
	flameburst_desc = "Préviens quand Illidan utilise son Explosion de flammes.",
	flameburst_message = "Explosion de flammes !",
	flameburst_cooldown_bar = "~Cooldown Explosion",
	flameburst_cooldown_warn = "Explosion de flammes imminente !",
	flameburst_warn = "Explosion de flammes dans 5 sec. !",

	enrage_trigger = "Goûtez à dix mille ans de haine !",
	enrage_message = "Enragé !",

	afflict_trigger = "^(%S+) (%S+) les effets [de|2]+ (.*).$",
	["Flame of Azzinoth"] = "Flamme d'Azzinoth",
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
	demons_trigger = "어둠의 악마 소환",
	demons_message = "어둠의 악마!",
	demons_warn = "잠시 후 어둠의 악마 소환!",

	phase = "단계",
	phase_desc = "일리단이 다른 형상으로 변경 시 알립니다.",
	phase2_soon_message = "잠시 후 2 단계!",
	phase2_trigger = "아지노스의 칼날|1이;가; 아지노스의 눈물 소환|1을;를; 시전합니다.",
	phase2_message = "2 단계 - 아지노스의 칼날!",
	phase3_message = "3 단계!",
	demon_phase_trigger = "내 안에 깃든... 악마의 힘을 보여주마!",
	demon_phase_message = "악마 형상!",
	demon_bar = "다음 보통 형상",
	phase4_trigger = "나만큼 널 증오하는 이가 또 있을까? 일리단! 네게 받아야 할 빚이 남았다!",
	phase4_soon_message = "잠시 후 4 단계!",
	phase4_message = "4 단계 - 마이에브 등장!",

	flameburst = "화염 폭발",
	flameburst_desc = "일리단이 화염 폭발 사용 시 알립니다.",
	flameburst_message = "화염 폭발!",
	flameburst_cooldown_bar = "화염 폭발 대기시간",
	flameburst_cooldown_warn = "잠시 후 화염 폭발!",
	flameburst_warn = "약 5초 이내 화염 폭발!",

	enrage_trigger = "만년 동안 응어리진 증오를 보여주마!",
	enrage_message = "격노!",

	afflict_trigger = "^([^|;%s]*)(%s+)(.*)에 걸렸습니다%.$",
	["Flame of Azzinoth"] = "아지노스의 불꽃",
} end )

L:RegisterTranslations("zhCN", function() return {
	berserk_trigger = "你们这是自寻死路！$",

	parasite = "寄生暗影魔",
	parasite_desc = "当队员中寄生暗影魔时发出警告.",
	parasite_you = "你中了>寄生暗影魔<!",
	parasite_other = "%s 中了>寄生暗影魔<!",

	icon = "团队标记",
	icon_desc = "为中了寄生暗影魔的队员打上团队标记.",

	barrage = "黑暗壁垒",
	barrage_desc = "当玩家中了黑暗壁垒时发出警报.",
	barrage_message = "%s 中了黑暗壁垒!",
	barrage_warn = "即将 黑暗壁垒!",
	barrage_warn_bar = "~下一波 黑暗壁垒",
	barrage_bar = "黑暗壁垒: %s",

	eyeblast = "魔眼冲击",
	eyeblast_desc = "当施放魔眼冲击时发出警报.",
	eyeblast_trigger = "直视背叛者的双眼吧！",
	eyeblast_message = "魔眼冲击!",

	shear = "剪切",
	shear_desc = "剪切玩家警报",
	shear_message = "剪切 %s!",
	shear_bar = "剪切: %s",

	flame = "苦痛之焰",--Agonizing Flames 苦痛之焰
	flame_desc = "当中了苦痛之焰时发出警报",
	flame_message = "%s 中了>苦痛之焰<!",

	demons = "影魔",
	demons_desc = "当伊利丹召唤影魔时发出警报.",
	demons_trigger = "召唤影魔",
	demons_message = "影魔!",
	demons_warn = "即将 影魔!",

	phase = "阶段",
	phase_desc = "当伊利丹进入不同阶段发出警报.",
	phase2_soon_message = "即将 -  第二阶段!",
	phase2_trigger = "埃辛诺斯之刃施放了召唤埃辛诺斯之类。$",--Update 10/31,Not my mistake，the combatlog really it is!
	phase2_message = "第二阶段 - 埃辛诺斯双刃!",
	phase3_message = "第三阶段!",
	demon_phase_trigger = "感受我体内的恶魔之力吧！",
	demon_phase_message = "影魔形态!",
	demon_bar = "下一次普通阶段",
	phase4_trigger = "你们就这点本事吗？这就是你们全部的能耐？",
	phase4_soon_message = "即将 - 第四阶段!",
	phase4_message = "第四阶段 - 玛维·影歌来临!",

	flameburst = "烈焰爆击",
	flameburst_desc = "当伊利丹使用烈焰爆击发出警报",
	flameburst_message = "烈焰爆击!",
	flameburst_cooldown_bar = "烈焰爆击 冷却",
	flameburst_cooldown_warn = "即将 烈焰爆击!",
	flameburst_warn = "5秒后 烈焰爆击!",

	enrage_trigger = "Feel the hatred of ten thousand years!",
	enrage_message = "狂暴!",

	afflict_trigger = "^([^%s]+)受([^%s]+)了([^%s]+)效果的影响。$",--%s受到了%s效果的影响。
	["Flame of Azzinoth"] = "埃辛诺斯之焰",
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
	demons_trigger = "zaubert Schattendämonen",
	demons_message = "Schattendämonen!",
	demons_warn = "Dämonen Bald!",

	phase = "Phasen",
	phase_desc = "Warnt wenn Illidan in die verschiedenen Phasen geht.",
	phase2_soon_message = "Phase 2 Bald!",
	phase2_trigger = "Klinge von Azzinoth wirkt Träne von Azzinoth beschwören.",
	phase2_message = "Phase 2 - Klingen von Azzinoth!",
	phase3_message = "Phase 3!",
	demon_phase_trigger = "Erzittert vor der Macht des Dämonen!",
	demon_phase_message = "Dämonen Form!",
	demon_bar = "Nächste Normale Phase",
	phase4_trigger = "War's das schon. Sterbliche? Ist das alles was Ihr zu bieten habt??",
	phase4_soon_message = "Phase 4 bald!",
	phase4_message = "Phase 4 - Maiev kommt!",

	flameburst = "Flammenschlag",
	flameburst_desc = "Warnt wenn Illidan Flammenschlag benutzen wird.",
	flameburst_message = "Flammenschlag!",
	flameburst_cooldown_bar = "Flammenschlag cooldown",
	flameburst_cooldown_warn = "Flammenschlag bald!",
	flameburst_warn = "Flammenschlag in 5sek!",

	enrage_trigger = "Fühlt dem Haß von 10 tausend Jahren!",
	enrage_message = "Wütend!",

	afflict_trigger = "^(%S+) (%S+) ist von (.*) betroffen.$",
	["Flame of Azzinoth"] = "Flamme von Azzinoth",
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

	shear = "Shear",
	shear_desc = "Warn about Shear on players.",
	shear_message = "Shear on %s!",
	shear_bar = "Shear: %s",

	flame = "苦惱之焰",
	flame_desc = "當玩家中了苦惱之焰時發出警報",
	flame_message = "苦惱之焰：[%s]",

	demons = "暗影惡魔",
	demons_desc = "當召喚暗影惡魔時發出警報",
	demons_trigger = "召喚暗影惡魔",
	demons_message = "暗影惡魔!",
	demons_warn = "暗影惡魔即將來臨!",

	phase = "階段",
	phase_desc = "當變換不同階段時發出警報",
	phase2_soon_message = "階段 2 即將來臨!",
	phase2_trigger = "埃辛諾斯之刃施放了召喚埃辛諾斯之淚。",
	phase2_message = "階段 2 - 埃辛諾斯之刃!",
	phase3_message = "階段 3!",
	demon_phase_trigger = "感受我體內的惡魔之力吧!",
	demon_phase_message = "惡魔型態!",
	demon_bar = "下一個普通階段",
	phase4_trigger = "你們就這點本事嗎?這就是你們全部的能耐?",
	phase4_soon_message = "階段 4 即將來臨!",
	phase4_message = "階段 4 - 瑪翼夫來臨!",

	flameburst = "烈焰爆擊",
	flameburst_desc = "當即將施放烈焰爆擊時發出警報",
	flameburst_message = "烈焰爆擊!",
	flameburst_cooldown_bar = "烈焰爆擊冷卻",
	flameburst_cooldown_warn = "烈焰爆擊即將來臨!",
	flameburst_warn = "烈焰爆擊 5 秒內來臨!",

	enrage_trigger = "感受一萬年的仇恨吧!",
	enrage_message = "狂怒!",

	afflict_trigger = "^(.+)受(到[了]*)(.*)效果的影響。$",
	["Flame of Azzinoth"] = "埃辛諾斯火焰",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"berserk", "phase", "parasite", "shear", "eyeblast", "barrage", "flame", "demons", "flameburst", "enrage", "proximity", "bosskill"}
mod.wipemobs = {L["Flame of Azzinoth"]}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3.5 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "IliPara", 1.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliBara", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliFlame", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliDemons", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliBurst", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliPhase2", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliFlameDied", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliShear", 3)

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_SPELLCAST_START")

	pName = UnitName("player")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "IliPara" and rest and db.parasite then
		local other = fmt(L["parasite_other"], rest)
		if rest == pName then
			self:Message(L["parasite_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		else
			self:Message(other, "Attention")
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		end
		if db.icon then
			self:Icon(rest)
		end
	elseif sync == "IliBara" and rest and db.barrage then
		self:Message(fmt(L["barrage_message"], rest), "Important", nil, "Alert")
		self:Bar(fmt(L["barrage_bar"], rest), 10, "Spell_Shadow_PainSpike")

		self:Bar(L["barrage_warn_bar"], 50, "Spell_Shadow_PainSpike")
		self:ScheduleEvent("BarrageWarn", "BigWigs_Message", 47, L["barrage_warn"], "Important")

	elseif sync == "IliFlame" and rest and db.flame then
		flamed[rest] = true
		self:ScheduleEvent("FlameCheck", self.FlameWarn, 1, self)
	elseif sync == "IliDemons" and db.demons then
		self:Message(L["demons_message"], "Important", nil, "Alert")
	elseif sync == "IliBurst" and db.flameburst then
		bCount = bCount + 1
		self:Message(L["flameburst_message"], "Important", nil, "Alert")
		if bCount < 3 then -- He'll only do three times before transforming again
			self:Bar(L["flameburst"], 20, "Spell_Fire_BlueRainOfFire")
			self:DelayedMessage(15, L["flameburst_warn"], "Positive")
		end
	elseif sync == "IliPhase2" then
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		flamesDead = 0
		if db.barrage then
			self:Bar(L["barrage_warn_bar"], 80, "Spell_Shadow_PainSpike")
			self:DelayedMessage(77, L["barrage_warn"], "Important")
		end
		if db.phase then
			self:Message(L["phase2_message"], "Important", nil, "Alarm")
		end
	elseif sync == "IliFlameDied" then
		flamesDead = flamesDead + 1
		if flamesDead == 2 then
			if db.phase then
				self:Message(L["phase3_message"], "Important", nil, "Alarm")
				self:TriggerEvent("BigWigs_ShowProximity", self) -- Proximity Warning
			end
			self:CancelScheduledEvent("BarrageWarn")
		end
	elseif sync == "IliShear" and db.shear and rest then
		self:Message(fmt(L["shear_message"], rest), "Important", nil, "Alert")
		self:Bar(fmt(L["shear_bar"], rest), 7, "Spell_Shadow_FocusedPower")
	end
end

function mod:AfflictEvent(msg)
	local player, type, spell = select(3, msg:find(L["afflict_trigger"]))
	if player and type then
		if player == L2["you"] and type == L2["are"] then
			player = pName
		end
		if spell == L["parasite"] then
			self:Sync("IliPara", player)
		elseif spell == L["barrage"] then
			self:Sync("IliBara", player)
		elseif spell == L["flame"] then
			self:Sync("IliFlame", player)
		elseif spell == L["shear"] then
			self:Sync("IliShear", player)
		end
	end
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
		end
		if db.flameburst then
			self:DelayedMessage(15, L["flameburst_cooldown_warn"], "Positive")
			self:Bar(L["flameburst_cooldown_bar"], 20, "Spell_Fire_BlueRainOfFire")
		end
	elseif msg == L["phase4_trigger"] then
		if db.phase then
			self:Message(L["phase4_message"], "Important", nil, "Alarm")
		end
	elseif db.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important", nil, "Alert")
	elseif db.berserk and msg == L["berserk_trigger"] then
		self:Message(fmt(L2["berserk_start"], boss, 25), "Attention")
		self:DelayedMessage(600, fmt(L2["berserk_min"], 15), "Positive")
		self:DelayedMessage(900, fmt(L2["berserk_min"], 10), "Positive")
		self:DelayedMessage(1200, fmt(L2["berserk_min"], 5), "Positive")
		self:DelayedMessage(1320, fmt(L2["berserk_min"], 3), "Positive")
		self:DelayedMessage(1440, fmt(L2["berserk_min"], 1), "Positive")
		self:DelayedMessage(1470, fmt(L2["berserk_sec"], 30), "Positive")
		self:DelayedMessage(1490, fmt(L2["berserk_sec"], 10), "Urgent")
		self:DelayedMessage(1495, fmt(L2["berserk_sec"], 5), "Urgent")
		self:DelayedMessage(1500, fmt(L2["berserk_end"], boss), "Attention", nil, "Alarm")
		self:Bar(L2["berserk"], 1500, "Spell_Nature_Reincarnation")
	end
end

function mod:CHAT_MSG_SPELL_SELF_DAMAGE(msg)
	if msg:find(L["flameburst"]) then
		self:Sync("IliBurst")
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["demons_trigger"] then
		self:Sync("IliDemons")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["phase2_trigger"] then
		self:Sync("IliPhase2")
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
		elseif hp > 30 and hp < 35 and not p4Announced then
			self:Message(L["phase4_soon_message"], "Attention")
			p4Announced = true
		elseif hp > 35 and p4Announced then
			p4Announced = nil
		end
	end
end

do
	local flameDies = fmt(UNITDIESOTHER, L["Flame of Azzinoth"])
	function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
		if msg == flameDies then
			self:Sync("IliFlameDied")
		else
			self:GenericBossDeath(msg)
		end
	end
end

function mod:FlameWarn()
	if db.flame then
		local msg = nil
		for k in pairs(flamed) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(fmt(L["flame_message"], msg), "Important", nil, "Alert")
	end
	for k in pairs(flamed) do flamed[k] = nil end
end
