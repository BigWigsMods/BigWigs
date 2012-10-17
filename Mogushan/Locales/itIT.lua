local L = BigWigs:NewBossLocale("The Stone Guard", "itIT")
if not L then return end
if L then
	L.petrifications = "Pietrificazione"
	L.petrifications_desc = "Avvertimento quando il boss comincia la pietrificazione"
	L.overload = "Sovraccarico"
	L.overload_desc = "Avviso per tutti i tipi di Sovraccarico."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "itIT")
if L then
	L.engage_yell = "Offrite le vostre anime, mortali! Queste sono le sale dei morti!"

	L.phase_lightning_trigger = "Oh, grande spirito... concedimi il potere della terra!"
	L.phase_flame_trigger = "Oh, potente! Attraverso me scioglierai la carne dalle ossa!"
	L.phase_arcane_trigger =  "Oh, saggio delle ere! Concedimi la tua saggezza arcana!"
	L.phase_shadow_trigger = "Grande spirito dei campioni del passato! concedimi il tuo scudo!"

	L.shroud_message = "%2$s attiva Manto su %1$s"
	L.barrier_message = "Barriera Attiva!"

	L.phase_lightning = "Fase Fulmini!"
	L.phase_flame = "Fase Fuoco!"
	L.phase_arcane = "Fase Arcana!"
	L.phase_shadow = "Fase Ombra!"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "itIT")
if L then
	L.engage_yell = "È giunta l'ora di schiattare!" -- From ChatLog

	L.totem = "Totem"
	L.frenzy = "Frenesia Imminente!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "itIT")
if L then
	L.shield_removed = "Scudo Rimosso!"
end

L = BigWigs:NewBossLocale("Elegon", "itIT")
if L then
	L.floor_despawn = "Il Suolo scompare!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "itIT")
if L then
	L.enable_zone = "Forge of the Endless"

	L.rage_trigger = "Rabbia dell'Imperatore echeggia tra le colline."
	L.strength_trigger = "Forza dell'Imperatore appare nelle alcove!"
	L.courage_trigger = "Coraggio dell'Imperatore appare nelle alcove!"
	L.bosses_trigger = "Due costrutti titanici appaiono nelle grandi alcove!"
end

