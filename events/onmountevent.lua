-- Note that firing a gun or a spell, or getting aggro, does NOT trigger this event.
function mWarlock:PLAYER_MOUNT_DISPLAY_CHANGED(eventName, ...) 
    if IsMounted() then
        for _, frame in pairs(MW_ALLFRAMES) do
            frame:Hide()
        end
        for _, frame in pairs(MW_WatcherFrames) do
            frame:Hide()
        end      
    else
        for _, frame in pairs(MW_ALLFRAMES) do
            frame:Show()
        end      
        for _, frame in pairs(MW_WatcherFrames) do
            frame:Show()
        end
    end
end

mWarlock:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
