local L = BigWigs:NewBossLocale("The Stone Guard", "zhCN")
if not L then return end
if L then
	L.petrifications = "石化"
	L.petrifications_desc = "守卫试图将自己的敌人转化为各色晶石，使其受到的相应伤害降低90%，但是会逐渐降低其移动速度。身上石化效果达到100层的敌人将变成石头，无法移动或执行任何动作。"

	L.overload = "过载" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "能量值全满时守卫会过载，对所有敌人造成250000点伤害，并中断相应石化。过载不会释放被完全石化的敌人。"
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
	L.phase_shadow = "（英雄模式）暗影阶段！"

	L.phase_message = "即将下一阶段！"
	L.shroud_message = "反射罩"
	L.shroud_can_interrupt = "%s 可打断 %s！"
	L.barrier_message = "废灵壁垒！"
	L.barrier_cooldown = "废灵壁垒冷却"

	-- Tanks
	L.tank = "坦克警报"
	L.tank_desc = "闪电之拳、野性火花、奥术震击、暗影灼烧（英雄模式）的计数"
	L.lash_message = "闪电之拳"
	L.spear_message = "野性火花"
	L.shock_message = "奥术震击"
	L.burn_message = "暗影灼烧"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "zhCN")
if L then
	L.engage_yell = "死亡时间到！"

	L.totem_message = "图腾 (%d)"
	L.shadowy_message = "暗影攻击 (%d)"
	L.banish_message = "坦克已被放逐"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "zhCN")
if L then
	L.bosses = "Bosses"
	L.bosses_desc = "Warnings for when a boss becomes active."

	L.shield_removed = "Shield removed! (%s)"
	L.casting_shields = "Casting shields"
	L.casting_shields_desc = "Warning for when shields are casted for all bosses."
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

	L.target_only = "|cFFFF0000该提示信息仅在你为首领目标时显示。|r "
	L.combo_message = "%s: 即将连击！"
end

