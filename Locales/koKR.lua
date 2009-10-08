local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "koKR")

if not L then return end

-- Core.lua
L["%s enabled"] = "%s - 활성화"	-- "<boss> enabled"
L["%s has been defeated"] = "%s 물리침"     -- "<boss> has been defeated"

L.bosskill = "보스 사망"
L.bosskill_desc = "보스를 물리쳤을 때 알림니다."
L.berserk = "광폭화"
L.berserk_desc = "보스가 언제 광폭화가 되는지 경고합니다."

L.already_registered = "|cffff0000경고:|r |cff00ff00%s|r (|cffffff00%d|r) 이미 Big Wigs 에서 보스 모듈로 존재하지만, 다시 등록이 필요합니다 (revision에 |cffffff00%d|r). 이 것은 일반적으로 애드온 업데이트 실패로 인하여 이 모듈이 당신의 애드온 폴더에 두개의 사본이 있는 것을 뜻합니다. 당신이 가지고 있는 Big Wigs 폴더의 삭제와 재설치를 권장합니다."

-- Loader / Options.lua
L["You are running an official release of Big Wigs %s (revision %d)"] = "Big Wigs %s (revision %d) 의 공식 릴리스가 실행중입니다."
L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"] = "Big Wigs %s (revision %d) 의 알파 릴리스가 실행중입니다."
L["You are running a source checkout of Big Wigs %s directly from the repository."] = "저장소에서 Big Wigs %s 을 직접 소스를 체크 아웃을 실행하고 있습니다."
L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = "Big Wigs을 사용할 수있는 새로운 릴리스는 curse.com, wowinterface.com, wowace.com 또는 Curse Updater를 통하여 새로운 릴리스 버전을 찾아 사용할수 있습니다."

-- XXX Our tooltip sucks, I want these things gone and automated!
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55f클릭|r : 모두 초기화 |cffeda55f알트-클릭|r 비활성화 |cffeda55f컨트롤-알트-클릭|r : BigWigs 비활성화."
L["Active boss modules:"] = "사용중인 보스 모듈:"
L["All running modules have been reset."] = "활성화된 모든 모듈이 초기화 되었습니다."
L["Big Wigs is currently disabled."] = "현재 Big Wigs가 비활성화 상태입니다."
L["|cffeda55fClick|r to enable."] = "|cffeda55f클릭|r 활성화."
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f클릭|r 모든 모듈 초기화. |cffeda55fAlt-클릭|r 모두 비활성화. |cffeda55fCtrl-Alt-클릭|r Big Wigs을 완전히 비활성화."
L["All running modules have been reset."] = "모든 실행중인 모듈을 초기화합니다."

L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."] = "Big Wigs가 자신보다 최근 버전이나 이전 버전인 사람들을 /BWV 를 입력하여 확인 가능합니다."
L["Up to date:"] = "최신 버전:"
L["Out of date:"] = "구 버전"
L["No Big Wigs 3.0:"] = "Big Wigs 3.0 미사용:"

