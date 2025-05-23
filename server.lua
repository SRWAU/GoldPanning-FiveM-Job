local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('goldpanning:reward', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local rewardGiven = false

    -- Calculate reward based on loot table
    local random = math.random()
    local cumulativeChance = 0.0

    for _, loot in pairs(Config.LootTable) do
        cumulativeChance = cumulativeChance + loot.chance
        if random <= cumulativeChance then
            local quantity = math.random(loot.min, loot.max)
            xPlayer.addInventoryItem(loot.item, quantity)
            xPlayer.showNotification('You found ' .. quantity .. 'x ' .. loot.item .. '!')
            rewardGiven = true
            break
        end
    end

    if not rewardGiven then
        xPlayer.showNotification('You found nothing this time.')
    end
end)

-- Register usable item
ESX.RegisterUsableItem('goldpan', function(source)
    print('[DEBUG] Player ' .. source .. ' used goldpan item')
    TriggerClientEvent('goldpanning:startPanning', source)
end)