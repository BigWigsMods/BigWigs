------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Astromancer Solarian"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local p1
local p2
local split

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Solarian",

	phase = "Phase",
	phase_desc = "Warn for phase changes",

	wrath = "Wrath Cast",
	wrath_desc = "Warn when Wrath is being cast, and the current target",

	wrathyou = "Wrath Debuff on You",
	wrathyou_desc = "Warn when you have Wrath of the Astromancer",

	wrathother = "Wrath Debuff on Others",
	wrathother_desc = "Warn about others that have Wrath of the Astromancer",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player with Wrath of the Astromancer",

	split = "Split",
	split_desc = "Warn for split & add spawn",

	split_trigger = "casts Astromancer Split",
	split_bar = "~Next Split",
	split_warning = "Split in ~7 sec",

	phase1_message = "Phase 1 - Split in ~50sec",

	phase2_warning = "Phase 2 Soon!",
	phase2_trigger = "^I become",
	phase2_message = "20% - Phase 2",

	wrath_trigger = "^([^%s]+) ([^%s]+) afflicted by Wrath of the Astromancer",
	wrath_other = "Wrath: %s",
	wrath_you = "Wrath on YOU!",
	wrath_alert = "Casting Wrath! - Target: %s",
	wrath_alert_trigger = "begins to cast Wrath of the Astromancer.$",

	agent_warning = "Split! - Agents in 6 sec",
	agent_bar = "Agents",

	priest_warning = "Priests/Solarian in 3 sec",
	priest_bar = "Priests/Solarian",

	["Solarium Priest"] = true,
	["Solarium Agent"] = true,
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phase",
	phase_desc = "Warnt vor Phasenwechsel",

	wrathyou = "Zorn Debuff auf Dir",
	wrathyou_desc = "Warn wenn du von Zorn des Astronomen betroffen bist",

	wrathother = "Zorn Debuff auf anderen",
	wrathother_desc = "Warnt welche Spieler von Zorn des Astronomen betroffen sind",

	icon = "Icon",
	icon_desc = "Plaziert ein Schlachtzug Icon auf dem Spieler, der von Zorn des Astronomen betroffen ist",

	split = "Spaltung",
	split_desc = "Warnt vor Spaltung & Add Spawn",

	split_trigger = "wirkt Spalten des Astronomen",
	split_bar = "~N\195\164chste Spaltung",
	split_warning = "Spaltung in ~7 sec",

	phase1_message = "Phase 1 - Spaltung in ~50sec",

	phase2_warning = "Phase 2 bald!",
	phase2_trigger = "^Ich werde", --to verify
	phase2_message = "20% - Phase 2",

	wrath_trigger = "^([^%s]+) ([^%s]+) von Zorn des Astronomen betroffen",
	wrath_other = "Zorn: %s",
	wrath_you = "Zorn auf DIR!",

	agent_warning = "Splittung! - Agenten in 6 sec",
	agent_bar = "Agenten",

	priest_warning = "Priester/Solarian in 3 sec",
	priest_bar = "Priester/Solarian",

	["Solarium Priest"] = "Solarispriester",
	["Solarium Agent"] = "Solarisagent",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변경에 대한 알림",

	wrath = "격노 시전",
	wrath_desc = "격노 시전 시 경고와 현재 대상 알림",

	wrathyou = "자신에 격노 디버프",
	wrathyou_desc = "당신이 점성술사의 격노에 걸렸을 때 알림",

	wrathother = "타인에 격노 디버프",
	wrathother_desc = "타인이 점성술사의 격노에 걸렸을 때 알림",

	icon = "아이콘",
	icon_desc = "점성술사의 격노에 걸린 플레이어에 공격대 아이콘 지정",

	split = "분리",
	split_desc = "분리와 소환에 대한 경고",

	split_trigger = "점성술사의 분리|1을;를; 시전합니다", -- check
	split_bar = "~다음 분리",
	split_warning = "약 7초 이내 분리",

	phase1_message = "1 단계 - 약 50초 이내 분리",

	phase2_warning = "잠시 후 2 단계!",
	phase2_trigger = "^나는 공허의", -- check
	phase2_message = "20% - 2 단계",

	wrath_trigger = "^([^|;%s]*)(.*)점성술사의 격노에 걸렸습니다%.$", -- check
	wrath_other = "격노: %s",
	wrath_you = "당신에 격노!",
	wrath_alert = "격노 시전! - 대상: %s",
	wrath_alert_trigger = "점성술사의 격노 시전을 시작합니다.$",

	agent_warning = "분리! - 6초 이내 요원",
	agent_bar = "요원",

	priest_warning = "3초 이내 사제/솔라리안",
	priest_bar = "사제/솔라리안",

	["Solarium Priest"] = "태양의 전당 사제",
	["Solarium Agent"] = "태양의 전당 요원",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Pr\195\169viens quand la rencontre entre dans une nouvelle phase.",

	wrath = "Incantation du Courroux",
	wrath_desc = "Pr\195\169viens quand le Courroux est en cours d'incantation, et sa cible actuelle.",

	wrathyou = "Courroux sur vous",
	wrathyou_desc = "Pr\195\169viens quand vous subissez les effets du Courroux de l'Astromancien.",

	wrathother = "Courroux sur les autres",
	wrathother_desc = "Pr\195\169viens quand d'autres subissent les effets du Courroux de l'Astromancien.",

	icon = "Ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur le joueur affect\195\169 par le Courroux de l'Astromancien (n\195\169cessite d'\195\170tre promu ou mieux).",

	split = "Rupture",
	split_desc = "Pr\195\169viens de l'arriv\195\169e des ruptures & des apparitions des adds.",

	split_trigger = "lance Rupture de l'astromancien",
	split_bar = "~Prochaine Rupture",
	split_warning = "Rupture dans ~7 sec.",

	phase1_message = "Phase 1 - Rupture dans ~50 sec.",

	phase2_warning = "Phase 2 imminente !",
	phase2_trigger = "^Je deviens",-- à vérifier
	phase2_message = "20% - Phase 2",

	wrath_trigger = "^([^%s]+) ([^%s]+) les effets de Courroux de l'Astromancien",
	wrath_other = "Courroux : %s",
	wrath_you = "Courroux sur VOUS !",
	wrath_alert = "Courroux en incantation ! - cible : %s",
	wrath_alert_trigger = "commence \195\160 lancer Courroux de l'Astromancien.$",

	agent_warning = "Rupture ! - Agents dans 6 sec.",
	agent_bar = "Agents",

	priest_warning = "Pr\195\170tres/Solarian dans 3 sec.",
	priest_bar = "Pr\195\170tres/Solarian",

	["Solarium Priest"] = "Pr\195\170tre Solarium", -- à vérifier
	["Solarium Agent"] = "Agent Solarium", -- à vérifier
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.wipemobs = {L["Solarium Priest"], L["Solarium Agent"]}
mod.toggleoptions = {"phase", "split", -1, "wrath", "wrathyou", "wrathother", "icon", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 4 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "debuff")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaWrath", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaWCast", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaSplit", 6)

	p1 = nil
	p2 = nil
	split = 0
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not p1 then
		p1 = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.phase then
			self:Message(L["phase1_message"], "Positive")
			self:Bar(L["split_bar"], 50, "Spell_Shadow_SealOfKings")
			self:DelayedMessage(43, L["split_warning"], "Important")
		end
	elseif sync == "SolaWrath" and rest then
		if rest == UnitName("player") and self.db.profile.wrathyou then
			self:Message(L["wrath_you"], "Personal", true, "Long")
			self:Message(L["wrath_other"]:format(rest), "Attention", nil, nil, true)
			self:Bar(L["wrath_other"]:format(rest), 8.5, "Spell_Arcane_Arcane02")
		elseif self.db.profile.wrathother then
			self:Message(L["wrath_other"]:format(rest), "Attention")
			self:Bar(L["wrath_other"]:format(rest), 8.5, "Spell_Arcane_Arcane02")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "SolaWCast" and self.db.profile.wrath then
		self:Bar(L["wrath"], 3, "Spell_Arcane_Arcane02")
		self:ScheduleEvent("BWSolaToTScan", self.WrathCheck, 1, self) --target scan once, after 1 second
	elseif sync == "SolaSplit" and self.db.profile.split then
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

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["split_trigger"]) and (GetTime() - split > 1) then
		split = GetTime()
		self:Sync("SolaSplit")
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

function mod:debuff(msg)
	local wplayer, wtype = select(3, msg:find(L["wrath_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = UnitName("player")
			self:CancelScheduledEvent("cancelProx") --incase they get the debuff twice, don't kill early
			self:TriggerEvent("BigWigs_ShowProximity", self) --you have the debuff, show the proximity window
			self:ScheduleEvent("cancelProx", "BigWigs_HideProximity", 8.5, self) --primary debuff lasts ~8.5 seconds, lets kill proximity after that
		end
		self:Sync("SolaWrath "..wplayer)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Personal")
		end
		self:CancelScheduledEvent("split1")
		self:TriggerEvent("BigWigs_StopBar", self, L["split_bar"])
	end
end

--Wrath is usually around a 3 second cast, and she takes a target, so we scan her target to try give some early advantage :)
function mod:WrathCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	else
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid"..i.."target") == boss then
				target = UnitName("raid"..i.."targettarget")
				break
			end
		end
	end
	if target then
		self:Message(L["wrath_alert"]:format(target), "Attention")
	end
end
