function mRadial:UNIT_POWER_UPDATE(_, arg1, arg2)
    if arg1 == "player" and arg2 == "SOUL_SHARDS" then
        mRadial:shardtrack()
    end
end

mRadial:RegisterEvent("UNIT_POWER_UPDATE")
