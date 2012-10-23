local L = BigWigs:NewBossLocale("The Stone Guard", "ptBR")
if not L then return end
if L then
	L.petrifications = "Petrificação"
	L.petrifications_desc = "Avisa quando o chefe vai petrificar"

	L.overload = "Sobrecarregar"
	L.overload_desc = "Avisa todos os tipos de sobrecarregamento."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "ptBR")
if L then
	L.engage_yell = "Ofereçam suas almas, mortais! Estes são os salões dos mortos!"

	L.phase_flame_trigger = "Oh, magnificente! Através de mim você derreterá a carne dos ossos!"
	L.phase_lightning_trigger = "Oh, grande espírito! Conceda-me o poder da terra!"
	L.phase_arcane_trigger =  "Oh, inteligência das eras! Dê-me sua sabedoria arcana!"
	L.phase_shadow_trigger = "Grande alma dos antigos campeões! Leve-me ao seu escudo!"

	L.phase_message = "New phase soon!"
	L.shroud_message = "%2$s conjurou mortalha em %1$s"
	L.barrier_message = "Barreira ATIVADA!"

	L.phase_flame = "Fase das chamas!"
	L.phase_lightning = "Fase dos raios!"
	L.phase_arcane = "Fase arcana!"
	L.phase_shadow = "Fase das sombras!"

	-- Tanks
	L.tank = "Alertas de tanquers"
	L.tank_desc = "Alertas somente para tanquers. Conta as pilhas de Açoite de raios, Lança flamejante, Choque arcano e Sombra Ardente (Heróico)."
	L.lash_message = "%2$dx Açoite em %1$s"
	L.spear_message = "%2$dx Lança em %1$s"
	L.shock_message = "%2$dx Choque em %1$s"
	L.burn_message = "%2$dx Sombra Ardente em %1$s"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "ptBR")
if L then
	L.engage_yell = "É hora de morrer!"

	L.totem = "Totem (%d)"
	L.shadowy_message = "Ataque (%d)"
	L.banish_message = "Tank Banished"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "ptBR")
if L then
	L.shield_removed = "Escudo removido! (%s)"
	L.casting_shields = "Conjurando escudos!"
	L.casting_shields_desc = "Avisa quando os escudos são conjurados para todos os chefes."
end

L = BigWigs:NewBossLocale("Elegon", "ptBR")
if L then
	L.last_phase = "Última Fase!"
	L.overcharged_total_annihilation = "Você tem (%d) %s, reinicie sua penalidade!"

	L.floor = "Floor Despawn"
	L.floor_desc = "Warnings for when the floor is about to despawn."
	L.floor_message = "The floor is falling!!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ptBR")
if L then
	L.enable_zone = DUNGEON_FLOOR_MOGUSHANVAULTS3 -- translate me

	L.rage_trigger = "A Ira do Imperador ecoa pelas colinas."
	L.strength_trigger = "A Força do Imperador prende esta terra com punhos de ferro."
	L.courage_trigger = "A Coragem do Imperador queima eternamente."
	L.bosses_trigger = "Dois construtos titânicos aparecem nas grandes alcovas!"

	L.heroic_start_trigger = "Destruindo os canos"
	L.normal_start_trigger = "A máquina toma vida! Vá para o nível inferior!"
	L.gas_trigger = "A Máquina Mogu Ancestral quebrou!"

	L.combo_message = "%s: Combo soon!"

	L.arc_desc = "|cFFFF0000Este aviso só será mostrado para o chefe que você estiver com alvo.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

