Shared = {
    resource = GetCurrentResourceName(),
}

if IsDuplicityVersion() then
    Server = {}
else
    Client = {
        target = GetResourceState('ox_target') == 'started' and (GetConvarInt('md_dailyrewards:target', 0) == 1)
    }
end

if not lib then
    return error('ox_lib was not found!')
end

if lib.context == 'server' then
    local currentVersion = GetResourceMetadata(Shared.resource, 'version', 0)
    if currentVersion == 'Development Build' then
        warn(("You are running a development build of the '%s' System. Please do not use this in production."):format(Shared.resource))
    end
    return require 'server'
end

require 'client'