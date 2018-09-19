local L = BigWigs:NewBossLocale("MOTHER", "esES") or BigWigs:NewBossLocale("MOTHER", "esMX")
if not L then return end
if L then
	L.sideLaser = "(Lateral) Láseres" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "(Techo) Láseres"
	L.mythic_beams = "(Lateral + Techo) Láseres"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "esES") or BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "esMX")
if L then
	L.surging_darkness_eruption = "Erupción (%d)"
	L.mythic_adds = "Adds Míticos"
	L.mythic_adds_desc = "Muestra temporizadores para el momento en que aparecerán adds en Mítico (Guerrero Silítido y Tejevacío Nerubiano aparecen al mismo tiempo)."
end

L = BigWigs:NewBossLocale("Zul", "esES") or BigWigs:NewBossLocale("Zul", "esMX")
if L then
	L.crawg_msg = "Tragadón" -- Short for 'Bloodthirsty Crawg'
	L.crawg_desc = "Avisos y temporizadores para el momento en que aparecerá el Tragadón Sanguinario."

	L.bloodhexer_msg = "Aojasangre" -- Short for 'Nazmani Bloodhexer'
	L.bloodhexer_desc = "Avisos y temporizadores para el momento en que aparecerá la Aojasangre Nazmani."

	L.crusher_msg = "Trituradora" -- Short for 'Nazmani Crusher'
	L.crusher_desc = "Avisos y temporizadores para el momento en que aparecerá la Trituradora Nazmani."

	L.custom_off_decaying_flesh_marker = "Marcador de Carne Putrefacta"
	L.custom_off_decaying_flesh_marker_desc = "Marca las fuerzas enemigas efectadas por Carne Putrefacta con {rt8}, requiere ayudante o lider."
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "esES") or BigWigs:NewBossLocale("Mythrax the Unraveler", "esMX")
if L then
	L.destroyer_cast = "%s (Destructor N'raqi)" -- npc id: 139381
	L.xalzaix_returned = "¡Xalzaix ha regresado!" -- npc id: 138324
	L.add_blast = "Haz del Add"
	L.boss_blast = "Haz del Jefe"
end

L = BigWigs:NewBossLocale("G'huun", "esES") or BigWigs:NewBossLocale("G'huun", "esMX")
if L then
	L.orbs_deposited = "Orbes depositados (%d/3) - %.1f seg"
	L.orb_spawning = "Reaparición de Orbe"
	L.orb_spawning_side = "Orbe reaparece (%s)"
	L.left = "Izquierda"
	L.right = "Derecha"

	L.custom_on_fixate_plates = "Fija un icono en la placa de nombre enemiga"
	L.custom_on_fixate_plates_desc = "Muestra un icono en la placa de nombre del enemigo que te tiene fijado.\nRequiere el uso de placa de nombre de enemigos. Esta característica es actualmente solo soportada por KuiNameplates."
end
