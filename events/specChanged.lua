function mRadial:PLAYER_SPECIALIZATION_CHANGED(eventName, ...)
    -- print("-----------PLAYER SPEC CHANGED!")
    if not InCombatLockdown then
        mRadial:InitUI()
    end
end

mRadial:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
