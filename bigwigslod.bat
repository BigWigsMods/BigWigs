@echo off

cd ..
rmdir /s /q BigWigs_SC
rmdir /s /q BigWigs_Karazhan
rmdir /s /q BigWigs_Outland
rmdir /s /q BigWigs_Extras
rmdir /s /q BigWigs_Plugins
rmdir /s /q BigWigs_TheEye
rmdir /s /q BigWigs_BlackTemple
rmdir /s /q BigWigs_Hyjal
rmdir /s /q BigWigs_ZulAman
rmdir /s /q BigWigs_Sunwell

cd BigWigs

move Karazhan ..\BigWigs_Karazhan
move SC ..\BigWigs_SC
move Outland ..\BigWigs_Outland
move Extras ..\BigWigs_Extras
move Plugins ..\BigWigs_Plugins
move TheEye ..\BigWigs_TheEye
move BlackTemple ..\BigWigs_BlackTemple
move Hyjal ..\BigWigs_Hyjal
move ZulAman ..\BigWigs_ZulAman
move Sunwell ..\BigWigs_Sunwell

del /f modules.xml
