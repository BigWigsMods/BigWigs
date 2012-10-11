local L = BigWigs:NewBossLocale("The Stone Guard", "ptBR")
if not L then return end
if L then
	L.petrifications = "Petrificação"
	L.petrifications_desc = "Avisa quando o chefe vai petrificar"
	L.overload = "Sobrecarga"
	L.overload_desc = "Avisa todos os tipos de overload."

end

L = BigWigs:NewBossLocale("Feng the Accursed", "ptBR")
if L then
	L.phases = "Fases"
	L.phases_desc = "Aviso para troca de fases"

	L.phase_flame_trigger = "Oh, magnificente! Através de mim você derreterá a carne dos ossos!"
	L.phase_lightning_trigger = "Oh, grande espírito! Conceda-me o poder da terra!"
	L.phase_arcane_trigger =  "Oh, inteligência das eras! Dêem-me sua sabedoria arcana!"
	L.phase_shadow_trigger = "Grande alma dos antigos campeões! Leve-me ao seu escudo!"

	L.shroud_message = "%2$s cast Shroud on %1$s"
	L.barrier_message = "Barrier UP!"

	L.phase_flame = "Fase das chamas!"
	L.phase_lightning = "Fase dos raios!"
	L.phase_arcane = "Fase arcana!"
	L.phase_shadow = "Fase das sombras!"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "ptBR")
if L then
	L.frenzy = "Frênesi iminente!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "ptBR")
if L then
	L.shield_removed = "Escudo removido!"
end

L = BigWigs:NewBossLocale("Elegon", "ptBR")
if L then
	L.floor_despawn = "Piso desaparece!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ptBR")
if L then
	L.rage_trigger = "A ira do imperador ecoa pelas colinas."
	L.strength_trigger = "A força do imperador prende esta terra com punhos de ferro!"
	L.courage_trigger = "A coragem do imperador queima eternamente!"
	L.bosses_trigger = "Dois constructos titânicos aparecem na grandes alcovas!"
end

