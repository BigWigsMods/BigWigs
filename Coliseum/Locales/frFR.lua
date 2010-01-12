local L = BigWigs:NewBossLocale("Anub'arak", "frFR")
if L then
	L.engage_message = "Anub'arak engagé, Fouir dans 80 sec. !"
	L.engage_trigger = "Ce terreau sera votre tombeau !"

	L.unburrow_trigger = "surgit de la terre"
	L.burrow_trigger = "s'enfonce dans le sol"
	L.burrow = "Fouir"
	L.burrow_desc = "Affiche un délai de la technique Fouir d'Anub'Arak."
	L.burrow_cooldown = "Prochain Fouir"
	L.burrow_soon = "Fouir imminent"

	L.nerubian_message = "Arrivée de fouisseurs !"
	L.nerubian_burrower = "Plus de fouisseurs"

	L.shadow_soon = "Attaque d'ombre dans ~5 sec. !"

	L.freeze_bar = "~Prochaine Entaille givrante"
	L.pcold_bar = "~Prochain Froid pénétrant"

	L.chase = "Poursuivi"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "frFR")
if L then
	L.enable_trigger = "Vous avez entendu l'appel de la Croisade d'argent, et vaillamment répondu !"
	L.wipe_trigger = "Tragique…"

	L.engage_trigger = "Arrivant tout droit des plus noires et profondes cavernes des pics Foudroyés, Gormok l'Empaleur !"
	L.jormungars_trigger = "Apprêtez-vous, héros, car voici que les terreurs jumelles, Gueule-d'acide et Écaille-d'effroi, pénètrent dans l'arène !"
	L.icehowl_trigger = "L'air se gèle à l'entrée de notre prochain combattant, Glace-hurlante ! Tuez ou soyez tués, champions !"
	L.boss_incoming = "Arrivée de %s"

	-- Gormok
	L.snobold = "Frigbold"
	L.snobold_desc = "Prévient quand un joueur a un frigbold sur sa tête."
	L.snobold_message = "Frigbold"
	L.impale_message = "%2$dx Empaler sur %1$s"
	L.firebomb_message = "Bombe incendiaire en dessous de VOUS !"

	-- Jormungars
	L.submerge = "Dans le sol"
	L.submerge_desc = "Prévient quand les vers s'enfoncent dans le sol."
	L.spew = "Crachement acide/de lave"
	L.spew_desc = "Prévient de l'arrivée des Crachements acides/de lave."
	L.sprays = "Jets"
	L.sprays_desc = "Prévient de l'arrivée du prochain Jet paralysant et brûlant."
	L.slime_message = "Bave sur VOUS !"
	L.burn_spell = "Bile"
	L.toxin_spell = "Toxine"
	L.spray = "~Prochain Jet"

	-- Icehowl
	L.butt_bar = "~Recharge Coup de tête"
	L.charge = "Charge furieuse"
	L.charge_desc = "Prévient quand un joueur subit les effets d'une Charge furieuse."
	L.charge_trigger = "lâche un rugissement assourdissant !$"
	L.charge_say = "Charge furieuse sur moi !"

	L.bosses = "Boss"
	L.bosses_desc = "Prévient quand le boss suivant arrive."
end

L = BigWigs:NewBossLocale("Faction Champions", "frFR")
if L then
	L.enable_trigger = "La prochaine bataille sera contre les chevaliers les plus puissants de la Croisade d'argent ! Ce n'est qu'après les avoir vaincus que vous serez déclarés dignes…"
	L.defeat_trigger = "Une victoire tragique et dépourvue de sens."

	L["Shield on %s!"] = "Bouclier sur %s !"
	L["Bladestorming!"] = "Tempête de lames !"
	L["Hunter pet up!"] = "Familier du chasseur appelé !"
	L["Felhunter up!"] = "Chasseur corrompu invoqué !"
	L["Heroism on champions!"] = "Héroïsme sur les champions !"
	L["Bloodlust on champions!"] = "Furie sanguinaire sur les champions !"
end

L = BigWigs:NewBossLocale("Lord Jaraxxus", "frFR")
if L then
	L.enable_trigger = "Misérable gnome ! Ton arrogance te perdra !"

	L.engage = "Engagement"
	L.engage_trigger = "Devant vous se tient Jaraxxus, seigneur Érédar de la Légion ardente !"
	L.engage_trigger1 = "Mais ! C'est moi qui commande, ici"

	L.adds = "Portails et volcans"
	L.adds_desc = "Prévient quand Jaraxxus invoque des portails et des volcans."

	L.incinerate_message = "Incinérer la chair"
	L.incinerate_other = "Incinérer : %s"
	L.incinerate_bar = "Prochain Incinérer"
	L.incinerate_safe = "%s est sauf !"

	L.legionflame_message = "Flamme de la Légion"
	L.legionflame_other = "Flamme : %s"
	L.legionflame_bar = "Prochaine Flamme"

	L.infernal_bar = "Apparition d'un volcan"
	L.netherportal_bar = "Apparition d'un portail"
	L.netherpower_bar = "~Prochaine Puissance"

	L.kiss_message = "Baiser de la Maîtresse sur VOUS !"
	L.kiss_interrupted = "Interrompu !"
end

L = BigWigs:NewBossLocale("The Twin Val'kyr", "frFR")
if L then
	L.engage_trigger1 = "Au nom de notre ténébreux maître. Pour le roi-liche. Vous. Allez. Mourir."

	L.vortex_or_shield_cd = "Prochain Vortex ou Bouclier"
	L.next = "Prochain Vortex ou Bouclier"
	L.next_desc = "Prévient quand le prochain Vortex ou Bouclier arrive."

	L.vortex = "Vortex"
	L.vortex_desc = "Prévient quand les jumelles commencent à incanter des Vortex."

	L.shield = "Bouclier des ténèbres/des lumières"
	L.shield_desc = "Prévient de l'arrivée des Boucliers des ténèbres/des lumières."
	L.shield_half_message = "Bouclier à 50% !"
	L.shield_left_message = "%d%% du bouclier restant"

	L.touch = "Toucher des ténèbres/de lumière"
	L.touch_desc = "Prévient quand un joueur subit les effets d'un Toucher des ténèbres ou de lumière."
end
