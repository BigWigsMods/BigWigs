local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "koKR")
if not L then return end
if L then
	L.storm_duration = "번개 폭풍 지속시간"
	L.storm_duration_desc = "번개 폭풍 시전 지속시간에 대한 경고 바를 표시합니다."
	L.storm_short = "번개 폭풍"

	L.in_water = "당신은 물안에 있습니다!"
end

L = BigWigs:NewBossLocale("Horridon", "koKR")
if L then
	L.charge_trigger = "시선을"
	L.door_trigger = "모래의 분노"
	--L.orb_trigger = "charge" -- PLAYERNAME forces Horridon to charge the Farraki door!

	L.chain_lightning_message = "당신의 주시 대상이 연쇄 번개를 시전합니다!"
	L.chain_lightning_bar = "주시 대상: 연쇄 번개"

	L.fireball_message = "당신의 주시 대상이 화염구를 시전합니다!"
	L.fireball_bar = "주시 대상: 화염구"

	L.venom_bolt_volley_message = "당신의 주시 대상이 일제 사격을 시전합니다!"
	L.venom_bolt_volley_bar = "주시 대상: 일제 사격"

	L.adds = "단계 전환"
	L.adds_desc = "파락키, 구루바시, 드라카리, 아마니, 전쟁신 잘라크의 단계 전환 경고를 표시합니다."

	L.door_opened = "문 열림!"
	L.door_bar = "다음 문 (%d)"
	L.balcony_adds = "병력 등장"
	L.orb_message = "조정의 구슬 떨어뜨림!"

	L.focus_only = "|cffff0000주시 대상 경고만 표시합니다.|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "koKR")
if L then
	L.priestess_adds = "영혼 추가"
	L.priestess_adds_desc = "대여사제 말리가 영혼을 추가로 소환할때 경고합니다."
	L.priestess_adds_message = "영혼 추가"

	L.custom_on_markpossessed = "빙의된 보스 공격대 아이콘"
	L.custom_on_markpossessed_desc = "영혼에 빙의된 보스에게 해골 공격대 아이콘을 표시합니다."

	--L.priestess_heal = "%s was healed!"
	L.assault_stun = "탱커 기절!"
	L.assault_message = "혹한의 공격"
	L.full_power = "전체 기력"
	L.hp_to_go_power = "%d%% 생명력 이동! (기력: %d)"
	L.hp_to_go_fullpower = "%d%% 생명력 이동! (전체 기력)"
end

L = BigWigs:NewBossLocale("Tortos", "koKR")
if L then
	L.bats_desc = "박쥐 등장! 처리하세요."

	L.kick = "등껍질 차기"
	L.kick_desc = "몇개의 등껍질을 찾는지 정보를 표시합니다."
	L.kick_message = "회오리 거북: %d"
	L.kicked_message = "%s kicked! (%d remaining)"

	L.custom_off_turtlemarker = "거북이 공격대 아이콘"
	L.custom_off_turtlemarker_desc = "모든 공격대 아이콘을 사용하여 표시합니다.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the turtles is the fastest way to mark them.|r"

	L.no_crystal_shell = "수정 보호막 없음"
end

L = BigWigs:NewBossLocale("Megaera", "koKR")
if L then
	L.breaths = "숨결"
	L.breaths_desc = "여러 숨결에 대한 경고를 합니다."

	L.arcane_adds = "황천 가르기 추가"
end

L = BigWigs:NewBossLocale("Ji-Kun", "koKR")
if L then
	--L.first_lower_hatch_trigger = "The eggs in one of the lower nests begin to hatch!"
	L.lower_hatch_trigger = "아랫둥지에 있는 알들이 부화하기 시작합니다!"
	L.upper_hatch_trigger = "위쪽 둥지에 있는 알들이 부화하기 시작합니다!"

	L.nest = "둥지"
	L.nest_desc = "둥지에 관련된 경고를합니다.\n|cFFADFF2FTIP: 만약 당신이 둥지를 처리하는 역할을 맞지 않았다면 이 경고를 해제하는게 좋습니다.|r"

	L.flight_over = "비행 남은 시간 %d 초!"
	L.upper_nest = "|cff008000위쪽|r 둥지"
	L.lower_nest = "|cffff0000아래쪽|r 둥지"
	L.up = "|cff008000위쪽|r"
	L.down = "|cffff0000아래쪽|r"
	L.add = "추가"
	L.big_add_message = "%s에 둥지 수호자 추가"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "koKR")
