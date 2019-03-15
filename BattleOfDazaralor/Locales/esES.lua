local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "esES") or BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "esMX")
if not L then return end
if L then
	L.prelate = "Prelado Akk'al"
	L.flamespeaker = "Hablallamas Rastari"
	L.enforcer = "Déspota eterno"
	L.punisher = "Castigador Rastari"
	L.vessel = "Receptáculo de Bwonsamdi"

	L.victim = "¡%s te ha apuñalado con %s!"
	L.witness = "¡%s ha apuñalado a %s con %s!"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "esES") or BigWigs:NewBossLocale("Champion of the Light Horde", "esMX")
if L then
	L.disorient_desc = "Barra para el lanzamiento de |cff71d5ff[Fe cegadora]|r.\nEsta es probablemente la barra que querrás tener con la cuenta atrás activada." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "esES") or BigWigs:NewBossLocale("Champion of the Light Alliance", "esMX")
if L then
	L.disorient_desc = "Barra para el lanzamiento de |cff71d5ff[Fe cegadora]|r.\nEsta es probablemente la barra que querrás tener con la cuenta atrás activada." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "esES") or BigWigs:NewBossLocale("Jadefire Masters Horde", "esMX")
if L then
	L.custom_on_fixate_plates = "Icono de acecho en la placa de identificación del enemigo"
	L.custom_on_fixate_plates_desc = "Muestra un ícono en la placa de identificación del objetivo que te está acechando.\nRequiere el uso de placas de identificación enemigas. Esta característica actualmente solo es compatible con KuiNameplates."

	L.absorb = "Absorbido"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Lanzando"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s interrumpido por %s (%.1f segundos restantes)"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "esES") or BigWigs:NewBossLocale("Jadefire Masters Alliance", "esMX")
if L then
	L.custom_on_fixate_plates = "Icono de acecho en la placa de identificación del enemigo"
	L.custom_on_fixate_plates_desc = "Muestra un ícono en la placa de identificación del objetivo que te está acechando.\nRequiere el uso de placas de identificación enemigas. Esta característica actualmente solo es compatible con KuiNameplates."

	L.absorb = "Absorbido"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Lanzando"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s interrumpido por %s (%.1f segundos restantes)"
end

L = BigWigs:NewBossLocale("Opulence", "esES") or BigWigs:NewBossLocale("Opulence", "esMX")
if L then
	L.room = "Sala (%d/8)"
	L.no_jewel = "Sin Gemas:"

	--L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	--L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the construct which isn't in your hall during stage 1."

	L.custom_on_hand_timers = "La Mano de In'zashi"
	L.custom_on_hand_timers_desc = "Muestra advertencias y barras para las habilidades de La Mano de In'zashi."
	L.hand_cast = "Mano: %s"

	L.custom_on_bulwark_timers = "Baluarte de Yalat"
	L.custom_on_bulwark_timers_desc = "Muestra advertencias y barras para las habilidades de Baluarte de Yalat."
	L.bulwark_cast = "Baluarte: %s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "esES") or BigWigs:NewBossLocale("Conclave of the Chosen", "esMX")
if L then
	L.custom_on_fixate_plates = "Icono de marca de la presa en la placa de identificación del enemigo"
	L.custom_on_fixate_plates_desc = "Muestra un ícono en la placa de identificación del objetivo que te está fijando.\nRequiere el uso de placas de identificación enemigas. Esta característica actualmente solo es compatible con KuiNameplates."
	L.killed = "¡%s muerto!"
	--L.count_of = "%s (%d/%d)"
end

L = BigWigs:NewBossLocale("King Rastakhan", "esES") or BigWigs:NewBossLocale("King Rastakhan", "esMX")
if L then
	L.leap_cancelled = "Salto Cancelado"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "esES") or BigWigs:NewBossLocale("High Tinker Mekkatorque", "esMX")
if L then
	L.gigavolt_alt_text = "Bomba"

	L.custom_off_sparkbot_marker = "Marcador de Chispabot"
	L.custom_off_sparkbot_marker_desc = "Marca a los Chispabots con {rt4}{rt5}{rt6}{rt7}{rt8}."

	L.custom_on_repeating_shrunk_say = "Decir repetidamente Encogido" -- Shrunk = 284168
	L.custom_on_repeating_shrunk_say_desc = "Dices repetidamente Encogido cuando estás |cff71d5ff[Encogido]|r. Tal vez así dejen de atropellarte."

	L.custom_off_repeating_tampering_say = "Decir repetidamente ¡Manipulando!" -- Tampering = 286105
	L.custom_off_repeating_tampering_say_desc = "Dices repetidamente tu nombre cuando estás controlando un Chispabot."
end

L = BigWigs:NewBossLocale("Stormwall Blockade", "esES") or BigWigs:NewBossLocale("Stormwall Blockade", "esMX")
if L then
	L.killed = "¡%s muerto!"

	--L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	--L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss who isn't active on your boat in stage 1."
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "esES") or BigWigs:NewBossLocale("Lady Jaina Proudmoore", "esMX")
if L then
	L.starbord_ship_emote = "¡Un corsario de Kul Tiran se acerca en el lado de estribor!"
	L.port_side_ship_emote = "¡Un corsario de Kul Tiran se acerca en el lado de babor!"

	L.starbord_txt = "Barco Derecha" -- estribor
	L.port_side_txt = "Barco Izquierda" -- babor

	L.custom_on_stop_timers = "Mostrar siempre barras de habilidad."
	L.custom_on_stop_timers_desc = "Jaina asigna al azar qué habilidad de reutilización usa después. Cuando esta opción esté habilitada, las barras para esas habilidades permanecerán en tu pantalla."

	L.frozenblood_player = "%s (%d jugadores)"

	L.intermission_stage2 = "Fase 2 - %.1f seg"
end
