local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "koKR")
if not L then return end

L.general = "일반"
L.comma = ", "

L.positionX = "X 위치"
L.positionY = "Y 위치"
L.positionExact = "정확한 위치"
L.positionDesc = "고정기로부터 정확한 위치를 원한다면 상자에 입력하거나 슬라이더를 움직이세요."
L.width = "너비"
L.height = "높이"
L.sizeDesc = "보통 고정기를 끌어서 크기를 조정합니다. 정확한 크기를 지정하고 싶다면 슬라이더를 사용하거나 직접 수치를 입력 상자안에 써넣으세요(최대값 제한 없음)."
--L.fontSizeDesc = "Adjust the font size using the slider or type the value into the box which has a much higher maximum of 200."

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "보조 자원"
--L.altPowerDesc = "The AltPower display will only appear for bosses that apply AltPower to players, which is extremely rare. The display measures the amount of 'Alternative Power' you and your group has, displaying it in a list. To move the display around, please use the test button below."
L.toggleDisplayPrint = "디스플레이가 다음에 표시됩니다. 이 우두머리 전투에서 완전히 비활성하려면 우두머리 전투 옵션에서 끄도록 전환해야 합니다."
L.disabled = "비활성"
L.disabledDisplayDesc = "디스플레이를 사용하는 모든 모듈에서 디스플레이를 비활성화합니다."
L.resetAltPowerDesc = "위치를 비롯한 모든 보조 자원 관련 설정을 초기화합니다."
--L.test = "Test"
--L.altPowerTestDesc = "Show the 'Alternative Power' display, allowing you to move it, and simulating the power changes you would see on a boss encounter."
--L.yourPowerBar = "Your Power Bar"
--L.barColor = "Bar color"
--L.barTextColor = "Bar text color"
--L.additionalWidth = "Additional Width"
--L.additionalHeight = "Additional Height"
--L.additionalSizeDesc = "Add to the size of the standard display by adjusting this slider, or type the value into the box which has a much higher maximum of 100."
--L.yourPowerTest = "Your Power: %d" -- Your Power: 42
--L.yourAltPower = "Your %s: %d" -- e.g. Your Corruption: 42
--L.player = "Player %d" -- Player 7
--L.disableAltPowerDesc = "Globally disable the AltPower display, it will never show for any boss encounter."

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

L.nameplateBars = "이름표 바"
L.nameplateAutoWidth = "이름표 너비와 맞추기"
L.nameplateAutoWidthDesc = "이름표 바의 너비를 해당 이름표의 너비와 맞춥니다."
L.nameplateOffsetY = "세로 위치 조정"
L.nameplateOffsetYDesc = "위로 확장을 사용할 경우 이름표의 상단으로부터, 그렇지 않은 경우 이름표의 하단으로부터의 거리입니다."

L.clickableBars = "클릭 가능한 바"
L.clickableBarsDesc = "BigWigs 바는 기본적으로 클릭을 무시합니다. 이 방법으로 커서가 바 위에 있을 때도 바 뒤의 물건을 대상 지정할 수 있고 바 뒤에 있는 대상에게 광역 주문을 사용할 수 있으며, 카메라 각도를 변경하는 등의 동작을 가능하게 합니다. |cffff4411클릭 가능한 바를 활성화하면 이런 동작들이 더이상 작동하지 않습니다.|r 당신이 바를 마우스 클릭하면 바가 클릭을 차단합니다.\n"
L.interceptMouseDesc = "바가 마우스 클릭을 수신하도록 활성화합니다."
L.modifier = "조합 키"
L.modifierDesc = "타이머 바위에 클릭 동작을 활성화하려면 선택한 조합 키를 누르고 있으세요."
L.modifierKey = "조합 키와 같이 사용할때만"
L.modifierKeyDesc = "지정된 조합 키가 눌려있지 않다면 바가 클릭을 무시하도록 허용합니다, 아래 설명된 마우스 동작이 사용 가능해집니다."

