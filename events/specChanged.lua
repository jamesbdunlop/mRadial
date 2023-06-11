function mRadial:PLAYER_SPECIALIZATION_CHANGED(self, event, ...)
    if self == "player" then
        mRadial:HideAllWatcherFrames()
        mRadial:InitUI()
        mRadial:UpdateUI(true)
    end
end

mRadial:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
