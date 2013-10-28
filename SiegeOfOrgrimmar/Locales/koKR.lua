local L = BigWigs:NewBossLocale("Immerseus", "koKR")
if not L then return end
if L then
--@localization(locale="koKR", namespace="SiegeOfOrgrimmar/Immerseus", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "koKR")
if L then
	L.defile = "더럽혀진 땅 방어전담 경고"

	L.custom_off_bane_marks = "어둠의 권능: 파멸 징표 설정"
	L.custom_off_bane_marks_desc = "해제를 돕기 위해 어둠의 권능: 파멸을 가진 플레이어들을 {rt1}{rt2}{rt3}{rt4}{rt5} 징표로 표시합니다. 공격대장이거나 권한이 필요합니다."

	L.no_meditative_field = "명상의 장 안으로 들어가야 합니다!"

	L.intermission = "궁책"
	L.intermission_desc = "수호자의 궁책 사용 시기가 가까워지면 경고로 알려줍니다."

	L.inferno_self = "지옥불 일격 특수경고"
	L.inferno_self_desc = "당신이 지옥불 일격에 걸렸을 때 특수 경고를 해줍니다."
	L.inferno_self_bar = "지옥불 일격 시전"
end

L = BigWigs:NewBossLocale("Norushen", "koKR")
if L then
--@localization(locale="koKR", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
 end

L = BigWigs:NewBossLocale("Sha of Pride", "koKR")
if L then
	L.custom_off_titan_mark = "티탄의 선물 표시"
	L.custom_off_titan_mark_desc = "티탄의 선물 걸린 플레이어를 파악하기 쉽게하기 위해, 티탄의 선물이 걸린 플레이어를 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."

	L.projection_message = "|cFF00FF00녹색|r 화살표 위로 올라가세요!"
	L.projection_explosion = "투영 폭발!"

	L.big_add_bar = "교만의 현신"
	L.big_add_spawning = "교만의 현신 등장!"
	L.small_adds = "자아성찰: 투영체"

	L.titan_pride = "티탄 + 교만: %s"
 end

L = BigWigs:NewBossLocale("Galakras", "koKR")
if L then
	L.demolisher = "파괴전차"
	L.demolisher_desc = "코르크론 파괴 전차가 전투에 나타날 때 까지의 시간"

	L.towers = "탑"
	L.towers_desc = "탑에 진입이 가능해 질 때 경고"
	L.south_tower_trigger = "남쪽 탑으로 통하는 문이 뚫렸습니다!"
	L.south_tower = "남쪽 탑"
	L.north_tower_trigger = "북쪽 탑으로 통하는 문이 뚫렸습니다!"
	L.north_tower = "북쪽 탑"
	L.tower_defender = "탑 수호자"

	L.adds_desc = "추가병력"
	L.adds_trigger1 = "저 계집을 당장 끌어내려라. 내가 친히 그녀의 목을 죌 것이다." -- Lady Sylvanas Windrunner
	L.adds_trigger2 = "놈들이 와요!" -- Lady Jaina Proudmoore
	L.adds_trigger3 = "용아귀 용사들아, 진격하라!"
	L.adds_trigger4	= "헬스크림 님을 위하여!"
	L.adds_trigger5	= "다음 분대, 진격!"

	L.custom_off_shaman_marker = "파도주술사 징표 설정"
	L.custom_off_shaman_marker_desc = "차단하는 것을 돕기 위해, 용아귀부족 파도주술사를 {rt1}{rt2}{rt3}{rt4}{rt5} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "koKR")
if L then
	L.custom_off_mine_marks = "지뢰 징표 설정"
	L.custom_off_mine_marks_desc = "지뢰 밟는 것을 돕기 위해, 집게 지뢰들을 {rt1}{rt2}{rt3} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "koKR")
if L then
	L.blobs = "오염된 점액"

	L.custom_off_mist_marks = "독성 안개 징표 설정"
	L.custom_off_mist_marks_desc = "힐을 돕기 위해, 독성 안개에 걸린 플레이어를 {rt1}{rt2}{rt3}{rt4}{rt5} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."
end

L = BigWigs:NewBossLocale("General Nazgrim", "koKR")
if L then
	L.custom_off_bonecracker_marks = "뼈파쇄기 징표 설정"
	L.custom_off_bonecracker_marks_desc = "힐을 돕기 위해, 뼈파쇄기에 걸린 플레이어를 {rt1}{rt2}{rt3}{rt4}{rt5} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."

	L.stance_bar = "%s(현재:%s)"
	L.battle = "전투 태세"
	L.berserker = "광폭 태세"
	L.defensive = "방어 태세"

	L.adds_trigger1 = "놈들을 막아라!"
	L.adds_trigger2 = "병력 집결!"
	L.adds_trigger3 = "다음 분대, 앞으로!"
	L.adds_trigger4 = "전사들이여! 이리로!"
	L.adds_trigger5 = "코르크론! 날 지원하라!"
	L.adds_trigger_extra_wave = "전 코르크론, 내 명령을 따르라. 모두 죽여!"
	L.extra_adds = "다음 병력"

	L.chain_heal_message = "당신의 주시 대상이 연쇄 치유를 시전합니다!"

	L.arcane_shock_message = "당신의 주시 대상이 비전 충격을 시전합니다!"

	L.focus_only = "|cffff0000주시 대상을 잡았을 경우에만 경고합니다.|r "
 end

L = BigWigs:NewBossLocale("Malkorok", "koKR")
if L then
	L.custom_off_energy_marks = "어긋난 힘 징표 설정"
	L.custom_off_energy_marks_desc = "해제를 돕기 위해, 어긋난 힘에 걸린 플레이어를 {rt1}{rt2}{rt3}{rt4} 징표로 표시합니다. 공격대장이거나 권한이 필요합니다."
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "koKR")
if L then
	L.win_trigger = "시스템 초기화 중. 전원을 끄면 폭발할 수 있으니 주의하라고."

	L.enable_zone = "유물 보관실"
	L.matter_scramble_explosion = "물질 뒤섞기 폭발"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "koKR")