L.temporaryCountdownDesc = "일시적으로 해당 바에 대한 초읽기를 활성화합니다."
L.report = "보고"
L.reportDesc = "현재 바 상태를 활성화된 그룹 대화에 보고합니다; 인스턴스 대화, 공격대, 파티 또는 일반 대화 중 적절한 채널을 사용합니다."
L.remove = "제거"
L.removeBarDesc = "일시적으로 해당 바를 제거합니다."
L.removeOther = "다른 바 제거"
L.removeOtherBarDesc = "일시적으로 해당 바를 제외한 다른 모든 바를 제거합니다."

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
L.bossBlockDesc = "우두머리 전투 중 차단할 수 있는 다양한 기능들을 설정합니다."
L.movieBlocked = "이 동영상을 본적이 있으므로 건너뜁니다."
L.blockEmotes = "화면 중앙의 감정표현 차단"
L.blockEmotesDesc = "몇몇 우두머리는 특정 능력에 감정표현을 표시합니다, 이 메시지는 너무 길고 설명적입니다. 우리는 게임 플레이를 방해하지 않으면서 당신이 특별한 행동을 하지 않아도 되는, 작고 더 알맞은 메시지를 만들려고 노력합니다.\n\n참고하세요: 우두머리 감정표현를 읽고 싶다면 여전히 대화에서 확인할 수 있습니다."
L.blockMovies = "반복되는 동영상 차단"
L.blockMoviesDesc = "우두머리 전투 동영상이 한번만 재생되도록 허용합니다 (각 한번씩 볼수 있도록) 그 후엔 차단됩니다."
L.blockFollowerMission = "모험 알림 차단" -- Rename to follower mission
L.blockFollowerMissionDesc = "모험 알림은 여러가지를 표시하지만 주로 모험이 완료되었을 때 표시합니다.\n\n이 알림들은 우두머리 전투 중 UI를 치명적으로 가릴 수 있습니다, 따라서 차단을 권장합니다."
L.blockGuildChallenge = "길드 도전 알림 차단"
L.blockGuildChallengeDesc = "길드 도전 알림은 여러가지를 표시하지만 주로 당신의 길드 파티의 영웅 던전이나 도전 모드 던전 완료를 표시합니다.\n\n이 알림들은 우두머리 전투 중 UI를 치명적으로 가릴 수 있습니다, 따라서 차단을 권장합니다."
L.blockSpellErrors = "주문 실패 메시지 차단"
L.blockSpellErrorsDesc = "일반적으로 화면 상단에 표시되는 \"마법이 아직 준비되지 않았습니다\" 같은 메시지를 차단합니다."
L.audio = "음성"
L.music = "배경음악"
L.ambience = "환경 소리"
L.sfx = "효과음"
L.disableMusic = "배경음악 끄기 (권장)"
L.disableAmbience = "환경 소리 끄기 (권장)"
L.disableSfx = "효과음 끄기 (권장하지 않음)"
L.disableAudioDesc = "WoW의 소리 설정에서 '%s' 설정이 꺼지고 교전이 끝난 후에 다시 켜집니다. BigWigs의 알림 소리에 더 집중하는데 도움이 됩니다."
L.blockTooltipQuests = "툴팁에서 퀘스트 목표 표시를 숨깁니다."
L.blockTooltipQuestsDesc = "우두머리를 처치하는 퀘스트를 진행 중인 경우 해당 우두머리에 마우스를 올렸을 때 보통 '0/1 완료' 같은 문구가 툴팁에 표시됩니다. 전투 중에 이 문구들을 숨김으로써 툴팁의 크기가 너무 크게 확장되는 것을 방지합니다."
L.blockObjectiveTracker = "퀘스트 추적기 숨김"
L.blockObjectiveTrackerDesc = "보스 전투 중에 퀘스트 추적기를 숨겨서 화면의 여유 공간을 넓힙니다.\n\n신화 쐐기돌이나 업적을 추적 중일 때는 숨기지 않습니다."

L.subzone_grand_bazaar = "대시장" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "잔달라 항구" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "동쪽 회랑" -- Auchindoun dungeon (Warlords of Draenor)

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

L.bwEmphasized = "BigWigs 강조"
L.messages = "메시지"
L.emphasizedMessages = "강조 메시지"
L.emphasizedDesc = "강조 메시지는 화면의 중앙에 보다 큰 크기의 메시지를 띄움으로써 당신의 주의를 끌게 됩니다. 기본값으로 강조 메시지 기능이 켜져 있는 경우는 드물지만 우두머리 별 설정에서 아무 우두머리 별 능력에 대한 강조 메시지를 켤 수 있습니다."
L.uppercase = "대문자"
L.uppercaseDesc = "모든 강조 메시지들이 대문자로 표시됩니다."

L.useIcons = "아이콘 사용"
L.useIconsDesc = "메시지 옆에 아이콘을 표시합니다."
L.classColors = "직업 색상"
L.classColorsDesc = "플레이어의 이름에 직업 색상을 입힙니다."
L.chatMessages = "대화 창 메시지"
L.chatMessagesDesc = "모든 BigWigs 메시지를 표시 설정과 더불어 기본 대화 창에도 출력합니다."

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
L.pullStarted = "%s 사용자 %s|1이;가; 전투 예정 타이머를 시작했습니다."
L.pullStopped = "%s|1이;가; 전투 예정 타이머를 취소했습니다."
L.pullStoppedCombat = "전투가 이미 시작되었기 때문에 전투 예정 타이머가 취소되었습니다."
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
-- Sound.lua
--

L.Sounds = "소리"
L.oldSounds = "예전 소리들"

L.Alarm = "알람"
L.Info = "정보"
L.Alert = "경보"
L.Long = "길게"
L.Warning = "경고"
L.onyou = "나에게 적용되는 주문, 강화 효과, 약화 효과"
L.underyou = "내 밑의 \"바닥\"을 피해야 할 때"

L.sound = "소리"
L.soundDesc = "메시지는 소리와 함게 나타날 수 있습니다. 몇몇 사람들은 메시지와 함께 어떤 소리가 재생되는지 배운 후에는 실제 메시지를 읽는 것보다 소리를 듣는 것으로 더 쉽게 찾을 수 있습니다."

L.customSoundDesc = "모듈이 제공한 소리 대신에 선택된 사용자 설정 소리를 재생합니다."
L.resetSoundDesc = "소리에 관련된 모든 설정을 기본값으로 초기화합니다."
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

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "전멸"
L.wipeSoundTitle = "전멸했을 때 소리 재생"
L.respawn = "재생성"
L.showRespawnBar = "재생성 바 표시"
L.showRespawnBarDesc = "우두머리에서 전멸 후에 우두머리 재생성까지 남은 시간을 보여주는 바를 표시합니다."
