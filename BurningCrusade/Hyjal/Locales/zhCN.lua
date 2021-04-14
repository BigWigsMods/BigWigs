local L = BigWigs:NewBossLocale("ArchimondeHyjal", "zhCN")
if not L then return end
if L then
	L.engage_trigger = "你们的抵抗是毫无意义的。"
	L.grip_other = "军团之握"
	L.fear_message = "恐惧！约42秒后再次发动。"

	L.killable = "可以击杀"
end

L = BigWigs:NewBossLocale("Azgalor", "zhCN")
if L then
	L.howl_bar = "阿兹加洛之嚎 冷却"
	L.howl_message = "群体沉默"
end

L = BigWigs:NewBossLocale("Kaz'rogal", "zhCN")
if L then
	L.mark_bar = "下一印记：%d"
	L.mark_warn = "5秒后，印记！"
end

L = BigWigs:NewBossLocale("Hyjal Summit Trash", "zhCN")
if L then
	L.waves = "阶段警报"
	L.waves_desc = "通告下一波来临警报信息。"

	L.ghoul = "食尸鬼"
	L.fiend = "地穴恶魔"
	L.abom = "憎恶"
	L.necro = "阴暗通灵师"
	L.banshee = "女妖"
	L.garg = "石像鬼"
	L.wyrm = "冰霜巨龙"
	L.fel = "恶魔猎犬"
	L.infernal = "地狱火"
	L.one = "第%d波：%d个%s！"
	L.two = "第%d波：%d个%s，%d个%s！"
	L.three = "第%d波：%d个%s，%d个%s，%d个%s！"
	L.four = "第%d波：%d个%s，%d个%s，%d个%s，%d个%s！"
	L.five = "第%d波：%d个%s，%d个%s，%d个%s，%d个%s，%d个%s！"
	L.barWave = "第%d波 出现！"

	L.waveInc = "第%d波 来临！"
	L.message = "%s 在约%d秒后来临！"
	L.waveMessage = "第%d波！将在约%d秒后来临！"

	L.winterchillGossip = "我和我的伙伴们将与您并肩作战，普罗德摩尔女士。"
	L.anetheronGossip = "我们已经准备好对付阿克蒙德的任何爪牙了，普罗德摩尔女士。"
	L.kazrogalGossip = "我与你并肩作战，萨尔。"
	L.azgalorGossip = "我们无所畏惧。"
end
