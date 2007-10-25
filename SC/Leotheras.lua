------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Leotheras the Blind"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local imagewarn = nil
local beDemon = {}
local pName = nil
local fmt = string.format
local stop

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Leotheras",

	enrage_trigger = "Finally, my banishment ends!",

	whirlwind = "Whirlwind",
	whirlwind_desc = "Whirlwind Timers.",
	whirlwind_trigger = "Leotheras the Blind gains Whirlwind.",
	whirlwind_gain = "Whirlwind for 12 sec",
	whirlwind_fade = "Whirlwind Over",
	whirlwind_bar = "Whirlwind",
	whirlwind_bar2 = "~Whirlwind Cooldown",
	whirlwind_warn = "Whirlwind Cooldown Over - Inc Soon",

	phase = "Demon Phase",
	phase_desc = "Estimated demon phase timers.",
	phase_trigger = "Be gone, trifling elf.  I am in control now!",
	phase_demon = "Demon Phase for 60sec",
	phase_demonsoon = "Demon Phase in 5sec!",
	phase_normalsoon = "Normal Phase in 5sec",
	phase_normal = "Normal Phase!",
	demon_bar = "Demon Phase",
	demon_nextbar = "Next Demon Phase",

	mindcontrol = "Mind Control",
	mindcontrol_desc = "Warn which players are Mind Controlled.",
	mindcontrol_trigger = "^(%S+) (%S+) afflicted by Consuming Madness%.$",
	mindcontrol_warning = "Mind Controlled: %s",

	image = "Image",
	image_desc = "15% Image Split Alerts.",
	image_trigger = "No... no! What have you done? I am the master! Do you hear me? I am... aaggh! Can't... contain him.",
	image_message = "15% - Image Created!",
	image_warning = "Image Soon!",

	whisper = "Insidious Whisper",
	whisper_desc = "Alert what players have Insidious Whisper.",
	whisper_trigger = "^(%S+) (%S+) afflicted by Insidious Whisper%.$",
	whisper_message = "Demon: %s",
	whisper_bar = "Demons Despawn",
	whisper_soon = "~Demons Cooldown",
} end )

L:RegisterTranslations("koKR", function() return {
	enrage_trigger = "드디어, 내가 풀려났도다!",

	whirlwind = "소용돌이",
	whirlwind_desc = "소용돌이에 대한 타이머입니다.",
	whirlwind_trigger = "눈먼 레오테라스|1이;가; 소용돌이 효과를 얻었습니다.",
	whirlwind_gain = "12초간 소용돌이",
	whirlwind_fade = "소용돌이 종료",
	whirlwind_bar = "소용돌이",
	whirlwind_bar2 = "~소용돌이 대기시간",
	whirlwind_warn = "소용돌이 대기시간 종료 - 잠시 후",

	phase = "악마 형상",
	phase_desc = "악마 형상 예측 타이머입니다.",
	phase_trigger = "꺼져라, 엘프 꼬맹이. 지금부터는 내가 주인이다!",
	phase_demon = "60초간 악마 형상",
	phase_demonsoon = "악마 형상 5초 전!",
	phase_normalsoon = "보통 형상 5초 전",
	phase_normal = "보통 형상!",
	demon_bar = "악마 형상",
	demon_nextbar = "다음 악마 형상",

	mindcontrol = "정신 지배",
	mindcontrol_desc = "정신 지배에 걸린 플레이어를 알립니다.",
	mindcontrol_trigger = "^([^|;%s]*)(.*)잠식하는 광기에 걸렸습니다%.$",
	mindcontrol_warning = "정신 지배: %s",

	image = "이미지",
	image_desc = "15% 이미지 분리에 대한 경고입니다.",
	image_trigger = "안 돼... 안 돼! 무슨 짓이냐? 내가 주인이야! 내 말 듣지 못해? 나란 말이야! 내가... 으아악! 놈을 억누를 수... 없... 어.",
	image_message = "15% - 이미지 생성!",
	image_warning = "곧 이미지!",

	whisper = "음흉한 속삭임",
	whisper_desc = "음흉한 속삭임에 걸린 플레이어를 알립니다.",
	whisper_trigger = "^([^|;%s]*)(.*)음흉한 속삭임에 걸렸습니다%.$",
	whisper_message = "악마: %s",
	whisper_bar = "악마 사라짐",
	whisper_soon = "~악마 대기시간",
} end )

