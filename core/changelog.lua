MRADIAL_ABOUT  = "Welcome to mRadial a little UI for tracking spell timers etc.  \
\n You have a Primary and a Secondary radial frame to assign spells to watch to. These can be set to be clickable buttons as well if so desired. \
\n Why did I write this? Well I like to keep my focus on my character as much as possible and this addon helps keep the most important spells I want to track in  \
a nice tight circle around the charcter (so I don't stand in fire mkay!)  \
\n For more info please visit the wiki from the curseForge addon here:  \
\n https://github.com/jamesbdunlop/mRadial/wiki \n"

MRADIAL_UPDATENOTES = " \
-- v0.4.01 --\n \
This overhauls the options pane to use the Ace3ConfigTables. Wiki not yet updated to reflect these changes! \
\nA few things of note here: \
\nIf you find the spell icons have gone a bit crazy, this is most likely due to the autoSpread being turned ON by default now. The autospread option tries to make adding/removing spell watchers \
less problematic, so you don't have to always adjust the spread when adding a new spell. So set any dimensions back to their defaults, and work from there.\
\n- Primary / Secondary spell orders are now in their own frame (to avoid issues with the ActionSlot frame type) that can be opened using the buttons in the spell selection tab. \
\n \
\n -- IMPROVEMENTS \
\n - Well the entire options pane for starters. \
\n - Warlock specific options are now broken out to their own tab. \
\n - Primary and Secondary radials are now able to be moved independently of each other. \
\n - Spell selections in primary should correctly remove these from secondary selection as was originally intended. \
\n - Linked spells no longer use the actionSlot widget as this doesn't play nice with the config and requires butchering base Ace3 code to get to work. Not advisable. Check the pane for more info. \
\n \
\n -- KNOWN ISSUES: \
\n- If you reload UI when in config mode. The next time you open the options the checkbox for the configMode will most likely be ticked. Just toggled it again to turn the mode back on. \
\n- The WINDOW has changed to the base ace3 Frame. This frame annoys the crap out of me in respect to trying to shift+click move it out the way so I can move the radial stuff around, it's hit and miss \
if it's going to start moving or not, but due to some nasty bugs in the Window frame I'm leaving it as is for now. \
\n - Some of the default values don't apply in the options on first load. Need to start testing this. For now I have added info into the tooltips \
\n \
\n -- TO DO: \
\n - Get the reset all spells working again for the primary and secondary spell selections! \
"