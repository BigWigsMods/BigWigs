local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "koKR")
if not L then return end

L.general = "일반"
L.advanced = "고급"
L.comma = ", "

L.positionX = "X 위치"
L.positionY = "Y 위치"
L.positionExact = "정확한 위치"
L.positionDesc = "고정기로부터 정확한 위치를 원한다면 상자에 입력하거나 슬라이더를 움직이세요."
L.width = "너비"
L.height = "높이"
L.sizeDesc = "보통 고정기를 끌어서 크기를 조정합니다. 정확한 크기를 지정하고 싶다면 슬라이더를 사용하거나 직접 수치를 입력 상자안에 써넣으세요."
L.fontSizeDesc = "글씨 크기를 슬라이더를 이용해 조정하거나 직접 수치를 입력 상자안에 써넣으세요 (최대 200)."
L.disabled = "비활성"
L.disableDesc = "'%s' 기능을 비활성화 하려고 하지만 |cffff4411권장하지 않습니다|r.\n\n비활성화 하시겠습니까?"

-- Anchor Points
L.UP = "위"
L.DOWN = "아래"
L.TOP = "상단"
L.RIGHT = "우측"
L.BOTTOM = "하단"
L.LEFT = "좌측"
L.TOPRIGHT = "우측 상단"
L.TOPLEFT = "좌측 상단"
L.BOTTOMRIGHT = "우측 하단"
L.BOTTOMLEFT = "좌측 하단"
L.CENTER = "중앙"
L.customAnchorPoint = "고급: 사용자 지정 앵커 지점"
L.sourcePoint = "원본 지점"
L.destinationPoint = "대상 지점"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "보조 자원"
L.altPowerDesc = "보조 자원 항목은 보스가 플레이어에게 보조 자원을 제공하는 매우 드문 보스에서만 발동합니다. 이 디스플레이는 당신과 당신의 파티가 얼만큼의 '보조 자원'이 있는지 리스트로 표시합니다. 이 디스플레이를 옮기려면, 아래의 테스트 버튼을 사용하십시오."
L.toggleDisplayPrint = "디스플레이가 다음에 표시됩니다. 이 우두머리 전투에서 완전히 비활성하려면 우두머리 전투 옵션에서 끄도록 전환해야 합니다."
L.disabledDisplayDesc = "디스플레이를 사용하는 모든 모듈에서 디스플레이를 비활성화합니다."
L.resetAltPowerDesc = "위치를 비롯한 모든 보조 자원 관련 설정을 초기화합니다."
L.test = "시험용"
L.altPowerTestDesc = "보조 자원 디스플레이를 표시해서 움직일수 있게 하고, 보스 전투에서 주로 어떻게 변화하는지를 보여줍니다."
L.yourPowerBar = "나의 자원 바"
L.barColor = "바 색"
L.barTextColor = "바 이름표 색깔"
L.additionalWidth = "추가 너비"
L.additionalHeight = "추가 높이"
L.additionalSizeDesc = "원래의 디스플레이에서 이 슬라이더로 크기를 추가하거나, 박스에 최대 100까지의 숫자를 입력해서 사이즈를 조절할 수 있습니다."
L.yourPowerTest = "나의 자원: %d" -- Your Power: 42
L.yourAltPower = "나의 %s: %d" -- e.g. Your Corruption: 42
L.player = "플레이어 %d" -- Player 7
L.disableAltPowerDesc = "전역 옵션으로 보조 자원 디스플레이를 비활성화하여, 어떠한 보스 전투에서도 보이지 않게 합니다."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "자동 응답"
L.autoReplyDesc = "우두머리와 전투 중일때 자동으로 귓속말에 응답합니다."
L.responseType = "응답 형식"
L.autoReplyFinalReply = "전투종료시 귓속말"
L.guildAndFriends = "길드원 및 친구들"
L.everyoneElse = "그 외 모두"

L.autoReplyBasic = "우두머리와 전투하느라 바쁩니다."
L.autoReplyNormal = "'%s'와(과) 전투하느라 바쁩니다."
L.autoReplyAdvanced = "'%s' (%s)와(과) 전투하느라 바쁩니다.현재 %d/%d 명이 생존 중입니다."
L.autoReplyExtreme = "'%s' (%s)와(과) 전투하느라 바쁩니다.현재 %d/%d 명이 생존 중입니다: %s"

