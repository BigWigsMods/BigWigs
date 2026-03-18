local L = BigWigs:NewBossLocale("Vorasius", "zhCN")
if not L then return end
if L then
	L.shadowclaw_slam = "重击" --“影爪重击”简称
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "zhCN")
if L then
	L.fractured_projection = "镜像" -- 打断？
end

L = BigWigs:NewBossLocale("Vaelgor & Ezzorak", "zhCN")
if L then
	--L.grappling_maw = "Tank Grip"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "zhCN")
if L then
	L.aura_of_wrath = "愤怒" -- “愤怒光环”简称
	L.execution_sentence = "处决" -- “处决宣判”简称
	L.judgement_red = "审判 [红]" -- 红色图标
	L.aura_of_devotion = "虔诚" -- “虔诚光环”简称
	L.judgement_blue = "审判 [蓝]" -- 蓝色图标
	L.aura_of_peace = "平心" -- “平心光环”简称
	L.zaelous_spirit = "狂热之魂" -- “狂热之魂”全称合适
end
