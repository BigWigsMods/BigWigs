local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "frFR")
if not L then return end
if L then
	L.engage_yell = "The Divine chose us to give mortal voice to Her divine will. We are but the vessel that enacts Her will."

	L.force_message = "Impulsion de zone"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (anneaux)"
	L.attenuation_bar = "Anneaux... dansez !"
	L.attenuation_message = "%s Dancing %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- Left <-|r"
	L.right = "|c00FF0000-> Right ->|r"

	L.platform_emote = "plateformes" -- Le vizir impérial Zor'lok s'envole vers l'une de ses plateformes !
	L.platform_emote_final = "inhale"-- Le vizir impérial Zor'lok inhale les Phéromones de zèle !
	L.platform_message = "Changement de plateforme"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "frFR")
if L then
	L.engage_yell = "On your guard, invaders. I, Ta'yak, Lord of Blades, will be your opponent."

	L.unseenstrike_inc = "Arrivée d'une Frappe !"

	L.assault_message = "Assauts"
	L.side_swap = "Side Swap"
end

L = BigWigs:NewBossLocale("Garalon", "frFR")
if L then
	L.removed = "%s enlevé !"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "frFR")
if L then
	L.next_pack = "Prochain groupe"
	L.next_pack_desc = "Prévient quand un prochain groupe atterrit après que vous ayez tué un autre."

	L.spear_removed = "Votre Lance de perforation a été enlevée !"
	L.residue_removed = "%s enlevé !"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "frFR")
if L then
	L.explosion_by_other = "Amber Explosion on others"
	L.explosion_by_other_desc = "Cooldown warning for Amber Explosions cast by Amber Monstrosity or your focus target."

	L.explosion_casting_by_other = "Amber Explosion cast by others"
	L.explosion_casting_by_other_desc = "Casting warnings for Amber Explosions started by Amber Monstrosity or your focus target. Emphasizing this is highly recommended!"

	L.explosion_by_you = "Amber Explosion on you"
	L.explosion_by_you_desc = "Cooldown warning for your Amber Explosions."

	L.explosion_casting_by_you = "Amber Explosion cast by you"
	L.explosion_casting_by_you_desc = "Casting warnings for Amber Explosions started by you. Emphasizing this is highly recommended!"

	L.willpower = "Points de Volonté"
	L.willpower_message = "Vos points de Volonté sont à %d"

	L.break_free_message = "Health at %d%%!"
	L.fling_message = "Getting tossed!"
	L.parasite = "Parasite"

	L.boss_is_casting = "BOSS is casting!"
	L.you_are_casting = "YOU are casting!"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "frFR")
if L then
	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre change de phase."

	L.eyes = "Yeux de l'impératrice"
	L.eyes_desc = "Compte les cumuls d'Yeux de l'impératrice et affiche une barre de durée."
	L.eyes_message = "%2$dx yeux sur %1$s"

	L.fumes_bar = "Your fumes buff"
end

