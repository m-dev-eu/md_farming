if not lib then return end
lib.locale()

---@param itemList {name: string, count: number}|{name: string, count: number}[]
local function checkForItems(xPlayer, itemList)
    if type(itemList) ~= 'table' then return false, nil end
    if table.type(itemList) == 'hash' then itemList = {itemList} end

    local hasItems, missingItems = true, {}
    for _, item in pairs(itemList) do
        local inventoryItem = xPlayer.getInventoryItem(item.name)
        if not inventoryItem then return false, nil end

        local playerCount = inventoryItem.count
        if playerCount < item.count then
            hasItems = false
            missingItems[#missingItems + 1] = ('%sx %s'):format(item.count - playerCount, inventoryItem.label)
        end
    end

    return hasItems, missingItems
end

---@param itemList {name: string, count: number}|{name: string, count: number}[]
local function checkForSpace(xPlayer, itemList)
    if type(itemList) ~= 'table' then return false end
    if table.type(itemList) == 'hash' then itemList = {itemList} end

    for _, item in pairs(itemList) do
        if not xPlayer.canCarryItem(item.name, item.count) then return false end
    end

    return true
end

lib.callback.register('md_farming:server:convertItems', function (source, sourceItems, productItems)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, nil end
    if not Player(playerId).state.isFarming then return false, nil end

    local hasRequiredItems, missingItems = checkForItems(xPlayer, sourceItems)
    if not hasRequiredItems and missingItems then return false, locale('items_missing_error', table.concat(missingItems, ', ')) end

    if not checkForSpace(xPlayer, productItems) then return false, locale('items_no_space_error') end


    sourceItems = table.type(sourceItems) == 'hash' and {sourceItems} or sourceItems
    productItems = table.type(productItems) == 'hash' and {productItems} or productItems
    
    for _, item in pairs(sourceItems) do
        xPlayer.removeInventoryItem(item.name, item.count)
    end

    for _, item in pairs(productItems) do
        xPlayer.addInventoryItem(item.name, item.count)
    end

    return true, locale('items_converted_success')
end)