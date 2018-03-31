local L = BigWigs:NewBossLocale("Argus the Unmaker", "esES") or BigWigs:NewBossLocale("Argus", "esMX")
if not L then return end
if L then
	--L.combinedBurstAndBomb = "Combine Soulburst and Soulbomb"
	--L.combinedBurstAndBomb_desc = "|cff71d5ffSoulbombs|r are always applied in combination with |cff71d5ffSoulbursts|r. Enable this option to combine those two messages into one."

	--L.custom_off_always_show_combined = "Always show the combined Soulburst and Soulbomb message"
	--L.custom_off_always_show_combined_desc = "The combined message won't be displayed if you get the |cff71d5ffSoulbomb|r or the |cff71d5ffSoulburst|r. Enable this option to always show the combined message, even when you're affected. |cff33ff99Useful for raid leaders.|r"

	--L.fear_help = "Sargeras' Fear Combination"
	--L.fear_help_desc = "Say a special message if you're afflicted by |cff71d5ffSargeras' Fear|r and |cff71d5ffSoulblight|r/|cff71d5ffSoulburst|r/|cff71d5ffSoulbomb|r/|cff71d5ffSentence of Sargeras|r."

	--L[257931] = "Fear" -- short for Sargeras' Fear
	--L[248396] = "Blight" -- short for Soulblight
	--L[251570] = "Bomb" -- short for Soulbomb
	--L[250669] = "Burst" -- short for Soulburst
	--L[257966] = "Sentence" -- short for Sentence of Sargeras

	--L.stage2_early = "Let the fury of the sea wash away this corruption!"
	--L.stage3_early = "No hope. Just pain. Only pain!"

	--L.gifts = "Gifts: %s (Sky), %s (Sea)"
	--L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tBurst:%s" -- short for Soulburst
	--L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tBomb (%d):|T137002:0|t%s - " -- short for Soulbomb

	--L.sky_say = "{rt5} Crit/Mast" -- short for Critical Strike/Mastery (stats)
	--L.sea_say = "{rt6} Haste/Versa" -- short for Haste/Versatility (stats)

	--L.bomb_explosions = "Bomb Explosions"
	--L.bomb_explosions_desc = "Show a timer for Soulburst and Soulbomb exploding."
end

L = BigWigs:NewBossLocale("Aggramar", "esES") or BigWigs:NewBossLocale("Aggramar", "esMX")
if L then
	--L.wave_cleared = "Wave %d Cleared!" -- Wave 1 Cleared!

	--L.track_ember = "Ember of Taeshalach Tracker"
	--L.track_ember_desc = "Display messages for each Ember of Taeshalach death."

	--L.custom_off_ember_marker_desc = "Mark Ember of Taeshalach with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cff33ff99Mythic: This will only mark adds in the current wave and above 45 energy.|r"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "esES") or BigWigs:NewBossLocale("The Coven of Shivarra", "esMX")
if L then
	--L.torment_of_the_titans_desc = "The Shivarra will force the titan souls to use their abilities against the players."

	--L.timeLeft = "%.1fs" -- s = seconds
	--L.torment = "Torment: %s"
	--L.nextTorment = "Next Torment: |cffffffff%s|r"
	--L.tormentHeal = "Heal/DoT" -- something like Heal/DoT (max 10 characters)
	--L.tormentLightning = "Lightning" -- short for "Chain Lightning" (or similar, max 10 characters)
	--L.tormentArmy = "Army" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	--L.tormentFlames = "Flames" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "esES") or BigWigs:NewBossLocale("Eonar the Life-Binder", "esMX")
if L then
	--L.warp_in_desc = "Shows timers and messages for each wave, along with any special adds in the wave."

	--L.top_lane = "Top"
	--L.mid_lane = "Mid"
	--L.bot_lane = "Bot"

	--L.purifier = "Purifier" -- Fel-Powered Purifier
	--L.destructor = "Destructor" -- Fel-Infused Destructor
	--L.obfuscator = "Obfuscator" -- Fel-Charged Obfuscator
	--L.bats = "Fel Bats"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "esES") or BigWigs:NewBossLocale("Portal Keeper Hasabel", "esMX")
if L then
	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Hasabel randomizes which off-cooldown ability she uses next. When this option is enabled, the bars for those abilities will stay on your screen."
	--L.custom_on_filter_platforms = "Filter Side Platform Warnings and Bars"
	--L.custom_on_filter_platforms_desc = "Removes unnecessary messages and bars if you are not on a side platform. It will always show bars and warnings from the main Platform: Nexus."
	--L.worldExplosion_desc = "Show a timer for the Collapsing World explosion."
	--L.platform_active = "%s Active!" -- Platform: Xoroth Active!
	--L.add_killed = "%s killed!"
end

L = BigWigs:NewBossLocale("Kin'garoth", "esES") or BigWigs:NewBossLocale("Kin'garoth", "esMX")
if L then
	--L.empowered = "(E) %s" -- (E) Ruiner
	--L.gains = "Kin'garoth gains %s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "esES") or BigWigs:NewBossLocale("Antoran High Command", "esMX")
if L then
	--L.felshieldActivated = "Felshield Activated by %s"
	--L.felshieldUp = "Felshield Up"
	L.achiev = "'En el portal de Hasabel' achievement debuffs" -- Achievement 11928
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "esES") or BigWigs:NewBossLocale("Gorothi Worldbreaker", "esMX")
if L then
	--L.cannon_ability_desc = "Display Messages and Bars related to the 2 cannons on the Gorothi Worldbreaker's back."

	--L.missileImpact = "Annihilation Impact"
	--L.missileImpact_desc = "Show a timer for the Annihilation missiles landing."

	--L.decimationImpact = "Decimation Impact"
	--L.decimationImpact_desc = "Show a timer for the Decimation missiles landing."
end

L = BigWigs:NewBossLocale("Antorus Trash", "esES") or BigWigs:NewBossLocale("Antorus Trash", "esMX")
if L then
	-- [[ Before Garothi Worldbreaker ]] --
	L.felguard = "Guardia vil antoran"

	-- [[ After Garothi Worldbreaker ]] --
	L.flameweaver = "Tejedor de fuego"

	-- [[ Before Antoran High Command ]] --
	L.ravager = "Devastador juraespadas"
	L.deconix = "Imperador Deconix"
	L.clobex = "Clobex"

	-- [[ Before Portal Keeper Hasabel ]] --
	L.stalker = "Acechador hambriento"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	L.tarneth = "Tarneth"
	L.priestess = "Sacerdotisa del delirio"

	-- [[ Before Aggramar ]] --
	L.aedis = "Guarda oscuro Aedis"
end
