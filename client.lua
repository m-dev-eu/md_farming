if not lib then return end
lib.locale()

require 'modules.farm.client'

AddEventHandler('onResourceStop', function ()
    LocalPlayer.state:set('isFarming', false, true)
end)