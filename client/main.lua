-- Client-Side Main File
-- Tattoo System by ELBaron

local ESX = exports['es_extended']:getSharedObject()
local PlayerData = {}
local currentTattoos = {}

-- Initialize
CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

-- Update player data on job change
RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Load player tattoos when spawned
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent('esx_tattooshop:loadTattoos')
end)

-- Apply tattoos received from server
RegisterNetEvent('esx_tattooshop:applyTattoos', function(tattoos)
    currentTattoos = tattoos
    ClearPedDecorations(PlayerPedId())
    
    if tattoos and #tattoos > 0 then
        for _, tattoo in ipairs(tattoos) do
            AddPedDecorationFromHashes(PlayerPedId(), tattoo.collection, tattoo.hash)
        end
    end
end)

-- ox_target: Setup player targeting for tattoo artists
selectedTattooForTarget = selectedTattooForTarget or {} -- Global table (shared with ui.lua)
local isProcessing = false -- Prevent multiple processes

CreateThread(function()
    exports.ox_target:addGlobalPlayer({
        {
            name = 'tattoo_menu',
            icon = Config.Target.icon,
            label = Config.Target.label,
            distance = Config.Target.distance,
            canInteract = function(entity, distance, coords, name, bone)
                -- Only show if job requirement is disabled OR player is tattoo artist
                if not Config.RequireJob then
                    return true
                end
                return PlayerData.job and PlayerData.job.name == Config.TattooJob
            end,
            onSelect = function(data)
                local targetPlayer = data.entity
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPlayer))
                OpenTattooMenu(targetId)
            end
        },
        {
            name = 'tattoo_start',
            icon = 'fas fa-syringe',
            label = Config.Locale.start_tattoo,
            distance = Config.Target.distance,
            canInteract = function(entity, distance, coords, name, bone)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                -- Check job requirement
                local hasJob = not Config.RequireJob or (PlayerData.job and PlayerData.job.name == Config.TattooJob)
                -- Only show if tattoo is selected for this target and not processing
                return hasJob and selectedTattooForTarget[targetId] ~= nil and not isProcessing
            end,
            onSelect = function(data)
                local targetPlayer = data.entity
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPlayer))
                StartTattooProcess(targetId)
            end
        }
    })
end)

--[[ OLD OX_LIB MENU SYSTEM - REPLACED WITH CUSTOM UI
-- Open Tattoo Category Selection Menu
function OpenTattooMenu(targetPlayerId)
    if not targetPlayerId then
        lib.notify({
            title = 'Fehler',
            description = Config.Locale.no_target,
            type = 'error'
        })
        return
    end

    local options = {}
    local zones = {}
    
    -- Count tattoos per zone
    for _, tattoo in ipairs(Tattoos.List) do
        if not zones[tattoo.zone] then
            zones[tattoo.zone] = 0
        end
        zones[tattoo.zone] = zones[tattoo.zone] + 1
    end
    
    -- Create menu options for each zone
    for zone, count in pairs(zones) do
        table.insert(options, {
            title = Tattoos.Zones[zone],
            description = count .. ' Tattoos verfügbar',
            icon = 'pen',
            onSelect = function()
                OpenTattooSelection(targetPlayerId, zone)
            end
        })
    end
    
    lib.registerContext({
        id = 'tattoo_category_menu',
        title = Config.Locale.menu_title,
        options = options
    })
    
    lib.showContext('tattoo_category_menu')
end

-- Open Tattoo Selection for specific zone
function OpenTattooSelection(targetPlayerId, zone)
    local options = {}
    
    -- Filter tattoos by zone
    for _, tattoo in ipairs(Tattoos.List) do
        if tattoo.zone == zone then
            table.insert(options, {
                title = tattoo.name,
                description = 'Preis: $' .. tattoo.price,
                icon = 'image',
                onSelect = function()
                    PreviewTattoo(targetPlayerId, tattoo)
                end
            })
        end
    end
    
    lib.registerContext({
        id = 'tattoo_selection_menu',
        title = Tattoos.Zones[zone],
        menu = 'tattoo_category_menu',
        options = options
    })

    lib.showContext('tattoo_selection_menu')
end

-- Preview tattoo on target player
local previewedTattoo = nil

function PreviewTattoo(targetPlayerId, tattoo)
    -- Apply preview on target
    TriggerServerEvent('esx_tattooshop:previewTattoo', targetPlayerId, tattoo)
    previewedTattoo = tattoo
    
    -- Show confirmation menu
    lib.registerContext({
        id = 'tattoo_confirm_menu',
        title = tattoo.name,
        menu = 'tattoo_selection_menu',
        options = {
            {
                title = 'Tattoo auswählen',
                description = 'Preis: $' .. tattoo.price,
                icon = 'check',
                onSelect = function()
                    SelectTattoo(targetPlayerId, tattoo)
                end
            },
            {
                title = 'Zurück',
                icon = 'arrow-left',
                onSelect = function()
                    -- Remove preview
                    TriggerServerEvent('esx_tattooshop:removePreview', targetPlayerId)
                    lib.showContext('tattoo_selection_menu')
                end
            }
        }
    })
    
    lib.showContext('tattoo_confirm_menu')
end
--]]