L.autoReplyLeftCombatBasic = "더이상 우두머리와 싸우고 있지 않습니다."
L.autoReplyLeftCombatNormalWin = "'%s'에게 승리하였습니다."
L.autoReplyLeftCombatNormalWipe = "'%s'에게 전멸하였습니다."
L.autoReplyLeftCombatAdvancedWin = "'%s'에게 %d/%d 명 생존한 채로 승리하였습니다."
L.autoReplyLeftCombatAdvancedWipe = "'%s'에게 %s 에서 전멸하였습니다."

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "바"
L.style = "모양"
L.bigWigsBarStyleName_Default = "기본"
L.resetBarsDesc = "위치를 비롯한 모든 바 관련 설정을 초기화합니다."
L.testBarsBtn = "테스트 바 만들기"
L.testBarsBtn_desc = "당신의 현재 표시 설정으로 테스트용 바를 만듭니다."

L.toggleAnchorsBtnShow = "고정기 표시"
L.toggleAnchorsBtnHide = "고정기 숨김"
L.toggleAnchorsBtnHide_desc = "고정기를 모두 숨겨서 다 그자리에 고정시킵니다."
L.toggleBarsAnchorsBtnShow_desc = "모든 이동 앵커를 표시하여 바를 이동할 수 있게 합니다."

L.emphasizeAt = "다음에 강조... (초)"
L.growingUpwards = "위로 확장"
L.growingUpwardsDesc = "고정기로부터 위 또는 아래로 확장하도록 전환합니다."
L.texture = "텍스쳐"
L.emphasize = "강조"
L.emphasizeMultiplier = "배율"
L.emphasizeMultiplierDesc = "강조 고정기로 이동하는 바가 활성화되지 않았을때, 이 옵션은 해당 바를 강조 바로 이동하지 않고 바의 크기를 주어진 배율만큼 확대시킵니다."

L.enable = "활성화"
L.move = "이동"
L.moveDesc = "강조된 바를 강조 고정기로 이동시킵니다. 이 옵션을 끄면 강조된 바는 단순히 크기 비율과 색상을 변경합니다."
L.emphasizedBars = "강조된 바"
L.align = "정렬"
L.alignText = "문자 정렬"
L.alignTime = "시간 정렬"
L.left = "왼쪽"
L.center = "중앙"
L.right = "오른쪽"
L.time = "시간"
L.timeDesc = "바에 남은 시간을 표시하거나 숨깁니다."
L.textDesc = "바에 문자를 표시하거나 숨깁니다."
L.icon = "아이콘"
L.iconDesc = "바 아이콘을 표시하거나 숨깁니다."
L.iconPosition = "아이콘 위치"
L.iconPositionDesc = "바의 어느 위치에 아이콘이 위치할지 지정합니다."
L.font = "글꼴"
L.restart = "다시 시작"
L.restartDesc = "강조된 바를 10부터 다시 셉니다."
L.fill = "채우기"
L.fillDesc = "바를 비우는 대신 채워나갑니다."
L.spacing = "간격"
L.spacingDesc = "각 바 사이의 간격을 조절합니다."
L.visibleBarLimit = "표시되는 바의 수"
L.visibleBarLimitDesc = "동시에 표시할 바의 최대 개수를 설정합니다."

L.localTimer = "지역"
L.timerFinished = "%s: 타이머 [%s] 종료됨."
L.customBarStarted = "%2$s 사용자 %3$s|1이;가; 사용자 설정 바 '%1$s'|1을;를; 시작했습니다."
L.sendCustomBar = "BigWigs와 DBM 사용자에게 사용자 설정 바 '%s'|1을;를; 보냅니다."

L.requiresLeadOrAssist = "이 기능은 공격대장이나 부공격대장 권한이 필요합니다."
L.encounterRestricted = "이 기능은 우두머리 전투 진행 중에 사용할 수 없습니다."
L.wrongCustomBarFormat = "잘못된 형식입니다. 올바른 예: /raidbar 20 문자"
L.wrongTime = "유효하지 않은 시간이 지정되었습니다. <시간>은 초 단위 숫자, 분:초 형식, 또는 분m으로 입력할 수 있습니다. 예제 5, 1:20 또는 2m."

