local L = BigWigs:NewBossLocale("Kil'jaeden", "esMX")
if not L then return end
if L then
	--L.bomb_cast = "Incoming Big Bomb"
	--L.bomb_nextbar = "Possible Bomb"
	--L.bomb_warning = "Possible bomb in ~10sec"

	--L.orb = "Shield Orb"
	--L.orb_desc = "Warn when a Shield Orb is shadowbolting."
	--L.orb_shooting = "Orb Alive - Shooting People!"

	--L.shield_up = "Shield is UP!"
	--L.deceiver_dies = "Deceiver #%d Killed"

	--L.blueorb = "Dragon Orb"
	--L.blueorb_desc = "Warns on Blue Dragonflight Orb spawns."
	--L.blueorb_message = "Blue Dragonflight Orb ready!"

	--L.kalec_yell = "I will channel my powers into the orbs! Be ready!"
	--L.kalec_yell2 = "I have empowered another orb! Use it quickly!"
	--L.kalec_yell3 = "Another orb is ready! Make haste!"
	--L.kalec_yell4 = "I have channeled all I can! The power is in your hands!"
	--L.phase3_trigger = "I will not be denied! This world shall fall!"
	--L.phase4_trigger = "Do not harbor false hope. You cannot win!"
	--L.phase5_trigger = "Ragh! The powers of the Sunwell turn against me! What have you done? What have you done?!"
end

L = BigWigs:NewBossLocale("Felmyst", "esMX")
if L then
	L.phase = "Fases"
	L.phase_desc = "Avisar sobre las fases de suelo y aire."
	L.airphase_trigger = "¡Soy más fuerte que nunca!"
	L.takeoff_bar = "Vuela"
	L.takeoff_message = "¡Vuela en 5 Seg!"
	L.landing_bar = "Aterriza"
	L.landing_message = "¡Aterriza en 10 Seg!"

	L.breath = "Respira hondo"
	L.breath_desc = "Avisar cuando respira hondo."
end

L = BigWigs:NewBossLocale("Brutallus", "esMX")
if L then
	L.engage_trigger = "¡Ah, más corderos al matadero!"

	L.burnresist = "Quemar resistido"
	L.burnresist_desc = "Avisar quién resiste Quemar."
	L.burn_resist = "Quemar resistido por %s"
end

L = BigWigs:NewBossLocale("M'uru", "esMX")
if L then
	L.sentinel = "Centinela del vacío"
	L.sentinel_desc = "Avisar cuando aparece un centinela del vacío."
	L.sentinel_next = "Centinela (%d)"

	L.humanoid = "Añadidos humanoides"
	L.humanoid_desc = "Avisar cuando aparecen los humanoides."
	L.humanoid_next = "Humanoides (%d)"
end

L = BigWigs:NewBossLocale("Kalecgos", "esMX")
if L then
	L.engage_trigger = "¡Aggh! ¡Ya no seré un esclavo de Malygos! ¡Retadme y seréis destruidos!"
	L.enrage_trigger = "¡Sathrovarr induce a Kalecgos a un estado de ira enloquecida!"

	L.sathrovarr = "Sathrovarr el Corruptor"

	L.portal = "Portal"
	L.portal_message = "Posible portal en 5 seg"

	L.realm_desc = "Avisa quién está en el Reino espectral."
	L.realm_message = "Reino espectral: %s (Grupo %d)"
	L.nobody = "Nadie"

	L.curse = "Maldición"

	L.wild_magic_healing = "Magia salvaje (Curación)"
	L.wild_magic_healing_desc = "Te avisa cuando haces curaciones aumentadas por Magia salvaje."
	L.wild_magic_healing_you = "¡Magia salvaje - Curación aumentada!"

	L.wild_magic_casting = "Magia salvaje (Tiempo lanzamiento)"
	L.wild_magic_casting_desc = "Te avisa cuando un sanador tiene el tiempo de lanzamiento aumentado por Magia salvaje."
	L.wild_magic_casting_you = "¡Magia salvaje - Tiempo lanzamiento aumentada!"
	L.wild_magic_casting_other = "¡Magia salvaje - Tiempo lanzamiento aumentado en %s!"

	L.wild_magic_hit = "Magia salvaje (Prob. golpe)"
	L.wild_magic_hit_desc = "Avisa cuando la probabilidad de golpe de un tanque se ve reducida por Magia salvaje."
	L.wild_magic_hit_you = "¡Magia salvaje - Prob. golpe reducida!"
	L.wild_magic_hit_other = "¡Magia salvaje - Prob. golpe reducida en %s!"

	L.wild_magic_threat = "Magia salvaje (Amenaza)"
	L.wild_magic_threat_desc = "Avisa cuando generas más amenaza por Magia salvaje."
	L.wild_magic_threat_you = "¡Magia salvaje - Amenaza generada aumentada!"
end

L = BigWigs:NewBossLocale("The Eredar Twins", "esMX")
if L then
	L.lady = "Lady Sacrolash #3:"
	L.lock = "Bruja suprema Alythess #2:"

	L.threat = "Amenaza"

	-- L.custom_on_threat = "Threat InfoBox"
	-- L.custom_on_threat_desc = "Show second on threat for Grand Warlock Alythess and third on threat for Lady Sacrolash."
end

