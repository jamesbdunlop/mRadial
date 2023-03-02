-- Note that firing a gun or a spell, or getting aggro, does NOT trigger this event.
function mWarlock:PLAYER_ENTER_COMBAT(eventName, ...) 
    for _, frame in pairs(PetFrames) do
        frame:Show()
    end

    for _, frame in pairs(MW_ALLFRAMES) do
        frame:Show()
    end
end

mWarlock:RegisterEvent("PLAYER_ENTER_COMBAT")
