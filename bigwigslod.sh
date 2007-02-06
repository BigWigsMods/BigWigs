#/bin/bash

cd ..
rm -rf BigWigs_AQ20
rm -rf BigWigs_AQ40
rm -rf BigWigs_BWL
rm -rf BigWigs_MC
rm -rf BigWigs_ZG
rm -rf BigWigs_Naxxramas
rm -rf BigWigs_Karazhan
rm -rf BigWigs_Other
rm -rf BigWigs_Outland
rm -rf BigWigs_Extras
rm -rf BigWigs_Plugins

cd BigWigs

mv AQ20/AQ20.toc AQ20/BigWigs_AQ20.toc
mv AQ40/AQ40.toc AQ40/BigWigs_AQ40.toc
mv BWL/BWL.toc BWL/BigWigs_BWL.toc
mv MC/MC.toc MC/BigWigs_MC.toc
mv Naxxramas/Naxxramas.toc Naxxramas/BigWigs_Naxxramas.toc
mv Karazhan/Karazhan.toc Karazhan/BigWigs_Karazhan.toc
mv ZG/ZG.toc ZG/BigWigs_ZG.toc
mv Other/Other.toc Other/BigWigs_Other.toc
mv Outland/Outland.toc Outland/BigWigs_Outland.toc
mv Extras/Extras.toc Extras/BigWigs_Extras.toc
mv Plugins/Plugins.toc Plugins/BigWigs_Plugins.toc

mv AQ20 ../BigWigs_AQ20
mv AQ40 ../BigWigs_AQ40
mv BWL ../BigWigs_BWL
mv MC ../BigWigs_MC
mv Naxxramas ../BigWigs_Naxxramas
mv Karazhan ../BigWigs_Karazhan
mv ZG ../BigWigs_ZG
mv Other ../BigWigs_Other
mv Outland ../BigWigs_Outland
mv Extras ../BigWigs_Extras
mv Plugins ../BigWigs_Plugins
