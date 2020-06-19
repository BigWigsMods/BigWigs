local L = BigWigs:NewBossLocale("Lucifron", "koKR")
if not L then return end
if L then
	L.mc_bar = "정배: %s"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "koKR")
if L then
	L.disabletrigger = "이럴 수가! 그만! 제발 그만! 내가 졌다! 내가 졌어!"
	--L.power_next = "Next Power"
end

L = BigWigs:NewBossLocale("Ragnaros", "koKR")
if L then
	L.submerge_trigger = "나의 종들아"
	L.engage_trigger = "이제 너희"

	L.knockback_message = "광역 튕겨냄!"
	L.knockback_bar = "광역 튕겨냄"

	L.submerge = "사라짐 경고"
	L.submerge_desc = "라그나로스 사라짐 & 피조물에 대한 경고"
	L.submerge_message = "90초간 라그나로스 사라짐. 피조물 등장!"
	L.submerge_bar = "피조물 등장"

	L.emerge = "등장 경고"
	L.emerge_desc = "라그나로스 등장에 대한 경고"
	L.emerge_message = "라그나로스가 등장했습니다. 3분후 피조물 소환!"
	L.emerge_bar = "라그나로스 등장"
end

