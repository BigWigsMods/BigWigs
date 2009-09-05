if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_message = "Anub'arak engagé, Fouir dans 80 sec. !",
	engage_trigger = "Ce terreau sera votre tombeau !",

	unburrow_trigger = "surgit de la terre",
	burrow_trigger = "s'enfonce dans le sol",
	burrow = "Fouir",
	burrow_desc = "Affiche un délai de la technique Fouir d'Anub'Arak.",
	burrow_cooldown = "Prochain Fouir",
	burrow_soon = "Fouir imminent",

	icon = "Icône",
	icon_desc = "Place une icône sur le dernier joueur poursuivi par Anub'arak lors de sa phase sous terre (nécessite d'être assistant ou mieux).",

	chase = "Poursuivi",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Arrivant tout droit des plus noires et profondes cavernes des pics Foudroyés, Gormok l'Empaleur !",
	jormungars_trigger = "Apprêtez-vous, héros, car voici que les terreurs jumelles, Gueule-d'acide et Écaille-d'effroi, pénètrent dans l'arène !",
	icehowl_trigger = "L'air se gèle à l'entrée de notre prochain combattant, Glace-hurlante ! Tuez ou soyez tués, champions !",
	boss_incoming = "Arrivée de %s",

	-- Gormok
	snobold = "Frigbold",
	snobold_desc = "Prévient quand un joueur a un frigbold sur sa tête.",
	snobold_message = "Frigbold sur %s !",
	impale_message = "%2$dx Empaler sur %1$s",
	firebomb_message = "Bombe incendiaire en dessous de VOUS !",

	-- Jormungars
	spew = "Crachement acide/de lave",
	spew_desc = "Prévient de l'arrivée des Crachements acides/de lave.",

	slime_message = "Bave sur VOUS !",
	burn_spell = "Bile",
	toxin_spell = "Toxine",

	-- Icehowl
	butt_bar = "~Recharge Coup de tête",
	charge = "Charge furieuse",
	charge_desc = "Prévient quand un joueur subit les effets d'une Charge furieuse.",
	charge_trigger = "lâche un rugissement assourdissant !$",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	enable_trigger = "La prochaine bataille sera contre les chevaliers les plus puissants de la Croisade d'argent ! Ce n'est qu'après les avoir vaincus que vous serez déclarés dignes…",
	defeat_trigger = "Une victoire tragique et dépourvue de sens.",

	["Shield on %s!"] = "Bouclier sur %s !",
	["Bladestorming!"] = "Tempête de lames !",
	["Hunter pet up!"] = "Familier du chasseur revenu !",
	["Felhunter up!"] = "Chasseur corrompu réinvoqué !",
	["Heroism on champions!"] = "Héroïsme sur les champions !",
	["Bloodlust on champions!"] = "Furie sanguinaire sur les champions !",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_trigger = "Devant vous se tient Jaraxxus, seigneur Érédar de la Légion ardente !",
	--engage_trigger1 = "Banished to the Nether",

	incinerate_message = "Incinérer",
	incinerate_other = "Incinérer la chair : %s",
	incinerate_bar = "~Recharge Incinérer",

	legionflame_message = "Flamme",
	legionflame_other = "Flamme de la Légion : %s",
	legionflame_bar = "~Recharge Flamme",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Flamme de la Légion (nécessite d'être assistant ou mieux).",

	netherportal_bar = "~Recharge Portail",
	netherpower_bar = "~Recharge Puissance",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Au nom de notre ténébreux maître. Pour le roi-liche. Vous. Allez. Mourir.",

	vortex_or_shield_cd = "Prochain Vortex ou Bouclier",

	vortex = "Vortex",
	vortex_desc = "Prévient quand les jumelles commencent à incanter des Vortex.",

	shield = "Bouclier des ténèbres/des lumières",
	shield_desc = "Prévient de l'arrivée des Boucliers des ténèbres/des lumières.",

	touch = "Toucher des ténèbres/de lumière",
	touch_desc = "Prévient quand un joueur subit les effets d'un Toucher des ténèbres ou de lumière.",
} end)
