if not lib then return end

local function toggleAction(actionName, value)
    local currentFarmingState = LocalPlayer.state.isFarming or false
    local newState = not currentFarmingState
    LocalPlayer.state:set('isFarming', newState, true)

    lib.notify({
        type = 'info',
        description = newState and locale('action_started', actionName) or locale('action_stopped', actionName)
    })

    if not newState then
        if lib.progressActive() then lib.cancelProgress() end
        return
    end

    repeat
        if lib.progressBar({
            duration = value.action.duration,
            label = locale('action_in_progress', actionName),
            canCancel = false,
            anim = value.action.animation
        }) then
            local success, msg = lib.callback.await('md_farming:server:convertItems', false, value.action.sourceItems, value.action.productItems)
            if msg then
                lib.notify({
                    type = success and 'success' or 'error',
                    description = msg
                })
            end
        end
    until not LocalPlayer.state.isFarming
end

local createBlip = require 'modules.blip.client'.createBlip
local function initBaseModule(newActionName, path)
    for name, value in pairs(lib.load(path)) do
        name = value.label or name
        value.range = value.range or 7.5

        local blip = value.blip
        if blip then
            createBlip(blip.sprite, blip.scale, blip.colour, name, blip.position or value.position)
        end

        local marker = value.marker
        lib.points.new({
            coords = value.position,
            distance = 15.0,
            nearby = function (self)
                ---@diagnostic disable-next-line: param-type-mismatch
                if marker then DrawMarker(marker.type, value.position.x, value.position.y, value.position.z, 0, 0, 0, 0, 0, 0, value.range * 2, value.range * 2, 1.5, marker.colour.x, marker.colour.y, marker.colour.z, marker.colour.a, false, false, 0, false, nil, nil, false) end
            
                if self.currentDistance < value.range and IsControlJustReleased(0, 38) then
                    CreateThread(function ()
                        toggleAction(locale(newActionName), value)
                    end)
                end
            end
        })
    end
end

return {
    initBaseModule = initBaseModule
}