if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Algalon", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",
	engage_warning = "第一階段！",
	phase2_warning = "即將 第二階段！",
	phase_bar = "<階段%d>",
	engage_trigger = "你的行為毫無意義。這場沖突的結果早已計算出來了。不論結局為何，萬神殿仍將收到觀察者的訊息。",

	punch_message = "相位拳擊%2$d層： >%1$s<！",
	smash_message = "即將 宇宙潰擊！",
	blackhole_message = "黑洞爆炸：>%dx< 出現！",
	bigbang_soon = "即將 大爆炸！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Auriaya", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	fear_warning = "即將 恐嚇尖嘯！",
	fear_message = "正在施放 恐嚇尖嘯！",
	fear_bar = "<恐嚇尖嘯 冷卻>",

	swarm_message = "守護貓群",
	swarm_bar = "<守護貓群 冷卻>",

	defender = "野性防衛者",
	defender_desc = "當野性防衛者出現時發出警報。",
	defender_message = "野性防衛者（%d/9）！",

	sonic_bar = "<音速尖嘯>",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Freya", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "必須守護大溫室!",
	engage_trigger2 = "長者們，賦予我你們的力量!",

	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	phase2_message = "第二階段！",

	wave = "波",
	wave_desc = "當一波小怪時發出警報。",
	wave_bar = "<下一波>",
	conservator_trigger = "伊歐娜，你的僕從需要協助!",
	detonate_trigger = "元素們將襲捲你們!",
	elementals_trigger = "孩子們，協助我!",
	tree_trigger = "一個|cFF00FFFF生命守縛者之禮|r開始生長!",
	conservator_message = "古樹護存者！",
	detonate_message = "引爆鞭笞者！",
	elementals_message = "上古水之靈！",

	tree = "伊歐娜的贈禮",
	tree_desc = "當芙蕾雅召喚伊歐娜的贈禮時發出警報。",	
	tree_message = "伊歐娜的贈禮 出現！",

	fury_message = "自然烈怒",
	fury_other = "自然烈怒：>%s<！",

	tremor_warning = "即將 地面震顫！",
	tremor_bar = "<下一地面震顫>",
	energy_message = ">你< 不穩定的能量！",
	sunbeam_message = "即將 太陽光束！",
	sunbeam_bar = "<下一太陽光束>",

	icon = "位置標記",
	icon_desc = "為中了太陽光束的隊員打上團隊標記。（需要權限）",

	end_trigger = "他對我的操控已然退散。我已再次恢復神智了。感激不盡，英雄們。",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Hodir", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你將為擅闖付出代價!",

	cold = "刺骨之寒（成就）",
	cold_desc = "當你受到2層刺骨之寒效果時發出警報。",
	cold_message = "刺骨之寒（%d層） - 移動！",

	flash_warning = "閃霜！",
	flash_soon = "5秒後，閃霜！",

	hardmode = "困難模式",
	hardmode_desc = "顯示困難模式計時器。",

	icon = "團隊標記",
	icon_desc = "為中了風暴雷雲的隊員打上團隊標記。（需要權限）",

	end_trigger = "我…我終於從他的掌控中…解脫了。",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Ignis", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "傲慢的小傢伙!你們的鮮血將會用來淬鍊重奪世界的武器!",

	construct_message = "即將 鐵之傀儡！",
	construct_bar = "<下一鐵之傀儡>",
	brittle_message = "鐵之傀儡 - 脆裂！",
	flame_bar = "<烈焰噴洩 冷卻>",
	scorch_message = ">你< 灼燒！",
	scorch_soon = "約5秒後，灼燒！",
	scorch_bar = "<下一灼燒>",
	slagpot_message = "熔渣之盆：>%s<！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Iron Council", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "你們別妄想擊潰鐵之集會，入侵者!",
	engage_trigger2 = "只有全面屠殺才能滿足我。",
	engage_trigger3 = "不管你是世界第一流的小卒，或是首屈一指的英雄人物，充其量也不過是個凡人罷了。",

	overload_message = "6秒後，超載！",
	death_message = ">你< 死亡符文！",
	summoning_message = "閃電元素即將出現！",

	chased_other = "閃電觸鬚：>%s<！",
	chased_you = ">你< 閃電觸鬚！",

	overwhelm_other = "極限威能：>%s<！",

	shield_message = "符文護盾！",

	icon = "團隊標記",
	icon_desc = "為中了閃電觸鬚的隊員打上團隊標記。（需要權限）",

	council_dies = "%s被擊敗了！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kologarn", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	arm = "手臂死亡",
	arm_desc = "當左右手臂死亡時發出警報。",
	left_dies = "左臂死亡！",
	right_dies = "右臂死亡！",
	left_wipe_bar = "<左臂重生>",
	right_wipe_bar = "<右臂重生>",

	shockwave = "震攝波",
	shockwave_desc = "當震攝波到來前發出警報。",
	shockwave_trigger = "滅亡吧!",

	eyebeam = "集束目光",
	eyebeam_desc = "當玩家中了集束目光時發出警報。",
	eyebeam_trigger = "%s正在注視著你!",
	eyebeam_message = "集束目光：>%s<！",
	eyebeam_bar = "<集束目光>",
	eyebeam_you = ">你< 集束目光！",
	eyebeam_say = ">我< 集束目光！",

	eyebeamsay = "集束目光",
	eyebeamsay_desc = "當你中了集束目光時發出自身警報。",

	armor_message = "粉碎護甲%2$d層：>%1$s<！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "發現敵意實體。啟動威脅評估協定。首要目標接近中。30秒後將再度評估。",
	engage_message = "%s已狂怒！",

	pursue = "獵殺",
	pursue_desc = "當烈焰戰輪獵殺玩家時發出警報。",
	pursue_trigger = "^%%s緊追",
	pursue_other = "烈焰戰輪獵殺：>%s<！",

	shutdown_message = "系統關閉！",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Mimiron", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	engage_warning = "第一階段！",
	engage_trigger = "我們沒有太多時間，朋友們!你們要幫我測試我最新也是最偉大的創作。在你們改變心意之前，別忘了就是你們把XT-002搞得一團糟，你們欠我一次。",
	phase2_warning = "即將 第二階段！",
	phase2_trigger = "太好了!絕妙的良好結果!外殼完整度98.9%!幾乎只有一點擦痕!繼續下去。",
	phase3_warning = "即將 第三階段！",
	phase3_trigger = "感謝你，朋友們!我們的努力讓我獲得了一些絕佳的資料!現在，我把東西放在哪兒了--噢，在這裡。",
	phase4_warning = "即將 第四階段！",
	phase4_trigger = "初步測試階段完成。現在要玩真的啦!",
	phase_bar = "<階段：%d>",

	hardmode = "困難模式計時器",
	hardmode_desc = "顯示困難模式計時器。",
	hardmode_trigger = "為什麼你要做出這種事?難道你沒看見標示上寫著「請勿觸碰這個按鈕!」嗎?現在自爆裝置已經啟動了，我們要怎麼完成測試呢?",
	hardmode_message = "已開啟困難模式！",
	hardmode_warning = "困難模式結束！",

	plasma_warning = "正在施放 離子衝擊！",
	plasma_soon = "即將 離子衝擊！",
	plasma_bar = "<離子沖擊>",

	shock_next = "下一震爆！",

	laser_soon = "即將 P3Wx2雷射彈幕！",
	laser_bar = "<P3Wx2雷射彈幕>",

	magnetic_message = "空中指揮裝置 已降落！",

	suppressant_warning = "即將 熾焰抑制劑！",

	fbomb_soon = "可能即將 冰霜炸彈！",
	fbomb_bar = "<下一冰霜炸彈>",

	bomb_message = "炸彈機器人 出現！",

	end_trigger = "看來我還是產生了些許計算錯誤。任由我的心智受到囚牢中魔鬼的腐化，棄我的首要職責於不顧。所有的系統看起來都正常運作。報告完畢。",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Razorscale", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	["Razorscale Controller"] = "銳鱗控制器",

	phase = "階段",
	phase_desc = "當銳鱗轉換不同階段發出警報。",
	ground_trigger = "快!她可不會在地面上待太久!",
	ground_message = "銳鱗被鎖住了！",
	air_trigger = "給我們一點時間來準備建造砲塔。",
	air_trigger2 = "火熄了!讓我們重建砲塔!",
	air_message = "起飛！",
	phase2_trigger = "%s再也飛不動了!",
	phase2_message = "第二階段！",
	phase2_warning = "即將 第二階段！",
	stun_bar = "<擊昏>",

	breath_trigger = "%s深深地吸了一口氣……",
	breath_message = "火息術！",
	breath_bar = "<火息術 冷卻>",

	flame_message = ">你< 吞噬烈焰！",

	harpoon = "魚叉炮塔",
	harpoon_desc = "當魚叉炮塔可用時發出警報。",
	harpoon_message = "魚叉炮塔：>%d<可用！",
	harpoon_trigger = "魚叉砲塔已經準備就緒!",
	harpoon_nextbar = "<魚叉炮塔：%d>",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thorim", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	phase1_message = "第一階段！",
	phase2_trigger = "擅闖者!像你們這種膽敢干涉我好事的凡人將付出…等等--你……",
	phase2_message = "第二階段 - 6分15秒後，狂暴！",
	phase3_trigger = "無禮的小輩，你竟敢在我的王座之上挑戰我?我會親手碾碎你們!",
	phase3_message = "第三階段 - %s已狂怒！",

	hardmode = "困難模式",
	hardmode_desc = "顯示困難模式計時器。",
	hardmode_warning = "困難模式結束！",

	shock_message = ">你< 閃電震擊！移動！",
	barrier_message = "符文巨像 - 符刻屏障！",

	detonation_say = "我是炸彈！",

	charge_message = "閃電能量：>%d<！",
	charge_bar = "<閃電能量：%d>",

	strike_bar = "<失衡打擊 冷卻>",

	end_trigger = "住手!我認輸了!",

	icon = "團隊標記",
	icon_desc = "為中了引爆符文的隊員打上團隊標記。（需要權限）",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: General Vezax", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	["Vezax Bunny"] = "Vezax Bunny", -- For emote catching.

	engage_trigger = "你的毀滅將會預告一個嶄新苦難時代的來臨!",

	surge_message = "暗鬱奔騰：>%d<！",
	surge_cast = "正在施放 暗鬱奔騰：>%d<！",
	surge_bar = "<暗鬱奔騰：%d>",

	animus = "薩倫聚惡體",
	animus_desc = "當薩倫聚惡體出現時發出警報。",
	animus_trigger = "薩倫煙霧聚集起來并且劇烈地旋轉，形成一個怪物般的形體!",
	animus_message = "薩倫聚惡體 出現！",

	vapor = "薩倫煙霧",
	vapor_desc = "當薩倫煙霧出現時發出警報。",
	vapor_message = "薩倫煙霧：>%d<！",
	vapor_bar = "<薩倫煙霧：%d/6>",
	vapor_trigger = "一片薩倫煙霧在附近聚合!",

	vaporstack = "薩倫煙霧堆疊",
	vaporstack_desc = "當玩家中了5層或更多薩倫煙霧時發出警報。",
	vaporstack_message = "薩倫煙霧：>x%d<！",

	crash_say = ">我< 暗影暴擊！",

	crashsay = "自身暗影暴擊",
	crashsay_desc = "當你中了暗影暴擊時發出說話警報。",

	crashicon = "暗影暴擊標記",
	crashicon_desc = "為中了暗影暴擊的隊員打上藍色方框團隊標記。（需要權限）",

	mark_message = "Mark",
	mark_message_other = "無面者印記：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了暗影暴擊的隊員打上團隊標記。（需要權限）",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: XT-002", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	exposed_warning = "即將 機心外露！",
	exposed_message = "機心外露！",

	gravitybomb_other = "重力彈：>%s<！",

	gravitybombicon = "重力彈標記",
	gravitybombicon_desc = "為中了重力彈的玩家打上藍色方框標記。（需要權限）",

	lightbomb_other = "灼熱之光：>%s<！",

	tantrum_bar = "<躁怒 冷卻>",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Yogg-Saron", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	["Crusher Tentacle"] = "粉碎觸手",
	["The Observation Ring"] = "觀察之環",

	phase = "階段",
	phase_desc = "當階段改變發出警報。",
	engage_warning = "第一階段",
	engage_trigger = "我們即將有機會打擊怪物的首腦!現在將你的憤怒與仇恨貫注在他的爪牙上!",
	phase2_warning = "第二階段！",
	phase2_trigger = "我是清醒的夢境。",
	phase3_warning = "第三階段！",
	phase3_trigger = "在我的真身面前顫抖吧。", --看看死亡的真實面貌，瞭解你們的末日降臨了!

	portal = "傳送門",
	portal_desc = "當傳送門時發出警報。",
	portal_trigger = "傳送門開啟進入%s的心靈!",
	portal_message = "開啟傳送門！",
	portal_bar = "<下一傳送門>",

	sanity_message = ">你< 即將瘋狂！！",

	weakened = "昏迷",
	weakened_desc = "當尤格薩倫昏迷時發出警報。",
	weakened_message = "昏迷：>%s<！",
	weakened_trigger = "幻影粉碎，然後中央房間的道路就打開了!",

	madness_warning = "5秒後，瘋狂誘陷！",
	malady_message = "心靈缺陷：>%s<！",

	tentacle = "粉碎觸手",
	tentacle_desc = "當粉碎觸手出現時發出警報。",
	tentacle_message = "粉碎觸手：>%d<！",

	link_warning = ">你< 腦波連結！",

	gaze_bar = "<癡狂凝視 冷卻>",
	empower_bar = "<暗影信標 冷卻>",

	guardian_message = "尤格薩倫守護者：>%d<！ ",

	empowericon = "暗影信標標記",
	empowericon_desc = "為中了暗影信標的不朽守護者打上骷髏標記。（需要權限）",
	empowericon_message = "暗影信標 消失！",

	roar_warning = "5秒後，震耳咆哮！",
	roar_bar = "<下一震耳咆哮>",
} end )
