local L = BigWigs:NewBossLocale("The Fallen Protectors", "esES") or BigWigs:NewBossLocale("The Fallen Protectors", "esMX")
if not L then return end
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/TheFallenProtectors", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_bane_marks = "Palabra de las Sombras: terror marcador"
	L.custom_off_bane_marks_desc = "Para ayudar a asignar los dispels, marca inicialmente a la gente que tiene Palabra de las Sombras: terror en ellos con {rt1}{rt2}{rt3}{rt4}{rt5} (en este orden, puede que no se usen todas las marcas), requiere ayudante o líder."
end

L = BigWigs:NewBossLocale("Norushen", "esES") or BigWigs:NewBossLocale("Norushen", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "esES") or BigWigs:NewBossLocale("Sha of Pride", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/ShaOfPride", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_titan_mark = "Marcador de Ofrenda de los titanes"
	L.custom_off_titan_mark_desc = "Marca la gente que tiene Ofrenda de los titanes con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r"

	L.custom_off_fragment_mark = "Marcador de Fragmento corrupto"
	L.custom_off_fragment_mark_desc = "Marca los Fragmentos corruptos con {rt8}{rt7}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid deberia tener activada esta opción para prevenir conflictos con las marcas.|r"
end

L = BigWigs:NewBossLocale("Galakras", "esES") or BigWigs:NewBossLocale("Galakras", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/Galakras", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "Marcador del Chamán"
	L.custom_off_shaman_marker_desc = "Para ayudar con las interrupciones, marca los Chamanes de mareas Faucedraco con {rt1}{rt2}{rt3}{rt4}{rt5}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener esta opción activada para prevenir conflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si la raid te ha elegido para que la actives, mover rápidamente el ratón por encima de los chamanes es la manera más rápida de marcarlos.|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "esES") or BigWigs:NewBossLocale("Iron Juggernaut", "esMX")
if L then
	L.custom_off_mine_marks = "Marcador de Minas"
	L.custom_off_mine_marks_desc = "Para ayudar con las asignaciones de las minas, marca las Minas reptadoras con {rt1}{rt2}{rt3}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener activada esta opción para prevenir coflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si la raid te ha elegido para que la actives, mover rápidamente el ratón por encima de todas las minas es la manera más rápida de marcarlas.|r"

end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "esES") or BigWigs:NewBossLocale("Kor'kron Dark Shaman", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/KorkronDarkShaman", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_mist_marks = "Marcador de Niebla tóxica"
	L.custom_off_mist_marks_desc = "Para ayudar con las tareas de sanación, marca la gente que tiene Niebla tóxica con {rt1}{rt2}{rt3}{rt4}{rt5}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "esES") or BigWigs:NewBossLocale("General Nazgrim", "esMX")
if L then
	L.custom_off_bonecracker_marks = "Marcador de Partehuesos"
	L.custom_off_bonecracker_marks_desc = "Para ayudar en las tareas de sanación, marca la gente que tiene Partehuesos con {rt1}{rt2}{rt3}{rt4}{rt5}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r"

	L.stance_bar = "%s(AHORA:%s)"
	-- shorten stances so they fit on the bars
	L.battle = "Batalla"
	L.berserker = "Rabiosa"
	L.defensive = "Defensiva"

	L.adds_trigger1 = "¡Defended la puerta!"
	L.adds_trigger2 = "¡Reunid a las tropas!"
	L.adds_trigger3 = "¡Siguiente escuadrón, al frente!"
	L.adds_trigger4 = "¡Guerreros, paso ligero!"
	L.adds_trigger5 = "¡Kor'kron, conmigo!"
	L.adds_trigger_extra_wave = "¡Todos los Kor'kron a mi comando, mátenlos ya!"
	L.extra_adds = "Adds extra"
	L.final_wave = "Oleada final"
	L.add_wave = "%s (%s): %s"

	L.chain_heal_message = "¡Tu foco está casteando Sanación en cadena!"

	L.arcane_shock_message = "¡Tu foco está casteando Choque Arcano!"
end

L = BigWigs:NewBossLocale("Malkorok", "esES") or BigWigs:NewBossLocale("Malkorok", "esMX")
if L then
	L.custom_off_energy_marks = "Marcador de Energía desplazada"
	L.custom_off_energy_marks_desc = "Para ayudar a dispelear, marca la gente que tiene Energía desplazada en ellos con {rt1}{rt2}{rt3}{rt4}, requiere ayudante o líder.\n|cFFFF0000SSólo 1 persona en la raid debería tener activada esta opción para evitar conflictos con las marcas.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "esES") or BigWigs:NewBossLocale("Spoils of Pandaria", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/SpoilsOfPandaria", format="lua_additive_table", handle-unlocalized="ignore")@

	L.crates = "Cajas"
	L.crates_desc = "Mensajes para saber cuanto poder necesitas y cuantas cajas grandes/medianas/pequeñas necesitarás para lograrlo."
	L.full_power = "¡Poder máximo!"
	L.power_left = "%d restantes! (%d/%d/%d)"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "esES") or BigWigs:NewBossLocale("Thok the Bloodthirsty", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "esES") or BigWigs:NewBossLocale("Siegecrafter Blackfuse", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/SiegecrafterBlackfuse", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_mine_marker = "Marcador de minas"
	L.custom_off_mine_marker_desc = "Marca las minas para asignar aturdimientos. (Se usan todas las marcas)"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "esES") or BigWigs:NewBossLocale("Paragons of the Klaxxi", "esMX")
