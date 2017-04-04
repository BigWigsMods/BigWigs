local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "koKR")
if not L then return end

L.general = "일반"

L.positionX = "X 위치"
L.positionY = "Y 위치"
L.positionExact = "정확한 위치"
L.positionDesc = "고정기로부터 정확한 위치를 원한다면 상자에 입력하거나 슬라이더를 움직이세요."

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "보조 자원"
L.toggleDisplayPrint = "디스플레이가 다음에 표시됩니다. 이 우두머리 전투에서 완전히 비활성하려면 우두머리 전투 옵션에서 끄도록 전환해야 합니다."
L.disabled = "비활성"
L.disabledDisplayDesc = "디스플레이를 사용하는 모든 모듈에서 디스플레이를 비활성화합니다."

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "바"
L.style = "모양"
L.bigWigsBarStyleName_Default = "기본"

L.clickableBars = "클릭 가능한 바"
L.clickableBarsDesc = "BigWigs 바는 기본적으로 클릭을 무시합니다. 이 방법으로 커서가 바 위에 있을 때도 바 뒤의 물건을 대상 지정할 수 있고 바 뒤에 있는 대상에게 광역 주문을 사용할 수 있으며, 카메라 각도를 변경하는 등의 동작을 가능하게 합니다. |cffff4411클릭 가능한 바를 활성화하면 이런 동작들이 더이상 작동하지 않습니다.|r 당신이 바를 마우스 클릭하면 바가 클릭을 차단합니다.\n"
L.interceptMouseDesc = "바가 마우스 클릭을 수신하도록 활성화합니다."
L.modifier = "조합 키"
L.modifierDesc = "타이머 바위에 클릭 동작을 활성화하려면 선택한 조합 키를 누르고 있으세요."
L.modifierKey = "조합 키와 같이 사용할때만"
L.modifierKeyDesc = "지정된 조합 키가 눌려있지 않다면 바가 클릭을 무시하도록 허용합니다, 아래 설명된 마우스 동작이 사용 가능해집니다."

L.tempEmphasize = "지속 시간과 관련된 바와 메시지를 일시적으로 강조합니다."
L.report = "보고"
L.reportDesc = "현재 바 상태를 활성화된 그룹 대화에 보고합니다; 인스턴스 대화, 공격대, 파티 또는 일반 대화 중 적절한 채널을 사용합니다."
L.remove = "제거"
L.removeDesc = "일시적으로 바와 모든 관련 메시지를 제거합니다."
L.removeOther = "다른 바 제거"
L.removeOtherDesc = "일시적으로 모든 다른 바와 (이 바를 제외하고) 관련 메시지를 제거합니다."
L.disable = "비활성화"
L.disableDesc = "이 바를 생성하는 우두머리 전투 능력 옵션을 영구적으로 비활성합니다."

L.emphasizeAt = "다음에 강조... (초)"
L.scale = "크기 비율"
L.growingUpwards = "위로 확장"
L.growingUpwardsDesc = "고정기로부터 위 또는 아래로 확장하도록 전환합니다."
L.texture = "텍스쳐"
L.emphasize = "강조"
L.enable = "활성화"
L.move = "이동"
L.moveDesc = "강조된 바를 강조 고정기로 이동시킵니다. 이 옵션을 끄면 강조된 바는 단순히 크기 비율과 색상을 변경합니다."
L.regularBars = "보통 바"
L.emphasizedBars = "강조된 바"
L.align = "정렬"
L.alignText = "문자 정렬"
L.alignTime = "시간 정렬"
L.left = "왼쪽"
L.center = "중앙"
L.right = "오른쪽"
L.time = "시간"
L.timeDesc = "바에 남은 시간을 표시하거나 숨깁니다."
L.icon = "아이콘"
L.iconDesc = "바 아이콘을 표시하거나 숨깁니다."
L.font = "글꼴"
L.restart = "다시 시작"
L.restartDesc = "강조된 바를 10부터 다시 셉니다."
L.fill = "채우기"
L.fillDesc = "바를 비우는 대신 채워나갑니다."

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
L.bossBlockDesc = "우두머리 전투 중 차단할 수 있는 다양한 기능들을 설정합니다."
L.movieBlocked = "이 동영상을 본적이 있으므로 건너뜁니다."
L.blockEmotes = "화면 중앙의 감정표현 차단"
L.blockEmotesDesc = "몇몇 우두머리는 특정 능력에 감정표현을 표시합니다, 이 메시지는 너무 길고 설명적입니다. 우리는 게임 플레이를 방해하지 않으면서 당신이 특별한 행동을 하지 않아도 되는, 작고 더 알맞은 메시지를 만들려고 노력합니다.\n\n참고하세요: 우두머리 감정표현를 읽고 싶다면 여전히 대화에서 확인할 수 있습니다."
L.blockMovies = "반복되는 동영상 차단"
L.blockMoviesDesc = "우두머리 전투 동영상이 한번만 재생되도록 허용합니다 (각 한번씩 볼수 있도록) 그 후엔 차단됩니다."
L.blockGarrison = "주둔지 알림 차단"
L.blockGarrisonDesc = "주둔지 알림은 여러가지를 표시하지만 주로 추종자 임무 완료를 표시합니다.\n\n이 알림들은 우두머리 전투 중 UI를 치명적으로 가릴 수 있습니다, 따라서 차단을 권장합니다."
L.blockGuildChallenge = "길드 도전 알림 차단"
L.blockGuildChallengeDesc = "길드 도전 알림은 여러가지를 표시하지만 주로 당신의 길드 파티의 영웅 던전이나 도전 모드 던전 완료를 표시합니다.\n\n이 알림들은 우두머리 전투 중 UI를 치명적으로 가릴 수 있습니다, 따라서 차단을 권장합니다."
L.blockSpellErrors = "주문 실패 메시지 차단"
L.blockSpellErrorsDesc = "일반적으로 화면 상단에 표시되는 \"마법이 아직 준비되지 않았습니다\" 같은 메시지를 차단합니다."

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "색상"

