local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "frFR")
if L then
	L.engage_message = "Anub'arak engagé, Fouir dans 80 sec. !"
	L.engage_trigger = "Ce terreau sera votre tombeau !"
	
	L.unburrow_trigger = "surgit de la terre"
	L.burrow_trigger = "s'enfonce dans le sol"
	L.burrow = "Fouir"
	L.burrow_desc = "Affiche un délai de la technique Fouir d'Anub'Arak."
	L.burrow_cooldown = "Prochain Fouir"
	L.burrow_soon = "Fouir imminent"

	L.icon = "Icône"
	L.icon_desc = "Place une icône sur le dernier joueur poursuivi par Anub'arak lors de sa phase sous terre (nécessite d'être assistant ou mieux)."

	L.chase = "Poursuivi"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "frFR")
if L then
	L.engage_trigger = "Arrivant tout droit des plus noires et profondes cavernes des pics Foudroyés, Gormok l'Empaleur !"
	L.jormungars_trigger = "Apprêtez-vous, héros, car voici que les terreurs jumelles, Gueule-d'acide et Écaille-d'effroi, pénètrent dans l'arène !"
	L.icehowl_trigger = "L'air se gèle à l'entrée de notre prochain combattant, Glace-hurlante ! Tuez ou soyez tués, champions !"
	L.boss_incoming = "Arrivée de %s"

	-- Gormok
	L.snobold = "Frigbold"
	L.snobold_desc = "Prévient quand un joueur a un frigbold sur sa tête."
	L.snobold_message = "Frigbold sur %s !"
	L.impale_message = "%2$dx Empaler sur %1$s"
	L.firebomb_message = "Bombe incendiaire en dessous de VOUS !"

	-- Jormungars
	L.spew = "Crachement acide/de lave"
	L.spew_desc = "Prévient de l'arrivée des Crachements acides/de lave."

	L.slime_message = "Bave sur VOUS !"
	L.burn_spell = "Bile"
	L.toxin_spell = "Toxine"

	-- Icehowl
	L.butt_bar = "~Recharge Coup de tête"
	L.charge = "Charge furieuse"
	L.charge_desc = "Prévient quand un joueur subit les effets d'une Charge furieuse."
	L.charge_trigger = "lâche un rugissement assourdissant !$"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "frFR")
if L then
	L.enable_trigger = "La prochaine bataille sera contre les chevaliers les plus puissants de la Croisade d'argent ! Ce n'est qu'après les avoir vaincus que vous serez déclarés dignes…"
	L.defeat_trigger = "Une victoire tragique et dépourvue de sens."

	L["Shield on %s!"] = "Bouclier sur %s !"
	L["Bladestorming!"] = "Tempête de lames !"
	L["Hunter pet up!"] = "Familier du chasseur revenu !"
	L["Felhunter up!"] = "Chasseur corrompu réinvoqué !"
	L["Heroism on champions!"] = "Héroïsme sur les champions !"
	L["Bloodlust on champions!"] = "Furie sanguinaire sur les champions !"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "frFR")
if L then
	L.engage = "Engagement"
	L.engage_trigger = "Devant vous se tient Jaraxxus, seigneur Érédar de la Légion ardente !"
	--L.engage_trigger1 = "Banished to the Nether"

	L.incinerate_message = "Incinérer"
	L.incinerate_other = "Incinérer la chair : %s"
	L.incinerate_bar = "~Recharge Incinérer"

	L.legionflame_message = "Flamme"
	L.legionflame_other = "Flamme de la Légion : %s"
	L.legionflame_bar = "~Recharge Flamme"

	L.icon = "Icône"
	L.icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Flamme de la Légion (nécessite d'être assistant ou mieux)."

	L.netherportal_bar = "~Recharge Portail"
	L.netherpower_bar = "~Recharge Puissance"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "frFR")
if L then
	L.engage_trigger1 = "Au nom de notre ténébreux maître. Pour le roi-liche. Vous. Allez. Mourir."

	L.vortex_or_shield_cd = "Prochain Vortex ou Bouclier"

	L.vortex = "Vortex"
	L.vortex_desc = "Prévient quand les jumelles commencent à incanter des Vortex."

	L.shield = "Bouclier des ténèbres/des lumières"
	L.shield_desc = "Prévient de l'arrivée des Boucliers des ténèbres/des lumières."

	L.touch = "Toucher des ténèbres/de lumière"
	L.touch_desc = "Prévient quand un joueur subit les effets d'un Toucher des ténèbres ou de lumière."
end