L.wrongBreakFormat = "1분에서 60분 사이여야 합니다. 올바른 예제: /break 5"
L.sendBreak = "BigWigs와 DBM 사용자에게 휴식 타이머를 보냅니다."
L.breakStarted = "%s 사용자 %s|1이;가; 휴식 타이머를 시작했습니다."
L.breakStopped = "%s|1이;가; 휴식 타이머를 취소했습니다."
L.breakBar = "휴식 시간"
L.breakMinutes = "%d분 후 휴식 종료!"
L.breakSeconds = "%d초 후 휴식 종료!"
L.breakFinished = "휴식 시간이 끝났습니다!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "우두머리 기능 차단"
L.bossBlockDesc = "우두머리 전투 중 차단할 수 있는 다양한 기능들을 설정합니다.\n\n"
L.bossBlockAudioDesc = "우두머리 전투 중 음소거할 음향을 설정합니다. \n\n|cff808080회색|r으로 표시된 옵션들은 WoW의 소리 설정에서 꺼져있습니다.\n\n"
L.movieBlocked = "이 동영상을 본적이 있으므로 건너뜁니다."
L.blockEmotes = "화면 중앙의 감정표현 차단"
L.blockEmotesDesc = "몇몇 우두머리는 특정 능력에 감정표현을 표시합니다, 이 메시지는 너무 길고 설명적입니다. 우리는 게임 플레이를 방해하지 않으면서 당신이 특별한 행동을 하지 않아도 되는, 작고 더 알맞은 메시지를 만들려고 노력합니다.\n\n참고하세요: 우두머리 감정표현를 읽고 싶다면 여전히 대화에서 확인할 수 있습니다."
L.blockMovies = "반복되는 동영상 차단"
L.blockMoviesDesc = "우두머리 전투 동영상이 한번만 재생되도록 허용합니다 (각 한번씩 볼수 있도록) 그 후엔 차단됩니다."
L.blockFollowerMission = "추종자 임무 알림 차단" -- Rename to follower mission
L.blockFollowerMissionDesc = "추종자 임무 알림은 여러가지를 표시하지만 주로 모험이 완료되었을 때 표시합니다.\n\n이 알림들은 우두머리 전투 중 UI를 치명적으로 가릴 수 있습니다, 따라서 차단을 권장합니다."
L.blockGuildChallenge = "길드 도전 알림 차단"
L.blockGuildChallengeDesc = "길드 도전 알림은 여러가지를 표시하지만 주로 당신의 길드 파티의 영웅 던전이나 도전 모드 던전 완료를 표시합니다.\n\n이 알림들은 우두머리 전투 중 UI를 치명적으로 가릴 수 있습니다, 따라서 차단을 권장합니다."
L.blockSpellErrors = "주문 실패 메시지 차단"
L.blockSpellErrorsDesc = "일반적으로 화면 상단에 표시되는 \"마법이 아직 준비되지 않았습니다\" 같은 메시지를 차단합니다."
L.blockZoneChanges = "지역 변경 메시지 차단"
L.blockZoneChangesDesc = "'|cFF33FF99스톰윈드|r' 또는 '|cFF33FF99오그리마|r'와 같이, 새로운 지역으로 이동할 경우 화면의 중상단에 나타나는 메시지를 차단합니다."
L.audio = "음성"
L.music = "배경음악"
L.ambience = "환경 소리"
L.sfx = "효과음"
L.errorSpeech = "오류 음성"
L.disableMusic = "배경음악 끄기 (권장)"
L.disableAmbience = "환경 소리 끄기 (권장)"
L.disableSfx = "효과음 끄기 (권장하지 않음)"
L.disableErrorSpeech = "오류 음성 음소거(권장)"
L.disableAudioDesc = "WoW의 소리 설정에서 '%s' 설정이 꺼지고 교전이 끝난 후에 다시 켜집니다. BigWigs의 알림 소리에 더 집중하는데 도움이 됩니다."
L.blockTooltipQuests = "툴팁에서 퀘스트 목표 표시를 숨깁니다."
L.blockTooltipQuestsDesc = "우두머리를 처치하는 퀘스트를 진행 중인 경우 해당 우두머리에 마우스를 올렸을 때 보통 '0/1 완료' 같은 문구가 툴팁에 표시됩니다. 전투 중에 이 문구들을 숨김으로써 툴팁의 크기가 너무 크게 확장되는 것을 방지합니다."
L.blockObjectiveTracker = "퀘스트 추적기 숨김"
L.blockObjectiveTrackerDesc = "보스 전투 중에 퀘스트 추적기를 숨겨서 화면의 여유 공간을 넓힙니다.\n\n신화 쐐기돌이나 업적을 추적 중일 때는 숨기지 않습니다."

