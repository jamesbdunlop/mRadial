
function mRadial:UNIT_PET(e, arg1)
    if arg1 ~= "player" then
        return
    end
    
    -- Cache new petGUI
    mRadial:CreatePetFrames()
    if not InCombatLockdown() then
        mRadial:SetPetFramePosAndSize()
    end

    MR_PET_ABILITIES = mRadial:GetPetAbilities()
end

mRadial:RegisterEvent("UNIT_PET")
