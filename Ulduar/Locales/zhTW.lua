
local L = BigWigs:NewBossLocale("Algalon the Observer", "zhTW")
if L then
	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"
	L.engage_warning = "第一階段！"
	L.phase2_warning = "即將 第二階段！"
	L.phase_bar = "<階段%d>"
	L.engage_trigger = "你的行為毫無意義。這場沖突的結果早已計算出來了。不論結局為何，萬神殿仍將收到觀察者的訊息。"

	L.punch_message = "相位拳擊%2$d層： >%1$s<！"
	L.smash_message = "即將 宇宙潰擊！"
	L.blackhole_message = "黑洞爆炸：>%dx< 出現！"
	L.bigbang_bar = "<下一大爆炸>"
	L.bigbang_soon = "即將 大爆炸！"

	L.end_trigger = "我曾經看過塵世沉浸在造物者的烈焰之中"
end

L = BigWigs:NewBossLocale("Auriaya", "zhTW")
if L then
	L.engage_trigger = "有些事情不該公諸於世!"

	L.fear_warning = "即將 恐嚇尖嘯！"
	L.fear_message = "正在施放 恐嚇尖嘯！"
	L.fear_bar = "<恐嚇尖嘯 冷卻>"

	L.swarm_message = "守護貓群"
	L.swarm_bar = "<守護貓群 冷卻>"

	L.defender = "野性防衛者"
	L.defender_desc = "當野性防衛者出現時發出警報。"
	L.defender_message = "野性防衛者（%d/9）！"

	L.sonic_bar = "<音速尖嘯>"
end

L = BigWigs:NewBossLocale("Freya", "zhTW")
if L then
	L.engage_trigger1 = "必須守護大溫室!"
	L.engage_trigger2 = "長者們，賦予我你們的力量!"

	L.phase = "階段"
	L.phase_desc = "當進入不同階段發出警報。"
	L.phase2_message = "第二階段！"

	L.wave = "波"
	L.wave_desc = "當一波小怪時發出警報。"
	L.wave_bar = "<下一波>"
	L.conservator_trigger = "伊歐娜，你的僕從需要協助!"
	L.detonate_trigger = "元素們將襲捲你們!"
	L.elementals_trigger = "孩子們，協助我!"
	L.tree_trigger = "一個|cFF00FFFF生命守縛者之禮|r開始生長!"
	L.conservator_message = "古樹護存者！"
	L.detonate_message = "引爆鞭笞者！"
	L.elementals_message = "上古水之靈！"

	L.tree = "伊歐娜的贈禮"
	L.tree_desc = "當芙蕾雅召喚伊歐娜的贈禮時發出警報。"
	L.tree_message = "伊歐娜的贈禮 出現！"

	L.fury_message = "自然烈怒"
	L.fury_other = "自然烈怒：>%s<！"

	L.tremor_warning = "即將 地面震顫！"
	L.tremor_bar = "<下一地面震顫>"
	L.energy_message = ">你< 不穩定的能量！"
	L.sunbeam_message = "即將 太陽光束！"
	L.sunbeam_bar = "<下一太陽光束>"

	L.end_trigger = "他對我的操控已然退散。我已再次恢復神智了。感激不盡，英雄們。"
end

L = BigWigs:NewBossLocale("Hodir", "zhTW")
if L then
	L.engage_trigger = "你將為擅闖付出代價!"

	L.cold = "刺骨之寒（成就）"
	L.cold_desc = "當你受到2層刺骨之寒效果時發出警報。"
	L.cold_message = "刺骨之寒（%d層） - 移動！"

	L.flash_warning = "閃霜！"
	L.flash_soon = "5秒後，閃霜！"

	L.hardmode = "困難模式"
	L.hardmode_desc = "顯示困難模式計時器。"

	L.end_trigger = "我…我終於從他的掌控中…解脫了。"
end

