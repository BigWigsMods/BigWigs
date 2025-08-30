local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "koKR")
if not L then return end

-- API.lua
L.showAddonBar = "'%s' 애드온이 '%s' 바를 생성했습니다."

-- Core.lua
L.berserk = "광폭화"
L.berserk_desc = "보스가 언제 광폭화하는지 바와 시간 경고를 표시합니다."
L.altpower = "보조 자원 표시"
L.altpower_desc = "보조 자원 창을 표시합니다. 이 창은 파티/공격대원의 보조 자원 수치를 보여줍니다."
L.infobox = "정보 상자"
L.infobox_desc = "보스 전투와 관련된 정보를 담은 상자를 표시합니다."
L.stages = "단계"
L.stages_desc = "단계 변경 경고, 단계 지속 시간 타이머 바 등 보스 전투의 다양한 단계와 관련된 기능을 활성화합니다."
L.warmup = "준비"
L.warmup_desc = "보스와의 전투가 시작되기까지의 시간입니다."
L.proximity = "근접 디스플레이"
L.proximity_desc = "이 전투에 적합한 경우 근접 창을 표시하여, 플레이어와 너무 가까이 있는 플레이어를 나열합니다."
L.adds = "추가 몹"
L.adds_desc = "보스 전투 중 소환되는 다양한 추가 몹들과 관련된 기능들을 활성화합니다."
L.health = "체력"
L.health_desc = "보스와의 전투 중 다양한 체력 정보를 표시하는 기능을 활성화합니다."
L.energy = "기력"
L.energy_desc = "보스와의 전투 중 다양한 기력 정보를 표시하는 기능을 활성화합니다."

L.already_registered = "|cffff0000경고:|r |cff00ff00%s|r (|cffffff00%s|r)|1은;는; 이미 BigWigs 내에 모듈로 존재합니다, 하지만 무엇인가 다시 등록하려고 시도했습니다. 이는 일반적으로 몇몇 애드온 업데이터 오류로 인해 애드온 폴더 내에 이 모듈의 사본을 가지고 있다는 것을 의미합니다. 설치된 모든 BigWigs 폴더를 삭제한 후 처음부터 다시 설치하는 것을 권장합니다."

-- Loader / Options.lua
L.okay = "확인"
L.officialRelease = "당신은 BigWigs %s (%s)의 공식 배포 버전을 실행 중입니다."
L.alphaRelease = "당신은 BigWigs %s (%s)의 알파 릴리스 버전을 실행 중입니다."
L.sourceCheckout = "당신은 저장소로부터 직접 가져온 BigWigs %s의 소스를 실행 중입니다."
L.littlewigsOfficialRelease = "당신은 LittleWigs (%s)의 공식 배포 버전을 실행 중입니다."
L.littlewigsAlphaRelease = "당신은 LittleWigs (%s)의 알파 릴리스 버전을 실행 중입니다."
L.littlewigsSourceCheckout = "당신은 저장소로부터 직접 가져온 LittleWigs 의 소스를 실행 중입니다."
L.guildRelease = "당신은 %2$d 버전 공식 애드온을 바탕으로한 길드용 %1$d 버전의 BigWigs를 사용하고 있습니다."
L.getNewRelease = "당신의 BigWigs는 구버전이지만 (/bwv) CurseForge 클라이언트를 사용해 쉽게 업데이트할 수 있습니다. 또는 curseforge.com이나 addons.wago.io에서 직접 업데이트할 수 있습니다."
L.warnTwoReleases = "당신의 BigWigs는 최신 버전보다 2번 앞서 배포된 구버전입니다! 당신의 버전은 오류가 있거나, 기능이 누락됐거나, 완전히 틀린 타이머를 가지고 있을 수 있습니다. 업데이트를 강력히 권장합니다."
L.warnSeveralReleases = "|cffff0000당신의 BigWigs는 최신 버전보다 %d번 앞서 배포된 구버전입니다!! 다른 플레이어와 동기화 문제를 방지하기 위해 업데이트를 강력히 권장합니다!|r"
L.warnOldBase = "당신은 길드 버전의 BigWigs(%d) 를 사용하고 있지만, 당신의 기본 버전 (%d) 은 %d번 뒤처져 있습니다. 문제가 발생할 수 있습니다."

L.tooltipHint = "옵션에 접근하려면 |cffeda55f오른쪽 클릭|r하세요."
L.activeBossModules = "활성화된 보스 모듈:"

L.oldVersionsInGroup = "그룹에 BigWigs의 |cffff0000이전 버전|r을 가진 사람들이 있습니다. 자세한 내용은 /bwv로 확인할 수 있습니다."
L.upToDate = "최신 버전:"
L.outOfDate = "구버전:"
L.dbmUsers = "DBM 사용자:"
L.noBossMod = "보스 모듈 없음:"
L.offline = "오프라인"

L.missingAddOnPopup = "|cFF436EEE%s|r 애드온이 없습니다!"
L.missingAddOnRaidWarning = "|cFF436EEE%s|r 애드온이 없습니다! 이 지역에는 타이머가 표시되지 않습니다!"
L.outOfDateAddOnPopup = "|cFF436EEE%s|r 애드온이 오래되었습니다!"
L.outOfDateAddOnRaidWarning = "|cFF436EEE%s|r 애드온이 오래되었습니다! v%d.%d.%d가 있지만 최신 버전은 v%d.%d.%d입니다!"
L.disabledAddOn = "|cFF436EEE%s|r 애드온이 비활성화 중이므로 타이머를 표시할 수 없습니다."
L.removeAddOn = "'|cFF436EEE%s|r'|1이;가; '|cFF436EEE%s|r'|1으로;로; 대체되었으므로 제거해주세요."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "경고!\n |cFF436EEE%s|r을 업데이트했지만 기본 |cFF436EEEBigWigs|r 애드온도 업데이트해야 합니다.\n이를 무시하면 기능이 손상될 수 있습니다."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r이 올바르게 작동하려면 기본 |cFF436EEEBigWigs|r 애드온의 %d 버전이 필요하지만 %d 버전을 사용 중입니다."
L.addOnLoadFailedWithReason = "BigWigs에서 애드온 |cFF436EEE%s|r을 로드하는 데 실패했습니다. 이유는 %q입니다. BigWigs 개발팀에 알려주세요!"
L.addOnLoadFailedUnknownError = "BigWigs에서 애드온 |cFF436EEE%s|r을 로드하는 중 오류가 발생했습니다. BigWigs 개발팀에 알려주세요!"

