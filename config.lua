-- ============================================
-- ESX TATTOO SHOP - CONFIGURATION
-- Created by ELBaron
-- Version: 1.0.0
-- ============================================

Config = {}

-- ============================================
-- FRAMEWORK SETTINGS
-- ============================================
Config.Framework = 'esx' -- Framework: 'esx' or 'qbcore' (for future support)

-- ============================================
-- JOB SETTINGS
-- ============================================
Config.TattooJob = 'tattoo_artist' -- Job name required to open tattoo menu
Config.RequireJob = true           -- true = Only tattoo_artist can tattoo | false = Anyone can tattoo

-- ============================================
-- TATTOO SHOP LOCATIONS
-- Add or remove locations as needed
-- ============================================
Config.TattooShops = {
    {
        name = "Tattoo Shop - Vespucci Beach",
        coords = vector3(-1153.6, -1425.6, 4.9),
        blip = {
            enabled = true,
            sprite = 75,
            color = 1,
            scale = 0.8
        }
    },
    {
        name = "Tattoo Shop - Vinewood",
        coords = vector3(1322.6, -1651.9, 52.2),
        blip = {
            enabled = true,
            sprite = 75,
            color = 1,
            scale = 0.8
        }
    },
    {
        name = "Tattoo Shop - Harmony",
        coords = vector3(1864.6, 3747.7, 33.0),
        blip = {
            enabled = true,
            sprite = 75,
            color = 1,
            scale = 0.8
        }
    },
    {
        name = "Tattoo Shop - Sandy Shores",
        coords = vector3(322.1, 180.4, 103.5),
        blip = {
            enabled = true,
            sprite = 75,
            color = 1,
            scale = 0.8
        }
    },
    {
        name = "Tattoo Shop - Paleto Bay",
        coords = vector3(-293.7, 6200.0, 31.4),
        blip = {
            enabled = true,
            sprite = 75,
            color = 1,
            scale = 0.8
        }
    }
}

-- ============================================
-- TATTOO PROCESS SETTINGS
-- Configure animation and duration
-- ============================================
Config.TattooProcess = {
    duration = 15000, -- Tattoo duration in milliseconds (15000 = 15 seconds)
    animation = {
        dict = "amb@world_human_bum_wash@male@low@idle_a", -- Animation dictionary
        anim = "idle_a",                                    -- Animation name
        flag = 1                                            -- Animation flag
    },
    progressLabel = "Tätowierung wird gestochen..." -- Progress bar text
}

-- ============================================
-- PRICING CONFIGURATION
-- Set prices for each body zone in $ (money)
-- ============================================
Config.Prices = {
    ZONE_TORSO = 500,      -- Chest/Back tattoos ($500)
    ZONE_HEAD = 300,       -- Face/Neck tattoos ($300)
    ZONE_LEFT_ARM = 400,   -- Left Arm tattoos ($400)
    ZONE_RIGHT_ARM = 400,  -- Right Arm tattoos ($400)
    ZONE_LEFT_LEG = 450,   -- Left Leg tattoos ($450)
    ZONE_RIGHT_LEG = 450   -- Right Leg tattoos ($450)
}

-- ============================================
-- OX_TARGET SETTINGS
-- Configure player targeting options
-- ============================================
Config.Target = {
    distance = 2.5,              -- Distance in meters to show target option (2.5m)
    icon = "fas fa-pen",         -- Font Awesome icon
    label = "Tattoo-Menü öffnen" -- Target option label
}

-- ============================================
-- LOCALE / TRANSLATIONS
-- Customize all in-game messages here
-- ============================================
Config.Locale = {
    -- Error messages
    no_permission = "Du bist kein Tätowierer!",
    no_target = "Kein Spieler in der Nähe!",
    tattoo_in_progress = "Tätowierung läuft bereits...",
    not_enough_money = "Nicht genug Geld!",
    
    -- Menu titles
    menu_title = "Tattoo Auswahl",
    select_category = "Wähle eine Körperzone",
    select_tattoo = "Wähle ein Tattoo",
    
    -- Action messages
    start_tattoo = "Tätowierung starten",
    tattoo_complete = "Tätowierung abgeschlossen!",
    tattoo_cancelled = "Tätowierung abgebrochen!",
    payment_received = "Bezahlung erhalten: $%s"
}
