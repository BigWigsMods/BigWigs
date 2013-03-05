local L = BigWigs:NewBossLocale("The Stone Guard", "zhCN")
if not L then return end
if L then
	L.petrifications = "石化"
	L.petrifications_desc = "当首领开始石化时发出警报。"

	L.overload = "过载"
	L.overload_desc = "当过载时发出警报。"
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
	L.tank_desc = "闪电之拳，野性火花，奥术震击，暗影灼烧堆叠计数。（英雄模式）"
	L.lash_message = "闪电之拳"
	L.spear_message = "野性火花"
	L.shock_message = "奥术震击"
	L.burn_message = "暗影灼烧"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "zhCN")
if L then
	L.engage_yell = "死亡时间到！"

	L.totem_message = "灵魂图腾 (%d)"
	L.shadowy_message = "暗影攻击 (%d)"
	L.banish_message = "坦克被放逐"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "zhCN")
if L then
	L.bosses = "首领"
	L.bosses_desc = "当首领激活时发出警报。"

	L.shield_removed = "盾移除！(%s)"
	L.casting_shields = "正在施放盾"
	L.casting_shields_desc = "当首领施放盾时发出警报。"
end

L = BigWigs:NewBossLocale("Elegon", "zhCN")
if L then
	L.engage_yell = "进入防御模式。禁用输出保险。"

	L.last_phase = "最后阶段"
	L.overcharged_total_annihilation = "超载 %d！太多了？"

	L.floor = "平台消失"
	L.floor_desc = "当平台即将消失时发出警报。"
	L.floor_message = "平台消失！"

	L.adds = "星界保护者"
	L.adds_desc = "当星界保护者出现时发出警报。"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "zhCN")
if L then
	L.enable_zone = "无尽熔炉"

	L.heroic_start_trigger = "管道被摧毁了" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "机器开始嗡嗡作响了！到下层去！" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "皇帝之怒响彻群山。"
	L.strength_trigger = "皇帝的力量出现在壁龛中！"
	L.courage_trigger = "皇帝的勇气出现在壁龛中！"
	L.bosses_trigger = "两个巨型构造体出现在大型的壁龛中！"
	L.gas_trigger = "上古魔古机器损坏了！"
	L.gas_overdrive_trigger = "皇帝之息渐灭。"

	L.target_only = "|cFFFF0000该提示信息仅在你为首领目标时显示。|r "

	L.combo_message = "%s：即将连击！"
end

