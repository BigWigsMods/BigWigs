------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Kil'jaeden"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local CheckInteractDistance = CheckInteractDistance

local db = nil
local started = nil
local deaths = 0
local bcount = 0
local pName = UnitName("player")
local bloomed = {}
local phase = nil
local sinister1 = nil
local sinister2 = nil
local sinister3 = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "KilJaeden",

	bomb = "Darkness",
	bomb_desc = "Warn when Darkness of a Thousand Souls is being cast.",
	bomb_cast = "Incoming Big Bomb!",
	bomb_bar = "Explosion!",
	bomb_nextbar = "~Possible Bomb",
	bomb_warning = "Possible bomb in ~10sec",
	blueorb_message = "Blue Dragonflight Orb ready!",
	kalec_yell = "I will channel my powers into the orbs! Be ready!",
	kalec_yell2 = "I have empowered another orb! Use it quickly!",
	kalec_yell3 = "Another orb is ready! Make haste!",
	kalec_yell4 = "I have channeled all I can! The power is in your hands!",

	orb = "Shield Orb",
	orb_desc = "Warn when a Shield Orb is shadowbolting.",
	orb_shooting = "Orb Alive - Shooting People!",

	bloom = "Fire Bloom",
	bloom_desc = "Tells you who has been hit by Fire Bloom.",
	bloom_other = "Fire Bloom on %s!",
	bloom_bar = "Fire Blooms",
	bloom_message = "Next Fire Bloom in 5 seconds!",

	bloomsay = "Fire Bloom Say",
	bloomsay_desc = "Place a msg in say notifying that you have Fire Bloom",
	bloom_say = "Fire Bloom on "..strupper(pName).."!",

	bloomwhisper = "Fire Bloom Whisper",
	bloomwhisper_desc = "Whisper players with Fire Bloom.",
	bloom_you = "Fire Bloom on YOU!",

	icons = "Bloom Icons",
	icons_desc = "Place random Raid Icons on players with Fire Bloom (requires promoted or higher)",

	shadow = "Shadow Spike",
	shadow_desc = "Raid warn of casting of Shadow Spike.",
	shadow_message = "Shadow Spikes Inc For 28sec! WATCH OUT!",
	shadow_bar = "Shadow Spikes Expire",
	shadow_warning = "Shadow Spikes Done in 5 sec!",
	shadow_debuff_bar = "Reduced Healing on %s",

	shadowdebuff = "Disable Shadow Bars",
	shadowdebuff_desc = "Timer bars for players affected by the Shadow Debuff",

	flame = "Flame Dart",
	flame_desc = "Show Flame Dart timer bar.",
	flame_bar = "Next Flame Dart",
	flame_message = "Next Flame Dart in 5 seconds!",

	sinister = "Sinister Reflections",
	sinister_desc = "Warns on Sinister Reflection spawns.",
	sinister_warning = "Sinister Reflections Soon!",
	sinister_message = "Sinister Reflections Up!",

	shield_up = "Shield is UP!",

	deceiver_dies = "Deciever #%d Killed",
	["Hand of the Deceiver"] = true,

	phase = "Phase",
	phase_desc = "Warn for phase changes.",
	phase2_message = "Phase 2 - Kil'jaeden incoming!",
	phase3_trigger = "I will not be denied! This world shall fall!",
	phase3_message = "Phase 3 - add Darkness",
	phase4_trigger = "Do not harbor false hope. You cannot win!",
	phase4_message = "Phase 4 - add Meteor",
	phase5_trigger = "Ragh! The powers of the Sunwell turn against me! What have you done? What have you done?!",
	phase5_message = "Phase 5 - Sacrifice of Anveena",
} end )

