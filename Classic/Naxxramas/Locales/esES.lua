local L = BigWigs:NewBossLocale("Anub'Rekhan", "esES") or BigWigs:NewBossLocale("Anub'Rekhan", "esMX")
if not L then return end
if L then
	L.bossName = "Anub'Rekhan"

	-- L.gainwarn10sec = "~10 sec until Locust Swarm"
	-- L.gainincbar = "~Next Locust Swarm"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "esES") or BigWigs:NewBossLocale("Grand Widow Faerlina", "esMX")
if L then
	L.bossName = "Gran Viuda Faerlina"

	-- L.silencewarn = "Silenced!"
	-- L.silencewarn5sec = "Silence ends in 5 sec"
end

L = BigWigs:NewBossLocale("Gluth", "esES") or BigWigs:NewBossLocale("Gluth", "esMX")
if L then
	L.bossName = "Gluth"

	-- L.startwarn = "Gluth engaged, ~105 sec to decimate!"

	-- L.decimate_bar = "Decimate Zombies"
end

L = BigWigs:NewBossLocale("Gothik the Harvester", "esES") or BigWigs:NewBossLocale("Gothik the Harvester", "esMX")
if L then
	L.bossName = "Gothik el Cosechador"

	-- L.room = "Room Arrival Warnings"
	-- L.room_desc = "Warn for Gothik's arrival"

	-- L.add = "Add Warnings"
	-- L.add_desc = "Warn for adds"

	-- L.adddeath = "Add Death Alert"
	-- L.adddeath_desc = "Alerts when an add dies."

	-- L.starttrigger1 = "Foolishly you have sought your own demise."
	-- L.starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun"
	-- L.startwarn = "Gothik the Harvester engaged! 4:30 till he's in the room."

	-- L.rider = "Unrelenting Rider"
	-- L.spectral_rider = "Spectral Rider"
	-- L.deathknight = "Unrelenting Deathknight"
	-- L.spectral_deathknight = "Spektral Deathknight"
	-- L.trainee = "Unrelenting Trainee"
	-- L.spectral_trainee = "Spectral Trainee"

	-- L.riderdiewarn = "Rider dead!"
	-- L.dkdiewarn = "Death Knight dead!"

	-- L.warn1 = "In room in 3 min"
	-- L.warn2 = "In room in 90 sec"
	-- L.warn3 = "In room in 60 sec"
	-- L.warn4 = "In room in 30 sec"
	-- L.warn5 = "Gothik Incoming in 10 sec"

	-- L.wave = "%d/23: %s"

	-- L.trawarn = "Trainees in 3 sec"
	-- L.dkwarn = "Deathknights in 3 sec"
	-- L.riderwarn = "Rider in 3 sec"

	-- L.trabar = "Trainee - %d"
	-- L.dkbar = "Deathknight - %d"
	-- L.riderbar = "Rider - %d"

	-- L.inroomtrigger = "I have waited long enough. Now you face the harvester of souls."
	-- L.inroomwarn = "He's in the room!"

	-- L.inroombartext = "In Room"
end

L = BigWigs:NewBossLocale("Grobbulus", "esES") or BigWigs:NewBossLocale("Grobbulus", "esMX")
if L then
	L.bossName = "Grobbulus"

	-- L.bomb_message = "Injection"
end

L = BigWigs:NewBossLocale("Heigan the Unclean", "esES") or BigWigs:NewBossLocale("Heigan the Unclean", "esMX")
if L then
	L.bossName = "Heigan el Impuro"

	-- L.starttrigger = "You are mine now."
	-- L.starttrigger2 = "You... are next."
	-- L.starttrigger3 = "I see you..."

	-- L.engage = "Engage"
	-- L.engage_desc = "Warn when Heigan is engaged."
	-- L.engage_message = "Heigan the Unclean engaged! 90 sec to teleport!"

	-- L.teleport = "Teleport"
	-- L.teleport_desc = "Warn for Teleports."
	-- L.teleport_trigger = "The end is upon you."
	-- L.teleport_1min_message = "Teleport in 1 min"
	-- L.teleport_30sec_message = "Teleport in 30 sec"
	-- L.teleport_10sec_message = "Teleport in 10 sec!"
	-- L.on_platform_message = "Teleport! On platform for 45 sec!"

	-- L.to_floor_30sec_message = "Back in 30 sec"
	-- L.to_floor_10sec_message = "Back in 10 sec!"
	-- L.on_floor_message = "Back on the floor! 90 sec to next teleport!"

	-- L.teleport_bar = "Teleport!"
	-- L.back_bar = "Back on the floor!"
end

