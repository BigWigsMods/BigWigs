local L = BigWigs:NewBossLocale("Vexie and the Geargrinders", "deDE")
if not L then return end
if L then
	L.plating_removed = "%d Schutzpanzerung noch übrig"
	L.exhaust_fumes = "Raid Schaden"
end

L = BigWigs:NewBossLocale("Cauldron of Carnage", "deDE")
if L then
	L.custom_on_fade_out_bars = "Leisten abblenden"
	L.custom_on_fade_out_bars_desc = "Blendet die Leisten ab, welche zum aus der Reichweite befindlichen Boss gehören."

	L.bomb_explosion = "Bombenexplosion"
	L.bomb_explosion_desc = "Zeigt einen Timer für die Explosion der Bomben."

	L.eruption_stomp = "Stampfen" -- Short for Eruption Stomp
	L.thunderdrum_salvo = "Salve" -- Short for Thunderdrum Salvo
	L.voltaic_image = "Fixierungen" -- Multiple of Fixate
end

L = BigWigs:NewBossLocale("Rik Reverb", "deDE")
if L then
	L.amplification = "Verstärker"
	L.echoing_chant = "Echos"
	L.faulty_zap = "Schocker"
	L.sparkblast_ignition = "Fässer"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "deDE")
if L then
	L.ball_size_medium = "Mittlerer Ball!"
	L.ball_size_large = "Großer Ball!"
	L.rolled_on_you = "%s ist über DICH gerollt" -- PlayerX rolled over you
	L.rolled_from_you = "Ist über %s gerollt" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "DU hast den BOSS getroffen für %s"

	L.electromagnetic_sorting = "Sortierung" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "Bombe absorbiert"
	L.short_fuse = "Bombenhülse Explosion"
	L.incinerator = "Feuerkreise"
	L.landing = "Landung" -- Landing down from the sky
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "deDE")
if L then
	L.foot_blasters = "Minen"
	L.screw_up = "Bohrer"
	L.sonic_ba_boom = "Raid Schaden"
	L.polarization_generator = "Farbänderungen"

	L.polarization_soon = "Farbänderung bald: %s"

	L.activate_inventions = "Aktiviert: %s"
	L.blazing_beam = "Strahlen"
	L.rocket_barrage = "Raketen"
	L.mega_magnetize = "Magneten"
	L.jumbo_void_beam = "Große Strahlen"
	L.void_barrage = "Bälle"
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "deDE")
if L then
	L.rewards = "Preise" -- Fabulous Prizes
	L.rewards_desc = "Wenn zwei Walzen eingerastet sind, wird die \"fabelhafte Belohnung\" ausgegeben.\nNachrichten weisen darauf hin, welche ausgegeben wird.\nDie Infobox zeigt an, welche Preise noch verfügbar sind."
	L.deposit_time = "Einwurfzeit" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "Münzen"
	L.shock = "Schock"
	L.flame = "Flamme"
	L.coin = "Münze"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "deDE")
if L then
	L.earthshaker_gaol = "Gefängnisse"
	L.frostshatter_boots = "Froststiefel" -- Short for Frostshatter Boots
	L.frostshatter_spear = "Frostspeere" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "Fingerpistole" -- Short for Stormfury Finger Gun
	L.molten_gold_knuckles = "Tank Frontal"
	L.unstable_crawler_mines = "Minen"
	L.goblin_guided_rocket = "Rakete"
	L.double_whammy_shot = "Tank Soak"
	L.electro_shocker = "Schocker"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "deDE")
if L then
	L.scatterblast_canisters = "Kegel Soak"
	L.fused_canisters = "Gruppen Soaks"
	L.tick_tock_canisters = "Soaks"
	L.total_destruction = "ZERSTÖRUNG!"

	L.duds = "Blindgänger" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "Alle Blindgänger detoniert!"
	L.duds_remaining = "%d Blindgänger übrig" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "Soak Blindgänger (%d übrig)"
end
