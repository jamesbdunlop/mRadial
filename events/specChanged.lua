function mWarlock:PLAYER_SPECIALIZATION_CHANGED(eventName, ...)
    -- print("-----------PLAYER SPEC CHANGED!")
    for x = 1, #MW_WatcherFrames do
        local frame = MW_WatcherFrames[x]
        -- print("Removing: %s", frame:GetName())
        
        local frameName = frame:GetName()
        for index, frame in ipairs(MW_ALLFRAMES) do
            if frameName == frame:GetName() then
                MW_ALLFRAMES.remove(index)
            end
        end
        frame:Hide()
        frame:SetParent(nil)
    end

    MWarlockSavedVariables = mWarlock:CreatePlayerSavedVars()
    mWarlock:INITUI()
end
mWarlock:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    