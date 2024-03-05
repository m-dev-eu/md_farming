local function spawnPed(hash, coords, scenario)
    local model = lib.requestModel(hash)
    if not model then return end

    local entity = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, false ,true)
    if scenario then TaskStartScenarioInPlace(entity, scenario, 0, true) end

    SetModelAsNoLongerNeeded(model)
    FreezeEntityPosition(entity, true)
    SetEntityInvincible(entity, true)
    SetBlockingOfNonTemporaryEvents(entity, true)

    return entity
end

return {
    spawnPed = spawnPed
}