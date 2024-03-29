function mRadial:PLAYER_SPECIALIZATION_CHANGED(self, event, ...)
    if event == "player" then
        MR_SPELL_CACHE = {}
        -- print("Player spec changed, updating mRadial spells now...")
        mRadial:HideAllWatcherFrames()
        MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", true)
        MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", true)
        mRadial:BuildPrimarySpellOrder(false)
        mRadial:BuildSecondarySpellOrder(false)
        mRadial:InitUI(true)
        mRadial:SetPetFramePosAndSize()
    end
end

mRadial:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
