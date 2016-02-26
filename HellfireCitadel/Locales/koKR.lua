local L = BigWigs:NewBossLocale("Hellfire Assault", "koKR")
if not L then return end
if L then
L.left = "왼쪽: %s" -- Needs review
L.middle = "가운데: %s" -- Needs review
L.right = "오른쪽: %s" -- Needs review

end

L = BigWigs:NewBossLocale("Kilrogg Deadeye", "koKR")
if L then
L.add_warnings = "소환수 추가 경고"

end

L = BigWigs:NewBossLocale("Gorefiend", "koKR")
if L then
L.fate_root_you = "이어진 운명 - 묶임" -- Needs review
L.fate_you = "이어진 운명 - %s 묶임" -- Needs review

end

L = BigWigs:NewBossLocale("Shadow-Lord Iskar", "koKR")
if L then
L.bindings_removed = "결속 제거 (%d/3)"
L.custom_off_binding_marker = "어둠의 결속 징표"
L.custom_off_binding_marker_desc = [=[어둠의 결속 대상을 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r]=]
L.custom_off_wind_marker = "실체 없는 바람 징표"
L.custom_off_wind_marker_desc = [=[실체 없는 바람 대상을 {rt1}{rt2}{rt3}{rt4}{rt5} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r]=]

end

L = BigWigs:NewBossLocale("Socrethar the Eternal", "koKR")
if L then
L.dominator_desc = "살게레이 통솔자가 언제 생성되는지 경고합니다."
L.portals = "차원문 이동"
L.portals_desc = "2단계에서 차원문이 언제 이동하는지 알리기 위한 타이머입니다."
L.portals_msg = "차원문 이동!"

end

L = BigWigs:NewBossLocale("Fel Lord Zakuun", "koKR")
if L then
L.custom_off_seed_marker = "파괴의 씨앗 징표"
L.custom_off_seed_marker_desc = "파괴의 씨앗 대상을 {rt1}{rt2}{rt3}{rt4}{rt5} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.seed = "씨앗"
L.tank_proximity = "방어 전담 근접 표시"
L.tank_proximity_desc = "잔인무도와 중무장 능력을 다른 방어 전담과 같이 맞기 위해 5미터 근접 표시창을 표시합니다."

end

L = BigWigs:NewBossLocale("Tyrant Velhari", "koKR")
if L then
L.font_removed_soon = "타락의 샘 곧 없어짐!"

end

L = BigWigs:NewBossLocale("Mannoroth", "koKR")
if L then
L["182212"] = "불지옥 차원문 닫힘!"
L["185147"] = "파멸의 군주 차원문 닫힘!"
L["185175"] = "임프 차원문 닫힘!"
L.custom_off_doom_marker = "파멸의 징표 징표"
L.custom_off_doom_marker_desc = "신화 난이도에서, 파멸의 징표 대상을 {rt1}{rt2}{rt3} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.custom_off_gaze_marker = "만노로스의 응시 징표"
L.custom_off_gaze_marker_desc = "만노로스의 응시 대상을 {rt1}{rt2}{rt3} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.custom_off_wrath_marker = "굴단의 분노 징표"
L.custom_off_wrath_marker_desc = "굴단의 분노 대상을 {rt8}{rt7}{rt6}{rt5}{rt4} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.felseeker_message = "%s (%d) %dm"
L.gaze = "응시 (%d)"

end

L = BigWigs:NewBossLocale("Archimonde", "koKR")
if L then
L.chaos_bar = "%s -> %s"
L.chaos_from = "%s from %s"
L.chaos_helper_message = "혼돈: %d"
L.chaos_to = "%s to %s"
L.custom_off_chaos_helper = "불러일으킨 혼돈 헬퍼"
L.custom_off_chaos_helper_desc = "신화 난이도에서만 동작합니다. 이 기능은 혼돈 번호를 일반 메시지 및 대화로 표시해 줍니다. 대화. 현재 사용 중인 전략에 따라 이 기능이 유용할수도, 유용하지 않을수도 있습니다."
L.custom_off_infernal_marker = "지옥불 멸망의 인도자 징표"
L.custom_off_infernal_marker_desc = "혼돈의 비로 생성되는 지옥불 멸망의 인도자를 {rt1}{rt2}{rt3}{rt4}{rt5} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.custom_off_legion_marker = "군단의 징표 징표"
L.custom_off_legion_marker_desc = "군단의 징표 대상을 {rt1}{rt2}{rt3}{rt4} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.custom_off_torment_marker = "구속된 고통 징표"
L.custom_off_torment_marker_desc = "구속된 고통 대상을 {rt1}{rt2}{rt3} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.infernal_count = "%s (%d/%d)"
L.markofthelegion_self = "당신에게 군단의 징표"
L.markofthelegion_self_bar = "징표 폭발!"
L.markofthelegion_self_desc = "당신에게 군단의 징표가 걸렸을때 표시해주는 특수 카운트다운 입니다."
L.torment_removed = "고통 제거됨 (%d/%d)"

end

L = BigWigs:NewBossLocale("Hellfire Citadel Trash", "koKR")
if L then
L.anetheron = "아네테론" -- Needs review
L.azgalor = "아즈갈로" -- Needs review
L.bloodthirster = "피에 굶주린 괴물" -- Needs review
L.burster = "그림자 광견" -- Needs review
L.daggorath = "다그고라스" -- Needs review
L.darkcaster = "피눈물 암흑술사" -- Needs review
L.eloah = "결속사 엘로아" -- Needs review
L.enkindler = "불타는 점화술사" -- Needs review
L.faithbreaker = "에레다르 신념파괴자" -- Needs review
L.graggra = "그락그라" -- Needs review
L.kazrogal = "카즈로갈" -- Needs review
L.kuroh = "수하 쿠로" -- Needs review
L.orb = "파괴의 보주" -- Needs review
L.peacekeeper = "피조물 평화감시단" -- Needs review
L.talonpriest = "타락한 갈퀴사제" -- Needs review
L.weaponlord = "무기군주 멜키오르" -- Needs review

end

