local L = BigWigs:NewBossLocale("Kil'jaeden", "zhCN")
if not L then return end
if L then
	L.bomb_cast = "即将 千魂之暗！"
	L.bomb_nextbar = "<可能 千魂之暗>"
	L.bomb_warning = "约10秒后，可能千魂之暗！"

	L.orb = "护盾宝珠"
	L.orb_desc = "当护盾宝珠施放暗影箭时发出警报。"
	L.orb_shooting = "护盾宝珠 - 暗影箭！"

	L.shield_up = ">蓝龙之盾< 启用！"
	L.deceiver_dies = "已杀死基尔加丹之手#%d"

	L.blueorb = "蓝龙宝珠"
	L.blueorb_desc = "当蓝龙宝珠可用时发出警报。"
	L.blueorb_message = "蓝龙宝珠已准备好！"

	L.kalec_yell = "我会将我的力量导入宝珠中！准备好！"
	L.kalec_yell2 = "我又将能量灌入了另一颗宝珠！快去使用它！"
	L.kalec_yell3 = "又有一颗宝珠准备好了！快点行动！"
	L.kalec_yell4 = "这是我所能做的一切了！力量现在掌握在你们的手中！"
	L.phase3_trigger = "我是不会失败的！这个世界注定要毁灭！"
	L.phase4_trigger = "别再抱有幻想了！你们不可能赢！"
	L.phase5_trigger = "啊啊啊！太阳之井的能量……开始……对抗我！你们都做了些什么？你们都做了些什么？？"
end

L = BigWigs:NewBossLocale("Felmyst", "zhCN")
if L then
	L.phase = "阶段警报"
	L.phase_desc = "当升空或降落阶段时发出警报。"
	L.airphase_trigger = "我比以前更强大了！"
	L.takeoff_bar = "升空"
	L.takeoff_message = "5秒后，升空！"
	L.landing_bar = "降落"
	L.landing_message = "10秒后，降落！"

	L.breath = "深呼吸"
	L.breath_desc = "当施放深呼吸时发出警报。"
end

L = BigWigs:NewBossLocale("Brutallus", "zhCN")
if L then
	L.engage_trigger = "啊，又来了一群小绵羊！"

	L.burnresist = "燃烧抵抗"
	L.burnresist_desc = "当玩家抵抗燃烧攻击发出警报。"
	L.burn_resist = "燃烧抵抗：>%s<！"
end

L = BigWigs:NewBossLocale("M'uru", "zhCN")
if L then
	L.sentinel = "虚空戒卫"
	L.sentinel_desc = "当虚空戒卫刷新时发出警报。"
	L.sentinel_next = "下一虚空戒卫：%d"

	L.humanoid = "暗誓精灵"
	L.humanoid_desc = "当暗誓精灵刷新时发出警报。"
	L.humanoid_next = "下一暗誓精灵：%d"
end

L = BigWigs:NewBossLocale("Kalecgos", "zhCN")
if L then
	L.engage_trigger = "啊！我不再是玛利苟斯的奴隶了！所有挑战我的人都要被消灭！"
	L.enrage_trigger = "萨索瓦尔将卡雷苟斯逼得狂暴不已！"

	L.sathrovarr = "腐蚀者萨索瓦尔"

	L.portal = "传送"
	L.portal_message = "5秒后,可能发动传送！"

	L.realm_desc = "当玩家在灵魂世界中发出警报."
	L.realm_message = "灵魂世界：>%s<!(%d 小队）"
	L.nobody = "没有人"

	L.curse = "诅咒"

	L.wild_magic_healing = "狂野魔法（治疗加成）"
	L.wild_magic_healing_desc = "当你从狂野魔法中获得治疗加成时发出警报。"
	L.wild_magic_healing_you = "狂野魔法 - 治疗效果加成！"

	L.wild_magic_casting = "狂野魔法（施法时间延长）"
	L.wild_magic_casting_desc = "当治疗从狂野魔法延长施法时间时发出警报。"
	L.wild_magic_casting_you = "狂野魔法 - 施法时间延长：>你<！"
	L.wild_magic_casting_other = "狂野魔法 - 施法时间延长：>%s<!"

	L.wild_magic_hit = "狂野魔法（降低命中率）"
	L.wild_magic_hit_desc = "当 MT 受到狂野魔法降低命中率时发出警报。"
	L.wild_magic_hit_you = "狂野魔法 - 命中率降低：>你<"
	L.wild_magic_hit_other = "狂野魔法 - 命中率降低：>%s<!"

	L.wild_magic_threat = "狂野魔法（增加仇恨）"
	L.wild_magic_threat_desc = "当你受到狂野魔法增加仇恨时发出警报。"
	L.wild_magic_threat_you = "狂野魔法 - 增加仇恨！"
end

L = BigWigs:NewBossLocale("The Eredar Twins", "zhCN")
if L then
	L.lady = "萨洛拉丝 #3:"
	L.lock = "奥蕾塞丝 #2:"

	L.threat = "仇恨"

	L.custom_on_threat = "仇恨信息框"
	L.custom_on_threat_desc = "奥蕾塞丝的仇恨显示在第2，萨洛拉丝显示在第3."
end

