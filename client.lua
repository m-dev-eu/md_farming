if not lib then return end
lib.locale()

local farms = require 'modules.farm.client'

AddEventHandler('onResourceStop', function ()
    LocalPlayer.state:set('isFarming', false, true)
    
    farms.wipeFarms()
end)