L = BigWigs:NewBossLocale("Ignis the Furnace Master", "zhTW")
if L then
	L.engage_trigger = "傲慢的小傢伙!你們的鮮血將會用來淬鍊重奪世界的武器!"

	L.construct_message = "即將 鐵之傀儡！"
	L.construct_bar = "<下一鐵之傀儡>"
	L.brittle_message = "鐵之傀儡 - 脆裂！"
	L.flame_bar = "<烈焰噴洩 冷卻>"
	L.scorch_message = ">你< 灼燒！"
	L.scorch_soon = "約5秒後，灼燒！"
	L.scorch_bar = "<下一灼燒>"
	L.slagpot_message = "熔渣之盆：>%s<！"
end

L = BigWigs:NewBossLocale("The Iron Council", "zhTW")
if L then
	L.engage_trigger1 = "你們別妄想擊潰鐵之集會，入侵者!"
	L.engage_trigger2 = "只有全面屠殺才能滿足我。"
	L.engage_trigger3 = "不管你是世界第一流的小卒，或是首屈一指的英雄人物，充其量也不過是個凡人罷了。"

	L.overload_message = "6秒後，超載！"
	L.death_message = ">你< 死亡符文！"
	L.summoning_message = "閃電元素即將出現！"

	L.chased_other = "閃電觸鬚：>%s<！"
	L.chased_you = ">你< 閃電觸鬚！"

	L.overwhelm_other = "極限威能：>%s<！"

	L.shield_message = "符文護盾！"

	L.council_dies = "%s被擊敗了！"
end

L = BigWigs:NewBossLocale("Kologarn", "zhTW")
if L then
	L.arm = "手臂死亡"
	L.arm_desc = "當左右手臂死亡時發出警報。"
	L.left_dies = "左臂死亡！"
	L.right_dies = "右臂死亡！"
	L.left_wipe_bar = "<左臂重生>"
	L.right_wipe_bar = "<右臂重生>"

	L.shockwave = "震攝波"
	L.shockwave_desc = "當震攝波到來前發出警報。"
	L.shockwave_trigger = "滅亡吧!"

	L.eyebeam = "集束目光"
	L.eyebeam_desc = "當玩家中了集束目光時發出警報。"
	L.eyebeam_trigger = "%s正在注視著你!"
	L.eyebeam_message = "集束目光：>%s<！"
	L.eyebeam_bar = "<集束目光>"
	L.eyebeam_you = ">你< 集束目光！"
	L.eyebeam_say = ">我< 集束目光！"

	L.eyebeamsay = "集束目光"
	L.eyebeamsay_desc = "當你中了集束目光時發出自身警報。"

	L.armor_message = "粉碎護甲%2$d層：>%1$s<！"
end

L = BigWigs:NewBossLocale("Flame Leviathan", "zhTW")
if L then
	L.engage_trigger = "發現敵意實體。啟動威脅評估協定。首要目標接近中。30秒後將再度評估。"
	L.engage_message = "%s已狂怒！"

	L.pursue = "獵殺"
	L.pursue_desc = "當烈焰戰輪獵殺玩家時發出警報。"
	L.pursue_trigger = "^%%s緊追"
	L.pursue_other = "烈焰戰輪獵殺：>%s<！"

	L.shutdown_message = "系統關閉！"
end

