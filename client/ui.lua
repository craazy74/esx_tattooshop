-- UI Handler for Custom Tattoo UI
-- by ELBaron

local uiOpen = false
selectedTattooForTarget = {} -- Global table for storing selections (shared with main.lua)

-- Open Custom UI
function OpenCustomUI(targetPlayerId)
    if uiOpen then return end
    
    -- Prepare categories with counts
    local categories = {}
    local zoneCounts = {}
    
    -- Count tattoos per zone
    for _, tattoo in ipairs(Tattoos.List) do
        if not zoneCounts[tattoo.zone] then
            zoneCounts[tattoo.zone] = 0
        end
        zoneCounts[tattoo.zone] = zoneCounts[tattoo.zone] + 1
    end
    
    -- Create category objects
    for zone, count in pairs(zoneCounts) do
        table.insert(categories, {
            zone = zone,
            name = Tattoos.Zones[zone] or zone,
            count = count
        })
    end
    
    -- Send to NUI
    SendNUIMessage({
        action = 'openUI',
        targetId = targetPlayerId,
        categories = categories
    })
    
    SetNuiFocus(true, true)
    uiOpen = true
end

-- Close Custom UI
RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    uiOpen = false
    cb('ok')
end)

-- Select Category
RegisterNUICallback('selectCategory', function(data, cb)
    local zone = data.zone
    local tattoos = {}
    
    -- Filter tattoos by zone
    for _, tattoo in ipairs(Tattoos.List) do
        if tattoo.zone == zone then
            table.insert(tattoos, {
                name = tattoo.name,
                hash = tattoo.hash,
                collection = tattoo.collection,
                zone = tattoo.zone,
                zoneName = Tattoos.Zones[zone],
                price = tattoo.price
            })
        end
    end
    
    -- Send tattoos to NUI
    SendNUIMessage({
        action = 'showTattoos',
        zone = zone,
        tattoos = tattoos
    })
    
    cb('ok')
end)

-- Preview Tattoo
RegisterNUICallback('previewTattoo', function(data, cb)
    local targetId = data.targetId
    local tattoo = data.tattoo
    
    TriggerServerEvent('esx_tattooshop:previewTattoo', targetId, tattoo)
    
    cb('ok')
end)

-- Clear Preview
RegisterNUICallback('clearPreview', function(data, cb)
    local targetId = data.targetId
    
    TriggerServerEvent('esx_tattooshop:removePreview', targetId)
    
    cb('ok')
end)

-- Confirm Tattoo
RegisterNUICallback('confirmTattoo', function(data, cb)
    local targetId = data.targetId
    local tattoo = data.tattoo
    
    -- Store selection locally
    selectedTattooForTarget[targetId] = tattoo
    
    -- Remove preview first
    TriggerServerEvent('esx_tattooshop:removePreview', targetId)
    
    -- Send selection to server
    TriggerServerEvent('esx_tattooshop:selectTattoo', targetId, tattoo)
    
    SetNuiFocus(false, false)
    uiOpen = false
    
    cb('ok')
end)

-- Replace the old OpenTattooMenu function
function OpenTattooMenu(targetPlayerId)
    if not targetPlayerId then
        lib.notify({
            title = 'Fehler',
            description = Config.Locale.no_target,
            type = 'error'
        })
        return
    end
    
    OpenCustomUI(targetPlayerId)
end

-- Export for testing
RegisterCommand('testui', function()
    local playerId = GetPlayerServerId(PlayerId())
    OpenCustomUI(playerId)
end, false)
