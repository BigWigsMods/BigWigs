local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "deDE")
if not L then return end
if L then
	L.engage_yell = "Die Göttliche erwählte uns als sterbliche Stimme für Ihren göttlichen Willen. Wir existieren, um Ihren Willen auszuführen"

	L.force_message = "AoE Puls"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Scheiben)"
	L.attenuation_bar = "Scheiben... tanzen!"
	L.attenuation_message = "%s tanzt %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- links <-|r"
	L.right = "|c00FF0000-> rechts ->|r"

	L.platform_emote = "Plattformen" -- Imperial Vizier Zor'lok flies to one of his platforms! --translated, not checked!
	L.platform_emote_final = "inhalieren"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal! --translated, not checked!
	L.platform_message = "Plattformwechsel"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "deDE")
if L then
	L.engage_yell = "Seid auf der Hut, Eindringlinge. Ich, Ta'yak, Klingenfürst, werde Euer Gegner sein."

	L.unseenstrike_inc = "Unsichtbarer Stoß!"
	L.unseenstrike_soon = "Stoß in ~5-10 sec!"

	L.assault_message = "Angriff"
	L.side_swap = "Seitenwechsel"
end

L = BigWigs:NewBossLocale("Garalon", "deDE")
if L then
	L.phase2_trigger = "Garalon's Plattenrüstung reißt und platzt auf!"

	L.removed = "%s entfernt!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "deDE")
if L then
	L.spear_removed = "Dein durchbohrender Speer wurde entfernt!"
	L.residue_removed = "%s entfernt!"

	L.mending_desc = "|cFFFF0000WARNUNG: Nur der Timer für dein 'Focusziel' wird angezeigt, da alle Schlachtheiler der Zar'thik einen seperaten Heilungs-Cooldown haben.|r "
	L.mending_warning = "Dein Focusziel wirkt Besserung!"
	L.mending_bar = "Focus: Besserung"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "deDE")
if L then
	L.explosion_by_other = "Bernexplosion Cooldownleiste der Monstrosität/Focus"
	L.explosion_by_other_desc = "Cooldown Warnung und Zauberleiste für Amberexplosion der Bernmonstrosität oder deinem Focusziel."

	L.explosion_casting_by_other = "Bernexplosion Zauberleiste der Monstrosität/Focus"
	L.explosion_casting_by_other_desc = "Zauberwarnung für Bernexplosion der Bernmonstrosität oder deinem Focusziel. Stark Hervorheben wird empfohlen!"

	L.explosion_by_you = "Dein Bernexplosions-Cooldown"
	L.explosion_by_you_desc = "Cooldown Warnung für deine Berexplosion."
	L.explosion_by_you_bar = "Du beginnst zu casten..."

	L.explosion_casting_by_you = "Deine Bernexplosion-Zauberleiste"
	L.explosion_casting_by_you_desc = "Warnung für das Wirken deiner Berexplosion. Stark Hervorheben wird empfohlen!"

	L.willpower = "Willenskraft"
	L.willpower_message = "Deine Willenskraft ist bei %d"

	L.break_free_message = "Leben auf %d%%!"
	L.fling_message = "Werde geworfen!"
	L.parasite = "Parasit"

	L.monstrosity_is_casting = "Monster: Explosion"
	L.you_are_casting = "DU castest!"

	L.unsok_short = "|cFFF20056Boss|r" -- Light Red
	L.monstrosity_short = "|cFFFFBE00Monster|r" -- Amber
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "deDE")
if L then
	L.phases = "Phasen"
	L.phases_desc = "Warnung bei Phasenwechsel."

	L.eyes = "Augen der Kaiserin"
	L.eyes_desc = "Zählt die Stapel von -Augen der Kaiserin- und zeigt eine Leiste mit der verbleibenden Dauer an."
	L.eyes_message = "%2$dx Augen auf %1$s"

	L.fumes_bar = "Dein Giftschwaden-Buff"
end

