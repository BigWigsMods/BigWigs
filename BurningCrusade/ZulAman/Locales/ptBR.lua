local L = BigWigs:NewBossLocale("Zul'jin", "ptBR")
if not L then return end
if L then
	L[42594] = "Forma de Urso" -- short form for "Essence of the Bear"
	L[42607] = "Forma de Lince"
	L[42606] = "Forma de Águia"
	L[42608] = "Forma de Falcodrago"
end

L = BigWigs:NewBossLocale("Halazzi", "ptBR")
if L then
	L.spirit_message = "Fase Espiritual"
	L.normal_message = "Fase Normal"
end

L = BigWigs:NewBossLocale("Nalorakk", "ptBR")
if L then
	L.troll_message = "Forma de Troll"
	L.troll_trigger = "Abrir caminho para Nalorakk!"
	--L.bear_trigger = "You call on da beast, you gonna get more dan you bargain for!"
end