L:RegisterTranslations("koKR", function() return {
	bomb = "어둠의 영혼",
	bomb_desc = "무수한 어둠의 영혼 시전 시 알립니다.",
	bomb_cast = "잠시 후 큰 폭탄!",
	bomb_bar = "폭발!",
	bomb_nextbar = "~폭탄 가능",
	bomb_warning = "약 10초 이내 폭탄 가능!",
	blueorb_message = "푸른용군단의 수정구 준비됨!",
	kalec_yell = "수정구에 힘을 쏟겠습니다! 준비하세요!",
	kalec_yell2 = "다른 수정구에 힘을 불어넣었습니다! 어서요!",
	kalec_yell3 = "다른 수정구가 준비됐습니다! 서두르세요!",	--check
	kalec_yell4 = "모든 힘을 수정구에 실었습니다! 이제 그대들의 몫입니다!",

	orb = "보호의 구슬",
	orb_desc = "보호의 구슬의 어둠 화살을 알립니다.",
	orb_shooting = "구슬 활동 - 어활 공격!",

	bloom = "화염 불꽃",
	bloom_desc = "화염 불꽃에 걸린 플레이어를 알립니다.",
	bloom_other = "%s 화염 불꽃!",
	bloom_bar = "화염 불꽃",
	bloom_message = "5초 후 다음 화염 불꽃!",

	bloomsay = "화염 불꽃 대화",
	bloomsay_desc = "자신이 화염 불꽃이 걸렸을시 일반 대화로 출력합니다.",
	bloom_say = ""..strupper(pName).." 화염 불꽃!",

	bloomwhisper = "화염 불꽃 귓속말",
	bloomwhisper_desc = "화염 불꽃에 걸린 플레이어에게 귓속말로 알립니다.",
	bloom_you = "당신은 화염 불꽃!",

	icons = "불꽃 전술 표시",
	icons_desc = "화염 불꽃에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	shadow = "어둠의 쐐기",
	shadow_desc = "어둠의 쐐기에 대하여 공격대에 알립니다.",
	shadow_message = "잠시 후 28초간 어둠의 쐐기! 조심하세요!",
	shadow_bar = "어둠의 쐐기 종료",
	shadow_warning = "5초 후 어둠의 쐐기 종료!",
	shadow_debuff_bar = "%s 치유효과 감소",

	--shadowdebuff = "Disable Shadow Bars",
	--shadowdebuff_desc = "Timer bars for players affected by the Shadow Debuff",

	flame = "불꽃 화살",
	flame_desc = "불꽃 화살 타이머 바를 표시합니다.",
	flame_bar = "다음 불꽃 화살",
	flame_message = "5초 후 다음 불꽃 화살!",

	sinister = "사악한 환영",
	sinister_desc = "사악한 환영 생성을 알립니다.",
	sinister_warning = "잠시 후 사악한 환영!",
	sinister_message = "사악한 환영!",

	shield_up = "푸른용의 보호막!",

	deceiver_dies = "심복 #%d 처치",
	["Hand of the Deceiver"] = "기만자의 심복",

	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	phase2_message = "2 단계- 킬제덴!",
	phase3_trigger = "나를 부정할 수는 없다! 이 세계는 멸망하리라!",
	phase3_message = "3 단계 - 어둠의 영혼 추가",
	phase4_trigger = "헛된 꿈을 꾸고 있구나! 너흰 이길 수 없어!",
	phase4_message = "4 단계 - 유성 추가",
	phase5_trigger = "으아! 태양샘의 마력이... 나를... 거부한다! 무슨 짓을 한 거지? 무슨 짓을 한 거냐???",
	phase5_message = "5 단계 - 안비나의 희생",
} end )

