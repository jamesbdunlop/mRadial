
function mRadial:UNIT_PET(_, arg1)
    if arg1 ~= "player" then
        return
    end
    MWPetGUID = UnitGUID("pet")
    if MWPetGUID == nil then
        mRadial:HideAllPetFrames()
    else
        mRadial:HideAllPetFrames()
        mRadial:CreatePetFrames()
        mRadial:SetPetFramePosAndSize()
    end
end

mRadial:RegisterEvent("UNIT_PET")
