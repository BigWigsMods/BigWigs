local L = BigWigs:NewBossLocale("Vorasius", "zhTW")
if not L then return end
if L then
	L.shadowclaw_slam = "猛擊"
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "zhTW")
if L then
	L.fractured_projection = "投影"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "zhTW")
if L then
	L.aura_of_wrath = "憤慨光環" -- Short for Aura of Wrath 不用縮寫
	L.execution_sentence = "死刑宣判" -- Short for Execution Sentence  不用縮寫，或者處決?
	L.judgement_red = "紅色審判" -- R for the Red icon. 審判+裁決
	L.aura_of_devotion = "奉獻光環" -- Short for Aura of Devotion
	L.judgement_blue = "藍色審判" -- B for the Blue icon. 審判+盾猛
	L.aura_of_peace = "和平光環" -- Short for Aura of Peace
	L.zaelous_spirit = "狂熱" -- Short for Zealous Spirit
end
