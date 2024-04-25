local L = BigWigs:NewBossLocale("Eranog", "zhTW")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "鎖定名條圖示"
	L.custom_on_nameplate_fixate_desc = "在獵殺指令鎖定你的塔拉賽克名條上顯示追擊圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	L.molten_cleave = "正面順劈"
	L.molten_spikes = "尖刺"
	L.collapsing_army = "烈焰大軍"
	L.greater_flamerift = "大型增援"
	L.leaping_flames = "跳躍火焰"
end

L = BigWigs:NewBossLocale("Terros", "zhTW")
if L then
	L.resonating_annihilation = "清場"
	L.awakened_earth = "地刺"
	L.shattering_impact = "猛擊"
	L.concussive_slam = "射線"
	L.infused_fallout = "落塵"

	L.custom_on_repeating_fallout = "重覆落塵喊話"
	L.custom_on_repeating_fallout_desc = "以 {rt7} 持續喊話，方便你找人消除落塵。"
end

L = BigWigs:NewBossLocale("The Primal Council", "zhTW")
if L then
	L.primal_blizzard = "暴風雪" -- Primal Blizzard
	L.earthen_pillars = "大地之柱" -- Earthen Pillars
	L.meteor_axes = "大圈分攤" -- Meteor Axes
	L.meteor_axe = "大圈分攤" -- Singular
	L.meteor_axes_melee = "近戰分攤"
	L.meteor_axes_ranged = "遠程分攤"

	-- L.skipped_cast = "Skipped %s (%d)"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "zhTW")
if L then
	L.ascend = "上升"
	L.ascend_desc = "賽娜斯朝巢穴的冰峰頂部移動。"
	L.chilling_blast = "凜冽衝擊"
	L.freezing_breath = "大怪吐息"
	L.webs = "蛛網"
	L.web = "蛛網"
	L.gossamer_burst = "拉人"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "zhTW")
if L then
	L.raging_burst = "狂怒風暴"
	L.cyclone = "拉近"
	L.crosswinds = "移動風暴"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "zhTW")
if L then
	-- -- Types
	L.damage = "傷害技能"
	L.damage_desc = "當我們不知道首領獲得什麼元素能力時，顯示傷害技能的計時器（岩漿衝擊、刺骨之寒、包覆之土、閃電爆擊）。"
	L.damage_bartext = "[傷害] %s" -- {Spell} [Dmg]

	L.avoid = "躲避技能"
	L.avoid_desc = "當我們不知道首領獲得什麼元素能力時，顯示躲避技能的計時器（熔火割裂、嚴寒洪流、爆發岩床、電擊爆發）。"
	L.avoid_bartext = "[躲避] %s" -- {Spell} [Avoid]

	L.ultimate = "終結技能"
	L.ultimate_desc = "當我們不知道首領獲得什麼元素能力時，顯示終結技能的計時器（灼熱屠殺、絕對零度、震地破裂、雷擊）。"
	L.ultimate_bartext = "[終結] %s" -- {Spell} [Ult]

	L.add_bartext = "[增援] %s" -- "{Spell} [Add]"

	L.Fire = "火焰"
	L.Frost = "冰霜"
	L.Earth = "大地"
	L.Storm = "風暴"

	-- Fire
	L.molten_rupture = "熔岩波"
	L.searing_carnage = "火圈跳舞"
	L.raging_inferno = "吸收熔岩池"

	-- Frost
	L.biting_chill = "刺骨之寒"
	L.absolute_zero_melee = "近戰分攤"
	L.absolute_zero_ranged = "遠程分攤"

	-- Earth
	L.erupting_bedrock = "地震跳舞"

	-- Storm
	L.lightning_crash = "閃電暴擊"

	-- General
	L.primal_attunement = "軟狂暴"

	-- Stage 2
	L.violent_upheaval = "石柱"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "zhTW")
if L then
	L.eggs_remaining = "還剩 %d 個蛋！"
	L.broodkeepers_bond = "剩餘龍蛋"
	L.greatstaff_of_the_broodkeeper = "巨杖"
	L.clutchwatchers_rage = "狂怒"
	L.rapid_incubation = "注入龍蛋"
	L.broodkeepers_fury = "狂怒"
	L.frozen_shroud = "定身吸收盾"
	L.detonating_stoneslam = "坦克分攤"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "zhTW")
if L then
	L.lighting_devastation_trigger = "深吸" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	L.volatile_current = "火花"
	L.thunderous_blast = "射線"
	L.lightning_strikes = "落雷"
	L.electric_scales = "團隊傷害"
	L.electric_lash = "電鞭"
	-- Stage Two: Surging Power
	L.absorb_text = "%s (%.0f%%)"
	L.stormsurge = "帶電吸收盾"
	L.stormcharged = "風暴充能"
	L.positive = "正極"
	L.negative = "負極"
	L.focused_charge = "聚能電荷"
	L.tempest_wing = "風暴之翼"
	L.fulminating_charge = "電能炸裂"
	L.fulminating_charge_debuff = "電能炸裂"
	-- Intermission: The Vault Falters
	L.ball_lightning = "閃電球"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "磁性電荷"

	L.custom_on_repeating_stormcharged = "重複正負極"
	L.custom_on_repeating_stormcharged_desc = "以 {rt1} 和 {rt3} 持續喊話正負極，方便你快速找到相同印記的隊友。"

	-- L.skipped_cast = "Skipped %s (%d)"

	L.custom_off_raidleader_devastation = "閃電破滅：團長模式"
	L.custom_off_raidleader_devastation_desc = "在另一個平台上也顯示閃電破滅（吐息）的計時器。"
	L.breath_other = "[對面] %s" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "zhTW")
if L then

end
