local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "itIT")
if not L then return end
if L then
	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discs)"
	L.attenuation_message = "Incoming Discs, Dance!"

	L.platform_emote = "platforms" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "inhales"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "Swapping Platform"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "itIT")
if L then

	L.unseenstrike_cone = "Cono dell'Assalto Invisibile!"
	L.assault_message = "%2$dx Assalto su %1$s"
	L.assault = "Assalto Opprimente"
	L.assault_desc = "Avviso solo per i Difensori. L'attacco lascia il Difensore esposto ai danni dei prossimi Attacchi Opprimenti del 100% per 45 secondi."
end

L = BigWigs:NewBossLocale("Garalon", "itIT")
if L then
	L.crush_stun = "Crush stun"
	L.crush_trigger1 = "Garalon si prepara a "
	L.crush_trigger2 = "Garalon senses" --Garalon senses the passage of Pheromones and begins to cast [Crush]! -- DA TRADURRE
	L.crush_trigger3 = "Garalon detects" --Garalon detects Baddie under him and begins to cast [Crush]! -- DA TRADURRE
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "itIT")
if L then
	L.next_pack = "Prossima Ondata"
	L.next_pack_desc = "Avvertimento per l'arrivo di una nuova ondata dopo aver ucciso un gruppo di Add."

	L.spear_removed = "La tua lancia impalante e' stata rimossa!"
	L.residue_removed = "%s Rimosso!"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "itIT")
if L then
	L.explosion_casting = "Lancio di Esplosione d'Ambra!"
	L.explosion_casting_desc = "Avviso per il cast di Esplosione d'Ambra. L'avviso di inizio cast è associato a quest'opzione. Enfatizzazione fortemente consigliata!"

	L.willpower = "Volontà"
	L.willpower_desc = "Quando Volontà finisce, il giocatore muore e il Costrutto Mutato continua ad attaccare, fuori controllo."
	L.willpower_message = "La tua Volonta' e': %d (%d)"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "itIT")
if L then
	L.phases = "Fasi"
	L.phases_desc = "Avviso per il cambiamento di Fasi."
	L.phases_icon = "achievement_raid_mantidraid07"

	L.eyes = "Occhi dell'Imperatrice"
	L.eyes_desc = "Conta le stack di Occhi dell'Imeratrice e mostra una barra di durata."
	L.eyes_message = "%2$dx Occhi su %1$s"
end

