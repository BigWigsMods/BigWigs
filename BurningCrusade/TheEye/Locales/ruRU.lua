local L = BigWigs:NewBossLocale("Void Reaver", "ruRU")
if not L then return end
if L then
	L.engage_trigger = "Тревога! Ты отмечен для уничтожения."
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "ruRU")
if L then
	
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "ruRU")
if L then
	L.engage_trigger = "^Сила. Могущество"
	L.engage_message = "Phase 1"

	L.gaze = "Gaze"
	L.gaze_desc = "Warn when Thaladred focuses on a player."
	L.gaze_trigger = "sets eyes"

	L.fear_soon_message = "Fear soon!"
	L.fear_message = "Fear!"
	L.fear_bar = "~Fear Cooldown"

	L.rebirth = "Phoenix Rebirth"
	L.rebirth_desc = "Approximate Phoenix Rebirth timers."
	L.rebirth_warning = "Possible Rebirth in ~5sec!"
	L.rebirth_bar = "~Possible Rebirth"

	L.pyro = "Pyroblast"
	L.pyro_desc = "Show a 60 second timer for Pyroblast"
	L.pyro_trigger = "%s begins to cast Pyroblast!"
	L.pyro_warning = "Pyroblast in 5sec!"
	L.pyro_message = "Casting Pyroblast!"

	L.phase = "Phase warnings"
	L.phase_desc = "Warn about the various phases of the encounter."
	L.thaladred_inc_trigger = "Посмотрим, как выдержат ваши нервы протви Затемнителя, Таладред!"
	L.sanguinar_inc_trigger = "Вы сумели противостоять кое-кому из моих лучших советников... но никто не может выдержать мощи Молота Кров. Узрите же лорда Сангвинара!"
	L.capernian_inc_trigger = "Каперниан позаботится о том, чтобы ваше пребывание здесь было кратковременным."
	L.telonicus_inc_trigger = "Well done, you have proven worthy to test your skills against my master engineer, Telonicus."
	L.weapons_inc_trigger = "Как видите, у меня в арсенале много оружия."
	L.phase3_trigger = "Возможно, я недооценил вас. Было бы нечестно заставлять вас драться со всеми четырьмя советниками одновременно, но... по отношению к моему народу никто и никогда не поступал честно. Так что я лишь возвращаю должок."
	L.phase4_trigger = "Увы, иногда приходится решать проблемы самостоятельно. Баламоре шаналь!"

	L.flying_trigger = "I have not come this far to be stopped! The future I have planned will not be jeopardized! Now you will taste true power!!"
	L.flying_message = "Phase 5 - Gravity Lapse in 1min"

	L.weapons_inc_message = "Phase 2 - Weapons incoming!"
	L.phase3_message = "Phase 3 - Advisors and Weapons!"
	L.phase4_message = "Phase 4 - Kael'thas incoming!"
	L.phase4_bar = "Kael'thas incoming"

	L.mc = "Mind Control"
	L.mc_desc = "Warn who has Mind Control."

	L.revive_bar = "Adds Revived"
	L.revive_warning = "Adds Revived in 5sec!"

	L.dead_message = "%s dies"

	L.capernian = "Верховный звездочет Каперниан"
	L.sanguinar = "Лорд Сангвинар"
	L.telonicus = "Старший инженер Телоникус"
	L.thaladred = "Таладред Светокрад"
end

