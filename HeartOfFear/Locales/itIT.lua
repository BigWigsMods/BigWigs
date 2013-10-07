local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "itIT")
if not L then return end
if L then
	L.engage_yell = "Siamo stati scelti per essere la voce mortale del Suo divino potere. Siamo solo uno strumento sotto il Suo controllo."

	L.force_message = "Pulsazione ad Area"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Dischi)"
	L.attenuation_bar = "Dischi... Corri!"
	L.attenuation_message = "%s Si balla %s"
	L.echo = "|c001cc986Eco|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- Sinistra <-|r"
	L.right = "|c00FF0000-> Destra ->|r"

	L.platform_emote = "piattaforme" -- Visir Imperiale Zor'lok vola su una delle sue piattaforme!
	L.platform_emote_final = "inala"-- Visir Imperiale Zor'lok inala i Feromoni dello Zelo!
	L.platform_message = "Cambio Piattaforma"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "itIT")
if L then
	L.engage_yell = "In guardia, invasori. Io, il Signore delle Lame Ta'yak, sarò il vostro avversario."

	L.unseenstrike_soon = "Assalto (%d) tra ~5-10 sec!"
	L.assault_message = "Assalto"
	L.side_swap = "Cambio Lato"

	L.custom_off_windstep = "Marcatore Passo del Vento"
	L.custom_off_windstep_desc = "Per aiutare l'assegnazione delle cure, evidenzia i giocatori che hanno Passo del Vento con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, richiede capoincursione o assistente."
end

L = BigWigs:NewBossLocale("Garalon", "itIT")
if L then
	L.phase2_trigger = "Garalon's massive armor plating begins to crack and split!"

	L.removed = "%s Rimosso!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "itIT")
if L then
	L.spear_removed = "La tua Lancia Impalante è stata rimossa!"

	L.mending_desc = "|cFFFF0000AVVISO: viene visualizzato solo il timer del tuo bersaglio 'focus' perché tutte i Guaritori da Barttaglia Zar'thik hanno tempi di lancio e di recupero separati per le cure.|r "
	L.mending_warning = "Il tuo focus sta lanciando Guarigione!"
	L.mending_bar = "Focus: Guarigione"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "itIT")
if L then
	L.explosion_by_other = "Barra recupero Esplosione d'Ambra della Mostruosità/Focus"
	L.explosion_by_other_desc = "Avvisi e barre di recupero per Esplosione d'Ambra lanciata da Mostruosità d'Ambra o dal tuo bersaglio focus."

	L.explosion_casting_by_other = "Barra di lancio Esplosione d'Ambra della Mostruosità/Focus"
	L.explosion_casting_by_other_desc = "Avviso di lancio per Esplosione d'Ambra eseguita o da Mostruosità d'Ambra o dal tuo bersaglio focus. È altamente consigliato enfatizzare questo avviso!"

	L.explosion_by_you = "Recupero Tua Esplosione d'Ambra"
	L.explosion_by_you_desc = "Avviso recupero per tua Esplosione d'Ambra."
	L.explosion_by_you_bar = "Inizi a lanciare..."

	L.explosion_casting_by_you = "Barra di lancio Tua Esplosione d'Ambra"
	L.explosion_casting_by_you_desc = "Avviso di lancio per Esplosione d'Ambra eseguita da Te Stesso. È altamente consigliato enfatizzare questo avviso!"

	L.willpower = "Volontà"
	L.willpower_message = "La tua Volontà è %d"

	L.break_free_message = "Salute al %d%%!"
	L.fling_message = "Lanciato!"
	L.parasite = "Parassita"

	L.monstrosity_is_casting = "Mostruosità: Esplosione"
	L.you_are_casting = "TU stai lanciando!"

	L.unsok_short = "Boss"
	L.monstrosity_short = "Mostruosità"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "itIT")
if L then
	L.engage_trigger = "Morte a tutti coloro che osano sfidare il mio impero!"
	L.phases = "Fasi"
	L.phases_desc = "Avviso per il cambiamento delle Fasi."

	L.eyes = "Occhi dell'Imperatrice"
	L.eyes_desc = "Conta gli accumuli di Occhi dell'Imperatrice e mostra una barra di durata."
	L.eyes_message = "Occhi"

	L.visions_message = "Visioni"
	L.visions_dispel = "I giocatori sono stati impauriti!"
	L.fumes_bar = "Veleno su du te"
end

