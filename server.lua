if not lib then return end
lib.locale()

function Server.hasPlayerInventoryItem(xPlayer, name, count)
    local item = xPlayer.getInventoryItem(name)
    return item and item.count >= count
end

function Server.generateItemMessage(baseLocale, itemList)
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

require 'modules.farm.server'
require 'modules.process.server'