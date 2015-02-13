local L = BigWigs:NewBossLocale("Gruul", "koKR")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Oregorger", "koKR")
if L then
	L.berserk_trigger = "굶주린 광물먹보가 광란에 빠집니다!"

	L.shard_explosion = "폭발성 파편 폭발"
	L.shard_explosion_desc = "폭발을 대비하기 위한 강조 바를 별도로 표시합니다."

	L.hunger_drive_power = "%d번째 %s - %d의 광석을 더 먹여야 합니다!"
end

L = BigWigs:NewBossLocale("The Blast Furnace", "koKR")
if L then
	L.custom_on_shieldsdown_marker = "보호막 소멸 징표 설정"
	L.custom_on_shieldsdown_marker_desc = "보호막이 소멸된 원시의 정령술사를 {rt8}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."


	L.heat_increased_message = "열기가 증가합니다! %s초마다 폭파합니다."

	L.bombs_dropped = "폭탄이 떨어졌습니다! (%d)"
end

L = BigWigs:NewBossLocale("Hans'gar and Franzok", "koKR")
if L then

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "koKR")
if L then
	L.molten_torrent_self = "나에게 시전한 녹아내린 격류"
	L.molten_torrent_self_desc = "녹아내린 격류의 대상이 당신일 때 특수 카운트를 해줍니다."
	L.molten_torrent_self_bar = "폭발합니다!"
end

L = BigWigs:NewBossLocale("Kromog", "koKR")
if L then

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "koKR")
if L then
	L.next_mount = "곧 탈것에 탑승합니다!"

	L.custom_off_pinned_marker = "봉쇄 징표 설정"
	L.custom_off_pinned_marker_desc = "땅에 꽂힌 창을 {rt8}{rt7}{rt6}{rt5}{rt4}의 징표로 설정합니다.\n|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r\n|cFFADFF2F팁: 만약 공격대에서 이 옵션을 사용하기로 결정했다면, 징표를 설정하기 위한 가장 빠른 방법은 창 위에 마우스를 올리는 것입니다.|r"

	L.custom_off_conflag_marker = "거대한 불길 징표 설정"
	L.custom_off_conflag_marker_desc = "거대한 불길의 대상을 {rt1}{rt2}{rt3}의 징표로 설정합니다.\n|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r"
end

L = BigWigs:NewBossLocale("Operator Thogar", "koKR")
if L then
	L.cauterizing_bolt_message = "주시 대상이 소작의 화살을 시전합니다!"

	L.trains = "기차 경고"
	L.trains_desc = "각 라인마다 다음 기차가 언제 올 지에 대해서 타이머와 메시지를 표시합니다. 라인은 보스부터 입구쪽으로 '보스 1 2 3 4 입구'로 숫자가 매겨져 있습니다."

	L.lane = "%s번째 라인 : %s"
	L.train = "기차"
	L.adds_train = "쫄 기차"
	L.big_add_train = "큰 쫄 기차"
	L.cannon_train = "대포 기차"
	--L.deforester = "Deforester" -- /dump (EJ_GetSectionInfo(10329))
	L.random = "무작위 기차"
end

L = BigWigs:NewBossLocale("The Iron Maidens", "koKR")
if L then
	L.ship_trigger = "무쌍호 주 대포를 쏠 준비를 합니다!"

	L.ship = "배로 점프"

	L.custom_off_heartseeker_marker = "피에 젖은 심장추적자 징표 설정"
	L.custom_off_heartseeker_marker_desc = "피에 젖은 심장추적자의 대상을 {rt1}{rt2}{rt3}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."

	L.power_message = "강철 분노 %d!"
end

L = BigWigs:NewBossLocale("Blackhand", "koKR")
if L then
	L.custom_off_markedfordeath_marker = "죽음의 표적 징표 설정"
	L.custom_off_markedfordeath_marker_desc = "죽음의 징표의 대상을 {rt1}{rt2}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
end

