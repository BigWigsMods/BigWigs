local L = BigWigs:NewBossLocale("Kargath Bladefist", "koKR")
if not L then return end
if L then
L.arena_sweeper_desc = "사슬 던지기로 인하여 관중석으로 내동댕이쳐진 이후 관중들에 의하여 쫓겨나기까지의 시간을 표시"
L.blade_dance_bar = "칼춤 도는 중"

end

L = BigWigs:NewBossLocale("The Butcher", "koKR")
if L then
L.adds_multiple = "%d번째 쫄"
L.tank_proximity = "방어 전담 근접 표시" -- Needs review
L.tank_proximity_desc = "잔인무도 공격을 다른 방어 전담과 같이 맞기 위해 5미터 근접 표시창을 표시합니다." -- Needs review

end

L = BigWigs:NewBossLocale("Tectus", "koKR")
if L then
L.adds_desc = "다음 쫄이 언제 전투에 참여하는 지를 확인하기 위한 타이머입니다."
L.custom_off_barrage_marker = "수정 포화 징표 설정"
L.custom_off_barrage_marker_desc = "수정 포화의 대상을 {rt1}{rt2}{rt3}{rt4}{rt5}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.custom_on_shard_marker = "텍터스의 조각 징표 설정"
L.custom_on_shard_marker_desc = "두 마리의 '텍터스의 조각'을 {rt8}{rt7}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.motes = "자갈"
L.shard = "조각"

end

L = BigWigs:NewBossLocale("Brackenspore", "koKR")
if L then
L.creeping_moss_add_heal = "큰 쫄 아래에 덩굴 이끼가 있습니다 (치유 중)"
L.creeping_moss_boss_heal = "보스 아래에 덩굴 이끼가 있습니다 (치유 중)"
L.custom_off_spore_shooter_marker = "포자 식물 징표 설정"
L.custom_off_spore_shooter_marker_desc = [=[포자 식물을 {rt1}{rt2}{rt3}{rt4}의 징표로 설정합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r
|cFFADFF2F팁: 만약 공격대에서 이 옵션을 사용하기로 결정했다면, 징표를 설정하기 위한 가장 빠른 방법은 몹들 위에 마우스를 올리는 것입니다.|r]=]
L.mythic_ability = "특수 기술"
L.mythic_ability_desc = "다음 해일의 부름이나 곰팡이 폭발까지의 시간을 표시해주는 바를 생성합니다."
L.mythic_ability_wave = "해일이 옵니다!"

end

L = BigWigs:NewBossLocale("Twin Ogron", "koKR")
if L then
L.custom_off_volatility_marker = "불안정한 비전 징표 설정"
L.custom_off_volatility_marker_desc = "불안정한 징표의 대상을 {rt1}{rt2}{rt3}{rt4}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.volatility_self_desc = "당신에게 불안정한 비전 디버프가 걸릴 경우를 위한 설정"

end

L = BigWigs:NewBossLocale("Ko'ragh", "koKR")
if L then
L.custom_off_fel_marker = "마법 방출: 악마 징표 설정"
L.custom_off_fel_marker_desc = [=[마법 방출: 악마의 대상을 {rt1}{rt2}{rt3}의 징표로 설정합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r]=]
L.dominating_power_bar = "정신 지배 구체가 떨어짐 (%d)"
L.fire_bar = "모두 폭발합니다!"
L.overwhelming_energy_bar = "구체가 떨어짐 (%d)"

end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "koKR")
if L then
L.add_death_soon = "쫄이 곧 죽습니다!"
L.adds = "뒤틀린 밤의 신봉자"
L.adds_desc = "뒤틀린 밤의 신봉자가 전투에 난입하는 때를 알려주는 타이머"
L.branded_say = "%s (%d) %d미터"
L.custom_off_branded_marker = "낙인 징표 설정"
L.custom_off_branded_marker_desc = [=[낙인의 대상을 {rt3}{rt4}의 징표로 설정합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r]=]
L.custom_off_fixate_marker = "시선집중 징표 설정"
L.custom_off_fixate_marker_desc = [=[고리안 전투마법사의 시선 집중의 대상을 {rt1}{rt2}의 징표로 설정합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r]=]
L.slow_fixate = "감속+시선 집중"

end

L = BigWigs:NewBossLocale("Highmaul Trash", "koKR")
if L then
L.arcanist = "고리안 비전술사"
L.oro = "오로"
L.ritualist = "파괴자 의식술사"
L.runemaster = "고리안 룬술사"

end

