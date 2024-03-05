if not lib then return end
local actionName = locale('action_farm')

---@param farmName string
---@param farmData MdFarmProperties
local function toggleFarming(farmName, farmData)
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
            duration = farmData.action.duration,
            label = locale('action_in_progress', actionName),
            canCancel = false,
            anim = farmData.action.animation
        }) then
            local success, msg = lib.callback.await('md_farming:server:convertItems', false, farmData.action.sourceItems, farmData.action.productItems)
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
for farmName, farmData in pairs(lib.load('data.farms') --[[@as table<string, MdFarmProperties>]]) do
    farmName = farmData.label or farmName
    farmData.range = farmData.range or 7.5

    local blip = farmData.blip
    if blip then
        createBlip(blip.sprite, blip.scale, blip.colour, farmName, blip.position or farmData.position)
    end

    local marker = farmData.marker
    lib.points.new({
        coords = farmData.position,
        distance = 15.0,
        nearby = function (self)
            ---@diagnostic disable-next-line: param-type-mismatch
            if marker then DrawMarker(marker.type, farmData.position.x, farmData.position.y, farmData.position.z, 0, 0, 0, 0, 0, 0, farmData.range * 2, farmData.range * 2, 1.5, marker.colour.x, marker.colour.y, marker.colour.z, marker.colour.a, false, false, 0, false, nil, nil, false) end
        
            if self.currentDistance < farmData.range and IsControlJustReleased(0, 38) then
                CreateThread(function ()
                    toggleFarming(farmName, farmData)
                end)
            end
        end
    })
end


---@class MdFarmProperties
---@field label? string;
---@field range? number;
---@field position vector3;
---@field blip? { sprite: number, colour: number, scale: number, position?: vector3};
---@field marker? { type: number, colour: vector4 };
---@field action { duration: number, animation: table, sourceItems: table, productItems: table };
