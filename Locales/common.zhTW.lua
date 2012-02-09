local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common", "zhTW")

if not L then return end

-- Prototype.lua common words
L.you = ">你< %s！"
L.underyou = ">你<腳下：%s！"
L.other = "%s：>%s<！"
L.say = ">我< %s！"
L.cast = "<正在施放：%s>"
L.soon = "即將 >%s<！"

L.phase = "階段%d"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.hard = "困難模式"
L.general = "通用" -- General settings, i.e. things that apply to both normal and hard mode.

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = ">%s<參戰 - %s將在%d分後！"
L.custom_start_s = ">%s<參戰 - %s將在%d秒後！"
L.custom_end = ">%s<將%s！"
L.custom_min = ">%s<%d分後！"
L.custom_sec = ">%s<%d秒後！"
