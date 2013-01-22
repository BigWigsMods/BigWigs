local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "itIT")
if not L then return end
if L then
	L.engage_yell = "Siamo stati scelti per essere la voce mortale del Suo divino potere. Siamo solo uno strumento sotto il Suo controllo."

	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Dischi)"
	L.attenuation_bar = "Dischi... Corri!"
	L.attenuation_message = "%s Si balla %s"
	L.echo = "|c001cc986Eco|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- Sinistra <-|r"
	L.right = "|c00FF0000-> Destra ->|r"

	L.platform_emote = "Piattaforme" -- Visir Imperiale Zor'lok vola su una delle sue piattaforme!
	L.platform_emote_final = "Inala"-- Visir Imperiale Zor'lok inala i Feromoni dello Zelo!
	L.platform_message = "Cambio Piattaforma"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "itIT")
if L then
	L.engage_yell = "In guardia, invasori. Io, il Signore delle Lame, Ta'yak, sarò il vostro avversario."

	L.unseenstrike_inc = "Assalto Invisibile tra poco!"
	L.unseenstrike_soon = "Assalto tra ~5-10 sec!"

	L.assault_message = "Assalto"
	L.side_swap = "Cambio Lato"
end

L = BigWigs:NewBossLocale("Garalon", "itIT")
if L then
	L.phase2_trigger = "Garalon's massive armor plating begins to crack and split!"

	L.removed = "%s Rimosso!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "itIT")
if L then
	L.spear_removed = "La tua lancia impalante è stata rimossa!"
	L.residue_removed = "%s Rimosso!"

	L.mending_desc = "|cFFFF0000AVVISO: viene visualizzato solo il timer del tuo bersaglio 'focus' perché tutte i Guaritori da Barttaglia Zar'thik hanno tempi di lancio e di recupero separati per le cure.|r "
	L.mending_warning = "Il tuo focus sta lanciando Guarigione!"
	L.mending_bar = "Focus: Guarigione"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "itIT")
if L then
	L.explosion_by_other = "Esplosionoe d'Ambra su altri"
	L.explosion_by_other_desc = "Avviso recupero per Esplosione d'Ambra lanciato da Mostruosità d'Ambra sul tuo bersaglio focus."

	L.explosion_casting_by_other = "Esplosione d'Ambra lanciata da altri"
	L.explosion_casting_by_other_desc = "Visualizza avvisi per i lanci di Esplosione d'Ambra della Mostruosità d'Ambra sul tuo bersaglio focus. È caldamente raccomandato di enfatizzare questi messaggi!"

	L.explosion_by_you = "Esplosione d'Ambra su di te"
	L.explosion_by_you_bar = "Stai per lanciare..."
	L.explosion_by_you_desc = "Avviso recupero mancante per la tua Esplosione d'Ambra."

	L.explosion_casting_by_you = "Esplosione d'Ambra lanciata da te"
	L.explosion_casting_by_you_desc = "Visualizza avvisi per Esplosione d'Ambra lanciati da te. È caldamente raccomandato di enfatizzare questo messaggio"

	L.willpower = "Volontà"
	L.willpower_message = "La tua Volontà è %d"

	L.break_free_message = "Salute al %d%%!"
	L.fling_message = "Lanciato!"
	L.parasite = "Parassita"

	L.monstrosity_is_casting = "Monstrosity: Explosion"
	L.you_are_casting = "TU stai lanciando!"

	L.unsok_short = "|cFFF20056Boss|r" -- Light Red
	L.monstrosity_short = "|cFFFFBE00Add|r" -- Amber
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "itIT")
if L then
	L.phases = "Fasi"
	L.phases_desc = "Avviso per il cambiamento di Fasi."
	L.phases_icon = "achievement_raid_mantidraid07"

	L.eyes = "Occhi dell'Imperatrice"
	L.eyes_desc = "Conta le stack di Occhi dell'Imperatrice e mostra una barra di durata."
	L.eyes_message = "%2$dx Occhi su %1$s"

	L.fumes_bar = "Il tuo beneficio dei fumi"
end

