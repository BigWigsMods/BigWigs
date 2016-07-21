local L = BigWigs:NewBossLocale("Hellfire Assault", "deDE")
if not L then return end
if L then
L.left = "Links: %s"
L.middle = "Mitte: %s"
L.right = "Rechts: %s"

end

L = BigWigs:NewBossLocale("Kilrogg Deadeye", "deDE")
if L then
L.add_warnings = "Füge Erscheinen-Warnungen hinzu"

end

L = BigWigs:NewBossLocale("Gorefiend", "deDE")
if L then
L.fate_root_you = "Geteiltes Schicksal – Du bist verwurzelt!"
L.fate_you = "Geteiltes Schicksal auf DIR! Wurzel auf %s"

end

L = BigWigs:NewBossLocale("Shadow-Lord Iskar", "deDE")
if L then
L.bindings_removed = "Bindungen entfernt (%d/3)"
L.custom_off_binding_marker = "Dunkle Bindungen markieren"
L.custom_off_binding_marker_desc = [=[Markiert die Dunklen Bindungen mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, benötigt Leiter oder Assistent.
|cFFFF0000Nur eine Person im Schlachtzug sollte diese Option aktiviert haben, um Markierungskonflikte zu verhindern.|r]=]
L.custom_off_wind_marker = "Imaginäre Winde markieren"
L.custom_off_wind_marker_desc = [=[Markiert Imaginäre Winde mit {rt1}{rt2}{rt3}{rt4}{rt5}, benötigt Leiter oder Assistent.
|cFFFF0000Nur eine Person im Schlachtzug sollte diese Option aktiviert haben, um Markierungskonflikte zu verhindern.|r]=]

end

L = BigWigs:NewBossLocale("Socrethar the Eternal", "deDE")
if L then
L.dominator_desc = "Warnt, wenn der Dominator der Sargerei erscheint."
L.portals = "Portale bewegen sich"
L.portals_desc = "Timer, der anzeigt, wann die Portale in Phase 2 die Position ändern."
L.portals_msg = "Die Portale haben sich bewegt!"

end

L = BigWigs:NewBossLocale("Fel Lord Zakuun", "deDE")
if L then
L.custom_off_seed_marker = "Saat der Zerstörung markieren"
L.custom_off_seed_marker_desc = "Markiert die Ziele von Saat der Zerstörung mit {rt1}{rt2}{rt3}{rt4}{rt5}, benötigt Leiter oder Assistent."
L.seed = "Saat"
L.tank_proximity = "Näheanzeige für Tanks"
L.tank_proximity_desc = "Öffnet eine Näheanzeige, die andere Tanks im Abstand von maximal 5 Metern anzeigt, die Anzeige hilft dir mit den Fähigkeiten \"Grobschlächtig\" und \"Schwer bewaffnet\" umzugehen."

end

L = BigWigs:NewBossLocale("Tyrant Velhari", "deDE")
if L then
L.font_removed_soon = "Dein Quell verschwindet bald!"

end

L = BigWigs:NewBossLocale("Mannoroth", "deDE")
if L then
L["182212"] = "Höllenbestienportal geschlossen!"
L["185147"] = "Verdammnislordportal geschlossen!"
L["185175"] = "Wichtelportal geschlossen!"
L.custom_off_doom_marker = "Mal der Verdammnis markieren"
L.custom_off_doom_marker_desc = "Auf dem Schwierigkeitsgrad Mythisch, markiert die Ziele von Mal der Verdammnis mit {rt1}{rt2}{rt3}, benötigt Leiter oder Assistent."
L.custom_off_gaze_marker = "Mannoroths Blick markieren"
L.custom_off_gaze_marker_desc = "Markiert die Ziele von Mannoroths Blick mit {rt1}{rt2}{rt3}, benötigt Leiter oder Assistent."
L.custom_off_wrath_marker = "Gul'dans Zorn markieren"
L.custom_off_wrath_marker_desc = "Markiert die Ziele von Gul'dans Zorn mit {rt8}{rt7}{rt6}{rt5}{rt4}, benötigt Leiter oder Assistent."
L.felseeker_message = "%s (%d) %dm"
L.gaze = "Blick (%d)"

end

L = BigWigs:NewBossLocale("Archimonde", "deDE")
if L then
L.chaos_bar = "%s -> %s"
L.chaos_from = "%s von %s"
L.chaos_helper_message = "Deine Chaos-Position: %d"
L.chaos_to = "%s auf %s"
L.custom_off_chaos_helper = "Gestiftetes-Chaos-Helfer"
L.custom_off_chaos_helper_desc = "Nur für den Schwierigkeitsgrad \"Mythisch\". Diese Funktion sagt dir welche Chaos-Nummer du bist, in dem es eine normale Nachricht anzeigt und es im Sagen-Channel ausgibt. Je nachdem, welche Taktik ihr verwendet, kann diese Funktion hilfreich oder nicht hilfreich sein"
L.custom_off_infernal_marker = "Höllische Verdammnisbringer markieren"
L.custom_off_infernal_marker_desc = "Markiert die höllischen Verdammnisbringer, die vom Chaosregen erzeugt werden, mit {rt1}{rt2}{rt3}{rt4}{rt5}, benötigt Leiter oder Assistent."
L.custom_off_legion_marker = "Mal der Legion markieren"
L.custom_off_legion_marker_desc = "Markiert die Ziele von Mal der Legion mit {rt1}{rt2}{rt3}{rt4}, benötigt Leiter oder Assistent."
L.custom_off_torment_marker = "Gefesselte Pein markieren"
L.custom_off_torment_marker_desc = "Markiert die Ziele von Gefesselte Pein mit {rt1}{rt2}{rt3}, benötigt Leiter oder Assistent."
L.infernal_count = "%s (%d/%d)"
L.markofthelegion_self = "Mal der Legion auf dir"
L.markofthelegion_self_bar = "Du explodierst!"
L.markofthelegion_self_desc = "Spezieller Countdown, wenn das Mal der Legion auf dir ist."
L.torment_removed = "Pein entfernt (%d/%d)"

end

L = BigWigs:NewBossLocale("Hellfire Citadel Trash", "deDE")
if L then
L.anetheron = "Anetheron"
L.azgalor = "Azgalor"
L.bloodthirster = "Geifernder Blutdürster"
L.burster = "Schattenberster"
L.daggorath = "Dag'gorath"
L.darkcaster = "Blutender Dunkelzauberer"
L.eloah = "Binder Eloah"
L.enkindler = "Feurige Zündlerin"
L.faithbreaker = "Glaubensbrecher der Eredar"
L.graggra = "Graggra"
L.kazrogal = "Kaz'rogal"
L.kuroh = "Adjunkt Kuroh"
L.orb = "Sphäre der Zerstörung"
L.peacekeeper = "Friedensbewahrerkonstrukt"
L.talonpriest = "Verderbter Krallenpriester"
L.weaponlord = "Waffenlord Mehlkhior"

end

