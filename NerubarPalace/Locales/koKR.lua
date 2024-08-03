local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "koKR")
if not L then return end
if L then
	L.chunky_viscera_message = "보스 먹이기! (엑스트라 버튼)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "koKR")
if L then
	L.grasp_from_beyond = "촉수"
	L.grasp_from_beyond_say = "촉수"
	L.bloodcurdle = "산개"
	L.bloodcurdle_on_you = "산개" -- Singular of Spread
	L.goresplatter = "바닥"
end

L = BigWigs:NewBossLocale("Rasha'nan", "koKR")
if L then
	L.rolling_acid = "파도"
	L.spinnerets_strands = "가닥"
	L.enveloping_webs = "거미줄"
	L.enveloping_web_say = "거미줄" -- Singular of Webs
	L.erosive_spray = "분무"
	L.caustic_hail = "다음 위치"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "koKR")
if L then
	L.sticky_web_say = "거미줄"
	L.infest_message = "당신에게 감연 시전 중!"
	L.infest_say = "기생충"
	L.experimental_dosage_say = "알 흡수"
	L.unstable_infusion = "이감 바닥"
	L.custom_on_experimental_dosage_marks = "실험용 투여제 할당"
	L.custom_on_experimental_dosage_marks_desc = "'실험용 투여제'에 영향을 받는 플레이어를 근접 > 원거리 > 힐러 우선 순위로 {rt6}{rt4}{rt3}{rt7}에 할당합니다. 채팅 및 대상 메시지에 영향을 미칩니다."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "koKR")
if L then
	L.assasination = "암살"
	L.twiligt_massacre = "돌진"
	L.nexus_daggers = "단검"
end