--[[ OLD OX_LIB SELECTION FUNCTION - REPLACED WITH CUSTOM UI
-- Select tattoo for application
function SelectTattoo(targetPlayerId, tattoo)
    -- Clear preview
    TriggerServerEvent('esx_tattooshop:removePreview', targetPlayerId)
    
    -- Store selection locally
    selectedTattooForTarget[targetPlayerId] = tattoo
    
    -- Send selection to server
    TriggerServerEvent('esx_tattooshop:selectTattoo', targetPlayerId, tattoo)
    previewedTattoo = nil
end
--]]

-- Start tattoo process
function StartTattooProcess(targetPlayerId)
    if isProcessing then
        lib.notify({
            title = 'Fehler',
            description = Config.Locale.tattoo_in_progress,
            type = 'error'
        })
        return
    end
    
    local tattoo = selectedTattooForTarget[targetPlayerId]
    if not tattoo then return end
    
    isProcessing = true
    
    -- Request payment check from server
    ESX.TriggerServerCallback('esx_tattooshop:canAffordTattoo', function(canAfford)
        if not canAfford then
            lib.notify({
                title = 'Fehler',
                description = Config.Locale.not_enough_money,
                type = 'error'
            })
            isProcessing = false
            return
        end
        
        -- Notify target player to prepare
        TriggerServerEvent('esx_tattooshop:notifyTarget', targetPlayerId, 'prepare')
        
        -- Start animation on artist
        local playerPed = PlayerPedId()
        RequestAnimDict(Config.TattooProcess.animation.dict)
        while not HasAnimDictLoaded(Config.TattooProcess.animation.dict) do
            Wait(10)
        end
        TaskPlayAnim(playerPed, Config.TattooProcess.animation.dict, Config.TattooProcess.animation.anim, 
                     8.0, -8.0, -1, Config.TattooProcess.animation.flag, 0, false, false, false)
        
        -- Show progress bar
        if lib.progressBar({
            duration = Config.TattooProcess.duration,
            label = Config.TattooProcess.progressLabel,
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true
            }
        }) then
            -- Process completed successfully
            ClearPedTasks(playerPed)
            
            -- Process payment and apply tattoo
            TriggerServerEvent('esx_tattooshop:processTattoo', targetPlayerId, tattoo)
            
            -- Clear selected tattoo
            selectedTattooForTarget[targetPlayerId] = nil
            
            lib.notify({
                title = 'Erfolg',
                description = Config.Locale.tattoo_complete,
                type = 'success'
            })
        else
            -- Process cancelled
            ClearPedTasks(playerPed)
            TriggerServerEvent('esx_tattooshop:notifyTarget', targetPlayerId, 'cancelled')
            
            lib.notify({
                title = 'Abgebrochen',
                description = Config.Locale.tattoo_cancelled,
                type = 'error'
            })
        end
        
        isProcessing = false
    end, targetPlayerId, tattoo)
