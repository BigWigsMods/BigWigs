local L = BigWigs:NewBossLocale("Cauldron of Carnage", "frFR")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Masquage des barres"
	L.custom_on_fade_out_bars_desc = "Masque les barres qui appartiennent au boss qui est hors de portée."

	L.bomb_explosion = "Explosion de bombe"
	L.bomb_explosion_desc = "Affiche un timer pour l'explosion des bombes."

	L.eruption_stomp = "Piétinement" -- Short for Eruption Stomp
	L.thunderdrum_salvo = "Salve" -- Short for Thunderdrum Salvo

	L.static_charge_high = "%d - Vous vous déplacez trop"
end

L = BigWigs:NewBossLocale("Rik Reverb", "frFR")
if L then
	L.amplification = "Amplificateur"
	L.echoing_chant = "Échos"
	L.faulty_zap = "Décharges"
	L.sparkblast_ignition = "Ignition"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "frFR")
if L then
	L.rolled_on_you = "%s vous a roulé dessus" -- PlayerX rolled over you
	L.rolled_from_you = "Vous avez roulé sur %s" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "Vous avez frappé le boss pour %s"

	L.electromagnetic_sorting = "Tri" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "Explosion fatale étouffée"
	L.short_fuse = "Explosion de crabombe"
	L.incinerator = "Cercles de feu"
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "frFR")
if L then
	L.foot_blasters = "Mines"
	L.unstable_shrapnel = "Mine absorbée"
	L.screw_up = "Foreuses"
	L.screw_up_single = "Foreuse" -- Singular of Drills
	L.sonic_ba_boom = "Dégâts sur le raid"
	L.polarization_generator = "Couleurs"

	L.polarization_soon = "Couleurs imminentes : %s"
	L.polarization_soon_change = "CHANGEMENT de couleurs imminent : %s"

	L.activate_inventions = "Activation : %s"
	L.blazing_beam = "Rayons"
	L.rocket_barrage = "Fusées"
	L.mega_magnetize = "Aimants"
	L.jumbo_void_beam = "Gros rayons"
	L.void_barrage = "Boules"
	L.everything = "Tout"

	L.under_you_comment = "E" -- Implies this setting is for the damage from the ground effect under you
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "frFR")
if L then
	L.rewards = "Prix" -- Fabulous Prizes
	L.rewards_desc = "Lorsque deux jetons sont verrouillés, un  \"prix fabuleux\" est distribué.\nLes messages vous laisseront savoir lequel a été obtenu.\nLa boîte d'info affichera quels prix sont encore disponibles."
	L.deposit_time = "Temps de dépôt:" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "Ligne pièces"
	L.shock = "Champ"
	L.flame = "Flamme"
	L.coin = "Pièce"

	L.withering_flames = "Flammes" -- Short for Withering Flames

	L.cheat = "Activation : %s" -- Cheat: Coils, Cheat: Debuffs, Cheat: Raid Damage, Cheat: Final Cast
	L.linked_machines = "Bobines"
	L.linked_machine = "Bobine" -- Singular of Coils
	L.hot_hot_heat = "Débuff châleur"
	L.explosive_jackpot = "Incantation finale"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "frFR")
if L then
	L.earthshaker_gaol = "Prisons"
	L.frostshatter_boots = "Bottes de givre" -- Short for Frostshatter Boots
	L.frostshatter_spear = "Lances de givre" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "Doigt-pistolet" -- Short for Stormfury Finger Gun
	L.molten_gold_knuckles = "Frontal Tank"
	L.unstable_crawler_mines = "Mines"
	L.goblin_guided_rocket = "Fusée"
	L.double_whammy_shot = "Tank Soak"
	L.electro_shocker = "Électrochoqueur mod. II"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "frFR")
if L then
	L.story_phase_trigger = "Vous pensez avoir gagné ?" -- What, you think you won? Nah, I got somethin' else for ya.

	L.scatterblast_canisters = "Cone Soak"
	L.fused_canisters = "Groupe Soaks"
	L.tick_tock_canisters = "Soaks"
	L.total_destruction = "DESTRUCTION !"

	L.duds = "Obus" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "Tous les obus ont détonné !"
	L.duds_remaining = "%d |4Obus restant:Obus restants;" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "Soak Obus (%d |4restant:restants;)"
end
