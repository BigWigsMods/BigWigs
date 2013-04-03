local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "koKR")
if not L then return end
if L then
	L.engage_yell = "신성하신 분께서 당신의 신성한 뜻을 실현하라고 우리에게 목소리를 주셨다. 우리는 도구일 뿐이다."
	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discs)"
	L.attenuation_bar = "Discs... Dance!"
	L.attenuation_message = "%s Dancing %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- 왼쪽 <-|r"
	L.right = "|c00FF0000-> 오른쪽 ->|r"

	L.platform_emote = "단상" -- 황실 장로 조르로크가 단상으로 날아갑니다!
	L.platform_emote_final = "열광" -- 황실 장로 조르로크가 열광의 페로몬을 들이마십니다!
	L.platform_message = "단상 변경"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "koKR")
if L then
	L.engage_yell = "On your guard, invaders. I, Ta'yak, Lord of Blades, will be your opponent."

	L.unseenstrike_soon = "Strike (%d) in ~5-10 sec!"
	L.assault_message = "Assault"
	L.side_swap = "Side Swap"
end

L = BigWigs:NewBossLocale("Garalon", "koKR")
if L then
	L.phase2_trigger = "가랄론의 육중한 장갑이 갈라지면서 쪼개지기 시작합니다!"

	L.removed = "%s 사라짐!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "koKR")
if L then
	L.spear_removed = "Your Impaling Spear was removed!"

	L.mending_desc = "|cFFFF0000WARNING: Only the timer for your 'focus' target will show because all Zar'thik Battle-Menders have separate heal cooldowns.|r "
	L.mending_warning = "Your focus is casting Mending!"
	L.mending_bar = "Focus: Mending"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "koKR")
if L then
	L.explosion_by_other = "Amber Explosion cooldown bar by Monstrosity/Focus"
	L.explosion_by_other_desc = "Cooldown warnings and bar for Amber Explosions cast by the Amber Monstrosity or your focus target."

	L.explosion_casting_by_other = "Amber Explosion cast bar by Monstrosity/Focus"
	L.explosion_casting_by_other_desc = "Cast warnings for Amber Explosions started by Amber Monstrosity or your focus target. Emphasizing this is highly recommended!"

	L.explosion_by_you = "Your Amber Explosion cooldown"
	L.explosion_by_you_desc = "Cooldown warning for your Amber Explosions."
	L.explosion_by_you_bar = "You start casting..."

	L.explosion_casting_by_you = "Your Amber Explosion cast bar"
	L.explosion_casting_by_you_desc = "Casting warnings for Amber Explosions started by you. Emphasizing this is highly recommended!"

	L.willpower = "의지력"
	L.willpower_message = "%d 의지력!"

	L.break_free_message = "%d%%의 생명력!"
	L.fling_message = "내던지기!"
	L.parasite = "기생충"

	L.monstrosity_is_casting = "괴수: 폭발"
	L.you_are_casting = "당신이 시전중!"

	L.unsok_short = "우두머리"
	L.monstrosity_short = "괴수"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "koKR")
if L then
	L.engage_trigger = "내 제국에 맞서는 모든 이들에게 죽음을!"

	L.phases = "단계"
	L.phases_desc = "단계 변경을 경고합니다."

	L.eyes = "Eyes of the Empress"
	L.eyes_desc = "Count the stacks and show a duration bar for Eyes of the Empress."
	L.eyes_message = "Eyes"

	L.visions_message = "Visions"
	L.visions_dispel = "Players have been feared!"
	L.fumes_bar = "Your fumes buff"
end