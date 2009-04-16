----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["General Vezax"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33271
mod.toggleoptions = {"vapor", "animus", -1, "crash", "mark", "flame", "surge", -1, "icon", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
started = true
count = 1
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Vezax",

	flame = "Searing Flames",
	flame_desc = "Warn when Vezax casts a Searing Flames.",
	flame_message = "Searing Flames!",

	surge = "Surge of Darkness",
	surge_desc = "Warn when Vezax gains Surge of Darkness.",
	surge_message = "Surge of Darkness!",
	surge_cast = "Surge of Darkness casting!",
	surge_end = "Surge of Darkness faded!",

	animus = "Saronite Animus",
	animus_desc = "Warn when the Saronite Animus spawns.",
	animus_message = "Animus spawns!",

	vapor = "Saronite Vapors",
	vapor_desc = "Warn for Saronite Vapors spawn.",
	vapor_message = "Saronite Vapors (%d)!",
	vapor_bar = "Next Vapors (%d)",

	crash = "Shadow Crash",
	crash_desc = "Warn who Vezax casts Shadow Crash on.",
	crash_you = "Shadow Crash on YOU!",
	crash_other = "Shadow Crash on %s",

	mark = "Mark of the Faceless",
	mark_desc = "Place Icon for Mark of the Faceless.",
	mark_message_you = "You have Mark of the Faceless!",
	mark_message_other = "%s has Mark of the Faceless!",

	icon = "Place Icon",
	icon_desc = "Place a Raid Target Icon on the player targetted by Shadow Crash. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	flame = "이글거리는 불길",
	flame_desc = "이글거리는 불길의 시전을 알립니다.",
	flame_message = "이글거리는 불길!",

	surge = "어둠 쇄도",
	surge_desc = "베작스의 어둠 쇄도 획득을 알립니다.",
	surge_message = "어둠 쇄도!",
	surge_cast = "어둠 쇄도 시전!",
	surge_end = "어둠 쇄도 사라짐!",

	animus = "사로나이트 원혼",
	animus_desc = "사로나이트 원혼 소환을 알립니다.",
	animus_message = "원혼 소환!",

	vapor = "사로나이트 증기",
	vapor_desc = "사로나이트 증기 소환을 알립니다.",
	vapor_message = "사로나이트 증기 (%d)!",
	vapor_bar = "다음 증기 (%d)",

	crash = "어둠 붕괴",
	crash_desc = "어둠 붕괴의 대상 플레이어를 알립니다.",
	crash_you = "당신은 어둠 붕괴!",
	crash_other = "어둠 붕괴: %s",

	mark = "얼굴 없는 자의 징표",
	mark_desc = "얼굴 없는 자의 징표 대상 플레이어에게 전술 표시를 합니다.",
	mark_message_you = "당신은 얼굴 없는 자의 징표!",
	mark_message_other = "얼굴 없는 자의 징표: %s",

	icon = "전술 표시",
	icon_desc = "어둠 붕괴 또는 얼굴 없는 자의 징표의 대상 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	flame = "Flammes incendiaires",
	flame_desc = "Prévient quand Vezax incante des Flammes incendiaires.",
	flame_message = "Flammes incendiaires !",

	surge = "Vague de ténèbres",
	surge_desc = "Prévient quand Vezax gagne une Vague de ténèbres.",
	surge_message = "Vague de ténèbres !",
	surge_cast = "Vague de ténèbres en incantation !",
	surge_end = "Vague de ténèbres estompée !",

	animus = "Animus de saronite",
	animus_desc = "Prévient quand un Animus de saronite apparaît.",
	animus_message = "Animus apparu !",

	vapor = "Vapeurs de saronite",
	vapor_desc = "Prévient quand des Vapeurs de saronite apparaissent.",
	vapor_message = "Vapeurs de saronite (%d) !",
	vapor_bar = "Prochaines Vapeurs (%d)",

	crash = "Déferlante d'ombre",
	crash_desc = "Prévient quand un joueur subit les effets d'une Déferlante d'ombre.",
	crash_you = "Déferlante d'ombre sur VOUS !",
	crash_other = "Déferlante d'ombre sur %s",

	mark = "Marque du Sans-visage",
	mark_desc = "Prévient quand un joueur subit les effets d'une Marque du Sans-visage.",
	mark_message_you = "Marque du Sans-visage sur VOUS !",
	mark_message_other = "Marque du Sans-visage sur %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Déferlante d'ombre (nécessite d'être assistant ou mieux).",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	flame = "灼热烈焰",
	flame_desc = "当维扎克斯施放灼热烈焰时发出警报。",
	flame_message = "灼热烈焰！",

	surge = "Surge of Darkness",
	surge_desc = "当维扎克斯获得Surge of Darkness时发出警报。",
	surge_message = "Surge of Darkness！",
	surge_cast = "正在施放 Surge of Darkness！",
	surge_end = "Surge of Darkness消失！",

	animus = "萨隆邪铁Animus",
	animus_desc = "当萨隆邪铁Animus出现时发出警报。",
	animus_message = "萨隆邪铁Animus 出现！",

	vapor = "萨隆邪铁蒸汽",
	vapor_desc = "当萨隆邪铁蒸汽出现时发出警报。",
	vapor_message = "萨隆邪铁蒸汽：>%d<！",
	vapor_bar = "<下一萨隆邪铁蒸汽：%d>",

	crash = "Shadow Crash",
	crash_desc = "当玩家中了维扎克斯施放的Shadow Crash时发出警报。",
	crash_you = ">你< Shadow Crash！",
	crash_other = "Shadow Crash：>%s<！",

	mark = "无面者的印记",
	mark_desc = "当玩家中了无面者的印记的时发出警报。",
	mark_message_you = ">你< 无面者的印记！",
	mark_message_other = "无面者的印记：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了Shadow Crash的队员打上团队标记。（需要权限）",
]]
} end )

