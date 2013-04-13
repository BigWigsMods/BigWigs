local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common", "zhTW")
if not L then return end
-- Prototype.lua common words
L.you = ">你< %s！"
L.underyou = ">你<腳下：%s！"
L.other = "%s：>%s<！"
L.onboss = "首領 >%s<！"
L.say = ">我< %s！"
L.on = "%2$s >%1$s<"
L.stack = "%3$s %1$d層>%2$s<"
L.cast = "<施放：%s>"
L.casting = "正在施放 >%s<！"
L.soon = "即將 >%s<！"
L.count = "%s（%d）"
L.near = ">%s< 你附近！"

L.phase = "階段%d"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.hard = "困難模式"
L.general = "通用" -- General settings, i.e. things that apply to both normal and hard mode.

L.duration = ">%s< 持續%s秒"
L.over = ">%s< 結束！"
L.removed = ">%s<移除"
L.incoming = "即將>%s<！"
L.interrupted = ">%s< 已打斷"

L.add_spawned = "小怪刷新！"
L.next_add = "下一波小怪"
L.add_killed = "小怪已擊殺！（%d/%d）"
L.add_remaining = "小怪已擊殺，%d剩餘"

L.mob_killed = "%s已擊殺！（%d/%d）"
L.mob_remaining = "%s已擊殺，%d剩餘"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s參戰 - %3$d分後>%2$s<！"
L.custom_start_s = "%1$s參戰 - %3$d秒後>%2$s<！"
L.custom_end = "%s - >%s<！"
L.custom_min = "%2$d分後>%1$s<！"
L.custom_sec = "%2$d秒後>%1$s<！"

