function mRadial:PLAYER_SPECIALIZATION_CHANGED(self, event, ...)
    if event == "player" then
        print("Player spec changed, updating mRadial spells now...")
        mRadial:HideAllWatcherFrames()
        mRadial:InitUI()
    end
end

mRadial:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
