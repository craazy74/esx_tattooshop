-- Server-Side Main File
-- Tattoo System by ELBaron

local ESX = exports['es_extended']:getSharedObject()

-- Load player tattoos from database
RegisterNetEvent('esx_tattooshop:loadTattoos', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local result = MySQL.query.await('SELECT tattoos FROM user_tattoos WHERE identifier = ?', {
        xPlayer.identifier
    })
    
    local tattoos = {}
    if result[1] and result[1].tattoos then
        tattoos = json.decode(result[1].tattoos) or {}
    end
    
    TriggerClientEvent('esx_tattooshop:applyTattoos', src, tattoos)
end)

-- Save tattoos to database
RegisterNetEvent('esx_tattooshop:saveTattoos', function(tattoos)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local tattooJson = json.encode(tattoos)
    
    MySQL.insert('INSERT INTO user_tattoos (identifier, tattoos) VALUES (?, ?) ON DUPLICATE KEY UPDATE tattoos = ?', {
        xPlayer.identifier,
        tattooJson,
        tattooJson
    })
end)

-- Preview tattoo on target player
RegisterNetEvent('esx_tattooshop:previewTattoo', function(targetId, tattoo)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    -- Check if player has tattoo artist job (DISABLED FOR TESTING)
    if Config.RequireJob and xPlayer.job.name ~= Config.TattooJob then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Fehler',
            description = Config.Locale.no_permission,
            type = 'error'
        })
        return
    end
    
    -- Apply preview on target
    TriggerClientEvent('esx_tattooshop:applyPreview', targetId, tattoo)
end)

-- Remove preview from target player
RegisterNetEvent('esx_tattooshop:removePreview', function(targetId)
    TriggerClientEvent('esx_tattooshop:clearPreview', targetId)
end)

-- Select tattoo (ready for application process)
local selectedTattoos = {} -- Store selected tattoo per player

RegisterNetEvent('esx_tattooshop:selectTattoo', function(targetId, tattoo)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    -- Check if player has tattoo artist job (DISABLED FOR TESTING)
    if Config.RequireJob and xPlayer.job.name ~= Config.TattooJob then
        return
    end
    
    -- Store selected tattoo
    selectedTattoos[targetId] = tattoo
    
    -- Notify tattoo artist
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Tattoo ausgewählt',
        description = tattoo.name .. ' - Jetzt Tätowierung starten!',
        type = 'success'
    })
    
    -- Notify customer
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Tattoo ausgewählt',
        description = 'Der Tätowierer kann jetzt starten!',
        type = 'info'
    })
end)

-- Get selected tattoo for target (will be used in Phase 4)
ESX.RegisterServerCallback('esx_tattooshop:getSelectedTattoo', function(source, cb, targetId)
    cb(selectedTattoos[targetId])
end)

-- Clear selected tattoo
RegisterNetEvent('esx_tattooshop:clearSelectedTattoo', function(targetId)
    selectedTattoos[targetId] = nil
end)

-- Check if player can afford tattoo
ESX.RegisterServerCallback('esx_tattooshop:canAffordTattoo', function(source, cb, targetId, tattoo)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then 
        cb(false)
        return
    end
    
    local tattooData = selectedTattoos[targetId] or tattoo
    if not tattooData then
        cb(false)
        return
    end
    
    local price = tattooData.price or Config.Prices[tattooData.zone] or 500
    local playerMoney = xTarget.getMoney()
    
    cb(playerMoney >= price)
end)

-- Process tattoo (payment and application)
RegisterNetEvent('esx_tattooshop:processTattoo', function(targetId, tattoo)
    local src = source
    local xArtist = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xArtist or not xTarget then return end
    
    -- Check job permission (DISABLED FOR TESTING)
    if Config.RequireJob and xArtist.job.name ~= Config.TattooJob then
        return
    end
    
    -- Get price
    local price = tattoo.price or Config.Prices[tattoo.zone] or 500
    
    -- Check if target can afford
    if xTarget.getMoney() < price then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Fehler',
            description = Config.Locale.not_enough_money,
            type = 'error'
        })
        return
    end
    
    -- Remove money from target
    xTarget.removeMoney(price)
    
    -- Give money to artist
    xArtist.addMoney(price)
    
    -- Load existing tattoos
    local result = MySQL.query.await('SELECT tattoos FROM user_tattoos WHERE identifier = ?', {
        xTarget.identifier
    })
    
    local tattoos = {}
    if result[1] and result[1].tattoos then
        tattoos = json.decode(result[1].tattoos) or {}
    end
    
    -- Add new tattoo
    table.insert(tattoos, {
        name = tattoo.name,
        hash = tattoo.hash,
        collection = tattoo.collection,
        zone = tattoo.zone
    })
    
    -- Save to database
    local tattooJson = json.encode(tattoos)
    MySQL.insert('INSERT INTO user_tattoos (identifier, tattoos) VALUES (?, ?) ON DUPLICATE KEY UPDATE tattoos = ?', {
        xTarget.identifier,
        tattooJson,
        tattooJson
    })
    
    -- Apply tattoo on target
    TriggerClientEvent('esx_tattooshop:applyPermanentTattoo', targetId, tattoo)
    
    -- Clear selected tattoo
    selectedTattoos[targetId] = nil
    
    -- Notify both players
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Bezahlung erhalten',
        description = string.format(Config.Locale.payment_received, price),
        type = 'success'
    })
    
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Tattoo fertig',
        description = 'Dein neues Tattoo wurde angewendet! -$' .. price,
        type = 'success'
    })
end)

-- Notify target player
RegisterNetEvent('esx_tattooshop:notifyTarget', function(targetId, type)
    if type == 'prepare' then
        TriggerClientEvent('ox_lib:notify', targetId, {
            title = 'Tätowierung',
            description = 'Die Tätowierung beginnt - Bitte bewege dich nicht!',
            type = 'info',
            duration = 15000
        })
    elseif type == 'cancelled' then
        TriggerClientEvent('ox_lib:notify', targetId, {
            title = 'Abgebrochen',
            description = 'Die Tätowierung wurde abgebrochen.',
            type = 'error'
        })
    end
end)
