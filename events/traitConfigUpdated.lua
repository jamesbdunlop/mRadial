--UNIT_SPELLCAST_SUCCEEDED
function mRadial:SPELLS_CHANGED(self, ...)
    MR_SPELL_CACHE = {}
    -- print("Player spells changed, updating mRadial spells now...")
    -- print("Building active and secondary now")
    mRadial:UpdateActivePrimarySpells()
    mRadial:UpdateActiveSecondarySpells()
    MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", true)
    MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", true)
    -- print("InitUI")
    mRadial:InitUI(true)
    -- print("Set pet frames.")
    mRadial:SetPetFramePosAndSize()
    mRadial:BuildPrimarySpellOrder(false)
    mRadial:BuildSecondarySpellOrder(false)
    -- print("Updating active and secondary now")
    mRadial:UpdateUI(true)
end

mRadial:RegisterEvent("SPELLS_CHANGED")
