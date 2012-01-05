local L = BigWigs:NewBossLocale("Morchok", "zhTW")
if not L then return end
if L then
	L.engage_trigger = "你想要阻止山崩。我會埋葬你。"

	L.crush = "擊碎護甲"
	L.crush_desc = "只警報坦克。擊碎護甲堆疊計數並顯示持續條。"
	L.crush_message = "%2$d層擊碎護甲：>%1$s<！"

	L.blood = "大地黑血"

	L.explosion = "爆炸水晶"
	L.crystal = "Crystal"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "zhTW")
if L then
	L.engage_trigger = "Zzof Shuul'wah. Thoq fssh N'Zoth!"

	L.ball = "壞滅虛無"
	L.ball_desc = "壞滅虛無在玩家和首領之間來回彈跳時發出警報。"

	L.bounce = "壞滅虛無彈跳"
	L.bounce_desc = "壞滅虛無彈跳計數。"

	L.darkness = "觸鬚迪斯可聚會！"
	L.darkness_desc = "當此階段開始，壞滅虛無撞擊首領。"

	L.shadows = "崩解之影"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "zhTW")
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar! H'IWN IILTH!"

	L.bolt_desc = "只警報坦克。虛無箭堆疊計數並顯示持續條。"
	L.bolt_message = "%2$d層虛無箭：>%1$s<！"

	L.blue = "|cFF0080FF藍|r"
	L.green = "|cFF088A08綠|r"
	L.purple = "|cFF9932CD紫|r"
	L.yellow = "|cFFFFA901黃|r"
	L.black = "|cFF424242黑|r"
	L.red = "|cFFFF0404紅|r"

	L.blobs = "血珠"
	L.blobs_bar = "下一血珠"
	L.blobs_desc = "當血珠向首領移動時發出警報。"
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "zhTW")
if L then
	L.engage_trigger = "你們惹毛暴風守縛者了!我要殺光你們。"

	L.lightning_or_frost = "閃電或寒冰"
	L.ice_next = "寒冰階段"
	L.lightning_next = "閃電階段"

	L.assault_desc = "只警報坦克。"..select(2, EJ_GetSectionInfo(4159))

	L.nextphase = "下一階段"
	L.nextphase_desc = "當下一階段時發出警報。"
end

L = BigWigs:NewBossLocale("Ultraxion", "zhTW")
if L then
	L.engage_trigger = "現在就是暮光之時!"

	L.warmup = "暮光之時"
	L.warmup_desc = "暮光之時计时器。"
	L.warmup_trigger = "我是終結的開始...遮掩陽光的印跡...通知末日將臨的鈴聲..."

	L.crystal = "增益水晶"
	L.crystal_desc = "守護巨龍召喚各種增益水晶計時器。"
	L.crystal_red = "生命賜福紅水晶"
	L.crystal_green = "夢之精華綠水晶"
	L.crystal_blue = "魔力之源藍水晶"

	L.twilight = "暮光之時"
	L.cast = "暮光之時施法條"
	L.cast_desc = "顯示暮光之時5秒施法條。"

	L.lightself = "自身凋零之光"
	L.lightself_desc = "顯示自身凋零之光爆炸剩餘計時條。"
	L.lightself_bar = "<你將爆炸>"

	L.lighttank = "坦克凋零之光"
	L.lighttank_desc = "只警報坦克。如果坦克中了凋零之光，顯示一個爆炸計時條及閃爍震動。"
	L.lighttank_bar = "<%s 爆炸>"
	L.lighttank_message = "坦克爆炸！"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "zhTW")
if L then
	L.warmup = "熱身"
	L.warmup_desc = "首領戰鬥開始之前的計時器。"
	L.warmup_trigger = "全速前進。一切都仰賴我們的速度!不能讓毀滅者逃走。"

	L.sunder = "破甲攻擊"
	L.sunder_desc = "只警報坦克。破甲攻擊堆疊計數並顯示持續條。"
	L.sunder_message = "%2$d層破甲攻擊：>%1$s<！"

	L.sapper_trigger = "一頭龍急速飛來，載送一名暮光工兵降落到甲板上!"
	L.sapper = "暮光工兵"
	L.sapper_desc = "暮光工兵對天火號造成傷害。"

	L.stage2_trigger = "看來我得自己動手。好極了!"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "zhTW")
if L then
	L.left_start = "即將左側翻滾"
	L.right_start = "即將右側翻滾"
	L.left = "左側翻滾"
	L.right = "右側翻滾"
	L.not_hooked = ">你< 沒有抓牢！"
	L.roll_message = "他開始滾了，滾了，滾啦！"
	L.level_trigger = "平衡"
	L.level_message = "別急，他已經平衡了！"

	L.exposed = "裝甲暴露"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "zhTW")
if L then
	L.engage_trigger = "你們都徒勞無功。我會撕裂你們的世界。"
	L.impale_desc = "只警報坦克。"..select(2,EJ_GetSectionInfo(4114))
	L.bolt_explode = "<源質箭爆炸>"
	L.parasite = "腐化寄生體"
	L.blobs_soon = "%d%% - 即將凝結之血！"
end

