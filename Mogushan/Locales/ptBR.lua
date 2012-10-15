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

	L.totem = "Totem"
	L.frenzy = "Frênesi iminente!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "ptBR")
if L then
	L.shield_removed = "Escudo removido!"
end

L = BigWigs:NewBossLocale("Elegon", "ptBR")
if L then
	L.last_phase = "Última Fase!"
	L.floor_despawn = "Piso desaparece"
	L.overcharged_total_annihilation = "Você tem (%d) %s, reinicie sua penalidade!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ptBR")
if L then
	L.rage_trigger = "A ira do imperador ecoa pelas colinas."
	L.strength_trigger = "A força do imperador prende esta terra com punhos de ferro!"
	L.courage_trigger = "A coragem do imperador queima eternamente!"
	L.bosses_trigger = "Dois constructos titânicos aparecem na grandes alcovas!"
end

