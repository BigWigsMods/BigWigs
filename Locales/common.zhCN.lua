local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common", "zhCN")

if not L then return end

-- Prototype.lua common words
L.you = ">你< %s！"
L.other = "%s：>%s<！"
L.say = ">我< %s！"

L.phase = "阶段%d"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.hard = "困难模式"
L.general = "通用" -- General settings, i.e. things that apply to both normal and hard mode.

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = ">%s<激活 - %s将在%d分后！"
L.custom_end = ">%s<将%s！"
L.custom_min = ">%s<分后%d！"
L.custom_sec = ">%s<秒后%d！"
