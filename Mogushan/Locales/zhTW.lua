local L = BigWigs:NewBossLocale("The Stone Guard", "zhTW")
if not L then return end
if L then
	L.petrifications = "石化"
	L.petrifications_desc = "警告當首領開始施放石化"

	L.overload = "超載"
	L.overload_desc = "警告所有類型的超載"
end

L = BigWigs:NewBossLocale("Feng the Accursed", "zhTW")
if L then
	L.engage_yell = "噢，很好，交出你們的靈魂吧，凡人!這裡是亡者的殿堂!"

	L.phase_lightning_trigger = "噢，偉大的靈魂!賜予我大地之力!"
	L.phase_flame_trigger = "噢，至高的神啊!藉由我來融化他們的血肉吧!"
	L.phase_arcane_trigger = "噢，上古的賢者!賜予我秘法的智慧!"
	L.phase_shadow_trigger = "英雄之靈!以盾護我之身!"

	L.phase_lightning = "雷霆階段！"
	L.phase_flame = "火焰階段！"
	L.phase_arcane = "祕法階段！"
	L.phase_shadow = "暗影階段！(英雄)"

	L.phase_message = "快要轉換階段！"
	L.shroud_message = "Shroud"
	L.shroud_can_interrupt = "%s 可以中斷 %s！"
	L.barrier_message = "阻擋!"
	L.barrier_cooldown = "屏障冷卻中"

	-- Tanks
	L.tank = "坦克警報"
	L.tank_desc = "計數堆疊閃電鞭笞，火焰長矛，奧術衝擊與暗影灼燒（英雄）。"
	L.lash_message = "鞭笞"
	L.spear_message = "長矛"
	L.shock_message = "衝擊"
	L.burn_message = "衝擊"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "zhTW")
if L then
	L.engage_yell = "受死吧，你們!"

	L.totem_message = "靈魂圖騰 (%d)"
	L.shadowy_message = "暗影攻擊 (%d)"
	L.banish_message = "放逐坦克"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "zhTW")
if L then
	L.bosses = "Bosses"
	L.bosses_desc = "Warnings for when a boss becomes active."

	L.shield_removed = "盾移除了! (%s)"
	L.casting_shields = "施放護盾"
	L.casting_shields_desc = "警報當每個首領施放護盾的時候"
end

L = BigWigs:NewBossLocale("Elegon", "zhTW")
if L then
	L.engage_yell = "啟動防禦模式。關閉輸出保險設定。"

	L.last_phase = "最後階段"
	L.overcharged_total_annihilation = "超載 %d! 太多了喔?"

	L.floor = "地板消失"
	L.floor_desc = "警報當地板將要消失。"
	L.floor_message = "地板要落下了！"

	L.adds = "天體保護者出現"
	L.adds_desc = "當天體保護者要出現時警告."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "zhTW")
if L then
	L.enable_zone = "無盡熔爐"

	L.heroic_start_trigger = "摧毀漏出[泰坦氣體]到房間裡的那些管子!" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "這台機器啟動了!" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "大帝之怒響徹群山。"
	L.strength_trigger = "大帝之力以鐵拳掌握大地。"
	L.courage_trigger = "大帝之勇永久不滅。"
	L.bosses_trigger = "無盡的大軍會碾碎大帝的敵人。"
	L.gas_trigger = "古代魔古機器崩毀了!"
	L.gas_overdrive_trigger = "大帝之息漸息。"

	L.target_only = "|cFFFF0000這個警告只會顯示你設為目標的首領。|r "

	L.combo_message = "%s: 毀滅連擊快要來了!"
end

