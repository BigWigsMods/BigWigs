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
	L.unseenstrike_inc = "即将无影击！"
	L.unseenstrike_soon = "5-10秒后无影击！"
	L.assault_message = "压制突袭"
	L.side_swap = "风暴释放"	
end

L = BigWigs:NewBossLocale("Garalon", "zhCN")
if L then
	L.removed = "%s 已移除！"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "zhCN")
if L then
	L.spear_removed = "你的穿刺之矛被移除了！"
	L.residue_removed = "%s 已移除！"

	L.mending_desc = "|cFFFF0000警告: 计时条仅对你的焦点作用|r "
	L.mending_warning = "你的焦点正在治疗！"
	L.mending_bar = "焦点：治疗！"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "zhCN")
if L then
	L.explosion_by_other = "其它人施放琥珀爆炸"
	L.explosion_by_other_desc = "Cooldown warning for Amber Explosions cast by Amber Monstrosity or your focus target."

	L.explosion_casting_by_other = "其它人施放琥珀爆炸"
	L.explosion_casting_by_other_desc = "Casting warnings for Amber Explosions started by Amber Monstrosity or your focus target. Emphasizing this is highly recommended!"

	L.explosion_by_you = "你的琥珀爆炸"
	L.explosion_by_you_bar = "You start casting..."
	L.explosion_by_you_desc = "Cooldown warning for your Amber Explosions."

	L.explosion_casting_by_you = "你正在施法琥珀爆炸"
	L.explosion_casting_by_you_desc = "Casting warnings for Amber Explosions started by you. Emphasizing this is highly recommended!"

	L.willpower = "意志力"
	L.willpower_message = "意志力：%d！"

	L.break_free_message = "血量：%d%%！"
	L.fling_message = "快吸水！"
	L.parasite = "寄生生长"

	L.monstrosity_is_casting = "Monstrosity: Explosion"
	L.you_are_casting = "»你«在施法！"

	L.unsok_short = "|cFFF20056Boss|r" -- Light Red
	L.monstrosity_short = "|cFFFFBE00Add|r" -- Amber
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "zhCN")
if L then

end

