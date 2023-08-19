MRADIAL_KNOWNISSUES = " \
\n    - If you reload UI when in config mode. The next time you open the options the checkbox for the configMode will most likely be ticked. Just toggled it again to turn the mode back on. \
\n \
"

MRADIAL_UPDATENOTES = " \
---------- v0.6.12 --\n \
\n -- LIBS \
\n    - Updates libDBIcon. \
\n -- FIXES \
\n    - Hide secondary toggle. \
\n    - shardframe issues for InCombatLockdown() setPoint. \
\n    - Desaturates frames when conditions are not met such as Channel Demonfire with no immolate present etc. \
\n\n \
---------- v0.6.11 --\n \
\n -- FIXES \
\n    - Some mouse frame issues for InCombatLockdown() checks. \
\n\n \
---------- v0.6.10 --\n \
\n -- IMPROVEMENTS \
\n    - Changing talents in the same spec will update the UI watchers accordingly, so one doesn't have to reload UI. This won't fix spread/positions though. \
\n -- FIXES \
\n    - Pet frames requiring a reload when swapping pets. These should show hide now as expected. \
\n\n \
---------- v0.6.9 --\n \
\n -- FIXES \
\n    - Error when hiding the shard tracker frame in the shardtracker. \
\n\n \
---------- v0.6.8 --\n \
\n -- FIXES \
\n    - Mem leak in pet frames. \
\n\n \
---------- v0.6.6 --\n \
\n I have spent quite a bit of time trying to debug pets that die during combat, and looking to cast a different pet. \
\n I think this is entirely appropriate, but Blizz CreateFontString does not want to show the new timers for the new pet.\
\n I can't for the life of me find out how to fix this atm so for now, if your pet dies and you cast a DIFFERENT pet during combat don't expect timers to work. \
\n Existing pets should restore from existing cached frames that should have valid timers if they were summoned out of combat.\
\n -- IMPROVEMENTS \
\n    - Bit of an overhaul on the state switching for cooldowns/buffs etc. \
\n\n \
---------- v0.6.5 --\n \
\n -- FIXES \
\n    - Small bug when one doens't have 3 specs to itr through for flushing the savedVar. \
\n\n \
---------- v0.6.4 --\n \
\n-- IMPROVEMENTS \
\n    - Adds the dimensions / font transfers from another spec. Use this if you want to quickly line up fonts/colors/frame positions from a spec you spent some time tweaking.\
\n    - Adds a little imp counter frame for Warlock demo spec when specced out of Implosion.\
\n -- FIXES \
\n    - Pets can now swap in combat and the frames should swap with them. \
\n\n \
---------- v0.6.3 --\n \
\n    - Checks for frame validity before removal.\
\n\n \
---------- v0.6.2 --\n \
\n-- IMPROVEMENTS \
\n    - Noticed a HUGE bloat in the saved vars (especially for pet classes). I have tracked this down to the frame positions and a returned val from the API being huge tables. I've push in a fix that should see the memory usage and file size come down significantly.\
\n    The next time you log in and reload, this file should drop from anywhere around 8-10mb in size and mem usage back down to where I'd expect it to be.\
\n\n \
---------- v0.6.1 --\n \
\n-- IMPROVEMENTS \
\n    - More default option cleanup for first time user experience improvements.\
\n    - Adds option to warlock section to hide the out of shards frame. If in Config mode this won't be reflected as expected here just yet. Need to suss out some changes.\
\n -- FIXES \
\n    - More cooldown timer tweaking. I'm trying to avoid a bunch of GCD spam but also get these to clock out correctly. \
\n\n \
---------- v0.6.0 --\n \
\n-- IMPROVEMENTS \
\n    - Some Options cleanup. Added the reset to the spell selection. Note this requires a toggle of the view atm to update it.\
\n    - Step one of the transfer process started. This is for frame positions. Next step will be for transferring the dimension settings across specs.\
\n -- FIXES \
\n    - Some spells like immolate return a valid spellID etc but IsKnown(spellID) was returning false. I'm letting all pass along now and it's up to the user to select valid spells.\
\n    - Radial spells info on hover was incorrectly named descp rather than desc.\
\n    - Some more timer tweaking.\
\n    - Spell order description was missing from locales.\
\n    - Update lib to latest Ace3.\
\n    - Bug where power was showing initally for MANA types which I do not want to show.\
\n    - Specs moving the frames to the one location. Spec frame positions should now respect each spec as expected.\
\n\n \
---------- v0.5.7 --\n \
\n-- IMPROVEMENTS \
\n    - Adds a power text count for spells that are dependant on player power like shards or insanity etc. This can be turned off.\
\n -- FIXES \
\n    - Pet timers locking to a grey background.\
\n    - Pet frames not showing if you fly in like superman directly into combat (I mean who doesn't).\
\n\n \
---------- v0.5.6 --\n \
\n-- IMPROVEMENTS \
\n    - General Debuff stuff, still keeping an eye on this side of the gameplay.\
\n    - Moved the known issues into it's own area in the about so it's persistant.\
\n-- FIXES \
\n    - Default cooldown color being GREEN! It's now red.\
\n    - Devouring Plague should register it's quriky play style a bit better.\
\n\n \
---------- v0.5.5 --\n \
\n-- IMPROVEMENTS \
\n    - New Pet frames go to the left rather then the center of screen for easier click + move. \
\n    - Added a reset pet frames button incase you're getting the wonderful UI bug were the positions wig out. \
\n    - Added an input option to add the names of any pet ability frames you might want to ignore.\
\n-- FIXES \
\n    - VSCode unsaved file. Whoops! Fixes config for pet frame cd position. \
\n    - UnitPower + Spell on cooldown play. I removed a called to the debuff/cd timers to stop the greying out of the icons, which was a bad idea in hindsight. \
\n\n \
---------- v0.5.4 --\n \
\n-- IMPROVEMENTS \
\n    - Pet frame options for fonts etc. \
\n    - Red frame spells whose power is not enough to use. \
\n\n \
---------- v0.5.3 --\n \
\n Seems that the 5.2 picked up the deleted archive. I'm releasing this for the IsPriest error so that gets gone. \
\n-- IMPROVEMENTS \
\n    - Adds the pet abilities from the spell book for any class now. Have added a pet options into the config. More to come here...WIP \
\n\n \
---------- v0.5.2 --\n \
\n-- FIXES \
\n    -I broke unitPower trying to be clever with it! This should fix for all classes.\
\n\n \
---------- v0.5.1 --\n \
\n-- FIXES \
\n    -Dot timer updown typo in name preventing position to work. \
\n    -Pet frames not using the custom colors. \
\n\n \
---------- v0.5.0 --\n \
\n-- IMPROVEMENTS \
\n    - Added font colors to the options. \
\n    - Moves the font size over rides into each font area rather the on top, and lets these scale down fonts as well as up. \
\n    - Dot timers now have their own config for timer position/size in the UI. \
\n    - UnitPower should work across all classes as expect??? \
\n-- FIXES \
\n    - Linked timer box was still moving in and out based on position around circle. This is now static. \
\n    !!NOTE: This will require you to fix the Left/Right values in the options!! Sorry! :) \
\n\n \
---------- v0.4.13 --\n \
\n-- IMPROVEMENTS \
\n    - Dropped the s from the timers incase fonts make it look like a 5. \
\n    - Cleans out the out of shard frame texture if on a different class and in config mode. \
\n    - Debuff timers (dots in particular) should not cross talk with cooldowns now and the watchers should reflect their timers. \
\n    - Spells not avail now just so X rather than N/A \
\n    - Spell icons grey out cleaner now when on cooldown. \
\n-- FIXES \
\n    - Closing options pane with config mode on now turns off correctly. \
\n    - Hide out of combat bug fixed. \
\n    - CONST for Summon SoulKeeper and Shadow Fury spell names into locales. NFI if these actually work. \
\n-- KNOWN ISSUES \
\n    - DEBUFF timers share the timer size. I will look to split this out. \
\n    - Frame positions are shared across specs. \
\n\n \
---------- v0.4.12 --\n \
\n-- IMPROVEMENTS \
\n    - Added option for center icons to have their timers above or below. \
\n-- FIXES \
\n    - Options default value for linked timers to be +10 not -'ve. \
\n    - Options default value for cooldown to be center. \
\n    - Options default value for font % to be .25 and bigger RDY and Cooldown text defaults. \
\n    - Option Radius Mult had the wrong title. \
\n\n \
---------- v0.4.11 --\n \
\n-- FIXES \
\n    - Options default values now set in UI as expected for first time use. \
\n\n \
---------- v0.4.10 --\n \
\n-- IMPROVEMENTS \
\n    - Options now has a checkbox to turn off the secondary spells panel without requiring one to remove all spells from it. \
\n-- FIXES \
\n    - Options text for General text which was previously not translated.do \
\n    - Warlock pet frames now using locale spellNames. (Gleaned these from chatGPT so they could be wrong.) \
\n\n \
---------- v0.4.9 --\n \
\n-- IMPROVEMENTS \
\n    - Options now updates correctly with spec changes. \
\n-- FIXES \
\n    - Bug in passive spells showing wrong table entries. \
\n\n \
---------- v0.4.8 --\n \
\n-- IMPROVEMENTS \
\n    - Adds locales to the addon. English / German / Spanish / SpanishMX. Translation via chatGPT so.... \
\n-- FIXES \
\n    - Linked spells empty table issues for new chars. \
\n\n \
---------- v0.4.7 --\n \
\n-- FIXES \
\n    - Spec swap changes being blocked by InCombatLockdown. Clearly I don't change specs often on my lock so this took a while to detect. \
\n\n \
---------- v0.4.6 --\n \
\n-- FIXES \
\n    - Missing default font. \
\n\n \
---------- v0.4.5 --\n \
\n-- IMPROVEMENTS \
\n    - Fonts now use the Shared Media Lib. \
\n-- FIXES \
\n    - Lower level characters won't be presented with spells they don't yet know for selecting. \
\n\n \
---------- v0.4.4 --\n \
\n-- CHANGES \
\n    - Removed the welcome message from chat frame. \
\n-- FIXES \
\n    - Missing title to move the options frame with. Note: this vanishes after using a checkbox etc. Very Annoying. But I have butchered the move frame so it appears again. \
\n    - The entire options frame can be moved with left click now. I really don't like this whole Ace3 move by title only, and then the title doesn't set properly pita. \
\n\n \
---------- v0.4.3 --\n \
\nHiding the reset for spell selection buttons for now. \
\n-- FIXES \
\n    - Pet frames no longer create multiples of. \
\n    - Pet frames on cooldown no longer solid red color. \
\n\n \
---------- v0.4.1 (and .2)--\n \
This overhauls the options pane to use the Ace3ConfigTables. Wiki not yet updated to reflect these changes! \
\n!!THIS IS A BIG OPTIONS UPDATE!! EXISTING OPTIONS SHOULD STILL WORK! How ever a few things of note here: \
\nIf you find the spell icons have gone a bit crazy, this is most likely due to the autoSpread being turned ON by default now. The autospread option tries to make adding/removing spell watchers \
less problematic, so you don't have to always adjust the spread etc when adding a new spell or changing radius etc. TO FIX ANY ISSUES: Set any dimensions back to their defaults, and work from there.\
\n \
\n-- IMPROVEMENTS \
\n    - Well the entire options pane for starters. \
\n    - Primary / Secondary spell orders are now in their own frame (to avoid issues with the ActionSlot frame type) that can be opened using the buttons in the spell selection tab. \
\n    - Warlock specific options are now broken out to their own tab. \
\n    - Primary and Secondary radials are now able to be moved independently of each other. \
\n    - Spell selections in primary should correctly remove these from secondary selection as was originally intended. \
\n    - Linked spells no longer use the actionSlot widget as this doesn't play nice with the config and requires butchering base Ace3 code to get to work. Not advisable. Check the pane for more info. \
\n \
"
