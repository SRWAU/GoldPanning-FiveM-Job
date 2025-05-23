local ESX = exports['es_extended']:getSharedObject()
local lastNotificationTime = 0 -- Cooldown for notification
local notificationCooldown = 5000 -- Cooldown in milliseconds (5 seconds)

-- Create panning zones
Citizen.CreateThread(function()
    for _, zone in pairs(Config.PanningZones) do
        exports.ox_target:addSphereZone({
            coords = zone.coords,
            radius = zone.radius,
            options = {
                {
                    name = zone.name,
                    icon = 'fas fa-water',
                    label = 'Pan for Gold',
                    distance = 2.0,
                    canInteract = function()
                        if not Config.RequiredItem then return true end
                        local playerData = ESX.GetPlayerData()
                        for _, item in pairs(playerData.inventory) do
                            if item.name == Config.RequiredItem and item.count > 0 then
                                return true
                            end
                        end
                        if GetGameTimer() - lastNotificationTime > notificationCooldown then
                            ESX.ShowNotification('You need a gold pan to pan for gold!')
                            lastNotificationTime = GetGameTimer()
                        end
                        return false
                    end,
                    onSelect = function()
                        StartPanning()
                    end
                }
            }
        })

        -- Create blip
        local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Client event for item use
RegisterNetEvent('goldpanning:startPanning')
AddEventHandler('goldpanning:startPanning', function()
    print('[DEBUG] goldpanning:startPanning event triggered')
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local inZone = false

    -- Check if player is in a panning zone
    for _, zone in pairs(Config.PanningZones) do
        local distance = #(playerCoords - zone.coords)
        print('[DEBUG] Distance to zone ' .. zone.name .. ': ' .. distance .. ' (max: ' .. Config.ItemUseZoneRadius .. ')')
        if distance <= Config.ItemUseZoneRadius then
            inZone = true
            break
        end
    end

    if inZone then
        print('[DEBUG] Player in valid zone, starting panning')
        StartPanning()
    else
        ESX.ShowNotification('You must be near a river to pan for gold!')
        print('[DEBUG] Player not in valid zone')
    end
end)

-- Panning function
function StartPanning()
    print('[DEBUG] StartPanning called')
    local playerPed = PlayerPedId()
    RequestAnimDict(Config.PanningAnimation.dict)
    while not HasAnimDictLoaded(Config.PanningAnimation.dict) do
        Citizen.Wait(100)
    end
    exports['progressBars']:startUI(Config.PanningDuration, 'Panning for Gold...')
    TaskPlayAnim(playerPed, Config.PanningAnimation.dict, Config.PanningAnimation.anim, 8.0, -8.0, Config.PanningDuration, 1, 0, false, false, false)
    Citizen.Wait(Config.PanningDuration)
    ClearPedTasks(playerPed)
    StartSkillCheck()
end

-- Skill check function
function StartSkillCheck()
    print('[DEBUG] StartSkillCheck called')
    local keys = Config.SkillCheck.Keys
    local key = keys[math.random(1, #keys)]
    local timeWindow = Config.SkillCheck.TimeWindow
    local success = false
    local startTime = GetGameTimer()
    local text = 'Press [' .. key .. ']!'

    -- Draw UI prompt
    Citizen.CreateThread(function()
        while GetGameTimer() - startTime < timeWindow do
            DrawText2D(0.5, 0.5, text, 0.6)
            Citizen.Wait(0)
        end
    end)

    -- Check for key press
    while GetGameTimer() - startTime < timeWindow do
        if IsControlJustPressed(0, Config.SkillCheck.KeyMap[key]) then
            success = true
            break
        end
        Citizen.Wait(0)
    end

    -- Handle result
    if success then
        TriggerServerEvent('goldpanning:reward')
        print('[DEBUG] Skill check passed, reward event triggered')
    else
        ESX.ShowNotification('You failed to pan properly!')
        print('[DEBUG] Skill check failed')
    end
end

-- Draw text function for skill check UI
function DrawText2D(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end