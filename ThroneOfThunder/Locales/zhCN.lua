local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "zhCN")
if not L then return end
if L then
	L.storm_duration = "闪电风暴持续"
	L.storm_duration_desc = "当闪电风暴施放时显示分离警报条。"

	L.in_water = ">你< 水中！"
end

L = BigWigs:NewBossLocale("Horridon", "zhCN")
if L then
	L.orb_message = "控制之球掉落！"

	L.chain_lightning_warning = "焦点：>闪电链<！"
	L.chain_lightning_bar = "焦点：闪电链"

	L.fireball_warning = "焦点：>火球术<！"
	L.fireball_bar = "焦点：火球术"

	L.venom_bolt_volley_desc = "|cFFFF0000注意：只有显示“焦点”目标时计时条才会被显示因为每个毒箭之雨施放者都有不同的冷却时间。|r "..select(2, EJ_GetSectionInfo(7112))
	L.venom_bolt_volley_warning = "焦点：>毒箭之雨<！"
	L.venom_bolt_volley_bar = "焦点：毒箭之雨"

	L.puncture_message = "三重穿刺！"

	L.charge_trigger = "sets his eyes" -- Horridon sets his eyes on PLAYERNAME and stamps his tail!
end

L = BigWigs:NewBossLocale("Council of Elders", "zhCN")
if L then
	L.full_power = "全能量"

	L.assault_message = "冰寒突击！"

	L.loa_kills = "击杀神灵：>%s<"
	L.priestess_add = "神灵增援"
	L.priestess_adds = "神灵增援"
	L.priestess_adds_desc = "当击杀全部高阶祭司玛尔里的增援时发出警报。"
	L.hp_to_go_power = "生命：%d%% - 能量：%d"
end

L = BigWigs:NewBossLocale("Tortos", "zhCN")
if L then
	L.kick = "脚踢"
	L.kick_desc = "持续追踪可被脚踢乌龟的数量。"
	L.kickable_turtles = "可脚踢乌龟：>%d<！"
	L.crystal_shell_removed = "晶化甲壳 移除！"
	L.no_crystal_shell = "没有晶化甲壳"
end

L = BigWigs:NewBossLocale("Megaera", "zhCN")
if L then
	L.breaths = "火息术"
	L.breaths_desc = "全部不同类型的火息术警报。"
	L.rampage_over = "狂暴结束！"
	L.arcane_adds = "奥术之头"
end

L = BigWigs:NewBossLocale("Ji-Kun", "zhCN")
if L then
	L.flight_over = "飞行结束"
	L.young_egg_hatching = "年幼的蛋孵化"
	L.lower_hatch_trigger = "The eggs in one of the lower nests begin to hatch!"
	L.upper_hatch_trigger = "The eggs in one of the upper nests begin to hatch!"
	L.upper_nest = "|c00008000下层|r巢穴"
	L.lower_nest = "|c00FF0000上层|r巢穴"
	L.food_call_trigger = "Hatchling calls for food!"
	L.nest = "巢穴"
	L.nest_desc = "警报依赖于巢穴。|c00FF0000如果你没有分配到处理巢穴请关闭该警报！|r"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "zhCN")
if L then
	L.rays_spawn = "Rays spawn"
	L.ray_controller = "Ray controller"
	L.ray_controller_desc = "Announce the ray direction controllers for the red and blue rays."
	L.ray_controller_icon = 22581 -- hopefully some fitting icon
	L.red_ray_controller = "You are the |c000000FFBlue|r ray controller"
	L.blue_ray_controller = "You are the |c00FF0000Red|r ray controller"
	L.red_spawn_trigger = "The Infrared Light reveals a Crimson Fog!"
	L.blue_spawn_trigger = "The Blue Rays reveal an Azure Eye!"
	L.red_add = "|c00FF0000Red|r add"
	L.blue_add = "|c000000FFBlue|r add"
	L.clockwise = "Clockwise"
	L.counter_clockwise = "Counter clockwise"
	L.death_beam = "Death beam"
end

L = BigWigs:NewBossLocale("Primordius", "zhCN")
if L then
	L.stream_of_blobs = "Stream of blobs"
	L.mutations = "Mutations"
end

L = BigWigs:NewBossLocale("Dark Animus", "zhCN")
if L then
	L.engage_trigger = "The orb explodes!"
	L.slam_message = "Slam"
end

L = BigWigs:NewBossLocale("Iron Qon", "zhCN")
if L then
	L.molten_energy = "熔火能量"

	L.overload_casting = "正在施放 熔火过载"
	L.overload_casting_desc = "当正在施放熔火过载时发出警报。"
end

L = BigWigs:NewBossLocale("Twin Consorts", "zhCN")
if L then
	L.barrage_fired = "Barrage fired!"
end

L = BigWigs:NewBossLocale("Lei Shen", "zhCN")
if L then
	L.conduit_abilities = "Conduit Abilities"
	L.conduit_abilities_desc = "Approximate cooldown bars for the conduit specific abilities"
	L.conduit_ability_meassage = "Next conduit ability"
	L.intermission = "Intermission"
	L.overchargerd_message = "Stunning AoE pulse"
	L.static_shock_message = "Splitting AoE damege"
	L.diffusion_add_message = "Diffusion adds"
	L.diffusion_chain_message = "Diffusion adds soon - SPREAD!"
end

L = BigWigs:NewBossLocale("Ra-den", "zhCN")
if L then

end