L = BigWigs:NewBossLocale("The Four Horsemen", "esES") or BigWigs:NewBossLocale("The Four Horsemen", "esMX")
if L then
	L.bossName = "Los Cuatro Jinetes"

	-- L.mark = "Mark"
	-- L.mark_desc = "Warn for marks."

	-- L.markbar = "Mark %d"
	-- L.markwarn1 = "Mark %d!"
	-- L.markwarn2 = "Mark %d in 5 sec"

	-- L.startwarn = "The Four Horsemen Engaged! Mark in ~17 sec"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "esES") or BigWigs:NewBossLocale("Kel'Thuzad", "esMX")
if L then
	L.bossName = "Kel'Thuzad"
	-- L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzad's Chamber"

	-- L.start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!"
	-- L.start_warning = "Kel'Thuzad encounter started! ~3min 30sec till he is active!"

	-- L.phase2_trigger1 = "Pray for mercy!"
	-- L.phase2_trigger2 = "Scream your dying breath!"
	-- L.phase2_trigger3 = "The end is upon you!"
	-- L.phase2_warning = "Phase 2, Kel'Thuzad incoming!"
	-- L.phase2_bar = "Kel'Thuzad Active!"

	-- L.phase3_trigger = "Master, I require aid!"
	-- L.phase3_soon_warning = "Phase 3 soon!"
	-- L.phase3_warning = "Phase 3, Guardians in ~15 sec!"

	-- L.guardians = "Guardian Spawns"
	-- L.guardians_desc = "Warn for incoming Icecrown Guardians in phase 3."
	-- L.guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!"
	-- L.guardians_warning = "Guardians incoming in ~10sec!"
	-- L.guardians_bar = "Guardians incoming!"
end

L = BigWigs:NewBossLocale("Loatheb", "esES") or BigWigs:NewBossLocale("Loatheb", "esMX")
if L then
	L.bossName = "Loatheb"

	-- L.startwarn = "Loatheb engaged, 2 minutes to Inevitable Doom!"

	-- L.doom_5sec_warn = "Doom %d in 5 sec!"
	-- L.doomtime_bar = "Doom every 15sec"
	-- L.doomtime_warn = "Doom timer changes in %s sec!"
	-- L.doomtime_now = "Doom now happens every 15 sec!"

	-- L.remove_curse = "Curses removed on Loatheb"

	-- L.spore_warn = "Spore %d!"
end

L = BigWigs:NewBossLocale("Maexxna", "esES") or BigWigs:NewBossLocale("Maexxna", "esMX")
if L then
	L.bossName = "Maexxna"

	-- L.webspraywarn30sec = "Cocoons in 10 sec"
	-- L.webspraywarn20sec = "Cocoons! Spiders in 10 sec!"
	-- L.webspraywarn10sec = "Spiders! Spray in 10 sec!"
	-- L.webspraywarn5sec = "WEB SPRAY in 5 seconds!"
	-- L.enragewarn = "Frenzy - SQUISH SQUISH SQUISH!"
	-- L.enragesoonwarn = "Frenzy Soon - Bugsquatters out!"

	-- L.cocoonbar = "Cocoons"
	-- L.spiderbar = "Spiders"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "esES") or BigWigs:NewBossLocale("Noth the Plaguebringer", "esMX")
if L then
	L.bossName = "Noth el Pesteador"

	-- L.starttrigger1 = "Die, trespasser!"
	-- L.starttrigger2 = "Glory to the master!"
	-- L.starttrigger3 = "Your life is forfeit!"
	-- L.startwarn = "Noth the Plaguebringer engaged! 90 sec till teleport"
	-- L.add_trigger = "Rise, my soldiers! Rise and fight once more!"

	-- L.blink = "Blink"
	-- L.blink_desc = "Warnings when Noth blinks."
	-- L.blink_trigger = "%s blinks away!"
	-- L.blink_bar = "Blink"

	-- L.teleport = "Teleport"
	-- L.teleport_desc = "Warnings and bars for teleport."
	-- L.teleport_bar = "Teleport!"
	-- L.teleportwarn = "Teleport! He's on the balcony!"
	-- L.teleportwarn2 = "Teleport in 10 sec!"
	-- L.back_bar = "Back in room!"
	-- L.back_warn = "He's back in the room for %d sec!"
	-- L.back_warn2 = "10 sec until he's back in the room!"

	-- L.curse_explosion = "Curse explosion!"
	-- L.curse_warn = "Curse! next in ~55 sec"
	-- L.curse_10sec_warn = "Curse in ~10 sec"
	-- L.curse_bar = "Next Curse"

	-- L.wave = "Waves"
	-- L.wave_desc = "Alerts for the different waves."
	-- L.wave1_bar = "Wave 1"
	-- L.wave2_bar = "Wave 2"
	-- L.wave2_message = "Wave 2 in 10 sec"
