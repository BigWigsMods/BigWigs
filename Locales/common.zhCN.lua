local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common", "zhCN")

if not L then return end

-- Prototype.lua common words
L.you = ">你< %s！"
L.other = "%s：>%s<！"

L.phase = "阶段%d"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.hard = "困难模式"
L.general = "通用" -- General settings, i.e. things that apply to both normal and hard mode.

L.berserk_start = "%s激活 - 将在%d分后狂暴！"
L.berserk_end = "%s已狂暴！"
L.berserk_min = "%d分后狂暴！"
L.berserk_sec = "%d秒后狂暴！"
L.berserk = "狂暴"
