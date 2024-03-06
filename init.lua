Shared = {
    resource = GetCurrentResourceName(),
    target = GetConvarInt('md_farming:target', 1) == 1,
    textUI = GetConvarInt('md_farming:textUI', 1) == 1
}

if IsDuplicityVersion() then
    Server = {}
else
    Client = {
        textUIActive = false
    }
end

if not lib then
    return error('ox_lib was not found!')
end

if Shared.target and GetResourceState('ox_target') ~= 'started' then
    Shared.target = false
    lib.print.warning('The target resource (ox_target) is not running. Disabling target functionality.')
end

if lib.context == 'server' then
    local currentVersion = GetResourceMetadata(Shared.resource, 'version', 0)
    if currentVersion == '0.0.0' then
        warn(("You are running a development build of the '%s' System. Please do not use this in production."):format(Shared.resource))
    end

    return require 'server'
end

require 'client'