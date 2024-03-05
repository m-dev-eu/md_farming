if not lib then return end
lib.locale()

local baseModule = require 'modules.baseModule.client'

baseModule.initBaseModule('action_farm', 'data.farms')
baseModule.initBaseModule('action_process', 'data.processStations')

AddEventHandler('onResourceStop', function ()
    LocalPlayer.state:set('isFarming', false, true)
end)