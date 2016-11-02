local L = BigWigs:NewBossLocale("Cenarius", "esES") or BigWigs:NewBossLocale("Cenarius", "esMX")
if not L then return end
if L then
	L.forces = "Fuerzas"
	L.bramblesSay = "Zarzas cerca %s"
	L.custom_off_multiple_breath_bar = "Muestra múltiples barras para Aliento podrido"
	L.custom_off_multiple_breath_bar_desc = "Por defecto BigWigs solo mostrará la barra de Aliento podrido de un draco. Activa esta opción si quieres ver el temporizador para cada draco."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "esES") or BigWigs:NewBossLocale("Elerethe Renferal", "esMX")
if L then
	L.isLinkedWith = "%s está enlazado con %s"
	L.yourLink = "Estás enlazado con %s"
	L.yourLinkShort = "Enlazado con %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "esES") or BigWigs:NewBossLocale("Il'gynoth", "esMX")
if L then
	L.remaining = "Restantes"
	L.missed = "Perdidas"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "esES") or BigWigs:NewBossLocale("Emerald Nightmare Trash", "esMX")
if L then
	L.gelatinizedDecay = "Descomposición gelatinosa"
	L.befouler = "Infectador Corazón Ruin"
	L.shaman = "Chamán temible"
end

L = BigWigs:NewBossLocale("Ursoc", "esES") or BigWigs:NewBossLocale("Ursoc", "esMX")
if L then
	L.custom_on_gaze_assist = "Asistente de Mirada enfocada"
	L.custom_on_gaze_assist_desc = "Muestra los iconos de raid en barras y mensajes para Mirada enfocada. Usando {rt4} para los impares, y {rt6} para los pares. Requiere ayudante o líder."
end

L = BigWigs:NewBossLocale("Xavius", "esES") or BigWigs:NewBossLocale("Xavius", "esMX")
if L then
	L.linked = "¡Ataduras de terror en TI! - ¡Enlazado con %s!"
	--L.dreamHealers = "Dream Healers"
end
