
function mRadial:UNIT_PET(e, arg1)
    if arg1 ~= "player" then
        return
    end
    
    -- Cache new petGUI
    mRadial:CreatePetFrames()
    if not InCombatLockdown() then
        mRadial:SetPetFramePosAndSize()
    end
end

mRadial:RegisterEvent("UNIT_PET")
