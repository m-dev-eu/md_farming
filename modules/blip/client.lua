---Creates a blip on the map
---@param sprite number
---@param scale number
---@param colour number
---@param name string
---@param coords vector3
---@return number
local function createBlip(sprite, scale, colour, name, coords)
    local createdBlip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(createdBlip, sprite)
    SetBlipScale(createdBlip, scale)
    SetBlipColour(createdBlip, colour)
    SetBlipAsShortRange(createdBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(createdBlip)

    return createdBlip
end

return {
    createBlip = createBlip
}