local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "deDE")
if not L then return end
if L then
	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discs)"
	L.attenuation_message = "Incoming Discs, Dance!"

	L.platform_emote = "platforms" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "inhales"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "Swapping Platform"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "deDE")
if L then
	L.unseenstrike_cone = "Unsichtbarer Stoß"

	L.assault = "Überwältigender Angriff"
	L.assault_desc = "Nur für Tanks. Dieser Angriff legt die Verteidigung des Ziels offen und erhöht dadurch für 45 Sekunden den erlittenen Schaden des Ziels um 100%."
end

L = BigWigs:NewBossLocale("Garalon", "deDE")
if L then
	L.crush_stun = "Zermalmen STUN"
	L.crush_trigger1 = "Garalon macht sich bereit" -- heroic trigger  
	L.crush_trigger2 = "Garalon spürt" -- normalmode trigger
	L.crush_trigger3 = "Garalon detects"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "deDE")
if L then
	L.next_pack = "Nächste Gruppe (heroisch)"
	L.next_pack_desc = "Warnung, wann eine neue Gruppe landen wird, nachdem ihr eine Gruppe getötet habt."

	L.spear_removed = "Dein durchbohrender Speer wurde entfernt!"
	L.residue_removed = "%s entfernt!"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "deDE")
if L then
	L.explosion_casting = "Amberexplosionen"
	L.explosion_casting_desc = "Warnungen für alle Arten von Amberexplosionen. Hervorheben dieser Warnung wird strengstens empfohlen!"

	L.willpower = "Willenskraft" 
	L.willpower_desc = "Wenn die Willenskraft erschöpft ist, stirbt der Spieler und das mutierte Konstrukt beginnt unkontrolliert zu handeln."
	L.willpower_message = "Deine Willenskraft ist bei: %d (%d)"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "deDE")
if L then
	L.phases = "Phasen"
	L.phases_desc = "Warnung bei Phasenwechsel."

	L.eyes = "Augen der Kaiserin"
	L.eyes_desc = "Zählt die Stapel von -Augen der Kaiserin- und zeigt eine Leiste mit der verbleibenden Dauer an."
	L.eyes_message = "%2$dx Augen auf %1$s"
end