-- Options.lua
-- XXX Perhaps option descriptions should be in key form, so it's
-- XXX L.iconDesc = .. instead of L["Bla bla bla ...
L["Customize ..."] = "사용자 정의 ..."
L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"] = "Big Wigs에 오신 것을 환영합니다. 보스와의 전투시 어느 정도의 여유를 드립니다. 귀하의 공격대 그룹을 위하여 새로운 보스와의 조우시 준비에 도움이 됩니다.\n"
L["Configure ..."] = "설정 ..."
L["Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."] = "인터페이스 옵션 창을 닫습니다. 그리고 바와 같은 것들에 대한 메시지가 표시가 되며 구성할 수있습니다.\n\n만약 더 많은 사용자 정의를 하고 싶다면, 왼쪽 옵션 트리에서 Big Wigs 옵션을 클릭하여 확장하여 '사용자 정의 ...' 찾으세요."
L["Sound"] = "소리"
L["Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"] = "메세지와 함께 소리를 사용합니다.\n\n|cffff4411각 메세지에 대한 소리가 있으며 그 소리를 통하여 보다 효율적으로 메세지에 대하여 인지가 가능합니다.|r"
L["Blizzard warnings"] = "블리자드 경고"
L["Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"] = "블리자드에서 보스에 대한 몇몇 중요 능력에 대하여 경고를 제공합니다. 이러한 메세지를 Big Wigs에서 보다 쉽게 따로 메세지를 제공하기에 블리자드 경고가 방해가 될수 있습니다. \n\n|cffff4411이것을 끌경우 블리자드 경고가 화면 중앙에 나타나지 않지만, 여전히 대화창 프레임에는 표시가 됩니다.|r"
L["Flash and shake"] = "번쩍임과 진동"
L["Certain abilities are important enough to need your full attention. When these abilities affect you Big Wigs can flash and shake the screen.\n\n|cffff4411If you are playing with the nameplates turned on the shaking function will not work due to Blizzard restrictions, the screen will only flash then.|r"] = "특정 기술에 대하여 충분한 주의를 주기 위하여 화면에 번쩍꺼림과 흔들림을 주어 알립니다. \n\n|cffff4411만약에 게임중 이름표 표시가 한번이라도 켜졌을 경우에 이것이 작동이 된다면 진동은 작동하지 않습니다.|r"
L["Raid icons"] = "공격대 아이콘"
L["Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "일부 '폭탄'과 같은 중요한 경고에 대하여 플레이어에게 공격대 전술을 지정합니다.\n\n|cffff4411오직 공격대장이나 승급된 사람만이 가능합니다!|r"
L["Whisper warnings"] = "귓속말 경고"
L["Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "일부 '폭탄'과 같은 중요한 경고에 대하여 플레이어에게 귓속말을 보냅니다.\n\n|cffff4411오직 공격대장이나 승급된 사람만이 가능합니다!|r"
L["Broadcast"] = "알림"
L["Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader/officer or in a 5-man party!|r"] = "Big Wigs으로 부터 발생하는 모든 메세지를 공격대 경보 채널로 알립니다.\n\n|cffff4411오직 5인 파티 던전 또는 공격대장이나 승급된 사람 또는 길드 관리장등만 가능합니다!|r"
L["Raid channel"] = "공격대 채널"
L["Use the raid channel instead of raid warning for broadcasting messages."] = "공격대 경보 채널 대신 알림 메세지를 공격대 대화 채널을 사용합니다."
L["Minimap icon"] = "미니맵 아이콘"
L["Toggle show/hide of the minimap icon."] = "미니맵 아이콘을 표시하거나 숨깁니다."
L["Configure"] = "설정"
L["Test"] = "테스트"
L["Reset positions"] = "위치 초기화"
L["Options for %s."] = "%s 대한 설정입니다."

L["BAR"] = "바"
L["MESSAGE"] = "메세지"
L["SOUND"] = "소리"
L["ICON"] = "아이콘"
L["PROXIMITY"] = "접근표시"
L["WHISPER"] = "귓속말"
L["SAY"] = "일반 대화"
L["FLASHSHAKE"] = "번쩍임과 진동"
L["PING"] = "미니맵 표시"
L["EMPHASIZE"] = "강조"
L["MESSAGE_desc"] = "Big Wigs에서 기술에 대하여 게임 화면에 메세지를 표시합니다. 만약 옵션에서 체크를 해제하면 표시하지 않습니다. 크기 위치등 형태에 관한 설정은 '설정...'을 통하여 하실수 있습니다."
L["BAR_desc"] = "일부 기술에 대하여 적절한 바를 생성하여 표시합니다. 만약 옵션에서 체크를 해제하면 표시하지 않습니다. 크기 위치등 형태에 관한 설정은 '설정...'을 통하여 하실수 있습니다."
L["FLASHSHAKE_desc"] = "중요한 기술에 대하여 효과적으로 알립니다. 만약 옵션에서 체크를 해제하면 화면 흔들림과 번쩍임 효과가 나타나지 않습니다."
L["ICON_desc"] = "Big Wigs에서 일부 중요한 기술에 걸린 플레이어에게 전술 아이콘을 지정합니다."
L["WHISPER_desc"] = "중요한 기술에 대하여 그 기술에 걸린 플레이어에게 귓속말을 보냅니다."
L["SAY_desc"] = "당신이 기술에 걸렸을시 일반 대화로 알립니다. 말풍선으로 쉽게 구별하기 좋습니다."
L["PING_desc"] = "Big Wigs에서 자신이 기술에 걸렸을시 그 위치를 미니맵에 표시합니다. 위치가 중요한 요소로 작용되는 전투에서 효과적입니다."
L["EMPHASIZE_desc"] = "바에 번쩍임등 효과를 통하여 강조를 합니다."
L["Advanced options"] = "고급 옵션"
L["<< Back"] = "<< 뒤로"

L["About"] = "정보"
L["Main Developers"] = "메인 개발자"
L["Maintainers"] = "관리자"
L["License"] = "라이센스"
L["Website"] = "웹사이트"
L["Contact"] = "연락처"
L["See license.txt in the main Big Wigs folder."] = "메인 Big Wigs 폴더의 license.txt를 참조하세요."
L["irc.freenode.net in the #wowace channel"] = "irc.freenode.net의 #wowace 채널"
L["Thanks to the following for all their help in various fields of development"] = "다양한 분야에서 개발을 위해 다음과 같은 사람들의 도움이 있었습니다."

