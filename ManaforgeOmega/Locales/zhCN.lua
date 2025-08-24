local L = BigWigs:NewBossLocale("Loom'ithar", "zhCN")
if not L then return end
if L then
	L.lair_weaving = "蛛网" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "晶塔" -- 技能“注能晶塔”的简称
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "zhCN")
if L then
	L.voidblade_ambush = "奇袭" -- 技能“虚空剑士奇袭”的简称
	L.soulfray_annihilation = "射线" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "射线" -- Single from Lines
	L.remaining_adds = "剩余增援" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "zhCN")
if L then
	L.invoke_collector = "收集者" -- NPC“唤动收集者”的简称
end

L = BigWigs:NewBossLocale("Fractillus", "zhCN")
if L then
	L.crystalline_shockwave = "水晶墙"
	L.shattershell = "破墙"
	L.shockwave_slam = "坦克墙"
	L.nexus_shrapnel = "碎片落地"
	L.crystal_lacerations = "流血"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "zhCN")
if L then
	L.oath_bound_removed_dose = "移除1层誓言约束"
	L.behead = "处斩" -- Claws of a dragon
	L.netherbreaker = "虚空圈"
	L.galaxy_smash = "重碾" -- 技能“星河重碾”的简称
	L.starkiller_swing = "歼星斩" -- 歼星斩
	L.vengeful_oath = "幻影"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "zhCN")
if L then
	L.reverse_gravity = "引力" -- 技能“引力倒逆”的简称
	L.extinction = "碎片" -- 迪门修斯投掷出破碎世界的碎片
	L.slows = "减速"
	L.slow = "减速"
	L.stardust_nova = "新星" -- 技能“星尘新星”的简称
	L.extinguish_the_stars = "众星" -- 技能“熄灭众星”的简称
	L.darkened_sky = "环形"
	L.cosmic_collapse = "崩塌" -- 技能“寰宇崩塌”的简称
	L.soaring_reshii = "坐骑可用" -- On the timer for when flying is available

	L.weakened_soon_monster_yell = "必须出击，就是现在！" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
