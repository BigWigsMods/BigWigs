local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "zhTW")
if not L then return end
if L then
	L.storm_duration = "閃電風暴持續"
	L.storm_duration_desc = "當閃電風暴施放時顯示分離持續警報條。"
	L.storm_short = "閃電風暴"

	L.in_water = ">你< 水中！"
end

L = BigWigs:NewBossLocale("Horridon", "zhTW")
if L then
	L.charge_trigger = "開始拍打他的尾巴"
	L.door_trigger = "的門蜂擁而出!"

	L.chain_lightning_message = "焦點：>閃電鏈<！"
	L.chain_lightning_bar = "焦點：閃電鏈"

	L.fireball_message = "焦點：>火球術<！"
	L.fireball_bar = "焦點：火球術"

	L.venom_bolt_volley_message = "焦點：>劇毒箭雨<！"
	L.venom_bolt_volley_bar = "焦點：劇毒箭雨"

	L.adds = "增援出現"
	L.adds_desc = "當法拉奇，古拉巴什，德拉克瑞和阿曼尼部族以及戰神加拉克出現時發出警報。"

	L.door_opened = "開門！"
	L.door_bar = "下一門（%d）"
	L.balcony_adds = "陽臺增援"
	L.orb_message = "控獸寶珠掉落！"

	L.focus_only = "|cffff0000只警報焦點目標。|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "zhTW")
if L then
	L.priestess_adds = "神靈增援"
	L.priestess_adds_desc = "當擊殺全部高階祭司瑪爾裏的增援時發出警報。"
	L.priestess_adds_message = "神靈增援"

	L.custom_on_markpossessed = "標記控制首領"
	L.custom_on_markpossessed_desc = "用骷髏團隊標記被控制的首領，需要許可權。"

	L.assault_stun = "坦克眩暈"
	L.assault_message = "嚴寒之擊！"
	L.full_power = "全能量"
	L.hp_to_go_power = "%d%% 生命！（能量：%d）"
	L.hp_to_go_fullpower = "%d%% 生命！（全能量）"
end

L = BigWigs:NewBossLocale("Tortos", "zhTW")
if L then
	L.bats_desc = "大量吸血蝠。控制。"

	L.kick = "腳踢"
	L.kick_desc = "持續追蹤可被腳踢迴旋龍龜的數量。"
	L.kick_message = "可腳踢迴旋龍龜：>%d<！"
	L.kicked_message = "%s已被踢！（%d剩餘）"

	L.custom_off_turtlemarker = "迴旋龍龜標記"
	L.custom_off_turtlemarker_desc = "使用團隊標記標記全部迴旋龍龜。\n|cFFFF0000團隊中只有1名應該啟用此選項以防止標記衝突，需要許可權。|r\n|cFFADFF2F提示：如果團隊選擇你用來標記旋龜，滑鼠懸停快速劃過全部迴旋龍龜是最快的標記方式。|r"

	L.no_crystal_shell = "沒有水晶護罩！"
end

L = BigWigs:NewBossLocale("Megaera", "zhTW")
if L then
	L.breaths = "吐息"
	L.breaths_desc = "全部不同類型的吐息警報。"

	L.arcane_adds = "祕法蛇頭"
end

L = BigWigs:NewBossLocale("Ji-Kun", "zhTW")
if L then
	L.lower_hatch_trigger = "下層某個鳥巢中的蛋開始孵化了！"
	L.upper_hatch_trigger = "上層某個鳥巢中的蛋開始孵化了！"

	L.nest = "巢穴"
	L.nest_desc = "警報依賴於巢穴。\n|cFFADFF2F提示：如果你沒有分配到處理巢穴請關閉該警報。|r"

	L.flight_over = "飛行結束 %d秒！"
	L.upper_nest = "|cff008000下層|r巢穴"
	L.lower_nest = "|cffff0000上層|r巢穴"
	L.up = "|cff008000上層|r"
	L.down = "|cffff0000下層|r"
	L.add = "增援"
	L.big_add_message = "大量增援 >%s<！"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "zhTW")
if L then
	L.red_spawn_trigger = "紅光照出了一隻緋紅霧行獸！"
	L.blue_spawn_trigger = "藍光照出了一隻蔚藍霧行獸！"
	L.yellow_spawn_trigger = "強光照出了一隻琥珀霧行獸！"

	L.adds = "顯形增援"
	L.adds_desc = "當緋紅、琥珀和蔚藍霧行獸顯形和霧行獸剩餘時發出警報。"

	L.custom_off_ray_controllers = "光線控制"
	L.custom_off_ray_controllers_desc = "使用%s%s%s團隊標記控制光線增援和移動的玩家，需要許可權。"

	L.custom_off_parasite_marks = "黑暗寄生標記"
	L.custom_off_parasite_marks_desc = "使用%s%s%s標記中了黑暗寄生的玩家幫助分配治療，需要許可權。"

	L.initial_life_drain = "初始生命吸取施放"
	L.initial_life_drain_desc = "初始生命吸取施放消息以幫助保持減少受到治療的減益。"

	L.life_drain_say = ">%d<層吸取"

	L.rays_spawn = "光線出現"
	L.red_add = "|cffff0000紅色|r增援"
	L.blue_add = "|cff0000ff藍色|r增援"
	L.yellow_add = "|cffffff00黃色|r增援"
	L.death_beam = "衰變光束"
	L.red_beam = "|cffff0000紅色|r光束"
	L.blue_beam = "|cff0000ff藍色|r光束"
	L.yellow_beam = "|cffffff00黃色|r光束"
