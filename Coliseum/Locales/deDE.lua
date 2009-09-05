if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_message = "Anub'arak angegriffen, Eingraben in 80 sek!",
	engage_trigger = "Dieser Ort wird Euch als Grab dienen!",

	unburrow_trigger = "%s entsteigt dem Boden!",
	burrow_trigger = "%s gräbt sich in den Boden!",
	burrow = "Eingraben",
	burrow_desc = "Zeigt einen Timer für Anub'arak's Eingraben.",
	burrow_cooldown = "~Eingraben",
	burrow_soon = "Eingraben bald!",
	
	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Anub'arak verfolgt werden (benötigt Assistent oder höher).",
	
	chase = "Verfolgen",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Er kommt aus den tiefsten, dunkelsten Höhlen der Sturmgipfel - Gormok der Pfähler! Voran, Helden!",
	jormungars_trigger = "Stählt Euch, Helden, denn die Zwillingsschrecken Ätzschlund und Schreckensmaul erscheinen in der Arena!",
	icehowl_trigger = "Mit der Ankündigung unseres nächsten Kämpfers gefriert die Luft selbst: Eisheuler! Tötet oder werdet getötet, Champions!",
	boss_incoming = "%s kommt",

	-- Gormok
	snobold = "Schneebold",
	snobold_desc = "Warnt davor, wer einen Schneebold auf seinem Kopf hat.",
	snobold_message = "Schneebold: %s!",
	impale_message = "%2$dx Pfählen: %1$s!",
	firebomb_message = "Feuerbombe auf DIR!",

	-- Jormungars
	spew = "Ätzender/Geschmolzener Auswurf",
	spew_desc = "Warnt vor Ätzender/Geschmolzener Auswurf.",

	slime_message = "Schleimpfütze auf DIR!",
	burn_spell = "Galle",
	toxin_spell = "Toxin",

	-- Icehowl
	butt_bar = "~Kopfstoß",
	charge = "Wütender Ansturm",
	charge_desc = "Warnt vor Wütender Ansturm auf Spielern.",
	charge_trigger = "^zornig an und lässt einen gewaltigen Schrei ertönen!",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	enable_trigger = "Der nächste Kampf wird gegen die stärksten Ritter des Argentumkreuzzugs ausgefochten! Nur der Sieg wird Euren...",
	--defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death.",

	["Shield on %s!"] = "Schild: %s!",
	["Bladestorming!"] = "Klingensturm!",
	["Hunter pet up!"] = "Jäger Pet da!",
	["Felhunter up!"] = "Teufelsjäger da!",
	["Heroism on champions!"] = "Heldentum auf Champions!",
	["Bloodlust on champions!"] = "Kampfrausch auf Champions!",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage = "Angegriffen",
	engage_trigger = "^Ihr steht vor Jaraxxus",
	--engage_trigger1 = "Banished to the Nether", --need!

	incinerate_message = "Einäschern",
	incinerate_other = "Einäschern: %s",
	incinerate_bar = "~Einäschern",

	legionflame_message = "Legionsflamme",
	legionflame_other = "Legionsflamme: %s",
	legionflame_bar = "~Legionsflamme",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern mit Legionsflamme (benötigt Assistent oder höher).",

	netherportal_bar = "~Netherportal",
	netherpower_bar = "~Macht des Nether",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "Im Namen unseres dunklen Meisters. Für den Lichkönig. Ihr. Werdet. Sterben.",

	vortex_or_shield_cd = "~Vortex/Schild",

	vortex = "Vortex",
	vortex_desc = "Warnt, wenn die Zwillinge anfangen Vortex zu wirken.",

	shield = "Schild der Nacht/Licht",
	shield_desc = "Warnt bei Schild der Nacht/Licht.",

	touch = "Berührung der Nacht/Licht",
	touch_desc = "Warnt bei Berührung der Nacht/Licht.",
} end)
