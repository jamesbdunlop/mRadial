-- slash commands
SLASH_MW1 = "/mw"

---------------------------------------------------------------------------------------------------
function MW_slashCommands(msg, editbox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower(command)

    if command == "move" then
        mWarlock:SetUIMovable(true)
    end
    
    if command == "lock" then
        mWarlock:SetUIMovable(false)
    end
    
    if command == "options" then
        mWarlock:OptionsPane()
    end
end
SlashCmdList["MW"] = MW_slashCommands
---------------------------------------------------------------------------------------------------