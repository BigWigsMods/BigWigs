------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Void Reaver"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local previous

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Reaver",

	engage_trigger = "Alert! You are marked for extermination.",

	enrage = "Enrage",
	enrage_desc = "Enrage Timers",

	orbyou = "Arcane Orb on You",
	orbyou_desc = "Warn for Arcane Orb on you",
	orb_you = "Arcane Orb on YOU!",

	orbsay = "Arcane Orb Say",
	orbsay_desc = "Print in say when you are targeted for arcane orb, can help nearby members with speech bubbles on",
	orb_say = "Orb on Me!",

	orbother = "Arcane Orb on Others",
	orbother_desc = "Warn for Arcane Orb on others",
	orb_other = "Orb(%s)",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player targeted for Arcane Orb(requires promoted or higher)",

	pounding = "Pounding",
	pounding_desc = "Show Pounding timer bars",
	pounding_trigger1 = "Alternative measure commencing...",
	pounding_trigger2 = "Calculating force parameters...",
	pounding_nextbar = "~Pounding Cooldown",
	pounding_bar = "<Pounding>",
} end )

L:RegisterTranslations("deDE", function() return {
	enrage = "Wutanfall",
	enrage_desc = "Wutanfall Timer",

	orbyou = "Arkane Kugel auf dir",
	orbyou_desc = "Warnt vor Arkane Kugel auf dir",

	orbsay = "Arkane Kugel Ansage",
	orbsay_desc = "Schreibt im Say, wenn eine Arkane Kugel auf deine Position fliegt, kann nahen Partymember mit aktivierten Sprechblasen helfen",

	orbother = "Arkane Kugel auf Anderen",
	orbother_desc = "Warn for Arcane Orb on others",

	icon = "Raid Icon",
	icon_desc = "Plaziert ein Raid Icon auf dem Spieler auf den Arkane Kugel zufliegt (ben?tigt Anf\195\188hrer oder Assistent)",

	pounding = "H\195\164mmern",
	pounding_desc = "Timer Balken f?r H\195\164mmern",

	orb_other = "Kugel(%s)",
	orb_you = "Arkane Kugel auf DIR!",
	orb_say = "Kugel auf Mir!",

	pounding_nextbar = "~H\195\164mmern Cooldown",
	pounding_bar = "<H\195\164mmern>",
} end )

L:RegisterTranslations("frFR", function() return {
	enrage = "Enrager",
	enrage_desc = "Affiche le délai avant que le Saccageur du Vide ne devienne enragé.",

	orbyou = "Orbe des arcanes sur vous",
	orbyou_desc = "Préviens quand vous êtes ciblé par l'Orbe des arcanes.",

	orbsay = "Dire - Orbe des arcanes",
	orbsay_desc = "Fais dire à votre personnage qu'il est ciblé par l'Orbe des arcanes quand c'est le cas, afin d'aider les membres proches.",

	orbother = "Orbe des arcanes sur les autres",
	orbother_desc = "Préviens quand les autres sont ciblés par l'Orbe des arcanes.",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne ciblée par l'Orbe des arcanes (nécessite d'être promu ou mieux).",

	pounding = "Martèlement ",
	pounding_desc = "Affiche des barres temporelles pour les Martèlements.",

	orb_other = "Orbe (%s)",
	orb_you = "Orbe des arcanes sur VOUS !",
	orb_say = "Orbe sur moi !",

	pounding_nextbar = "~Cooldown Martèlement",
	pounding_bar = "<Martèlement>",
} end )

L:RegisterTranslations("koKR", function() return {
	enrage = "격노",
	enrage_desc = "격노 타이머",

	orbyou = "자신의 비전 보주",
	orbyou_desc = "자신의 비전 보주 알림",

	orbsay = "비전 보주 대화",
	orbsay_desc = "당신이 비전 보주의 대상이 되었을 때 대화를 출력합니다",

	orbother = "타인의 비전 보주",
	orbother_desc = "타인의 비전 보주 알림",

	icon = "공격대 아이콘",
	icon_desc = "비전 보주 대상이된 플레이어에 공격대 아이콘 지정(승급자 이상 권한 필요)",

	pounding = "울림",
	pounding_desc = "울림 타이머 바 표시",

	orb_other = "보주(%s)",
	orb_you = "당신에 비전 보주!",
	orb_say = "나에게 보주!",

	pounding_nextbar = "~울림 대기 시간",
	pounding_bar = "<울림>",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "pounding", -1, "orbyou", "orbsay", "orbother", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	previous = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if self.db.profile.orbyou or self.db.profile.orbother then
			self:ScheduleRepeatingEvent("BWReaverToTScan", self.OrbCheck, 0.2, self) --how often to scan the target, 0.2 seconds
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 10), "Important")
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
	elseif self.db.profile.pounding and (msg == L["pounding_trigger1"] or msg == L["pounding_trigger2"]) then
		self:Bar(L["pounding_bar"], 3, "Ability_ThunderClap")
		self:Bar(L["pounding_nextbar"], 13, "Ability_ThunderClap")
	end
end

function mod:OrbCheck()
	local id, target
	--if Void reaver is your target, scan hes target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
		id = "targettarget"
	else
		--if Void Reaver isn't your target, scan raid members targets, hopefully one of them has him targeted and we can get hes target from there
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid"..i.."target") == boss then
				target = UnitName("raid"..i.."targettarget")
				id = "raid"..i.."targettarget"
				break
			end
		end
	end
	if target ~= previous and UnitExists(target) then --spam protection & wierdness protection
		if target and id then
			if UnitPowerType(id) == 0 then --if the player has mana it is most likely ranged, we don't want other units(energy/rage would be melee)
				self:Result(target) --pass the unit with mana through
			end
			previous = target --create spam protection filter
		else
			previous = nil
		end
	end
end

function mod:Result(target)
	if target == UnitName("player") and self.db.profile.orbyou then
		self:Message(L["orb_you"], "Personal", true, "Long")
		self:Message(L["orb_other"]:format(target), "Attention", nil, nil, true)

		--this is handy for player with speech bubbles enabled to see if nearby players are being hit and run away from them
		if self.db.profile.orbsay then
			SendChatMessage(L["orb_say"], "SAY")
		end
	elseif self.db.profile.orbother then
		self:Message(L["orb_other"]:format(target), "Attention")
	end
	if self.db.profile.icon then 
		self:Icon(target)
	end
end
