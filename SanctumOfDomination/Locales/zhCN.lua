local L = BigWigs:NewBossLocale("The Tarragrue", "zhCN")
if not L then return end
if L then
	L.chains = "锁链" -- Chains of Eternity (Chains)
	L.remnants = "残迹" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "物理残迹"
	L.magic_remnant = "魔法残迹"
	L.fire_remnant = "火焰残迹"
	L.fire = "火焰"
	L.magic = "魔法"
	L.physical = "物理"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "zhCN")
if L then
	L.chains = "锁链" -- Short for Dragging Chains
	L.pool = "黑水" -- Spreading Misery
	L.pools = "黑水" -- Spreading Misery (multiple)
	L.death_gaze = "死亡凝视" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "zhCN")
if L then
	L.fragments = "残片" -- Short for Fragments of Destiny
	L.fragment = "残片" -- Singular Fragment of Destiny
	L.run_away = "跑开" -- Wings of Rage
	L.song = "歌" -- Short for Song of Dissolution
	L.go_in = "靠近" -- Reverberating Refrain
	L.valkyr = "瓦格里" -- Short for Call of the Val'kyr
	L.blades = "刃" -- Agatha's Eternal Blade
	L.big_bombs = "大炸弹" -- Daschla's Mighty Impact
	L.big_bomb = "大炸弹" -- Attached to the countdown
	L.shield = "盾" -- Annhylde's Bright Aegis
	L.soaks = "泡" -- Aradne's Falling Strike
	L.small_bombs = "小炸弹" -- Brynja's Mournful Dirge
	L.recall = "召回" -- Short for Word of Recall

	--L.blades_yell = "Fall before my blade!"
	--L.soaks_yell = "You are all outmatched!"
	--L.shield_yell = "My shield never falters!"

	L.berserk_stage1 = "狂暴阶段1"
	L.berserk_stage2 = "狂暴阶段2"

	L.image_special = "%s [斯凯亚]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "zhCN")
if L then
	L.cones = "障碍" -- Grasp of Malice
	L.orbs = "宝珠" -- Orb of Torment
	L.orb = "宝珠" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "zhCN")
if L then
	L.custom_off_nameplate_defiance = "蔑视姓名板图标"
	L.custom_off_nameplate_defiance_desc = "在渊誓怪有蔑视时在姓名板显示图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"

	L.custom_off_nameplate_tormented = "饱受磨难姓名板图标"
	L.custom_off_nameplate_tormented_desc = "在渊誓怪有饱受磨难时在姓名板显示图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"

	L.cones = "障碍" -- Torment
	L.dance = "跳舞" -- Encore of Torment
	L.brands = "烙印" -- Brand of Torment
	L.brand = "烙印" -- Single Brand of Torment
	L.spike = "尖刺" -- Short for Agonizing Spike
	L.chains = "锁链" -- Hellscream
	L.chain = "锁链" -- Soul Manacles
	L.souls = "灵魂" -- Rendered Soul

	L.chains_remaining = "%d锁链剩余"
	L.all_broken = "全部锁链已破坏"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "zhCN")
if L then
	L.hammer = "铁锤" -- Short for Reverberating Hammer
	L.axe = "刃斧" -- Short for Cruciform Axe
	L.scythe = "镰刀" -- Short for Dualblade Scythe
	L.trap = "陷阱" -- Short for Flameclasp Trap
	L.chains = "锁链" -- Short for Shadowsteel Chains
	L.embers = "余烬" -- Short for Shadowsteel Embers
	L.adds_embers = "余烬 (%d) - 下一波恐魔!"
	L.adds_killed = "击杀恐魔，用时 %.2f秒"
	L.spikes = "狂暴时限" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "zhCN")
if L then
	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "卫士可能延迟他的技能。当启用此选项，他的技能条将停留在屏幕上。"

	-- L.bomb_missed = "%dx 炸弹未击中"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "zhCN")
if L then
	L.rings = "织环"
	L.rings_active = "织环已激活" -- for when they activate/are movable
	L.runes = "符文"

	L.grimportent_countdown = "冷却"
	L.grimportent_countdown_desc = "受到恐怖征兆的玩家冷却"
	L.grimportent_countdown_bartext = "快去符文！"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhCN")
if L then
	L.spikes = "尖刺" -- Short for Glacial Spikes
	L.spike = "尖刺"
	L.miasma = "瘴气" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "追击姓名板图标"
	L.custom_on_nameplate_fixate_desc = "霜缚狂热者追击你时在姓名板显示一个图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "zhCN")
if L then
	L.chains_active = "锁链已激活"
	L.chains_active_desc = "当统御锁链激活时显示计时条。"

	L.custom_on_nameplate_fixate = "追击姓名板图标"
	L.custom_on_nameplate_fixate_desc = "黑暗哨兵追击你时在姓名板显示一个图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"

	L.chains = "锁链" -- Short for Domination Chains
	L.chain = "锁链" -- Single Domination Chain
	L.darkness = "黑暗" -- Short for Veil of Darkness
	L.arrow = "箭" -- Short for Wailing Arrow
	L.wave = "妖魂" -- Short for Haunting Wave
	L.dread = "压迫" -- Short for Crushing Dread
	L.orbs = "宝珠" -- Dark Communion
	L.curse = "诅咒" -- Short for Curse of Lethargy
	L.pools = "池" -- Banshee's Bane
	L.scream = "尖啸" -- Banshee Scream

	L.knife_fling = "刀飞出！" -- "Death-touched blades fling out"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "zhCN")
if L then
	L.custom_on_bar_icon = "条形图标"
	L.custom_on_bar_icon_desc = "显示宿命之力条形图标."

	L.chaotic_essence = "精华"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	L.reconfiguration_emitter = "打断小怪"
end