L.blockTalkingHead = "'말하는 머리' NPC 대사 팝업 숨기기"
L.blockTalkingHeadDesc = "'말하는 머리' 는 npc머리를 가지고있는 팝업 대화 박스입니다. |cffff4411가끔|r NPC가 대사를 할때 화면 중앙 하단쪽에 표시됩니다.\n\n어떤 경우에 이 기능의 표시 기능을 숨길지 상황을 선택할수 있습니다.\n\n|cFF33FF99주의점:|r\n 1) 이 기능은 npc의 목소리는 끊기지 않고 재생할 것입니다.\n 2) 안전하게 특정 머리들만 안보이게 될 것입니다. 일회성 퀘스트같이 특별한 머리들은 계속 보일 것입니다."
L.blockTalkingHeadDungeons = "일반 및 명웅 던전"
L.blockTalkingHeadMythics = "신화 및 쐐기돌 던전"
L.blockTalkingHeadRaids = "레이드"
L.blockTalkingHeadTimewalking = "시간여행 (던전 및 레이드)"
L.blockTalkingHeadScenarios = "시나리오"

L.redirectPopups = "BigWigs 메시지에 표시되는 팝업 배너"
L.redirectPopupsDesc = "화면 중앙에 나타나는 '|cFF33FF99금고 슬롯이 잠금 해제됨|r' 등의 팝업 배너가 대신 BigWigs 메시지로 표시됩니다. 이러한 배너는 크기가 크고, 오래 지속되며, 클릭을 방해할 수 있습니다."
L.redirectPopupsColor = "표시되는 팝업 배너의 색상"
L.blockDungeonPopups = "던전 팝업 배너 차단"
L.blockDungeonPopupsDesc = "던전에 입장할 때 표시되는 팝업 배너는 때때로 매우 긴 텍스트를 포함할 수 있습니다. 이 기능을 활성화하면 이러한 팝업 배너가 완전히 차단됩니다."
L.itemLevel = "아이템 레벨: %d"

L.userNotifySfx = "우두머리 기능 차단으로 비활성화된 음향 효과를 강제로 다시 활성화합니다."
L.userNotifyMusic = "우두머리 기능 차단으로 비활성화된 배경음악를 강제로 다시 활성화합니다."
L.userNotifyAmbience = "우두머리 기능 차단으로 비활성화된 환경 소리를 강제로 다시 활성화합니다."
L.userNotifyErrorSpeech = "우두머리 기능 차단으로 비활성화된 오류 음성을 강제로 다시 활성화합니다."

L.subzone_grand_bazaar = "대시장" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "잔달라 항구" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "동쪽 회랑" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "색상"

L.text = "문자"
L.textShadow = "문자 그림자"
L.normal = "일반"
L.emphasized = "강조"

L.reset = "초기화"
L.resetDesc = "위의 색상을 기본 색상으로 초기화합니다."
L.resetAll = "모두 초기화"
L.resetAllDesc = "우두머리 전투 설정에 사용자 설정 색상을 적용했다면, 이 버튼은 여기에 정의된 색상이 대신 사용되도록 모두 초기화합니다."

