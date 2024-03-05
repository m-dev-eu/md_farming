if not lib then return end
lib.locale()

local baseZoneModule = require 'modules.baseZoneModule.client'

baseZoneModule.initBaseModule('action_farm', 'data.farms')
baseZoneModule.initBaseModule('action_process', 'data.processStations')

AddEventHandler('onResourceStop', function ()
    LocalPlayer.state:set('isFarming', false, true)
end)