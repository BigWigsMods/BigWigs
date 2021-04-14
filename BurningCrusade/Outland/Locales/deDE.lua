local L = BigWigs:NewBossLocale("Doomwalker", "deDE")
if not L then return end
if L then
	L.name = "Verdammniswandler"

	L.engage_trigger = "Fahren Sie nicht fort. Sie werden eliminiert." --check
	L.engage_message = "Verdammniswandler angegriffen, Erdbeben in ~30sek!"

	L.overrun_desc = "Warnt, wenn Verdammniswandler \195\156berrennen benutzt."

	L.earthquake_desc = "Warnt wenn Verdammniswandler Erdbeben benutzt."
end

L = BigWigs:NewBossLocale("Doom Lord Kazzak", "deDE")
if L then
	L.name = "Verdammnislord Kazzak"

	L.engage_trigger1 = "Die Legion wird alles erobern!"
	L.engage_trigger2 = "Alle Sterblichen werden zu Grunde gehen!"

	L.enrage_warning1 = "%s angegriffen - Enrage in ~60sek"
	L.enrage_warning2 = "Enrage bald!"
	L.enrage_message = "Enrage!"
	L.enrage_finished = "Enrage vorbei - Nüchster in ~60sek"
	L.enrage_bar = "~Enrage"
	L.enraged_bar = "Enrage!"
end

L = BigWigs:NewBossLocale("Gruul the Dragonkiller", "deDE")
if L then
	L.engage_trigger = "Kommt und sterbt."
	L.engage_message = "%s gepullt!"

	L.grow = "Wachstum" 
	L.grow_desc = "Warnt wenn Gruul Wachstum bekommt" 
	L.grow_message = "Wachstum: (%d)"
	L.grow_bar = "Wachstum (%d)"

	L.grasp = "Griff des Gronnlords"
	L.grasp_desc = "Griff des Gronnlords warnung und Zeitanzeige" 
	L.grasp_message = "Erde ersch\195\188tert - Griff kommt" 
	L.grasp_warning = "Erde ersch\195\188tern bald!"

	L.silence_message = "AOE Stille"
	L.silence_warning = "AOE Stille bald!"
	L.silence_bar = "~Stille Cooldown"
end

L = BigWigs:NewBossLocale("High King Maulgar", "deDE")
if L then
	L.engage_trigger = "Die Gronn sind die wahre Macht der Scherbenwelt!"

	L.heal_message = "Blindauge der Seher wirkt Gebet der Heilung!"
	L.heal_bar = "Heilung"

	L.shield_message = "Schild auf Blindauge!"

	L.spellshield_message = "Zauberschild auf Krosh!"

	L.summon_message = "Teufelsj\195\164ger wurde beschworen!"

	L.whirlwind_message = "Maulgar - Wirbelwind f\195\188r 15sek!"
	L.whirlwind_warning = "Maulgar angegriffen - Wirbelwind in ~60sek!"

	L.mage = "Krosh Feuerhand (Magier)"
	L.warlock = "Olm der Beschwörer (Hexenmeister)"
	L.priest = "Blindauge der Seher (Priester)"
end

L = BigWigs:NewBossLocale("Magtheridon", "deDE")
if L then
	L.escape = "Ausbruch"
	L.escape_desc = "Countdown bis Magtheridon ausbricht"
	L.escape_trigger1 = "Die Fesseln von %%s werden schw\195\164cher!"
	L.escape_trigger2 = " Ich... bin... frei!"
	L.escape_warning1 = "%s angegriffen - Ausbruch in 2min!"
	L.escape_warning2 = "Ausbruch in 1min!"
	L.escape_warning3 = "Ausbruch in 30sec!"
	L.escape_warning4 = "Ausbruch in 10sec!"
	L.escape_warning5 = "Ausbruch in 3sec!"
	L.escape_bar = "Frei..."
	L.escape_message = "%s frei!"

	L.abyssal = "Brennender Schlund"
	L.abyssal_desc = "Warnt, wenn ein Brennender Schlund gespawned wird"
	L.abyssal_message = "Brennender Schlund gespawned (%d)"

	L.heal = "Heilung"
	L.heal_desc = "Warnt, wenn ein Kanalisierer anf\195\164ngt zu heilen"
	L.heal_message = "Heilung!"

	L.banish = "Verbannung"
	L.banish_desc = "Warnt, wenn ihr Magtheridon verbannt"
	L.banish_message = "Verbannt f\195\188r ~10sec"
	L.banish_over_message = "Verbannen verblasst!"
	L.banish_bar = "<Verbannt>"

	L.exhaust_desc = "Timer f\195\188r Gedankenersch\195\182pfung"
	L.exhaust_bar = "[%s] ersch\195\182pft"

	L.debris_trigger = "Lasst die Mauern dieses Kerkers erzittern"
	L.debris_message = "30% - Trümmer steht bevor!"
end