end

-- Event: Apply permanent tattoo
RegisterNetEvent('esx_tattooshop:applyPermanentTattoo', function(tattoo)
    -- Add to current tattoos
    table.insert(currentTattoos, tattoo)
    
    -- Apply tattoo
    ClearPedDecorations(PlayerPedId())
    for _, t in ipairs(currentTattoos) do
        AddPedDecorationFromHashes(PlayerPedId(), t.collection, t.hash)
    end
    
    lib.notify({
        title = 'Neues Tattoo',
        description = tattoo.name .. ' wurde erfolgreich angewendet!',
        type = 'success'
    })
end)

-- Apply preview from server
RegisterNetEvent('esx_tattooshop:applyPreview', function(tattoo)
    local ped = PlayerPedId()
    AddPedDecorationFromHashes(ped, tattoo.collection, tattoo.hash)
end)

-- Remove preview from server
RegisterNetEvent('esx_tattooshop:clearPreview', function()
    local ped = PlayerPedId()
    ClearPedDecorations(ped)
    -- Reapply permanent tattoos
    if currentTattoos and #currentTattoos > 0 then
        for _, tattoo in ipairs(currentTattoos) do
            AddPedDecorationFromHashes(ped, tattoo.collection, tattoo.hash)
        end
    end
end)

-- TEST COMMAND: Open tattoo menu on yourself
RegisterCommand('testtattoo', function()
    local playerId = GetPlayerServerId(PlayerId())
    OpenTattooMenu(playerId)
end, false)

-- TEST COMMAND: Directly apply a test tattoo
RegisterCommand('testpreview', function()
    local ped = PlayerPedId()
    local pedModel = GetEntityModel(ped)
    local mpMale = GetHashKey("mp_m_freemode_01")
    local mpFemale = GetHashKey("mp_f_freemode_01")
    
    print("^2[TATTOO DEBUG] Ped Model: " .. pedModel)
    print("^2[TATTOO DEBUG] MP Male Hash: " .. mpMale)
    print("^2[TATTOO DEBUG] MP Female Hash: " .. mpFemale)
    
    if pedModel ~= mpMale and pedModel ~= mpFemale then
        lib.notify({
            title = 'Debug',
            description = 'FEHLER: Kein MP Ped! Tattoos funktionieren nur auf mp_m_freemode_01 oder mp_f_freemode_01',
            type = 'error',
            duration = 10000
        })
        return
    end
    
    -- Determine correct hash based on gender
    local testHash
    if pedModel == mpMale then
        testHash = GetHashKey("MP_MP_Biker_Tat_001_M") -- Different tattoo for testing
    else
        testHash = GetHashKey("MP_MP_Biker_Tat_001_F")
    end
    
    local testCollection = GetHashKey("mpbiker_overlays")
    
    print("^2[TATTOO DEBUG] Applying test tattoo...")
    print("^2Hash: " .. testHash)
    print("^2Collection: " .. testCollection)
    print("^2Gender: " .. (pedModel == mpMale and "Male" or "Female"))
    
    -- Clear all first
    ClearPedDecorations(ped)
    
    -- Try multiple tattoos to ensure one is visible
    local tattoos = {
        "MP_MP_Biker_Tat_001_M",
        "MP_MP_Biker_Tat_003_M", 
        "MP_MP_Biker_Tat_005_M",
        "MP_MP_Biker_Tat_009_M", -- Head tattoo
        "MP_MP_Biker_Tat_011_M"  -- Chest tattoo
    }
    
    for i, tatName in ipairs(tattoos) do
        local hash = GetHashKey(tatName)
        AddPedDecorationFromHashes(ped, testCollection, hash)
        print("^2[TATTOO DEBUG] Applied: " .. tatName .. " (Hash: " .. hash .. ")")
    end
    
    lib.notify({
        title = 'Debug',
        description = '5 Test-Tattoos angewendet! Checke Kopf, Brust, Arme!',
        type = 'success',
        duration = 10000
    })
end, false)
