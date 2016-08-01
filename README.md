# Big Wigs Bossmods

## Introduction

**Big Wigs** is a boss encounter add-on. It consists of many individual _encounter scripts_, or _boss modules_; mini add-ons that are designed to trigger alert messages, timer bars, sounds, and so forth, for one specific raid encounter.

Looking for functionality that Big Wigs doesn't cover? Try these addons:
* [Little Wigs](https://mods.curse.com/addons/wow/little-wigs) is a plugin for Big Wigs and covers all forms of 5 man and solo content.
* [Capping](https://mods.curse.com/addons/wow/capping-bg-timers) covers various battleground and world PvP timers.
* [oRA3](https://mods.curse.com/addons/wow/ora3) covers all sorts of raid management functionality including raid cooldowns and Battle Res counting.
* Old content can be installed by [doing a search for BigWigs](https://mods.curse.com/search?search=bigwigs&submit-search=Submit) on Curse and installing the appropriate expansion addon.


## Help us out

### Feedback
Please remember that we are always interested in hearing directly from you. About anything you want to share or ask. You may [file tickets from our project page](https://github.com/BigWigsMods/BigWigs/issues) about anything, and you may also contact us on IRC; see the bottom here for details.

### Open
Note that the Big Wigs project - like 99% of all add-ons hosted on [wowace.com](https://www.wowace.com/) - is open for free access to anyone who cares to join. The source code is open and free, and we welcome you to participate in the future development of Big Wigs.


## Features

### Plug-ins
* Messages: Can be moved, coloured, locked, outputted to all kinds of different text areas.
* Bars: Can be moved, skinned to different textures (SharedMedia compatible), resized & also have an 'emphasis' feature to flash and move to a different anchor when they are about to expire.
* Raid icons: Target painting (put an icon over a player that has been singled out by the boss).
* Boss Block: Suppress Blizzard boss emotes.
* Sound: Plays various sounds on different events (SharedMedia compatible).
* LibDataBroker/Minimap: Button for easy access to the configuration menu, resetting running modules, and seeing what modules are active.

### Extras
* Proximity: For displaying players within a certain range on certain boss encounters.
* Test: Test and preview your bars and warnings configuration, and move them around.
* CustomBar: For 'pizza timers', create your own custom bars.
* Flash: Flash the screen blue when something important happens that directly affects you, such as a debuff.
* Clickable bars: Lets you define left/middle/right click actions for your timer bars.
* Super Emphasise: Any encounter ability you want to be extra vigilant of, you can enable Super Emphasise to get a voiced countdown and more.


## Ancient project history

Tekkub, the original BigWigs1 for Ace1 author - back in the MC days, was inspired to write BW1 after his very first raid. He was horrified by the massive amount of spam his raid leader was creating with his boss mod. Getting messages all over the place for things he didn't care about (Hunters can't dispel a curse or interrupt a heal - well, they couldn't back then). He also found that the "60 seconds until painful doom" timer messages were such a waste. Why not use a simple timer bar to show this?

## Our goals

Big Wigs aims to be as efficient as possible (creating a lower memory per second footprint and using a lower amount of CPU than any other boss mod). When modules are written, every aspect of the encounter is inspected. Is add-on synchronisation required? Is target scanning required? What events are really needed? We also aim to have the latest encounter scripts released ASAP; not long after the first few attempts of a brand new boss, we usually have a working encounter script for it.

## Credits

Thanks to all the wonderful people in #bigwigs on irc.freenode.net for help with transcripts, translations, libraries, etc. Visit the About screen in the Big Wigs interface options for a complete list of all authors who helped directly with source changes.

If you want to contact us on IRC, remember that all the main Big Wigs authors live in Europe, and the nature of IRC means you might not get a response for as long as 10 - yes, TEN - hours. Just stick around and eventually, someone will answer.