end

L = BigWigs:NewBossLocale("Primordius", "zhTW")
if L then
	L.mutations = "變異 |cff008000>%d<|r |cffff0000>%d<|r"
	L.acidic_spines = "酸性脊刺（濺射傷害）"
end

L = BigWigs:NewBossLocale("Dark Animus", "zhTW")
if L then
	L.engage_trigger = "寶珠爆炸了！"

	L.matterswap_desc = "中了物質交換的玩家離你過遠，如果他們被驅散時你會與他們交換的位置。"
	L.matterswap_message = ">你< 最遠距離物質交換！"

	L.siphon_power = "虹吸血靈（%d%%）"
	L.siphon_power_soon = "虹吸血靈（%d%%）即將%s！"
	L.slam_message = "爆炸猛擊！"
end

L = BigWigs:NewBossLocale("Iron Qon", "zhTW")
if L then
	L.molten_energy = "熔火能量"

	L.overload_casting = "正在施放 熔岩超載"
	L.overload_casting_desc = "當正在施放熔岩超載時發出警報。"

	L.arcing_lightning_cleared = "弧光閃電"

	L.custom_off_spear_target = "投擲長矛目標"
	L.custom_off_spear_target_desc = "嘗試警報投擲長矛目標。此方法將提高 CPU 使用率，有時會顯示錯誤的目標，所以它在默認情況下是被禁用。\n|cFFADFF2F提示：設置為坦克職業會有助於提高警報準確性。|r"
	L.possible_spear_target = "可能的長矛"
end

L = BigWigs:NewBossLocale("Twin Consorts", "zhTW")
if L then
	L.last_phase_yell_trigger = "只此一次……"

	L.barrage_fired = "彈幕！"
end

L = BigWigs:NewBossLocale("Lei Shen", "zhTW")
if L then
	L.custom_off_diffused_marker = "散射閃電標記"
	L.custom_off_diffused_marker_desc = "使用全部團隊標記標記全部散射閃電，需要許可權。\n|cFFFF0000團隊中只有1名應該啟用此選項以防止標記衝突。|r\n|cFFADFF2F提示：如果團隊選擇你用來標記散射閃電，滑鼠懸停快速劃過全部散射閃電是最快的標記方式。|r"

	L.stuns = "昏迷"
	L.stuns_desc = "顯示昏迷持續計時條，用於處理球狀閃電。"

	L.aoe_grip = "AoE 之握"
	L.aoe_grip_desc = "當死亡騎士使用血魔之握時發出警報，用於處理球狀閃電。"

	L.shock_self = ">你< 靜電衝擊"
	L.shock_self_desc = "顯示靜電衝擊減益持續計時條。"

	L.overcharged_self = ">你< 超載"
	L.overcharged_self_desc = "顯示超載減益持續計時條。"

	L.last_inermission_ability = "最終階段轉換技能已使用！"
	L.safe_from_stun = "超載昏迷你也許是安全的"
	L.intermission = "階段轉換"
	L.diffusion_add = "散射閃電增援"
	L.shock = "電能震擊"
	L.static_shock_bar = "<靜電衝擊分攤>"
	L.overcharge_bar = "<超載脈衝>"
end

L = BigWigs:NewBossLocale("Ra-den", "zhTW")
if L then
	L.vita_abilities = "生命技能"
	L.anima_abilities = "心能技能"
	L.worm = "血色恐魔"
	L.worm_desc = "召喚血色恐魔。"
	L.balls = "造物材料"
	L.balls_desc = "心能（紅）和生命（藍）造物材料，這些技能使萊登獲得增益。"
	L.corruptedballs = "腐化心能"
	L.corruptedballs_desc = "腐化生命和腐化心能，（腐化生命）增加傷害或（腐化心能）增加生命值。"
	L.unstablevitajumptarget = "不穩定的生命彈跳目標"
	L.unstablevitajumptarget_desc = "當你距離最遠受到不穩定的生命玩家時發出提示。如果醒目此選項，將會在不穩定的生命彈跳到你時候看到冷卻計時條。"
	L.unstablevitajumptarget_message = ">你< 距離不穩定的生命最遠！"
	L.sensitivityfurthestbad = "生命過敏+最遠距離 = |cffff0000壞|r！"
	L.kill_trigger = "等等"

	L.assistPrint = "一個名為“BigWigs_Ra-denAssist”的插件已經發佈，可以幫助公會在萊登的戰鬥中提供幫助。"
end

L = BigWigs:NewBossLocale("Throne of Thunder Trash", "zhTW")
if L then
	L.displayname = "小怪"

	L.stormcaller = "贊達拉風暴召喚者"
	L.stormbringer = "風暴使者達茲基爾"
	L.monara = "莫納拉"
	L.rockyhorror = "岩石恐魔"
	L.thunderlord_guardian = "雷電領主/雷電守衛"
end

