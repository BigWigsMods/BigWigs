local L = BigWigs:NewBossLocale("Beth'tilac", "zhCN")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Lord Rhyolith", "zhCN")
if L then
	L.phase2_message = "Immolation phase soon! Boss has %dx %s"
end

L = BigWigs:NewBossLocale("Alysrazor", "zhCN")
if L then
	L.tornado_trigger = "These skies are MINE!"
	L.claw_message = "%2$dx Claw on %1$s"
	L.fullpower_message = "%s soon!"
end

L = BigWigs:NewBossLocale("Shannox", "zhCN")
if L then
	L.safe = "%s safe"
end

L = BigWigs:NewBossLocale("Baleroc", "zhCN")
if L then
	L.torment_message = "%2$dx torment on %1$s"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "zhCN")
if L then
	L.seed_explosion = "Seed explosion soon!"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhCN")
if L then
	L.intermission = "Intermission"
	L.sons_left = "%d Sons Left"
	L.engulfing_close = "Close %s"
	L.engulfing_middle = "Far %s"
	L.engulfing_far = "Middle %s"
end

