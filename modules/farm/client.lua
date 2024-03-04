if not lib then return end

--- @type table<number, MdFarm>
local farms = {}

--- @param farmId number
local function toggleFarming(farmId)
    local farm = farms[farmId]

    local currentState = LocalPlayer.state.isFarming or false
    local newState = not currentState
    LocalPlayer.state:set('isFarming', newState, true)

    lib.notify({
        description = locale(newState and 'farming_started' or 'farming_stopped', farm.name),
        type = 'info'
    })

    if not newState then return end

    CreateThread(function ()
        repeat
            lib.progressBar({
                duration = farm.farmProcess.duration,
                label = locale('farming_in_progress', farm.name),
                anim = farm.animation,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    sprint = true
                },
                canCancel = false
            })
            local success, msg = lib.callback.await('md_farming:server:farm', false, farm.farmProcess.requiredItems, farm.farmProcess.resultItems)
            lib.notify({
                type = success and 'success' or 'error',
                description = msg
            })
        until not LocalPlayer.state.isFarming
    end)
end

--- @param point CPoint
local function nearbyFarm(point)
    if point.marker then
        ---@diagnostic disable-next-line: param-type-mismatch
        DrawMarker(point.marker.type, point.coords.x, point.coords.y, point.coords.z, 0, 0, 0, 0, 0, 0, point.range, point.range, 1.5, point.marker.colour.x, point.marker.colour.y, point.marker.colour.z, point.marker.colour.w, false, false, 0, false, nil, nil, false)
    end

    if point.currentDistance < point.range then
        if IsControlJustReleased(0, 38) then
            toggleFarming(point.farmId)
        end
    end
end

local createBlip = require 'modules.blip.client'.createBlip
for farmName, farmData in pairs(lib.load('data.farms') --[[@as table<string, MdFarm>]]) do
    local farm = {
        id = #farms + 1,
        name = farmName,
        animation = farmData.animation,
        farmProcess = farmData.farmProcess,
    }

    local blip = farmData.blip
    if blip then
        farm.blip = createBlip(blip.sprite, 0.8, blip.colour, blip.name, farmData.position)
    end

    local marker = farmData.marker

    farm.zoneId = lib.points.new({
        farmId = farm.id,
        coords = farmData.position,
        distance = 20.0,
        marker = marker,
        range = farmData.range,
        nearby = nearbyFarm
    })

    farms[farm.id] = farm
end

local function wipeFarms()
    for i = 1, #farms do
        local farm = farms[i]
        if farm.blip then
            ---@diagnostic disable-next-line: param-type-mismatch
            RemoveBlip(farm.blip)
        end

        if farm.zoneId then
           farm.zoneId:remove()
        end
    end

    table.wipe(farms)
end

return {
    wipeFarms = wipeFarms
}

--- @class MdFarmProperties
--- @field position vector3;
--- @field range number;
--- @field animation? table;
--- @field farmProcess { duration: number, requiredItems: table, resultItems: table};
--- @field blip? { sprite: number, colour: number, name: string }|number;
--- @field marker? { type: number, colour: vector4 };

--- @class MdFarm : MdFarmProperties
--- @field id number;
--- @field name string;
--- @field zoneId CPoint;