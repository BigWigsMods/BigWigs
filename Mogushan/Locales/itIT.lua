if not GetNumGroupMembers then return end
local L = BigWigs:NewBossLocale("The Stone Guard", "itIT")
if not L then return end
if L then
	L.petrifications = "Pietrificazione"
	L.petrifications_desc = "Avvertimento quando il boss comincia la pietrificazione"
	L.overload = "Sovraccarico" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "Avviso per tutti i tipi di Sovraccarico."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "itIT")
if L then
	L.phases = "Fasi"
	L.phases_desc = "Avvertimento per il cambiamento di Fase"

	L.phase_flame_trigger = "Oh mio Signore! Tramite di me si sciogliera' la vostra carne dalle Ossa!"
	L.phase_lightning_trigger = "Oh grande spirito! Dammi la forza della Terra!"
	L.phase_arcane_trigger =  "Oh saga delle ere! Innervami col tuo potere Arcano!"
	L.phase_shadow_trigger = "Grande anima dei Campioni del passato! Cedimi il tuo scudo!"

	L.phase_flame = "Fase Fuoco!"
	L.phase_lightning = "Fase Fulmini!"
	L.phase_arcane = "Fase Arcana!"
	L.phase_shadow = "Fase Ombra!"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "itIT")
if L then
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
	L.rage_trigger = "La rabbia dell'Imperatore echeggia tra le colline."
	L.strength_trigger = "La Forza dell'Imperatore appare dalle Alcove!"
	L.courage_trigger = "Il Coraggio dell'Imperatore appare dalle Alcove!"
	L.bosses_trigger = "Due Costrutti Titanici appaiono dalle grandi Alcove!"
end