if L then
	L.red_spawn_trigger = "진흥빛 안개"
	L.blue_spawn_trigger = "하늘빛 안개"
	L.yellow_spawn_trigger = "호박색 안개"

	L.adds = "공개 추가" -- Reveal Adds
	L.adds_desc = "진흥빛, 하늘빛, 호박색 안개중 몇마리의 진흥빛 안개가 남았는지 경고합니다."

	L.custom_off_ray_controllers = "적외선 조절 공격대 아이콘"
	L.custom_off_ray_controllers_desc = "Use the {rt1}{rt7}{rt6} raid markers to mark people who will control the ray spawn positions and movement."

	L.custom_off_parasite_marks = "암흑의 기생충 공격대 아이콘" -- Dark parasite marker
	L.custom_off_parasite_marks_desc = "To help healing assignments, mark the people who have dark parasite on them with {rt3}{rt4}{rt5}, requires promoted or leader."

	L.initial_life_drain = "생명력 흡수"
	L.initial_life_drain_desc = "Message for the initial Life Drain cast to help keeping up healing received reducing debuff."

	L.life_drain_say = "%dx 생명력 흡수"

	L.rays_spawn = "생명체 추가"
	L.red_add = "|cffff0000붉은색|r 추가"
	L.blue_add = "|cff0000ff푸른색|r 추가"
	L.yellow_add = "|cffffff00노란색|r 추가"
	L.death_beam = "광선"
	L.red_beam = "|cffff0000붉은색|r 광선" -- 적외선
	L.blue_beam = "|cff0000ff푸른색|r 광선" -- 청색 광선
	L.yellow_beam = "|cffffff00노란색|r 광선" -- 직사광선
end

L = BigWigs:NewBossLocale("Primordius", "koKR")
if L then
	L.mutations = "변형 |cff008000(%d)|r |cffff0000(%d)|r"
	L.acidic_spines = "산성 가시 (바닥 피해)" -- Acidic Spines (Splash Damage)
end

L = BigWigs:NewBossLocale("Dark Animus", "koKR")
if L then
	L.engage_trigger = "구슬이 폭발합니다!"

	L.matterswap_desc = "A player with Matter Swap is far away from you. You will swap places with them if they are dispelled."
	L.matterswap_message = "당신은 물질 바꾸기를 위해 멀리있어야합니다!"

	L.siphon_power = "령 착취 (%d%%)"
	L.siphon_power_soon = "령 착취 (%d%%) 곧 %s!"
	L.slam_message = "격돌"
end

L = BigWigs:NewBossLocale("Iron Qon", "koKR")
if L then
	L.molten_energy = "불꽃 과부화"

	L.overload_casting = "불꽃 과부화 시전"
	L.overload_casting_desc = "불꽃 과부화 시전을 경고합니다."

	L.arcing_lightning_cleared = "휘어지는 번개"

	L.custom_off_spear_target = "창 던지기 대상"
	L.custom_off_spear_target_desc = "Try to warn for the Throw Spear target. This method is high on CPU usage and sometimes displays the wrong target so it is disabled by default.\n|cFFADFF2FTIP: Setting up TANK roles should help to increase the accuracy of the warning.|r"
	L.possible_spear_target = "창 투척"
end

L = BigWigs:NewBossLocale("Twin Consorts", "koKR")
if L then
	L.last_phase_yell_trigger = "그래야 한다면..." -- "<490.4 01:24:30> CHAT_MSG_MONSTER_YELL#Just this once...#Lu'lin###Suen##0#0##0#3273#nil#0#false#false", -- [6]

	L.barrage_fired = "우주의 포화!"
end

L = BigWigs:NewBossLocale("Lei Shen", "koKR")
if L then
	L.custom_off_diffused_marker = "확산된 번개 공격대 아이콘"
	L.custom_off_diffused_marker_desc = "당신이 공격대장이나 부공격대장일때, 확산된 번개에 모든 공격대 아이콘을 표시합니다.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the adds is the fastest way to mark them.|r"

	L.stuns = "기절"
	L.stuns_desc = "뛰어오르는 화살 처리를 위해 기절 지속 시간에 대한 바를 표시합니다."

	L.aoe_grip = "뛰어오르는 화살 처리"
	L.aoe_grip_desc = "죽음의 기사로 뛰어오르는 화살 처리를 위해 고어핀드의 손아귀를 사용할 수 있도록 경고합니다."

	L.shock_self = "당신에 전하 충격"
	L.shock_self_desc = "전하 충격 디버프의 지속시간 바를 표시합니다."

	L.overcharged_self = "당신에 과충전"
	L.overcharged_self_desc = "과충전 디버프의 지속시간 바를 표시합니다."

	L.last_inermission_ability = "마지막 도관 작동 능력 사용!"
	L.safe_from_stun = "당신은 과충전 기절에 안전"
	L.diffusion_add = "연쇄 확산"
	L.shock = "전하 충격"
	L.static_shock_bar = "<Static Shock Split>"
	L.overcharge_bar = "<Overcharge Pulse>"
end

L = BigWigs:NewBossLocale("Ra-den", "koKR")
if L then
	L.vita_abilities = "Vita abilities"
	L.anima_abilities = "Anima abilities"
	L.worm = "벌레" -- Worm
	L.worm_desc = "벌레 소환" -- Summon worm

	L.balls = "Balls"
	L.balls_desc = "Anima (red) and Vita (blue) balls, that determine which abilities will Ra-den gain"

	L.assistPrint = "A plugin called 'BigWigs_Ra-denAssist' has now been released for assistance during the Ra-den encounter that your guild may be interested in trying."
end

L = BigWigs:NewBossLocale("Throne of Thunder Trash", "koKR")
if L then
	L.stormcaller = "Zandalari Storm-Caller"
	L.stormbringer = "Stormbringer Draz'kil"
	L.monara = "Monara"
	L.rockyhorror = "Rocky Horror"
	L.thunderlord_guardian = "Thunder Lord / Lightning Guardian"
end