L.text = "문자"
L.textShadow = "문자 그림자"
L.flash = "깜빡임"
L.normal = "일반"
L.emphasized = "강조"

L.reset = "초기화"
L.resetDesc = "위의 색상을 기본 색상으로 초기화합니다."
L.resetAll = "모두 초기화"
L.resetAllDesc = "우두머리 전투 설정에 사용자 설정 색상을 적용했다면, 이 버튼은 여기에 정의된 색상이 대신 사용되도록 모두 초기화합니다."

L.Important = "중요"
L.Personal = "개인"
L.Urgent = "긴급"
L.Attention = "주의"
L.Positive = "적극"
L.Neutral = "중립"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L.superEmphasize = "특수 강조"
L.superEmphasizeDesc = "특정 우두머리 전투 능력의 관련 메시지나 바를 증폭시킵니다.\n\n우두머리 전투 능력의 고급 옵션에서 강조 옵션을 사용할 때 여기에 수행해야 될 작업을 정확히 구성하세요.\n\n|cffff4411기본값으로 모든 능력에 강조는 꺼져있다는 걸 참고하세요.|r\n"
L.uppercase = "대문자"
L.uppercaseDesc = "강조 옵션에 관련된 모든 메시지를 대문자로 표시합니다."
L.superEmphasizeDisableDesc = "모든 모듈이 사용하는 강조를 비활성화합니다."
L.textCountdown = "문자 초읽기"
L.textCountdownDesc = "초읽기 중에 시각적 카운터를 표시합니다."
L.countdownColor = "초읽기 색상"
L.countdownVoice = "초읽기 음성"
L.countdownTest = "초읽기 테스트"
L.countdownAt = "초읽기 시작... (초)"

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "정보 상자"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "이 애드온의 출력을 BigWigs 메시지 디스플레이에 출력합니다. 이 디스플레이는 아이콘과 색상, 그리고 동시에 4개의 메시지 출력을 지원합니다. 새롭게 삽입된 메시지는 사용자에게 알리기 위해 크기가 커졌다가 다시 빠르게 줄어듭니다."
L.emphasizedSinkDescription = "이 애드온의 출력을 BigWigs 강조 메시지 디스플레이에 출력합니다. 이 디스플레이는 문자와 색상, 그리고 동시에 하나의 메시지 출력을 지원합니다."
L.emphasizedCountdownSinkDescription = "이 애드온의 출력을 BigWigs 강조 초읽기 메시지 디스플레이에 출력합니다. 이 디스플레이는 문자와 색상, 그리고 동시에 하나의 메시지 출력을 지원합니다."

L.bwEmphasized = "BigWigs 강조"
L.messages = "메시지"
L.normalMessages = "일반 메시지"
L.emphasizedMessages = "강조 메시지"
L.output = "출력"
L.emphasizedCountdown = "강조 초읽기"

L.useColors = "색상 사용"
L.useColorsDesc = "색상을 무시하도록 메시지에 색상 사용을 전환합니다."
L.useIcons = "아이콘 사용"
L.useIconsDesc = "메시지 옆에 아이콘을 표시합니다."
L.classColors = "직업 색상"
L.classColorsDesc = "플레이어의 이름에 직업 색상을 입힙니다."

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
-- Proximity.lua
--

L.customRange = "사용자 설정 거리 지시기"
L.proximityTitle = "%d미터 / %d 플레이어" -- yd = yards (short)
L.proximity_name = "근접"
L.soundDelay = "소리 지연"
L.soundDelayDesc = "누군가 당신과 가까이 있을 때 BigWigs에 지정된 소리의 반복 재생 간격을 지정합니다."

