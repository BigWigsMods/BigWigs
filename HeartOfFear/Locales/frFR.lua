if not GetNumGroupMembers then return end
local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "frFR")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "frFR")
if L then
	L.unseenstrike_cone = "Cone de Frappe invisible"

	L.phase2_warning = "Phase 2 imminente !"

	L.assault = "Assaut accablant"
	L.assault_desc = "Alerte pour tanks uniquement. L'attaque laisse les défenses de la cible exposées, augmentant les dégâts subis par la cible quand un Assaut accablant la touche de 100% pendant 45 sec."
end

L = BigWigs:NewBossLocale("Garalon", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "frFR")
if L then
	L.next_pack = "Prochain groupe"
	L.next_pack_desc = "Prévient quand un prochain groupe atterrit après que vous ayez tué un autre."

	L.spear_removed = "Votre Lance de perforation a été enlevée !"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "frFR")
if L then
	L.explosion_boss = "Explosion sur le BOSS !"
	L.explosion_you = "Explosion sur VOUS !"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "frFR")
if L then
	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre change de phase."

	L.eyes = "Yeux de l'impératrice"
	L.eyes_desc = "Alerte pour tanks uniquement. Compte les cumuls d'Yeux de l'impératrice et affiche une barre de durée."
	L.eyes_message = "%2$dx yeux sur %1$s"
end
