local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "koKR")
if not L then return end

L.abilityName = "스킬 이름"
L.abilityNameDesc = "스킬의 이름을 창 위에 표시하거나 숨깁니다."
L.Alarm = "알림"
L.Alert = "경보"
L.align = "정렬"
--L.alignText = "Align Text"
--L.alignTime = "Align Time"
L.altPowerTitle = "대체 기력"
L.Attention = "주의"
L.background = "배경"
L.backgroundDesc = "배경을 표시하거나 숨깁니다."
L.bars = "바"
L.bestTimeBar = "최고 기록"
L.Beware = "조심해라 (알갈론)"
L.bigWigsBarStyleName_Default = "기본값"
L.blockEmotes = "화면 중간에 나타나는 감정표현 막기"
L.blockEmotesDesc = [=[특정 보스들은 특정 능력을 사용할 때 감정 표현을 하는데, 이 메시지들은 너무 장황합니다. 우리는 게임플레이에 간섭하지 않으면서 여러분들로 하여금 특별하게 무엇을 하라고 요구하지 않는 더 적고 알맞는 메시지를 송출하여고 합니다.

주의: 보스들의 감정표현을 계속 보고 싶으시다면 채팅창을 통하여 보실 수 있습니다.]=]
L.blockGarrison = "주둔지 관련 팝업 막기"
L.blockGarrisonDesc = [=[주둔지는 몇몇 상황들을 알려주는 팝업창을 띄우는데, 그 중 대부분은 주둔지 임무가 완료되었을 경우입니다.

이 팝업창들은 보스와의 전투 중 여러분들의 UI의 중요한 부분을 가릴 수 있기 때문에, 막으시는 것을 권장합니다.]=]
L.blockGuildChallenge = "길드 도전 관련 팝업 막기"
L.blockGuildChallengeDesc = [=[길드 도전은 몇몇 상황들을 알려주는 팝업창을 띄우는데, 그 중 대부분은 길드원으로 구성된 그룹이 영웅 던전이나 도전모드 던전을 완료했을 경우입니다.

이 팝업창들은 보스와의 전투 중 여러분들의 UI의 중요한 부분을 가릴 수 있기 때문에, 막으시는 것을 권장합니다.]=]
L.blockMovies = "본적이 있는 영상들 막기"
L.blockMoviesDesc = "보스와의 전투 시 나오는 영상들을 한 번만 재생하고(그러므로 여러분들은 한 번씩은 볼 수 있습니다) 그 후에는 막습니다."
L.blockSpellErrors = "주문 오류 팝업 막기"
L.blockSpellErrorsDesc = "\"마법이 아직 준비되지 않았습니다.\" 같이 화면 상단부에 나타나는 메시지들을 막습니다."
L.bossBlock = "보스 블락"
L.bossBlockDesc = "설정을 통하여 보스와의 전투 중 발생하는 다양한 것들을 막을 수 있습니다."
L.bossDefeatDurationPrint = "%s '%s'에 물리침."
L.bossStatistics = "보스 통계"
L.bossStatsDescription = "보스가 죽은 시간의 합계, 전멸 횟수의 합계, 전투가 지속된 총 시간, 또는 가장 빠른 보스 죽임 등의 다양한 보스 관련 통계를 기록합니다. 이 통계는 각각의 보스 설정 화면에서 볼 수 있으나, 기록된 통계가 없는 보스에선 보여지지 않습니다."
L.bossWipeDurationPrint = "%s '%s'에서 전멸함."
L.breakBar = "휴식 시간"
L.breakFinished = "휴식 시간이 끝났습니다!"
L.breakMinutes = "휴식 시간이 %d |4분:분; 후에 종료됩니다!"
L.breakSeconds = "휴식 시간이 %d |4초:초; 후에 종료됩니다!"
L.breakStarted = "휴식 타이머가 %s에 의해 %s에 시작되었습니다."
L.breakStopped = "휴식 타이머가 %s에 의해 취소되었습니다."
L.bwEmphasized = "BigWigs 강조"
L.center = "중앙"
L.chatMessages = "대화 메시지"
L.classColors = "직업 색상"
L.classColorsDesc = "플레이어의 이름을 직업 색상으로 표시."
L.clickableBars = "클릭이 가능한 바"
L.clickableBarsDesc = [=[BigWigs 바에 클릭을 통해 기본적인 기능을 가지게 합니다. |cffff4411만약 당신이 클릭이가 능한 바를 사용할경우에는
 BigWigs를 통해 생성된 바에서는 대상 지정, 카메라 시점등의 불편함도 생길수 있으니 유의하시기 바랍니다.
바의 위에서는 클릭이 가능한 바의 기능이 사용되기 때문입니다.]=]
L.close = "닫기"
L.closeButton = "닫기 버튼"
L.closeButtonDesc = "닫기 버튼을 표시하거나 숨깁니다."
L.closeProximityDesc = [=[근접 표시를 닫습니다.

완전히 비활성화기 위해서는 해당 보스 모듈에 있는 옵션의 근접 표시를 끄세요.]=]
L.colors = "색상"
-- L.combatLog = "Automatic Combat Logging"
-- L.combatLogDesc = "Automatically start logging combat when a pull timer is started and end it when the encounter ends."
L.countDefeats = "죽임 횟수"
L.countdownAt = "X초 남았을 때 카운트다운"
L.countdownColor = "카운트다운 색상"
L.countdownTest = "카운트다운 테스트"
-- L.countdownType = "Countdown Type"
L.countdownVoice = "카운트다운 음성"
L.countWipes = "전멸 횟수"
L.createTimeBar = "'최고 기록' 바 보이기"
L.customBarStarted = "사용자 지정 바 '%s'가 %s를 이용한 %s에 의하여 표시됩니다."
L.customRange = "사용자 거리 지시기"
L.customSoundDesc = "모듈에서 제공하는 효과음 대신 선택된 사용자 정의 소리를 사용합니다."
L.defeated = "%s 물리침"
L.Destruction = "파괴 (킬제덴)"
L.disable = "사용안함"
L.disabled = "미사용"
L.disabledDisplayDesc = "모든 모듈을 사용하는 창을 비활성화 합니다."
L.disableDesc = "해당 바를 교전 모듈에서 체크 해제합니다.(다시 표시하고 싶다면 교전 모듈에서 해당 스킬 경고를 체크하시길 바랍니다.)"
L.displayTime = "표시할 시간"
L.displayTimeDesc = "몇 초동안 메시지를 표시합니다."
L.emphasize = "강조"
L.emphasizeAt = "강조... (초)"
L.emphasized = "강조"
L.emphasizedBars = "강조 바"
L.emphasizedCountdown = "강조된 카운트다운"
L.emphasizedCountdownSinkDescription = "BigWigs의 강조된 카운트다운 메시지 표시를 통해 이 애드온의 메시지를 출력합니다. 이 디스플레이는 텍스트와 색상을 지원하며, 한번에 단 하나의 메시지를 표시할 수 있습니다."
L.emphasizedMessages = "강조된 메시지"
L.emphasizedSinkDescription = "BigWigs의 강조된 메시지 표시를 통해 이 애드온의 메시지를 출력합니다. 이 디스플레이는 텍스트와 색상을 지원하며, 한번에 단 하나의 메시지를 표시할 수 있습니다."
L.enable = "사용"
L.enableStats = "통계 활성화"
L.encounterRestricted = "이 기능은 보스와의 전투 시엔 사용이 불가합니다."
L.fadeTime = "사라짐 시간"
L.fadeTimeDesc = "몇 초 후 메시지가 점점 사라지게 할지 설정합니다."
L.fill = "채우기"
L.fillDesc = "바를 채우기로 표시합니다."
L.FlagTaken = "깃발 빼앗김 (PvP)"
L.flash = "깜박임"
L.font = "글꼴"
L.fontColor = "글꼴 색상"
L.fontSize = "글꼴 크기"
L.general = "일반"
L.growingUpwards = "윗쪽으로 쌓기"
L.growingUpwardsDesc = "기준점으로부터 윗쪽 혹은 아랫쪽으로 쌓을 지 설정합니다."
L.icon = "아이콘"
L.iconDesc = "바 아이콘을 숨기거나 표시합니다."
L.icons = "아이콘"
L.Important = "중요"
L.Info = "정보"
L.interceptMouseDesc = "바에 마우스 클릭으로 나타내기를 활성화합니다."
L.left = "좌측"
L.localTimer = "로컬"
L.lock = "고정"
L.lockDesc = "이동 또는 크기 조절을 방지하기 위해 디스플레이를 고정합니다."
L.Long = "장음"
L.messages = "메시지"
L.modifier = "사용자 설정"
L.modifierDesc = "클릭이 가능한 바를 별도의 사용자가 선택한 키를 조합하여야 작동되게 합니다."
L.modifierKey = "사용자 키를 위한 적용할 키"
L.modifierKeyDesc = "설정한 키를 통해서만 클릭이 가능한 바가 적용되도록 합니다."
L.monochrome = "단색"
L.monochromeDesc = "글꼴 가장자리의 외곽선을 제거하여 단색 모드로 전환합니다."
L.move = "이동"
L.moveDesc = "강조 바를 이동하기 위해 강조 앵커를 표시합니니다. 이 옵션이 비활성화면, 간단히 강조 바의 크기와 색상만 변경할 수 있습니다."
L.movieBlocked = "이 동영상을 본 적이 있으므로 생략합니다."
L.Neutral = "중립"
L.newBestTime = "새로운 최고 기록!"
L.none = "없음"
L.normal = "일반"
L.normalMessages = "일반 메시지"
L.outline = "외곽선"
L.output = "출력"
L.Personal = "개인"
L.positionDesc = "정확한 자리를 정하기 위하여 직접 수치를 입력하거나 슬라이더를 움직이세요."
L.positionExact = "정확한 위치설정"
L.positionX = "X 좌표"
L.positionY = "Y 좌표"
L.Positive = "긍정적"
L.primary = "첫번째 아이콘"
L.primaryDesc = "첫번째 공격대 대상에게 사용할 아이콘을 지정합니다."
L.printBestTimeOption = "최고 기록 알림"
L.printDefeatOption = "죽임 시간"
L.printWipeOption = "전멸 시간"
L.proximity = "근접 표시"
L.proximity_desc = "해당 보스전에서 필요 시 자신과 근접해 있는 플레이어 목록을 표시하는 근접 표시창을 표시합니다."
L.proximity_name = "근접"
L.proximityTitle = "%d미터 / %d 플레이어"
L.pull = "풀링"
L.pullIn = "풀링 %d초 전"
L.pulling = "풀링합니다!"
L.pullStarted = "%2$s님이 %1$s 풀링 타이머를 시작합니다."
L.pullStopped = "풀링 타이머가 %s 에 의해 취소되었습니다."
L.raidIconsDesc = [=['폭탄'류의 스킬이나 정신 지배 같은 능력들의 경고를 하여 공격대원들의 주의를 끌기 위해서, 몇몇 보스 스크립트는 플레이어에게 전술 아이콘을 설정합니다. 이 옵션을 끄면 전술 아이콘을 설정하지 않습니다.

|cffff4411오직 공격대장이나 승급된 사람만이 가능합니다!|r]=]
L.raidIconsDescription = [=[중요한 '폭탄'-유형의 보스 능력을 플레이어에게 사용할 경우 BigWigs에서 공격대 대상 아이콘 지정을 설정합니다. 중요 '폭탄'-유형 기술이 2개일 경우 1개의 기술에 첫번째, 그나머지 기술에 대해서는 두번째 아이콘을 지정하여 사용합니다.

|cffff4411주의: 만약에 플레이어가 이미 수동으로 전술 지정이 되어있다면 BigWigs 에서는 그것을 변경하지 않습니다.|r]=]
L.recordBestTime = "최고 기록 저장하기"
L.regularBars = "일반 바"
L.remove = "삭제"
L.removeDesc = "해당 바에 관련된 모든 바와 메세지를 제거합니다."
L.removeOther = "기타 삭제"
L.removeOtherDesc = "해당 바를 제외한 모든 바와 메세지를 제거합니다."
L.report = "보고"
L.reportDesc = "활성화된 대화창에 현재 바의 상태를 보고합니다. 인스턴스 대화, 공격대, 파티나 일반 창에 알릴 수 있습니다."
L.requiresLeadOrAssist = "이 기능은 공격대장이나 부공격대장만 가능합니다."
L.reset = "초기화"
L.resetAll = "모두 초기화"
L.resetAllCustomSound = [=[어떤 보스 설정에서 소리를 사용자 지정했다면, 이 버튼으로 모두 초기화 됩니다. 따라서 여기에 정의된 소리가 대신 사용됩니다.
]=]
L.resetAllDesc = "어떤 보스 설정에서 색상을 사용자 지정했다면, 이 버튼으로 모두 초기화 됩니다. 따라서 여기에 정의된 색상이 대신 사용됩니다."
L.resetDesc = "위의 색상을 모두 기본으로 초기화 합니다."
L.respawn = "재생성" -- Needs review
L.restart = "재시작"
L.restartDesc = "이전의 시간을 그대로 적용하지않고 새롭게 10초부터 특수강조바를 생성합니다."
L.right = "우측"
L.RunAway = "도망쳐라 꼬마야 달아나라 (커다란 나쁜 늑대)"
L.scale = "크기"
L.secondary = "두번째 아이콘"
L.secondaryDesc = "두번째 공격대 대상에게 사용할 아이콘을 지정합니다."
L.sendBreak = "BigWigs와 DBM 유저들에게 휴식 타이머를 보냅니다."
L.sendCustomBar = "BigWigs과 DBM 사용자에게 '%s' 사용자 바를 보냅니다."
L.sendPull = "BigWigs과 DBM 사용자에게 풀링 타이머를 보냅니다."
L.showHide = "표시/숨김"
L.showRespawnBar = "재생성 바 표시" -- Needs review
L.showRespawnBarDesc = "보스를 리셋한 후에 재생성 되기까지 걸리는 시간을 바에 표시합니다." -- Needs review
L.sinkDescription = "BigWigs 메세지 표시를 통해 이 애드온의 메세지를 출력합니다. 이것은 디스플레이와 색상, 아이콘을 지원하는 메시지가 화면에 한 번에 최대 4개까지 표시됩니다. 새로운 메시지는 사용자에게 알리기 위해 점점 커지다가 순식간에 사라집니다"
L.sound = "효과음"
L.soundButton = "소리 버튼"
L.soundButtonDesc = "소리 버튼을 표시하거나 숨깁니다."
L.soundDelay = "효과음 지연"
L.soundDelayDesc = "누군가가 근접해 있을 때 나오는 반복적인 효과음의 지연 시간을 설정합니다."
L.soundDesc = "메시지와 함께 효과음을 사용합니다. " -- Needs review
L.Sounds = "효과음"
L.style = "모양"
L.superEmphasize = "특수 강조바"
L.superEmphasizeDesc = [=[특정 보스가 사용하는 스킬과 관련한 메시지와 바를 특징있게 나타냅니다.

여기에서 보스가 사용하는 기술에 대하여 특수 강조 옵션을 구성합니다.

|cffff4411특수 강조는 모든 스킬에 대해서 기본적으로 꺼져있습니다.|r]=]
L.superEmphasizeDisableDesc = "모든 모듈에서 특수 강조바를 비활성화합니다."
L.tempEmphasize = "선택한 바에 대하여 지속시간 동안 바와 메세지에 특수 강조 기능을 적용합니다."
L.text = "글자"
L.textCountdown = "카운트다운 텍스트" -- Needs review
L.textCountdownDesc = "카운트다운을 하는 동안 시각적으로 카운트를 보여줍니다." -- Needs review
L.textShadow = "글자 그림자"
L.texture = "텍스쳐"
L.thick = "두껍게"
L.thin = "얇게"
L.time = "시간"
L.timeDesc = "바의 우측에 시간을 숨기거나 표시합니다."
L.timerFinished = "%s: [%s] 타이머가 종료되었습니다."
L.title = "제목"
L.titleDesc = "제목을 표시하거나 숨깁니다."
L.toggleDisplayPrint = "이 화면은 다음에 나타납니다. 이 보스에서 완전히 비활성화 시키려면, 보스 옵션에서 꺼주시기 바랍니다."
L.toggleSound = "소리 전환"
L.toggleSoundDesc = "근접 창에서 다른 플레이어와 가까이 있을 경우에 알리는 경고음을 켜거나 끌 수 있게 합니다."
L.tooltip = "툴팁"
L.tooltipDesc = "현재 보스 스킬에 직접 연결되어 자동으로 뜨는 근접 표시창에 대해 커서를 올릴시 툴팁을 표시하거나 숨깁니다."
L.uppercase = "대문자"
L.uppercaseDesc = "특수 강조의 모든 관련된 메세지를 대문자로 표시합니다."
L.Urgent = "긴급"
L.useColors = "색상 사용"
L.useColorsDesc = "메시지에 색상 사용을 설정합니다."
L.useIcons = "아이콘 사용"
L.useIconsDesc = "메시지 뒤에 아이콘을 표시합니다."
L.Victory = "승리"
L.victoryHeader = "보스를 쓰러뜨린 후 수행할 작업들을 설정합니다." -- Needs review
L.victoryMessageBigWigs = "BigWigs의 메세지를 보여줍니다." -- Needs review
L.victoryMessageBigWigsDesc = "BigWigs 메세지는 단순하게 \"우두머리를 쓰러뜨렸습니다\" 입니다." -- Needs review
L.victoryMessageBlizzard = "블리자드 메세지를 보여줍니다." -- Needs review
L.victoryMessageBlizzardDesc = "블리자드 메세지는 화면 중앙에  \"우두머리를 쓰러뜨렸습니다\"는 애니메이션입니다." -- Needs review
L.victoryMessages = "보스를 쓰러뜨린 메세지를 보여줍니다." -- Needs review
L.victorySound = "승리의 사운드를 재생합니다." -- Needs review
L.Warning = "경고"
L.wrongBreakFormat = "1~60분 사이로 설정하셔야 합니다. 예시: /break 5"
L.wrongCustomBarFormat = "잘못된 형식입니다. /raidbar 20 text와 같이 쓰는게 정확한 예입니다."
L.wrongPullFormat = "1~60초 사이로 설정하셔야 합니다. 예시: /pull 5"
L.wrongTime = "시간의 표현 방식이 적절하지 않습니다. 초 단위로 표현하거나, 분:초 형식, 아니면 분 단위로 표현해야 합니다. 예를 들자면 5, 1:20 혹은 2m와 같이 써야 합니다."

-----------------------------------------------------------------------
-- InfoBox.lua
--

--L.infoBox = "InfoBox"
