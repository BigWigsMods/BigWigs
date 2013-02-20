local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "zhCN")
if not L then return end
if L then
	L.engage_yell = "我们不会向黑暗虚空的绝望屈服。如果女皇要我们去死，我们便照做。"

	L.force_message = "力与魄"

	L.attenuation_bar = "音波衰减"
	L.attenuation_message = "%s 音波衰减 %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffa佐尔洛克|r"
	L.left = "|c00008000<- 左 <-|r"
	L.right = "|c00FF0000-> 右 ->|r"

	L.platform_emote = "朝他其中一个平台飞去了！" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "皇家宰相佐尔洛克吸入狂热信息素！"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "换平台"
end


L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "zhCN")
if L then
	L.engage_yell = "On your guard, invaders. I, Ta'yak, Lord of Blades, will be your opponent."

	L.unseenstrike_soon = "5-10秒后无影击(%d)！"
	L.assault_message = "压制突袭"
	L.side_swap = "风暴释放"
end

L = BigWigs:NewBossLocale("Garalon", "zhCN")
if L then
	L.phase2_trigger = "Garalon's massive armor plating begins to crack and split!"

	L.removed = "%s 已移除！"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "zhCN")
if L then
	L.spear_removed = "你的穿刺之矛被移除了！"

	L.mending_desc = "|cFFFF0000警告: 计时条仅对你的焦点作用|r "
	L.mending_warning = "你的焦点正在治疗！"
	L.mending_bar = "焦点：治疗！"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "zhCN")
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

	L.willpower = "意志力"
	L.willpower_message = "意志力：%d！"

	L.break_free_message = "血量：%d%%！"
	L.fling_message = "快吸水！"
	L.parasite = "寄生生长"

	L.monstrosity_is_casting = "Monster: Explosion"
	L.you_are_casting = "»你«在施法！"

	L.unsok_short = "Boss"
	L.monstrosity_short = "Monster"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "zhCN")
if L then
	L.engage_trigger = "Death to all who dare challenge my empire!"
	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes."

	L.eyes = "Eyes of the Empress"
	L.eyes_desc = "Count the stacks and show a duration bar for Eyes of the Empress."
	L.eyes_message = "Eyes"

	L.visions_message = "Visions"
	L.visions_dispel = "Players have been feared!"
	L.fumes_bar = "Your fumes buff"
end

