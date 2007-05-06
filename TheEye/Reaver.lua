------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Void Reaver"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local started
local previous

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Reaver",

	enrage = "Enrage",
	enrage_desc = "Enrage Timers",

	orbyou = "Arcane Orb on You",
	orbyou_desc = "Warn for Arcane Orb on you",

	orbsay = "Arcane Orb Say",
	orbsay_desc = "Print in say when you are targeted for arcane orb, can help nearby members with speech bubbles on",

	orbother = "Arcane Orb on Others",
	orbother_desc = "Warn for Arcane Orb on others",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player targeted for Arcane Orb(requires promoted or higher)",

	pounding = "Pounding",
	pounding_desc = "Show Pounding timer bars",

	orb_other = "Orb(%s)",
	orb_you = "Arcane Orb on YOU!",
	orb_say = "Orb on Me!",

	pounding_trigger = "Pounding",
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

	pounding_trigger = "H\195\164mmern",
	pounding_nextbar = "~H\195\164mmern Cooldown",
	pounding_bar = "<H\195\164mmern>",
} end )

L:RegisterTranslations("frFR", function() return {
	enrage = "Enrager",
	enrage_desc = "Affiche l\195\169 délai avant que le Saccageur du Vide ne devienne enrag\195\169.",

	orbyou = "Orbe des arcanes sur vous",
	orbyou_desc = "Pr\195\169viens quand vous \195\170tes cibl\195\169 par l'Orbe des arcanes.",

	orbsay = "Dire - Orbe des arcanes",
	orbsay_desc = "Fais dire \195\160 votre personnage qu'il est cibl\195\169 par l'Orbe des arcanes quand c'est le cas, afin d'aider les membres proches.",

	orbother = "Orbe des arcanes sur les autres",
	orbother_desc = "Pr\195\169viens quand les autres sont cibl\195\169s par l'Orbe des arcanes.",

	icon = "Ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur la personne cibl\195\169e par l'Orbe des arcanes (n\195\169cessite d'\195\170tre promu ou mieux).",

	pounding = "Mart\195\168lement ",
	pounding_desc = "Affiche des barres temporelles pour les Mart\195\168lements.",

	orb_other = "Orbe (%s)",
	orb_you = "Orbe des arcanes sur VOUS !",
	orb_say = "Orbe sur moi !",

	pounding_trigger = "Mart\195\168lement",
	pounding_nextbar = "~Cooldown Mart\195\168lement",
	pounding_bar = "<Mart\195\168lement>",
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
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ReaverPound", 6)

	started = nil
	previous = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
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
	elseif sync == "ReaverPound" and self.db.profile.pounding then
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
	if target ~= previous then --spam protection
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

function mod:UNIT_SPELLCAST_CHANNEL_START(msg)
	if UnitName(msg) == boss and (UnitChannelInfo(msg)) == L["pounding_trigger"] then
		self:Sync("ReaverPound")
	end
end
