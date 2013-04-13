local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common", "zhCN")
if not L then return end
-- Prototype.lua common words
L.you = ">你< %s！"
L.underyou = ">你<脚下：%s！"
L.other = "%s：>%s<"
L.onboss = "首领 >%s<！"
L.say = ">我< %s！"
L.on = "%2$s >%1$s<"
L.stack = "%3$s %1$d层>%2$s<"
L.cast = "<施放：%s>"
L.casting = "正在施放 >%s<！"
L.soon = "即将 >%s<！"
L.count = "%s（%d）"
L.near = ">%s< 你附近！"

L.phase = "阶段%d"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.hard = "困难模式"
L.general = "通用" -- General settings, i.e. things that apply to both normal and hard mode.

L.duration = ">%s< 持续%s秒"
L.over = ">%s< 结束！"
L.removed = ">%s<移除"
L.incoming = "即将>%s<！"
L.interrupted = ">%s< 已打断"

L.add_spawned = "小怪刷新！"
L.next_add = "下一波小怪"
L.add_killed = "小怪已击杀！（%d/%d）"
L.add_remaining = "小怪已击杀，%d剩余"

L.mob_killed = "%s已击杀！（%d/%d）"
L.mob_remaining = "%s已击杀，%d剩余"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s激活 - %3$d分后>%2$s<！"
L.custom_start_s = "%1$s激活 - %3$d秒后>%2$s<！"
L.custom_end = "%s - >%s<！"
L.custom_min = "%2$d分后>%1$s<！"
L.custom_sec = "%2$d秒后>%1$s<！"

