local L = BigWigs:NewBossLocale("Doomwalker", "esES")
if not L then return end
if L then
	L.name = "Caminante del Destino"

	L.engage_trigger = "No continuéis. Seréis eliminados."
	L.engage_message = "¡Caminante del Destino en combate, Terremoto en ~30 seg!"

	L.overrun_desc = "Avisar cuando Caminante del Destino utiliza Infestar."

	L.earthquake_desc = "Avisar cuando Caminante del Destino utiliza Terremoto."
end

L = BigWigs:NewBossLocale("Doom Lord Kazzak", "esES")
if L then
	L.name = "Señor Apocalíptico Kazzak"

	L.engage_trigger1 = "¡La Legión lo conquistará todo!"
	L.engage_trigger2 = "¡Todo mortal perecerá!"

	L.enrage_warning1 = "%s Activado - Enfurecer en 50-60seg"
	L.enrage_warning2 = "¡Enfurecer en breve!"
	L.enrage_message = "¡Efurecido durante 10seg!"
	L.enrage_finished = "Fin enfurecer - Próx. en 50-60seg"
	L.enrage_bar = "~Enfurecer"
	L.enraged_bar = "<Enfurecido>"
end

L = BigWigs:NewBossLocale("Gruul the Dragonkiller", "esES")
if L then
	L.engage_trigger = "Venid... y morid."
	L.engage_message = "¡%s Activado!"

	L.grow = "Crecimiento (Grow)"
	L.grow_desc = "Cuenta y avisa de los crecimientos de Gruul"
	L.grow_message = "Crece: (%d)"
	L.grow_bar = "~Crecimiento (%d)"

	L.grasp = "Embate en el suelo (Ground Slam)"
	L.grasp_desc = "Avisos de Embate en el suelo y trizar (Shatter)."
	L.grasp_message = "¡Embate en el suelo! - Trizar en ~10seg"
	L.grasp_warning = "Posible Embate"

	L.silence_message = "¡Reverberación - Silencio de área!"
	L.silence_warning = "Posible Reverberación"
	L.silence_bar = "~Reverberación"
end

L = BigWigs:NewBossLocale("High King Maulgar", "esES")
if L then
	L.engage_trigger = "¡Los Gronn son el auténtico poder de Terrallende!"

	L.heal_message = "¡Ciego lanzando Rezo de sanación!"
	L.heal_bar = "Rezo de sanación"

	L.shield_message = "¡Escudo en Ciego el Vidente!"

	L.spellshield_message = "¡Escudo hechizos en Krosh!"

	L.summon_message = "¡Invocando manáfago!"
	L.summon_bar = "~Manáfago"

	L.whirlwind_message = "¡Maulgar - Torbellino durante 15seg!"
	L.whirlwind_warning = "¡Maulgar Activado - Torbellino en ~60seg!"

	L.mage = "Krosh Manofuego (Mago)"
	L.warlock = "Olm el Invocador (Brujo)"
	L.priest = "Ciego el Vidente (Sacerdote)"
end

L = BigWigs:NewBossLocale("Magtheridon", "esES")
if L then
	L.escape = "Libreación"
	L.escape_desc = "Cuenta atrás hasta la liberación de Magtheridon.."
	L.escape_trigger1 = "¡Las cuerdas de %%s empiezan a aflojarse!"
	L.escape_trigger2 = "¡He... sido... liberado!"
	L.escape_warning1 = "¡%s Activado - Liberado en 2min!"
	L.escape_warning2 = "¡Liberado en 1min!"
	L.escape_warning3 = "¡Liberado en 30sec!"
	L.escape_warning4 = "¡Liberado en 10sec!"
	L.escape_warning5 = "¡Liberado en 3sec!"
	L.escape_bar = "Liberado en..."
	L.escape_message = "¡%s Liberado!"

	L.abyssal = "Abisal ardiente (Burning Abyssal)"
	L.abyssal_desc = "Avisar cuando se crea un Abisal ardiente."
	L.abyssal_message = "Abisal ardiente creado (%d)"

	L.heal = "Curación"
	L.heal_desc = "Avisar cuando Canalizador Fuego Infernal empieza a curar."
	L.heal_message = "¡Curando!"

	L.banish = "Desterrar (Banish)"
	L.banish_desc = "Avisar cuando destierras a Magtheridon."
	L.banish_message = "Desterrado por ~10seg"
	L.banish_over_message = "¡Desterrar se desvanece!"
	L.banish_bar = "<Desterrado>"

	L.exhaust_desc = "Temporizadores para Extenuación mental en jugadores."
	L.exhaust_bar = "[%s] Extenuación mental"

	L.debris_trigger = "¡Que tiemblen las paredes de esta prisión"
	L.debris_message = "¡30% - Escombros!"
end