L:RegisterTranslations("frFR", function() return {
	bomb = "Ténèbres des mille âmes",
	bomb_desc = "Prévient quand les Ténèbres des mille âmes sont incantés.",
	bomb_cast = "Arrivée d'une énorme bombe !",
	bomb_bar = "Explosion !",
	bomb_nextbar = "~Bombe probable",
	bomb_warning = "Bombe probable dans ~10 sec.",
	blueorb_message = "Orbe du Vol bleu prêt !",
	kalec_yell = "Je vais canaliser mon énergie vers les orbes ! Préparez-vous !", -- à vérifier
	kalec_yell2 = "J'ai chargé un autre orbe ! Utilisez-le vite !", -- à vérifier
	kalec_yell3 = "Un autre orbe est prêt ! Hâtez-vous !", -- à vérifier
	kalec_yell4 = "J'ai envoyé tout ce que je pouvais ! La puissance est entre vos mains !", -- à vérifier

	orb = "Orbe bouclier",
	orb_desc = "Prévient quand un Orbe bouclier lance des Traits de l'ombre.",
	orb_shooting = "Orbe en vie - Bombardement de traits !",

	bloom = "Fleurs du feu",
	bloom_desc = "Prévient quand des joueurs subissent les effets de la Fleur du feu.",
	bloom_other = "Fleur du feu sur %s !",
	bloom_bar = "Fleurs du feu",
	bloom_message = "Prochaines Fleurs du feu dans 5 sec. !",

	bloomsay = "Dire - Fleur du feu",
	bloomsay_desc = "Fait dire à votre personnage qu'il subit les effets de la Fleur du feu quand c'est le cas, afin d'aider les membres proches ayant les bulles de dialogue activées.",
	bloom_say = "Fleur du feu sur "..strupper(pName).." !",

	bloomwhisper = "Chuchoter",
	bloomwhisper_desc = "Prévient par chuchotement les derniers joueurs affectés par la Fleur du feu (nécessite d'être promu ou mieux).",
	bloom_you = "Fleur du feu sur VOUS !",

	icons = "Icônes",
	icons_desc = "Place une icône de raid sur les derniers joueurs affectés par la Fleur du feu (nécessite d'être promu ou mieux).",

	shadow = "Pointes de l'ombre",
	shadow_desc = "Prévient quand les Pointes de l'ombre sont incantées.",
	shadow_message = "Pointes de l'ombre pendant 28 sec. !",
	shadow_bar = "Fin des Pointes",
	shadow_warning = "Pointes de l'ombre terminées dans 5 sec. !",
	shadow_debuff_bar = "Soins réduits sur %s",

	shadowdebuff = "Pas de barres des Pointes",
	shadowdebuff_desc = "Désactive les barres temporelles des joueurs affectés par les Pointe de l'ombre si coché.",

	flame = "Fléchettes des flammes",
	flame_desc = "Affiche une barre temporelle pour les Flèchettes des flammes.",
	flame_bar = "Prochaines Fléchettes",
	flame_message = "Prochaines Fléchettes des flammes dans 5 sec. !",

	sinister = "Reflets sinistres",
	sinister_desc = "Prévient quand les Reflets sinistres apparaissent.",
	sinister_warning = "Reflets sinistres imminents !",
	sinister_message = "Reflets sinistres actifs !",

	shield_up = "Bouclier ACTIF !",

	deceiver_dies = "Trompeur #%d tué",
	["Hand of the Deceiver"] = "Main du Trompeur", -- à vérifier

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase2_message = "Phase 2 - Arrivée de Kil'jaeden !",
	phase3_trigger = "Rien ne m'arrêtera ! Ce monde va tomber !", -- à vérifier
	phase3_message = "Phase 3 - Ajout des Ténèbres des mille âmes",
	phase4_trigger = "Assez de faux espoirs. Vous ne pouvez pas gagner !", -- à vérifier
	phase4_message = "Phase 4 - Ajout des Météores",
	phase5_trigger = "Nooon ! Les pouvoirs du Puits de soleil se retournent contre moi ! Qu'avez-vous fait ? Qu'avez-vous fait ?!", -- à vérifier
	phase5_message = "Phase 5 - Sacrifice d'Anveena",
} end )

