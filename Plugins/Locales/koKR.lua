local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "koKR")

if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Clickable Bars"] = "클릭이 가능한 바"
L.clickableBarsDesc = "Big Wigs 바에 클릭을 통해 기본적인 기능을 가지게 합니다. |cffff4411만약 당신이 클릭이가 능한 바를 사용할경우에는\n Big Wigs를 통해 생성된 바에서는 대상 지정, 카메라 시점등의 불편함도 생길수 있으니 유의하시기 바랍니다.\n바의 위에서는 클릭이 가능한 바의 기능이 사용되기 때문입니다."
L["Enables bars to receive mouse clicks."] = "바에 마우스 클릭으로 나타내기를 활성화합니다."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "선택한 바에 대하여 지속시간 동안 바와 메세지에 특수 강조 기능을 적용합니다."
L["Report"] = "보고"
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = "선택한 바에 대한 정보를 자신이 속한 파티, 공격대에 따라 파티 또는 공격대 대화창으로 알립니다."
L["Remove"] = "삭제"
L["Temporarily removes the bar and all associated messages."] = "해당 바에 관련된 모든 바와 메세지를 제거합니다."
L["Remove other"] = "기타 삭제"
L["Temporarily removes all other bars (except this one) and associated messages."] = "해당 바를 제외한 모든 바와 메세지를 제거합니다."
L["Disable"] = "사용안함"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "해당 바를 교전 모듈에서 체크 해제합니다.(다시 표시하고 싶다면 교전 모듈에서 해당 스킬 경고를 체크하시길 바랍니다.)"

L["Scale"] = "크기"
L["Grow upwards"] = "생성 방향"
L["Toggle bars grow upwards/downwards from anchor."] = "바의 생성 방향을 위/아래로 전환합니다."
L["Texture"] = "텍스쳐"
L["Emphasize"] = "강조"
L["Enable"] = "사용"
L["Move"] = "이동"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "강조 바를 두번째 고정위치로 이동합니다."
L["Flash"] = "섬광"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "강조 바에 붉은색 배경을 번쩍이게 합니다."
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
L["Font"] = "글꼴"

L["Local"] = "로컬"
L["%s: Timer [%s] finished."] = "%s: [%s] 타이머가 종료되었습니다."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "색상"

L["Messages"] = "메세지"
L["Bars"] = "바"
L["Background"] = "배경"
L["Text"] = "글자"
L["Flash and shake"] = "번쩍임과 진동"
L["Normal"] = "일반"
L["Emphasized"] = "강조"

L["Reset"] = "초기화"
L["Resets the above colors to their defaults."] = "위의 색상을 모두 기본으로 초기화 합니다."
L["Reset all"] = "모두 초기화"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "보스 교전 모듈의 사용자가 지정한 색상이 있다면, 이 버튼으로 인해 모든 색상이 초기화되며 다시 설정이 가능합니다."

L["Important"] = "중요"
L["Personal"] = "개인"
L["Urgent"] = "긴급"
L["Attention"] = "주의"
L["Positive"] = "제안"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Big Wigs 메세지 표시를 통해 이 애드온의 메세지를 출력합니다. 이것은 디스플레이와 색상, 아이콘을 지원하는 메시지가 화면에 한 번에 최대 4개로 표시됩니다."
L.emphasizedSinkDescription = "Big Wigs Emphasized 메세지 표시를 통해 이 애드온의 메세지를 출력합니다. 이것은 텍스트와 색상을 지원하는 메세지가 화면에 한번에 하나만 표시됩니다."

L["Messages"] = "메세지"
L["Normal messages"] = "일반 메세지"
L["Emphasized messages"] = "강조 메세지"
L["Output"] = "출력"

L["Use colors"] = "색상 사용"
L["Toggles white only messages ignoring coloring."] = "메세지에 색상 사용을 설정합니다."

L["Use icons"] = "아이콘 사용"
L["Show icons next to messages, only works for Raid Warning."] = "레이드 경고를 위한, 메세지 옆에 아이콘 표시합니다."

L["Class colors"] = "직업 색상"
L["Colors player names in messages by their class."] = "메세지의 플레이어 이름에 직업 색상을 사용합니다."

L["Chat frame"] = "대화창"
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "모든 BigWigs 메세지를 디스플레이 설정에 추가된 기본 대화창에 출력합니다."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "아이콘"

L.raidIconDescription = "중요한 '폭탄'-유형의 보스 능력을 플레이어에게 사용할 경우 BigWigs에서 공격대 대상 아이콘 지정을 설정합니다. 중요 '폭탄'-유형 기술이 2개일 경우 1개의 기술에 첫번째, 그나머지 기술에 대해서는 두번째 아이콘을 지정하여 사용합니다.\n\n|cffff4411주의: 만약에 플레이어가 이미 수동으로 전술 지정이 되어있다면 Big Wigs 에서는 그것을 변경하지 않습니다.|r"
L["Primary"] = "첫번째 아이콘"
L["The first raid target icon that a encounter script should use."] = "첫번째 공격대 대상에게 사용할 아이콘을 지정합니다."
L["Secondary"] = "두번째 아이콘"
L["The second raid target icon that a encounter script should use."] = "두번째 공격대 대상에게 사용할 아이콘을 지정합니다."

