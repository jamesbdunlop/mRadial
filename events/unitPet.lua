
function mRadial:UNIT_PET(eventName, arg1, arg2, arg3)
    -- print("eventName: %s", eventName)
    -- print("arg1: %s", arg1)
    -- print("arg2: %s", arg2)
    -- print("arg3: %s", arg3)
    if arg1 ~= "player" then
        return
    end

    MWPetGUID = UnitGUID("pet")
    if MWPetGUID == nil then
        for idx, frame in pairs(MR_ALLFRAMES) do
            if frame.isPetFrame then
                frame:Hide()
            end
        end
    else
        for idx, frame in pairs(MR_ALLFRAMES) do
            if frame.isPetFrame then
                frame:Show()
            end
        end
    end
end

mRadial:RegisterEvent("UNIT_PET")
