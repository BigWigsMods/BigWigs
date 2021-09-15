local L = BigWigs:NewBossLocale("Void Reaver", "esES") or BigWigs:NewBossLocale("Void Reaver", "esMX")
if not L then return end
if L then
	L.engage_trigger = "¡Alerta! Estáis marcados para exterminación."
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "esES") or BigWigs:NewBossLocale("High Astromancer Solarian", "esMX")
if L then
	L.engage_trigger = "¡Tal anu'men no sin'dorei!"

	L.phase = "Fases"
	L.phase_desc = "Avisar sobre cambios de fase."
	L.phase1_message = "Fase 1 - División en ~50seg"
	L.phase2_warning = "¡Fase 2 en breve!"
	L.phase2_trigger = "^Me FUNDO"
	L.phase2_message = "20% - Fase 2"

	L.wrath_other = "Cólera"

	L.split = "División"
	L.split_desc = "Avisar sobre la división y aparición de añadidos."
	L.split_trigger1 = "¡Aplastaré vuestros delirios de grandeza!"
	L.split_trigger2 = "¡Os superamos con creces!"
	L.split_bar = "~División"
	L.split_warning = "División en ~7 seg"

	L.agent_warning = "¡División! - Agentes en 6 seg"
	L.agent_bar = "Agentes"
	L.priest_warning = "Sacerdotes/Solarian en 3 seg"
	L.priest_bar = "Sacerdotes/Solarian"
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "esES") or BigWigs:NewBossLocale("Kael'thas Sunstrider", "esMX")
if L then
	L.engage_trigger = "^Energía. Poder."
	L.engage_message = "Fase 1"

	L.gaze = "Mirada"
	L.gaze_desc = "Avisar cuando Thaladred mira a un jugador."
	L.gaze_trigger = "mira a"

	L.fear_soon_message = "¡Miedo en breve!"
	L.fear_message = "¡Miedo!"
	L.fear_bar = "~Miedo"

	L.rebirth = "Renacer del Fénix"
	L.rebirth_desc = "Temporizadores aproximados para el Renacer del Fénix."
	L.rebirth_warning = "Posible Renacer en ~5seg"
	L.rebirth_bar = "~Posible Renacer"

	L.pyro = "Piroexplosión (Pyroblast)"
	L.pyro_desc = "Mostrar un temporizador de 60 seg. para Piroexplosión."
	L.pyro_trigger = "%s lanza una piroexplosión"
	L.pyro_warning = "Piroexplosión en 5seg"
	L.pyro_message = "¡Lanzando Piroexplosión!"

	L.phase = "Fases"
	L.phase_desc = "Avisar sobre las distintas fases del encuentro."
	L.thaladred_inc_trigger = "¡Veamos cómo aguantan vuestros nervios contra el Ensombrecedor, Thaladred!"
	L.sanguinar_inc_trigger = "Habéis sobrevivido a algunos de mis mejores consejeros... pero nadie puede resistir el poder del Martillo de Sangre. ¡He aquí Lord Sanguinar!"
	L.capernian_inc_trigger = "Capernian se encargará de que vuestra visita sea breve."
	L.telonicus_inc_trigger = "Bien hecho. Parecéis dignos de probar vuestras habilidades con mi maestro ingeniero Telonicus."
	L.weapons_inc_trigger = "Como veis, dispongo de un amplio arsenal..."
	L.phase3_trigger = "Quizás os subestimé. Sería injusto que os enfrentarais a los cuatro consejeros al mismo tiempo, pero... nunca se le ha brindado un trato justo a mi gente. Así que os devuelvo el favor."
	L.phase4_trigger = "Desafortunadamente hay veces en las que tienes que hacer las cosas con tus propias manos. ¡Balamore shanal!"

	L.flying_trigger = "¡No he llegado hasta aquí para que me detengáis! ¡El futuro que he planeado no se pondrá en peligro! ¡Vais a probar el verdadero poder!"
	L.flying_message = "Fase 5 - Gravedad cero en 1min"

	L.weapons_inc_message = "¡Fase 2 - Armas!"
	L.phase3_message = "¡Fase 3 - Consejeros y Armas!"
	L.phase4_message = "¡Fase 4 - Kael'thas!"
	L.phase4_bar = "Kael'thas entra"

	L.mc = "Control mental (Mind Control)"
	L.mc_desc = "Avisar quién tiene Control mental."

	L.revive_bar = "Añadidos revividos"
	L.revive_warning = "¡Añadidos reviven en 5seg!"

	L.dead_message = "%s muere"

	L.capernian = "Gran astromántica Capernian"
	L.sanguinar = "Lord Sanguinar"
	L.telonicus = "Maestro Ingeriero Telonicus"
	L.thaladred = "Thaladred el Oscurecedor"
end
