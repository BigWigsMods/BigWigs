local L = BigWigs:NewBossLocale("Attumen the Huntsman Raid", "zhTW")
if not L then return end
if L then
	L.phase = "階段警告"
	L.phase_desc = "當進入下一個階段時發送警告"
	L.phase2_trigger = "%s呼叫她的主人!"
	L.phase2_message = "第二階段 - %s & 阿圖曼"
	L.phase3_trigger = "來吧午夜，讓我們驅散這群小規模的烏合之眾!"
	L.phase3_message = "第三階段"
end

L = BigWigs:NewBossLocale("The Curator Raid", "zhTW")
if L then
	L.engage_trigger = "展示廳是賓客專屬的。"

	L.weaken_message = "喚醒 - 20 秒虛弱時間開始"
	L.weaken_fade_message = "喚醒結束 - 準備擊殺小電球"
	L.weaken_fade_warning = "喚醒將於 5 秒後結束"
end

L = BigWigs:NewBossLocale("Maiden of Virtue Raid", "zhTW")
if L then
	L.engage_trigger = "你的行為不能被容忍。"
	L.engage_message = "戰鬥開始！33 秒後懺悔！"

	L.repentance_message = "懺悔！33 秒後下一次懺悔！"
	L.repentance_warning = "懺悔即將來臨！"
end

L = BigWigs:NewBossLocale("Prince Malchezaar", "zhTW")
if L then
	L.wipe_bar = "重生計時"

	L.phase = "階段提示"
	L.phase_desc = "進入戰鬥及每一階段時發送警告"
	L.phase1_trigger = "瘋狂把你帶到我的面前。我會成為你失敗的原因!"
	L.phase2_trigger = "頭腦簡單的笨蛋!你在燃燒的是時間的火焰!"
	L.phase3_trigger = "你怎能期望抵抗這樣勢不可擋的力量?"
	L.phase1_message = "第一階段 - 地獄火將在 40 秒後召喚"
	L.phase2_message = "60% - 第二階段"
	L.phase3_message = "30% - 第三階段"

	L.infernal = "地獄火警告"
	L.infernal_desc = "顯示召喚地獄火計時條"
	L.infernal_bar = "地獄火"
	L.infernal_warning = "17 秒後召喚地獄火"
	L.infernal_message = "5 秒後召喚地獄火"
end

L = BigWigs:NewBossLocale("Moroes Raid", "zhTW")
if L then
	L.engage_trigger = "嗯，突然上門的訪客。一定要做好準備……"
	L.engage_message = "%s 進入戰鬥 - 將於 35 秒後消失"
end

L = BigWigs:NewBossLocale("Netherspite", "zhTW")
if L then
	L.phase = "階段警告"
	L.phase_desc = "當 尼德斯 進入下一階段時發送警告"
	L.phase1_message = "撒退 - 第一階段光線門"
	L.phase1_bar = "地獄吐息 - 撒退"
	L.phase1_trigger = "%s大聲呼喊撤退，打開通往地獄的門。"
	L.phase2_message = "狂怒 - 第二階段自我放逐"
	L.phase2_bar = "地獄吐息 - 狂怒"
	L.phase2_trigger = "%s陷入一陣狂怒!"

	L.voidzone_warn = "虛空地區 (%d)"
end

L = BigWigs:NewBossLocale("Nightbane Raid", "zhTW")
if L then
	L.name = "夜禍"

	L.phase = "階段警告"
	L.phase_desc = "當 夜禍 進入下一階段時發送警告"
	L.airphase_trigger = "悲慘的害蟲。我將讓你消失在空氣中!"
	L.landphase_trigger1 = "夠了!我要親自挑戰你!"
	L.landphase_trigger2 = "昆蟲!給你們近距離嚐嚐我的厲害!"
	L.airphase_message = "昇空"
	L.landphase_message = "降落"
	L.summon_trigger = "一個古老的生物在遠處甦醒過來……"

	L.engage_trigger = "真是蠢蛋!我會快點結束你的痛苦!"
end

L = BigWigs:NewBossLocale("Romulo & Julianne", "zhTW")
if L then
	L.name = "羅慕歐與茱麗葉"

	L.phase = "階段提示"
	L.phase_desc = "當戰鬥進入下一個階段時發送警告"
	L.phase1_trigger = "你是什麼樣的惡魔，讓我這樣的痛苦?"
	L.phase1_message = "Act I - 茱麗葉"
	L.phase2_trigger = "你想挑釁我嗎?下一個就輪到你了，小子!"
	L.phase2_message = "Act II - 羅慕歐"
	L.phase3_trigger = "來吧，溫和的夜晚；把我的羅慕歐還給我!"
	L.phase3_message = "Act III - 羅慕歐與茱麗葉"

	L.poison = "中毒警告"
	L.poison_desc = "當有玩家中毒時發送警告"
	L.poison_message = "中毒"

	L.heal = "治療警告"
	L.heal_desc = "當 茱麗葉 施放永恆的影響時發送警告"
	L.heal_message = "茱麗葉 正在施放治療術"

	L.buff = "狀態警告"
	L.buff_desc = "當 羅慕歐 和 茱麗葉 施放狀態時發送警告"
	L.buff1_message = "羅慕歐 在施放增益狀態"
	L.buff2_message = "茱麗葉 在施放增益狀態"
end

L = BigWigs:NewBossLocale("Shade of Aran", "zhTW")
if L then
	L.adds = "召喚水元素"
	L.adds_desc = "當埃蘭之影召喚水元素時發送警告"
	L.adds_message = "召喚水元素"
	L.adds_warning = "埃蘭之影即將召喚水元素"
	L.adds_bar = "召喚水元素"

	L.drink = "群體變羊"
	L.drink_desc = "當 埃蘭之影 開始回魔時發送警告"
	L.drink_warning = "埃蘭之影魔力太低"
	L.drink_message = "群體變羊術 - 埃蘭之影開始回魔"
	L.drink_bar = "群體變羊術"

	L.blizzard = "暴風雪警告"
	L.blizzard_desc = "當埃蘭之影施放暴風雪時發送警告"
	L.blizzard_message = "暴風雪 - 順時針方向走避"

	L.pull = "巨力磁力/魔爆術警告"
	L.pull_desc = "當埃蘭之影施放巨力磁力及魔爆術時發送警告"
	L.pull_message = "魔爆術 - 立刻向外圍跑"
	L.pull_bar = "魔爆術"
end

L = BigWigs:NewBossLocale("Terestian Illhoof", "zhTW")
if L then
	L.engage_trigger = "啊，你來的正好。儀式正要開始!"

	L.weak = "虛弱提示"
	L.weak_desc = "當泰瑞斯提安進入虛弱狀態時發送警告"
	L.weak_message = "進入虛弱狀態 45 秒！"
	L.weak_warning1 = "虛弱狀態 5 秒後結束！"
	L.weak_warning2 = "虛弱狀態結束！"
	L.weak_bar = "虛弱"
end

L = BigWigs:NewBossLocale("The Big Bad Wolf", "zhTW")
if L then
	L.name = "大野狼"

	L.riding_bar = "%s 快跑！"
end

L = BigWigs:NewBossLocale("The Crone", "zhTW")
if L then
	L.name = "老巫婆"

	L.engage_trigger = "喔多多，我們一定要找到回家的路!"

	L.spawns = "啟動時間"
	L.spawns_desc = "設定各角色啟動時間計時"
	L.spawns_warning = "%s 將在 5 秒後開始攻擊"

	L.roar = "獅子"
	L.tinhead = "機器人"
	L.strawman = "稻草人"
	L.tito = "多多"
end

