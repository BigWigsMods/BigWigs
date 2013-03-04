local L = BigWigs:NewBossLocale("The Stone Guard", "deDE")
if not L then return end
if L then
	L.petrifications = "Versteinerung"
	L.petrifications_desc = "Warnung, wenn einer der Bosse Versteinerung wirkt."

	L.overload = "Überladung"
	L.overload_desc = "Warnungen für alle Arten von Überladungen."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "deDE")
if L then
	L.engage_yell = "Ah, ja! Bietet Eure Seelen dar, Sterbliche! Dies sind die Hallen der Toten!"

	L.phase_lightning_trigger = "Oh, großer Geist! Gewährt mir die Macht der Erde!"
	L.phase_flame_trigger = "Oh, Erhabener! Durch mich sollt Ihr das Fleisch von den Knochen schmelzen!"
	L.phase_arcane_trigger = "Oh, Weiser der Zeitalter! Vertraut mir Euer arkanes Wissen an!"
	L.phase_shadow_trigger = "Große Seele vergangener Helden! Gewährt mir Euren Schild!" -- this is the right one :o

	L.phase_lightning = "Blitzphase!"
	L.phase_flame = "Feuerphase!"
	L.phase_arcane = "Arkanphase!"
	L.phase_shadow = "(Heroisch) Schattenphase!"

	L.phase_message = "Neue Phase bald!"
	L.shroud_message = "Wolke der Umkehrung"
	L.shroud_can_interrupt = "%s kann %s unterbrechen!"
	L.barrier_message = "Nullifikationsbarriere AN!"
	L.barrier_cooldown = "Barriere bereit"

	-- Tanks
	L.tank = "Tankwarnungen"
	L.tank_desc = "Zählt die Stapel von Blitzpeitsche, Flammender Speer, Arkanschock und Schattenbrand (heroisch)."
	L.lash_message = "Blitzpeitsche"
	L.spear_message = "Flammender Speer"
	L.shock_message = "Arkanschock"
	L.burn_message = "Schattenbrand"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "deDE")
if L then
	L.engage_yell = "Jetzt is' Sterbenszeit!"

	L.totem_message = "Totem (%d)"
	L.shadowy_message = "Angriff (%d)"
	L.banish_message = "Tank verbannt"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "deDE")
if L then
	L.bosses = "Bosse"
	L.bosses_desc = "Warnungen für die Aktivierung der Bosse."

	L.shield_removed = "Schild entfernt! (%s)"
	L.casting_shields = "Schilde"
	L.casting_shields_desc = "Warnung für alle Bosse, wenn Schilde aktiviert werden."
end

L = BigWigs:NewBossLocale("Elegon", "deDE")
if L then
	L.engage_yell = "Aktiviere Verteidigungsmodus. Notausschaltung deaktiviert."

	L.last_phase = "Letzte Phase"
	L.overcharged_total_annihilation = "%dx Überladen! Etwas viel?"

	L.floor = "Boden verschwindet"
	L.floor_desc = "Warnungen, wenn der Boden verschwindet."
	L.floor_message = "Der Boden verschwindet!"

	L.adds = "Himmlische Beschützer"
	L.adds_desc = "Warnungen kurz bevor ein Himmlischer Beschützer erscheint."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "deDE")
if L then
	L.enable_zone = "Schmiede des Unendlichen"

	L.heroic_start_trigger = "Durch die Zerstörung der Rohre"
	L.normal_start_trigger = "Die Maschine brummt und erwacht zu Leben! Geht zur unteren Ebene!"

	L.rage_trigger = "Der Zorn des Kaisers schallt durch die Berge."
	L.strength_trigger = "Die Stärke des Kaisers erscheint in den Erkern!"
	L.courage_trigger = "Der Mut des Kaisers erscheint in den Erkern!"
	L.bosses_trigger = "In den riesigen Erkern erscheinen zwei Titanenkonstrukte!"
	L.gas_trigger = "Die uralte Mogumaschine bricht zusammen!"
	L.gas_overdrive_trigger = "Die uralte Mogumaschine schaltet in den Schnellgang!"

	L.target_only = "|cFFFF0000Diese Warnung wird nur für den Boss angezeigt, welchen du anvisierst.|r "
	L.combo_message = "%s: Combo bald!"
end

