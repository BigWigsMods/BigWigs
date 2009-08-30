local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs", "koKR")

if not L then return end

-- Core.lua

L["%s has been defeated"] = "%s 물리침"     -- "<boss> has been defeated"
L["%s have been defeated"] = "%s 물리침"    -- "<bosses> have been defeated"

L["Bosses"] = "보스"
L["Options for bosses in %s."] = "%s에 보스들을 위한 옵션입니다." -- "Options for bosses in <zone>"
L["Options for %s (r%d)."] = "%s에 대한 옵션입니다 (r%d)."     -- "Options for <boss> (<revision>)"
L["Plugins"] = "플러그인"
L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Big Wigs의 주요 기능을 다루는 플러그인 입니다. - 메세지 및 타이머 바 표시 기능, 기타 주요 기능 등."
L["Extras"] = "기타"
L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Big Wigs가 제대로 작동할 수 있도록 하는 플러그인입니다."
L["Active"] = "활성화"
L["Activate or deactivate this module."] = "해당 모듈을 활성화/비활성화 합니다."
L["Reboot"] = "재시작"
L["Reboot this module."] = "해당 모듈을 재시작합니다."
L["Options"] = "옵션"
L["Minimap icon"] = "미니맵 아이콘"
L["Toggle show/hide of the minimap icon."] = "미니맵 아이콘을 표시/숨김으로 전환합니다."
L["Advanced"] = "고급"
L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "경보, 아이콘, 차단에 대한 고급 설정입니다. 정말로 필요하지 않은 이상 건들지 않는 것이 좋습니다."

L.bosskill = "보스 사망"
L.bosskill_desc = "보스를 물리쳤을 때 알림니다."
L.enrage = "격노"
L.enrage_desc = "보스가 격노 상태로 변경 시 경고합니다."
L.berserk = "광폭화"
L.berserk_desc = "보스가 언제 광폭화가 되는지 경고합니다."

L["Load"] = "불러오기"
L["Load All"] = "모두 불러오기"
L["Load all %s modules."] = "모든 %s 모듈들을 불러옵니다."

L.already_registered = "|cffff0000경고:|r |cff00ff00%s|r (|cffffff00%d|r) 이미 Big Wigs 에서 보스 모듈로 존재하지만, 다시 등록이 필요합니다 (revision에 |cffffff00%d|r). 이 것은 일반적으로 애드온 업데이트 실패로 인하여 이 모듈이 당신의 애드온 폴더에 두개의 사본이 있는 것을 뜻합니다. 당신이 가지고 있는 Big Wigs 폴더의 삭제와 재설치를 권장합니다."


-- Options.lua
L["|cff00ff00Module running|r"] = "|cff00ff00모듈 실행중|r"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55f클릭|r : 모두 초기화 |cffeda55f알트-클릭|r 비활성화 |cffeda55f컨트롤-알트-클릭|r : BigWigs 비활성화."
L["Active boss modules:"] = "사용중인 보스 모듈:"
L["All running modules have been reset."] = "모든 실행중인 모듈을 초기화합니다."
L["Menu"] = "메뉴"
L["Menu options."] = "메뉴 설정."

-- Prototype.lua common words
L.you = "%s on YOU"
L.other = "%1$s on %2$s"

L.enrage_start = "%s 전투 개시 - %d분 후 격노"
L.enrage_end = "%s 격노"
L.enrage_min = "%d분 후 격노"
L.enrage_sec = "%d초 후 격노"
L.enrage = "격노"

L.berserk_start = "%s 전투 개시 - %d분 후 광폭화"
L.berserk_end = "%s 광폭화"
L.berserk_min = "%d분 후 광폭화"
L.berserk = "광폭화"
