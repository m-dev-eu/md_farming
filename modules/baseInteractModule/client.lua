if not lib then return end

local function sellItems(value)
    -- TODO: This
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
            })
            
            goto continue
        end

        lib.points.new({
            coords = value.position,
            distance = value.range,
            onEnter = function (self)
                if not Shared.textUI then return end

                lib.showTextUI(interactMessage, {
                    icon = 'fas fa-handshake',
                })

                Client.textUIActive = true
            end,
            onExit = function (self)
                if not Shared.textUI or not Client.textUIActive then return end
                lib.hideTextUI()

                Client.textUIActive = false
            end,
            nearby = function (self)
                if IsControlJustReleased(0, 38) and not LocalPlayer.state.isFarming then
                    sellItems(value)
                end
            end
        })

        ::continue::
    end
end

return {
    initBaseModule = initBaseModule
}