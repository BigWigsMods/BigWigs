local L = BigWigs:NewBossLocale("Kurinnaxx", "zhTW")
if not L then return end
if L then
	L.bossName = "庫林納克斯"
end

local L = BigWigs:NewBossLocale("General Rajaxx", "zhTW")
if L then
	L.bossName = "拉賈克斯將軍"

	L.wave = "來襲警報"
	L.wave_desc = "當新一批敵人來襲時發出警報"

	L.wave_trigger1a = "先殺再說...他們來了！"
	L.wave_trigger1b = "記得"
	L.wave_trigger3 = "我們懲罰的時刻就在眼前！讓黑暗支配敵人的內心吧！"
	L.wave_trigger4 = "我們不需在被禁堵的門與石牆後等待了！我們的復仇將不再被否認！巨龍將在我們的憤怒之前顫抖！"
	L.wave_trigger5 = "恐懼是給敵人的！恐懼與死亡！"
	L.wave_trigger6 = "鹿盔將為了活命而啜泣、乞求，就像他的兒子一樣！一千年的不公將在今日結束！"
	L.wave_trigger7 = "范達爾！你的時候到了！躲進翡翠夢境祈禱我們永遠不會找到你吧！"
	L.wave_trigger8 = "厚顏無恥的笨蛋！我要親手殺了你！"

	L.wave_message = "揮動敵人(%d)"
end

local L = BigWigs:NewBossLocale("Moam", "zhTW")
if L then
	L.bossName = "莫阿姆"
end

local L = BigWigs:NewBossLocale("Buru the Gorger", "zhTW")
if L then
	L.bossName = "『暴食者』布魯"

	-- L.fixate = "Fixate"
	-- L.fixate_desc = "Fixate on a target, ignoring threat from other attackers."
end

local L = BigWigs:NewBossLocale("Ayamiss the Hunter", "zhTW")
if L then
	L.bossName = "『狩獵者』阿亞米斯"
end

local L = BigWigs:NewBossLocale("Ossirian the Unscarred", "zhTW")
if L then
	L.bossName = "『無疤者』奧斯里安"

	L.debuff = "虛弱警報"
	L.debuff_desc = "無疤者奧斯里安受到虛弱效果影響時發出警報"
end

local L = BigWigs:NewBossLocale("Ruins of Ahn'Qiraj Trash", "zhTW")
if L then
	-- L.guardian = "Anubisath Guardian"
end
