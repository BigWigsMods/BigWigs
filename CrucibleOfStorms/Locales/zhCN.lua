local L = BigWigs:NewBossLocale("The Restless Cabal", "zhCN")
if not L then return end
if L then
	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "zhCN")
if L then
	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
end