L.red = "빨강"
L.redDesc = "일반적인 경보"
L.blue = "파랑"
L.blueDesc = "나에게 직접적으로 영향을 주는 것들에 대한 경보(예: 나에게 약화 효과가 걸릴 때)."
L.orange = "주황"
L.yellow = "노랑"
L.green = "초록"
L.greenDesc = "이로운 상황에 대한 경보(예: 나에게 걸린 약화 효과가 제거될 때)."
L.cyan = "청록"
L.cyanDesc = "다음 단계로 전환 같은 교전 상태의 변화에 대한 경보."
L.purple = "보라"
L.purpleDesc = "방어 전담에 관련된 경보(예: 방어 전담이 걸리는 약화 효과 중첩)."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "문자 초읽기"
L.textCountdownDesc = "초읽기 중에 시각적 카운터를 표시합니다."
L.countdownColor = "초읽기 색상"
L.countdownVoice = "초읽기 음성"
L.countdownTest = "초읽기 테스트"
L.countdownAt = "초읽기 시작... (초)"
L.countdownAt_desc = "초읽기가 몇 초 전부터 시작될 지 선택하세요."
L.countdown = "초읽기"
L.countdownDesc = "음성과 문자열 초읽기에 관련된 기능입니다. 기본값으로 초읽기 기능이 켜져있는 경우는 드물지만 우두머리 별 설정에서 아무 우두머리 능력에 대한 초읽기를 켤 수 있습니다."
L.countdownAudioHeader = "음성 초읽기"
L.countdownTextHeader = "문자 초읽기"
L.resetCountdownDesc = "위의 모든 초읽기 관련 설정들을 기본값으로 초기화합니다."
L.resetAllCountdownDesc = "위의 초읽기 관련 설정들은 물론 우두머리 별 설정에서 따로 사용자 지정된 초읽기 음성들 역시 기본값으로 초기화합니다."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "정보 상자"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "이 애드온의 출력을 BigWigs 메시지 디스플레이에 출력합니다. 이 디스플레이는 아이콘과 색상, 그리고 동시에 4개의 메시지 출력을 지원합니다. 새롭게 삽입된 메시지는 사용자에게 알리기 위해 크기가 커졌다가 다시 빠르게 줄어듭니다."
L.emphasizedSinkDescription = "이 애드온의 출력을 BigWigs 강조 메시지 디스플레이에 출력합니다. 이 디스플레이는 문자와 색상, 그리고 동시에 하나의 메시지 출력을 지원합니다."
L.resetMessagesDesc = "위치를 비롯한 메시지에 관련된 모든 설정을 기본값으로 초기화합니다."
L.toggleMessagesAnchorsBtnShow_desc = "모든 이동 앵커를 표시하여 메시지를 이동할 수 있게 합니다."

L.testMessagesBtn = "테스트 메시지 생성"
L.testMessagesBtn_desc = "현재 디스플레이 설정을 테스트할 메시지를 생성합니다."

L.bwEmphasized = "BigWigs 강조"
L.messages = "메시지"
L.emphasizedMessages = "강조 메시지"
L.emphasizedDesc = "강조 메시지는 화면의 중앙에 보다 큰 크기의 메시지를 띄움으로써 당신의 주의를 끌게 됩니다. 기본값으로 강조 메시지 기능이 켜져 있는 경우는 드물지만 우두머리 별 설정에서 아무 우두머리 별 능력에 대한 강조 메시지를 켤 수 있습니다."
L.uppercase = "대문자"
L.uppercaseDesc = "모든 강조 메시지들이 대문자로 표시됩니다."

L.useIcons = "아이콘 사용"
L.useIconsDesc = "메시지 옆에 아이콘을 표시합니다."
L.classColors = "직업 색상"
L.classColorsDesc = "메세지에 플레이어 이름이 포함될때가 있습니다. 이 옵션을 활성화하면 그 플레이어들의 이름을 직업 색상으로 표시합니다."
L.chatFrameMessages = "대화 창 메시지"
L.chatFrameMessagesDesc = "모든 BigWigs 메시지를 표시 설정과 더불어 기본 대화 창에도 출력합니다."

L.fontSize = "글꼴 크기"
L.none = "안함"
L.thin = "얇은"
L.thick = "두꺼운"
L.outline = "외곽선"
L.monochrome = "단색"
L.monochromeDesc = "단색 상태 사용을 전환하여, 글꼴 경계의 모든 다듬기를 제거합니다."
L.fontColor = "글꼴 색상"

