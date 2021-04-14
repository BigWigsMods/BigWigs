local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "zhTW")
if not L then return end
if L then
	L.start_trigger = "你會以瓦許女士之名而死!"
end

L = BigWigs:NewBossLocale("Supremus", "zhTW")
if L then
	L.normal_phase_trigger = "瑟普莫斯憤怒的捶擊地面!"
	L.kite_phase_trigger = "地上開始裂開!"
	L.normal_phase = "普通階段"
	L.kite_phase = "風箏階段"
	L.next_phase = "下一階段"
end

L = BigWigs:NewBossLocale("Shade of Akama", "zhTW")
if L then
	--L.wipe_trigger = "No! Not yet!"
	--L.defender = "Defender" -- Ashtongue Defender
	--L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	L.adds_right = "右側小怪"
	L.adds_left = "左側小怪"

	--L.engaged = "Shade of Akama Engaged"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "zhTW")
if L then
	L.zero_mana = "沒魔"
	L.zero_mana_desc = "當慾望精華出現並開始降低法力值，替法力值歸零顯示計時器。"
	L.desire_start = "慾望精華：160秒後沒魔"

	L[-15665] = "階段一：受難精華"
	L[-15673] = "階段二：慾望精華"
	L[-15681] = "階段三：憤怒精華"
end

L = BigWigs:NewBossLocale("The Illidari Council", "zhTW")
if L then
	L.veras = "維拉斯：%s"
	L.malande = "瑪蘭黛：%s"
	L.gathios = "者高希歐：%s"
	L.zerevor = "札瑞佛：%s"

	L.circle_heal_message = "治療成功！約20秒後再次使用。"
	L.circle_fail_message = "%s打斷了！約12秒後再次使用。"

	L.magical_immunity = "魔法免疫！"
	L.physical_immunity = "物理免疫！"

	L[-15704] = "粉碎者高希歐"
	L[-15716] = "維拉斯‧深影"
	L[-15726] = "瑪蘭黛女士"
	L[-15720] = "高等虛空術師札瑞佛"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "zhTW")
if L then
	L.barrage_bar = "黑暗侵襲"
	L.warmup_trigger = "阿卡瑪。你的謊言真是老套。我很久前就該殺了你和你那些畸形的同胞。"

	L[-15735] = "階段一：你們還沒準備好"
	L[-15740] = "階段二：埃辛諾斯火焰"
	L[-15751] = "階段三：體內的惡魔"
	L[-15757] = "階段四：長久的狩獵"
end