L:RegisterTranslations("frFR", function() return {
	enrage_trigger = "Enfin, mon exil s'achève !",

	whirlwind = "Tourbillon",
	whirlwind_desc = "Affiche les différentes durées concernant le Tourbillon.",
	whirlwind_trigger = "Leotheras l'Aveugle gagne Tourbillon.",
	whirlwind_gain = "Tourbillon pendant 12 sec.",
	whirlwind_fade = "Fin du Tourbillon",
	whirlwind_bar = "Tourbillon",
	whirlwind_bar2 = "~Cooldown Tourbillon",
	whirlwind_warn = "Fin du cooldown Tourbillon - Imminent !",

	phase = "Phase démon",
	phase_desc = "Affiche une estimation de la phase démon.",
	phase_trigger = "Hors d'ici, elfe insignifiant. Je prends le contrôle !", -- à vérifier
	phase_demon = "Phase démon pendant 60 sec.",
	phase_demonsoon = "Phase démon dans 5 sec. !",
	phase_normalsoon = "Phase normal dans 5 sec.",
	phase_normal = "Phase normale !",
	demon_bar = "Phase démon",
	demon_nextbar = "Prochaine phase démon",

	mindcontrol = "Contrôle mental",
	mindcontrol_desc = "Préviens quand un joueur subit les effets du Contrôle mental.",
	mindcontrol_trigger = "^(%S+) (%S+) les effets .* Folie dévorante%.$",
	mindcontrol_warning = "Contrôle mental : %s",

	image = "Image",
	image_desc = "Préviens quand l'image est créée à 15%.",
	image_trigger = "Non… Non ! Mais qu'avez-vous fait ? C'est moi le maître ! Vous entendez ? Moi ! Je suis… Aaargh ! Impossible… de… retenir…", -- à vérifier
	image_message = "15% - Image créée !",
	image_warning = "Image imminente !",

	whisper = "Murmure insidieux",
	whisper_desc = "Préviens quand des joueurs subissent le Murmure insidieux.",
	whisper_trigger = "^(%S+) (%S+) les effets .* Murmure insidieux.$",
	whisper_message = "Démon : %s",
	whisper_bar = "Disparition des démons",
	whisper_soon = "~Cooldown Démons",
} end )

L:RegisterTranslations("deDE", function() return {
	whirlwind = "Wirbelwind",
	whirlwind_desc = "Wirbelwind Timer",

	phase = "D\195\164monenphase",
	phase_desc = "Gesch\195\164tzte Timer f\195\188r D\195\164monenphase",

	image = "Schatten von Leotheras",
	image_desc = "15% Schatten Abspaltung Alarm",

	whisper = "Heimt\195\188ckisches Gefl\195\188ster",
	whisper_desc = "Zeigt an, welche Spieler von Heimt\195\188ckisches Gefl\195\188ster betroffen sind",

	enrage_trigger = "Endlich hat meine Verbannung ein Ende!",

	whirlwind_trigger = "Leotheras der Blinde bekommt 'Wirbelwind'.",
	whirlwind_gain = "Wirbelwind f\195\188r 12sec",
	whirlwind_fade = "Wirbelwind vorbei",
	whirlwind_bar = "Wirbelwind",
	whirlwind_bar2 = "~Wirbelwind Cooldown",
	whirlwind_warn = "Wirbelwind Cooldown vorbei",

	phase_trigger = "Hinfort, unbedeutender Elf. Ich habe jetzt die Kontrolle!",
	phase_demon = "D\195\164monenphase Phase f\195\188r 60sec",
	phase_demonsoon = "D\195\164monenphase in 5sec!",
	phase_normalsoon = "Normale Phase in 5sec",
	phase_normal = "Normale Phase!",
	demon_bar = "D\195\164monenphase",
	demon_nextbar = "n\195\164chste D\195\164monenphase",

	image_trigger = "Ich bin der Meister! H\195\182rt Ihr?",
	image_message = "15% - Schatten von Leotheras!",
	image_warning = "Schatten von Leotheras bald!",

	whisper_trigger = "^([^%s]+) ([^%s]+) von Heimt\195\188ckisches Gefl\195\188ster betroffen",
	whisper_message = "D\195\164mon: %s",
	whisper_bar = "D\195\164monen Despawn",
	whisper_soon = "~D\195\164monen Cooldown",
} end )

