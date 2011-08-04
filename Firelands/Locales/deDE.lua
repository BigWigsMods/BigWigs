local L = BigWigs:NewBossLocale("Beth'tilac", "deDE")
if not L then return end
if L then
	L.devastate_message = "Verwüstung #%d!"
	L.devastate_bar = "~Verwüstung"
	L.drone_bar = "Nächste Drohne"
	L.drone_message = "Drohne kommt!"
	L.kiss_message = "Kuss"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "deDE")
if L then
	L.armor = "Obsidianrüstung"
	L.armor_desc = "Warnt, wenn Rüstungsstapel von Lord Rhyolith entfernt werden."
	L.armor_icon = 98632
	L.armor_message = "%d%% Rüstung noch"
	L.armor_gone_message = "Rüstung weg!"

	L.adds_header = "Adds"
	L.big_add_message = "Funke kommt!"
	L.small_adds_message = "Fragmente kommen!"

	L.phase2_warning = "Phase 2 bald!"

	L.molten_message = "%dx Stapel auf Rhyolith!"

	L.stomp_message = "Stampfen! Stampfen! Stampfen!"
	L.stomp_warning = "Nächstes Stampfen"
end

L = BigWigs:NewBossLocale("Alysrazor", "deDE")
if L then
	L.tornado_trigger = "Dieser Himmel ist MEIN."
	L.claw_message = "%2$dx Klauen: %1$s"
	L.fullpower_soon_message = "Volle Kraft bald!"
	L.halfpower_soon_message = "Phase 4 bald!"
	L.encounter_restart = "Volle Kraft! Es geht wieder los..."
	L.no_stacks_message = "Du hast keine Federn!"
	L.moonkin_message = "Beschaff' dir richtige Federn!"
	L.molt_bar = "Nächste Mauser"
	L.cataclysm_bar = "Next Cataclysm"

	L.stage_message = "Phase %d"

	L.worm_emote = "Feurige Lavawürmer brechen aus dem Boden hervor!"
	L.phase2_soon_emote = "Alysrazar beginnt, in einem schnellen Kreis zu fliegen!"

	L.flight = "Flughilfe"
	L.flight_desc = "Zeigt eine Timerleiste mit deiner verbleibenden Restdauer von 'Flammenschwingen', sollte am besten mit der 'Stark hervorgehoben'-Funktion verwendet werden."
end

L = BigWigs:NewBossLocale("Shannox", "deDE")
if L then
	L.safe = "%s ist sicher!"
	L.immolation_trap = "Brandfalle auf %s!"
	L.crystal_trap = "Kristallfalle"

	L.traps_header = "Fallen"
	L.immolation = "Feuerbrandfalle"
	L.immolation_desc = "Warnt, wenn Augenkratzer oder Wadenbeißer auf eine Feuerbrandfalle tritt."
	L.immolation_icon = 99838
	L.crystal = "Kristallgefängnisfalle"
	L.crystal_desc = "Warnt, unter wen Shannox die Kristallgefängnisfalle ablegt."
	L.crystal_icon = 99836
end

L = BigWigs:NewBossLocale("Baleroc", "deDE")
if L then
	L.torment = "Anzahl der 'Qual'-Stapel auf deinem Fokusziel"
	L.torment_desc = "Warnt, wenn dein /focus weitere 'Qual'-Stapel erhält."
	L.torment_message = "%2$dx Qual: %1$s"

	L.blade_bar = "Nächste Klinge"
	L.shard_message = "Splitter %d!"
	L.focus_message = "Dein Fokus hat %d Stapel!"
	L.countdown_bar = "Nächste Verbindung"
	L.link_message = "Verbunden"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "deDE")
if L then
	L.seed_explosion = "Du explodierst gleich!"
	L.seed_bar = "Du explodierst!"
	L.adrenaline_message = "%dx Adrenalin!"
end

L = BigWigs:NewBossLocale("Ragnaros", "deDE")
if L then
	L.intermission_end_trigger1 = "Sulfuras wird Euer Ende sein."
	L.intermission_end_trigger2 = "Auf die Knie, Sterbliche! Das ist das Ende."
	--L.intermission_end_trigger3 = "Enough! I will finish this."
	--L.phase4_trigger = "Too soon..."
	L.seed_explosion = "Samenexplosion!"
	L.intermission_bar = "Phasenübergang"
	L.intermission_message = "Phasenübergang!"
	L.sons_left = "%d Söhne noch"
	L.engulfing_close = "Innen entflammt!"
	L.engulfing_middle = "Mitte entflammt!"
	L.engulfing_far = "Außen entflammt!"
	L.hand_bar = "Nächster Rückstoß"
	L.wound_bar = "Wunde: %s"
	L.ragnaros_back_message = "Raggy wieder da, auf geht's!"
end

