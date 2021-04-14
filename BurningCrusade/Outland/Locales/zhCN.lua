local L = BigWigs:NewBossLocale("Doomwalker", "zhCN")
if not L then return end
if L then
	L.name = "末日行者"

	L.engage_trigger = "停止前进。否则你们将被消灭。"
	L.engage_message = "末日行者激活！约30秒后，发动地震术！"

	L.overrun_desc = "当施放泛滥技能时发出警报。"

	L.earthquake_desc = "当施放地震术时发出警告。"
end

L = BigWigs:NewBossLocale("Doom Lord Kazzak", "zhCN")
if L then
	L.name = "末日领主卡扎克"

	L.engage_trigger1 = "军团将会征服一切！"
	L.engage_trigger2 = "所有的凡人都将灭亡！"

	L.enrage_warning1 = "%s 激活 - 50-60秒后，激怒！"
	L.enrage_warning2 = "即将 激怒！"
	L.enrage_message = "10秒后，激怒！"
	L.enrage_finished = "激活结束！50-60秒后，再次发动。"
	L.enrage_bar = "<激怒>"
	L.enraged_bar = "<已激怒>"
end

L = BigWigs:NewBossLocale("Gruul the Dragonkiller", "zhCN")
if L then
	L.engage_trigger = "来了……就得死。"
	L.engage_message = "%s 激活！"

	L.grow = "成长"
	L.grow_desc = "计算并当成长时发出警告。"
	L.grow_message = "成长：>%d<！"
	L.grow_bar = "成长：%d"

	L.grasp = "碎裂"
	L.grasp_desc = "碎裂警报计时条。"
	L.grasp_message = "大地冲击！约10秒后，破碎！"
	L.grasp_warning = "即将 大地冲击！"

	L.silence_message = "群体沉默！"
	L.silence_warning = "即将 群体沉默！"
	L.silence_bar = "沉默"
end

L = BigWigs:NewBossLocale("High King Maulgar", "zhCN")
if L then
	L.engage_trigger = "戈隆才是外域的主宰！"

	L.heal_message = "盲眼先知 - 治疗祷言！"
	L.heal_bar = "<治疗>"

	L.shield_message = "盲眼先知 真言术：盾！"

	L.spellshield_message = "克洛什 法术护盾！速度偷取"

	L.summon_message = "开始召唤 地狱犬！"
	L.summon_bar = "地狱犬 计时"

	L.whirlwind_message = "莫加尔 - 旋风斩！15秒。"
	L.whirlwind_warning = "莫加尔 激活！约60秒后，旋风斩！"

	L.mage = "克洛什·火拳 (法师)"
	L.warlock = "召唤者沃尔姆 (术士)"
	L.priest = "盲眼先知 (牧师)"
end

L = BigWigs:NewBossLocale("Magtheridon", "zhCN")
if L then
	L.escape = "释放"
	L.escape_desc = "玛瑟里顿获得自由倒计时。"
	L.escape_trigger1 = "%s的禁锢开始变弱！"
	L.escape_trigger2 = "我……自由了！"
	L.escape_warning1 = "%s 激活！2分钟后，获得自由！"
	L.escape_warning2 = "60秒后，自由！"
	L.escape_warning3 = "30秒后，自由！"
	L.escape_warning4 = "10秒后，自由！"
	L.escape_warning5 = "3秒后，自由！"
	L.escape_bar = "已释放"
	L.escape_message = "%s 已释放！"

	L.abyssal = "深渊燃魔"
	L.abyssal_desc = "当创造深渊燃魔时发出警报。"
	L.abyssal_message = "深渊燃魔：>%d<！"

	L.heal = "治疗"
	L.heal_desc = "当地狱火导魔者施放治疗时发出警报。"
	L.heal_message = "黑暗愈合！"

	L.banish = "放逐术"
	L.banish_desc = "当你放逐玛瑟里顿时发出警报。"
	L.banish_message = "放逐成功！约10秒。"
	L.banish_over_message = "放逐消失！"
	L.banish_bar = "<放逐中>"

	L.exhaust_desc = "心灵疲惫记时条。"
	L.exhaust_bar = "心灵疲惫：%s"

	L.debris_trigger = "我是不会轻易倒下的！让这座牢狱的墙壁颤抖并崩塌吧！"
	L.debris_message = "30% - 碎片来临！"
end