L:RegisterTranslations("zhCN", function() return {
	bomb = "千魂之暗",
	bomb_desc = "当千魂之暗开始施放时发出警报。",
	bomb_cast = "即将 千魂之暗！",
	bomb_bar = "<千魂之暗>",
	bomb_nextbar = "<可能 千魂之暗>",
	bomb_warning = "约10秒后，可能千魂之暗！",
	blueorb_message = "蓝龙宝珠已准备好！",
	kalec_yell = "我会将我的力量导入宝珠中！准备好！",
	kalec_yell2 = "我又将能量灌入了另一颗宝珠！快去使用它！",
	kalec_yell3 = "又有一颗宝珠准备好了！快点行动！",
	kalec_yell4 = "这是我所能做的一切了！力量现在掌握在你们的手中！",

	orb = "护盾宝珠",
	orb_desc = "当护盾宝珠施放暗影箭时发出警报。",
	orb_shooting = "护盾宝珠 - 暗影箭！",

	bloom = "火焰之花",
	bloom_desc = "当玩家中了火焰之花时发出警报。",
	bloom_other = "火焰之花：>%s<！",
	bloom_bar = "<火焰之花>",
	bloom_message = "5秒后，火焰之花！",

	bloomsay = "火焰之花提醒",
	bloomsay_desc = "当你中了火焰之花时通知周围的玩家。",
	bloom_say = ">"..strupper(pName).."< 中了火焰之花！",

	bloomwhisper = "火焰之花密语",
	bloomwhisper_desc = "当玩家中了火焰之花时密语提示他离开。",
	bloom_you = ">你< 中了火焰之花！",

	icons = "团队标记",
	icons_desc = "为中了火焰之花的玩家随机打上一个团队标记。（需要权限）",

	shadow = "暗影之刺",
	shadow_desc = "当施放暗影之刺时发出警报。",
	shadow_message = "28秒后，>暗影之刺<！当心！",
	shadow_bar = "<暗影之刺>",
	shadow_warning = "5秒后，暗影之刺！",
	shadow_debuff_bar = "<降低治疗：%s>",

	shadowdebuff = "禁用暗影减益计时条",
	shadowdebuff_desc = "玩家中了暗影减益效果计时条。",

	flame = "烈焰之刺",
	flame_desc = "显示烈焰之刺记时条。",
	flame_bar = "<下一烈焰之刺>",
	flame_message = "5秒后，烈焰之刺！",

	sinister = "邪恶镜像",
	sinister_desc = "当邪恶镜像时发出警报。",
	sinister_warning = "即将 邪恶镜像！",
	sinister_message = "邪恶镜像 出现！",

	shield_up = ">蓝龙之盾< 启用！",

	deceiver_dies = "已杀死基尔加丹之手#%d",
	["Hand of the Deceiver"] = "基尔加丹之手",

	phase = "阶段",
	phase_desc = "当进入不同阶段时发出警报。",
	phase2_message = "第二阶段 - 基尔加丹来临！",
	phase3_trigger = "我是不会失败的！这个世界注定要毁灭！",
	phase3_message = "第三阶段 - 注意千魂之暗！",
	phase4_trigger = "别再抱有幻想了！你们不可能赢！",
	phase4_message = "第四阶段 - 注意流星！",
	phase5_trigger = "啊啊啊！太阳之井的能量……开始……对抗我！你们都做了些什么？你们都做了些什么？？",
	phase5_message = "第五阶段 - 牺牲安薇娜！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local deceiver = L["Hand of the Deceiver"]
local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = {deceiver, boss}
mod.toggleoptions = {"phase", -1, "bomb", "orb", "flame", -1, "bloom", "bloomwhisper", "bloomsay", "icons", -1, "sinister", "shadow", "shadowdebuff", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Sinister", 45892)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shield", 45848)
	self:AddCombatListener("SPELL_DAMAGE", "Orb", 45680)
	self:AddCombatListener("SPELL_MISSED", "Orb", 45680)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Bloom", 45641)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shadow", 45885)
	self:AddCombatListener("SPELL_CAST_START", "ShadowCast", 46680)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	started = nil
	deaths = 0
	phase = 0
	for i = 1, #bloomed do bloomed[i] = nil end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Sinister()
	if db.sinister then
		self:IfMessage(L["sinister_message"], "Attention", 45892)
	end
	if db.flame then
		self:Bar(L["flame_bar"], 60, 45737)
		self:DelayedMessage(55, L["flame_message"], "Attention")
	end
end

function mod:Shield()
	self:IfMessage(L["shield_up"], "Urgent", 45848)
end

local last = 0
function mod:Orb()
	local time = GetTime()
	if (time - last) > 10 then
		last = time
		if db.orb then
			self:IfMessage(L["orb_shooting"], "Attention", 45680, "Alert")
		end
	end
end

function mod:Deaths(unit)
	if unit == deceiver then
		deaths = deaths + 1
		self:IfMessage(L["deceiver_dies"]:format(deaths), "Positive")
		if deaths == 3 then
			phase = 2
			self:Message(L["phase2_message"], "Attention")
			self:Bar(boss, 10, "Spell_Shadow_Charm")
			self:TriggerEvent("BigWigs_ShowProximity", self)
		end
	elseif unit == boss then
		self:GenericBossDeath(unit)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, unit)
	if unit == boss and db.bomb then
		self:Bar(L["bomb_bar"], 8, "Spell_Shadow_BlackPlague")
		self:IfMessage(L["bomb_cast"], "Positive")
		if phase == 3 or phase == 4 then
			bCount = bCount + 1
			if bCount < 2 then -- only do two times before next Orbs yell
				self:Bar(L["bomb_nextbar"], 46, "Spell_Shadow_BlackPlague")
				self:DelayedMessage(36, L["bomb_warning"], "Attention")
			end
		elseif phase == 5 then
			self:Bar(L["bomb_nextbar"], 25, "Spell_Shadow_BlackPlague")
			self:DelayedMessage(15, L["bomb_warning"], "Attention")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L["kalec_yell"] or msg == L["kalec_yell2"] or msg == L["kalec_yell3"]) and db.bomb then
		bCount = 0
		self:IfMessage(L["blueorb_message"], "Attention")
		self:Bar(L["bomb_nextbar"], 40, "Spell_Shadow_BlackPlague")
		self:DelayedMessage(30, L["bomb_warning"], "Attention")
	elseif msg == L["kalec_yell4"] and db.bomb then
		self:IfMessage(L["blueorb_message"], "Attention")
		self:Bar(L["bomb_nextbar"], 13, "Spell_Shadow_BlackPlague")
		self:DelayedMessage(3, L["bomb_warning"], "Attention")
	elseif msg == L["phase3_trigger"] then
		phase = 3
		self:IfMessage(L["phase3_message"], "Attention")
	elseif msg == L["phase4_trigger"] then
		phase = 4
		self:IfMessage(L["phase4_message"], "Attention")
	elseif msg == L["phase5_trigger"] then
		phase = 5
		self:IfMessage(L["phase5_message"], "Attention")
	end
