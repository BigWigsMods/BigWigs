local L = BigWigs:NewBossLocale("The Tarragrue", "zhTW")
if not L then return end
if L then
	L.chains = "鎖鏈" -- Chains of Eternity (Chains)
	L.remnants = "殘留" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "物理殘留" -- 待定，可以改成更簡單的「物理球/魔法球/火焰球」
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
	L.soaks = "接圈" -- Aradne's Falling Strike; 待定，原文是soak，這是習慣用語差異
	L.small_bombs = "小炸彈" -- Brynja's Mournful Dirge; 待定
	L.recall = "撤回" -- Short for Word of Recall; 待定，召回、撤回、或者取消？

	--L.blades_yell = "Fall before my blade!"
	--L.soaks_yell = "You are all outmatched!"
	--L.shield_yell = "My shield never falters!"

	L.berserk_stage1 = "狂暴階段一"
	L.berserk_stage2 = "狂暴階段二"

	L.image_special = "%s [斯凱雅]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "zhTW")
if L then
	-- L.cones = "Cones" -- Grasp of Malice
	L.orbs = "寶珠" -- Orb of Torment
	L.orb = "寶珠" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "zhTW")
if L then
	L.custom_off_nameplate_defiance = "反抗名條圖示"
	L.custom_off_nameplate_defiance_desc = "在獲得反抗效果強化的小怪名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"
	
	L.custom_off_nameplate_tormented = "烙印名條圖示"
	L.custom_off_nameplate_tormented_desc = "在受到折磨烙印影響的小怪名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	-- L.cones = "Cones" -- Torment
	L.dance = "跳舞" -- Encore of Torment
	L.brands = "烙印" -- Brand of Torment
	L.brand = "烙印" -- Single Brand of Torment
	-- L.spike = "Spike" -- Short for Agonizing Spike
	L.chains = "鎖鏈" -- Hellscream
	L.chain = "鎖鏈" -- Soul Manacles
	L.souls = "靈魂" -- Rendered Soul

	L.chains_remaining = "還剩 %d 條鎖鏈"
	L.all_broken = "鎖鏈已全部拉斷"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "zhTW")
if L then
	-- L.hammer = "Hammer" -- Short for Rippling Hammer
	-- L.axe = "Axe" -- Short for Cruciform Axe
	-- L.scythe = "Scythe" -- Short for Dualblade Scythe
	-- L.trap = "Trap" -- Short for Flameclasp Trap
	-- L.chains = "Chains" -- Short for Shadowsteel Chains
	-- L.ember = "Ember" -- Short for Shadowsteel Ember
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "zhTW")
if L then
	L.custom_on_stop_timers = "總是顯示計時器"
	L.custom_on_stop_timers_desc = "守護者的技能可能延遲施放。啟用此選項後，這些技能的計時條會保持顯示。"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "zhTW")
if L then
	-- L.rings = "Rings"
	-- L.rings_active = "Rings Active" -- for when they activate/are movable
	-- L.runes = "Runes"

	-- L.grimportent_countdown = "Countdown"
	-- L.grimportent_countdown_desc = "Countdown for the players who are Affected by Grim Portent"
	-- L.grimportent_countdown_bartext = "Go to rune!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhTW")
if L then
	-- L.spikes = "Spikes" -- Short for Glacial Spikes
	-- L.spike = "Spike"
	-- L.miasma = "Miasma" -- Short for Sinister Miasma

	-- L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frostbound Devoted that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "zhTW")
if L then
	L.chains_active = "鎖鏈生效"
	-- L.chains_active_desc = "Show a bar for when the Chains of Domination activate"
	-- L.chains_active_bartext = "%d Active" -- Chains Active

	-- L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Dark Sentinels that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	L.chains = "鎖鏈" -- Short for Domination Chains
	L.chain = "鎖鏈" -- Single Domination Chain
	L.darkness = "黑暗" -- Short for Veil of Darkness
	L.arrow = "悲鳴箭" -- Short for Wailing Arrow; 夠短了所以在中文不需要縮寫
	-- L.wave = "Wave" -- Short for Haunting Wave
	L.dread = "碎擊" -- Short for Crushing Dread; 可能要改
	L.orbs = "球" -- Dark Communion; 可能要改
	L.curse = "組咒" -- Short for Curse of Lethargy
	L.pools = "災禍" -- Banshee's Bane
	L.scream = "Scream" -- Banshee Scream

	-- L.knife_fling = "Knives out!" -- "Death-touched blades fling out"
end

