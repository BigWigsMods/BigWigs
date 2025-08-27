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
	L.fractal_images = "虚空龙" -- 技能“分形镜像”描述
	L.oath_bound_removed_dose = "移除1层誓言约束"
	L.behead = "处斩" -- Claws of a dragon
	L.netherbreaker = "虚空圈"
	L.galaxy_smash = "重碾" -- 技能“星河重碾”的简称
	L.starkiller_swing = "歼星斩" -- 歼星斩
	L.vengeful_oath = "幻影"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "zhCN")
if L then
	L.gravity = "引力" -- 技能“引力倒逆”和“引力扭曲”的简称。
	L.extinction = "碎片" -- 迪门修斯投掷出“破碎空间”的空间碎片
	L.slows = "减速"
	L.slow = "减速"
	L.mass_destruction = "射线"
	L.mass_destruction_single = "射线"
	L.stardust_nova = "新星" -- 技能“星尘新星”的简称
	L.extinguish_the_stars = "众星" -- 技能“熄灭众星”的简称
	L.darkened_sky = "波"
	L.cosmic_collapse = "坦克拉人"
	L.cosmic_collapse_easy = "坦克大圈"
	L.soaring_reshii = "坐骑可用" -- On the timer for when flying is available

	L.left_living_mass = "活体物质（左）"  -- NPCID：242587 活体物质
	L.right_living_mass = "活体物质（右）"

	L.soaring_reshii_monster_yell = "你目前的表现好得出奇，" -- [CHAT_MSG_MONSTER_YELL] 你目前的表现好得出奇，可我们还没结束呢。#Xal'atath###Meeresflask##0#0##0#256#nil#0#false#false#false#false",

	L.weakened_soon_monster_yell = "必须出击，就是现在！" -- [CHAT_MSG_MONSTER_YELL] 必须出击，就是现在！#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
