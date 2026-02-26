local L = BigWigs:NewBossLocale("Vorasius", "deDE")
if not L then return end
if L then
	L.shadowclaw_slam = "Hiebe"
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "deDE")
if L then
	L.fractured_projection = "Unterbrechungen"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "deDE")
if L then
	L.aura_of_wrath = "Zorn" -- Short for Aura of Wrath
	L.execution_sentence = "Todesurteil" -- Short for Execution Sentence
	L.judgement_red = "Richturteil [R]" -- R for the Red icon.
	L.aura_of_devotion = "Hingabe" -- Short for Aura of Devotion
	L.judgement_blue = "Richturteil [B]" -- B for the Blue icon.
	L.aura_of_peace = "Frieden" -- Short for Aura of Peace
	L.zaelous_spirit = "Geist" -- Short for Zealous Spirit
end