if L then
	L.catalyst_match = "Catalizador: |c%sTE CORRESPONDE|r" -- might not be best for colorblind?
	L.you_ate = "Te comiste un Parásito (%d restantes)"
	L.other_ate = "%s se comió un %sParásito (%d restantes)"
	L.parasites_up = "%d |4Parásito activo:Parásitos activos;"
	L.dance = "%s, Baile"
	L.prey_message = "Usa Depredar en parásito"
	L.injection_over_soon = "¡Inyección acabará pronto (%s)!"

	L.one = "¡Iyyokuk elige: Uno!"
	L.two = "¡Iyyokuk elige: Dos!"
	L.three = "¡Iyyokuk elige: Tres!"
	L.four = "¡Iyyokuk elige: Cuatro!"
	L.five = "¡Iyyokuk elige: Cinco!"

	L.custom_off_edge_marks = "Marcador del límite"
	L.custom_off_edge_marks_desc = "Marca los jugadores que serán los límites según los cálculos con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener activa esta opción para prevenir conflictos con las marcas.|r"
	L.edge_message = "¡Estás en el límite!"

	L.custom_off_parasite_marks = "Marcador de Parásito"
	L.custom_off_parasite_marks_desc = "Marca los parásitos para controlar y asignar víctimas con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener activa esta opción para prevenir conflictos con las marcas.|r"

	L.injection_tank = "Inyección (casteo)"
	L.injection_tank_desc = "Barra de tiempo para cuando Inyección es casteada por su tanque actual."
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "esES") or BigWigs:NewBossLocale("Garrosh Hellscream", "esMX")
if L then
--@localization(locale="esES", namespace="SiegeOfOrgrimmar/GarroshHellscream", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "Marcador de Clarividentes"
	L.custom_off_shaman_marker_desc = "Para ayudar con las interrupciones, marca los Clarividente jinete de lobos con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona de la raid debería tener activa esta opción para prevenir conflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si la raid te elige para que la actives, mover rápidamente el ratón por encima de los clarividentes es la manera más rápida de marcarlos.|r"

	L.custom_off_minion_marker = "Marcador de esbirros"
	L.custom_off_minion_marker_desc = "Para ayudar a separarse de los adds del Torbellino de corrupción potenciado, márcalos con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requiere ayudante o líder."
end

