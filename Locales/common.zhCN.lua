local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common", "zhCN")
if not L then return end
-- Prototype.lua common words
L.you = ">你< %s！"
L.underyou = ">你<脚下：%s！"
L.other = "%s：>%s<"
L.onboss = ">首领< %s！"
L.say = ">我< %s！"
L.on = ">%s< %s"
L.stack = "%d层%s >%s<"
L.cast = "<正在施放：%s>"
L.soon = "即将 >%s<！"
L.count = "%s（%d）"
L.near = ">%s< 你附近！"

L.phase = "阶段%d"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.hard = "困难模式"
L.general = "通用" -- General settings, i.e. things that apply to both normal and hard mode.

L.duration = ">%s< %s秒"
L.over = "%s 结束！"
L.removed = "%s移除"
L.incoming = "即将%s！"
L.interrupted = "%s Interrupted"

L.add_spawned = "小怪刷新!"
L.next_add = "下一波小怪"
L.add_killed = "小怪已击杀！（%d/%d）"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = ">%s<激活 - %s将在%d分后！"
L.custom_start_s = ">%s<激活 - %s将在%d秒后！"
L.custom_end = ">%s<将%s！"
L.custom_min = ">%s<%d分后！"
L.custom_sec = ">%s<%d秒后！"