if L then
	L.adds = "하드모드 쫄"
	L.adds_desc = "하드모드에서만 나오는 쫄이 전투 중 출현했을 때 경고해줍니다."

	L.tank_debuffs = "탱커 디버프"
	L.tank_debuffs_desc = "무시무시한 외침과 연계된 탱커 디버프를 경고합니다."

	L.cage_opened = "감옥 열림"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "koKR")
if L then
	L.overcharged_crawler_mine = "과충전된 거미 지뢰"
	L.custom_off_mine_marker = "지뢰 징표 설정"
	L.custom_off_mine_marker_desc = "스턴 임무를 맡은 플레이어를 위해 지뢰에 징표를 찍습니다. (모든 징표가 사용됩니다)"

	L.saw_blade_near_you = "근처에 톱날이 날아옵니다!"
	L.saw_blade_near_you_desc = "공격대의 택틱이 뭉쳐서 하는 것이라면 스팸 메시지를 피하기 위해 이 옵션을 꺼주세요."

	L.disabled = "파괴됨"

	L.shredder_engage_trigger = "자동 분쇄기가 다가옵니다!"
	L.laser_on_you = "레이저가 당신에게 꽂힙니다!"
	L.laser_say = "나에게 절단 레이저!"

	L.assembly_line_trigger = "생산 설비에서 미완성 무기가 나오기 시작합니다."
	L.assembly_line_message = "생산 설비 가동 (%d)"
	L.assembly_line_items = "설비들 (%d): %s"
	L.item_missile = "미사일"
	L.item_mines = "지뢰"
	L.item_laser = "레이저"
	L.item_magnet = "전자석"

	L.shockwave_missile_trigger = "내 이쁜이 ST-03 충격파 미사일 포탑을 소개하지!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "koKR")