L.displayTime = "표시 시간"
L.displayTimeDesc = "메시지를 표시할 시간, 초 단위"
L.fadeTime = "서서히 사라질 시간"
L.fadeTimeDesc = "메시지를 서서히 없앨 시간, 초 단위"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "이름표"
L.testNameplateIconBtn = "테스트 아이콘 표시"
L.testNameplateIconBtn_desc = "현재 표시 설정을 테스트할 수 있도록 대상 이름표에 테스트 아이콘을 생성합니다."
L.testNameplateTextBtn = "텍스트 테스트 표시"
L.testNameplateTextBtn_desc = "현재 텍스트 설정을 테스트할 수 있도록 대상 이름표에 테스트 텍스트를 생성합니다."
L.stopTestNameplateBtn = "테스트 중지"
L.stopTestNameplateBtn_desc = "이름표의 아이콘 및 텍스트 테스트를 중지합니다."
L.noNameplateTestTarget = "이름표 기능을 테스트하려면 공격 가능한 적대적인 대상을 선택해야 합니다."
L.anchoring = "설정"
L.growStartPosition = "성장 시작 위치"
L.growStartPositionDesc = "첫 번째 아이콘의 시작 위치를 설정합니다."
L.growDirection = "성장 방향"
L.growDirectionDesc = "시작 위치에서 아이콘이 성장하는 방향을 설정합니다."
L.iconSpacingDesc = "각 아이콘 사이의 간격을 변경합니다."
L.nameplateIconSettings = "아이콘 설정"
L.keepAspectRatio = "비율 유지"
L.keepAspectRatioDesc = "아이콘의 비율을 1:1로 유지하여 프레임 크기에 맞게 늘어나지 않도록 합니다."
L.iconColor = "아이콘 색상"
L.iconColorDesc = "아이콘 텍스처의 색상을 변경합니다."
L.desaturate = "채도 감소"
L.desaturateDesc = "아이콘 텍스처의 채도를 감소시킵니다."
L.zoom = "줌"
L.zoomDesc = "아이콘 텍스처를 확대합니다."
L.showBorder = "테두리 표시"
L.showBorderDesc = "아이콘 주위에 테두리를 표시합니다."
L.borderColor = "테두리 색상"
L.borderSize = "테두리 크기"
L.showNumbers = "숫자 표시"
L.showNumbersDesc = "아이콘에 숫자 표시."
L.cooldown = "쿨다운"
L.showCooldownSwipe = "회전 애니메이션 표시"
L.showCooldownSwipeDesc = "쿨다운이 활성화된 경우 아이콘에 회전 애니메이션을 표시합니다."
L.showCooldownEdge = "가장자리 표시"
L.showCooldownEdgeDesc = "쿨다운이 활성화된 경우 가장자리를 표시합니다."
L.inverse = "반전"
L.inverseSwipeDesc = "쿨다운 애니메이션을 반전시킵니다."
L.glow = "반짝임"
L.enableExpireGlow = "만료 반짝임 활성화"
L.enableExpireGlowDesc = "쿨다운이 만료된 경우 아이콘 주위에 반짝임를 표시합니다."
L.glowColor = "반짝임 색상"
L.glowType = "반짝임 유형"
L.glowTypeDesc = "아이콘 주위에 표시되는 반짝임 유형을 변경합니다."
L.resetNameplateIconsDesc = "이름표 아이콘과 관련된 모든 옵션을 초기화합니다."
L.nameplateTextSettings = "텍스트 설정"
L.fixate_test = "고정 테스트" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "이름표 텍스트와 관련된 모든 옵션을 초기화합니다."
L.autoScale = "자동 크기 조정"
L.autoScaleDesc = "이름표 크기에 따라 자동으로 크기을 변경합니다."
L.glowAt = "반짝임 시작 (초)"
L.glowAt_desc = "반짝임이 시작될 때 재사용 대기시간이 몇 초 남았는지 선택합니다."

