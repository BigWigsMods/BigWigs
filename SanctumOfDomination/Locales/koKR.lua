local L = BigWigs:NewBossLocale("The Tarragrue", "koKR")
if not L then return end
if L then
	L.chains = "사슬" -- Chains of Eternity (Chains)
	L.remnants = "잔재" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "물리 잔재"
	L.magic_remnant = "마법 잔재"
	L.fire_remnant = "화염 잔재"
	L.fire = "화염"
	L.magic = "마법"
	L.physical = "물리"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "koKR")
if L then
	L.chains = "사슬" -- Short for Dragging Chains
	L.pool = "바닥 깔기" -- Spreading Misery
	L.pools = "바닥 깔기" -- Spreading Misery (multiple)
	L.death_gaze = "죽음의 시선" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "koKR")
if L then
	L.fragments = "파편" -- Short for Fragments of Destiny
	L.fragment = "파편" -- Singular Fragment of Destiny
	L.run_away = "카이라에서 멀어지기!" -- Wings of Rage
	L.song = "노래" -- Short for Song of Dissolution
	L.go_in = "시그니로 접근!" -- Reverberating Refrain
	L.valkyr = "발키르" -- Short for Call of the Val'kyr
	L.blades = "칼날" -- Agatha's Eternal Blade
	L.big_bombs = "쎈 폭탄" -- Daschla's Mighty Impact
	L.big_bomb = "쎈 폭탄" -- Attached to the countdown
	L.shield = "방패" -- Annhylde's Bright Aegis
	L.soaks = "바닥 맞기" -- Aradne's Falling Strike
	L.small_bombs = "약한 폭탄" -- Brynja's Mournful Dirge
	L.recall = "진언" -- Short for Word of Recall

	L.blades_yell = "Fall before my blade!"
	L.soaks_yell = "You are all outmatched!"
	L.shield_yell = "My shield never falters!"

	L.berserk_stage1 = "1페이즈 광폭화"
	L.berserk_stage2 = "2페이즈 광폭화"

	L.image_special = "%s [스키야]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "koKR")
if L then
	 L.cones = "바닥" -- Grasp of Malice
	 L.orbs = "보주" -- Orb of Torment
	 L.orb = "보주" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "koKR")
if L then
	 L.custom_off_nameplate_defiance = "저항 네임플레이트 아이콘"
	 L.custom_off_nameplate_defiance_desc = "나락살이의 네임플레이트에 저항 아이콘을 표시합니다.\n\n네임플레이트 애드온과 적 네임플레이트 활성화 필요(KuiNameplates, Plater)."

	 L.custom_off_nameplate_tormented = "고문 네임플레이트 아이콘"
	 L.custom_off_nameplate_tormented_desc = "나락살이의 네임플레이트에 고문 아이콘을 표시합니다.\n\n네임플레이트 애드온과 적 네임플레이트 활성화 필요 (KuiNameplates, Plater)."

	 L.cones = "바닥" -- Torment
	 L.dance = "바닥" -- Encore of Torment
	 L.brands = "낙인" -- Brand of Torment
	 L.brand = "낙인" -- Single Brand of Torment
	 L.spike = "쐐기" -- Short for Agonizing Spike
	 L.chains = "족쇄" -- Hellscream
	 L.chain = "수갑" -- Soul Manacles
	 L.souls = "영혼" -- Rendered Soul

	 L.chains_remaining = "족쇄 %d 개 남음"
	 L.all_broken = "족쇄 올 클리어"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "koKR")
if L then
	 L.hammer = "망치" -- Short for Rippling Hammer
	 L.axe = "도끼" -- Short for Cruciform Axe
	 L.scythe = "낫" -- Short for Dualblade Scythe
	 L.trap = "덫" -- Short for Flameclasp Trap
	 L.chains = "사슬" -- Short for Shadowsteel Chains
	 L.embers = "불씨" -- Short for Shadowsteel Embers
	--  L.adds_embers = "Embers (%d) - Adds Next!"
	--  L.adds_killed = "Adds killed in %.2fs"
	--  L.spikes = "Spiked Death" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "koKR")
if L then
	L.custom_on_stop_timers = "능력 바 항상 표시"
	L.custom_on_stop_timers_desc = "수호자의 능력이 미뤄질수 있습니다. 이 옵션을 킨다면, 그 능력들을 표시하는 바가 화면에 남아있습니다."

	-- L.bomb_missed = "%dx Bombs Missed"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "koKR")
if L then
	 L.rings = "굴레"
	 L.rings_active = "굴레 활성화" -- for when they activate/are movable
	 L.runes = "룬"

	 L.grimportent_countdown = "초읽기"
	 L.grimportent_countdown_desc = "음산한 징조에 걸린 플레이어들을 위한 초읽기"
	 L.grimportent_countdown_bartext = "룬으로 이동!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "koKR")
if L then
	 L.spikes = "쐐기" -- Short for Glacial Spikes
	 L.spike = "쐐기"
	 L.miasma = "독기" -- Short for Sinister Miasma

	 L.custom_on_nameplate_fixate = "시선집중 네임플레이트 아이콘"
	 L.custom_on_nameplate_fixate_desc = "헌신자의 네임플레이트에 시선집중 아이콘을 표시합니다.\n\n네임플레이트 애드온과 적 네임플레이트 활성화 필요(KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "koKR")
if L then
	 L.chains_active = "사슬 활성화"
	 L.chains_active_desc = "지배의 사슬이 활성화될때를 보여주는 바 표시"

	-- L.custom_on_nameplate_fixate = "시선집중 네임플레이트 아이콘"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Dark Sentinels that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	 L.chains = "사슬" -- Short for Domination Chains
	 L.chain = "사슬" -- Single Domination Chain
	 L.darkness = "장막" -- Short for Veil of Darkness
	 L.arrow = "화살" -- Short for Wailing Arrow
	 L.wave = "파도" -- Short for Haunting Wave
	 L.dread = "공포" -- Short for Crushing Dread
	 L.orbs = "보주" -- Dark Communion
	 L.curse = "저주" -- Short for Curse of Lethargy
	 L.pools = "파멸" -- Banshee's Bane
	 L.scream = "비명" -- Banshee Scream

	 L.knife_fling = "비수 조심!" -- "Death-touched blades fling out"
end

