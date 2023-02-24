function mWarlock:COMPANION_UPDATE(eventName, arg1, arg2)
    -- print("eventName: %s", eventName)
    -- print("arg1: %s", arg1)
    -- print("arg2: %s", arg2)
    if arg1 == "MOUNT" then
        mWarlock:radialButtonLayout()
    end
end

mWarlock:RegisterEvent("COMPANION_UPDATE")
