local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Plugins", "koKR")

if not L then return end

-- Bars2.lua
L["Bars"] = "바"
L["Normal Bars"] = "일반 바"
L["Emphasized Bars"] = "강조 바"
L["Options for the timer bars."] = "타이머 바에 대한 설정입니다."
L["Toggle anchors"] = "앵커 토글"
L["Show or hide the bar anchors for both normal and emphasized bars."] = "기본 바와 강조 바의 앵커를 숨기거나 표시합니다."
L["Scale"] = "크기"
L["Set the bar scale."] = "바의 크기를 조절합니다."
L["Grow upwards"] = "생성 방향"
L["Toggle bars grow upwards/downwards from anchor."] = "바의 생성 방향을 위/아래로 전환합니다."
L["Texture"] = "텍스쳐"
L["Set the texture for the timer bars."] = "타이머 바의 텍스쳐를 설정합니다."
L["Test"] = "테스트"
L["Close"] = "닫기"
L["Emphasize"] = "강조"
L["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "만료에 가까워진 바를 강조합니다.(10초 이하)."
L["Enable"] = "사용"
L["Enables emphasizing bars."] = "강조 바를 사용합니다."
L["Move"] = "이동"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "강조 바를 두번째 고정위치로 이동합니다."
L["Set the scale for emphasized bars."] = "강조 바의 크기를 설정합니다."
L["Reset position"] = "위치 초기화"
L["Reset the anchor positions, moving them to their default positions."] = "화면의 중앙으로 고정위치를 초기화합니다."
L["Test"] = "테스트"
L["Creates a new test bar."] = "새로운 테스트 바를 생성합니다."
L["Hide"] = "숨김"
L["Hides the anchors."] = "앵커를 숨깁니다."
L["Flash"] = "섬광"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "강조 바에 붉은색 배경을 번쩍이게 합니다."
L["Regular bars"] = "일반 바"
L["Emphasized bars"] = "강조 바"
L["Align"] = "정렬"
L["How to align the bar labels."] = "바 문자를 표시될 곳을 선택합니다."
L["Left"] = "좌측"
L["Center"] = "중앙"
L["Right"] = "우측"
L["Time"] = "시간"
L["Whether to show or hide the time left on the bars."] = "바의 우측에 시간을 숨기거나 표시합니다."
L["Icon"] = "아이콘"
L["Shows or hides the bar icons."] = "바 아이콘을 숨기거나 표시합니다."
L["Font"] = "글꼴"
L["Set the font for the timer bars."] = "타이머 바의 글꼴을 설정합니다."

-- Colors.lua
L["Colors"] = "색상"

L["Messages"] = "메세지"
L["Bars"] = "바"
L["Short bars"] = "짧은바"
L["Long bars"] = "긴바"
L["Color "] = "색상 "
L["Number of colors"] = "색상의 수"
L["Background"] = "배경"
L["Text"] = "글자"
L["Reset"] = "초기화"

L["Bar"] = "바"
L["Change the normal bar color."] = "기본 바 색상을 변경합니다."
L["Emphasized bar"] = "강조 바"
L["Change the emphasized bar color."] = "강조 바 색상을 변경합니다."

L["Colors of messages and bars."] = "메세지와 바의 색상을 설정합니다."
L["Change the color for %q messages."] = "%q 메세지에 대한 색생을 변경합니다."
L["Change the %s color."] = "%s의 색상을 변경합니다."
L["Change the bar background color."] = "배경 색상을 변경합니다."
L["Change the bar text color."] = "글자 색상을 변경합니다."
L["Resets all colors to defaults."] = "모든 색상을 기본 설정으로 초기화합니다."

L["Important"] = "중요"
L["Personal"] = "개인"
L["Urgent"] = "긴급"
L["Attention"] = "주의"
L["Positive"] = "제안"
L["Bosskill"] = "보스사망"
L["Core"] = "코어"

L["color_upgrade"] = "마지막 버전에서부터 새적용 사항을 작동되게 메세지와 바에 대한 색상값이 초기화 되었습니다. 만약 이것을 다시 조절하고 싶다면, Big Wigs 아이콘에 마우스 우-클릭하고 플러그인 -> 색상으로 이동하여 설정하세요."

-- Messages.lua
L["Messages"] = "메세지"
L["Options for message display."] = "메세지 표시에 대한 설정입니다."

L["BigWigs Anchor"] = "BigWigs 메세지 위치"
L["Output Settings"] = "출력 설정"

L["Show anchor"] = "고정 위치 표시"
L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "메세지의 고정 위치를 표시합니다.\n\n'BigWigs'로 출력이 선택되어 있을 때에만 표시합니다."

L["Use colors"] = "색상 사용"
L["Toggles white only messages ignoring coloring."] = "메세지에 색상 사용을 설정합니다."

L["Scale"] = "크기"
L["Set the message frame scale."] = "메세지창의 크기를 설정합니다."

L["Use icons"] = "아이콘 사용"
L["Show icons next to messages, only works for Raid Warning."] = "레이드 경고를 위한, 메세지 옆에 아이콘 표시합니다."

L["Class colors"] = "직업 색상"
L["Colors player names in messages by their class."] = "메세지의 플레이어 이름에 직업 색상을 사용합니다."

L["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000색|cffff00ff상|r"
L["White"] = "흰색"

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "모든 BigWigs 메세지를 디스플레이 설정에 추가된 기본 대화창에 출력합니다."

L["Chat frame"] = "대화창"

L["Test"] = "테스트"
L["Close"] = "닫기"

L["Reset position"] = "위치 초기화"
L["Reset the anchor position, moving it to the center of your screen."] = "화면의 중앙으로 고정 위치를 초기화합니다."

L["Spawns a new test warning."] = "새 테스트 경고를 표시합니다."
L["Hide"] = "숨김"
L["Hides the anchors."] = "앵커를 숨깁니다."

-- RaidIcon.lua

L["Raid Icons"] = "공격대 아이콘"
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "중요한 '폭탄'-유형의 보스 능력을 플레이어에게 사용할 경우 BigWigs에서 공격대 대상 아이콘 지정을 설정합니다."

L["Place"] = "지정"
L["Place Raid Icons"] = "공격대 아이콘 지정"
L["Toggle placing of Raid Icons on players."] = "플레이어에 공격대 아이콘을 지정합니다."

L["Icon"] = "아이콘"
L["Set Icon"] = "아이콘 설정"
L["Set which icon to place on players."] = "플레이어에 지정할 아이콘을 설정합니다."

L["Use the %q icon when automatically placing raid icons for boss abilities."] = "보스 능력에 대해 자동적으로 공격대 아이콘을 %q 로 지정하도록 합니다."

L["Star"] = "별"
L["Circle"] = "원"
L["Diamond"] = "다이아몬드"
L["Triangle"] = "세모"
L["Moon"] = "달"
L["Square"] = "네모"
L["Cross"] = "가위표"
L["Skull"] = "해골"

-- RaidWarn.lua
L["RaidWarning"] = "공격대경보"

L["Whisper"] = "귓속말"
L["Toggle whispering warnings to players."] = "플레이어에게 귓속말 경보 알림을 전환합니다."

L["raidwarning_desc"] = "BigWigs가 보스 메세지를 출력할 곳을 설정하세요."

-- Sound.lua

L["Sounds"] = "효과음"
L["Options for sounds."] = "효과음에 대한 설정입니다."

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "%q에 사용할 효과음을 설정합니다.\n\n미리듣기는 CTRL-클릭하세요."
L["Use sounds"] = "효과음 사용"
L["Toggle all sounds on or off."] = "모든 효과음을 켜거나 끕니다."
L["Default only"] = "기본음"
L["Use only the default sound."] = "기본음만을 사용합니다."
