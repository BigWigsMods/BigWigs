local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "deDE")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "deDE")
if L then
	L.unseenstrike_cone = "Unsichtbarer Stoß"

	L.assault = "Überwältigender Angriff"
	L.assault_desc = "Nur für Tanks. Dieser Angriff legt die Verteidigung des Ziels offen und erhöht dadurch für 45 Sekunden den erlittenen Schaden des Ziels um 100%."
end

L = BigWigs:NewBossLocale("Garalon", "deDE")
if L then

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
	L.explosion_boss = "Explosion auf BOSS!"
	L.explosion_you = "Explosion auf DIR!"

	L.explosion_casting = "Amberexplosionen"
	L.explosion_casting_desc = "Warnungen für alle Arten von Amberexplosionen. Hervorheben dieser Warnung wird strengstens empfohlen!"

	L.willpower = "Willen" -- Willenskraft" would be a so much nicer translation, but the dungeonjournal calls it "Willen". Might change it.
	L.willpower_desc = "Wenn der Willen erschöpft ist, stirbt der Spieler und das mutierte Konstrukt beginnt unkontrolliert zu handeln.When Willpower runs out, the player dies and the Mutated Construct continues to act, uncontrolled."
	L.willpower_message = "Dein Wille ist bei: %d (%d)"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "deDE")
if L then
	L.phases = "Phasen"
	L.phases_desc = "Warnung bei Phasenwechsel."
	L.phases_icon = "achievement_raid_mantidraid07"

	L.eyes = "Augen der Kaiserin"
	L.eyes_desc = "Nur für Tanks. Zählt die Stapel von -Augen der Kaiserin- und zeigt eine Leiste mit der verbleibenden Dauer an."
	L.eyes_message = "%2$dx Augen auf %1$s"
end

