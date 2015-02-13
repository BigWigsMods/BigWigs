local L = BigWigs:NewBossLocale("Gruul", "esES") or BigWigs:NewBossLocale("Gruul", "esMX")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Oregorger", "esES") or BigWigs:NewBossLocale("Oregorger", "esMX")
if L then
	L.berserk_trigger = "¡Tragamenas ha enloquecido de hambre!"

	L.shard_explosion = "Explosión de Fragmento explosivo"
	L.shard_explosion_desc = "Barra enfatizada separada para la explosión."

	L.hunger_drive_power = "%dx %s - %d menas para acabar!"
end

L = BigWigs:NewBossLocale("The Blast Furnace", "esES") or BigWigs:NewBossLocale("The Blast Furnace", "esMX")
if L then
	L.custom_on_shieldsdown_marker = "Marcador de Escudos abajo"
	L.custom_on_shieldsdown_marker_desc = "Marca una Elementalista primigenia vulnerable con {rt8}, requiere ayudante o líder."

	L.heat_increased_message = "¡Calor aumentado! Reventar cada %ss"

	L.bombs_dropped = "¡Bombas arrojadas! (%d)"
end

L = BigWigs:NewBossLocale("Hans'gar and Franzok", "esES") or BigWigs:NewBossLocale("Hans'gar and Franzok", "esMX")
if L then

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "esES") or BigWigs:NewBossLocale("Flamebender Ka'graz", "esMX")
if L then
	L.molten_torrent_self = "Torrente de magma en ti"
	L.molten_torrent_self_desc = "Cuenta atrás especial cuando Torrente de magma te afecte."
	L.molten_torrent_self_bar = "¡Explotas!"
end

L = BigWigs:NewBossLocale("Kromog", "esES") or BigWigs:NewBossLocale("Kromog", "esMX")
if L then

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "esES") or BigWigs:NewBossLocale("Beastlord Darmac", "esMX")
if L then
	L.next_mount = "¡Montará pronto!"

	L.custom_off_pinned_marker = "Marcador de Inmovilizar"
	L.custom_off_pinned_marker_desc = "Marca los fijados por las lanzas con {rt8}{rt7}{rt6}{rt5}{rt4}, requiere ayudante o líder.\n|cFFFF0000Sólo 1 persona en la raid debería activar esta opción para prevenir conflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si eres el encargado de activar esta opción, mover rápidamente el ratón sobre las lanzas es la manera más rápida de marcarlos.|r"

	L.custom_off_conflag_marker = "Marcador de Conflagración"
	L.custom_off_conflag_marker_desc = "Marca los objetivos de Conflagración con {rt1}{rt2}{rt3}, requiere ayudante o líder.\n|cFFFF0000Sólo 1 persona en la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r"
end

L = BigWigs:NewBossLocale("Operator Thogar", "esES") or BigWigs:NewBossLocale("Operator Thogar", "esMX")
if L then
	L.cauterizing_bolt_message = "¡Tu foco está casteando Descarga cauterizadora!"

	L.trains = "Avisos de tren"
	L.trains_desc = "Muestra contadores y mensajes para cada carril cuando el próximo tren esté llegando. Los carriles están numerados desde el jefe a la entrada, p.ej, Jefe 1 2 3 4 Entrada."

	L.lane = "Carril %s: %s"
	L.train = "Tren"
	L.adds_train = "Tren de adds"
	L.big_add_train = "Tren de add grande"
	L.cannon_train = "Tren del cañón"
	--L.deforester = "Deforester" -- /dump (EJ_GetSectionInfo(10329))
	L.random = "Trenes aleatorios"
end

L = BigWigs:NewBossLocale("The Iron Maidens", "esES") or BigWigs:NewBossLocale("The Iron Maidens", "esMX")
if L then
	--L.ship_trigger = "prepares to man the Dreadnaught's Main Cannon!"

	L.ship = "Saltar al barco"

	L.custom_off_heartseeker_marker = "Marcador de Buscacorazones empapado de sangre"
	L.custom_off_heartseeker_marker_desc = "Marca los objetivos de Buscacorazones con {rt1}{rt2}{rt3}, requiere ayudante o líder."

	L.power_message = "¡%d Furia de hierro!"
end

L = BigWigs:NewBossLocale("Blackhand", "esES") or BigWigs:NewBossLocale("Blackhand", "esMX")
if L then
	L.custom_off_markedfordeath_marker = "Marcador de Marcado para morir"
	L.custom_off_markedfordeath_marker_desc = "Marca los objetivos de Marcado para morir con {rt1}{rt2}, requiere ayudante o líder."
end

