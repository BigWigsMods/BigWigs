local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "koKR")

if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

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
L["Reset"] = "초기화"

L["Bar"] = "바"
L["Change the normal bar color."] = "일반 바 색상을 변경합니다."
L["Emphasized bar"] = "강조 바"
L["Change the emphasized bar color."] = "강조 바 색상을 변경합니다."

L["Colors of messages and bars."] = "메세지와 바의 색상입니다."
L["Change the color for %q messages."] = "%q 메세지의 색상을 변경합니다."
L["Change the bar background color."] = "바 배경 색상을 변경합니다."
L["Change the bar text color."] = "바 글꼴 색상을 변경합니다."
L["Resets all colors to defaults."] = "모두 기본 색상으로 초기화 합니다."

L["Important"] = "중요"
L["Personal"] = "개인"
L["Urgent"] = "긴급"
L["Attention"] = "주의"
L["Positive"] = "제안"
L["Bosskill"] = "보스사망"
L["Core"] = "코어"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the Big Wigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."

L["Messages"] = "메세지"

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
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "중요한 '폭탄'-유형의 보스 능력을 플레이어에게 사용할 경우 BigWigs에서 공격대 대상 아이콘 지정을 설정합니다."

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

L.soundDefaultDescription = "With this option set, Big Wigs will only use the default Blizzard raid warning sound for messages that come with a sound alert. Note that only some messages from encounter scripts will trigger a sound alert."

L["Sounds"] = "효과음"
L["Options for sounds."] = "효과음에 대한 설정입니다."

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

L["Cool!"] = "쿨!"
L["Tips"] = "도움말"
L["Configure how the raiding tips should be displayed."] = "레이드중 도움말 표시 방법에 대하여 설정합니다."
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with raid leaders who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = true
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid leader will also be blocked by this, so be careful."] = true
L["Automatic tips"] = "자동 도움말"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "도움말 기능을 원하지 않는다면 설정에서 비활성화하여 표시하지 않을 수 있습니다."
L["Manual tips"] = "도움말 설명서"
L["Raid leaders have the ability to show the players in the raid a manual tip with the /sendtip command. If you have a raid leader who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = true
L["Output to chat frame"] = "대화 프레임 출력"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = true
L["Usage: /sendtip <index|\"Custom tip\">"] = "Usage: /sendtip <index|\"Custom tip\">"
L["You must be the raid leader to broadcast a tip."] = "도움말 알림을 위해서는 공격대장이어야 합니다."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "팁 색인 범위 밖으로, %d의 1 인덱스 범위를 허용합니다."

