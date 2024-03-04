if not lib then return end
lib.locale()

local farms = require 'modules.farm.client'
local processStations = require 'modules.process.client'

AddEventHandler('onResourceStop', function ()
    LocalPlayer.state:set('isFarming', false, true)
    
    farms.wipeFarms()
    processStations.wipeProcessStations()
end)