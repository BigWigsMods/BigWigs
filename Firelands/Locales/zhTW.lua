local L = BigWigs:NewBossLocale("Beth'tilac", "zhTW")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Lord Rhyolith", "zhTW")
if L then
	L.phase2_message = "Immolation phase soon! Boss has %dx %s"
end

L = BigWigs:NewBossLocale("Alysrazor", "zhTW")
if L then
	L.tornado_trigger = "These skies are MINE!"
	L.claw_message = "%2$dx Claw on %1$s"
	L.fullpower_message = "%s soon!"
end

L = BigWigs:NewBossLocale("Shannox", "zhTW")
if L then
	L.safe = "%s safe"
end

L = BigWigs:NewBossLocale("Baleroc", "zhTW")
if L then
	L.torment_message = "%2$dx torment on %1$s"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "zhTW")
if L then
	L.seed_explosion = "Seed explosion soon!"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhTW")
if L then
	L.intermission = "Intermission"
	L.sons_left = "%d Sons Left"
	L.engulfing_close = "Close %s"
	L.engulfing_middle = "Middle %s"
	L.engulfing_far = "Far %s"
end

