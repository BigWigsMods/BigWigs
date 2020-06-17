local L = BigWigs:NewBossLocale("Kurinnaxx", "koKR")
if not L then return end
if L then
	L.bossName = "쿠린낙스"
end

local L = BigWigs:NewBossLocale("General Rajaxx", "koKR")
if L then
	L.bossName = "장군 라작스"

	L.wave = "단계 알림"
	L.wave_desc = "단계에 대한 알림"

	L.wave_trigger1a = "그들이 오고 있다. 자신의 몸을 지키도록 하라!"
	L.wave_trigger1b = "내가 너는 꼭 마지막에 해치우겠다고 말했던 걸 기억하나, 라작스?" -- CHECK (Remember, Rajaxx, when I said I'd kill you last?)
	L.wave_trigger3 = "응보의 날이 다가왔다! 암흑이 적들의 마음을 지배하게 되리라!"
	L.wave_trigger4 = "‘더는’ 돌벽과 성문 뒤에서 기다릴 수 없다! 복수의 기회를 놓칠 수 없다. 우리가 분노를 터뜨리는 날 용족은 두려움에 떨리라."
	L.wave_trigger5 = "적에게 공포와 죽음의 향연을!"
	L.wave_trigger6 = "스테그헬름은 흐느끼며 목숨을 구걸하리라. 그 아들놈이 그랬던 것처럼! 천 년의 한을 풀리라! 오늘에서야!"
	L.wave_trigger7 = "판드랄! 때가 왔다! 에메랄드의 꿈속에 숨어서 기도나 올려라!"
	L.wave_trigger8 = "건방진...  내 친히 너희를 처치해주마!"

	L.wave_message = "단계 (%d/8)"
end

local L = BigWigs:NewBossLocale("Moam", "koKR")
if L then
	L.bossName = "모암"
end

local L = BigWigs:NewBossLocale("Buru the Gorger", "koKR")
if L then
	L.bossName = "먹보 부루"

	L.fixate = "시선 고정"
	L.fixate_desc = "대상에게 시선을 고정합니다. 다른 공격자의 위협은 무시합니다."
end

local L = BigWigs:NewBossLocale("Ayamiss the Hunter", "koKR")
if L then
	L.bossName = "사냥꾼 아야미스"
end

local L = BigWigs:NewBossLocale("Ossirian the Unscarred", "koKR")
if L then
	L.bossName = "무적의 오시리안"

	L.debuff = "약화마법 경고"
	L.debuff_desc = "약화마법에 대한 경고"
end

local L = BigWigs:NewBossLocale("Ruins of Ahn'Qiraj Trash", "koKR")
if L then
	L.guardian = "아누비사스 감시자"
end