if L then
	L.catalyst_match = "촉매제: |c%s당신에게 해당됩니다!|r"
	L.you_ate = "기생충을 먹었습니다!"
	L.other_ate = "%s이(가) 기생충을 먹었습니다! (%d 마리 남음)"
	L.parasites_up = "%d 마리의 |4기생충:기생충들; 나타남"
	L.dance = "속사"
	L.prey_message = "기생충을 드세요."
	L.one = "이요쿠크가 1을 선택합니다!"
	L.two = "이요쿠크가 2을 선택합니다!"
	L.three = "이요쿠크가 3을 선택합니다!"
	L.four = "이요쿠크가 4을 선택합니다!"
	L.five = "이요쿠크가 5을 선택합니다!"
	L.edge_message = "당신은 광기의 계산 대상자입니다."
	L.custom_off_edge_marks = "광기의 계산 대상 징표 설정"
	L.custom_off_edge_marks_desc = "광기의 계산의 대상이 된 플레이어를 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."
	L.injection_over_soon = "주입이 곧 끝남! (%s)"
	L.custom_off_mutate_marks = "돌연변이: 호박석 전갈 징표 설정"
	L.custom_off_mutate_marks_desc = "힐을 돕기 위해, 돌연변이: 호박석 전갈에 걸린 플레이어를 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."
	L.custom_off_parasite_marks = "기생충 징표 설정"
	L.custom_off_parasite_marks_desc = "군중 제어기나 기생충을 먹어야 하는 플레이어를 위해 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다. \n|cFFFF0000혼선을 빚는 것을 방지하기 위하여, 오직 공대원 중 한 사람만이 이 옵션을 켜야합니다.|r"
 end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "koKR")
if L then
	L.manifest_rage = "명백한 분노"
	L.manifest_rage_desc = "가로쉬의 기력이 100에 도달하면 그는 2초동안 명백한 분노를 시전하고, 그 후 정신집중에 들어갑니다. 가로쉬가 정신집중하는 동안에는 큰 쫄이 나옵니다. 강철의 별을 가로쉬에게 유도해서 스턴시켜 시전을 멈추게 해야 합니다."

	L.phase_3_end_trigger = "네가 이겼다고 생각하나? 넌 눈이 멀었다! 내가 그 눈을 뜨게해 주마!"

	L.clump_check_desc = "폭격 동안 3초마다 플레이어들이 뭉쳐있는 지 확인합니다. 뭉쳐있는 것이 발견된다면 코르크론 강철의 별이 소환됩니다."
	--L.clump_check_warning = "Clump found, Star inc"

	L.bombardment = "폭격"
	L.bombardment_desc = "스톰윈드를 폭격하고, 지면에 불길의 흔적을 남깁니다. 폭격 동안에만 코르크론 강철의 별이 소환될 수 있습니다."

	L.intermission = "내면 세계"
	L.mind_control = "정신 지배"
	--L.empowered_message = "%s is now empowered!"

	L.ironstar_impact_desc = "강철의 별이 다른 쪽 벽에 충돌할 때를 위한 타이머 바를 생성합니다."
	L.ironstar_rolling = "강철의 별이 굴러갑니다!"

	L.chain_heal_desc = "아군 대상의 최대 생명력의 40%를 치유하고, 인접한 아군 대상에게 튕겨갑니다."
	L.chain_heal_message = "당신의 주시 대상이 연쇄 치유를 시전합니다"
	L.chain_heal_bar = "주시: 연쇄 치유"

	L.farseer_trigger = "선견자, 우리를 치료하라!"
	L.custom_off_shaman_marker = "선견자 표시"
	L.custom_off_shaman_marker_desc = "차단을 돕기 위해, 선견자 늑대 기수를 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다. \n|cFFFF0000혼선을 빚는 것을 방지하기 위하여, 오직 공대원 중 한 사람만이 이 옵션을 켜야합니다.|r \n|cFFADFF2F팁: 만약 공대에서 당신이 이 옵션을 키기로 했다면, 빠르게 선견자에게 마우스를 대는 것이 마킹을 하는 가장 빠른 방법입니다.|r"

	L.custom_off_minion_marker = "이샤라즈의 하수인 징표 설정"
	L.custom_off_minion_marker_desc = "쫄들을 분리하는 것을 돕기 위해, {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8} 마크로 표시합니다. 공격대장이거나 권한이 필요합니다."

	L.focus_only = "|cffff0000주시 대상 경고 전용.|r "
 end

