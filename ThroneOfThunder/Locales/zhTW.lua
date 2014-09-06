local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "zhTW")
if not L then return end
if L then
	L.storm_duration = "閃電風暴持續時間"
	L.storm_duration_desc = "為閃電風暴的持續時間顯示單獨的計時條。"
	L.storm_short = "閃電風暴"

	L.in_water = ">你<在水中！"
end

L = BigWigs:NewBossLocale("Horridon", "zhTW")
if L then
	L.charge_trigger = "用力拍動尾巴!"
	L.door_trigger = "的門蜂擁而出!"
	--L.orb_trigger = "charge" -- PLAYERNAME forces Horridon to charge the Farraki door!

	L.chain_lightning_message = "你的專注目標正在施展閃電鏈！"
	L.chain_lightning_bar = "專注目標：閃電鏈"

	L.fireball_message = "你的專注目標正在施展火球術！"
	L.fireball_bar = "專注目標：火球術"

	L.venom_bolt_volley_message = "你的專注目標正在施展毒箭之雨！"
	L.venom_bolt_volley_bar = "專注目標：毒箭之雨"

	L.adds = "小怪參戰"
	L.adds_desc = "當法拉奇、古拉巴什、德拉克瑞和阿曼尼部族以及戰神加拉克出現時發出警報。"

	L.door_opened = "開門！"
	L.door_bar = "下一道門（%d）"
	L.balcony_adds = "上層看臺小怪"
	L.orb_message = "控獸寶珠掉落！"

	L.focus_only = "|cffff0000只警報專注目標。|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "zhTW")
if L then
	L.priestess_adds = "魂靈"
	L.priestess_adds_desc = "當高階女祭司瑪俐開始呼叫魂靈時發出警報。"
	L.priestess_adds_message = "魂靈"

	L.custom_on_markpossessed = "標記遭佔據的首領"
	L.custom_on_markpossessed_desc = "用骷髏標記遭佔據的首領，需要權限。"

	L.priestess_heal = ">%s< 被治療！"
	L.assault_stun = "坦克暈眩"
	L.assault_message = "嚴寒之擊！"
	L.full_power = "全能量"
	L.hp_to_go_power = "%d%% 生命！（能量：%d）"
	L.hp_to_go_fullpower = "%d%% 生命！（全能量）"
end

L = BigWigs:NewBossLocale("Tortos", "zhTW")
if L then
	L.bats_desc = "大量吸血蝙蝠。處理掉。"

	L.kick = "腳踢"
	L.kick_desc = "持續追蹤可被踢的迴旋龍龜數量。"
	L.kick_message = "可踢的迴旋龍龜：%d！"
	L.kicked_message = "%s已腳踢！（剩餘%d）"

	L.custom_off_turtlemarker = "標記迴旋龍龜"
	L.custom_off_turtlemarker_desc = "使用全部的團隊圖示標記迴旋龍龜，需要權限。\n|cFFFF0000團隊中只需要有一人啟用此選項以防止標記衝突。|r\n|cFFADFF2F提示：如果團隊選擇你來啟用此項功能，滑鼠快速滑過所有迴旋龍龜是最快的標記方式。|r"

	L.no_crystal_shell = "沒有水晶護罩"
end

L = BigWigs:NewBossLocale("Megaera", "zhTW")
if L then
	L.breaths = "火息術"
	L.breaths_desc = "警報所有不同類型的火息術。"

	L.arcane_adds = "秘法蛇頭"
end

L = BigWigs:NewBossLocale("Ji-Kun", "zhTW")
if L then
	L.first_lower_hatch_trigger = "下層巢裡的蛋開始孵化了!"
	L.lower_hatch_trigger = "下層巢裡的蛋開始孵化了!"
	L.upper_hatch_trigger = "上層巢裡的蛋開始孵化了!"

	L.nest = "鳥巢"
	L.nest_desc = "鳥巢警報。\n|cFFADFF2F提示：如果你不是分配到處理鳥巢請取消此選項關閉警報。|r"

	L.flight_over = "飛行結束 %d秒！"
	L.upper_nest = "|cff008000上層|r鳥巢"
	L.lower_nest = "|cffff0000下層|r鳥巢"
	L.up = "|cff008000上層|r"
	L.down = "|cffff0000下層|r"
	L.add = "巢穴守衛者"
	L.big_add_message = "大量巢穴守衛者 >%s<！"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "zhTW")
if L then
	L.red_spawn_trigger = "紅光射線照出了緋紅霧獸!"
	L.blue_spawn_trigger = "藍光射線照出了蔚藍霧獸!"
	L.yellow_spawn_trigger = "強光射線照出了琥珀霧獸!"

	L.adds = "霧獸現形"
	L.adds_desc = "當緋紅、蔚藍和琥珀霧獸現形時發出警報並提示剩餘多少霧獸。"

	L.custom_off_ray_controllers = "射線控制"
	L.custom_off_ray_controllers_desc = "使用 {rt1}{rt7}{rt6} 團隊圖示標記控制射線出生位置及位移的玩家，需要權限。"

	L.custom_off_parasite_marks = "黑暗寄生蟲標記"
	L.custom_off_parasite_marks_desc = "使用 {rt3}{rt4}{rt5} 標記中了黑暗寄生蟲的玩家協助分配治療，需要權限。"

	L.initial_life_drain = "生命吸取起始警報"
	L.initial_life_drain_desc = "一施放生命吸取就發送訊息以協助跟上治療減益。"

	L.life_drain_say = ">%d<層吸取"

	L.rays_spawn = "光線出現"
	L.red_add = "|cffff0000緋紅|r霧獸"
	L.blue_add = "|cff0000ff蔚藍|r霧獸"
	L.yellow_add = "|cffffff00琥珀|r霧獸"
	L.death_beam = "毀滅光束"
	L.red_beam = "|cffff0000紅光|r射線"
	L.blue_beam = "|cff0000ff藍光|r射線"
	L.yellow_beam = "|cffffff00強光|r射線"