L.proximity = "근접 디스플레이"
L.proximity_desc = "이 우두머리 전투에 적절할 때 근접 창을 표시합니다, 자신과 너무 가깝게 서있는 플레이어를 보여줍니다."

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
L.pulling = "전투 시작!"
L.pullStarted = "%s 사용자 %s|1이;가; 전투 예정 타이머를 시작했습니다."
L.pullStopped = "%s|1이;가; 전투 예정 타이머를 취소했습니다."
L.pullIn = "%d초 후 전투 시작"
L.sendPull = "BigWigs와 DBM 사용자에게 전투 예정 타이머를 보냅니다."
L.wrongPullFormat = "1초에서 60초 사이여야 합니다. 올바른 예제: /pull 5"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "아이콘"
L.raidIconsDesc = "몇몇 우두머리 전투 스크립트는 당신의 파티에서 특별히 관심이 가는 플레이어에게 공격대 아이콘을 표시합니다. 예를 들어 '폭탄'-유형 효과와 정신 지배. 이 옵션을 끄면 누구도 표시할 수 없습니다.\n\n|cffff4411공격대장이나 부공격대장 권한이 있어야 적용됩니다!|r"
L.raidIconsDescription = "몇몇 우두머리 전투는 특정 플레이어를 지정하는 폭탄-유형 능력이나 추적당하는 플레이어, 또는 다른 방법으로 관심이 가는 특정 플레이어 같은 요소를 포함합니다. 여기서 이 플레이어들을 표시하는데 사용할 공격대 아이콘을 사용자 설정할 수 있습니다.\n\n우두머리 전투가 표시할만한 능력을 하나만 가지고 있으면 첫번째 아이콘만 사용합니다. 하나의 아이콘은 같은 우두머리 전투에서 다른 2개의 능력에 사용되지 않으며, 다음에도 주어진 능력에 항상 같은 아이콘을 사용합니다.\n\n|cffff4411참고: 플레이어에게 수동으로 표시가 되어있으면 BigWigs는 아이콘을 변경하지 않습니다.|r"
L.primary = "첫번째"
L.primaryDesc = "우두머리 전투 스크립트가 사용할 첫번째 공격대 대상 아이콘입니다."
L.secondary = "두번째"
L.secondaryDesc = "우두머리 전투 스크립트가 사용할 두번째 공격대 대상 아이콘입니다."

-----------------------------------------------------------------------
-- Respawn.lua
--

L.respawn = "재생성"
L.showRespawnBar = "재생성 바 표시"
L.showRespawnBarDesc = "우두머리에서 전멸 후에 우두머리 재생성까지 남은 시간을 보여주는 바를 표시합니다."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "소리"

L.Alarm = "알람"
L.Info = "정보"
L.Alert = "경보"
L.Long = "길게"
L.Warning = "경보"

L.Beware = "조심해라 (알갈론)"
L.FlagTaken = "깃발 뺏김 (PvP)"
L.Destruction = "파괴 (킬제덴)"
L.RunAway = "도망쳐라 꼬마야 달아나라 (커다란 나쁜 늑대)"

L.sound = "소리"
L.soundDesc = "메시지는 소리와 함게 나타날 수 있습니다. 몇몇 사람들은 메시지와 함께 어떤 소리가 재생되는지 배운 후에는 실제 메시지를 읽는 것보다 소리를 듣는 것으로 더 쉽게 찾을 수 있습니다."

L.customSoundDesc = "모듈이 제공한 소리 대신에 선택된 사용자 설정 소리를 재생합니다"
L.resetAllCustomSound = "어떤 우두머리 전투 설정에 사용자 설정된 소리가 있다면 이 버튼으로 모두 초기화하고 여기에 정의된 소리를 대신 사용합니다."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "전투 시작 %2$s만에 '%1$s'|1을;를; 처치했습니다."
L.bossWipeDurationPrint = "전투 시작 %2$s만에 '%1$s'에서 전멸했습니다."
L.newBestTime = "새로운 최고 기록!"
L.bossStatistics = "우두머리 통계"
L.bossStatsDescription = "우두머리를 처치하는 데 걸린 시간, 전멸 횟수, 지속된 총 전투 시간, 또는 가장 빠른 우두머리 처치와 같은 여러가지 우두머리 관련 통계 기록입니다. 이 통계들은 각 우두머리의 설정 화면에서 볼수 있지만, 기록된 통계가 없는 우두머리는 숨겨집니다."
L.enableStats = "통계 활성화"
L.chatMessages = "대화 메시지"
L.printBestTimeOption = "최고 기록 알림"
L.printDefeatOption = "처치 시간"
L.printWipeOption = "전멸 시간"
L.countDefeats = "처치 횟수"
L.countWipes = "전멸 횟수"
L.recordBestTime = "최고 기록 기억하기"
L.createTimeBar = "'최고 기록' 바 표시"
L.bestTimeBar = "최고 기록"
L.printHealthOption = "우두머리 생명력"
L.healthPrint = "생명력: %s."
L.healthFormat = "%s (%.1f%%)"

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