L = BigWigs:NewBossLocale("Mimiron", "zhTW")
if L then
	L.phase = "階段"
	L.phase_desc = "當進入不同階段發出警報。"
	L.engage_warning = "第一階段！"
	L.engage_trigger = "我們沒有太多時間，朋友們!你們要幫我測試我最新也是最偉大的創作。在你們改變心意之前，別忘了就是你們把XT-002搞得一團糟，你們欠我一次。"
	L.phase2_warning = "即將 第二階段！"
	L.phase2_trigger = "太好了!絕妙的良好結果!外殼完整度98.9%!幾乎只有一點擦痕!繼續下去。"
	L.phase3_warning = "即將 第三階段！"
	L.phase3_trigger = "感謝你，朋友們!我們的努力讓我獲得了一些絕佳的資料!現在，我把東西放在哪兒了--噢，在這裡。"
	L.phase4_warning = "即將 第四階段！"
	L.phase4_trigger = "初步測試階段完成。現在要玩真的啦!"
	L.phase_bar = "<階段：%d>"

	L.hardmode = "困難模式計時器"
	L.hardmode_desc = "顯示困難模式計時器。"
	L.hardmode_trigger = "為什麼你要做出這種事?難道你沒看見標示上寫著「請勿觸碰這個按鈕!」嗎?現在自爆裝置已經啟動了，我們要怎麼完成測試呢?"
	L.hardmode_message = "已開啟困難模式！"
	L.hardmode_warning = "困難模式結束！"

	L.plasma_warning = "正在施放 離子衝擊！"
	L.plasma_soon = "即將 離子衝擊！"
	L.plasma_bar = "<離子沖擊>"

	L.shock_next = "下一震爆！"

	L.laser_soon = "即將 P3Wx2雷射彈幕！"
	L.laser_bar = "<P3Wx2雷射彈幕>"

	L.magnetic_message = "空中指揮裝置 已降落！"

	L.suppressant_warning = "即將 熾焰抑制劑！"

	L.fbomb_soon = "可能即將 冰霜炸彈！"
	L.fbomb_bar = "<下一冰霜炸彈>"

	L.bomb_message = "炸彈機器人 出現！"

	L.end_trigger = "看來我還是產生了些許計算錯誤。任由我的心智受到囚牢中魔鬼的腐化，棄我的首要職責於不顧。所有的系統看起來都正常運作。報告完畢。"
end

L = BigWigs:NewBossLocale("Razorscale", "zhTW")
if L then
	L["Razorscale Controller"] = "銳鱗控制器"

	L.phase = "階段"
	L.phase_desc = "當銳鱗轉換不同階段發出警報。"
	L.ground_trigger = "快!她可不會在地面上待太久!"
	L.ground_message = "銳鱗被鎖住了！"
	L.air_trigger = "給我們一點時間來準備建造砲塔。"
	L.air_trigger2 = "火熄了!讓我們重建砲塔!"
	L.air_message = "起飛！"
	L.phase2_trigger = "%s再也飛不動了!"
	L.phase2_message = "第二階段！"
	L.phase2_warning = "即將 第二階段！"
	L.stun_bar = "<擊昏>"

	L.breath_trigger = "%s深深地吸了一口氣……"
	L.breath_message = "火息術！"
	L.breath_bar = "<火息術 冷卻>"

	L.flame_message = ">你< 吞噬烈焰！"

	L.harpoon = "魚叉炮塔"
	L.harpoon_desc = "當魚叉炮塔可用時發出警報。"
	L.harpoon_message = "魚叉炮塔：>%d<可用！"
	L.harpoon_trigger = "魚叉砲塔已經準備就緒!"
	L.harpoon_nextbar = "<魚叉炮塔：%d>"
end

L = BigWigs:NewBossLocale("Thorim", "zhTW")
if L then
	L.phase = "階段"
	L.phase_desc = "當進入不同階段發出警報。"
	L.phase1_message = "第一階段！"
	L.phase2_trigger = "擅闖者!像你們這種膽敢干涉我好事的凡人將付出…等等--你……"
	L.phase2_message = "第二階段 - 6分15秒後，狂暴！"
	L.phase3_trigger = "無禮的小輩，你竟敢在我的王座之上挑戰我?我會親手碾碎你們!"
	L.phase3_message = "第三階段 - 索林姆已狂怒！"

	L.hardmode = "困難模式"
	L.hardmode_desc = "顯示困難模式計時器。"
	L.hardmode_warning = "困難模式結束！"

	L.shock_message = ">你< 閃電震擊！移動！"
	L.barrier_message = "符文巨像 - 符刻屏障！"

	L.detonation_say = "我是炸彈！"

	L.charge_message = "閃電能量：>%d<！"
	L.charge_bar = "<閃電能量：%d>"

	L.strike_bar = "<失衡打擊 冷卻>"

	L.end_trigger = "住手!我認輸了!"
end

