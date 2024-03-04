local function hasPlayerInventoryItem(xPlayer, name, count)
    local item = xPlayer.getInventoryItem(name)
    return item and item.count >= count
end

local function generateItemMessage(baseLocale, itemList)
    local placeholder = ""
    for i = 1, #itemList do
        local item = itemList[i]
        placeholder = placeholder .. item.count .. "x " .. item.name
        if i < #itemList then
            placeholder = placeholder .. ", "
        end
    end

    return locale(baseLocale, placeholder)
end

lib.callback.register('md_farming:server:farm', function (source, requiredItems, resultItems)
    local playerId = source
    if not Player(playerId).state.isFarming then return false, locale('not_farming_atm') end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, locale('player_not_found') end

    if type(requiredItems) ~= 'table' or type(resultItems) ~= 'table' then return false, locale('invalid_configuration') end
    
    if table.type(requiredItems) == 'hash'then
        requiredItems = { requiredItems}
    end

    if table.type(resultItems) == 'hash' then
        resultItems = { resultItems }
    end

    for _, item in pairs(requiredItems) do
        if not hasPlayerInventoryItem(xPlayer, item.name, item.count) then
            return false, generateItemMessage('farming_lack_of_items', requiredItems)
        end
    end

    for _, item in pairs(resultItems) do
        if not xPlayer.canCarryItem(item.name, item.count) then
            return false, locale('farming_not_enough_place')
        end

        xPlayer.addInventoryItem(item.name, item.count)
    end

    return true, generateItemMessage('farming_success', resultItems)
end)