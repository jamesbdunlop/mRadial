
function mRadial:UNIT_PET(eventName, arg1, arg2, arg3)
    -- print("eventName: %s", eventName)
    -- print("arg1: %s", arg1)
    -- print("arg2: %s", arg2)
    -- print("arg3: %s", arg3)
    if arg1 ~= "player" then
        return
    end

    MWPetGUID = UnitGUID("pet")
    mRadial:RemoveAllPetFrames()
    mRadial:createPetFrames()
    if MWPetGUID == nil then
        for idx, frame in ipairs(MR_PETFAMES) do
            if frame.isPetFrame then
                frame:Hide()
            end
        end
    else
        mRadial:createPetFrames()
        for idx, frame in ipairs(MR_PETFAMES) do
            if frame.isPetFrame then
                frame:Show()
            end
        end
    end
end

mRadial:RegisterEvent("UNIT_PET")