end

function mod:ShadowCast(_, spellID)
	if db.shadow then
		self:Bar(L["shadow_bar"], 28.7, spellID)
		self:IfMessage(L["shadow_message"], "Attention", spellID)
		self:DelayedMessage(23.7, L["shadow_warning"], "Attention")
	end
end

function mod:Shadow(player, spellId)
	if not db.shadowdebuff then
		self:Bar(L["shadow_debuff_bar"]:format(player), 10, spellId) 
	end
end

function mod:Bloom(player)
	if db.bloom then
		tinsert(bloomed, player)
		self:Whisper(player, L["bloom_you"], "bloomwhisper")
		self:ScheduleEvent("BWBloomWarn", self.BloomWarn, 0.4, self)
		if player == pName and db.bloomsay then
			self:LocalMessage(L["bloom_you"], "Personal", 45641, "Long")
			SendChatMessage(L["bloom_say"], "SAY")
		end
	end
end

function mod:BloomWarn()
	local msg = nil
	table.sort(bloomed)

	for i,v in ipairs(bloomed) do
		if not msg then
			msg = v
		else
			msg = msg .. ", " .. v
		end
		if db.icons then
			SetRaidTarget(v, i)
		end
	end

	self:IfMessage(L["bloom_other"]:format(msg), "Important", 45641, "Alert")
	self:Bar(L["bloom_bar"], 20, 45641)
	self:DelayedMessage(15, L["bloom_message"], "Attention")
	for i = 1, #bloomed do bloomed[i] = nil end
end

function mod:UNIT_HEALTH(msg)
	if UnitName(msg) == boss and db.sinister then
		local health = UnitHealth(msg)
		if not sinister1 and health > 86 and health <= 88 then
			sinister1 = true
			self:Message(L["sinister_warning"], "Attention")
		elseif not sinister2 and health > 56 and health <= 58 then
			sinister2 = true
			self:Message(L["sinister_warning"], "Attention")
		elseif not sinister3 and health > 26 and health <= 28 then
			sinister3 = true
			self:Message(L["sinister_warning"], "Attention")
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		phase = 1
		sinister1 = nil
		sinister2 = nil
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end
