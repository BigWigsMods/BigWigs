------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Astromancer Solarian"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local p2 = nil

local pName = nil
local UnitName = UnitName
local fmt = string.format

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

	wrath = "Wrath Cast",
	wrath_desc = "Warn when Wrath is being cast, and the current target.",
	wrath_trigger = "^(%S+) (%S+) afflicted by Wrath of the Astromancer%.$",
	wrath_alert = "Casting Wrath! - Target: %s",
	wrath_alert_trigger = "begins to cast Wrath of the Astromancer%.$",

	wrathyou = "Wrath Debuff on You",
	wrathyou_desc = "Warn when you have Wrath of the Astromancer.",
	wrath_you = "Wrath on YOU!",

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
	phase = "Phase",
	phase_desc = "Warnt vor Phasenwechsel",

	wrathyou = "Zorn Debuff auf Dir",
	wrathyou_desc = "Warn wenn du von Zorn des Astronomen betroffen bist",

	icon = "Icon",
	icon_desc = "Plaziert ein Schlachtzug Icon auf dem Spieler, der von Zorn des Astronomen betroffen ist",

	split = "Spaltung",
	split_desc = "Warnt vor Spaltung & Add Spawn",

	split_bar = "~N\195\164chste Spaltung",
	split_warning = "Spaltung in ~7 sec",

	phase1_message = "Phase 1 - Spaltung in ~50sec",

	phase2_warning = "Phase 2 bald!",
	phase2_trigger = "^Ich werde", --to verify
	phase2_message = "20% - Phase 2",

	wrath_trigger = "^([^%s]+) ([^%s]+) von Zorn des Astronomen betroffen%.$",
	wrath_you = "Zorn auf DIR!",

	agent_warning = "Splittung! - Agenten in 6 sec",
	agent_bar = "Agenten",

	priest_warning = "Priester/Solarian in 3 sec",
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

	wrath = "격노 시전",
	wrath_desc = "격노 시전 시 경고와 현재 대상을 알립니다.",
	wrath_trigger = "^([^|;%s]*)(.*)점성술사의 격노에 걸렸습니다%.$",
	wrath_alert = "격노 시전! - 대상: %s",
	wrath_alert_trigger = "점성술사의 격노 시전을 시작합니다%.$",

	wrathyou = "자신에 격노 디버프",
	wrathyou_desc = "당신이 점성술사의 격노에 걸렸을 때 알립니다.",
	wrath_you = "당신에 격노!",

	icon = "전술 표시",
	icon_desc = "점성술사의 격노에 걸린 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",

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

	wrath = "Incantation du Courroux",
	wrath_desc = "Préviens quand le Courroux est en cours d'incantation, et sa cible actuelle.",
	wrath_trigger = "^([^%s]+) ([^%s]+) les effets .* Courroux de l'Astromancien%.$",
	wrath_alert = "Courroux en incantation ! - Cible : %s",
	wrath_alert_trigger = "commence à lancer Courroux de l'Astromancien.$",

	wrathyou = "Courroux sur vous",
	wrathyou_desc = "Préviens quand vous subissez les effets du Courroux de l'Astromancien.",
	wrath_you = "Courroux sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le joueur affecté par le Courroux de l'Astromancien (nécessite d'être promu ou mieux).",

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

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "split", -1, "wrath", "wrathyou", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "WrathAff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "WrathAff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "WrathAff")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaWCast", 5)
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync)
	if sync == "SolaWCast" and self.db.profile.wrath then
		self:Bar(L["wrath"], 3, "Spell_Arcane_Arcane02")
		self:ScheduleEvent("BWSolaToTScan", self.WrathCheck, 1, self) --target scan once, after 1 second
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["wrath_alert_trigger"]) then
		self:Sync("SolaWCast")
	end
end

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

function mod:WrathAff(msg)
	local wplayer, wtype = select(3, msg:find(L["wrath_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = pName
			if self.db.profile.wrathyou then
				self:Message(L["wrath_you"], "Personal", true, "Alert")
			end
		end
		if self.db.profile.icon then
			self:Icon(wplayer)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Personal")
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

--Wrath is usually around a 3 second cast, and she takes a target, so we scan her target to try give some early advantage :)
function mod:WrathCheck()
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
		self:Message(fmt(L["wrath_alert"], target), "Attention")
	end
end