--盲眼者莱欧瑟拉斯
L:RegisterTranslations("zhCN", function() return {
	enrage_trigger = "我的放逐终于结束了！",

	whirlwind = "旋风斩",
	whirlwind_desc = "旋风斩计时",
	whirlwind_trigger = "盲眼者莱欧瑟拉斯获得了旋风斩的效果。",
	whirlwind_gain = "旋风斩 - 12秒",
	whirlwind_fade = "旋风斩 结束",
	whirlwind_bar = "旋风斩",
	whirlwind_bar2 = "~旋风斩 CD",
	whirlwind_warn = "冷却结束 - 即将发动",

	phase = "恶魔形态",
	phase_desc = "恶魔形态计时",
	phase_trigger = "滚开吧，脆弱的精灵。现在我说了算！",
	phase_demon = "恶魔形态 - 60秒",
	phase_demonsoon = "5秒后 恶魔形态!",
	phase_normalsoon = "5秒后 正常形态",
	phase_normal = "正常形态!",
	demon_bar = "恶魔形态",
	demon_nextbar = "下一 恶魔阶段",

	mindcontrol = "精神控制",
	mindcontrol_desc = "当玩家受到精神控制发出警报",
	mindcontrol_trigger = "^(%S+)受(%S+)了噬体疯狂效果的影响。$",
	mindcontrol_warning = "精神控制: %s",

	image = "镜像",
	image_desc = "15%镜像分裂警报.",
	image_trigger = "不……不！你在干什么？我才是主宰！你听到没有？我……啊啊啊啊！控制……不住了。",
	image_message = "15% - 镜像 出现!",
	image_warning = "即将 镜像!",

	whisper = "因斯迪安低语",
	whisper_desc = "当玩家受到因斯迪安低语发出警报",
	whisper_trigger = "^(%S+)受(%S+)了因斯迪安低语效果的影响。$",
	whisper_message = "恶魔: %s",
	whisper_bar = "恶魔消失",
	whisper_soon = "~恶魔 冷却",
}end )

