local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "deDE")
if L then
	L.engage_message = "Anub'arak angegriffen, Eingraben in 80 sek!"
	L.engage_trigger = "Dieser Ort wird Euch als Grab dienen!"

	L.unburrow_trigger = "%s entsteigt dem Boden!"
	L.burrow_trigger = "%s gräbt sich in den Boden!"
	L.burrow = "Eingraben"
	L.burrow_desc = "Zeigt einen Timer für Anub'arak's Eingraben."
	L.burrow_cooldown = "~Eingraben"
	L.burrow_soon = "Eingraben bald!"
	
	L.icon = "Schlachtzugs-Symbol"
	L.icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Anub'arak verfolgt werden (benötigt Assistent oder höher)."
	
	L.chase = "Verfolgen"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "deDE")
if L then
	L.engage_trigger = "Er kommt aus den tiefsten, dunkelsten Höhlen der Sturmgipfel - Gormok der Pfähler! Voran, Helden!"
	L.jormungars_trigger = "Stählt Euch, Helden, denn die Zwillingsschrecken Ätzschlund und Schreckensmaul erscheinen in der Arena!"
	L.icehowl_trigger = "Mit der Ankündigung unseres nächsten Kämpfers gefriert die Luft selbst: Eisheuler! Tötet oder werdet getötet, Champions!"
	L.boss_incoming = "%s kommt"

	-- Gormok
	L.snobold = "Schneebold"
	L.snobold_desc = "Warnt davor, wer einen Schneebold auf seinem Kopf hat."
	L.snobold_message = "Schneebold: %s!"
	L.impale_message = "%2$dx Pfählen: %1$s!"
	L.firebomb_message = "Feuerbombe auf DIR!"

	-- Jormungars
	L.spew = "Ätzender/Geschmolzener Auswurf"
	L.spew_desc = "Warnt vor Ätzender/Geschmolzener Auswurf."

	L.slime_message = "Schleimpfütze auf DIR!"
	L.burn_spell = "Galle"
	L.toxin_spell = "Toxin"

	-- Icehowl
	L.butt_bar = "~Kopfstoß"
	L.charge = "Wütender Ansturm"
	L.charge_desc = "Warnt vor Wütender Ansturm auf Spielern."
	L.charge_trigger = "^zornig an und lässt einen gewaltigen Schrei ertönen!"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "deDE")
if L then
	L.enable_trigger = "Der nächste Kampf wird gegen die stärksten Ritter des Argentumkreuzzugs ausgefochten! Nur der Sieg wird Euren..."
	-- L.defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death."

	L["Shield on %s!"] = "Schild: %s!"
	L["Bladestorming!"] = "Klingensturm!"
	L["Hunter pet up!"] = "Jäger Pet da!"
	L["Felhunter up!"] = "Teufelsjäger da!"
	L["Heroism on champions!"] = "Heldentum auf Champions!"
	L["Bloodlust on champions!"] = "Kampfrausch auf Champions!"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "deDE")
if L then
	L.engage = "Angegriffen"
	L.engage_trigger = "^Ihr steht vor Jaraxxus"
	--L.engage_trigger1 = "Banished to the Nether" --need!

	L.incinerate_message = "Einäschern"
	L.incinerate_other = "Einäschern: %s"
	L.incinerate_bar = "~Einäschern"

	L.legionflame_message = "Legionsflamme"
	L.legionflame_other = "Legionsflamme: %s"
	L.legionflame_bar = "~Legionsflamme"

	L.icon = "Schlachtzugs-Symbol"
	L.icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern mit Legionsflamme (benötigt Assistent oder höher)."

	L.netherportal_bar = "~Netherportal"
	L.netherpower_bar = "~Macht des Nether"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "deDE")
if L then
	L.engage_trigger1 = "Im Namen unseres dunklen Meisters. Für den Lichkönig. Ihr. Werdet. Sterben."

	L.vortex_or_shield_cd = "~Vortex/Schild"

	L.vortex = "Vortex"
	L.vortex_desc = "Warnt, wenn die Zwillinge anfangen Vortex zu wirken."

	L.shield = "Schild der Nacht/Licht"
	L.shield_desc = "Warnt bei Schild der Nacht/Licht."
	
	L.touch = "Berührung der Nacht/Licht"
	L.touch_desc = "Warnt bei Berührung der Nacht/Licht."
end
