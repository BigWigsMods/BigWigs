if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Algalon", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt vor Phasenwechsel.",
	engage_warning = "Phase 1",
	phase2_warning = "Phase 2 bald!",
	phase_bar = "Phase %d",
	engage_trigger = "Euer Handeln ist unlogisch. Alle Möglichkeiten dieser Begegnung wurden berechnet. Das Pantheon wird die Nachricht des Beobachters erhalten, ungeachtet des Ausgangs.",

	punch_message = "%dx Phasenschlag: %s!",
	smash_message = "Kosmischer Schlag kommt!",
	blackhole_message = "Schwarzes Loch %dx!",
	bigbang_soon = "Großer Knall bald!",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Auriaya", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	fear_warning = "Furcht bald!",
	fear_message = "Furcht!",
	fear_bar = "~Furcht",

	swarm_message = "Wächterschwarm",
	swarm_bar = "~Wächterschwarm",

	defender = "Wilder Verteidiger",
	defender_desc = "Warnt, wieviele Leben der Wilder Verteidiger noch hat.",
	defender_message = "Verteidiger da %d/9!",

	sonic_bar = "~Überschallkreischen",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Freya", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "Das Konservatorium muss verteidigt werden!",
	engage_trigger2 = "Ihr Ältesten, gewährt mir Eure Macht!",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase2_message = "Phase 2",

	wave = "Wellen",
	wave_desc = "Warnt vor den Wellen.",
	wave_bar = "Nächste Welle",
	conservator_trigger = "Eonar, Eure Dienerin braucht Hilfe!",
	detonate_trigger = "Der Schwarm der Elemente soll über Euch kommen!",
	elementals_trigger = "Helft mir, Kinder!",
	tree_trigger = "Ein |cFF00FFFFGeschenk der Lebensbinderin|r fängt an zu wachsen!",
	conservator_message = "Konservator!",
	detonate_message = "Explosionspeitscher!",
	elementals_message = "Elementare!",
	tree_message = "Eonars Geschenk!",

	fury_message = "Furor",
	fury_other = "Furor: %s",

	tremor_warning = "Bebende Erde bald!",
	tremor_bar = "~Bebende Erde",
	energy_message = "Instabile Energie auf DIR!",
	sunbeam_message = "Sonnenstrahl!",
	sunbeam_bar = "~Sonnenstrahl",
	
	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Sonnenstrahl und Furor der Natur betroffen sind (benötigt Assistent oder höher).",

	end_trigger = "Seine Macht über mich beginnt zu schwinden. Endlich kann ich wieder klar sehen. Ich danke Euch, Helden.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Hodir", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Für Euer Eindringen werdet Ihr bezahlen!",

	cold = "Beißende Kälte",
	cold_desc = "Warnt, wenn du zwei Stapel von Beißende Kälte hast.",
	cold_message = "Beißende Kälte x%d!",

	flash_warning = "Blitzeis!",
	flash_soon = "Blitzeis in 5 sek!",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Sturmwolke betroffen sind (benötigt Assistent oder höher).",

	end_trigger = "Ich... bin von ihm befreit... endlich.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Ignis", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ihr anmaßenden Wichte! Euer Blut wird die Waffen härten, mit denen diese Welt erobert wird!",

	construct_message = "Konstrukt aktiviert!",
	construct_bar = "Nächstes Konstrukt",
	brittle_message = "Konstrukt ist spröde!",
	flame_bar = "~Flammenstrahlen",
	scorch_message = "Versengen auf DIR!",
	scorch_soon = "Versengen in ~5 sek!",
	scorch_bar = "Nächstes Versengen",
	slagpot_message = "Schlackentopf: %s",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Iron Council", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "So leicht werdet Ihr die Versammlung des Eisens nicht bezwingen, Eindringlinge!",
	engage_trigger2 = "Nur vollständige Dezimierung wird mich zufriedenstellen.",
	engage_trigger3 = "Selbst wenn Ihr die größten Helden der Welt seid, so seid Ihr doch nichts weiter als Sterbliche.",

	overload_message = "Überladen in 6 sek!",
	death_message = "Todesrune auf DIR!",
	summoning_message = "Elementare!",

	chased_other = "%s wird verfolgt!",
	chased_you = "DU wirst verfolgt!",

	overwhelm_other = "Überwältigende Kraft: %s",

	shield_message = "Runenschild!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die während der Blitzrankenphase verfolgt werden oder von Überwältigende Kraft betroffen sind (benötigt Assistent oder höher).",

	council_dies = "%s getötet!",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kologarn", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	arm = "Arm stirbt",
	arm_desc = "Warnung und Timer für das Sterben des linken & rechten Arms.",
	left_dies = "Linker Arm stirbt!",
	right_dies = "Rechter Arm stirbt!",
	left_wipe_bar = "Neuer linker Arm",
	right_wipe_bar = "Neuer rechter Arm",

	shockwave = "Schockwelle",
	shockwave_desc = "Timer für die Schockwelle.",
	shockwave_trigger = "AUSLÖSCHUNG!",

	eyebeam = "Fokussierter Augenstrahl",
	eyebeam_desc = "Warnt, wenn du von Fokussierter Augenstrahl betroffen bist.",
	eyebeam_trigger = "%s fokussiert seinen Blick auf Euch!",
	eyebeam_message = "Augenstrahl: %s",
	eyebeam_bar = "~Augenstrahl",
	eyebeam_you = "Augenstrahl auf DIR!",
	eyebeam_say = "Augenstrahl auf MIR!",

	eyebeamsay = "Augenstrahl /sagen",
	eyebeamsay_desc = "Verkündet, wenn du das Ziel des Augenstrahls bist.",

	armor_message = "%2$dx Rüstung zermalmen: %1$s!",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Feindeinheiten erkannt",
	engage_message = "%s angegriffen!",

	pursue = "Verfolgen",
	pursue_desc = "Warnt, wenn der Flammenleviathan einen Spieler verfolgt.",
	pursue_trigger = "^%%s verfolgt",
	pursue_other = "Verfolgen: %s",

	shutdown_message = "Systemabschaltung!",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Mimiron", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	engage_warning = "Phase 1",
	engage_trigger = "^Wir haben nicht viel Zeit, Freunde!",
	phase2_warning = "Phase 2",
	phase2_trigger = "WUNDERBAR! Das sind Ergebnisse nach meinem Geschmack! Integrität der Hülle bei 98,9 Prozent! So gut wie keine Dellen! Und weiter geht's.",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Danke Euch, Freunde! Eure Anstrengungen haben fantastische Daten geliefert!",
	phase4_warning = "Phase 4",
	phase4_trigger = "Vorversuchsphase abgeschlossen. Jetzt kommt der eigentliche Test!",
	phase_bar = "Phase %d",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",
	hardmode_trigger = "^Warum habt Ihr das denn jetzt gemacht?",
	hardmode_message = "Hard Mode aktiviert!",
	hardmode_warning = "BOOM!",

	plasma_warning = "Wirkt Plasmaeruption!",
	plasma_soon = "Plasmaeruption bald!",
	plasma_bar = "Plasmaeruption",

	shock_next = "~Schockschlag",

	laser_soon = "Lasersalve!",
	laser_bar = "Lasersalve",

	magnetic_message = "Einheit am Boden!",

	suppressant_warning = "Löschschaum kommt!",

	fbomb_soon = "Frostbombe bald!",
	fbomb_bar = "~Frostbombe",

	bomb_message = "Bombenbot!",

	end_trigger = "^Es scheint, als wäre mir",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Razorscale", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	["Razorscale Controller"] = "Klingenschuppe Controller",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	ground_trigger = "Beeilt Euch! Sie wird nicht lange am Boden bleiben!",
	ground_message = "Angekettet!",
	air_trigger = "Gebt uns einen Moment, damit wir uns auf den Bau der Geschütze vorbereiten können.",
	air_trigger2 = "Feuer einstellen! Lasst uns diese Geschütze reparieren!",
	air_message = "Hebt ab!",
	phase2_trigger = "%s dauerhaft an den Boden gebunden!",
	phase2_message = "Phase 2",
	phase2_warning = "Phase 2 bald!",
	stun_bar = "Betäubt",

	breath_trigger = "%s holt tief Luft...",
	breath_message = "Flammenatem!",
	breath_bar = "~Flammenatem",

	flame_message = "Verschlingende Flamme auf DIR!",

	harpoon = "Harpunengeschütze",
	harpoon_desc = "Warnungen und Timer für die Harpunengeschütze.",
	harpoon_message = "Harpunengeschütz %d bereit!",
	harpoon_trigger = "Harpunengeschütz ist einsatzbereit!",
	harpoon_nextbar = "Geschütz %d",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thorim", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase1_message = "Phase 1",
	phase2_trigger = " Eindringlinge! Ihr Sterblichen, die Ihr es wagt, Euch in mein Vergnügen einzumischen, werdet... Wartet... Ihr...", -- space in the beginning!
	phase2_message = "Phase 2 - Berserker in 6:15 min!",
	phase3_trigger = "Ihr unverschämtes Geschmeiß! Ihr wagt es, mich in meinem Refugium herauszufordern? Ich werde Euch eigenhändig zerschmettern!",
	phase3_message = "Phase 3 - %s angegriffen!",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",
	hardmode_warning = "Hard Mode beendet!",

	shock_message = "DU wirst geschockt!",
	barrier_message = "Runenbarriere oben!",

	detonation_say = "Ich bin die Bombe!",

	charge_message = "Blitzladung x%d!",
	charge_bar = "Blitzladung %d",

	strike_bar = "~Schlag",

	end_trigger = "Senkt Eure Waffen! Ich ergebe mich!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Runendetonation und Sturmhammer betroffen sind (benötigt Assistent oder höher).",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: General Vezax", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Eure Vernichtung wird ein neues Zeitalter des Leids einläuten!",

	surge_message = "Sog %d!",
	surge_cast = "Wirkt Sog %d",
	surge_bar = "Sog %d",

	animus = "Saronitanimus",
	animus_desc = "Warnt, wenn ein Saronitanimus auftaucht.",
	animus_trigger = "Die Saronitdämpfe sammeln sich, wirbeln heftig herum und verschmelzen zu einer monströsen Form!",
	animus_message = "Saronitanimus kommt!",

	vapor = "Saronitdämpfe",
	vapor_desc = "Warnung und Timer für das Auftauchen von Saronitdämpfen.",
	vapor_message = "Saronitdämpfe %d!",
	vapor_bar = "Saronitdämpfe %d/6",
	vapor_trigger = "Eine Wolke Saronitdämpfe bildet sich in der Nähe!",

	vaporstack = "Saronitdämpfe Stapel",
	vaporstack_desc = "Warnt, wenn du 5 oder mehr Stapel der Saronitdämpfe hast.",
	vaporstack_message = "Saronitdämpfe x%d!",

	crash_say = "Schattengeschoss auf MIR!",

	crashsay = "Schattengeschoss Sagen",
	crashsay_desc = "Warnt im Sagen Chat, wenn du das Ziel eines Schattengeschosses bist.",

	crashicon = "Schattengeschoss: Schlachtzugs-Symbol",
	crashicon_desc = "Platziert das zweite Schlachtzugs-Symbol auf Spielern, die von Schattengeschoss betroffen sind (benötigt Assistent oder höher).",

	mark_message = "Mal",
	mark_message_other = "Mal: %s",

	icon = "Mal der Gesichtslosen: Schlachtzugs-Symbol",
	icon_desc = "Platziert das erste Schlachtzugs-Symbol auf Spielern, die von Mal der Gesichtslosen betroffen sind (benötigt Assistent oder höher).",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: XT-002", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	exposed_warning = "Freigelegtes Herz bald!",
	exposed_message = "Herz freigelegt!",

	gravitybomb_other = "Gravitationsbombe: %s",

	gravitybombicon = "Gravitationsbombe: Schlachtzugs-Symbol",
	gravitybombicon_desc = "Platziert ein blaues Quadrat auf Spielern, die von Gravitationsbombe getroffen werden (benötigt Assistent oder höher).",

	lighticon = "Sengendes Licht: Schlachtzugs-Symbol",
	lighticon_desc = "Platziert einen Totenkopf auf Spielern, die von Sengendes Licht betroffen sind (benötigt Assistent oder höher).",
	
	lightbomb_other = "Lichtbombe: %s",

	tantrum_bar = "~Betäubender Koller",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Yogg-Saron", "enUS", true)