L:RegisterTranslations("zhTW", function() return {
	flame = "灼熱烈焰",
	flame_desc = "當威札斯施放灼熱烈焰時發出警報。",
	flame_message = "灼熱烈焰！",

	surge = "暗鬱奔騰",
	surge_desc = "當威札斯獲得暗鬱奔騰時發出警報。",
	surge_message = "暗鬱奔騰！",
	surge_cast = "正在施放 暗鬱奔騰！",
	surge_end = "暗鬱奔騰 消失！",

	animus = "薩倫聚惡體",
	animus_desc = "當薩倫聚惡體出現時發出警報。",
	animus_message = "薩倫聚惡體 出現！",

	vapor = "薩倫煙霧",
	vapor_desc = "當薩倫煙霧出現時發出警報。",
	vapor_message = "薩倫煙霧：>%d<！",
	vapor_bar = "<下一薩倫煙霧：%d>",

	crash = "暗影暴擊",
	crash_desc = "當玩家中了威札斯施放的暗影暴擊時發出警報。",
	crash_you = ">你< 暗影暴擊！",
	crash_other = "暗影暴擊：>%s<！",

	mark = "無面者印記",
	mark_desc = "當玩家中了無面者印記時發出警報。",
	mark_message_you = ">你< 無面者印記！",
	mark_message_other = "無面者印記：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了暗影暴擊的隊員打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("ruRU", function() return {
	flame = "Жгучее пламя",
	flame_desc = "Сообщает когда Везакс применяет Жгучее пламя.",
	flame_message = "Жгучее пламя!",

	surge = "Наплыв Тьмы",
	surge_desc = "Сообщает когда Везакс применяет Наплыв Тьмы.",
	surge_message = "Наплыв Тьмы!",
	surge_cast = "Применяется Наплыв Тьмы!",
	surge_end = "Наплыв Тьмы рассеялся!",

	animus = "Саронитовый враг",
	animus_desc = "Сообщать о появлении саронитового врага.",
	animus_message = "Появление врагов!",

	vapor = "Саронитовые пары",
	vapor_desc = "Сообщать о появлении Саронитовые пары.",
	vapor_message = "Саронитовые пары (%d)!",
	vapor_bar = "Следующие Пары (%d)",

	crash = "Темное сокрушение",
	crash_desc = "Сообщает на кого Везакс применяет Темное сокрушение.",
	crash_you = "Темное сокрушение на ВАС!",
	crash_other = "Темное сокрушение на |3-5(%s)",

	mark = "Метка Безликого",
	mark_desc = "Помечать иконкой Метку Безликого.",
	mark_message_you = "На ВАС Метка Безликого!",
	mark_message_other = "Метка на: |3-5(%s)!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на который попал под воздействие Темного сокрушения. (необходимо быть лидером группы или рейда)",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Flame", 62661)
	self:AddCombatListener("SPELL_CAST_START", "Surge", 62662)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SurgeGain", 62662)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Target", 60835, 62660)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Mark", 63276)
	self:AddCombatListener("SPELL_SUMMON", "Summon", 63081, 63145)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

local function ScanTarget()
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
		local other = L["crash_other"]:format(target)
		if target == pName then
			mod:LocalMessage(L["crash_you"], "Personal", 62660, "Alert")
			mod:WideMessage(other)
		else
			mod:IfMessage(other, "Attention", 62660)
			mod:Whisper(target, L["crash_you"])
		end
		if db.icon then
			mod:Icon(target, "icon")
		end
	end
end

function mod:Mark(player, spellID)
	if db.mark then
		local other = L["mark_message_other"]:format(player)
		if player == pName then
			self:LocalMessage(L["mark_message_you"], "Personal", spellID, "Alert")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", spellID)
			self:Whisper(player, L["mark_message_you"])
		end
		self:Bar(other, 10, spellID)
		if db.icon then
			self:Icon(player, "icon")
			self:ScheduleEvent("BWRemovebeamIcon", "BigWigs_RemoveRaidIcon", 10, self)
		end
	end
end

function mod:Target(player, spellId)
	if db.crash then
		self:ScheduleEvent("BWCrashToTScan", ScanTarget, 0.1)
		self:ScheduleEvent("BWRemovebeamIcon", "BigWigs_RemoveRaidIcon", 4, self)
	end
end

function mod:Flame(_, spellID)
	if db.flame then
		self:IfMessage(L["flame_message"], "Attention", spellID)
	end
end

function mod:Surge(_, spellID)
	if db.surge then
		self:IfMessage(L["surge_message"], "Attention", spellID)
		self:Bar(L["surge_cast"], 3, spellID)
	end
end

function mod:SurgeGain(_, spellID)
	if db.surge then
		self:Bar(L["surge"], 10, spellID)
		self:DelayedMessage(10, L["surge_end"], "Attention")
	end
end

function mod:Summon(_, spellID)
	if spellId == 63081 and db.vapor then
		self:IfMessage(L["vapor_message"]:format(count), "Attention", 63323)
		count = count + 1
		self:Bar(L["vapor_bar"]:format(count), 30, 63323)
	elseif spellId == 63145 and db.animus then
		self:IfMessage(L["animus_message"], "Attention", 63319)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		count = 1
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
	end
end
