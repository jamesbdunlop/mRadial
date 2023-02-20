
function mWarlock:UNIT_PET(eventName, arg1, arg2, arg3)
    mWarlock:createPetFrames()
    MWPetGUID = UnitGUID("pet")
end

mWarlock:RegisterEvent("UNIT_PET")
