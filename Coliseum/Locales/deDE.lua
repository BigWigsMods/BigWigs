local L = BigWigs:NewBossLocale("Anub'arak", "deDE")
if L then
	L.engage_message = "Anub'arak angegriffen, Eingraben in 80 sek!"
	L.engage_trigger = "Dieser Ort wird Euch als Grab dienen!"

	L.unburrow_trigger = "entsteigt dem Boden"
	L.burrow_trigger = "gräbt sich in den Boden"
	L.burrow = "Eingraben"
	L.burrow_desc = "Zeigt Timer für Anub'araks Ein- und Ausgraben sowie für das Erscheinen der Nerubischen Gräber."
	L.burrow_cooldown = "~Eingraben"
	L.burrow_soon = "Eingraben bald!"

	L.nerubian_message = "Adds kommen!"
	L.nerubian_burrower = "Weitere Adds"

	L.shadow_soon = "Schattenhieb in ~5 sek!"

	L.freeze_bar = "~Gefrierender Streich"
	L.pcold_bar = "~Durchdringende Kälte"

	L.chase = "Verfolgen"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "deDE")
if L then
	L.enable_trigger = "Ihr habt den Ruf des Argentumkreuzzugs vernommen und seid ihm mutig gefolgt"
	L.wipe_trigger = "Tragisch..."

	L.engage_trigger = "Er kommt aus den tiefsten, dunkelsten Höhlen der Sturmgipfel - Gormok der Pfähler! Voran, Helden!"
	L.jormungars_trigger = "Stählt Euch, Helden, denn die Zwillingsschrecken Ätzschlund und Schreckensmaul erscheinen in der Arena!"
	L.icehowl_trigger = "Mit der Ankündigung unseres nächsten Kämpfers gefriert die Luft selbst: Eisheuler! Tötet oder werdet getötet, Champions!"
	L.boss_incoming = "%s kommt"

	-- Gormok
	L.snobold = "Schneebold"
	L.snobold_desc = "Warnt davor, wer einen Schneebold auf seinem Kopf hat."
	L.snobold_message = "Schneebold"
	L.impale_message = "%2$dx Pfählen: %1$s"
	L.firebomb_message = "Feuer auf DIR!"

	-- Jormungars
	L.submerge = "Eingraben"
	L.submerge_desc = "Zeigt die Zeit bis zum nächsten Eingraben der Würmer."
	L.spew = "Ätzender/Geschmolzener Auswurf"
	L.spew_desc = "Warnt vor Ätzender/Geschmolzener Auswurf."
	L.sprays = "Sprühen"
	L.sprays_desc = "Zeigt Zeitleisten für Paralysierendes und Brennendes Sprühen."
	L.slime_message = "Schleimpfütze auf DIR!"
	L.burn_spell = "Brennende Galle"
	L.toxin_spell = "Paralysierendes Toxin"
	L.spray = "~Sprühen"

	-- Icehowl
	L.butt_bar = "~Kopfstoß"
	L.charge = "Wütender Ansturm"
	L.charge_desc = "Warnt vor Wütender Ansturm auf Spielern."
	L.charge_trigger = "zornig an"
	L.charge_say = "Ansturm auf MIR!"

	L.bosses = "Bosse"
	L.bosses_desc = "Warnt, wann die nachfolgenden Bosse eintreffen."
end

L = BigWigs:NewBossLocale("Faction Champions", "deDE")
if L then
	L.enable_trigger = "Der nächste Kampf wird gegen die stärksten Ritter des Argentumkreuzzugs ausgefochten! Nur der Sieg wird Euren..."
	L.defeat_trigger = "Ein tragischer Sieg. Wir wurden schwächer durch die heutigen Verluste. Wer außer dem Lichkönig profitiert von solchen Torheiten? Große Krieger gaben ihr Leben. Und wofür? Die wahre Bedrohung erwartet uns noch - der Lichkönig erwartet uns alle im Tod."

	L["Shield on %s!"] = "Schild: %s!"
	L["Bladestorming!"] = "Klingensturm!"
	L["Hunter pet up!"] = "Jäger Pet da!"
	L["Felhunter up!"] = "Teufelsjäger da!"
	L["Heroism on champions!"] = "Heldentum auf Champions!"
	L["Bloodlust on champions!"] = "Kampfrausch auf Champions!"
end

L = BigWigs:NewBossLocale("Lord Jaraxxus", "deDE")
if L then
	L.enable_trigger = "Unbedeutender Gnom! Deine Arroganz wird dir zum Verhängnis!"

	L.engage = "Angegriffen"
	L.engage_trigger = "^Ihr steht vor Jaraxxus"
	L.engage_trigger1 = "Aber ich habe hier die Kontrollehhh..."

	L.adds = "Portale und Vulkane"
	L.adds_desc = "Zeigt einen Timer und warnt vor der Beschwörung der Portale und Vulkane."

	L.incinerate_message = "Einäschern"
	L.incinerate_other = "Einäschern: %s"
	L.incinerate_bar = "~Einäschern"
	L.incinerate_safe = "%s ist sicher!"

	L.legionflame_message = "Legionsflamme"
	L.legionflame_other = "Legionsflamme: %s"
	L.legionflame_bar = "~Legionsflamme"

	L.infernal_bar = "Vulkan kommt"
	L.netherportal_bar = "Netherportal kommt"
	L.netherpower_bar = "~Macht des Nether"

	L.kiss_message = "Kuss auf DIR!"
	L.kiss_interrupted = "Unterbrochen!"
end

L = BigWigs:NewBossLocale("The Twin Val'kyr", "deDE")
if L then
	L.engage_trigger1 = "Im Namen unseres dunklen Meisters. Für den Lichkönig. Ihr. Werdet. Sterben."

	L.vortex_or_shield_cd = "~Vortex/Schild"
	L.next = "Vortex/Schild"
	L.next_desc = "Warnt vor dem nächsten Vortex/Schild."

	L.vortex = "Vortex"
	L.vortex_desc = "Warnt, wenn die Zwillinge anfangen, einen Vortex zu wirken."

	L.shield = "Schild der Nacht/Licht"
	L.shield_desc = "Warnt bei Schild der Nacht/Licht."
	L.shield_half_message = "Schild bei 50% !"
	L.shield_left_message = " Schild: noch %d%%"

	L.touch = "Berührung der Nacht/Licht"
	L.touch_desc = "Warnt bei Berührung der Nacht/Licht."
end
