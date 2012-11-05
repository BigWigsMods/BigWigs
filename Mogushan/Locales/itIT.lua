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
	L.phase_arcane_trigger = "Oh, saggio delle ere! Concedimi la tua saggezza arcana!"
	L.phase_shadow_trigger = "Grande spirito dei campioni del passato! concedimi il tuo scudo!"

	L.phase_lightning = "Fase Fulmini!"
	L.phase_flame = "Fase Fuoco!"
	L.phase_arcane = "Fase Arcana!"
	L.phase_shadow = "Fase Ombra!"

	L.phase_message = "New phase soon!"
	L.shroud_message = "%2$s attiva Manto su %1$s"
	L.barrier_message = "Barriera Attiva!"
	L.barrier_cooldown = "Barrier cooldown"
	L.can_interrupt_epicenter = "%s can interrupt %s"
	L.epicenter_interrupted = "%s interrupted!"

	-- Tanks
	L.tank = "Tank Alerts"
	L.tank_desc = "Count the stacks of Lightning Lash, Flaming Spear, Arcane Shock & Shadowburn (Heroic)."
	L.lash_message = "%2$dx Lash on %1$s"
	L.spear_message = "%2$dx Spear on %1$s"
	L.shock_message = "%2$dx Shock on %1$s"
	L.burn_message = "%2$dx Burn on %1$s"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "itIT")
if L then
	L.engage_yell = "È giunta l'ora di schiattare!" -- From ChatLog

	L.totem = "Totem (%d)"
	L.shadowy_message = "Attack (%d)"
	L.banish_message = "Tank Banished"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "itIT")
if L then
	L.shield_removed = "Scudo Rimosso! (%s)"
end

L = BigWigs:NewBossLocale("Elegon", "itIT")
if L then
	L.engage_yell = "Entering defensive mode.  Disabling output failsafes."

	L.floor = "Scomparsa del Pavimento"
	L.floor_desc = "Avviso Speciale prima che il vortice svanisca."
	L.floor_message = "Il Pavimento sta Scomparendo!"

	L.adds = "Adds"
	L.adds_desc = "Warnings for when a Celestial Protector is about to spawn."
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

	L.target_only = "|cFFFF0000Questo messaggio verra' visualizzato solo per il boss che stai targettando.|r "
	L.combo_message = "%s: Combo in ARRIVO!"
end