-- Glow types as part of LibCustomGlow
L.pixelGlow = "픽셀 반짝임"
L.autocastGlow = "자동시전 반짝임"
L.buttonGlow = "버튼 반짝임"
L.procGlow = "발동 반짝임"
L.speed = "속도"
L.animation_speed_desc = "반짝임 애니메이션이 재생되는 속도."
L.lines = "선"
L.lines_glow_desc = "반짝임 애니메이션에서 선의 개수."
L.intensity = "강도"
L.intensity_glow_desc = "반짝임 효과의 강도. 높을수록 더 많은 반짝임이 나타납니다."
L.length = "길이"
L.length_glow_desc = "반짝임 애니메이션에서 선의 길이."
L.thickness = "굵기"
L.thickness_glow_desc = "반짝임 애니메이션에서 선의 굵기."
L.scale = "크기"
L.scale_glow_desc = "애니메이션에서 반짝임의 크기."
L.startAnimation = "애니메이션 시작"
L.startAnimation_glow_desc = "이 반짝임은 시작 애니메이션을 가지고 있으며, 애니메이션의 활성화/비활성화를 설정합니다."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "사용자 설정 거리 지시기"
L.proximityTitle = "%d미터 / %d 플레이어" -- yd = yards (short)
L.proximity_name = "근접"
L.soundDelay = "소리 지연"
L.soundDelayDesc = "누군가 당신과 가까이 있을 때 BigWigs에 지정된 소리의 반복 재생 간격을 지정합니다."

L.resetProximityDesc = "위치를 비롯한 근접에 관련된 모든 설정을 기본값으로 초기화합니다."

L.close = "닫기"
L.closeProximityDesc = "근접 디스플레이를 닫습니다.\n\n모든 우두머리 전투에서 완전히 비활성화하려면, 관련 우두머리 모듈의 옵션에서 '근접' 옵션을 꺼야합니다."
L.lock = "잠그기"
L.lockDesc = "이동과 크기 변경을 방지하도록 디스플레이를 위치에 잠급니다."
L.title = "제목"
L.titleDesc = "제목을 표시하거나 숨깁니다."
L.background = "배경"
L.backgroundDesc = "배경을 표시하거나 숨깁니다."
L.toggleSound = "소리 사용 전환"
L.toggleSoundDesc = "다른 플레이어와 너무 가깝게 있을 때 근접 창의 알림음 사용 여부를 전환합니다."
L.soundButton = "소리 버튼"
L.soundButtonDesc = "소리 버튼을 표시하거나 숨깁니다."
L.closeButton = "닫기 버튼"
L.closeButtonDesc = "닫기 버튼을 표시하거나 숨깁니다."
L.showHide = "표시/숨기기"
L.abilityName = "능력 이름"
L.abilityNameDesc = "창 상단의 능력 이름을 표시하거나 숨깁니다."
L.tooltip = "툴팁"
L.tooltipDesc = "근접 디스플레이가 우두머리 전투 능력과 직접 연관되어 있을 때 주문 툴팁을 표시하거나 숨깁니다."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "초읽기 유형"
L.combatLog = "자동 전투 기록"
L.combatLogDesc = "전투 예정 타이머 시작부터 우두머리 전투 종료로 타이머가 끝날 때까지의 전투 기록을 자동으로 켭니다."

