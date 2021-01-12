local L = BigWigsAPI:NewLocale("BigWigs: Common", "zhCN")
if not L then return end

L.add = "增援"
L.add_killed = "小怪已击杀（%d/%d）"
L.add_remaining = "小怪已击杀，%d剩余"
L.adds = "增援"
L.add_spawned = "小怪刷新"
L.cast = "<施放：%s>"
L.casting = "正在施放%s"
L.count = "%s（%d）"
L.count_icon = "%s（%d|T13700%d:0|t）"
L.count_rticon = "%s（%d{rt%d}）"
L.custom_end = "%s - %s"
L.custom_min = "%2$d分后%1$s"
L.custom_sec = "%2$d秒后%1$s"
L.custom_start = "%1$s激活 - %3$d分后%2$s"
L.custom_start_s = "%1$s激活 - %3$d秒后%2$s"
L.duration = "%s持续%s秒"
L.focus_only = "|cffff0000只警报焦点目标。|r "
L.general = "通用" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.heroic = "英雄模式"
L.incoming = "即将%s"
L.intermission = "阶段转换"
L.interrupted = "%s已打断"
L.interrupted_by = "%2$s已打断%1$s" -- spell interrupted by player
L.mob_killed = "%s已击杀（%d/%d）"
L.mob_remaining = "%s已击杀，%d剩余"
L.mythic = "史诗模式"
L.near = "%s在你附近"
L.next_add = "下一波小怪"
L.no = "缺少%s"
L.normal = "普通模式"
L.on = "%2$s %1$s"
L.onboss = "首领%s"
L.buff_boss = "首领增益：%s"
L.buff_other = "首领增益%s：%s"
L.other = "%s：%s"
L.over = "%s结束"
L.percent = "%d%% - %s" -- 20% - spell
L.phase = "阶段%d"
L.removed = "%s移除"
L.removed_from = "%2$s已移除%1$s"
L.removed_by = "%s被%s移除" -- spell removed by player
L.soon = "即将%s"
L.spawned = "%s重生"
L.spawning = "%s出现"
L.stack = "%3$s %1$d层%2$s"
L.stackyou = "你%d层%s"
L.stage = "阶段%d"
L.trash = "小怪"
L.underyou = "你脚下：%s"
L.you = "你 %s"
L.you_icon = "|T13700%2$d:0|t你 %1$s"
L.on_group = "队伍 %s" -- spell on group

L.big_add = "大型增援" -- singular
L.big_adds = "大型增援" -- plural
L.small_add = "小型增援" -- singular
L.small_adds = "小型增援" -- plural

L.active = "激活" -- When a boss becomes active, after speech finishes

-- Common raid marking locale
L.marker = "%s标记"
L.marker_player_desc = "标记受到%s影响的玩家为%s，需要权限。"
L.marker_npc_desc = "标记%s为%s，需要权限。"

-- Ability where two players have to move close to each other
L.link = "连接"
L.link_with = "与%s连接"
L.link_short = "连接：%s"
L.link_both = "%s和%s连接"
L.link_removed = "连接已移除"

-- Abbreviated numbers
L.amount_one = "%.2f亿" -- Billions 1,000,000,000
L.amount_two = "%.1f万" -- Millions 1,000,000
L.amount_three = "%d千" -- Thousands 1,000
L.seconds = "%.1f秒" -- 1.1 seconds

-- Common ability name replacements
L.laser = "激光" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.bomb = "炸弹" -- Used for debuffs that make players explode
L.fixate = "锁定" -- Used when a boss or add is chasing/fixated on a player
