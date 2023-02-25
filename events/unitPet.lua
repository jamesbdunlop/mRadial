
function mWarlock:UNIT_PET(eventName, arg1, arg2, arg3)
    -- print("eventName: %s", eventName)
    -- print("arg1: %s", arg1)
    -- print("arg2: %s", arg2)
    -- print("arg3: %s", arg3)
    if arg1 ~= "player" then
        return
    end
    mWarlock:createPetFrames()
    MWPetGUID = UnitGUID("pet")
end

mWarlock:RegisterEvent("UNIT_PET")