end

L = BigWigs:NewBossLocale("Patchwerk", "esES") or BigWigs:NewBossLocale("Patchwerk", "esMX")
if L then
	L.bossName = "Remendejo"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "esES") or BigWigs:NewBossLocale("Instructor Razuvious", "esMX")
if L then
	L.bossName = "Instructor Razuvious"
	L.understudy = "Suplente Caballero de la Muerte"

	-- L.taunt_warning = "Taunt ready in 5sec!"
	-- L.shieldwall_warning = "Barrier gone in 5sec!"
end

L = BigWigs:NewBossLocale("Sapphiron", "esES") or BigWigs:NewBossLocale("Sapphiron", "esMX")
if L then
	L.bossName = "Sapphiron"

	-- L.deepbreath_trigger = "%s takes in a deep breath..."

	-- L.air_phase = "Air phase"
	-- L.ground_phase = "Ground phase"

	-- L.deepbreath = "Ice Bomb"
	-- L.deepbreath_warning = "Ice Bomb Incoming!"
	-- L.deepbreath_bar = "Ice Bomb Lands!"

	-- L.icebolt_say = "I'm a Block!"
end

L = BigWigs:NewBossLocale("Thaddius", "esES") or BigWigs:NewBossLocale("Thaddius", "esMX")
if L then
	L.bossName = "Thaddius"

	-- L.trigger_phase1_1 = "Stalagg crush you!"
	-- L.trigger_phase1_2 = "Feed you to master!"
	-- L.trigger_phase2_1 = "Eat... your... bones..."
	-- L.trigger_phase2_2 = "Break... you!!"
	-- L.trigger_phase2_3 = "Kill..."

	-- L.add_death_trigger = "%s dies."
	-- L.overload_trigger = "%s overloads!"
	-- L.polarity_trigger = "Now you feel pain..."

	-- L.polarity_warning = "3 sec to Polarity Shift!"
	-- L.polarity_changed = "Polarity changed!"
	-- L.polarity_nochange = "Same polarity!"
	-- L.polarity_first_positive = "You're POSITIVE!"
	-- L.polarity_first_negative = "You're NEGATIVE!"

	-- L.phase1_message = "Phase 1"
	-- L.phase2_message = "Phase 2 - Berserk in 5 minutes!"

	-- L.throw = "Throw"
	-- L.throw_desc = "Warn about tank platform swaps."
	-- L.throw_warning = "Throw in ~5 sec!"

	-- L.polarity_extras = "Additional alerts for Polarity Shift positioning"

	-- L.custom_off_select_charge_position = "First position"
	-- L.custom_off_select_charge_position_desc = "Where to move to after the first Polarity Shift."
	-- L.custom_off_select_charge_position_value1 = "|cffff2020Negative (-)|r are LEFT, |cff2020ffPositive (+)|r are RIGHT"
	-- L.custom_off_select_charge_position_value2 = "|cff2020ffPositive (+)|r are LEFT, |cffff2020Negative (-)|r are RIGHT"

	-- L.custom_off_select_charge_movement = "Movement"
	-- L.custom_off_select_charge_movement_desc = "The movement strategy your group uses."
	-- L.custom_off_select_charge_movement_value1 = "Run |cff20ff20THROUGH|r the boss"
	-- L.custom_off_select_charge_movement_value2 = "Run |cff20ff20CLOCKWISE|r around the boss"
	-- L.custom_off_select_charge_movement_value3 = "Run |cff20ff20COUNTER-CLOCKWISE|r around the boss"
	-- L.custom_off_select_charge_movement_value4 = "Four camps 1: Polarity changed moves |cff20ff20RIGHT|r, same polarity moves |cff20ff20LEFT|r"
	-- L.custom_off_select_charge_movement_value5 = "Four camps 2: Polarity changed moves |cff20ff20LEFT|r, same polarity moves |cff20ff20RIGHT|r"

	-- L.custom_off_charge_graphic = "Graphical arrow"
	-- L.custom_off_charge_graphic_desc = "Show an arrow graphic."
	-- L.custom_off_charge_text = "Text arrows"
	-- L.custom_off_charge_text_desc = "Show an additional message."
	-- L.custom_off_charge_voice = "Voice alert"
	-- L.custom_off_charge_voice_desc = "Play a voice alert."

	-- Translate these to get locale sound files!
	-- L.left = "<--- GO LEFT <--- GO LEFT <---"
	-- L.right = "---> GO RIGHT ---> GO RIGHT --->"
	-- L.swap = "^^^^ SWITCH SIDES ^^^^ SWITCH SIDES ^^^^"
	-- L.stay = "==== DON'T MOVE ==== DON'T MOVE ===="
end