L:RegisterTranslations("deDE", function() return {
	["Crusher Tentacle"] = "Schmettertentakel",
	["The Observation Ring"] = "Der Beobachtungsring",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	engage_warning = "Phase 1",
	engage_trigger = "^Bald ist die Zeit",
	phase2_warning = "Phase 2",
	phase2_trigger = "^Ich bin der strahlende Traum",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Erblickt das wahre Antlitz des Todes",

	portal = "Portale",
	portal_desc = "Warnt, wenn Portale erscheinen.",
	portal_trigger = "Portale öffnen sich im Geist von %s!",
	portal_message = "Portale offen!",
	portal_bar = "Nächsten Portale",

	sanity_message = "DU wirst verrückt!",

	weakened = "Geschwächt",
	weakened_desc = "Warnt, wenn Yogg-Saron geschwächt ist.",
	weakened_message = "%s ist geschwächt!",
	weakened_trigger = "Die Illusion fällt in sich zusammen und der Weg in den zentralen Raum wird frei!",

	madness_warning = "Wahnsinn in 5 sek!",
	malady_message = "Geisteskrank: %s!",

	tentacle = "Schmettertentakel",
	tentacle_desc = "Warnung und Timer für das Auftauchen der Schmettertentakel.",
	tentacle_message = "Schmettertentakel %d!",

	link_warning = "DU bist verbunden!",

	gaze_bar = "~Blick",
	empower_bar = "~Machtvolle Schatten",

	guardian_message = "Wächter %d!",

	empowericon = "Schatten-Symbol",
	empowericon_desc = "Platziert einen Totenkopf über der Unvergänglichen Wache, die von Machtvolle Schatten betroffen ist (benötigt Assistent oder höher).",
	empowericon_message = "Schatten verblasst!",

	roar_warning = "Gebrüll in 5 sek!",
	roar_bar = "Nächstes Gebrüll",
} end )
