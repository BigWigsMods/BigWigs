local L = BigWigsAPI:NewLocale("BigWigs: Common", "zhTW")
if not L then return end

-- Prototype.lua common words
L.you = "你：%s"
L.you_icon = "|T13700%2$d:0|t你：%1$s"
L.underyou = "你腳下：%s"
L.other = "%s：%s"
L.onboss = "首領%s"
L.buff_boss = "首領增益：%s"
L.buff_other = "首領增益%s：%s"
L.on = "%s：%s"
L.stack = "%3$s：%1$d層%2$s"
L.stackyou = "你：%d層%s"
L.cast = "<施放：%s>"
L.casting = "正在施放：%s"
L.soon = "即將：%s"
L.count = "%s（%d）"
L.count_icon = "%s（%d|T13700%d:0|t）"
L.count_rticon = "%s（%d{rt%d}）"
L.rticon = "%s（{rt%d}）"
L.near = "%s在你附近"
L.on_group = "團隊：%s" -- spell on group

L.phase = "階段%d"
L.stage = "階段%d"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.mythic = "傳奇難度"
L.active = "開戰" -- When a boss becomes active, after speech finishes
L.general = "通用" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s持續%s秒" -- Spell for 10 seconds
L.over = "%s結束" -- Spell Over
L.removed = "%s移除" -- Spell Removed
L.removed_from = "%2$s已移除%1$s" -- Spell removed from Player
L.removed_by = "%s被%s移除" -- Spell removed by Player
L.incoming = "即將：%s" -- Spell Incoming
L.interrupted = "%s已打斷" -- Spell Interrupted
L.interrupted_by = "%2$s已打斷%1$s" -- Spell interrupted by Player
L.no = "缺少%s" -- No Spell
L.intermission = "階段轉換"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s取消" -- Spell Cancelled

-- Add related
L.add_spawned = "小怪出現"
L.spawned = "%s已重生"
L.spawning = "%s出現"
L.next_add = "下一波小怪"
L.add_killed = "小怪已擊殺（%d/%d）"
L.add_remaining = "小怪已擊殺，剩餘 %d"
L.add = "增援"
L.adds = "增援"
L.big_add = "大型增援" -- singular
L.big_adds = "大型增援" -- plural
L.small_add = "小型增援" -- singular
L.small_adds = "小型增援" -- plural

-- Mob related
L.mob_killed = "%s已擊殺（%d/%d）"
L.mob_remaining = "%s已擊殺，剩餘 %d"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s參戰 - %3$d分後%2$s"
L.custom_start_s = "%1$s參戰 - %3$d秒後%2$s"
L.custom_end = "%s - %s"
L.custom_min = "%2$d分後%1$s"
L.custom_sec = "%2$d秒後%1$s"

L.focus_only = "|cffff0000只限專注目標。|r "
L.trash = "小怪"

-- Common raid marking locale
L.marker = "%s標記"
L.marker_player_desc = "標記受到%s影響的玩家為%s，需要權限。"
L.marker_npc_desc = "標記%s為%s，需要權限。"

-- Ability where two players have to move close to each other
L.link = "連結"
L.link_with = "與%s連結"
L.link_with_icon = "與|T13700%d:0|t%s連結"
L.link_short = "連結：%s"
L.link_both = "%s和%s連結"
L.link_removed = "連結移除"

-- Abbreviated numbers
L.amount_one = "%.2f億" -- Billions 1,000,000,000
L.amount_two = "%.1f萬" -- Millions 1,000,000
L.amount_three = "%d千" -- Thousands 1,000
L.seconds = "%.1f秒" -- 1.1 seconds

-- Common ability name replacements
L.laser = "雷射" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.beam = "射線" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "射線" -- Plural of L.beam
L.bomb = "炸彈" -- Used for debuffs that make players explode
L.bombs = "炸彈" -- Plural of L.bomb
L.explosion = "爆炸" -- When the explosion from a bomb-like ability will occur
L.fixate = "鎖定" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "擊退" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.traps = "陷阱" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "隕石" -- This one will probably only ever be used for actual meteors
L.shield = "護盾" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "傳送" -- A boss/add/etc teleported somewhere
L.fear = "恐懼" -- For abilities that cause you to flee in fear
