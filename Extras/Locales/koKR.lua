local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "koKR")

if not L then return end


-- Custombars.lua

L["Local"] = "로컬"
L["%s: Timer [%s] finished."] = "%s: [%s] 타이머가 종료되었습니다."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true

-- Version.lua
L["should_upgrade"] = "Big Wigs가 구버전입니다. 보스와 전투를 시작하기전에 업데이트를 권장합니다."
L["out_of_date"] = "구버전을 사용중인 플레이어: %s."
L["not_using"] = "Big Wigs 미사용중인 그룹 멤버: %s."


-- Proximity.lua

L["Proximity"] = "접근"
L["Close Players"] = "가까운 플레이어"
L["Options for the Proximity Display."] = "접근 표시에 대한 설정입니다."
L["|cff777777Nobody|r"] = "|cff777777아무도 없음|r"
L["Sound"] = "효과음"
L["Play sound on proximity."] = "접근 표시에 효과음을 재생합니다."
L["Disabled"] = "미사용"
L["Disable the proximity display for all modules that use it."] = "모든 모듈의 접근 표시를 비활성화 합니다."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "다음 표시때 접근 표시를 표시하도록 합니다. 이것을 비활성화 하려면 옵션을 통해 전환하세요."
L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "접근 표시가 고정되어 있습니다. 고정을 해제하길 원하거나 설정하려면 Big Wigs 아이콘의 우클릭하여 기타 -> 접근 -> 표시 이곳을 통해 이동 또는 기타 설정을 할 수 있습니다."

L.proximity = "접근 표시"
L.proximity_desc = "해당 보스전에서 필요 시 자신과 근접해 있는 플레이어 목록을 표시하는 접근 표시창을 표시합니다."

L.font = "Fonts\\2002.TTF"

L["Close"] = "닫기"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "접근 표시를 닫습니다.\n\n완전히 비활성화기 위해서는 해당 보스 모듈에 있는 옵션의 접근 표시를 끄세요."
L["Test"] = "테스트"
L["Perform a Proximity test."] = "접근 테스트를 실행합니다."
L["Display"] = "표시"
L["Options for the Proximity display window."] = "접근 표시 창을 설정합니다."
L["Lock"] = "고정"
L["Locks the display in place, preventing moving and resizing."] = "미리 이동 또는 크기조절을 하고 표시할 장소에 고정합니다."
L["Title"] = "제목"
L["Shows or hides the title."] = "제목을 표시하거나 숨깁니다."
L["Background"] = "배경"
L["Shows or hides the background."] = "배경을 표시하거나 숨깁니다."
L["Toggle sound"] = "소리 전환"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "접근 창에 다른 플에이어와 가까이 있을 경에 알리는 경고음을 켜거나 끌수있게 합니다."
L["Sound button"] = "소리 버튼"
L["Shows or hides the sound button."] = "소리 버튼을 표시하거나 숨깁니다."
L["Close button"] = "닫기 버튼"
L["Shows or hides the close button."] = "닫기 버튼을 표시하거나 숨깁니다."
L["Show/hide"] = "표시/숨김"
