--            Junkin           --
-- A gray item seller that is  --
-- as non-invasive as possible --
-- (C) 2020 Julian Monticelli  --

JUNKIN_VERSION = "1.0.0"

-- https://stackoverflow.com/questions/1426954/split-string-in-lua
function SplitStringArguments(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end


function GetSubCommandAndArguments(inputstr)
	subcmd = nil
	subcmdArgs = {}
	
	local parseableCommandLine = SplitStringArguments(inputstr)
	
	for index, val in pairs(parseableCommandLine) do
        if index == 1 then
            subcmd = val
        else
            table.insert(t, val)
        end
	end
	
	return subcmd, subcmdArgs
end

function JunkinHelpCommand(subcmdArgs)
    print("|cff00bdb2/junk|r |cffbb45ffhelp|r:       Display the help menu")
    print("|cff00bdb2/junk|r |cffbb45ffsell|r:        Sell all gray items with no prompt")
    print("|cff00bdb2/junk|r |cffbb45ffversion|r:   Display version")
end

function JunkinSellHandleItem(itemId, bagId, slotId)
	local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bagId, slotId)
	
    if quality == 0 then
        --ShowMerchantSellCursor(1);
        UseContainerItem(bagId, slotId)
		print("Selling " .. itemLink .. " (x" .. itemCount .. ")...")
    end
end

function JunkinVersionCommand(subcmdArgs)
    print("|cff00bdb2J|r|cffbb45ffu|r|cff00bdb2n|r|cffbb45ffk|r|cff00bdb2i|r|cffbb45ffn|r v" .. JUNKIN_VERSION.. " <|cff00bdb2j|r.|cffbb45ffm|r.|cff00bdb2monticelli|r@|cffbb45ffgmail|r.|cff00bdb2com|r>")
end

function JunkinSellCommand(subcmdArgs)
    if not MerchantFrame:IsVisible() then
        print("|cffff0000Cannot sell items: not at vendor.|r ")
        return
    end
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local id = GetContainerItemID(bag, slot)
            if id then JunkinSellHandleItem(id, bag, slot) end
        end
    end
end

function JunkinCommand(msg, editbox) -- define the function
    subcmd, subcmdArgs = GetSubCommandAndArguments(msg)
	
    --if subcmd then print("Subcmd: " .. subcmd) end
    if subcmd then
        cmd = string.lower(subcmd)
        if     cmd == "help" then JunkinHelpCommand(subcmdArgs)
        elseif cmd == "sell" then JunkinSellCommand(subcmdArgs)
		elseif cmd == "version" then JunkinVersionCommand(subcmdArgs)
		else print("|cffffff00Unknown command:|r " .. cmd)
        end
    end
end

SLASH_JUNKIN1 = "/junk"
SLASH_JUNKIN2 = "/junkin"; -- define slash commands
SlashCmdList["JUNKIN"] = JunkinCommand