------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Astromancer Solarian"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local p2 = nil

local pName = nil
local UnitName = UnitName
local CheckInteractDistance = CheckInteractDistance

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Solarian",

	engage_trigger = "Tal anu'men no sin'dorei!",

	phase = "Phase",
	phase_desc = "Warn for phase changes.",
	phase1_message = "Phase 1 - Split in ~50sec",
	phase2_warning = "Phase 2 Soon!",
	phase2_trigger = "^I become",
	phase2_message = "20% - Phase 2",

	wrath = "Wrath Debuff",
	wrath_desc = "Warn who is afflicted by Wrath of the Astromancer.",
	wrath_trigger = "^(%S+) (%S+) afflicted by Wrath of the Astromancer%.$",
	wrath_fade = "Wrath of the Astromancer fades from you.",
	wrath_other = "Wrath on %s",
	wrath_you = "Wrath on YOU!",

	whisper = "Whisper",
	whisper_desc = "Whisper the player with Wrath Debuff (requires promoted or higher).",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Wrath of the Astromancer(requires promoted or higher).",

	split = "Split",
	split_desc = "Warn for split & add spawn.",
	split_trigger1 = "I will crush your delusions of grandeur!",
	split_trigger2 = "You are hopelessly outmatched!",
	split_bar = "~Next Split",
	split_warning = "Split in ~7 sec",

	agent_warning = "Split! - Agents in 6 sec",
	agent_bar = "Agents",
	priest_warning = "Priests/Solarian in 3 sec",
	priest_bar = "Priests/Solarian",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Tal anu'men no sin'dorei!",

	phase = "Phasen",
	phase_desc = "Warnung bei Phasenwechsel.",
	phase1_message = "Phase 1 - Spaltung in ~50sec",
	phase2_warning = "Phase 2 bald!",
	phase2_trigger = "^Ich werde",
	phase2_message = "20% - Phase 2",

	wrath = "Zorn des Astronomen",
	wrath_desc = "Warnt wer von Zorn des Astronomen betroffen ist.",
	wrath_trigger = "^([^%s]+) ([^%s]+) von Zorn des Astronomen betroffen%.$",
	wrath_fade = "Zorn des Astronomen schwindet von Euch.",
	wrath_other = "Zorn auf %s",
	wrath_you = "Zorn auf DIR!",

	whisper = "Flüstern",
	whisper_desc = "Warnung an Spieler mit Zorn Debuff flüstern(benötigt Asssitent oder höher).",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziere ein Schlachtzug Symbol auf dem Spieler, der von Zorn des Astronomen betroffen ist.",

	split = "Spaltung",
	split_desc = "Warnt vor Spaltung & Add Spawn.",
	split_trigger1 = "Ich werde Euch Euren Hochmut austreiben!",
	split_trigger2 = "Ihr seid eindeutig in der Unterzahl!",
	split_bar = "~Nächste Spaltung",
	split_warning = "Spaltung in ~7 sek",

	agent_warning = "Splittung! - Agenten in 6 sek",
	agent_bar = "Agenten",
	priest_warning = "Priester/Solarian in 3 sek",
	priest_bar = "Priester/Solarian",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "탈 아누멘 노 신도레이!",

	phase = "단계",
	phase_desc = "단계 변경에 대해 알립니다.",
	phase1_message = "1 단계 - 약 50초 이내 분리",
	phase2_warning = "잠시 후 2 단계!",
	phase2_trigger = "^나는 공허의",
	phase2_message = "20% - 2 단계",

	wrath = "분노 디버프",
	wrath_desc = "분노 디버프에 걸린 대상을 알립니다.",
	wrath_trigger = "^([^|;%s]*)(.*)점성술사의 분노에 걸렸습니다%.$",
	wrath_fade = "당신의 몸에서 점성술사의 분노 효과가 사라졌습니다.",
	wrath_other = "%s에 분노",
	wrath_you = "당신에 분노!",

	whisper = "귓속말",
	whisper_desc = "분노 디버프에 걸린 플레이어에게 귓속말을 보냅니다 (승급자 이상 권한 요구).",

	icon = "전술 표시",
	icon_desc = "점성술사의 분노에 걸린 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",

	split = "분리",
	split_desc = "분리와 소환에 대한 경고입니다.",
	split_trigger1 = "그 오만한 콧대를 꺾어주마!",
	split_trigger2 = "한 줌의 희망마저 짓밟아주마!",
	split_bar = "~다음 분리",
	split_warning = "약 7초 이내 분리",

	agent_warning = "분리! - 6초 이내 요원",
	agent_bar = "요원",
	priest_warning = "3초 이내 사제/솔라리안",
	priest_bar = "사제/솔라리안",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Tal anu'men no sin'dorei!",

	phase = "Phases",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase1_message = "Phase 1 - Rupture dans ~50 sec.",
	phase2_warning = "Phase 2 imminente !",
	phase2_trigger = "^Je ne fais plus",
	phase2_message = "20% - Phase 2",

	wrath = "Courroux de l'astromancienne",
	wrath_desc = "Préviens quand un joueur subit les effets du Courroux de l'astromancienne.",
	wrath_trigger = "^(%S+) (%S+) les effets .* Courroux de l'astromancienne%.$",
	wrath_fade = "Courroux de l'astromancienne vient de se dissiper.",
	wrath_other = "Courroux sur %s",
	wrath_you = "Courroux sur VOUS !",

	whisper = "Chuchoter",
	whisper_desc = "Préviens par chuchotement le dernier joueur affecté par le Courroux de l'astromancienne (nécessite d'être promu ou mieux).",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Courroux de l'astromancienne (nécessite d'être promu ou mieux).",

	split = "Rupture",
	split_desc = "Préviens de l'arrivée des ruptures & des apparitions des adds.",
	split_trigger1 = "Je vais balayer vos illusions de grandeur !",
	split_trigger2 = "Vous êtes désespérément surclassés !",
	split_bar = "~Prochaine Rupture",
	split_warning = "Rupture dans ~7 sec.",

	agent_warning = "Rupture ! - Agents dans 6 sec.",
	agent_bar = "Agents",
	priest_warning = "Prêtres/Solarian dans 3 sec.",
	priest_bar = "Prêtres/Solarian",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "Tal anu'men no sin'dorei!",

	phase = "阶段",
	phase_desc = "阶段改变警报",
	phase1_message = "阶段 1 - ~50秒后分裂",
	phase2_warning = "即将 阶段 2!",
	phase2_trigger = "^我受够了！现在我要让你们看看宇宙的愤怒！",
	phase2_message = "20% - 阶段 2",

	wrath = "愤怒Debuff",
	wrath_desc = "当受到星术师之怒发出警报",
	wrath_trigger = "^(%S+)受(%S+)了星术师之怒效果的影响。$",
	wrath_fade = "星术师之怒效果从你身上消失了。",
	wrath_other = "愤怒 --> %s",
	wrath_you = "愤怒 >你<!",
	
	whisper = "密语",
	whisper_desc = "发送密语给中了愤怒的玩家 (需要权限).",

	icon = "团队标记",
	icon_desc = "给受到星术师之怒的队友打上团队标记",

	split = "分裂",
	split_desc = "当分裂和增加救援发出警报",
	split_trigger1 = "我要让你们自以为是的错觉荡然无存！",
	split_trigger2 = "你们势单力薄！",
	split_bar = "~下次 分裂",
	split_warning = "~7秒后 分裂",

	agent_warning = "分裂! - 6秒后 日晷密探",
	agent_bar = "日晷密探",
	priest_warning = "3秒后 日晷祭司/索兰莉安",
	priest_bar = "日晷祭司/索兰莉安",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "與血精靈為敵者死!",

	phase = "階段警告",
	phase_desc = "當階段轉換時警告",
	phase1_message = "第一階段 - 50 秒內分身！",
	phase2_warning = "即將進入第二階段！",
	phase2_trigger = "夠了!現在我要呼喚宇宙中失衡的能量。",
	phase2_message = "20% - 第二階段！",

	wrath = "星術師之怒施放",
	wrath_desc = "警報隊友受到星術師之怒。", --enUS changed
	wrath_trigger = "^(.+)受(到[了]*)星術師之怒效果的影響。",
	wrath_fade = "星術師之怒效果從你身上消失了。",
	wrath_other = "星術師之怒：[%s]",
	wrath_you = "你中了星術師之怒！快跑！",

	whisper = "發送密語",
	whisper_desc = "發送密語給受到星術師之怒的玩家（需要權限）",

	icon = "團隊標記",
	icon_desc = "當隊友受到星術師之怒時設置標記（需要權限）",

	split = "分身警告",
	split_desc = "當分身與小兵出現時警示。",
	split_trigger1 = "我會粉碎你那偉大的夢想!",
	split_trigger2 = "我的實力遠勝於你!",
	split_bar = "下一次分身",
	split_warning = "7 秒內分身來臨！",

	agent_warning = "分身！ - 6 秒內密探出現！",
	agent_bar = "密探計時",
	priest_warning = "5 秒內牧師、星術師出現！",
	priest_bar = "牧師、星術師計時",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "split", -1, "wrath", "whisper", "icon", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "WrathAff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "WrathAff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "WrathAff")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaWrath", 3)
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 21 and hp <= 24 and not p2 then
			self:Message(L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 40 and p2 then
			p2 = false
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "SolaWrath" and rest and self.db.profile.wrath then
		local other = L["wrath_other"]:format(rest)
		if rest == pName then
			self:Message(L["wrath_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
		if self.db.profile.whisper then
			self:Whisper(rest, L["wrath_you"])
		end
		self:Bar(other, 6, "Spell_Arcane_Arcane02")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

local function HideProx()
	mod:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	mod:TriggerEvent("BigWigs_HideProximity", self)
end

function mod:WrathAff(msg)
	local wplayer, wtype = select(3, msg:find(L["wrath_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
			wplayer = pName
			self:TriggerEvent("BigWigs_ShowProximity", self)
			self:ScheduleEvent("BWHideProx", HideProx, 6)
		end
		self:Sync("SolaWrath", wplayer)
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if msg == L["wrath_fade"] then
		self:TriggerEvent("BigWigs_HideProximity", self)
		self:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
		self:CancelScheduledEvent("BWHideProx")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Important")
		end
		self:CancelScheduledEvent("split1")
		self:TriggerEvent("BigWigs_StopBar", self, L["split_bar"])
	elseif msg == L["engage_trigger"] then
		p2 = nil

		if self.db.profile.phase then
			self:Message(L["phase1_message"], "Positive")
			self:Bar(L["split_bar"], 50, "Spell_Shadow_SealOfKings")
			self:DelayedMessage(43, L["split_warning"], "Important")
		end
	elseif self.db.profile.split and (msg == L["split_trigger1"] or msg == L["split_trigger2"]) then
		--split is around 90 seconds after the previous
		self:Bar(L["split_bar"], 90, "Spell_Shadow_SealOfKings")
		self:ScheduleEvent("split1", "BigWigs_Message", 83, L["split_warning"], "Important")

		-- Agents 6 seconds after the Split
		self:Message(L["agent_warning"], "Important")
		self:Bar(L["agent_bar"], 6, "Ability_Creature_Cursed_01")

		-- Priests 22 seconds after the Split
		self:DelayedMessage(19, L["priest_warning"], "Important")
		self:Bar(L["priest_bar"], 22, "Spell_Holy_HolyBolt")
	end
end

