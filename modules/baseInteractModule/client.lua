if not lib then return end

local createBlip = require 'modules.blip.client'.createBlip
local spawnPed = require 'modules.ped.client'.spawnPed
local function initBaseModule(action_name, path)
    for name, value in pairs(lib.load(path)) do
        name = value.label or name
        value.range = value.range or 1.5

        local blip = value.blip
        if blip then
            createBlip(blip.sprite, blip.scale, blip.colour, name, blip.position or value.position)
        end

        local ped = value.ped
        if ped then
            local entity = spawnPed(ped.model, ped.position, ped.scenario)
            if Shared.target then
                exports.ox_target:addLocalEntity(entity, {
                    label = locale('interact_help', locale(action_name)),
                })
            else
                -- OX_LIB Zone and TextUI
            end
        end
    end
end

return {
    initBaseModule = initBaseModule
}