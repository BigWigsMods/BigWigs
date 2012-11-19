local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "deDE")
if not L then return end
if L then
	L.engage_yell = "The Divine chose us to give mortal voice to Her divine will. We are but the vessel that enacts Her will."

	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Scheiben)"
	L.attenuation_bar = "Scheiben... tanzen!"
	L.attenuation_message = "%s tanzt %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- links <-|r"
	L.right = "|c00FF0000-> rechts ->|r"

	L.platform_emote = "Plattformen" -- Imperial Vizier Zor'lok flies to one of his platforms! --translated, not checked!
	L.platform_emote_final = "inhaliert"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal! --translated, not checked!
	L.platform_message = "Plattformwechsel"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "deDE")
if L then
	L.engage_yell = "On your guard, invaders. I, Ta'yak, Lord of Blades, will be your opponent."

	L.unseenstrike_inc = "Unsichtbarer Stoß!"

	L.assault_message = "Angriff"
	L.side_swap = "Side Swap"
end

L = BigWigs:NewBossLocale("Garalon", "deDE")
if L then
	L.removed = "%s entfernt!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "deDE")
if L then
	L.next_pack = "Nächste Gruppe (heroisch)"
	L.next_pack_desc = "Warnung, wann eine neue Gruppe landen wird, nachdem ihr eine Gruppe getötet habt."

	L.spear_removed = "Dein durchbohrender Speer wurde entfernt!"
	L.residue_removed = "%s entfernt!"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "deDE")
if L then
	L.explosion_by_other = "Amber Explosion on others"
	L.explosion_by_other_desc = "Cooldown warning for Amber Explosions cast by Amber Monstrosity or your focus target."

	L.explosion_casting_by_other = "Amber Explosion cast by others"
	L.explosion_casting_by_other_desc = "Casting warnings for Amber Explosions started by Amber Monstrosity or your focus target. Emphasizing this is highly recommended!"

	L.explosion_by_you = "Amber Explosion on you"
	L.explosion_by_you_desc = "Cooldown warning for your Amber Explosions."

	L.explosion_casting_by_you = "Amber Explosion cast by you"
	L.explosion_casting_by_you_desc = "Casting warnings for Amber Explosions started by you. Emphasizing this is highly recommended!"

	L.willpower = "Willenskraft"
	L.willpower_message = "Deine Willenskraft ist bei %d"

	L.break_free_message = "Health at %d%%!"
	L.fling_message = "Getting tossed!"
	L.parasite = "Parasite"

	L.boss_is_casting = "BOSS is casting!"
	L.you_are_casting = "YOU are casting!"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "deDE")
if L then
	L.phases = "Phasen"
	L.phases_desc = "Warnung bei Phasenwechsel."

	L.eyes = "Augen der Kaiserin"
	L.eyes_desc = "Zählt die Stapel von -Augen der Kaiserin- und zeigt eine Leiste mit der verbleibenden Dauer an."
	L.eyes_message = "%2$dx Augen auf %1$s"

	L.fumes_bar = "Your fumes buff"
end