--zhTW語系：Peroth＠暴風祭壇
--site：http://blog.pixnet.net/Neriak
L:RegisterTranslations("zhTW", function() return {
	enrage_trigger = "終於結束了我的流放生涯!",

	whirlwind = "旋風斬",
	whirlwind_desc = "旋風斬計時",
	whirlwind_trigger = "『盲目者』李奧薩拉斯獲得了旋風斬的效果。",
	whirlwind_gain = "旋風斬 - 持續 12 秒。",
	whirlwind_fade = "旋風斬終止！",
	whirlwind_bar = "旋風斬",
	whirlwind_bar2 = "旋風斬冷卻",
	whirlwind_warn = "冷卻結束 - 旋風斬即將來臨！",

	phase = "惡魔型態",
	phase_desc = "惡魔型態計時",
	phase_trigger = "消失吧，微不足道的精靈。現在開始由我掌管!",
	phase_demon = "惡魔型態 - 持續 60 秒！",
	phase_demonsoon = "5 秒內進入惡魔型態！",
	phase_normalsoon = "5 秒內回到普通型態！",
	phase_normal = "普通型態 - 旋風斬即將來臨！",
	demon_bar = "惡魔型態",
	demon_nextbar = "下一次惡魔型態",

	mindcontrol = "心靈控制",
	mindcontrol_desc = "當隊友受到心控時警告",
	mindcontrol_trigger = "^(.+)受(到[了]*)吞噬瘋狂效果的影響。",
	mindcontrol_warning = "心控：%s",

	image = "影分身",
	image_desc = "15% 分身警告",
	image_trigger = "不…不!你做了什麼?我是主人!你沒聽見我在說話嗎?我…..啊!無法…控制它。",
	image_message = "15% - 分身出現！",
	image_warning = "分身即將出現！",

	whisper = "陰險之語",
	whisper_desc = "當隊友受到陰險之語時警告",
	whisper_trigger = "^(.+)受(到[了]*)陰險之語效果的影響。",
	whisper_message = "內心的惡靈：: %s",
	whisper_bar = "惡靈消失計時",
	whisper_soon = "惡靈冷卻",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "whirlwind", "phase", "image", "whisper", "mindcontrol", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "WMEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "WMEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "WMEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "WMEvent")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LeoWhisp", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "LeoWW", 10)

	self:RegisterEvent("UNIT_HEALTH")
	pName = UnitName("player")
	stop = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["enrage_trigger"] then
		imagewarn = nil
		for k in pairs(beDemon) do beDemon[k] = nil end
		stop = nil

		if self.db.profile.phase then
			self:DelayedMessage(55, L["phase_demonsoon"], "Urgent")
			self:Bar(L["demon_nextbar"], 60, "Spell_Shadow_Metamorphosis")
		end
		if self.db.profile.enrage then
			self:Message(fmt(L2["enrage_start"], boss, 10), "Attention")
			self:DelayedMessage(300, fmt(L2["enrage_min"], 5), "Positive")
			self:DelayedMessage(420, fmt(L2["enrage_min"], 3), "Positive")
			self:DelayedMessage(540, fmt(L2["enrage_min"], 1), "Positive")
			self:DelayedMessage(570, fmt(L2["enrage_sec"], 30), "Positive")
			self:DelayedMessage(590, fmt(L2["enrage_sec"], 10), "Urgent")
			self:DelayedMessage(600, fmt(L2["enrage_end"], boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
		if self.db.profile.whirlwind then
			self:WhirlwindBar()
		end
	elseif msg == L["phase_trigger"] then
		if self.db.profile.phase then
			self:CancelScheduledEvent("demon1")
			self:TriggerEvent("BigWigs_StopBar", self, L["demon_nextbar"])
			self:Message(L["phase_demon"], "Attention")
			self:ScheduleEvent("normal1", "BigWigs_Message", 55, L["phase_normalsoon"], "Important")
			self:Bar(L["demon_bar"], 60, "Spell_Shadow_Metamorphosis")
			self:ScheduleEvent("bwdemon", self.DemonSoon, 60, self)
		end
		if self.db.profile.whirlwind then
			self:CancelScheduledEvent("ww1")
			self:CancelScheduledEvent("ww2")
			self:CancelScheduledEvent("bwwhirlwind")
			self:TriggerEvent("BigWigs_StopBar", self, L["whirlwind_bar"])
			self:TriggerEvent("BigWigs_StopBar", self, L["whirlwind_bar2"])
			self:ScheduleEvent("BWAfterDemon", self.WhirlwindBar, 60, self)
		end
		if self.db.profile.whisper then
			self:Bar(L["whisper_soon"], 23, "Spell_Shadow_ManaFeed")
		end
	elseif msg == L["image_trigger"] then
		self:CancelScheduledEvent("bwdemon")
		self:CancelScheduledEvent("normal1")
		self:CancelScheduledEvent("demon1")
		self:TriggerEvent("BigWigs_StopBar", self, L["demon_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["demon_nextbar"])
		if self.db.profile.image then
			self:Message(L["image_message"], "Important")
		end
	end
end

function mod:DemonSoon()
	self:Message(L["phase_normal"], "Important")
	self:ScheduleEvent("demon1", "BigWigs_Message", 40, L["phase_demonsoon"], "Urgent")
	self:Bar(L["demon_nextbar"], 45, "Spell_Shadow_Metamorphosis")
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["whirlwind_trigger"] then
		self:Sync("LeoWW")
	end
end

function mod:WhirlwindBar()
	self:Bar(L["whirlwind_bar2"], 15, "Ability_Whirlwind")
	self:ScheduleEvent("ww2", "BigWigs_Message", 15, L["whirlwind_warn"], "Attention")
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.image then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 16 and health <= 19 and not imagewarn then
			self:Message(L["image_warning"], "Urgent")
			imagewarn = true
		elseif health > 25 and imagewarn then
			imagewarn = false
		end
	end
end

function mod:WMEvent(msg)
	local wplayer, wtype = select(3, msg:find(L["whisper_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = pName
		end
		self:Sync("LeoWhisp "..wplayer)
		return
	end

	if self.db.profile.mindcontrol then
		local mcplayer, mctype = select(3, msg:find(L["mindcontrol_trigger"]))
		if mcplayer and mctype then
			if mcplayer == L2["you"] and mctype == L2["are"] then
				mcplayer = pName
			end
			self:Message(fmt(L["mindcontrol_warning"], mcplayer), "Urgent", nil, "Alert")
			return
		end
	end
end

local function nilStop()
	stop = nil
	for k in pairs(beDemon) do beDemon[k] = nil end
end

function mod:DemonWarn()
	if stop then return end
	if self.db.profile.whisper then
		local msg = nil
		for k in pairs(beDemon) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(fmt(L["whisper_message"], msg), "Attention")
	end
	stop = true
	self:ScheduleEvent("BWLeoNilStop", nilStop, 6)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "LeoWhisp" and not stop and rest then
		beDemon[rest] = true
		self:ScheduleEvent("ScanDemons", self.DemonWarn, 0.3, self)
		self:Bar(L["whisper_bar"], 30, "Spell_Shadow_ManaFeed")
	elseif sync == "LeoWW" and self.db.profile.whirlwind then
		self:Message(L["whirlwind_gain"], "Important", nil, "Alert")
		self:ScheduleEvent("ww1", "BigWigs_Message", 12, L["whirlwind_fade"], "Attention")
		self:Bar(L["whirlwind_bar"], 12, "Ability_Whirlwind")
		self:ScheduleEvent("bwwhirlwind", self.WhirlwindBar, 12, self)
	end
end
