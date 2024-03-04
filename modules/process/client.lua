if not lib then return end

local processStations = {}

--- @param processId number
local function toggleProcessing(processId)
    local processStation = processStations[processId]

    local currentState = processStation.processingProcess.state
    local newState = not currentState
    LocalPlayer.state:set('isFarming', newState, true)

    lib.notify({
        description = locale(newState and 'processing_started' or 'processing_stopped', processStation.name),
        type = 'info'
    })

    if not newState then return end

    CreateThread(function ()
        repeat
            lib.progressBar({
                duration = processStation.processingProcess.duration,
                label = locale('processing_in_progress', processStation.name),
                anim = processStation.animation,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    sprint = true
                },
                canCancel = false
            })
            local success, msg = lib.callback.await('md_processing:server:process', false, processStation.processingProcess.requiredItems, processStation.processingProcess.resultItems)
            lib.notify({
                type = success and 'success' or 'error',
                description = msg
            })
        until not LocalPlayer.state.isFarming
    end)
end

--- @param point CPoint
local function nearbyProcessStation(point)
    if point.marker then
        ---@diagnostic disable-next-line: param-type-mismatch
        DrawMarker(point.marker.type, point.coords.x, point.coords.y, point.coords.z, 0, 0, 0, 0, 0, 0, point.range, point.range, 1.5, point.marker.colour.x, point.marker.colour.y, point.marker.colour.z, point.marker.colour.w, false, false, 0, false, nil, nil, false)
    end

    if point.currentDistance < point.range then
        if IsControlJustReleased(0, 38) then
            toggleProcessing(point.processId)
        end
    end
end

local createBlip = require 'modules.blip.client'.createBlip
for processName, processData in pairs(lib.load('data.processStations') --[[@as table<string, MdProcess>]]) do
    local processStation = {
        id = #processStations + 1,
        name = processName,
        animation = processData.animation,
        processingProcess = processData.processingProcess,
    }

    local blip = processData.blip
    if blip then
        processStation.blip = createBlip(blip.sprite, 0.8, blip.colour, blip.name, processData.position)
    end

    local marker = processData.marker

    processStation.zoneId = lib.points.new({
        processId = processStation.id,
        coords = processData.position,
        distance = 20.0,
        marker = marker,
        range = processData.range,
        nearby = nearbyProcessStation
    })

    processStations[processStation.id] = processStation
end

local function wipeProcessStations()
    for i = 1, #processStations do
        local processStation = processStations[i]
        if processStation.blip then
            ---@diagnostic disable-next-line: param-type-mismatch
            RemoveBlip(processStation.blip)
        end

        if processStation.zoneId then
           processStation.zoneId:remove()
        end
    end

    table.wipe(processStations)
end

return {
    wipeProcessStations = wipeProcessStations
}

--- @class MdProcessProperties
--- @field position vector3;
--- @field range number;
--- @field animation? table;
--- @field processingProcess { duration: number, requiredItems: table, resultItems: table};
--- @field blip? { sprite: number, colour: number, name: string }|number;
--- @field marker? { type: number, colour: vector4 };

--- @class MdProcess : MdProcessProperties
--- @field id number;
--- @field name string;
--- @field zoneId CPoint;