L.expansionNames = {
	"오리지널", -- Classic
	"불타는 성전", -- The Burning Crusade
	"리치 왕의 분노", -- Wrath of the Lich King
	"대격변", -- Cataclysm
	"판다리아의 안개", -- Mists of Pandaria
	"드레노어의 전쟁군주", -- Warlords of Draenor
	"군단", -- Legion
	"격전의 아제로스", -- Battle for Azeroth
	"어둠땅", -- Shadowlands
	"용군단", -- Dragonflight
	"내부 전쟁", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "구렁",
	["LittleWigs_CurrentSeason"] = "현재 시즌",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "조심해라 (알갈론)"
L.FlagTaken = "깃발 뺏김 (PvP)"
L.Destruction = "파괴 (킬제덴)"
L.RunAway = "도망쳐라 꼬마야 달아나라 (커다란 나쁜 늑대)"
L.spell_on_you = "BigWigs: 당신에게 주문"
L.spell_under_you = "BigWigs: 발밑에 바닥"
L.simple_no_voice = "심플 (음성 없음)"

-- Options.lua
L.options = "옵션"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "공격대 보스"
L.dungeonBosses = "던전 보스"
L.introduction = "BigWigs에 오신 것을 환영합니다! 이곳은 보스들이 자유롭게 돌아다니는 곳입니다. 안전벨트를 착용하시고, 땅콩도 드시면서 여정을 즐겨주세요. BigWigs는 여러분의 아이들을 잡아먹진 않지만, 새로운 보스 공략을 레이드 팀을 위한 7코스 만찬처럼 완벽하게 준비할 수 있도록 도와드립니다."
L.sound = "소리"
L.minimapIcon = "미니맵 아이콘"
L.minimapToggle = "미니맵 아이콘의 표시/숨기기를 전환합니다."
L.compartmentMenu = "애드온 묶음에 아이콘 표시 안 함"
L.compartmentMenu_desc = "이 옵션을 끄면 BigWigs 아이콘이 애드온 묶음 메뉴에 표시됩니다. 이 옵션을 켜두는 것을 권장합니다."
L.configure = "구성"
L.resetPositions = "위치 초기화"
L.selectEncounter = "보스 전투 선택"
L.privateAuraSounds = "비공개 오라 소리"
L.privateAuraSounds_desc = "비공개 오라는 일반적으로 추적할 수 없지만, 능력으로 타깃이 되었을 때 재생되도록 사운드를 설정할 수 있습니다."
L.listAbilities = "파티/공격대 대화에 능력 나열하기"

L.dbmFaker = "DBM을 사용 중인 것처럼 위장하기"
L.dbmFakerDesc = "DBM 사용자가 DBM의 버전을 확인하여 누가 DBM을 사용하는지 확인할 때 DBM 사용자 명단에 당신을 표시합니다. DBM 사용을 강제하는 길드에서 유용합니다."
L.zoneMessages = "지역 메시지 표시"
L.zoneMessagesDesc = "비활성화하면 설치하지 않았지만 BigWigs에 타이머가 있는 지역에 입장했을 때 메시지 표시를 중지합니다. 당신이 유용하다고 느끼는 새로운 지역에 대한 타이머를 우리가 갑자기 만들었을 때 받을 수 있는 유일한 알림이기 때문에 이 기능을 사용하는 걸 권장합니다."
L.englishSayMessages = "영어 전용 메시지"
L.englishSayMessagesDesc = "보스 전투중 당신이 채팅창에 보내는 모든 '말하기'와 '외치기' 메시지는 항상 영어로 나타납니다. 당신이 혼용된 언어의 사용자들과 함께 할 경우 유용할 수 있습니다."

L.slashDescTitle = "|cFFFED000슬래시 명령어:|r"
L.slashDescPull = "|cFFFED000/pull:|r 공격대에 전투 예정 초읽기를 보냅니다."
L.slashDescBreak = "|cFFFED000/break:|r 공격대에 휴식 타이머를 보냅니다."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r 공격대에 사용자 설정 바를 보냅니다."
L.slashDescLocalBar = "|cFFFED000/localbar:|r 자신만 볼 수 있는 사용자 설정 바를 만듭니다."
L.slashDescRange = "|cFFFED000/range:|r 거리 표시기를 엽니다."
L.slashDescVersion = "|cFFFED000/bwv:|r BigWigs 버전 확인을 수행합니다."
L.slashDescConfig = "|cFFFED000/bw:|r BigWigs 구성을 엽니다."

L.gitHubDesc = "|cFF33FF99BigWigs은 GitHub에 호스트되는 오픈 소스 소프트웨어입니다. 우리는 우리를 도와줄 새로운 사람들을 항상 찾고 있으며 우리의 코드를 누구나 살펴보는 것을 환영합니다, 기고를 만들고 오류 보고를 제출하세요. BigWigs이 오늘날과 같이 훌륭한 것은 대부분 와우 커뮤니티의 도움 덕분입니다.|r"

L.BAR = "바"
L.MESSAGE = "메시지"
L.ICON = "공격대 징표"
L.SAY = "일반 대화"
L.FLASH = "깜빡임"
L.EMPHASIZE = "강조"
L.ME_ONLY = "나에게 걸렸을 때만"
L.ME_ONLY_desc = "이 옵션을 활성화하면 이 능력이 자신에게 영향을 끼칠때만 메시지를 표시합니다. 예를 들어, 나에게 걸렸을 때만 '폭탄: 플레이어'를 표시합니다."
L.PULSE = "맥박"
L.PULSE_desc = "화면을 깜빡이는 것과 더불어, 당신의 주의를 끌기 위해 특정 능력과 연관된 아이콘을 화면 중앙에 즉시 표시하도록 할 수 있습니다."
L.MESSAGE_desc = "대부분의 보스 능력에는 BigWigs이 화면에 표시하는 하나 이상의 메시지가 포함되어 있습니다. 이 옵션을 비활성화하면, 해당 옵션에 연결된 메시지(있는 경우)는 모두 표시되지 않습니다."
L.BAR_desc = "몇몇 보스 전투 능력에 대한 바가 적절한 때에 표시됩니다. 이 능력이 따르는 바를 숨기고 싶다면 이 옵션을 비활성화하세요."
L.FLASH_desc = "몇몇 능력은 다른 능력보다 더 중요합니다. 이 능력이 임박하거나 사용됐을 때 화면을 깜빡이고 싶다면 이 옵션을 체크하세요."
L.ICON_desc = "BigWigs은 능력에 영향을 받는 캐릭터를 징표로 표시할 수 있습니다. 이렇게 하면 캐릭터를 더 쉽게 찾을 수 있습니다."
L.SAY_desc = "대화 말풍선은 눈에 잘 띕니다. BigWigs은 자신에게 걸린 효과에 대하여 주위 사람에게 알리는데 일반 대화 메시지를 사용합니다."
L.EMPHASIZE_desc = "활성화하면 이 능력과 연관된 모든 메시지를 강조합니다, 더 크고 더 잘 보이게 만듭니다. 강조된 메시지의 크기와 글꼴을 주 옵션의 \"메시지\"에서 설정할 수 있습니다."
L.PROXIMITY = "근접 표시"
L.PROXIMITY_desc = "일부 능력은 종종 산개 진형을 요구합니다. 이럴 때 BigWigs은 해당 능력에 맞춰 거리 표시창을 띄워주어, 한눈에 안전한지 아닌지 바로 확인할 수 있게 해줍니다."
L.ALTPOWER = "보조 자원 표시"
L.ALTPOWER_desc = "몇몇 보스 전투는 파티 내의 플레이어에게 보조 자원 메커니즘을 사용합니다. 보조 자원 표시는 최소/최대 보조 자원을 가진 사람을 간략하게 보여줍니다, 특정 공략이나 전술에 유용할 수 있습니다."
L.TANK = "방어 전담만"
L.TANK_desc = "몇몇 능력은 방어 전담에게만 중요합니다. 이 능력에 대한 경고를 역할에 관계없이 보고싶다면, 이 옵션을 비활성하세요."
L.HEALER = "치유 전담만"
L.HEALER_desc = "몇몇 능력은 치유 전담에게만 중요합니다. 이 능력에 대한 경고를 역할에 관계없이 보고싶다면, 이 옵션을 비활성하세요."
L.TANK_HEALER = "방어 & 치유 전담만"
L.TANK_HEALER_desc = "몇몇 능력은 방어와 치유 전담에게만 중요합니다. 이 능력에 대한 경고를 역할에 관계없이 보고싶다면, 이 옵션을 비활성하세요."
L.DISPEL = "무효화 시전자만"
L.DISPEL_desc = "이 능력에 대한 경고를 무효화할 수 없을때라도 보고싶다면, 이 옵션을 비활성하세요."
L.VOICE = "음성"
L.VOICE_desc = "음성 플러그인을 설치하고, 이 옵션을 활성화하면 이 경고를 소리내어 말해주는 소리 파일을 재생합니다."
L.COUNTDOWN = "초읽기"
L.COUNTDOWN_desc = "활성화하면, 마지막 5초에 음성과 시각적 초읽기가 추가됩니다. 화면 가운데에 \"5... 4... 3... 2... 1...\"의 큰 숫자와 함께 초읽기를 해줍니다."
L.CASTBAR_COUNTDOWN = "초읽기(시전바만)"
L.CASTBAR_COUNTDOWN_desc = "활성화하면 시전바의 마지막 5초동안 음성 및 시각적 효과가 추가됩니다."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "보스의 능력들을 소리를 통해서 알려줍니다. 이 옵션을 비활성화 한다면 이 능력에 해당하는 소리가 들리지 않을 것입니다."
L.CASTBAR = "시전 바"
L.CASTBAR_desc = "주로 특정 중요 능력들을 시전하는 보스들을 상대할 때는 시전바가 표시됩니다. 이 능력에 해당하는 시전바를 숨기고 싶다면 이 옵션을 비활성화하세요."
L.SAY_COUNTDOWN = "카운트 표시"
L.SAY_COUNTDOWN_desc = "말풍선은 매우 알아보기 쉽습니다. BigWigs은 여러가지 말풍선으로 주위 사람들에게 어떤 능력이 만료된다는 것을 알려줍니다."
L.ME_ONLY_EMPHASIZE = "강조(나에게 걸렸을 때만)"
L.ME_ONLY_EMPHASIZE_desc = "이 옵션을 활성화하면 이 능력이 자신에게 영향을 끼칠때 메세지를 더 크고 눈에 띄게 표시합니다."
L.NAMEPLATE = "이름표"
L.NAMEPLATE_desc = "활성화하면 특정 능력에 대한 아이콘과 텍스트와 같은 기능이 이름표에 표시됩니다. 이는 여러 NPC가 동일한 능력을 사용할 때 어떤 NPC가 능력을 사용하는지 더 쉽게 인식할 수 있게 합니다."
L.PRIVATE = "개인 오라"
L.PRIVATE_desc = "이 설정은 일반 시전 알림과 바에만 적용됩니다!\n\n이 능력에 대상이 될 때 재생할 소리는 우측 상단의 \"보스 전투 선택\" 드롭다운에서 \"비공개 오라 소리\"를 선택하여 변경할 수 있습니다."

L.advanced_options = "고급 옵션"
L.back = "<< 뒤로"

L.tank = "|cFFFF0000방어 전담만 경보합니다.|r "
L.healer = "|cFFFF0000치유 전담만 경보합니다.|r "
L.tankhealer = "|cFFFF0000방어 & 치유 전담만 경보합니다.|r "
L.dispeller = "|cFFFF0000무효화 시전자만 경보합니다.|r "

-- Sharing.lua
L.import = "가져오기"
L.import_info = "문자열을 입력한 후 가져올 설정을 선택할 수 있습니다.\n가져오기 문자열에 설정이 포함되어 있지 않으면 선택할 수 없습니다.\n\n|cffff4411이 가져오기는 일반 설정에만 영향을 미치며 보스별 설정에는 영향을 미치지 않습니다.|r"
L.import_info_active = "가져오고 싶은 부분을 선택한 후 가져오기 버튼을 클릭하세요."
L.import_info_none = "|cFFFF0000가져오기 문자열이 호환되지 않거나 오래되었습니다.|r"
L.export = "내보내기"
L.export_info = "내보내고 다른 사람과 공유할 설정을 선택하세요.\n\n|cffff4411일반 설정만 공유할 수 있으며 보스별 설정에는 영향을 미치지 않습니다.|r"
L.export_string = "내보내기 문자열"
L.export_string_desc = "설정을 공유하려면 이 BigWigs 문자열을 복사하세요."
L.import_string = "가져오기 문자열"
L.import_string_desc = "가져오려는 BigWigs 문자열을 여기에 붙여넣으세요."
L.position = "위치"
L.settings = "설정"
L.other_settings = "기타 설정"
L.nameplate_settings_import_desc = "모든 이름표 설정 가져오기."
L.nameplate_settings_export_desc = "모든 이름표 설정 내보내기."
L.position_import_bars_desc = "바의 위치(앵커)를 가져옵니다."
L.position_import_messages_desc = "메시지의 위치(앵커)를 가져옵니다."
L.position_import_countdown_desc = "카운트다운의 위치(앵커)를 가져옵니다."
L.position_export_bars_desc = "바의 위치(앵커)를 내보냅니다."
L.position_export_messages_desc = "메시지의 위치(앵커)를 내보냅니다."
L.position_export_countdown_desc = "카운트다운의 위치(앵커)를 내보냅니다."
L.settings_import_bars_desc = "크기, 글꼴 등의 일반 바 설정을 가져옵니다."
L.settings_import_messages_desc = "크기, 글꼴 등의 일반 메시지 설정을 가져옵니다."
L.settings_import_countdown_desc = "음성, 크기, 글꼴 등의 일반 카운트다운 설정을 가져옵니다."
L.settings_export_bars_desc = "크기, 글꼴 등의 일반 바 설정을 내보냅니다."
L.settings_export_messages_desc = "크기, 글꼴 등의 일반 메시지 설정을 내보냅니다."
L.settings_export_countdown_desc = "음성, 크기, 글꼴 등의 일반 카운트다운 설정을 내보냅니다."
L.colors_import_bars_desc = "바의 색상을 가져옵니다."
L.colors_import_messages_desc = "메시지의 색상을 가져옵니다."
L.color_import_countdown_desc = "카운트다운의 색상을 가져옵니다."
L.colors_export_bars_desc = "바의 색상을 내보냅니다."
L.colors_export_messages_desc = "메시지의 색상을 내보냅니다."
L.color_export_countdown_desc = "카운트다운의 색상을 내보냅니다."
L.confirm_import = "선택한 설정이 현재 선택한 프로필의 설정을 덮어씁니다:\n\n|cFF33FF99\"%s\"|r\n\n이 작업을 진행하시겠습니까?"
L.confirm_import_addon = "애드온 |cFF436EEE\"%s\"|r이(가) 새로운 BigWigs 설정을 자동으로 가져와 현재 선택한 BigWigs 프로필의 설정을 덮어쓰려 합니다:\n\n|cFF33FF99\"%s\"|r\n\n이 작업을 진행하시겠습니까?"
L.confirm_import_addon_new_profile = "애드온 |cFF436EEE\"%s\"|r이(가) 새로운 BigWigs 프로필을 자동으로 생성하려 합니다:\n\n|cFF33FF99\"%s\"|r\n\n이 새로운 프로필을 수락하면 해당 프로필로 전환됩니다."
L.confirm_import_addon_edit_profile = "애드온 |cFF436EEE\"%s\"|r이(가) BigWigs 프로필 중 하나를 자동으로 수정하려 합니다:\n\n|cFF33FF99\"%s\"|r\n\n이 변경 사항을 수락하면 해당 프로필로 전환됩니다."
L.no_string_available = "가져올 가져오기 문자열이 없습니다. 먼저 문자열을 가져오세요."
L.no_import_message = "가져온 설정이 없습니다."
L.import_success = "가져오기 완료: %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "바 위치"
L.imported_bar_settings = "바 설정"
L.imported_bar_colors = "바 색상"
L.imported_message_positions = "메시지 위치"
L.imported_message_settings = "메시지 설정"
L.imported_message_colors = "메시지 색상"
L.imported_countdown_position = "카운트다운 위치"
L.imported_countdown_settings = "카운트다운 설정"
L.imported_countdown_color = "카운트다운 색상"
L.imported_nameplate_settings = "이름표 설정"
L.imported_mythicplus_settings = "신화+ 설정"
L.mythicplus_settings_import_desc = "모든 신화+ 설정 가져오기."
L.mythicplus_settings_export_desc = "모든 신화+ 설정 내보내기."

-- Statistics
L.statistics = "통계"
L.defeat = "패배"
L.defeat_desc = "이 보스 전투에서 패배한 총 횟수입니다."
L.victory = "승리"
L.victory_desc = "이 보스 전투에서 승리한 총 횟수입니다."
L.fastest = "최고 기록"
L.fastest_desc = "최고 승리 시간과 그 날짜입니다 (년/월/일)."
L.first = "최초 승리"
L.first_desc = "이 보스 전투에서 처음 승리한 시간, 형식은 다음과 같습니다:\n[최초 승리 전 패배 횟수] - [전투 지속 시간] - [승리한 년/월/일]"

-- Difficulty levels for statistics display on bosses
L.unknown = "알 수 없음"
L.LFR = "공찾"
L.normal = "일반"
L.heroic = "영웅"
L.mythic = "신화"
L.timewalk = "시간여행"
L.solotier8 = "솔플 8단계"
L.solotier11 = "솔플 11단계"
L.story = "스토리"
L.mplus = "신화+ %d"
L.SOD = "디스커버리 시즌"
L.hardcore = "하드코어"
L.level1 = "레벨 1"
L.level2 = "레벨 2"
L.level3 = "레벨 3"
L.N10 = "일반 10"
L.N25 = "일반 25"
L.H10 = "영웅 10"
L.H25 = "영웅 25"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "도구"
L.toolsDesc = "BigWigs은 보스와의 전투를 더욱 빠르고 간편하게 만들어 주는 다양한 도구 또는 \"편의 기능\"을 제공합니다. |cFF33FF99+|r 아이콘을 클릭하여 메뉴를 확장하면 모든 기능을 확인할 수 있습니다."

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "자동 역할"
L.autoRoleExplainer = "그룹에 가입하거나 그룹에 있는 동안 특성 전문화를 변경할 때마다 BigWigs이 자동으로 그룹 역할(탱커, 힐러, 딜러)을 그에 맞게 조정합니다.\n\n"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs 쐐기돌"
L.keystoneHeaderParty = "파티"
L.keystoneRefreshParty = "파티 새로 고침"
L.keystoneHeaderGuild = "길드"
L.keystoneRefreshGuild = "길드 새로 고침"
L.keystoneLevelTooltip = "쐐기돌 레벨: |cFFFFFFFF%s|r"
L.keystoneMapTooltip = "던전: |cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "신화+ 등급: |cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "플레이어가 이 정보를 숨기도록 선택했습니다."
L.keystoneTabOnline = "온라인"
L.keystoneTabAlts = "부캐"
L.keystoneTabTeleports = "순간이동"
L.keystoneHeaderMyCharacters = "내 캐릭터"
L.keystoneTeleportNotLearned = "'|cFFFFFFFF%s|r'순간이동 주문을 아직 |cFFFF4411배우지 않았습니다|r."
L.keystoneTeleportOnCooldown = "'|cFFFFFFFF%s|r'순간이동 주문은 현재 %d 시간 %d 분 동안 |cFFFF4411재사용 대기 중입니다|r."
L.keystoneTeleportReady = "'|cFFFFFFFF%s|r'순간이동 주문은 |cFF33FF99사용할 수 있습니다|r. 클릭하여 시전하세요."
L.keystoneTeleportInCombat = "전투 중에는 순간이동할 수 없습니다."
L.keystoneTabHistory = "기록"
L.keystoneHeaderThisWeek = "이번 주"
L.keystoneHeaderOlder = "이전 기록"
L.keystoneScoreGainedTooltip = "획득 점수: |cFFFFFFFF+%d|r\n던전 점수: |cFFFFFFFF%d|r"
--L.keystoneCompletedTooltip = "제한 시간 내에 완료: |cFFFFFFFF%d min %d sec|r\nTime Limit: |cFFFFFFFF%d min %d sec|r"
--L.keystoneFailedTooltip = "제한 시간 내에 완료하지 못함: |cFFFFFFFF%d min %d sec|r\nTime Limit: |cFFFFFFFF%d min %d sec|r"
L.keystoneExplainer = "신화+ 경험을 향상시키는 다양한 도구 모음입니다."
L.keystoneAutoSlot = "쐐기돌 자동 삽입"
L.keystoneAutoSlotDesc = "마력의 샘을 열 때 자동으로 쐐기돌을 넣습니다."
L.keystoneAutoSlotMessage = "%s 쐐기돌을 자동으로 넣었습니다."
L.keystoneModuleName = "신화+"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d 지금 시작합니다!" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "신화+ 던전을 시작하면 카운트다운이 재생됩니다. 듣고 싶은 음성과 카운트다운을 시작 시간을 선택하세요.\n\n"
L.keystoneCountdownBeginsDesc = "신화+ 시작 타이머에서 카운트다운 재생이 시작될 남은 시간을 선택하세요."
L.keystoneCountdownBeginsSound = "신화+ 카운트다운 시작 시 사운드 재생"
L.keystoneCountdownEndsSound = "신화+ 카운트다운 종료 시 사운드 재생"
L.keystoneViewerTitle = "쐐기돌 뷰어"
L.keystoneHideGuildTitle = "길드원에게 내 쐐기돌 숨기기"
L.keystoneHideGuildDesc = "|cffff4411권장하지 않습니다.|r 이 기능은 길드원들이 당신의 쐐기돌을 볼 수 없도록 합니다. 파티 내의 다른 멤버들은 여전히 이를 확인할 수 있습니다."
L.keystoneHideGuildWarning = "길드원이 당신의 쐐기돌을 볼 수 없도록 하는 것은 |cffff4411권장하지 않습니다|r.\n\n정말로 이 기능을 사용하시겠습니까?"
L.keystoneAutoShowEndOfRun = "신화+ 던전이 종료될 때 표시"
L.keystoneAutoShowEndOfRunDesc = "신화+ 던전이 종료될 때 자동으로 쐐기돌 뷰어를 표시합니다.\n\n|cFF33FF99이 기능을 사용하면 파티가 획득한 새로운 쐐기돌을 확인할 수 있습니다.|r"
L.keystoneViewerExplainer = "쐐기돌 뷰어를 열려면 |cFF33FF99/key|r 명령어를 사용하거나 아래 버튼을 클릭하세요.\n\n"
L.keystoneViewerOpen = "쐐기돌 뷰어 열기"
L.keystoneViewerKeybindingExplainer = "\n\n쐐기돌 뷰어를 열도록 단축키를 설정할 수도 있습니다:\n\n"
L.keystoneViewerKeybindingDesc = "단축키로 쐐기돌 뷰어를 엽니다."
L.keystoneClickToWhisper = "귓속말 대화 상자를 열려면 클릭"
L.keystoneClickToTeleportNow = "\n여기로 순간이동 하려면 클릭"
L.keystoneClickToTeleportCooldown = "\n순간이동 불가, 재사용 대기 중"
L.keystoneClickToTeleportNotLearned = "\n순간이동 불가, 주문 미습득"
L.keystoneHistoryRuns = "총 %d개"
L.keystoneHistoryRunsThisWeekTooltip = "이번 주 던전 총계: |cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "이번 주 이전까지 던전 총계: |cFFFFFFFF%d|r"
L.keystoneHistoryScore = "점수 +%d"
L.keystoneHistoryScoreThisWeekTooltip = "이번 주 획득 총 점수: |cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "이번 주 이전에 획득한 총 점수: |cFFFFFFFF+%d|r"
L.keystoneTimeUnder = "|cFF33FF99-%02d:%02d|r"
L.keystoneTimeOver = "|cFFFF4411+%02d:%02d|r"
--L.keystoneTeleportTip = "TIP: Click the dungeon name below to teleport directly to the dungeon entrance."

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "부화장"
L.keystoneShortName_DarkflameCleft = "어불동"
L.keystoneShortName_PrioryOfTheSacredFlame = "수도원"
L.keystoneShortName_CinderbrewMeadery = "양조장"
L.keystoneShortName_OperationFloodgate = "수문"
L.keystoneShortName_TheaterOfPain = "고투"
L.keystoneShortName_TheMotherlode = "왕노"
L.keystoneShortName_OperationMechagonWorkshop = "작업장"
L.keystoneShortName_EcoDomeAldani = "알다니"
L.keystoneShortName_HallsOfAtonement = "속죄"
L.keystoneShortName_AraKaraCityOfEchoes = "아라카라"
L.keystoneShortName_TazaveshSoleahsGambit = "소레아"
L.keystoneShortName_TazaveshStreetsOfWonder = "거리"
L.keystoneShortName_TheDawnbreaker = "새인호"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "부화장"
L.keystoneShortName_DarkflameCleft_Bar = "어둠불꽃 동굴"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "수도원"
L.keystoneShortName_CinderbrewMeadery_Bar = "양조장"
L.keystoneShortName_OperationFloodgate_Bar = "수문"
L.keystoneShortName_TheaterOfPain_Bar = "고투"
L.keystoneShortName_TheMotherlode_Bar = "왕노"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "작업장"
L.keystoneShortName_EcoDomeAldani_Bar = "알다니"
L.keystoneShortName_HallsOfAtonement_Bar = "속죄"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "아라카라"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "소레아"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "거리"
L.keystoneShortName_TheDawnbreaker_Bar = "새인호"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "누가 쐐기돌을 가지고 있나요?"
L.instanceKeysDesc = "신화 던전에 입장하면 해당 던전의 쐐기돌을 가진 플레이어가 목록으로 표시됩니다.\n\n"
L.instanceKeysTest8 = "|cFF00FF98수도사:|r +8"
L.instanceKeysTest10 = "|cFFFF7C0A드루이드:|r +10"
L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d (%s)" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
L.instanceKeysShowAll = "모든 플레이어 항상 표시"
L.instanceKeysShowAllDesc = "이 옵션을 활성화하면 현재 있는 던전과 관련이 없는 쐐기돌을 가진 플레이어도 목록에 표시됩니다."
L.instanceKeysOtherDungeonColor = "다른 던전 색상"
L.instanceKeysOtherDungeonColorDesc = "현재 있는 던전과 관련이 없는 쐐기돌을 가진 플레이어의 글꼴 색상을 선택합니다."
L.instanceKeysEndOfRunDesc = "기본적으로 목록은 신화 던전에 들어갈 때만 표시됩니다. 이 옵션을 활성화하면 신화+가 끝난 후에도 목록이 표시됩니다."

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "파티 찾기 타이머"
L.lfgTimerExplainer = "파티 찾기 대기열 창이 표시될 때마다 BigWigs은 대기열을 수락하기까지 남은 시간을 표시하는 타이머 바를 생성합니다.\n\n"
L.lfgUseMaster = "'주 음량' 오디오 채널에서 파티 찾기 준비 완료 사운드 재생"
L.lfgUseMasterDesc = "이 옵션을 활성화하면 파티 찾기 준비 완료음이 '주 음량' 오디오 채널을 통해 재생됩니다. 이 옵션을 비활성화하면 '%s' 오디오 채널을 통해 재생됩니다."

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "일반"
L.advanced = "고급"
L.comma = ", "
L.reset = "초기화"
L.resetDesc = "위의 설정을 기본값으로 초기화합니다."
L.resetAll = "모두 초기화"

L.positionX = "X 위치"
L.positionY = "Y 위치"
L.positionExact = "정확한 위치"
L.positionDesc = "고정기로부터 정확한 위치를 원한다면 상자에 입력하거나 슬라이더를 움직이세요."
L.width = "너비"
L.height = "높이"
L.size = "크기"
L.sizeDesc = "보통 고정기를 끌어서 크기를 조정합니다. 정확한 크기를 지정하고 싶다면 슬라이더를 사용하거나 직접 수치를 입력 상자안에 써넣으세요."
L.fontSizeDesc = "글씨 크기를 슬라이더를 이용해 조정하거나 직접 수치를 입력 상자안에 써넣으세요 (최대 200)."
L.disabled = "비활성"
L.disableDesc = "'%s' 기능을 비활성화하려고 합니다. |cffff4411권장하지 않음|r.\n\n정말로 비활성화하시겠습니까?"
L.keybinding = "키 설정"
L.dragToResize = "드래그하여 크기 조정"

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
L.drawStrata = "계층"
L.medium = "중간"
L.low = "낮음"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "보조 자원"
L.altPowerDesc = "보조 자원 항목은 보스가 플레이어에게 보조 자원을 제공하는 매우 드문 보스에서만 발동합니다. 이 디스플레이는 당신과 당신의 파티가 얼만큼의 '보조 자원'이 있는지 리스트로 표시합니다. 이 디스플레이를 옮기려면, 아래의 테스트 버튼을 사용하십시오."
L.toggleDisplayPrint = "디스플레이가 다음에 표시됩니다. 이 보스 전투에서 완전히 비활성하려면 보스 전투 옵션에서 끄도록 전환해야 합니다."
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
L.autoReplyDesc = "보스와 전투 중일때 자동으로 귓속말에 응답합니다."
L.responseType = "응답 형식"
L.autoReplyFinalReply = "전투종료시 귓속말"
L.guildAndFriends = "길드원 및 친구들"
L.everyoneElse = "그 외 모두"

L.autoReplyBasic = "보스와 전투하느라 바쁩니다."
L.autoReplyNormal = "'%s'와(과) 전투하느라 바쁩니다."
L.autoReplyAdvanced = "'%s' (%s)와(과) 전투하느라 바쁩니다.현재 %d/%d 명이 생존 중입니다."
L.autoReplyExtreme = "'%s' (%s)와(과) 전투하느라 바쁩니다.현재 %d/%d 명이 생존 중입니다: %s"

L.autoReplyLeftCombatBasic = "더 이상 보스와 싸우고 있지 않습니다."
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
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "배율"
L.emphasizeMultiplierDesc = "강조 고정기로 이동하는 바가 활성화되지 않았을때, 이 옵션은 해당 바를 강조 바로 이동하지 않고 바의 크기를 주어진 배율만큼 확대시킵니다."

L.enable = "활성화"
L.move = "이동"
L.moveDesc = "강조된 바를 강조 고정기로 이동시킵니다. 이 옵션을 끄면 강조된 바는 단순히 크기 비율과 색상을 변경합니다."
L.emphasizedBars = "강조된 바"
L.align = "정렬"
L.alignText = "문자 정렬"
L.alignTime = "시간 정렬"
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
L.sendCustomBar = "BigWigs 및 DBM 사용자에게 사용자 설정 바 '%s'|1을;를; 보냅니다."

L.requiresLeadOrAssist = "이 기능은 공격대장이나 부공격대장 권한이 필요합니다."
L.encounterRestricted = "이 기능은 보스 전투 진행 중에 사용할 수 없습니다."
L.wrongCustomBarFormat = "잘못된 형식입니다. 올바른 예: /raidbar 20 문자"
L.wrongTime = "유효하지 않은 시간이 지정되었습니다. <시간>은 초 단위 숫자, 분:초 형식, 또는 분m으로 입력할 수 있습니다. 예제 5, 1:20 또는 2m."

L.wrongBreakFormat = "1분에서 60분 사이여야 합니다. 올바른 예제: /break 5"
L.sendBreak = "BigWigs 및 DBM 사용자에게 휴식 타이머를 보냅니다."
L.breakStarted = "%s 사용자 %s|1이;가; 휴식 타이머를 시작했습니다."
L.breakStopped = "%s|1이;가; 휴식 타이머를 취소했습니다."
L.breakBar = "휴식 시간"
L.breakMinutes = "%d분 후 휴식 종료!"
L.breakSeconds = "%d초 후 휴식 종료!"
L.breakFinished = "휴식 시간이 끝났습니다!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "보스 기능 차단"
L.bossBlockDesc = "보스 전투 중 차단할 수 있는 다양한 기능들을 설정합니다.\n\n"
L.bossBlockAudioDesc = "보스 전투 중 음소거할 사운드를 설정합니다. \n\n|cff808080회색|r으로 표시된 옵션들은 게임 소리 설정에서 꺼져있습니다.\n\n"
L.movieBlocked = "이 동영상을 본적이 있으므로 건너뜁니다."
L.blockEmotes = "화면 중앙의 감정표현 차단"
L.blockEmotesDesc = "몇몇 보스는 특정 능력에 감정표현을 표시합니다, 이 메시지는 너무 길고 설명적입니다. 우리는 게임 플레이를 방해하지 않으면서 당신이 특별한 행동을 하지 않아도 되는, 작고 더 알맞은 메시지를 만들려고 노력합니다.\n\n참고하세요: 보스 감정표현를 읽고 싶다면 여전히 대화에서 확인할 수 있습니다."
L.blockMovies = "반복되는 동영상 차단"
L.blockMoviesDesc = "보스 전투 동영상이 한번만 재생되도록 허용합니다 (각 한번씩 볼수 있도록) 그 후엔 차단됩니다."
L.blockFollowerMission = "추종자 임무 알림 차단" -- Rename to follower mission
L.blockFollowerMissionDesc = "추종자 임무 알림은 여러가지를 표시하지만 주로 모험이 완료되었을 때 표시합니다.\n\n이 알림들은 보스 전투 중 UI의 중요한 부분을 가릴 수 있으므로 차단하는 것을 권장합니다."
L.blockGuildChallenge = "길드 도전 알림 차단"
L.blockGuildChallengeDesc = "길드 도전 알림은 여러가지를 표시하지만 주로 당신의 길드 파티의 영웅 던전이나 도전 모드 던전 완료를 표시합니다.\n\n이 알림들은 보스 전투 중 UI의 중요한 부분을 가릴 수 있으므로 차단하는 것을 권장합니다."
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
L.disableAudioDesc = "게임 소리 설정에서 '%s' 설정이 꺼지고 전투가 끝난 후에 다시 켜집니다. BigWigs의 알림 소리에 더 집중하는데 도움이 됩니다."
L.blockTooltipQuests = "툴팁에서 퀘스트 목표 표시를 숨깁니다."
L.blockTooltipQuestsDesc = "보스를 처치하는 퀘스트를 진행 중인 경우 해당 보스에 마우스를 올렸을 때 보통 '0/1 완료' 같은 문구가 툴팁에 표시됩니다. 전투 중에 이 문구들을 숨김으로써 툴팁의 크기가 너무 크게 확장되는 것을 방지합니다."
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
L.newRespawnPoint = "새로운 부활 지점"

L.userNotifySfx = "보스 기능 차단으로 비활성화된 사운드 효과를 강제로 다시 활성화합니다."
L.userNotifyMusic = "보스 기능 차단으로 비활성화된 배경음악를 강제로 다시 활성화합니다."
L.userNotifyAmbience = "보스 기능 차단으로 비활성화된 환경 소리를 강제로 다시 활성화합니다."
L.userNotifyErrorSpeech = "보스 기능 차단으로 비활성화된 오류 음성을 강제로 다시 활성화합니다."

L.subzone_grand_bazaar = "대시장" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "잔달라 항구" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "동쪽 회랑" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "색상"

L.text = "문자"
L.textShadow = "문자 그림자"
L.expiring_normal = "일반"
L.emphasized = "강조"

L.resetColorsDesc = "위의 색상을 기본 색상으로 초기화합니다."
L.resetAllColorsDesc = "보스 전투 설정에 사용자 설정 색상을 적용했다면, 이 버튼은 여기에 정의된 색상이 대신 사용되도록 모두 초기화합니다."

L.red = "빨강"
L.redDesc = "일반적인 경보"
L.blue = "파랑"
L.blueDesc = "디버프가 적용되는 등 자신에게 직접적으로 영향을 미치는 사항에 대한 경고."
L.orange = "주황"
L.yellow = "노랑"
L.green = "초록"
L.greenDesc = "디버프가 제거되는 등 좋은 일이 발생하면 경고."
L.cyan = "청록"
L.cyanDesc = "다음 단계로 넘어가는 등 전투 상태의 변화에 ​​대한 경고."
L.purple = "보라"
L.purpleDesc = "탱커 디버프 중첩 등 탱커 관련 능력에 대한 경고."

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
L.countdownDesc = "음성과 텍스트 초읽기에 관련된 기능입니다. 기본적으로 활성화되어 있는 경우는 드물지만, 특정 보스 전투 설정에서 모든 보스 능력에 대해 카운트다운을 활성화할 수 있습니다."
L.countdownAudioHeader = "음성 초읽기"
L.countdownTextHeader = "문자 초읽기"
L.resetCountdownDesc = "위의 모든 초읽기 관련 설정들을 기본값으로 초기화합니다."
L.resetAllCountdownDesc = "위의 초읽기 관련 설정들은 물론 보스 별 설정에서 따로 사용자 지정된 초읽기 음성들 역시 기본값으로 초기화합니다."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "정보 상자"

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
L.emphasizedDesc = "강조 메시지는 화면 중앙에 큰 메시지로 표시되어 플레이어의 주의를 끌기 위한 것입니다. 기본적으로 활성화되어 있는 경우는 드물지만, 특정 보스 전투 설정에서 모든 보스 능력에 대해 활성화할 수 있습니다."
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

L.messagesOptInHeaderOff = "보스 모드 메시지 '선택 활성화' 모드: 이 옵션을 활성화하면 모든 보스 모듈에서 메시지가 비활성화됩니다.\n\n원하는 메시지만 각 모듈에서 수동으로 활성화해야 합니다.\n\n"
L.messagesOptInHeaderOn = "보스 모드 메시지 '선택 활성화' 모드가 |cFF33FF99활성화|r되었습니다. 보스 모드 메시지를 보려면 특정 보스 능력 설정에 들어가서 '|cFF33FF99메시지|r' 옵션을 활성화하세요.\n\n"
L.messagesOptInTitle = "보스 모드 메시지 '선택 활성화' 모드"
L.messagesOptInWarning = "|cffff4411경고!|r\n\n'선택 활성화' 모드를 활성화하면 모든 보스 모듈에서 메시지가 비활성화됩니다. 원하는 메시지만 각 모듈에서 수동으로 활성화해야 합니다.\n\nUI가 재시작됩니다. 계속하시겠습니까?"

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
L.borderOffset = "테두리 위치 조정"
L.borderName = "테두리 이름"
L.showNumbers = "숫자 표시"
L.showNumbersDesc = "아이콘에 숫자 표시."
L.cooldown = "쿨다운"
L.cooldownEmphasizeHeader = "기본적으로 강조 기능은 비활성화되어 있습니다(0초). 1초 이상으로 설정하면 강조 기능이 활성화됩니다. 이렇게 하면 해당 숫자에 다른 글꼴 색상과 글꼴 크기를 설정할 수 있습니다."
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
L.fixate_test = "테스트 텍스트" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "이름표 텍스트와 관련된 모든 옵션을 초기화합니다."
L.glowAt = "반짝임 시작 (초)"
L.glowAt_desc = "반짝임이 시작될 때 재사용 대기시간이 몇 초 남았는지 선택합니다."
L.offsetX = "X 위치 조정"
L.offsetY = "Y 위치 조정"
L.headerIconSizeTarget = "현재 대상의 아이콘 크기"
L.headerIconSizeOthers = "다른 모든 대상의 아이콘 크기"
L.headerIconPositionTarget = "현재 대상의 아이콘 위치"
L.headerIconPositionOthers = "다른 모든 대상의 아이콘 위치"

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

L.nameplateOptInHeaderOff = "\n\n\n\n보스 모드 이름표 '선택 활성화' 모드: 이 옵션을 활성화하면 모든 보스 모듈에서 이름표가 비활성화됩니다.\n\n원하는 이름표만 각 모듈에서 수동으로 활성화해야 합니다.\n\n"
L.nameplateOptInHeaderOn = "\n\n\n\n보스 모드 이름표 '선택 활성화' 모드가 |cFF33FF99활성화|r되었습니다. 보스 모드 이름표를 보려면 특정 보스 능력 설정에 들어가서 '|cFF33FF99이름표|r' 옵션을 활성화하세요.\n\n"
L.nameplateOptInTitle = "보스 모드 이름표 '선택 활성화' 모드"
L.nameplateOptInWarning = "|cffff4411경고!|r\n\n'선택 활성화' 모드를 활성화하면 모든 보스 모듈에서 이름표가 비활성화됩니다. 원하는 이름표만 각 모듈에서 수동으로 활성화해야 합니다.\n\nUI가 재시작됩니다. 계속하시겠습니까?"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "사용자 설정 거리 표시기"
L.proximityTitle = "%d미터 / %d 플레이어" -- yd = yards (short)
L.proximity_name = "근접"
L.soundDelay = "소리 지연"
L.soundDelayDesc = "누군가 당신과 가까이 있을 때 BigWigs에 지정된 소리의 반복 재생 간격을 지정합니다."

L.resetProximityDesc = "위치를 비롯한 근접에 관련된 모든 설정을 기본값으로 초기화합니다."

L.close = "닫기"
L.closeProximityDesc = "근접 디스플레이를 닫습니다.\n\n모든 보스 전투에서 완전히 비활성화하려면, 관련 보스 모듈의 옵션에서 '근접' 옵션을 꺼야합니다."
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
L.tooltipDesc = "근접 디스플레이가 보스 전투 능력과 직접 연관되어 있을 때 주문 툴팁을 표시하거나 숨깁니다."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "초읽기 유형"
L.combatLog = "자동 전투 기록"
L.combatLogDesc = "전투 예정 타이머 시작부터 보스 전투 종료로 타이머가 끝날 때까지의 전투 기록을 자동으로 켭니다."

L.pull = "전투 예정"
L.engageSoundTitle = "보스 전투가 시작되면 사운드 재생"
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
L.pullExplainer = "\n|cFF33FF99/pull|r은 일반적인 풀 타이머를 시작합니다.\n|cFF33FF99/pull 7|r은 7초 풀 타이머를 시작합니다. 원하는 숫자를 사용할 수 있습니다.\n또는 아래에 키 설정을 할 수도 있습니다.\n\n"
L.pullKeybindingDesc = "풀 타이머를 시작하기 위한 키 설정을 선택하세요."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "징표"
L.raidIconsDescription = "일부 보스 전투에서는 폭탄형 능력처럼 특정 플레이어를 지정하거나, 쫓기는 플레이어, 혹은 다른 방식으로 주목해야 하는 플레이어가 있을 수 있습니다. 이곳에서는 이런 플레이어를 표시할 때 사용할 공격대 징표를 직접 지정할 수 있습니다.\n\n|cffff4411참고: 플레이어가 이미 수동으로 표시된 경우 BigWigs은 해당 플레이어의 징표를 변경하지 않습니다.|r"
L.primary = "첫번째"
L.primaryDesc = "첫 번째로 사용할 공격대 징표."
L.secondary = "두번째"
L.secondaryDesc = "두 번째로 사용할 공격대 징표."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "소리"
L.soundsDesc = "BigWigs은 '주 음량' 소리 채널로 모든 소리를 재생합니다. 소리가 너무 작거나 너무 크다면, 와우의 소리 설정에 들어가서 '주 음량' 을 알맞게 조정하십시오.\n\n아래에선 특별한 상황에서 나오는 다양한 소리들을 설정하거나, '없음'으로 설정해서 비활성화 할 수 있습니다. 특성 보스의 능력의 소리만 바꾸고 싶다면, 보스 전투 설정에서 바꾸십시오.\n\n"
L.oldSounds = "예전 소리들"

L.Alarm = "알람"
L.Info = "정보"
L.Alert = "경보"
L.Long = "길게"
L.Warning = "경고"
L.onyou = "나에게 적용되는 주문, 강화 효과, 약화 효과"
L.underyou = "내 밑의 \"바닥\"을 피해야 할 때"
L.privateaura = "'비공개 오라'가 당신에게 있을 때"

L.customSoundDesc = "모듈이 제공한 소리 대신에 선택된 사용자 설정 소리를 재생합니다."
L.resetSoundDesc = "소리에 관련된 모든 설정을 기본값으로 초기화합니다."
L.resetAllCustomSound = "보스 전투 설정에 대해 사운드를 사용자 지정한 경우, 이 버튼을 누르면 모든 사운드가 재설정되어 여기에 정의된 사운드가 대신 사용됩니다."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "보스 통계"
L.bossStatsDescription = "승리 횟수, 패배 횟수, 첫 승리 날짜, 가장 빠른 승리 등 다양한 보스 관련 통계가 기록됩니다. 이러한 통계는 각 보스의 설정 화면에서 확인할 수 있지만, 기록된 통계가 없는 보스의 경우 숨겨집니다."
L.createTimeBar = "'최고 기록' 바 표시"
L.bestTimeBar = "최고 기록"
L.healthPrint = "생명력: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "대화 메시지"
L.newFastestVictoryOption = "새로운 가장 빠른 승리"
L.victoryOption = "당신이 승리했습니다"
L.defeatOption = "당신이 패배했습니다"
L.bossHealthOption = "보스 생명력"
L.bossVictoryPrint = "'%s'에게 %s 후 승리했습니다." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "'%s'에게 %s 후 패배했습니다." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "새로운 최고 승리 시간: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "승리"
L.victoryHeader = "보스와의 전투에서 승리한 후 취해야 할 작업을 구성합니다."
L.victorySound = "승리 소리 재생하기"
L.victoryMessages = "보스 처치 메시지 표시"
L.victoryMessageBigWigs = "BigWigs 메시지 표시"
L.victoryMessageBigWigsDesc = "BigWigs 메시지는 단순한 \"보스를 처치했습니다\" 메시지입니다."
L.victoryMessageBlizzard = "블리자드 메시지 표시"
L.victoryMessageBlizzardDesc = "Blizzard 메시지는 화면 중앙의 아주 큰 \"보스 처치\" 애니메이션입니다."
L.defeated = "%s|1을;를; 처치했습니다"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "전멸"
L.wipeSoundTitle = "전멸했을 때 소리 재생"
L.respawn = "재생성"
L.showRespawnBar = "재생성 바 표시"
L.showRespawnBarDesc = "보스에서 전멸 후에 보스 재생성까지 남은 시간을 보여주는 바를 표시합니다."
