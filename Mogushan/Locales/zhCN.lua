local L = BigWigs:NewBossLocale("The Stone Guard", "zhCN")
if not L then return end
if L then
	L.petrifications = "Petrification"
	L.petrifications_desc = "Warning for when bosses start petrification"

	L.overload = "Overload" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "Warning for all types of overloads."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "zhCN")
if L then
	L.engage_yell = "啊，没错。交出你们的灵魂吧，凡人！这里是亡者的殿堂！"

	L.phase_lightning_trigger = "噢，伟大的神灵！赐予我大地的力量！"
	L.phase_flame_trigger = "噢，至高的神！借我之手融化他们的血肉吧！"
	L.phase_arcane_trigger = "噢，上古的贤者！赐予我魔法的智慧吧！"
	L.phase_shadow_trigger = "先烈的英灵！用你的盾保护我吧！"

	L.phase_lightning = "闪电阶段！"
	L.phase_flame = "火焰阶段！"
	L.phase_arcane = "奥术阶段！"
	L.phase_shadow = "（英雄）暗影阶段！"

	L.phase_message = "即将下一阶段！"
	L.shroud_message = "%2$s cast Shroud on %1$s"
	L.barrier_message = "Barrier UP!"
	L.barrier_cooldown = "Barrier cooldown"
	L.can_interrupt_epicenter = "%s 可打断 %s"
	L.epicenter_interrupted = "%s 已打断！"

	-- Tanks
	L.tank = "坦克警报"
	L.tank_desc = "Count the stacks of Lightning Lash, Flaming Spear, Arcane Shock & Shadowburn (Heroic)."
	L.lash_message = "%2$dx Lash on %1$s"
	L.spear_message = "%2$dx Spear on %1$s"
	L.shock_message = "%2$dx Shock on %1$s"
	L.burn_message = "%2$dx Burn on %1$s"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "zhCN")
if L then
	L.engage_yell = "死亡时间到！"

	L.totem = "Totem (%d)"
	L.shadowy_message = "Attack (%d)"
	L.banish_message = "Tank Banished"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "zhCN")
if L then
	L.shield_removed = "Shield removed! (%s)"
	L.casting_shields = "Casting shields"
	L.casting_shields_desc = "Warning for when shields are casted for all bosses"
end

L = BigWigs:NewBossLocale("Elegon", "zhCN")
if L then
	L.engage_yell = "进入防御模式。禁用输出保险。"

	L.last_phase = "最后阶段"
	L.overcharged_total_annihilation = "超载 %d! 太多了？"

	L.floor = "平台消失"
	L.floor_desc = "当平台即将消失时进行提示。"
	L.floor_message = "平台即将消失！"

	L.adds = "星界保护者"
	L.adds_desc = "星界保护者刷新时提示。"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "zhCN")
if L then
	L.enable_zone = "无尽熔炉"

	L.heroic_start_trigger = "Destroying the pipes" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "机器开始嗡嗡作响了！到下层去！" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "皇帝之怒响彻群山。"
	L.strength_trigger = "皇帝的力量出现在壁龛中！"
	L.courage_trigger = "皇帝的勇气出现在壁龛中！"
	L.bosses_trigger = "两个巨型构造体出现在大型的壁龛中！"
	L.gas_trigger = "上古魔古机器损坏了！"
	L.gas_overdrive_trigger = "皇帝之息渐灭。"

	L.target_only = "|cFFFF0000This warning will only show for the boss you're targeting.|r "
	L.combo_message = "%s: Combo soon!"
end

