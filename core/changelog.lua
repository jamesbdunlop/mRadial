MRADIAL_UPDATENOTES = " \
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
\n-- KNOWN ISSUES: \
\n    - If you reload UI when in config mode. The next time you open the options the checkbox for the configMode will most likely be ticked. Just toggled it again to turn the mode back on. \
\n    - The WINDOW has changed to the base ace3 Frame. This frame annoys the crap out of me in respect to trying to shift+click move it out the way so I can move the radial stuff around, it's hit and miss \
if it's going to start moving or not, but due to some nasty bugs in the Window frame I'm leaving it as is for now. \
\n    - Some of the default values don't apply in the options on first load. Need to start testing this. For now I have added info into the tooltips \
\n \
\n-- TO DO: \
\n    - Get the reset all spells working again for the primary and secondary spell selections! \
"
