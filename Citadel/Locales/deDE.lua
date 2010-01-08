local L = BigWigs:NewBossLocale("Blood Princes", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Blood-Queen Lana'thel", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "deDE")
if L then
	L.adds = "Blutbestien"
	L.adds_desc = "Zeigt Timer und Nachrichten für das Auftauchen der Blutbestien."
	L.adds_warning = "Blutbestien in 5 sek!"
	L.adds_message = "Blutbestien!"
	L.adds_bar = "~Blutbestien"

	L.rune_bar = "~Rune"

	L.mark = "Mal %d"

	L.engage_trigger = "BEI DER MACHT DES LICHKÖNIGS!"
	--L.warmup_alliance = "Let's get a move on then! Move ou..."
	L.warmup_horde = "Kor'kron, Aufbruch! Champions, gebt Acht. Die Geißel ist..."
end

L = BigWigs:NewBossLocale("Festergut", "deDE")
if L then
	L.engage_trigger = "Fun time?"

	L.inhale_message = "Seuche einatmen %d"
	L.inhale_bar = "~Seuche einatmen %d"

	L.blight_warning = "Stechende Seuche in ~5 sek!"
	L.blight_bar = "~Stechende Seuche"

	L.bloat_message = "%2$dx Magenblähung: %1$s"
	L.bloat_bar = "~Magenblähung"

	L.spore_bar = "~Gassporen"
end

L = BigWigs:NewBossLocale("Icecrown Gunship Battle", "deDE")
if L then
	L.adds = "Portal"
	L.adds_desc = "Warnt vor den Portalen."
	--L.adds_trigger_alliance = "Reavers, Sergeants, attack!"
	L.adds_trigger_horde = "Soldaten! Zum Angriff!"
	L.adds_message = "Portal!"

	L.mage = "Magier"
	L.mage_desc = "Warnt, wenn ein Magier erscheint, um die Kanonen einzufrieren."
	L.mage_message = "Magier gespawnt!"
	L.mage_bar = "Nächster Magier"

	--L.enable_trigger_alliance = "Fire up the engines! We got a meetin' with destiny, lads!"
	L.enable_trigger_horde = "Erhebt Euch, Söhne und Töchter der Horde! Wir ziehen gegen einen verhassten Feind in die Schlacht! LOK'TAR OGAR!"

	--L.disable_trigger_alliance = "Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"
	L.disable_trigger_horde = "Die Allianz wankt. Vorwärts zum Lichkönig!"
end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "deDE")
if L then
	L.engage_trigger = "Was soll die Störung? Ihr wagt es, heiligen Boden zu betreten? Dies wird der Ort Eurer letzten Ruhe sein!"
	L.phase2_message = "Manabarriere weg - Phase 2!"

	L.dnd_message = "Tod und Verfall auf DIR!"

	L.adds = "Adds"
	L.adds_desc = "Zeigt Timer und Nachrichten für das Auftauchen der Adds."
	L.adds_bar = "~Adds"
	L.adds_warning = "Adds in 5 sek!"

	L.touch_message = "%2$dx Berührung: %1$s"
	L.touch_bar = "~Berührung"
end

L = BigWigs:NewBossLocale("Lord Marrowgar", "deDE")
if L then
	L.impale_cd = "~Aufspießen"

	L.bonestorm_cd = "~Knochensturm"
	L.bonestorm_warning = "Knochensturm in 5 sek!"

	L.coldflame_message = "Eisflamme auf DIR!"

	L.engage_trigger = "Die Geißel wird über diese Welt kommen wie ein Schwarm aus Tod und Zerstörung!"
end

L = BigWigs:NewBossLocale("Professor Putricide", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Putricide Dogs", "deDE")
if L then
	L.wound_message = "%2$dx Tödliche Wunde: %1$s"
end

L = BigWigs:NewBossLocale("Rotface", "deDE")
if L then
	L.infection_bar = "Infektion auf %s!"

	L.flood_trigger1 = "Gute Nachricht, Freunde! Die Giftschleim-Rohre sind repariert!"
	L.flood_trigger2 = "Gute Nachricht, Freunde! Der Schleim fließt wieder!"
	L.flood_warning = "Schleimflut bald!"
end

L = BigWigs:NewBossLocale("Sindragosa", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "deDE")
if L then

end
