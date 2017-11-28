local L = BigWigs:NewBossLocale("Argus the Unmaker", "zhTW")
if not L then return end
if L then
	--L.stage2_early = "Let the fury of the sea wash away this corruption!"
	--L.stage3_early = "No hope. Just pain. Only pain!"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "zhTW")
if L then
	--L.torment_of_the_titans_desc = "The Shivvara will force the titan souls to use their abilities against the players."
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
end

L = BigWigs:NewBossLocale("Kin'garoth", "zhTW")
if L then
	--L.empowered = "(E) %s" -- (E) Ruiner
	L.gains = "金加洛斯獲得了%s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "zhTW")
if L then
	L.cannon_ability_desc = "顯示與火砲相關的警告與計時器。"
end