end

L = BigWigs:NewBossLocale("Primordius", "zhTW")
if L then
	L.mutations = "變異 |cff008000>%d<|r |cffff0000>%d<|r"
	L.acidic_spines = "強酸脊刺（濺射傷害）"
end

L = BigWigs:NewBossLocale("Dark Animus", "zhTW")
if L then
	L.engage_trigger = "血靈球體爆炸了!"

	L.matterswap_desc = "中了物質交換的玩家被驅散時，會與距離最遠的盟友交換位置。"
	L.matterswap_message = ">你< 距離最遠 物質交換！"

	L.siphon_power = "虹吸血靈（%d%%）"
	L.siphon_power_soon = "虹吸血靈（%d%%）即將%s！"
	L.slam_message = "爆裂猛擊！"
end

L = BigWigs:NewBossLocale("Iron Qon", "zhTW")
if L then
	L.molten_energy = "熔岩之力"

	L.overload_casting = "正在施放 熔岩超載"
	L.overload_casting_desc = "當正在施放熔岩超載時發出警報。"

	L.arcing_lightning_cleared = "弧光閃電"

	L.custom_off_spear_target = "投擲長矛目標"
	L.custom_off_spear_target_desc = "嘗試警報投擲長矛目標。將提高CPU使用率，有時會顯示錯誤的目標，預設關閉。\n|cFFADFF2F提示：設置為坦克角色會有助於提高警報準確性。|r"
	L.possible_spear_target = "預測長矛目標"
end

L = BigWigs:NewBossLocale("Twin Consorts", "zhTW")
if L then
	L.last_phase_yell_trigger = "就這一次..."

	L.barrage_fired = "彈幕！"
end

L = BigWigs:NewBossLocale("Lei Shen", "zhTW")
if L then
	L.custom_off_diffused_marker = "散射電靈標記"
	L.custom_off_diffused_marker_desc = "使用全部的團隊圖示標記散射電靈，需要權限。\n|cFFFF0000團隊中只需要有一人啟用此選項以防止標記衝突。|r\n|cFFADFF2F提示：如果團隊選擇你來啟用此項功能，滑鼠快速滑過所有散射電靈是最快的標記方式。|r"

	L.stuns = "昏迷"
	L.stuns_desc = "顯示昏迷持續時間計時條，用於處理閃電球。"

	L.aoe_grip = "AoE控場"
	L.aoe_grip_desc = "當死亡騎士使用血魔之握時發出警報，用於處理閃電球。"

	L.shock_self = "自身靜電震擊"
	L.shock_self_desc = "顯示靜電震擊減益的持續時間計時條。"

	L.overcharged_self = "自身電能超載"
	L.overcharged_self_desc = "顯示電能超載減益的持續時間計時條。"

	L.last_inermission_ability = "最終階段轉換技能已使用！"
	L.safe_from_stun = "可容許的超載昏迷"
	L.diffusion_add = "散射電靈"
	L.shock = "靜電震擊"
	L.static_shock_bar = "<靜電震擊分擔>"
	L.overcharge_bar = "<電能超載脈衝>"
end

L = BigWigs:NewBossLocale("Ra-den", "zhTW")
if L then
	L.vita_abilities = "精華技能"
	L.anima_abilities = "血靈技能"
	L.worm = "血紅魔物"
	L.worm_desc = "召喚血紅魔物。"
	L.balls = "造物材料"
	L.balls_desc = "血靈（紅）和精華（藍）造物材料，這些技能使萊公獲得增益。"
	L.corruptedballs = "腐化的造物材料"
	L.corruptedballs_desc = "腐化的精華和腐化的血靈，增加傷害（腐化的精華）或增加最大生命值（腐化的血靈）。"
	L.unstablevitajumptarget = "動盪生命彈跳目標"
	L.unstablevitajumptarget_desc = "當你與受到動盪生命的玩家距離最遠時發出提示。如果勾選此項，當動盪生命準備跳離你時將會倒數。"
	L.unstablevitajumptarget_message = ">你< 距離動盪生命最遠！"
	L.sensitivityfurthestbad = "生命敏感+最遠距離 = |cffff0000坏|r！"
	L.kill_trigger = "慢著!"

	L.assistPrint = "擴充外掛\"BigWigs_Ra-denAssist\"已經發佈來協助與萊公的戰鬥，也許你的團隊會有興趣嘗試看看。"
end

L = BigWigs:NewBossLocale("Throne of Thunder Trash", "zhTW")
if L then
	L.stormcaller = "贊達拉召雷師"
	L.stormbringer = "風暴召喚者德拉茲齊"
	L.monara = "魔娜菈" --(任務)皇后的輓歌
	L.rockyhorror = "磐石駭獸" --(任務)石落人亡
	L.thunderlord_guardian = "雷霆總兵/閃電守護者"
end

