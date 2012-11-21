local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "esES") or BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "esMX")
if not L then return end
if L then
	L.engage_yell = "La Divina nos ha elegido para dar voz mortal a Su pensamiento eterno. Solo somos el brazo que ejecuta Su voluntad."

	L.force_message = "Pulso AoE"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discos)"
	L.attenuation_bar = "¡Discos... baila!"
	L.attenuation_message = "%s Baile %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- Izquierda <-|r"
	L.right = "|c00FF0000-> Derecha ->|r"

	L.platform_emote = "¡El visir imperial Zor'lok vuela hacia una de las plataformas!" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "¡El visir imperial Zor'lok inhala las feromonas de celo!"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "Cambio de plataforma"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "esES") or BigWigs:NewBossLocale("Blade Lord Ta'yak", "esMX")
if L then
	L.engage_yell = "¡En guardia, invasores! Yo, Ta'yak, Señor de las Espadas, seré vuestro contrincante."

	L.unseenstrike_inc = "¡Golpe inminente!"
	L.unseenstrike_soon = "Strike in ~5-10 sec!"

	L.assault_message = "Asalto"
	L.side_swap = "Side Swap"
end

L = BigWigs:NewBossLocale("Garalon", "esES") or BigWigs:NewBossLocale("Garalon", "esMX")
if L then
	L.removed = "¡%s eliminado!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "esES") or BigWigs:NewBossLocale("Wind Lord Mel'jarak", "esMX")
if L then

end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "esES") or BigWigs:NewBossLocale("Amber-Shaper Un'sok", "esMX")
if L then

end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "esES") or BigWigs:NewBossLocale("Grand Empress Shek'zeer", "esMX")
if L then

end

