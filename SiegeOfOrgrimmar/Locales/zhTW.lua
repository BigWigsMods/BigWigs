local L = BigWigs:NewBossLocale("Immerseus", "zhTW")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("The Fallen Protectors", "zhTW")
if L then
	L.defile = "Defiled Ground cast"

	L.custom_off_bane_marks = "Shadow Word: Bane marker"
	L.custom_off_bane_marks_desc = "To help dispelling assignments, mark the people who have Shadow Word: Bane on them with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."

	L.no_meditative_field = "NO Meditative Field!"

	L.intermission = "Desperate Measures"
	L.intermission_desc = "Warnings for when you are getting close to any of the bosses using Desperate Measures"
end

L = BigWigs:NewBossLocale("Norushen", "zhTW")
if L then
	L.pre_pull = "Pre pull"
	L.pre_pull_desc = "Timer bar for the RP before the boss engage"
	L.pre_pull_trigger = "Very well, I will create a field to keep your corruption quarantined."

	L.big_adds = "Big adds"
	L.big_adds_desc = "Warning for killing big adds inside/outside"
	L.big_add = "Big add! (%d)"
	L.big_add_killed = "Big add killed! (%d)"
end

L = BigWigs:NewBossLocale("Sha of Pride", "zhTW")
if L then
	L.custom_off_titan_mark = "Gift of the Titans marker"
	L.custom_off_titan_mark_desc = "To help spotting others with Gift of the Titans, mark the people who have Gift of the Titans on them with %s%s%s%s%s%s%s%s (players with Aura of Pride are not marked), requires promoted or leader."

	L.projection_message = "Go to |cFF00FF00GREEN|r arrow!"
	L.projection_explosion = "Projection explosion"

	L.big_add_bar = "Big add"
	L.big_add_spawning = "Big add spawning!"
	L.small_adds = "Small adds"
end

L = BigWigs:NewBossLocale("Galakras", "zhTW")
if L then
	L.demolisher = "Demolisher"
	L.demolisher_desc = "Timers for when the Kor'kron Demolishers enter the fight"
	L.towers = "Towers"
	L.towers_desc = "Warnings for when the towers get breached"
	L.south_tower_trigger = "The door barring the South Tower has been breached!"
	L.south_tower = "South tower"
	L.north_tower_trigger = "The door barring the North Tower has been breached!"
	L.north_tower = "North tower"

	L.custom_off_shaman_marker = "Shaman marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "zhTW")
if L then
	L.blobs = "Blobs"

	L.custom_off_mist_marks = "Toxic Mist"
	L.custom_off_mist_marks_desc = "To help healing assignments, mark the people who have Toxic Mist on them with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."
end

L = BigWigs:NewBossLocale("General Nazgrim", "zhTW")
if L then
	L.custom_off_bonecracker_marks = "Bonecracker"
	L.custom_off_bonecracker_marks_desc = "To help healing assignments, mark the people who have Bonecracker on them with %s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."

	L.stance_bar = "%s (NOW: %s)"
	L.battle = "Battle"
	L.berserker = "Berserker"
	L.defensive = "Defensive"

	L.adds_trigger1 = "Defend the gate!"
	L.adds_trigger2 = "Rally the forces!"
	L.adds_trigger3 = "Next squad, to the front!"
	L.adds_trigger4 = "Warriors, on the double!"
	L.adds_trigger5 = "Kor'kron, at my side!"
	L.adds_trigger_extra_wave = "All Kor'kron... under my command... kill them... NOW"
	L.extra_adds = "Extra adds"

	L.chain_heal_message = "Your focus is casting Chain Heal!"

	L.arcane_shock_message = "Your focus is casting Arcane Shock!"

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "zhTW")
if L then
	L.custom_off_energy_marks = "Displaced Energy marker"
	L.custom_off_energy_marks_desc = "To help dispelling assignments, mark the people who have Displaced Energy on them with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "zhTW")
if L then
	L.enable_zone = "Artifact Storage"
	L.matter_scramble_explosion = "Matter Scramble explosion" -- shorten maybe?

	L.custom_off_mark_brewmaster = "Brewmaster marker"
	L.custom_off_mark_brewmaster_desc = "Mark the Ancient Brewmaster Spirit with %s"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "zhTW")
if L then
	L.tank_debuffs = "Tank debuffs"
	L.tank_debuffs_desc = "Warnings for the different types of tank debuffs associated with Fearsome Roar"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "zhTW")
if L then
	L.shredder_engage_trigger = "An Automated Shredder draws near!"
	L.laser_on_you = "Laser on you PEW PEW!"
	L.laser_say = "Laser PEW PEW!"

	L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."
	L.assembly_line_message = "Unfinished weapons (%d)"

	L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "zhTW")
if L then
	L.one = "Iyyokuk selects: One!"
	L.two = "Iyyokuk selects: Two!"
	L.three = "Iyyokuk selects: Three!"
	L.four = "Iyyokuk selects: Four!"
	L.five = "Iyyokuk selects: Five!"
	L.edge_message = "You're an edge"
	L.custom_off_edge_marks = "Edge marks"
	L.custom_off_edge_marks_desc = "Mark the players who will be edges based on the calculations %s%s%s%s%s%s, requires promoted or leader."
	L.injection_over_soon = "Injection over soon (%s)!"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "zhTW")
if L then
	L.mind_control = "Mind Control"

	L.chain_heal_desc = "Heals a friendly target for 40% of their max health, chaining to nearby friendly targets."
	L.chain_heal_message = "Your focus is casting Chain Heal!"
	L.chain_heal_bar = "Focus: Chain Heal"

	L.farseer_trigger = "Farseers, mend our wounds!"
	L.custom_off_shaman_marker = "Farseer marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Farseer Wolf Rider with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "zhTW")
if L then

end

