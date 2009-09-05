local L = LibStub("AceLocale-3.0"):NewLocale("BigWigsArchavon the Stone Watcher", "deDE")
if L then
	L.stomp_message = "Stampfen - Ansturm bald!"
	L.stomp_warning = "Mögliches Stampfen in ~5 sek!"
	L.stomp_bar = "~Stampfen"

	L.cloud_message = "Erstickende Wolke auf DIR!"

	L.charge = "Ansturm"
	L.charge_desc = "Warnt, wenn ein Spieler angestürmt wird."

	L.icon = "Schlachtzugs-Symbol"
	L.icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Felssplitter gewirkt wird (benötigt Assistent oder höher)."
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsEmalon the Storm Watcher", "deDE")
if L then
	L.nova_next = "~Blitzschlagnova"

	L.overcharge_message = "Sturmdiener überladen!"
	L.overcharge_bar = "Explosion"
	L.overcharge_next = "~Überladen"

	L.icon = "Schlachtzugs-Symbol"
	L.icon_desc = "Platziert ein Schlachtzugs-Symbol (Totenkopf) auf dem Sturmdiener, der von Überladen betroffen ist (benötigt Assistent oder höher)."
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsMalygos", "deDE")
if L then
	L.sparks = "Energiefunke"
	L.sparks_desc = "Warnungen und Timer für das Erscheinen von Energiefunken."
	L.sparks_message = "Energiefunke!"
	L.sparks_warning = "Energiefunke in ~5 sek!"

	L.sparkbuff_message = "Malygos bekommt Energiefunke!"

	L.vortex = "Vortex"
	L.vortex_desc = "Warnungen und Timer für Vortex in Phase 1."
	L.vortex_message = "Vortex!"
	L.vortex_warning = "Vortex in ~5 sek!"
	L.vortex_next = "~Vortex"

	L.breath = "Tiefer Atem"
	L.breath_desc = "Warnungen und Timer für Tiefer Atem (Kraftsog) in Phase 2."
	L.breath_message = "Tiefer Atem!"
	L.breath_warning = "Tiefer Atem in ~5 sek!"

	L.surge = "Kraftsog"
	L.surge_desc = "Warnt, wenn du von Kraftsog in Phase 3 betroffen ist."
	L.surge_you = "Kraftsog auf DIR!"
	L.surge_trigger = "Die Augen von %s sind auf Euch fixiert!"

	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."
	L.phase2_warning = "Phase 2 bald!"
	L.phase2_trigger = "Ich hatte gehofft, eure Leben schnell zu beenden, doch ihr zeigt euch... hartnäckiger als erwartet. Nichtsdestotrotz sind eure Bemühungen vergebens. Ihr törichten, leichtfertigen Sterblichen tragt die Schuld an diesem Krieg. Ich tue, was ich tun muss, und wenn das eure Auslöschung bedeutet... dann SOLL ES SO SEIN!"
	L.phase2_message = "Phase 2, Nexuslords & Saat der Ewigkeit!"
	L.phase2_end_trigger = "GENUG! Wenn ihr die Magie Azeroths zurückhaben wollt, dann sollt ihr sie bekommen!"
	L.phase3_warning = "Phase 3 bald!"
	L.phase3_trigger = "Eure Wohltäter sind eingetroffen, doch sie kommen zu spät! Die hier gespeicherten Energien reichen aus, die Welt zehnmal zu zerstören. Was, denkt ihr, werden sie mit euch machen?"
	L.phase3_message = "Phase 3!"
end

L = LibStub("AceLocale-3.0"):NewLocale("BigWigsSartharion", "deDE")
if L then
	L.engage_trigger = "Meine Aufgabe ist es, über diese Eier zu wachen. Kommt ihnen zu nahe und von euch bleibt nur ein Häuflein Asche."

	L.tsunami = "Flammentsunami"
	L.tsunami_desc = "Warnungen und Timer für Flammentsunami."
	L.tsunami_warning = "Flammentsunami in ~5 sek!"
	L.tsunami_message = "Flammentsunami!"
	L.tsunami_cooldown = "~Flammentsunami"
	L.tsunami_trigger = "Die Lava um %s brodelt!"

	L.breath_cooldown = "~Flammenatem"

	L.drakes = "Drachen"
	L.drakes_desc = "Warnungen und Timer für den Kampfbeitritt der Drachen."
	L.drakes_incomingsoon = "%s kommt in ~5 sek!"

	L.twilight = "Zwielicht Ereignisse"
	L.twilight_desc = "Warnungen und Timer für Ereignisse in der Zwielichtzone."
	L.twilight_trigger_tenebron = "Tenebron beginnt im Zwielicht Eier auszubrüten!"
	L.twilight_trigger_vesperon = "Ein Vesperonjünger erscheint im Zwielicht!"
	L.twilight_trigger_shadron = "Ein Shadronjünger erscheint im Zwielicht!"
	L.twilight_message_tenebron = "Eier schlüpfen"
	L.twilight_message = "%s kommt dazu!"
end
