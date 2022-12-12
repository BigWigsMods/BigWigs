local L = BigWigs:NewBossLocale("Eranog", "deDE")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "Fixieren-Symbol an gegnerischen Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden rasenden Tarasek an.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.molten_cleave = "Frontal"
	L.incinerating_roar = "Brüllen"
	L.molten_spikes = "Stacheln"
	L.collapsing_army = "Armee"
	L.greater_flamerift = "Mythisches Add"
	L.leaping_flames = "Flammen"
end

L = BigWigs:NewBossLocale("Terros", "deDE")
if L then
	L.rock_blast = "Soak"
	L.resonating_annihilation = "Vernichtung"
	L.awakened_earth = "Säule"
	L.shattering_impact = "Einschlag"
	L.concussive_slam = "Tank Linie"
	L.infused_fallout = "Staub"
end

L = BigWigs:NewBossLocale("The Primal Council", "deDE")
if L then
	L.primal_blizzard = "Blizzard" -- Primal Blizzard
	L.earthen_pillars = "Säulen" -- Earthen Pillars
	L.meteor_axes = "Äxte" -- Meteor Axes
	L.meteor_axe = "Axt" -- Singular
	L.meteor_axes_melee = "Nahkampf Axt"
	L.meteor_axes_ranged = "Fernkampf Axt"
	L.conductive_marks = "Zeichen" -- Conductive Marks
	L.conductive_mark = "Zeichen" -- Singular

	L.custom_off_chain_lightning = "Kettenblitzschlag ist standardmäßig deaktiviert, diese Option zum Aktivieren einschalten."

	L.custom_on_stop_timers = "Fähigkeitenleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Fähigkeiten, welche immer angezeigt werden: Leitfähiges Zeichen"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "deDE")
if L then
	L.ascend = "Aufsteigen"
	L.ascend_desc = "Sennarth steigt vom Raum zur Spitze des Eises auf."
	L.chilling_blast = "Verteilen"
	L.freezing_breath = "Add Atem"
	L.webs = "Spinnweben"
	L.web = "Spinnwebe"
	L.gossamer_burst = "Heranziehen"
	L.repelling_burst = "Zurückstoßen"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "deDE")
if L then
	L.marks_on_me = "%d Zeichen" -- {Stacks} Conductive Mark on the player

	L.conductive_marks = "Zeichen"
	L.conductive_mark = "Zeichen"
	L.raging_burst = "Neue Tornados"
	L.cyclone = "Heranziehen"
	L.crosswinds = "Bewegende Tornados"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "deDE")
if L then
	-- -- Types
	L.damage = "Schadensfähigkeiten"
	L.damage_desc = "Zeigt Timer für Schadensfähigkeiten an (Magmaexplosion, Beißende Kälte, Einhüllende Erde, Blitzeinschlag) wenn nicht bekannt ist, an welchem Altar der Boss ist."
	L.damage_bartext = "%s [Schaden]" -- {Spell} [Dmg]

	L.avoid = "Ausweich-Fähigkeiten"
	L.avoid_desc = "Zeigt Timer für Ausweich-Fähigkeiten an (Geschmolzene Eruption, Eisiger Strom, Ausbrechender Felsboden, Schockausbruch) wenn nicht bekannt ist, an welchem Altar der Boss ist."
	L.avoid_bartext = "%s [Ausweichen]" -- {Spell} [Avoid]

	L.ultimate = "Ultimative Fähigkeiten"
	L.ultimate_desc = "Zeigt Timer für ultimative Fähigkeiten an (Sengendes Gemetzel, Absoluter Nullpunkt, Seismischer Riss, Donnerschlag) wenn nicht bekannt ist, an welchem Altar der Boss ist."
	L.ultimate_bartext = "%s [Ultimativ]" -- {Spell} [Ult]

	-- -- Fire
	L.magma_burst = "Pfützen"
	L.molten_rupture = "Wellen"
	L.searing_carnage = "Tanzen"

	-- -- Frost
	L.biting_chill = "Kälte DoT"
	L.frigid_torrent = "Kugeln"
	L.absolute_zero = "Soaks"
	L.absolute_zero_melee = "Nahkampf Soak"
	L.absolute_zero_ranged = "Fernkampf Soak"

	-- -- Earth
	L.enveloping_earth = "Heilung absorbiert"
	L.erupting_bedrock = "Beben"

	-- -- Storm
	L.lightning_crash = "Blitze"
	L.thundering_strike = "Soaks"

	-- -- General
	L.primal_attunement = "Soft Enrage"

	-- -- Stage 2
	L.violent_upheaval = "Säulen"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "deDE")
if L then
	L.eggs_remaining = "%d Eier verbleiben!"
	L.broodkeepers_bond = "Eier verbleiben"
	L.greatstaff_of_the_broodkeeper = "Großstab"
	L.greatstaffs_wrath = "Strahl"
	L.clutchwatchers_rage = "Wut (Gelegehüterin)"
	L.rapid_incubation = "Eier erfüllen"
	L.icy_shroud = "Heilung absorbiert"
	L.broodkeepers_fury = "Wut (Bruthüterin)"
	L.frozen_shroud = "Bewegungsunfähig / Absorbtion"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "deDE")
if L then

end