L.pull = "전투 예정"
L.engageSoundTitle = "우두머리 전투가 시작될때 소리 재생"
L.pullStartedSoundTitle = "전투 예정 타이머가 시작되었을때 소리 재생"
L.pullFinishedSoundTitle = "전투 예정 타이머가 끝났을때 소리 재생"
L.pullStartedBy = "%s에 의해 풀 타이머가 시작되었습니다."
L.pullStopped = "%s|1이;가; 전투 예정 타이머를 취소했습니다."
L.pullStoppedCombat = "전투가 이미 시작되었기 때문에 전투 예정 타이머가 취소되었습니다."
L.pullIn = "%d초 후 전투 시작"
L.sendPull = "그룹에 풀 타이머를 전송합니다."
L.wrongPullFormat = "잘못된 풀 타이머 형식입니다. 올바른 예: /pull 5"
L.countdownBegins = "초읽기 시작"
L.countdownBegins_desc = "전투 시작 초읽기가 몇 초 전부터 시작될 지 선택하세요."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "아이콘"
L.raidIconsDescription = "몇몇 우두머리 전투는 특정 플레이어를 지정하는 폭탄-유형 능력이나 추적당하는 플레이어, 또는 다른 방법으로 관심이 가는 특정 플레이어 같은 요소를 포함합니다. 여기서 이 플레이어들을 표시하는데 사용할 공격대 아이콘을 사용자 설정할 수 있습니다.\n\n우두머리 전투가 표시할만한 능력을 하나만 가지고 있으면 첫번째 아이콘만 사용합니다. 하나의 아이콘은 같은 우두머리 전투에서 다른 2개의 능력에 사용되지 않으며, 다음에도 주어진 능력에 항상 같은 아이콘을 사용합니다.\n\n|cffff4411참고: 플레이어에게 수동으로 표시가 되어있으면 BigWigs는 아이콘을 변경하지 않습니다.|r"
L.primary = "첫번째"
L.primaryDesc = "우두머리 전투 스크립트가 사용할 첫번째 공격대 대상 아이콘입니다."
L.secondary = "두번째"
L.secondaryDesc = "우두머리 전투 스크립트가 사용할 두번째 공격대 대상 아이콘입니다."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "소리"
L.soundsDesc = "빅윅은 '주 음량' 소리 채널로 모든 소리를 재생합니다. 소리가 너무 작거나 너무 크다면, 와우의 음향 설정에 들어가서 '주 음량' 을 알맞게 조정하십시오.\n\n아래에선 특별한 상황에서 나오는 다양한 소리들을 설정하거나, '없음'으로 설정해서 비활성화 할 수 있습니다. 특성 보스의 능력의 소리만 바꾸고 싶다면, 보스 전투 설정에서 바꾸십시오.\n\n"
L.oldSounds = "예전 소리들"

L.Alarm = "알람"
L.Info = "정보"
L.Alert = "경보"
L.Long = "길게"
L.Warning = "경고"
L.onyou = "나에게 적용되는 주문, 강화 효과, 약화 효과"
L.underyou = "내 밑의 \"바닥\"을 피해야 할 때"
L.privateaura = "'비공개 오라'가 당신에게 있을 때"

L.sound = "소리"

L.customSoundDesc = "모듈이 제공한 소리 대신에 선택된 사용자 설정 소리를 재생합니다."
L.resetSoundDesc = "소리에 관련된 모든 설정을 기본값으로 초기화합니다."
L.resetAllCustomSound = "어떤 우두머리 전투 설정에 사용자 설정된 소리가 있다면 이 버튼으로 모두 초기화하고 여기에 정의된 소리를 대신 사용합니다."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "우두머리 통계"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times you were victorious, the amount of times you were defeated, date of first victory, and the fastest victory. 이 통계들은 각 우두머리의 설정 화면에서 볼수 있지만, 기록된 통계가 없는 우두머리는 숨겨집니다."
L.createTimeBar = "'최고 기록' 바 표시"
L.bestTimeBar = "최고 기록"
L.healthPrint = "생명력: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "대화 메시지"
L.newFastestVictoryOption = "새로운 최고 승리 시간"
L.victoryOption = "당신이 승리했습니다"
L.defeatOption = "당신이 패배했습니다"
L.bossHealthOption = "우두머리 생명력"
L.bossVictoryPrint = "'%s'에게 %s 후 승리했습니다." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "'%s'에게 %s 후 패배했습니다." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "새로운 최고 승리 시간: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "승리"
L.victoryHeader = "우두머리 전투를 처치한 후 취할 행동을 설정합니다."
L.victorySound = "승리 소리 재생하기"
L.victoryMessages = "우두머리 처치 메시지 표시"
L.victoryMessageBigWigs = "BigWigs 메시지 표시"
L.victoryMessageBigWigsDesc = "BigWigs 메시지는 단순한 \"우두머리를 처치했습니다\" 메시지입니다."
L.victoryMessageBlizzard = "블리자드 메시지 표시"
L.victoryMessageBlizzardDesc = "Blizzard 메시지는 화면 중앙의 아주 큰 \"우두머리 처치\" 애니메이션입니다."
L.defeated = "%s|1을;를; 처치했습니다"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "전멸"
L.wipeSoundTitle = "전멸했을 때 소리 재생"
L.respawn = "재생성"
L.showRespawnBar = "재생성 바 표시"
L.showRespawnBarDesc = "우두머리에서 전멸 후에 우두머리 재생성까지 남은 시간을 보여주는 바를 표시합니다."
