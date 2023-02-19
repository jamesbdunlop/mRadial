
function mWarlock:UNIT_PET(eventName, arg1, arg2, arg3)
    mWarlock:createPetFrames()
end

mWarlock:RegisterEvent("UNIT_PET")
