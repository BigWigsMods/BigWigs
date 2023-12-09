local L = BigWigs:NewBossLocale("Gnarlroot", "zhCN")
if not L then return end
if L then
	L.tortured_scream = "尖啸"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "zhCN")
if L then
	L.blistering_spear = "长矛"
	L.blistering_spear_single = "长矛"
	L.blistering_torment = "链条"
	L.twisting_blade = "飞刀"
	L.marked_for_torment = "折磨"
	L.umbral_destruction = "分摊"
	L.heart_stopper = "治疗吸收盾"
	L.heart_stopper_single = "治疗吸收盾"
end

L = BigWigs:NewBossLocale("Volcoross", "zhCN")
if L then
	L.custom_off_all_scorchtail_crash = "团长模式"
	L.custom_off_all_scorchtail_crash_desc = "显示全部焦尾碾压的计时器和信息，而不是仅显示你的一面。"

	L.flood_of_the_firelands = "分摊"
	L.flood_of_the_firelands_single_wait = "等待" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.flood_of_the_firelands_single = "分摊"
	L.scorchtail_crash = "尾击"
	L.serpents_fury = "怒焰"
	L.coiling_flames_single = "烈焰"
end

L = BigWigs:NewBossLocale("Council of Dreams", "zhCN")
if L then
	L.agonizing_claws_debuff = "{421022} (减益)"

	L.ultimate_boss = "满能量 (%s)"
	L.special_bar = "满能 [%s] (%d)"
	L.special_mythic_bar = "满能 [%s/%s] (%d)"
	L.special_mechanic_bar = "%s [满能] (%d)"

	L.poisonous_javelin = "标枪"
	L.song_of_the_dragon = "歌谣"
	L.polymorph_bomb = "鸭子"
	L.polymorph_bomb_single = "鸭子"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "zhCN")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "焖燃窒息血量重复喊话"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "当你的血量低于75%时，持续喊话通报你的血量。"

	L.blazing_coalescence_on_player_note = "你获得时"
	L.blazing_coalescence_on_boss_note = "首领获得时"

	L.scorching_roots = "树根"
	L.blazing_thorns = "躲避"
	L.falling_embers = "接圈"
	L.fire_whirl = "火旋风"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "zhCN")
if L then
	L.mythic_add_death = "%s已击杀"

	L.continuum = "新矩阵"
	L.surging_growth = "新踩圈"
	L.ephemeral_flora = "踩红圈"
	L.viridian_rain = "翠绿之雨"
	L.threads = "丝线" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "zhCN")
if L then
	L.brand_of_damnation = "坦克分摊"
	L.lava_geysers = "喷泉"
	L.flame_waves = "旋风"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "zhCN")
if L then
	L.seed_soaked = "烈焰之种"
	L.all_seeds_soaked = "踩种子完毕!"
	L.blazing_mushroom = "蘑菇"
	L.fiery_growth = "炽热驱散" --炽热增生驱散后脚下大圈
	L.mass_entanglement = "藤蔓"
	L.incarnation_moonkin = "枭兽形态"
	L.incarnation_tree_of_flame = "树人形态"
	L.flaming_germination = "种子"
	L.suppressive_ember = "治疗吸收盾"
	L.suppressive_ember_single = "治疗吸收盾"
	L.flare_bomb = "羽毛"
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "zhCN")
if L then
	L.spirits_trigger = "卡多雷精魂"

	L.fyralaths_bite = "正面"
	L.fyralaths_bite_mythic = "正面"
	L.fyralaths_mark = "印记"
	L.darkflame_shades = "影子"
	L.darkflame_cleave = "分摊[史诗]"

	L.incarnate_intermission = "击飞"

	L.incarnate = "升空"
	L.molten_gauntlet = "重拳"
	L.mythic_debuffs = "牢笼" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "宏火风暴" -- G for Greater
	L.greater_firestorm_message_full = "宏火风暴"
	L.eternal_firestorm_shortened_bar = "永火风暴" -- E for Eternal
	L.eternal_firestorm_message_full = "永火风暴"

	L.eternal_firestorm_swirl = "旋火风暴[永火]"
	L.eternal_firestorm_swirl_desc = "显示永火风暴的旋火风暴计时器。"
	L.eternal_firestorm_swirl_bartext = "旋火"
end
