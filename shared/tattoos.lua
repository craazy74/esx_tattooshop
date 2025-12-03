-- Shared Tattoos Data
-- This file will contain all GTA V tattoos organized by zones
-- Will be populated in Phase 2

Tattoos = {}

-- Tattoo collections (GTA V native)
Tattoos.Collections = {
    ['mpbusiness_overlays'] = 'Business',
    ['mpchristmas2_overlays'] = 'Christmas',
    ['mpbeach_overlays'] = 'Beach',
    ['mphipster_overlays'] = 'Hipster',
    ['mpairraces_overlays'] = 'Air Races',
    ['mpbiker_overlays'] = 'Biker',
    ['mpgunrunning_overlays'] = 'Gunrunning',
    ['mpsmuggler_overlays'] = 'Smuggler',
    ['mpvinewood_overlays'] = 'Vinewood',
    ['multiplayer_overlays'] = 'Multiplayer'
}

-- Zone definitions
Tattoos.Zones = {
    ZONE_TORSO = "Oberkörper",
    ZONE_HEAD = "Kopf/Gesicht",
    ZONE_LEFT_ARM = "Linker Arm",
    ZONE_RIGHT_ARM = "Rechter Arm",
    ZONE_LEFT_LEG = "Linkes Bein",
    ZONE_RIGHT_LEG = "Rechtes Bein"
}

-- Tattoo data will be added in Phase 2
Tattoos.List = {
    -- TORSO (Chest/Back) Tattoos
    {
        name = "Skull and Sword",
        hash = `MP_MP_Biker_Tat_018_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 500
    },
    {
        name = "Dragons and Skull",
        hash = `MP_MP_Biker_Tat_019_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 650
    },
    {
        name = "Ride or Die",
        hash = `MP_MP_Biker_Tat_021_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 550
    },
    {
        name = "Skull Chain",
        hash = `MP_MP_Biker_Tat_023_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 600
    },
    {
        name = "Snake Bike",
        hash = `MP_MP_Biker_Tat_026_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 700
    },
    {
        name = "These Colors Don't Run",
        hash = `MP_MP_Biker_Tat_029_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 800
    },
    {
        name = "Feather Wings",
        hash = `MP_MP_Biker_Tat_030_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 750
    },
    {
        name = "Mum",
        hash = `MP_MP_Biker_Tat_031_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 400
    },
    {
        name = "Swooping Eagle",
        hash = `MP_MP_Biker_Tat_032_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 700
    },
    {
        name = "Eagle Emblem",
        hash = `MP_MP_Biker_Tat_042_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_TORSO",
        price = 650
    },

    -- HEAD/FACE Tattoos
    {
        name = "Clown",
        hash = `MP_MP_Biker_Tat_001_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_HEAD",
        price = 300
    },
    {
        name = "Skull",
        hash = `MP_MP_Biker_Tat_003_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_HEAD",
        price = 350
    },
    {
        name = "Snake Outline",
        hash = `MP_MP_Biker_Tat_009_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_HEAD",
        price = 300
    },
    {
        name = "Snake Shaded",
        hash = `MP_MP_Biker_Tat_010_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_HEAD",
        price = 350
    },
    {
        name = "Ride Free",
        hash = `MP_MP_Biker_Tat_011_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_HEAD",
        price = 400
    },

    -- LEFT ARM Tattoos
    {
        name = "Demon Crossbones",
        hash = `MP_MP_Biker_Tat_004_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_ARM",
        price = 400
    },
    {
        name = "Web Rider",
        hash = `MP_MP_Biker_Tat_006_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_ARM",
        price = 450
    },
    {
        name = "Dragon's Fury",
        hash = `MP_MP_Biker_Tat_008_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_ARM",
        price = 500
    },
    {
        name = "Ride or Die Shaded",
        hash = `MP_MP_Biker_Tat_022_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_ARM",
        price = 450
    },
    {
        name = "Macabre Tree",
        hash = `MP_MP_Biker_Tat_025_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_ARM",
        price = 550
    },
    {
        name = "Clawed Beast",
        hash = `MP_MP_Biker_Tat_035_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_ARM",
        price = 500
    },
    {
        name = "Bone Cruiser",
        hash = `MP_MP_Biker_Tat_039_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_ARM",
        price = 600
    },

    -- RIGHT ARM Tattoos
    {
        name = "Made In America",
        hash = `MP_MP_Biker_Tat_000_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_ARM",
        price = 400
    },
    {
        name = "Morbid Arachnid",
        hash = `MP_MP_Biker_Tat_002_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_ARM",
        price = 450
    },
    {
        name = "Cranium Rose",
        hash = `MP_MP_Biker_Tat_005_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_ARM",
        price = 400
    },
    {
        name = "Zooted Skull",
        hash = `MP_MP_Biker_Tat_007_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_ARM",
        price = 500
    },
    {
        name = "Poison Scorpion",
        hash = `MP_MP_Biker_Tat_014_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_ARM",
        price = 450
    },
    {
        name = "Bone Wrench",
        hash = `MP_MP_Biker_Tat_033_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_ARM",
        price = 400
    },
    {
        name = "Dagger Devil",
        hash = `MP_MP_Biker_Tat_048_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_ARM",
        price = 550
    },

    -- LEFT LEG Tattoos
    {
        name = "Engulfed Skull",
        hash = `MP_MP_Biker_Tat_013_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_LEG",
        price = 450
    },
    {
        name = "Scorched Soul",
        hash = `MP_MP_Biker_Tat_015_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_LEG",
        price = 500
    },
    {
        name = "Ride Hard Die Fast",
        hash = `MP_MP_Biker_Tat_027_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_LEG",
        price = 450
    },
    {
        name = "Bone Slinger",
        hash = `MP_MP_Biker_Tat_028_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_LEFT_LEG",
        price = 500
    },

    -- RIGHT LEG Tattoos
    {
        name = "Laughing Skull",
        hash = `MP_MP_Biker_Tat_012_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_LEG",
        price = 450
    },
    {
        name = "Smoking Skull",
        hash = `MP_MP_Biker_Tat_016_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_LEG",
        price = 400
    },
    {
        name = "Gruesome Talons",
        hash = `MP_MP_Biker_Tat_024_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_LEG",
        price = 500
    },
    {
        name = "Cranked Skull",
        hash = `MP_MP_Biker_Tat_037_M`,
        collection = `mpbiker_overlays`,
        zone = "ZONE_RIGHT_LEG",
        price = 450
    }
}
