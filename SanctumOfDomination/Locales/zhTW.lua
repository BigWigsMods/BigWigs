local L = BigWigs:NewBossLocale("The Tarragrue", "zhTW")
if not L then return end
if L then
	L.chains = "鎖鏈" -- Chains of Eternity (Chains)
	L.remnants = "殘留" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "物理殘留"
	L.magic_remnant = "魔法殘留"
	L.fire_remnant = "火焰殘留"
	L.fire = "火焰"
	L.magic = "魔法"
	L.physical = "物理"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "zhTW")
if L then
	L.chains = "鎖鏈" -- Short for Dragging Chains
	L.pool = "黑水" -- Spreading Misery
	L.pools = "黑水" -- Spreading Misery (multiple)
	L.death_gaze = "死亡凝視" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "zhTW")
if L then
	L.fragments = "碎片" -- Short for Fragments of Destiny
	L.fragment = "碎片" -- Singular Fragment of Destiny
	L.run_away = "跑開" -- Wings of Rage
	L.song = "唱歌" -- Short for Song of Dissolution
	L.go_in = "靠近" -- Reverberating Refrain
	L.valkyr = "華爾琪" -- Short for Call of the Val'kyr
	L.blades = "飛刀" -- Agatha's Eternal Blade
	L.big_bombs = "大炸彈" -- Daschla's Mighty Impact; 待定
	L.big_bomb = "大炸彈" -- Attached to the countdown; 待定
	L.shield = "減傷盾" -- Annhylde's Bright Aegis; 待定
	L.soaks = "接圈" -- Aradne's Falling Strike
	L.small_bombs = "小炸彈" -- Brynja's Mournful Dirge; 待定
	L.recall = "撤回" -- Short for Word of Recall; 待定，召回、撤回、或者取消？

	L.blades_yell = "死在我的利刃之下！"
	L.soaks_yell = "你們毫無勝算！"
	L.shield_yell = "我的盾堅不可摧！"

	L.berserk_stage1 = "狂暴階段一"
	L.berserk_stage2 = "狂暴階段二"

	L.image_special = "%s [斯凱雅]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "zhTW")
if L then
	L.cones = "射線" -- Grasp of Malic
	L.orbs = "寶珠" -- Orb of Torment
	L.orb = "寶珠" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "zhTW")
if L then
	L.custom_off_nameplate_defiance = "反抗名條圖示"
	L.custom_off_nameplate_defiance_desc = "在獲得反抗效果強化的小怪名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	L.custom_off_nameplate_tormented = "烙印名條圖示"
	L.custom_off_nameplate_tormented_desc = "在受到折磨烙印影響的小怪名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	L.cones = "折磨" -- Torment
	L.dance = "跳舞" -- Encore of Torment
	L.brands = "烙印" -- Brand of Torment
	L.brand = "烙印" -- Single Brand of Torment
	L.spike = "尖刺" -- Short for Agonizing Spike
	L.chains = "鎖鏈" -- Hellscream
	L.chain = "鎖鏈" -- Soul Manacles
	L.souls = "靈魂" -- Rendered Soul

	L.chains_remaining = "還剩 %d 條鎖鏈"
	L.all_broken = "鎖鏈已全部拉斷"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "zhTW")
if L then
	L.hammer = "迴盪錘" -- Short for Rippling Hammer
	L.axe = "十字斧" -- Short for Cruciform Axe
	L.scythe = "雙刃鐮" -- Short for Dualblade Scythe
	L.trap = "陷阱" -- Short for Flameclasp Trap
	L.chains = "鎖鏈" -- Short for Shadowsteel Chains
	L.embers = "餘燼" -- Short for Shadowsteel Embers
	L.adds_embers = "餘燼（%d）：下一波懼魔！"
	L.adds_killed = "擊殺懼魔，用時%.2f秒"
	L.spikes = "狂暴時限" -- Soft enrage spikes; 尖刺軟狂暴時限
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "zhTW")
if L then
	L.custom_on_stop_timers = "總是顯示計時器"
	L.custom_on_stop_timers_desc = "守護者的技能可能延遲施放。啟用此選項後，這些技能的計時條會保持顯示。"

	L.bomb_missed = "%dx炸彈未擊中" -- 圈沒有去石柱給能量的提示，格式好像不對，可能要修
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "zhTW")
if L then
	L.rings = "圓環"
	L.rings_active = "圓環啟動" -- for when they activate/are movable
	L.runes = "符文"

	L.grimportent_countdown = "倒數"
	L.grimportent_countdown_desc = "為受到恐怖惡兆的玩家顯示倒數技時。"
	L.grimportent_countdown_bartext = "去找符文！"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhTW")
if L then
	L.spikes = "冰刺" -- Short for Glacial Spikes
	L.spike = "冰刺"
	L.miasma = "瘴氣" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "索命追擊名條圖示"
	L.custom_on_nameplate_fixate_desc = "在追擊你的霜縛效忠者名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "zhTW")
if L then
	L.chains_active = "鎖鏈啟動"
	L.chains_active_desc = "顯示鎖鏈開始鏈住玩家的倒數計時器。"

	L.custom_on_nameplate_fixate = "憤怒名條圖示"
	L.custom_on_nameplate_fixate_desc = "在追擊你的黑暗哨兵名條上顯示追擊圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	L.chains = "鎖鏈" -- Short for Domination Chains
	L.chain = "鎖鏈" -- Single Domination Chain
	L.darkness = "黑暗" -- Short for Veil of Darkness
	L.arrow = "悲鳴箭" -- Short for Wailing Arrow
	L.wave = "波浪" -- Short for Haunting Wave
	L.dread = "碎擊" -- Short for Crushing Dread
	L.orbs = "球" -- Dark Communion; 可能要改
	L.curse = "詛咒" -- Short for Curse of Lethargy
	L.pools = "災禍" -- Banshee's Bane
	L.scream = "號叫" -- Banshee Scream

	L.knife_fling = "飛刀！" -- "Death-touched blades fling out"; 傳奇模式的死亡利刃射出計時
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "zhTW")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	--L.reconfiguration_emitter = "Interrupt Add"
end
