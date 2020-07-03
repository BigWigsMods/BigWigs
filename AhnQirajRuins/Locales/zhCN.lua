local L = BigWigs:NewBossLocale("Kurinnaxx", "zhCN")
if not L then return end
if L then
	L.bossName = "库林纳克斯"
end

local L = BigWigs:NewBossLocale("General Rajaxx", "zhCN")
if L then
	L.bossName = "拉贾克斯将军"

	L.wave = "波数警报"
	L.wave_desc = "每波的大概警报"

	L.wave_trigger1a = "它们来了。尽量别被它们干掉，新兵。"
	L.wave_trigger1b = "记得"
	L.wave_trigger3 = "我们复仇的时刻到了！让敌人的内心被黑暗吞噬吧！"
	L.wave_trigger4 = "我们不用再呆在这座石墙里面了！我们很快就能报仇了！在我们的怒火面前，就连那些龙也会战栗！"
	L.wave_trigger5 = "让敌人胆战心惊吧！让他们在恐惧中死去！"
	L.wave_trigger6 = "鹿盔将会呜咽着哀求我饶他一命，就像他那懦弱的儿子一样！一千年来的屈辱会在今天洗清！"
	L.wave_trigger7 = "范达尔！你的死期到了！藏到翡翠梦境里去吧，祈祷我们永远都找不到你！"
	L.wave_trigger8 = "无礼的蠢货！我会亲自要了你们的命！"

	L.wave_message = "挥动敌人(%d)"
end

local L = BigWigs:NewBossLocale("Moam", "zhCN")
if L then
	L.bossName = "莫阿姆"
end

local L = BigWigs:NewBossLocale("Buru the Gorger", "zhCN")
if L then
	L.bossName = "吞咽者布鲁"

	L.fixate = "锁定"
	L.fixate_desc = "锁定一个目标，忽视其他攻击者的威胁。"
end

local L = BigWigs:NewBossLocale("Ayamiss the Hunter", "zhCN")
if L then
	L.bossName = "狩猎者阿亚米斯"
end

local L = BigWigs:NewBossLocale("Ossirian the Unscarred", "zhCN")
if L then
	L.bossName = "无疤者奥斯里安"

	L.debuff = "虚弱"
	L.debuff_desc = "当各种虚弱类型时发出警报。"
end

local L = BigWigs:NewBossLocale("Ruins of Ahn'Qiraj Trash", "zhCN")
if L then
	L.guardian = "阿努比萨斯守卫者"
end
