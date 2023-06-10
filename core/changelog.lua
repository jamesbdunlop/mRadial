MRADIAL_ABOUT  = "Welcome to mRadial a little UI for tracking spell timers etc.  \
\nYou have a Primary and a Secondary radial frame to assign spells to watch to. These can be set to be clickable buttons as well if so desired. \
\nWhy did I write this? Well I like to keep my focus on my character as much as possible and this addon helps keep the most important spells I want to track in  \
a nice tight circle around the charcter (so I don't stand in fire mkay!)  \
\nFor more info please visit the wiki via curseForge.  \
\n \n"

MRADIAL_UPDATENOTES = " \
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
