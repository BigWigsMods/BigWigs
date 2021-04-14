local L = BigWigs:NewBossLocale("Doomwalker", "frFR")
if not L then return end
if L then
	L.name = "Marche-funeste"

	L.engage_trigger = "Cessez toute activité. Vous allez être éliminés."
	L.engage_message = "Marche-funeste engagé, Séisme dans ~30 sec. !"

	L.overrun_desc = "Prévient quand Marche-funeste utilise sa capacité Renversement."

	L.earthquake_desc = "Prévient quand Marche-funeste utilise sa capacité Séisme."
end

L = BigWigs:NewBossLocale("Doom Lord Kazzak", "frFR")
if L then
	L.name = "Seigneur funeste Kazzak"

	L.engage_trigger1 = "La Légion envahira l'univers !"
	L.engage_trigger2 = "Que les mortels périssent tous !"

	L.enrage_warning1 = "%s engagé - Enrager dans 50-60 sec."
	L.enrage_warning2 = "Enrager imminent !"
	L.enrage_message = "Enragé pendant 10 sec. !"
	L.enrage_finished = "Fin de l'Enrager - Prochain dans 50-60 sec."
	L.enrage_bar = "~Enrager"
	L.enraged_bar = "<Enragé>"
end

L = BigWigs:NewBossLocale("Gruul the Dragonkiller", "frFR")
if L then
	L.engage_trigger = "Venez… mourir."
	L.engage_message = "%s engagé !"

	L.grow = "Croissance"
	L.grow_desc = "Compte les Croissances de Grull et prévient de leurs arrivées."
	L.grow_message = "Croissance : (%d)"
	L.grow_bar = "Croissance (%d)"

	L.grasp = "Emprise"
	L.grasp_desc = "Avertissements et délais pour l'Emprise du seigneur gronn."
	L.grasp_message = "Heurt terrestre - Fracasser dans ~10 sec !"
	L.grasp_warning = "Heurt terrestre imminent"

	L.silence_message = "Silence de zone"
	L.silence_warning = "Silence de zone imminent !"
	L.silence_bar = "~Recharge Silence"
end

L = BigWigs:NewBossLocale("High King Maulgar", "frFR")
if L then
	L.engage_trigger = "Les gronns sont la seule vraie puissance de l'Outreterre !"

	L.heal_message = "Oeillaveugle incante une Prière de soins !"
	L.heal_bar = "Soin en cours"

	L.shield_message = "Bouclier sur Oeillaveugle !"

	L.spellshield_message = "Bouclier anti-sort sur Krosh !"

	L.summon_message = "Chasseur corrompu en cours d'invocation !"
	L.summon_bar = "~Recharge Chasseur corrompu"

	L.whirlwind_message = "Maulgar - Toubillon pendant 15 sec. !"
	L.whirlwind_warning = "Maulgar engagé - Tourbillon dans ~60 sec. !"

	L.mage = "Krosh Brasemain (Mage)"
	L.warlock = "Olm l'Invocateur (Démoniste)"
	L.priest = "Oeillaveugle le Voyant (Prêtre)"
end

L = BigWigs:NewBossLocale("Magtheridon", "frFR")
if L then
	L.escape = "Evasion"
	L.escape_desc = "Compte à rebours avant que Magtheridon ne soit libre."
	L.escape_trigger1 = "Les liens de %%s commencent à se relâcher !"
	L.escape_trigger2 = "Me... voilà... déchaîné !"
	L.escape_warning1 = "%s engagé - Libre dans 2 min. !"
	L.escape_warning2 = "Libre dans 1 min. !"
	L.escape_warning3 = "Libre dans 30 sec. !"
	L.escape_warning4 = "Libre dans 10 sec. !"
	L.escape_warning5 = "Libre dans 3 sec. !"
	L.escape_bar = "Libération…"
	L.escape_message = "%s libéré !"

	L.abyssal = "Abyssal ardent"
	L.abyssal_desc = "Prévient quand un Abyssal ardent est créé."
	L.abyssal_message = "Abyssal ardent créé (%d)"

	L.heal = "Soin"
	L.heal_desc = "Prévient quand un Canaliste des Flammes infernales commence à soigner."
	L.heal_message = "Se soigne !"

	L.banish = "Bannir"
	L.banish_desc = "Prévient quand vous bannissez Magtheridon."
	L.banish_message = "Banni pendant ~10 sec."
	L.banish_over_message = "Fin du ban !"
	L.banish_bar = "<Banni>"

	L.exhaust_desc = "Barre temporelles pour l'Epuisement d'esprit des joueurs."
	L.exhaust_bar = "[%s] épuisé"

	L.debris_trigger = "Que les murs de cette prison tremblent"
	L.debris_message = "30% - Arrivée des débris !"
end

