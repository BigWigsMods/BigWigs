local L = BigWigs:NewBossLocale("Hellfire Assault", "esES") or BigWigs:NewBossLocale("Hellfire Assault", "esMX")
if not L then return end
if L then
L.left = "Izquierda: %s"
L.middle = "Centro: %s"
L.right = "Derecha: %s"

end

L = BigWigs:NewBossLocale("Kilrogg Deadeye", "esES") or BigWigs:NewBossLocale("Kilrogg Deadeye", "esMX")
if L then
L.add_warnings = "Avisos cuando aparecen adds"

end

L = BigWigs:NewBossLocale("Gorefiend", "esES") or BigWigs:NewBossLocale("Gorefiend", "esMX")
if L then
L.fate_root_you = "Destino compartido - ¡Estás enraizado!"
L.fate_you = "¡Destino compartido en TI! - Raiz en %s"

end

L = BigWigs:NewBossLocale("Shadow-Lord Iskar", "esES") or BigWigs:NewBossLocale("Shadow-Lord Iskar", "esMX")
if L then
L.bindings_removed = "Ataduras eliminadas (%d/3)"
L.custom_off_binding_marker = "Marcador de Ataduras oscuras"
L.custom_off_binding_marker_desc = [=[Marca los objetivos de Ataduras oscuras con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requiere ayudante o líder.
|cFFFF0000Sólo 1 persona en la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r]=]
L.custom_off_wind_marker = "Marcador de Vientos fantasmales"
L.custom_off_wind_marker_desc = [=[Marca los objetivos de Vientos fantasmales con {rt1}{rt2}{rt3}{rt4}{rt5}, requiere ayudante o líder.
|cFFFF0000Sólo 1 persona en la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r]=]

end

L = BigWigs:NewBossLocale("Socrethar the Eternal", "esES") or BigWigs:NewBossLocale("Socrethar the Eternal", "esMX")
if L then
L.dominator_desc = "Avisos para cuando Dominador Sargerei aparece."
L.portals = "Movimiento de Portales"
L.portals_desc = "Temporizador para cuando los portales cambian de posición en fase 2."
L.portals_msg = "¡Los portales se han movido!"

end

L = BigWigs:NewBossLocale("Fel Lord Zakuun", "esES") or BigWigs:NewBossLocale("Fel Lord Zakuun", "esMX")
if L then
L.custom_off_seed_marker = "Marcador de Semilla de destrucción"
L.custom_off_seed_marker_desc = "Marca los objetivos de Semilla de destrucción con {rt1}{rt2}{rt3}{rt4}{rt5}, requiere ayudante o líder."
L.seed = "Semilla"
L.tank_proximity = "Proximidad de tanque"
L.tank_proximity_desc = "Abre una proximidad a 5 metros mostrando los otros tanques para ayudarte a lidiar con las habilidades Mano dura y Muy armado."

end

L = BigWigs:NewBossLocale("Tyrant Velhari", "esES") or BigWigs:NewBossLocale("Tyrant Velhari", "esMX")
if L then
L.font_removed_soon = "¡Tu Fuente acaba pronto!"

end

L = BigWigs:NewBossLocale("Mannoroth", "esES") or BigWigs:NewBossLocale("Mannoroth", "esMX")
if L then
L["182212"] = "¡Portal Infernal cerrado!"
L["185147"] = "¡Portal del Señor de fatalidad cerrado!"
L["185175"] = "¡Portal del Diablillo cerrado!"
L.custom_off_doom_marker = "Marcador de Marca de fatalidad"
L.custom_off_doom_marker_desc = "En dificultad Mítica, marca los objetivos de Marca de fatalidad con {rt1}{rt2}{rt3}, requiere ayudante o líder."
L.custom_off_gaze_marker = "Marcador de Mirada de Mannoroth"
L.custom_off_gaze_marker_desc = "Marca los objetivos de Mirada de Mannoroth con {rt1}{rt2}{rt3}, requiere ayudante o líder."
L.custom_off_wrath_marker = "Marcador de Cólera de Gul'dan"
L.custom_off_wrath_marker_desc = "Marca los objetivos de Cólera de Gul'dan con {rt8}{rt7}{rt6}{rt5}{rt4}, requiere ayudante o líder."
L.felseeker_message = "%s (%d) %dm"
L.gaze = "Mirada (%d)"

end

L = BigWigs:NewBossLocale("Archimonde", "esES") or BigWigs:NewBossLocale("Archimonde", "esMX")
if L then
L.chaos_bar = "%s -> %s"
L.chaos_from = "%s de %s"
L.chaos_helper_message = "Tu posición de caos: %d" -- Needs review
L.chaos_to = "%s a %s" -- Needs review
L.custom_off_chaos_helper = "Ayudante de Provocar caos" -- Needs review
L.custom_off_chaos_helper_desc = "Sólo para dificultad Mítica. Esta característica te dirá que número de caos eres, mostrando un mensaje normal y diciendolo por el chat decir. Dependiendo de la táctica que uses, esta característica puede o no puede ser de utilidad." -- Needs review
L.custom_off_infernal_marker = "Marcador de Infernales" -- Needs review
L.custom_off_infernal_marker_desc = "Marca los Infernales que aparecen por Lluvia de caos con {rt1}{rt2}{rt3}{rt4}{rt5}, requiere ayudante o líder." -- Needs review
L.custom_off_legion_marker = "Marcador de Marca de la Legión"
L.custom_off_legion_marker_desc = "Marca los objetivos de Marca de la Legión con {rt1}{rt2}{rt3}{rt4}, requiere ayudante o líder."
L.custom_off_torment_marker = "Marcador de Tormento encadenado"
L.custom_off_torment_marker_desc = "Marca los objetivos de Tormento encadenado con {rt1}{rt2}{rt3}, requiere ayudante o líder."
L.infernal_count = "%s (%d/%d)" -- Needs review
L.markofthelegion_self = "Marca de la Legión en ti"
L.markofthelegion_self_bar = "¡Explotas!"
L.markofthelegion_self_desc = "Cuenta atrás especial cuando tienes Marca de la Legión." -- Needs review
L.torment_removed = "Tormento encadenado eliminado (%d/%d)"

end

L = BigWigs:NewBossLocale("Hellfire Citadel Trash", "esES") or BigWigs:NewBossLocale("Hellfire Citadel Trash", "esMX")
if L then
L.anetheron = "Anetheron"
L.azgalor = "Azgalor"
L.bloodthirster = "Sediente de sangre salivoso"
L.burster = "Reventador de las sombras"
L.daggorath = "Dag'gorath"
L.darkcaster = "Taumaturgo oscuro sangrante"
L.eloah = "Vinculador Eloah"
L.enkindler = "Prendedora ígnea"
L.faithbreaker = "Quebrantacredos eredar"
L.graggra = "Graggra"
L.kazrogal = "Kaz'rogal"
L.kuroh = "Auxiliar Kuroh"
L.orb = "Orbe de destrucción"
L.peacekeeper = "Ensamblaje pacifista"
L.talonpriest = "Sacerdote de la garra corrupto"
L.weaponlord = "Señor de armas Mehlkhior"

end

