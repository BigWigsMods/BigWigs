local L = BigWigs:NewBossLocale("Argus the Unmaker", "koKR")
if not L then return end
if L then
	L.combinedBurstAndBomb = "영혼분출 영혼폭탄 전투 메세지 통합"
	L.combinedBurstAndBomb_desc = "|cff71d5ff영혼폭탄|r 은 항상 |cff71d5ff영혼분출|r 과 동시에 걸립니다. 이 옵션을 활성화하면 두개의 전투 메세지를 하나로 통합할 수 있습니다."

	L.custom_off_always_show_combined = "영혼분출과 영혼폭탄이 같이 올때 항상 통합 메세지로 표시"
	L.custom_off_always_show_combined_desc = "통합 전투 메세지는 플레이어가 |cff71d5ff영혼폭탄|r 이나 |cff71d5ff영혼분출|r 이 걸렸을때는 표시되지 않습니다. 이 옵션을 활성화하면 영혼폭탄이나 영혼분출과 무관하게 전투 메세지를 표시할 수 있습니다. |cff33ff99공격대장에게 유용한 .|r"

	L.fear_help = "살게라스의 공포 관련 경보"
	L.fear_help_desc = "다음의 기술과 함께 걸렸을 때 특수 전투 메제시 전송: |cff71d5ff살게라스의 공포|r and |cff71d5ff영혼역병|r/|cff71d5ff영혼분출|r/|cff71d5ff영혼폭탄|r/|cff71d5ff살게라스의 선고|r."

	L[257931] = "공포" -- short for Sargeras' Fear
	L[248396] = "역병" -- short for Soulblight
	L[251570] = "폭탄" -- short for Soulbomb
	L[250669] = "분출" -- short for Soulburst
	L[257966] = "선고" -- short for Sentence of Sargeras

	L.stage2_early = "바다의 분노가 타락을 씻어 내리라"
	L.stage3_early = "희망은 없다. 오로지 고통, 고통뿐!"

	L.gifts = "선물: %s (하늘), %s (바다)"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|t분출:%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|t폭탄 (%d):|T137002:0|t%s - " -- short for Soulbomb

	L.sky_say = "{rt5} 치명/특화" -- short for Critical Strike/Mastery (stats)
	L.sea_say = "{rt6} 가속/유연" -- short for Haste/Versatility (stats)

	L.bomb_explosions = "폭탄 폭발"
	L.bomb_explosions_desc = "영혼분출과 영혼폭탄 터질 때까지 타이머 표시."
end

L = BigWigs:NewBossLocale("Aggramar", "koKR")
if L then
	L.wave_cleared = "불씨 %d 번 웨이브 완료!" -- Wave 1 Cleared!

	L.track_ember = "테샤라크의 불씨 상태 확인"
	L.track_ember_desc = "테샤라크의 불씨가 죽을때 마다 전투 메세지 표시."

	L.custom_off_ember_marker_desc = "테샤라크의 불씨에 {rt1}{rt2}{rt3}{rt4}{rt5} 징표 부여, 공격대장이나 부공격대장 권한 필요.\n|cff33ff99신화 난이도: 현재 웨이브에서 기력 45 이상인 불씨만 징표가 찍힙니다.|r"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "koKR")
if L then
	L.torment_of_the_titans_desc = "쉬바라는 티탄의 영혼들을 굴복시켜 집회의 적에게 능력을 사용하게 합니다."

	L.timeLeft = "%.1fs" -- s = seconds
	L.torment = "티탄의 고통: %s"
	L.nextTorment = "다음 고통: |cffffffff%s|r"
	L.tormentHeal = "아만툴!" -- something like Heal/DoT (max 10 characters)
	L.tormentLightning = "골가네스!" -- short for "Chain Lightning" (or similar, max 10 characters)
	L.tormentArmy = "노르간논!" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	L.tormentFlames = "카즈고로스!" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "koKR")
if L then
	L.warp_in_desc = "각 무리(특수 쫄 포함)가 소환되는 타이머와 전투 메세지 표시."

	L.top_lane = "상층"
	L.mid_lane = "중층"
	L.bot_lane = "하층"

	L.purifier = "정화자" -- Fel-Powered Purifier
	L.destructor = "파괴자" -- Fel-Infused Destructor
	L.obfuscator = "혼란자" -- Fel-Charged Obfuscator
	L.bats = "지옥 박쥐"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "koKR")
if L then
	L.custom_on_stop_timers = "보스 기술 바 항상 표시"
	L.custom_on_stop_timers_desc = "하사벨은 쿨타임이 돌아온 스킬을 무작위로 시전합니다. 이 옵션을 활성화하면, 쿨타임이 돌아온 스킬들의 바가 화면에 남아있습니다."
	L.custom_on_filter_platforms = "특수 단상 경보 및 바 필터"
	L.custom_on_filter_platforms_desc = "특수 단상에 올라가있지 않을 경우 불필요한 전투 메세지나 바 제거. 단상: 집결지의 바와 경보는 항상 표시됩니다."
	L.worldExplosion_desc = "붕괴하는 세계 타이머 표시."
	L.platform_active = "%s 활성화!" -- Platform: Xoroth Active!
	L.add_killed = "%s 처치!"
	L.achiev = "'포탈 컴뱃' achievement debuffs" -- Achievement 11928
end

L = BigWigs:NewBossLocale("Kin'garoth", "koKR")
if L then
	L.empowered = "(강화된) %s" -- (E) Ruiner
	L.gains = "킨가로스가  %s 능력 획득" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "koKR")
if L then
	L.felshieldActivated = "지옥방어막 생성기 %s 가 클릭!"
	L.felshieldUp = "지옥방어막 활성"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "koKR")
if L then
	L.cannon_ability_desc = "가로시 세계파괴자의 등에 부착된 2개의 대포의 기술에 관한 전투 메세지 및 바 표시."

	L.missileImpact = "파멸 폭발"
	L.missileImpact_desc = "파멸 미사일 타이머 표시."

	L.decimationImpact = "학살 폭발"
	L.decimationImpact_desc = "폭발 미사일 타이머 표시."
end

L = BigWigs:NewBossLocale("Antorus Trash", "koKR")
if L then
	-- [[ Before Garothi Worldbreaker ]] --
	L.felguard = "안토란 지옥수호병"

	-- [[ After Garothi Worldbreaker ]] --
	L.flameweaver = "화염술사"

	-- [[ Before Antoran High Command ]] --
	L.ravager = "칼날서약병 약탈자"
	L.deconix = "전제군주 데코닉스"
	L.clobex = "클로벡스"

	-- [[ Before Portal Keeper Hasabel ]] --
	L.stalker = "굶주린 추적자"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	L.tarneth = "타네스"
	L.priestess = "착란의 여사제"

	-- [[ Before Aggramar ]] --
	L.aedis = "암흑의 문지기 에이디스"
end
