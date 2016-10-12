local L = BigWigs:NewBossLocale("Cenarius", "esES") or BigWigs:NewBossLocale("Cenarius", "esMX")
if not L then return end
if L then
	L.forces = "Fuerzas"
	L.bramblesSay = "Zarzas cerca %s"
	--L.custom_off_multiple_breath_bar = "Show multiple Rotten Breath bars"
	--L.custom_off_multiple_breath_bar_desc = "Per default BigWigs will only show the Rotten Breath bar of one drake. Enable this option if you want to see the timer for each drake."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "esES") or BigWigs:NewBossLocale("Elerethe Renferal", "esMX")
if L then
	L.isLinkedWith = "%s está enlazado con %s"
	L.yourLink = "Estás enlazado con %s"
	L.yourLinkShort = "Enlazado con %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "esES") or BigWigs:NewBossLocale("Il'gynoth", "esMX")
if L then
	L.custom_off_deathglare_marker = "Marcador de Tentáculo ojoletal"
	L.custom_off_deathglare_marker_desc = "Marca los Tentáculos ojoletal con {rt6}{rt5}{rt4}{rt3}, requiere ayudante o líder.\n|cFFFF0000Sólo 1 persona en la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si la raid te elige a ti para activarla, teniendo las placas de nombre activadas o moviendo rápidamente el ratón por encima de los adds es la forma más rápida de marcarlos.|r"

	L.bloods_remaining = "Mata %d |4Sangre:Sangres; más"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "esES") or BigWigs:NewBossLocale("Emerald Nightmare Trash", "esMX")
if L then
	L.gelatinizedDecay = "Descomposición gelatinosa"
	L.befouler = "Infectador Corazón Ruin"
	L.shaman = "Chamán temible"
	--L.custom_on_mark_totem = "Mark the Totems"
	--L.custom_on_mark_totem_desc = "Mark the Totems with {rt8}{rt7}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Ursoc", "esES") or BigWigs:NewBossLocale("Ursoc", "esMX")
if L then
	L.custom_off_gaze_assist = "Asistente de Mirada enfocada"
	L.custom_off_gaze_assist_desc = "Muestra los iconos de raid en barras y mensajes para Mirada enfocada. Usando {rt4} para los impares, y {rt6} para los pares. Requiere ayudante o líder."
end

L = BigWigs:NewBossLocale("Xavius", "esES") or BigWigs:NewBossLocale("Xavius", "esMX")
if L then
	L.custom_off_blade_marker = "Marcador de Hoja de la Pesadilla"
	L.custom_off_blade_marker_desc = "Marca los objetivos de Hoja de la Pesadilla con {rt1}{rt2}, requiere ayudante o líder."

	L.linked = "¡Ataduras de terror en TI! - ¡Enlazado con %s!"
end
