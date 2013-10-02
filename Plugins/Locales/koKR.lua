local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "koKR")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "모양"
L.bigWigsBarStyleName_Default = "기본값"

L["Clickable Bars"] = "클릭이 가능한 바"
L.clickableBarsDesc = "Big Wigs 바에 클릭을 통해 기본적인 기능을 가지게 합니다. |cffff4411만약 당신이 클릭이가 능한 바를 사용할경우에는\n Big Wigs를 통해 생성된 바에서는 대상 지정, 카메라 시점등의 불편함도 생길수 있으니 유의하시기 바랍니다.\n바의 위에서는 클릭이 가능한 바의 기능이 사용되기 때문입니다."
L["Enables bars to receive mouse clicks."] = "바에 마우스 클릭으로 나타내기를 활성화합니다."
L["Modifier"] = "사용자 설정"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "클릭이 가능한 바를 별도의 사용자가 선택한 키를 조합하여야 작동되게 합니다."
L["Only with modifier key"] = "사용자 키를 위한 적용할 키"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "설정한 키를 통해서만 클릭이 가능한 바가 적용되도록 합니다."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "선택한 바에 대하여 지속시간 동안 바와 메세지에 특수 강조 기능을 적용합니다."
L["Report"] = "보고"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "활성화된 대화창에 현재 바의 상태를 보고합니다. 인스턴스 대화, 공격대, 파티나 일반 창에 알릴 수 있습니다."
L["Remove"] = "삭제"
L["Temporarily removes the bar and all associated messages."] = "해당 바에 관련된 모든 바와 메세지를 제거합니다."
L["Remove other"] = "기타 삭제"
L["Temporarily removes all other bars (except this one) and associated messages."] = "해당 바를 제외한 모든 바와 메세지를 제거합니다."
L.disable = "사용안함"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "해당 바를 교전 모듈에서 체크 해제합니다.(다시 표시하고 싶다면 교전 모듈에서 해당 스킬 경고를 체크하시길 바랍니다.)"

L["Emphasize at... (seconds)"] = "강조... (초)"
L["Scale"] = "크기"
L["Grow upwards"] = "생성 방향"
L["Toggle bars grow upwards/downwards from anchor."] = "바의 생성 방향을 위/아래로 전환합니다."
L["Texture"] = "텍스쳐"
L["Emphasize"] = "강조"
L["Enable"] = "사용"
L["Move"] = "이동"
L.moveDesc = "강조 바를 이동하기 위해 강조 앵커를 표시합니니다. 이 옵션이 비활성화면, 간단히 강조 바의 크기와 색상만 변경할 수 있습니다."
L["Regular bars"] = "일반 바"
L["Emphasized bars"] = "강조 바"
L["Align"] = "정렬"
L["Left"] = "좌측"
L["Center"] = "중앙"
L["Right"] = "우측"
L["Time"] = "시간"
L["Whether to show or hide the time left on the bars."] = "바의 우측에 시간을 숨기거나 표시합니다."
L["Icon"] = "아이콘"
L["Shows or hides the bar icons."] = "바 아이콘을 숨기거나 표시합니다."
L.font = "글꼴"
L["Restart"] = "재시작"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "이전의 시간을 그대로 적용하지않고 새롭게 10초부터 특수강조바를 생성합니다."
L["Fill"] = "채우기"
L["Fills the bars up instead of draining them."] = "바를 채우기로 표시합니다."

L["Local"] = "로컬"
L["%s: Timer [%s] finished."] = "%s: [%s] 타이머가 종료되었습니다."
--L["Custom bar '%s' started by %s user %s."] = "Custom bar '%s' started by %s user %s."

L["Pull"] = "풀링"
L["Pulling!"] = "풀링합니다!"
L["Pull timer started by %s user %s."] = "%2$s님이 %1$s 풀링 타이머를 시작합니다."
L["Pull in %d sec"] = "풀링 %d초 전"
L["Sending a pull timer to Big Wigs and DBM users."] = "Big Wigs과 DBM 사용자에게 풀링 타이머를 보냅니다."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Big Wigs과 DBM 사용자에게 '%s' 사용자 바를 보냅니다."
L["This function requires raid leader or raid assist."] = "이 기능은 공격대장이나 부공격대장만 가능합니다."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "1에서 60 사이의 숫자여야 합니다. 예: /pull 5"
--L["Incorrect format. A correct example is: /raidbar 20 text"] = "Incorrect format. A correct example is: /raidbar 20 text"
--L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."
--L["This function can't be used during an encounter."] = "This function can't be used during an encounter."
--L["Pull timer cancelled by %s."] = "Pull timer cancelled by %s."




-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="koKR", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

