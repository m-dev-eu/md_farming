local function hasPlayerInventoryItem(xPlayer, name, count)
    local item = xPlayer.getInventoryItem(name)
    return item and item.count >= count
end

local function generateItemMessage(baseLocale, itemList)
    local placeholder = ""
    for _, item in pairs(itemList) do
        placeholder = placeholder .. item.count .. "x " .. item.name .. ", "
    end

    return locale(baseLocale, placeholder)
end

lib.callback.register('md_farming:server:farm', function (source, requiredItems, resultItems)
    local playerId = source
    if not Player(playerId).state.isFarming then
        return false, locale('not_farming_atm')
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        return false, locale('player_not_found')
    end


end)