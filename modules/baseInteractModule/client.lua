if not lib then return end
local cachedMessages = {}

local function sellItems(name, value)
    local message = cachedMessages[name] or ''
    local alert = lib.alertDialog({
        header = locale('interact_sell_alert_header'),
        content = message,
        cancel = true,
        centered = true
    })

    if alert == 'cancel' then return end

    LocalPlayer.state:set('isFarming', true, true)
    local success, result = lib.callback.await('md_farming:server:convertItems', false, value.action.sourceItems, value.action.productItems)
    if result then
        lib.notify({
            type = success and 'success' or 'error',
            description = result
        })
    end

    LocalPlayer.state:set('isFarming', false, true)
end

local function generateMessage(sourceItems, productItems)
    if table.type(sourceItems) == 'hash' then
        sourceItems = {sourceItems}
    end
    if table.type(productItems) == 'hash' then
        productItems = {productItems}
    end

    local sourceMessage = ''
    local lastItem = sourceItems[#sourceItems]
    for _, item in ipairs(sourceItems) do
        sourceMessage = sourceMessage .. ('%sx %s'):format(item.count, item.name)
        if item ~= lastItem then
            sourceMessage = sourceMessage .. ', '
        end
    end

    local productMessage = ''
    lastItem = productItems[#productItems]
    for _, item in ipairs(productItems) do
        productMessage = productMessage .. ('%sx %s'):format(item.count, item.name)
        if item ~= lastItem then
            productMessage = productMessage .. ', '
        end
    end

    return locale('interact_sell_alert_content', sourceMessage, productMessage)
end

local createBlip = require 'modules.blip.client'.createBlip
local spawnPed = require 'modules.ped.client'.spawnPed
local function initBaseModule(action_name, path)
    for name, value in pairs(lib.load(path)) do
        local interactMessage = locale('interact_help', locale('interact_sell'))

        name = value.label or name
        value.range = value.range or 1.5

        local blip = value.blip
        if blip then
            createBlip(blip.sprite, blip.scale, blip.colour, name, blip.position or value.position)
        end

        local ped = value.ped
        local entity = ped and spawnPed(ped.model, ped.position, ped.scenario)
        if entity and Shared.target then
            exports.ox_target:addLocalEntity(entity, {
                label = interactMessage,
                icon = 'fas fa-handshake',
                distance = value.range,
                onSelect = function ()
                    sellItems(name, value)
                end
            })
            
            goto continue
        end

        lib.points.new({
            coords = value.position,
            distance = value.range,
            onEnter = function ()
                if not Shared.textUI then return end

                lib.showTextUI(interactMessage, {
                    icon = 'fas fa-handshake',
                })

                Client.textUIActive = true
            end,
            onExit = function ()
                if not Shared.textUI or not Client.textUIActive then return end
                lib.hideTextUI()

                Client.textUIActive = false
            end,
            nearby = function ()
                if IsControlJustReleased(0, 38) and not LocalPlayer.state.isFarming then
                    sellItems(name, value)
                end
            end
        })

        ::continue::
        cachedMessages[name] = generateMessage(value.action.sourceItems, value.action.productItems)
    end
end

return {
    initBaseModule = initBaseModule
}