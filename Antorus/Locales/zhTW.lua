local L = BigWigs:NewBossLocale("Argus the Unmaker", "zhTW")
if not L then return end
if L then
	--L.combinedBurstAndBomb = "Combine Soulburst and Soulbomb"
	--L.combinedBurstAndBomb_desc = "|cff71d5ffSoulbombs|r are always applied in combination with |cff71d5ffSoulbursts|r. Enable this option to combine those two messages into one."

	--L.custom_off_always_show_combined = "Always show the combined Soulburst and Soulbomb message"
	--L.custom_off_always_show_combined_desc = "The combined message won't be displayed if you get the |cff71d5ffSoulbomb|r or the |cff71d5ffSoulburst|r. Enable this option to always show the combined message, even when you're affected. |cff33ff99Useful for raid leaders.|r"

	--L.stage2_early = "Let the fury of the sea wash away this corruption!"
	--L.stage3_early = "No hope. Just pain. Only pain!"

	--L.explosion = "%s Explosion"
	--L.gifts = "Gifts: %s (Sky), %s (Sea)"
	--L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tBurst:%s" -- short for Soulburst
	--L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tBomb:%s" -- short for Soulbomb
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "zhTW")
if L then
	--L.torment_of_the_titans_desc = "The Shivarra will force the titan souls to use their abilities against the players."

	--L.timeLeft = "%.1fs" -- s = seconds
	--L.torment = "Torment: %s"
	--L.nextTorment = "Next Torment: |cffffffff%s|r"
	--L.nextTorments = "Next Torments:"
	--L.tormentHeal = "Heal/DoT" -- something like Heal/DoT (max 10 characters)
	--L.tormentLightning = "Lightning" -- short for "Chain Lightning" (or similar, max 10 characters)
	--L.tormentArmy = "Army" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	--L.tormentFlames = "Flames" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "zhTW")
if L then
	L.warp_in_desc = "顯示每一波怪的計時器與訊息，並提示其中的特殊怪。"

	L.top_lane = "上"
	L.mid_lane = "中"
	L.bot_lane = "下"

	L.purifier = "淨化者" -- Fel-Powered Purifier
	L.destructor = "毀滅者" -- Fel-Infused Destructor
	L.obfuscator = "匿蹤者" -- Fel-Charged Obfuscator
	L.bats = "蝙蝠"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "zhTW")
if L then
	L.custom_on_filter_platforms = "過濾外側平台的警告與計時器"
	L.custom_on_filter_platforms_desc = "如果你不是上台組，關閉不需要的外側平台提示，只顯示中央場地的警告與計時器。"
	L.platform_active = "%s啟動！" -- Platform: Xoroth Active!
	--L.add_killed = "%s killed!"
end

L = BigWigs:NewBossLocale("Kin'garoth", "zhTW")
if L then
	--L.empowered = "(E) %s" -- (E) Ruiner
	L.gains = "金加洛斯獲得了%s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "zhTW")
if L then
	--L.felshieldActivated = "Felshield Activated by %s"
	--L.felshieldUp = "Felshield Up"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "zhTW")
if L then
	L.cannon_ability_desc = "顯示被兩門火砲強化後的技能訊息與計時器。"
	--L.missileImpact_desc = "Show a timer for the Annihilation missiles landing."
end
