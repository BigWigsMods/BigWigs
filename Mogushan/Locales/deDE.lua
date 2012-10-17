local L = BigWigs:NewBossLocale("The Stone Guard", "deDE")
if not L then return end
if L then
	L.petrifications = "Versteinerung"
	L.petrifications_desc = "Warnung, wenn einer der Bosse Versteinerung wirkt."

	L.overload = "Überladung"
	L.overload_desc = "Warnugen für alle Arten von Überladungen."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "deDE")
if L then
	L.engage_yell = "Ah, ja! Bietet Eure Seelen dar, Sterbliche! Dies sind die Hallen der Toten!"

	L.phase_lightning_trigger = "Oh, großer Geist! Gewährt mir die Macht der Erde!"
	L.phase_flame_trigger = "Oh, Erhabener! Durch mich sollt Ihr das Fleisch von den Knochen schmelzen!"
	L.phase_arcane_trigger =  "Oh, Weiser der Zeitalter! Vertraut mir Euer arkanes Wissen an!"
	L.phase_shadow_trigger = "Große Seele vergangener Helden! Gewährt mir Euren Schild!" -- this is the right one :o

	L.phase_lightning = "Blitzphase!"
	L.phase_flame = "Feuerphase!"
	L.phase_arcane = "Arkanphase!"
	L.phase_shadow = "(Heroisch) Schattenphase!"

	L.shroud_message = "%2$s wirkt Wolke der Umkehrung auf %1$s"
	L.barrier_message = "Nullifikationsbarriere AN!"

	-- Tanks
	L.tank = "Tankwarnungen"
	L.tank_desc = "Nur für Tanks. Zählt die Stapel von Blitzpeitsche, Flammender Speer, Arkanschock und Schattenbrand (heroisch)."
	L.lash_message = "%2$dx Blitzpeitsche auf %1$s"
	L.spear_message = "%2$dx Flammender Speer auf %1$s"
	L.shock_message = "%2$dx Arkanschock auf %1$s"
	L.burn_message = "%2$dx Schattenbrand auf %1$s"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "deDE")
if L then
	L.engage_yell = "Jetzt is' Sterbenszeit!"

	L.totem = "Totem"
	L.frenzy = "Raserei bald!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "deDE")
if L then
	L.shield_removed = "Schild entfernt!"
end

L = BigWigs:NewBossLocale("Elegon", "deDE")
if L then
	L.last_phase = "Letzte Phase"
	L.overcharged_total_annihilation = "Du hast (%d) %s, werde deinen Debuff los!"

	L.floor = "Floor Despawn"
	L.floor_desc = "Warnings for when the floor is about to despawn."
	L.floor_message = "The floor is falling!!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "deDE")
if L then
	L.enable_zone = "Forge of the Endless"

	L.rage_trigger = "Der Zorn des Kaisers schallt durch die Berge."
	L.strength_trigger = "Die Stärke des Kaisers erscheint in den Erkern!"
	L.courage_trigger = "Der Mut des Kaisers erscheint in den Erkern!"
	L.bosses_trigger = "In den riesigen Erkern erscheinen zwei Titanenkonstrukte!"

	L.arc_desc = "|cFFFF0000Diese Warnung wird nur für den Boss angezeigt, welchen du anvisierst.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

