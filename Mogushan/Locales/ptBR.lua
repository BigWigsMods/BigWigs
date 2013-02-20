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
	L.phase_arcane_trigger = "Oh, inteligência das eras! Dê-me sua sabedoria arcana!"
	L.phase_shadow_trigger = "Grande alma dos antigos campeões! Leve-me ao seu escudo!"

	L.phase_message = "New phase soon!"
	L.shroud_message = "Mortalha"
	L.shroud_can_interrupt = "%s can interrupt %s!"
	L.barrier_message = "Barreira ATIVADA!"
	L.barrier_cooldown = "Barrier cooldown"

	L.phase_flame = "Fase das chamas!"
	L.phase_lightning = "Fase dos raios!"
	L.phase_arcane = "Fase arcana!"
	L.phase_shadow = "Fase das sombras!"

	-- Tanks
	L.tank = "Alertas de tanquers"
	L.tank_desc = "Conta as pilhas de Açoite de raios, Lança flamejante, Choque arcano e Sombra Ardente (Heróico)."
	L.lash_message = "Açoite"
	L.spear_message = "Lança"
	L.shock_message = "Choque"
	L.burn_message = "Sombra Ardente"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "ptBR")
if L then
	L.engage_yell = "É hora de morrer!"

	L.totem_message = "Totem (%d)"
	L.shadowy_message = "Ataque (%d)"
	L.banish_message = "Tanque Banido!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "ptBR")
if L then
	L.bosses = "Bosses"
	L.bosses_desc = "Warnings for when a boss becomes active."

	L.shield_removed = "Escudo removido! (%s)"
	L.casting_shields = "Conjurando escudos!"
	L.casting_shields_desc = "Avisa quando os escudos são conjurados para todos os chefes."
end

L = BigWigs:NewBossLocale("Elegon", "ptBR")
if L then
	L.engage_yell = "Entering defensive mode.  Disabling output failsafes."

	L.last_phase = "Última Fase!"
	L.overcharged_total_annihilation = "Overcharge %d! A bit much?"

	L.floor = "O Vórtice de Energia está descarregando!"
	L.floor_desc = "Avisa quando o chão está prestes a desaparecer."
	L.floor_message = "O chão está desaparecendo!"

	L.adds = "Adds"
	L.adds_desc = "Warnings for when a Celestial Protector is about to spawn."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ptBR")
if L then
	L.enable_zone = DUNGEON_FLOOR_MOGUSHANVAULTS3 -- translate me

	L.heroic_start_trigger = "Destruindo os canos"
	L.normal_start_trigger = "A máquina toma vida! Vá para o nível inferior!"

	L.rage_trigger = "A Ira do Imperador ecoa pelas colinas."
	L.strength_trigger = "A Força do Imperador prende esta terra com punhos de ferro."
	L.courage_trigger = "A Coragem do Imperador queima eternamente."
	L.bosses_trigger = "Dois construtos titânicos aparecem nas grandes alcovas!"
	L.gas_trigger = "A Máquina Mogu Ancestral quebrou!"
	L.gas_overdrive_trigger = "The Ancient Mogu Machine goes into overdrive!"

	L.target_only = "|cFFFF0000Este aviso só será mostrado para o chefe que você estiver com alvo.|r "
	L.combo_message = "%s: Combo soon!"
end

