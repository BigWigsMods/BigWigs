local L = BigWigs:NewBossLocale("The Stone Guard", "itIT")
if not L then return end
if L then
	L.petrifications = "Pietrificazione"
	L.petrifications_desc = "Avvisa quando il boss comincia la pietrificazione"

	L.overload = "Sovraccarico"
	L.overload_desc = "Avviso per tutti i tipi di Sovraccarico."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "itIT")
if L then
	L.engage_yell = "Offrite le vostre anime, mortali! Queste sono le sale dei morti!"

	L.phase_lightning_trigger = "Oh, grande spirito... concedimi il potere della terra!"
	L.phase_flame_trigger = "Oh, potente! Attraverso me scioglierai la carne dalle ossa!"
	L.phase_arcane_trigger = "Oh, saggio delle ere! Concedimi la tua saggezza arcana!"
	L.phase_shadow_trigger = "Grande spirito dei campioni del passato! concedimi il tuo scudo!"

	L.phase_lightning = "Fase Fulmini!"
	L.phase_flame = "Fase Fuoco!"
	L.phase_arcane = "Fase Arcana!"
	L.phase_shadow = "Fase Ombra! (Eroico)"

	L.phase_message = "Nuova fase tra poco!"
	L.shroud_message = "Manto"
	L.shroud_can_interrupt = "%s può interrompere %s!"
	L.barrier_message = "Barriera ATTIVA!"
	L.barrier_cooldown = "Recupero Barriera"

	-- Tanks
	L.tank = "Messaggio solo per Difensori."
	L.tank_desc = "Conta gli stacks di Sferzata Fulminante, Lancia Fiammeggiante, Folgore Arcana & Combustione dell'Ombra (Eroico)."
	L.lash_message = "Sferzata"
	L.spear_message = "Lancia"
	L.shock_message = "Folgore"
	L.burn_message = "Combustione"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "itIT")
if L then
	L.engage_yell = "È giunta l'ora di schiattare!" -- From ChatLog

	L.totem_message = "Totem (%d)"
	L.shadowy_message = "Attacco (%d)"
	L.banish_message = "Difensore Esiliato"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "itIT")
if L then
	L.bosses = "Imperatori"
	L.bosses_desc = "Avvisa quando uno dei Boss diventa attivo."

	L.shield_removed = "Scudo Rimosso! (%s)"
	L.casting_shields = "Lancio Scudo"
	L.casting_shields_desc = "Avvisa quando viene lanciato lo Scudo per tutti gli Imperatori."
end

L = BigWigs:NewBossLocale("Elegon", "itIT")
if L then
	L.engage_yell = "Attivazione modalità difensiva. Disattivazione protezione in uscita."

	L.last_phase = "Ultima Fase"
	L.overcharged_total_annihilation = "Sovraccaricato %d! Un pò troppo?"

	L.floor = "Scomparsa del Pavimento"
	L.floor_desc = "Avviso Speciale prima che il Vortice svanisca."
	L.floor_message = "Il Pavimento sta Scomparendo!"

	L.adds = "Adds"
	L.adds_desc = "Avvisa quando sta per apparire un Protettore Celestiale."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "itIT")
if L then
	L.enable_zone = "Forgia dell'Eternità"

	L.heroic_start_trigger = "Destroying the pipes" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!  MANCA ANCORA QUESTO
	L.normal_start_trigger = " La macchina si mette in moto" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "La Rabbia dell'Imperatore risuona tra le colline."
	L.strength_trigger = "La Forza dell'Imperatore appare nelle volte!"
	L.courage_trigger = "Il Coraggio dell'Imperatore appare nelle volte!"
	L.bosses_trigger = "Due Costrutti Titanici appaiono nelle alcove più grandi!"
	L.gas_trigger = "La Macchina Antica dei Mogu si rompe!"
	L.gas_overdrive_trigger = "La Macchina Antica dei Mogu va in sovraccarico!"

	L.target_only = "|cFFFF0000Questo messaggio verrà visualizzato solo per il boss che stai selezionando.|r "
	L.combo_message = "%s: Combo IN ARRIVO!"
end

