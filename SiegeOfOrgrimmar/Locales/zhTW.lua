local L = BigWigs:NewBossLocale("Immerseus", "zhTW")
if not L then return end
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/Immerseus", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/TheFallenProtectors", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_bane_marks = "暗言術:禍 標記"
	L.custom_off_bane_marks_desc = "幫助驅散分配，給最初受到暗言術:禍的玩家使用{rt1}{rt2}{rt3}{rt4}{rt5}進行標記 (依照此順序標記，不代表所有都會用到)，需要權限。"
end

L = BigWigs:NewBossLocale("Norushen", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/ShaOfPride", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_titan_mark = "泰坦之賜標記"
	L.custom_off_titan_mark_desc = "將受到泰坦之賜的玩家使用{rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}標記，需要權限。\n|cFFFF0000團隊中只能有一個玩家啟用此選項以避免標記衝突。|r"
end

L = BigWigs:NewBossLocale("Galakras", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/Galakras", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "薩滿標記"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the shamans is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "zhTW")
if L then
	L.custom_off_mine_marks = "Mine marker"
	L.custom_off_mine_marks_desc = "To help soaking assignments, mark the Crawler Mines with {rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the mines is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "zhTW")
if L then
	L.blobs = "Blobs"

	L.custom_off_mist_marks = "Toxic Mist marker"
	L.custom_off_mist_marks_desc = "To help healing assignments, mark the people who have Toxic Mist on them with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "zhTW")
if L then
	L.custom_off_bonecracker_marks = "Bonecracker marker"
	L.custom_off_bonecracker_marks_desc = "To help healing assignments, mark the people who have Bonecracker on them with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.stance_bar = "%s(現在:%s)"
	L.battle = "戰鬥"
	L.berserker = "狂暴"
	L.defensive = "防禦"

	L.adds_trigger1 = "守住大門!"
	L.adds_trigger2 = "重整部隊!"
	L.adds_trigger3 = "下一隊，來前線!"
	L.adds_trigger4 = "戰士們，快點過來!"
	L.adds_trigger5 = "柯爾克隆，來我身邊!"
	L.adds_trigger_extra_wave = "所有科爾克隆...聽我號令...殺死他們!"
	L.extra_adds = "10% - 額外增援部隊"
	--L.final_wave = "Final Wave"

	L.chain_heal_message = "你的專注目標正在施放治療鍊！"

	L.arcane_shock_message = "Your focus is casting Arcane Shock!"

	L.focus_only = "|cffff0000只警報專注目標。|r "
end

L = BigWigs:NewBossLocale("Malkorok", "zhTW")
if L then
	L.custom_off_energy_marks = "Displaced Energy marker"
	L.custom_off_energy_marks_desc = "To help dispelling assignments, mark the people who have Displaced Energy on them with {rt1}{rt2}{rt3}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "zhTW")
if L then
	L.start_trigger = "我們在錄音嗎?有嗎?好。哥布林-泰坦控制模組開始運作，請後退。"
	L.win_trigger = "系統重置中。請勿關閉電源，否則可能會爆炸。"

	L.enable_zone = "Artifact Storage"
	L.matter_scramble_explosion = "Matter Scramble explosion" -- shorten maybe?
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "zhTW")
if L then
	L.overcharged_crawler_mine = "Overcharged Crawler Mine" -- sadly this is needed since they have same mobId
	L.custom_off_mine_marker = "地雷標記"
	L.custom_off_mine_marker_desc = "Mark the mines for specific stun assignments. (All the marks are used)"

	L.saw_blade_near_you = "Saw blade near you (not on you)"
	L.saw_blade_near_you_desc = "You might want to turn this off to avoid spam if your raid is mostly bunched up according to your tactics."

	L.disabled = "已停用"

	L.shredder_engage_trigger = "有個自動化伐木機靠近了!"
	L.laser_on_you = "Laser on you PEW PEW!"
	L.laser_say = "Laser PEW PEW"

	L.assembly_line_trigger = "尚未完成的武器開始從生產線上掉落。"
	L.assembly_line_message = "Unfinished weapons (%d)"
	L.assembly_line_items = "物品 (%d): %s"
	L.item_missile = "Missile"
	L.item_mines = "Mines"
	L.item_laser = "Laser"
	L.item_magnet = "Magnet"
	L.item_deathdealer = "Deathdealer"

	L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "zhTW")
if L then
	L.catalyst_match = "催化劑: |c%s引爆你|r" -- might not be best for colorblind?
	L.you_ate = "You ate a Parasite (%d left)"
	L.other_ate = "%s ate a %sParasite (%d left)"
	L.parasites_up = "%d |4Parasite:Parasites; up"
	L.dance = "跳舞"
	L.prey_message = "Use Prey on parasite"
	L.injection_over_soon = "注射即將結束: (%s)!"

	L.one = "一"
	L.two = "二"
	L.three = "三"
	L.four = "四"
	L.five = "五"

	L.custom_off_edge_marks = "Edge marks"
	L.custom_off_edge_marks_desc = "Mark the players who will be edges based on the calculations {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.edge_message = "You are an edge!"

	L.custom_off_parasite_marks = "Parasite marker"
	L.custom_off_parasite_marks_desc = "Mark the parasites for crowd control and Prey assignments with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.injection_tank = "Injection cast"
	L.injection_tank_desc = "Timer bar for when Injection is cast for his current tank."
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "zhTW")
if L then
	L.manifest_rage = "Manifest Rage"
	L.manifest_rage_desc = "When Garrosh reaches 100 energy he'll pre cast Manifest Rage for 2 seconds, then channel it. While it's channelled it summons big adds. Kite the Iron Star into Garrosh to stun and interrupt his cast."

	L.phase_3_end_trigger = "You think you have WON?  You are BLIND.  I WILL FORCE YOUR EYES OPEN."

	L.clump_check_desc = "Check every 3 seconds during bombardment for clumped up players, if a clump is found a Kor'kron Iron Star will spawn."
	L.clump_check_warning = "Clump found, Star inc"

	L.bombardment = "Bombardment"
	L.bombardment_desc = "Bombarding Stormwind and leaving fires on the ground. Kor'kron Iron Star can only spawn during bombardment."

	L.intermission = "中場休息"
	L.mind_control = "亞煞拉懼之觸"
	L.empowered_message = ">%s< 強化腐化！"

	L.ironstar_impact_desc = "A timer bar for when the Iron Star will impact the wall at the other side."
	L.ironstar_rolling = "Iron Star Rolling!"

	L.chain_heal_desc = "Heals a friendly target for 40% of their max health, chaining to nearby friendly targets."
	L.chain_heal_message = "Your focus is casting Chain Heal!"
	L.chain_heal_bar = "Focus: Chain Heal"

	L.farseer_trigger = "先知們，治療我們的傷口!"
	L.custom_off_shaman_marker = "先知標記"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Farseer Wolf Rider with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the farseers is the fastest way to mark them.|r"

	L.custom_off_minion_marker = "亞煞拉懼的爪牙標記"
	L.custom_off_minion_marker_desc = "To help separate Empowered Whirling Corruption adds, mark them with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader."

	L.focus_only = "|cffff0000只警報專注目標。|r "
end

