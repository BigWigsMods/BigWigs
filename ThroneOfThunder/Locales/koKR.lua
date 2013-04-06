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
	L.charge_trigger = "시선을" -- 호리돈이 시선을 PLAYERNAME에게 고정하고 꼬리를 바닥에 쿵쿵 내려칩니다!
	L.door_trigger = "모래의 분노" -- 파락키, 모래의 분노로 적의 껍질을 벗겨라!

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
	L.priestess_adds = "영혼 추가"  -- Priestess adds
	L.priestess_adds_desc = "대여사제 말리가 영혼을 추가로 소환할때 경고합니다."  -- Warnings for when High Priestess Mar'li starts to summon adds.
	L.priestess_adds_message = "영혼 추가"  -- Priestess add

	L.custom_on_markpossessed = "빙의된 보스 공격대 아이콘"
	L.custom_on_markpossessed_desc = "영혼에 빙의된 보스에게 해골 공격대 아이콘을 표시합니다."

	L.assault_stun = "탱커 기절!"
	L.assault_message = "혹한의 공격"
	L.full_power = "전체 파워"
	L.hp_to_go_power = "%d%% 생명력 이동! (파워: %d)"
	L.hp_to_go_fullpower = "%d%% 생명력 이동! (전체 파워)"
end

L = BigWigs:NewBossLocale("Tortos", "koKR")
if L then
	L.kick = "등껍질 차기"
	L.kick_desc = "몇개의 등껍질을 찾는지 정보를 표시합니다."
	L.kick_message = "회오리 거북: %d"

	L.custom_off_turtlemarker = "거북이 공격대 아이콘"  -- 대상 표시기 아이콘
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
	L.lower_hatch_trigger = "아랫둥지에 있는 알들이 부화하기 시작합니다!"
	L.upper_hatch_trigger = "위쪽 둥지에 있는 알들이 부화하기 시작합니다!"

	L.nest = "둥지"
	L.nest_desc = "둥지에 관련된 경고를합니다. |cffff0000만약 당신이 둥지를 처리하는 역할을 맞지 않았다면 이 경고를 해제하는게 좋습니다!|r"

	L.flight_over = "비행 남은 시간 %d 초!"
	L.upper_nest = "|cff008000위쪽|r 둥지"
	L.lower_nest = "|cffff0000아래쪽|r 둥지"
	L.up = "위쪽"
	L.down = "아래쪽"
	L.add = "추가"
	L.big_add_message = "%s에 둥지 수호자 추가"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "koKR")
if L then
	L.red_spawn_trigger = "진흥빛 안개"
	L.blue_spawn_trigger = "하늘빛 안개"
	L.yellow_spawn_trigger = "Amber Fog"

	L.adds = "Reveal Adds"
	L.adds_desc = "Warnings for when you reveal a Crimson, Amber, or Azure Fog and for how many Crimson Fogs remain."

	L.custom_off_ray_controllers = "적외선 조절"
	L.custom_off_ray_controllers_desc = "Use the %s%s%s raid markers to mark people who will control the ray spawn positions and movement.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.custom_off_parasite_marks = "Dark parasite marker"
	L.custom_off_parasite_marks_desc = "To help healing assignments, mark the people who have dark parasite on them with %s%s%s.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.initial_life_drain = "생명력 흡수"
	L.initial_life_drain_desc = "Message for the initial Life Drain cast to help keeping up healing received reducing debuff."

	L.life_drain_say = "%dx 흡수"

	L.rays_spawn = "Rays spawn"
	L.red_add = "|cffff0000붉은색|r 추가"
	L.blue_add = "|cff0000ff푸른색|r 추가"
	L.yellow_add = "|cffffff00노란색|r 추가"
	L.death_beam = "분해 광선"
	L.red_beam = "|cffff0000붉은색|r 광선"
	L.blue_beam = "|cff0000ff푸른색|r 광선"
	L.yellow_beam = "|cffffff00노란색|r 광선"
end

L = BigWigs:NewBossLocale("Primordius", "koKR")
if L then
	L.mutations = "변형 |cff008000(%d)|r |cffff0000(%d)|r"
	L.acidic_spines = "Acidic Spines (Splash Damage)"
end

L = BigWigs:NewBossLocale("Dark Animus", "koKR")
if L then
	L.engage_trigger = "The orb explodes!"

	L.siphon_power = "Siphon Anima (%d%%)"
	L.siphon_power_soon = "Siphon Anima (%d%%) %s soon!"
	L.font_empower = "Font + Empower"
	L.slam_message = "Slam"
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
	L.custom_off_diffused_add_marker = "Diffused Lightning Marker"
	L.custom_off_diffused_add_marker_desc = "Mark the Diffused Lightning adds"

	L.stuns = "Stuns"
	L.stuns_desc = "Show bars for stun durations, for use with handling Ball Lightnings."

	L.aoe_grip = "AoE grip"
	L.aoe_grip_desc = "Warning for when a Death Knight uses Gorefiend's Grasp, for use with handling Ball Lightnings."

	L.last_inermission_ability = "Last intermission ability used!"
	L.safe_from_stun = "You are probably safe from Overcharge stuns"
	L.intermission = "튀어오르는 화살"
	L.diffusion_add = "연쇄 확산"
	L.shock = "전기 충격"
end

L = BigWigs:NewBossLocale("Ra-den", "koKR")
if L then

end

L = BigWigs:NewBossLocale("Trash", "koKR")
if L then
	L.stormcaller = "Zandalari Storm-Caller"
	L.stormbringer = "Stormbringer Draz'kil"
	L.monara = "Monara"
end
