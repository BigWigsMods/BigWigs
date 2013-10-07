local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "esES") or BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "esMX")
if not L then return end
if L then
	L.engage_yell = "La Divina nos ha elegido para dar voz mortal a Su pensamiento eterno. Solo somos el brazo que ejecuta Su voluntad."

	L.force_message = "Pulso AoE"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discos)"
	L.attenuation_bar = "¡Discos... baila!"
	L.attenuation_message = "%s Baile %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- Izquierda <-|r"
	L.right = "|c00FF0000-> Derecha ->|r"

	L.platform_emote = "¡El visir imperial Zor'lok vuela hacia una de las plataformas!" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "¡El visir imperial Zor'lok inhala las feromonas de celo!"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "Cambio de plataforma"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "esES") or BigWigs:NewBossLocale("Blade Lord Ta'yak", "esMX")
if L then
	L.engage_yell = "¡En guardia, invasores! Yo, Ta'yak, Señor de las Espadas, seré vuestro contrincante."

	L.unseenstrike_soon = "¡Golpe (%d) en ~5-10 seg!"
	L.assault_message = "Asalto"
	L.side_swap = "Cambia de lado"

	--L.custom_off_windstep = "Wind step marker"
	--L.custom_off_windstep_desc = "To help healing assignments, mark the people who have wind step on them with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Garalon", "esES") or BigWigs:NewBossLocale("Garalon", "esMX")
if L then
	L.phase2_trigger = "¡La enorme coraza de Garalon empieza a agrietarse y romperse!"

	L.removed = "¡%s eliminado!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "esES") or BigWigs:NewBossLocale("Wind Lord Mel'jarak", "esMX")
if L then
	L.spear_removed = "¡Tu Lanza empaladora fue eliminada!"

	L.mending_desc = "|cFFFF0000WARNING: Solo se mostrará el temporizador para tu 'focus' porque todos los Ensalmador de batalla Zar'thik tienen diferentes CDs de sanación.|r "
	L.mending_warning = "¡Tu focus está casteando Aliviar!"
	L.mending_bar = "Focus: Aliviar"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "esES") or BigWigs:NewBossLocale("Amber-Shaper Un'sok", "esMX")
if L then
	L.explosion_by_other = "Barra de CD para Explosión de ámbar de Monstruiosidad/Focus"
	L.explosion_by_other_desc = "Aviso de CD y barra para explosiones de ámbar casteados por la Monstruosidad de ámbar o tu focus."

	L.explosion_casting_by_other = "Barra para Explosión de ámbar de la Monstruosidad/Focus"
	L.explosion_casting_by_other_desc = "Aviso para el casteo de explosiones de ámbar empezadas por Monstruosidad de ámbar o tu focus. ¡Recomendamos encarecidamente enfatizar esto!"

	L.explosion_by_you = "Tu CD de Explosión de ámbar"
	L.explosion_by_you_desc = "Advertencia de CD para tus explosiones de ámbar."
	L.explosion_by_you_bar = "Empiezas a castear..."

	L.explosion_casting_by_you = "Tu barra para Explosión de ámbar"
	L.explosion_casting_by_you_desc = "Avisos para casteos de explosiones de ámbar empezados por ti. ¡Recomendamos encarecidamente enfatizar esto!"

	L.willpower = "Voluntad"
	L.willpower_message = "¡Voluntad al %d!"

	L.break_free_message = "¡Vida al %d%%!"
	L.fling_message = "¡Vas a ser lanzado!"
	L.parasite = "Parásito"

	L.monstrosity_is_casting = "Monstruo: Explosión"
	L.you_are_casting = "¡ESTÁS casteando!"

	L.unsok_short = "Jefe"
	L.monstrosity_short = "Monstruo"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "esES") or BigWigs:NewBossLocale("Grand Empress Shek'zeer", "esMX")
if L then
	L.engage_trigger = "¡Muerte a todo aquel que desafíe a mi imperio!"
	L.phases = "Fases"
	L.phases_desc = "Cambios de fase."

	L.eyes = "Ojos de la Emperatriz"
	L.eyes_desc = "Muestra stacks y barra de duración para Ojos de la Emperatriz."
	L.eyes_message = "Ojos"

	L.visions_message = "Visiones"
	L.visions_dispel = "¡Los jugadores han sido asustados!"
	L.fumes_bar = "Tu beneficio de Vapores"
end