L["Star"] = "별"
L["Circle"] = "원"
L["Diamond"] = "다이아몬드"
L["Triangle"] = "세모"
L["Moon"] = "달"
L["Square"] = "네모"
L["Cross"] = "가위표"
L["Skull"] = "해골"
L["|cffff0000Disable|r"] = "|cffff0000비활성화|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "이 옵션을 세트로 Big Wigs 의 기본 소리 경고와 함께 메시지에 대한 블리자드의 공격대 경고 사운드를 사용합니다."

L["Sounds"] = "효과음"

L["Alarm"] = "경보"
L["Info"] = "정보"
L["Alert"] = "알림"
L["Long"] = "장음"
L["Victory"] = "승리"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "%q에 사용할 효과음을 설정합니다.\n\n미리듣기는 CTRL-클릭하세요."
L["Default only"] = "기본음"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["%d yards"] = "%d 미터"
L["Proximity"] = "근접"
L["Sound"] = "효과음"
L["Disabled"] = "미사용"
L["Disable the proximity display for all modules that use it."] = "모든 모듈의 근접 표시를 비활성화 합니다."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "다음 표시때 근접 표시를 표시하도록 합니다. 이것을 비활성화 하려면 옵션을 통해 전환하세요."

L.proximity = "근접 표시"
L.proximity_desc = "해당 보스전에서 필요 시 자신과 근접해 있는 플레이어 목록을 표시하는 근접 표시창을 표시합니다."
L.proximityfont = "Fonts\\2002.TTF"

L["Close"] = "닫기"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "근접 표시를 닫습니다.\n\n완전히 비활성화기 위해서는 해당 보스 모듈에 있는 옵션의 근접 표시를 끄세요."
L["Lock"] = "고정"
L["Locks the display in place, preventing moving and resizing."] = "미리 이동 또는 크기 조절을 하고 표시할 장소에 고정합니다."
L["Title"] = "제목"
L["Shows or hides the title."] = "제목을 표시하거나 숨깁니다."
L["Background"] = "배경"
L["Shows or hides the background."] = "배경을 표시하거나 숨깁니다."
L["Toggle sound"] = "소리 전환"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "근접 창에 다른 플에이어와 가까이 있을 경에 알리는 경고음을 켜거나 끌수있게 합니다."
L["Sound button"] = "소리 버튼"
L["Shows or hides the sound button."] = "소리 버튼을 표시하거나 숨깁니다."
L["Close button"] = "닫기 버튼"
L["Shows or hides the close button."] = "닫기 버튼을 표시하거나 숨깁니다."
L["Show/hide"] = "표시/숨김"

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = "|cff%s%s|r 대화:"
L["Cool!"] = "쿨!"
L["Tips"] = "도움말"
L["Tip of the Raid"] = "공격대 도움말"
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with raid leaders who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = true
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid leader will also be blocked by this, so be careful."] = true
L["Automatic tips"] = "자동 도움말"
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "도움말 기능을 원하지 않는다면 설정에서 비활성화하여 표시하지 않을 수 있습니다."
L["Manual tips"] = "도움말 설명서"
L["Raid leaders have the ability to show the players in the raid a manual tip with the /sendtip command. If you have a raid leader who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = true
L["Output to chat frame"] = "대화 프레임 출력"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = true
L["Usage: /sendtip <index|\"Custom tip\">"] = "Usage: /sendtip <index|\"Custom tip\">"
L["You must be an officer in the raid to broadcast a tip."] = "도움말 알림을 위해서는 승급자이어야 합니다."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "팁 색인 범위 밖으로, %d의 1 인덱스 범위를 허용합니다."

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "특수 강조바"
L.superEmphasizeDesc = "특정 보스가 사용하는 스킬과 관련한 메세지와 바를 특징있게 나타냅니다.\n\n여기에서 보스가 사용하는 기술에 대하여 특수 강조 옵션을 구성합니다.\n\n|cffff4411체크를 해제하면 특수 강조의 모든 능력은 기본적으로 해제됩니다.|r\n"
L["UPPERCASE"] = "대문자"
L["Uppercases all messages related to a super emphasized option."] = "특수 강조의 모든 관련된 메세지를 대문자로 표시합니다."
L["Double size"] = "2배 크기"
L["Doubles the size of super emphasized bars and messages."] = "특수 강보 바와 메세지의 크기를 2배로 합니다."
L["Countdown"] = "카운트다운"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "관련 타이머에 5 초 동안 카운트다운을 추가합니다. \"5... 4... 3... 2... 1... 카운트다운!\" 화면의 중앙에 큰 숫자를 표시합니다."
L["Flash"] = "번쩍임"
L["Flashes the screen red during the last 3 seconds of any related timer."] = "관련된 모든 타이머의 마지막 3 초 동안 화면에 번쩍임 효과를 줍니다."