L = BigWigs:NewBossLocale("General Vezax", "zhTW")
if L then
	L["Vezax Bunny"] = "Vezax Bunny" -- For emote catching.

	L.engage_trigger = "你的毀滅將會預告一個嶄新苦難時代的來臨!"

	L.surge_message = "暗鬱奔騰：>%d<！"
	L.surge_cast = "正在施放 暗鬱奔騰：>%d<！"
	L.surge_bar = "<暗鬱奔騰：%d>"

	L.animus = "薩倫聚惡體"
	L.animus_desc = "當薩倫聚惡體出現時發出警報。"
	L.animus_trigger = "薩倫煙霧聚集起來并且劇烈地旋轉，形成一個怪物般的形體!"
	L.animus_message = "薩倫聚惡體 出現！"

	L.vapor = "薩倫煙霧"
	L.vapor_desc = "當薩倫煙霧出現時發出警報。"
	L.vapor_message = "薩倫煙霧：>%d<！"
	L.vapor_bar = "<薩倫煙霧：%d/6>"
	L.vapor_trigger = "一片薩倫煙霧在附近聚合!"

	L.vaporstack = "薩倫煙霧堆疊"
	L.vaporstack_desc = "當玩家中了5層或更多薩倫煙霧時發出警報。"
	L.vaporstack_message = "薩倫煙霧：>x%d<！"

	L.crash_say = ">我< 暗影暴擊！"

	L.mark_message = "無面者印記"
	L.mark_message_other = "無面者印記：>%s<！"
end

L = BigWigs:NewBossLocale("XT-002 Deconstructor", "zhTW")
if L then
	L.exposed_warning = "即將 機心外露！"
	L.exposed_message = "機心外露！"

	L.gravitybomb_other = "重力彈：>%s<！"

	L.lightbomb_other = "灼熱之光：>%s<！"

	L.tantrum_bar = "<躁怒 冷卻>"
end

L = BigWigs:NewBossLocale("Yogg-Saron", "zhTW")
if L then
	L["Crusher Tentacle"] = "粉碎觸手"
	L["The Observation Ring"] = "觀察之環"

	L.phase = "階段"
	L.phase_desc = "當階段改變發出警報。"
	L.engage_warning = "第一階段"
	L.engage_trigger = "我們即將有機會打擊怪物的首腦!現在將你的憤怒與仇恨貫注在他的爪牙上!"
	L.phase2_warning = "第二階段！"
	L.phase2_trigger = "我是清醒的夢境。"
	L.phase3_warning = "第三階段！"
	L.phase3_trigger = "在我的真身面前顫抖吧。" --看看死亡的真實面貌，瞭解你們的末日降臨了!

	L.portal = "傳送門"
	L.portal_desc = "當傳送門時發出警報。"
	L.portal_trigger = "傳送門開啟進入%s的心靈!"
	L.portal_message = "開啟傳送門！"
	L.portal_bar = "<下一傳送門>"

	L.fervor_cast_message = "正在施放 薩拉的熱誠：>%s<！"
	L.fervor_message = "薩拉的熱誠：>%s<！"

	L.sanity_message = ">你< 即將瘋狂！！"

	L.weakened = "昏迷"
	L.weakened_desc = "當尤格薩倫昏迷時發出警報。"
	L.weakened_message = "昏迷：>%s<！"
	L.weakened_trigger = "幻影粉碎，然後中央房間的道路就打開了!"

	L.madness_warning = "5秒後，瘋狂誘陷！"
	L.malady_message = "心靈缺陷：>%s<！"

	L.tentacle = "粉碎觸手"
	L.tentacle_desc = "當粉碎觸手出現時發出警報。"
	L.tentacle_message = "粉碎觸手：>%d<！"

	L.link_warning = ">你< 腦波連結！"

	L.gaze_bar = "<癡狂凝視 冷卻>"
	L.empower_bar = "<暗影信標 冷卻>"

	L.guardian_message = "尤格薩倫守護者：>%d<！ "

	L.empowericon_message = "暗影信標 消失！"

	L.roar_warning = "5秒後，震耳咆哮！"
	L.roar_bar = "<下一震耳咆哮>"
end
