# 🎨 ESX Tattoo -  Tattoo System

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Framework](https://img.shields.io/badge/framework-ESX%20Legacy-red.svg)



[Features](#-features) • [Installation](#-installation) • [Configuration](#-configuration) • [Usage](#-usage) • [Support](#-support)

</div>

---

## 📋 Features

### Core Features
- ✅ **Custom Modern UI** - Beautiful glassmorphism design with smooth animations
- ✅ **ox_target Integration** - Intuitive player targeting system
- ✅ **37 Tattoos** - Complete mpbiker_overlays collection
- ✅ **6 Body Zones** - Head, Torso, Arms (L/R), Legs (L/R)
- ✅ **Preview System** - Try before you buy with live preview
- ✅ **Persistent Storage** - MySQL database saves all tattoos
- ✅ **Payment System** - Money transfer between customer and artist
- ✅ **Job Restriction** - Only tattoo_artist job can tattoo (configurable)
- ✅ **Progress Bar** - Animated tattoo application process
- ✅ **Multi-Language Ready** - Easy locale customization

### Technical Features
- 🔧 Built with ox_lib, ox_target, oxmysql
- 🎯 Job-based access control
- 💾 Optimized database queries
- 🎨 Responsive UI design
- 🔄 Real-time tattoo preview
- 📱 NUI callbacks for smooth Lua ↔ JS communication

---

## 📦 Requirements

Before installing, ensure you have these dependencies installed:

| Dependency | Version | Required |
|------------|---------|----------|
| [es_extended](https://github.com/esx-framework/esx_core) | v1.10.0+ | ✅ Yes |
| [ox_lib](https://github.com/overextended/ox_lib) | v3.0.0+ | ✅ Yes |
| [ox_target](https://github.com/overextended/ox_target) | Latest | ✅ Yes |
| [oxmysql](https://github.com/overextended/oxmysql) | v2.0.0+ | ✅ Yes |

---

## 🚀 Installation

### Step 1: Download & Extract
```bash
# Clone or download this repository
git clone https://github.com/yourusername/esx_tattooshop.git

# Place the folder in your resources directory
resources/[standalone]/esx_tattooshop/
```

### Step 2: Database Setup
Import both SQL files into your ESX database:

```sql
-- 1. Import the tattoo table
mysql -u root -p your_database < tattoos.sql

-- 2. Import the tattoo_artist job
mysql -u root -p your_database < job_tattoo_artist.sql
```

**Or manually in PhpMyAdmin/HeidiSQL:**
1. Open your database
2. Import `tattoos.sql` (creates `user_tattoos` table)
3. Import `job_tattoo_artist.sql` (creates `tattoo_artist` job with 4 grades)

### Step 3: Resource Configuration
Add to your `server.cfg`:

```cfg
ensure oxmysql
ensure ox_lib
ensure ox_target
ensure es_extended

# Add tattoo shop AFTER dependencies
ensure esx_tattooshop
```

### Step 4: Assign Job (Optional)
Give yourself or players the tattoo artist job:

```sql
-- In-game F8 console (if you have permissions):
/setjob [playerid] tattoo_artist 3

-- Or via SQL:
UPDATE users SET job = 'tattoo_artist', job_grade = 3 WHERE identifier = 'YOUR_IDENTIFIER';
```

### Step 5: Restart Server
```bash
restart esx_tattooshop
# Or full restart for first installation
```

---

## ⚙️ Configuration

Edit `config.lua` to customize the script:

### Job Settings
```lua
Config.TattooJob = 'tattoo_artist'  -- Job required to open menu
Config.RequireJob = true            -- false = anyone can tattoo
```

### Pricing Per Zone
```lua
Config.Prices = {
    ZONE_TORSO = 500,      -- Chest/Back tattoos
    ZONE_HEAD = 300,       -- Face/Neck tattoos
    ZONE_LEFT_ARM = 400,   -- Left arm tattoos
    ZONE_RIGHT_ARM = 400,  -- Right arm tattoos
    ZONE_LEFT_LEG = 450,   -- Left leg tattoos
    ZONE_RIGHT_LEG = 450   -- Right leg tattoos
}
```

### Tattoo Process
```lua
Config.TattooProcess = {
    duration = 15000,  -- Milliseconds (15 seconds)
    animation = {
        dict = "amb@world_human_bum_wash@male@low@idle_a",
        anim = "idle_a",
        flag = 1
    },
    progressLabel = "Tätowierung wird gestochen..."
}
```

### Shop Locations
5 default locations included. Add/remove as needed:
```lua
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
    -- Add more locations...
}
```

### Locale (Translations)
```lua
Config.Locale = {
    no_permission = "Du bist kein Tätowierer!",
    no_target = "Kein Spieler in der Nähe!",
    -- Customize all messages...
}
```

---

## 🎮 Usage

### For Tattoo Artists (Players with Job)
1. **Target a Player** - Aim at any player and press target key (default: Left Alt)
2. **Select "Tattoo-Menü öffnen"** - Opens the custom UI
3. **Choose Body Zone** - Select from 6 available zones
4. **Pick a Tattoo** - Browse available tattoos with prices
5. **Preview** - Tattoo appears on target player temporarily
6. **Confirm or Cancel** - Buy to apply permanently, or cancel to remove preview
7. **Payment** - Customer pays, artist receives the money
8. **Application** - 15-second animation applies the tattoo

### For Customers
- Stand still while the tattoo artist selects your tattoo
- You'll see the preview on your character
- Confirm to pay and receive your permanent tattoo
- Tattoos persist through relog and respawn

---

## 📁 File Structure

```
esx_tattooshop/
├── 📄 fxmanifest.lua          # Resource manifest
├── 📄 config.lua              # All configuration options
├── 📄 tattoos.sql             # Database table schema
├── 📄 job_tattoo_artist.sql   # Job creation SQL
├── 📄 README.md               # This file
│
├── 📁 client/
│   ├── main.lua               # Core client logic & ox_target
│   └── ui.lua                 # NUI callbacks & UI handler
│
├── 📁 server/
│   └── main.lua               # Server events, payment, database
│
├── 📁 shared/
│   └── tattoos.lua            # Tattoo database (37 tattoos)
│
└── 📁 html/
    ├── index.html             # UI structure
    ├── style.css              # Modern styling
    └── script.js              # UI logic & NUI communication
```

---

## 🎨 Tattoo Collection

**37 Tattoos** from the **mpbiker_overlays** collection:

### By Zone
- **Head (ZONE_HEAD)**: 7 tattoos
- **Torso (ZONE_TORSO)**: 11 tattoos
- **Left Arm (ZONE_LEFT_ARM)**: 7 tattoos
- **Right Arm (ZONE_RIGHT_ARM)**: 7 tattoos
- **Left Leg (ZONE_LEFT_LEG)**: 2 tattoos
- **Right Leg (ZONE_RIGHT_LEG)**: 3 tattoos

**Examples:**
- Western Skull, Dagger, Rose, Web Scrollwork
- Lady Liberty, Mum, Feather, Snake, Eagle
- Love Hate, Brotherhood, R.I.P., Tall Ship
- And 26 more unique designs!

---

## 🔧 Troubleshooting

### Common Issues

**❌ "Error: ox_target not found"**
- Install [ox_target](https://github.com/overextended/ox_target)
- Add `ensure ox_target` to server.cfg

**❌ "Error: ox_lib not found"**
- Install [ox_lib](https://github.com/overextended/ox_lib)
- Add `ensure ox_lib` to server.cfg

**❌ Tattoos don't show on player**
- Player must use MP Male (`mp_m_freemode_01`) or MP Female (`mp_f_freemode_01`) ped
- Clothing may cover tattoos - try changing outfit
- Restart resource: `restart esx_tattooshop`

**❌ UI doesn't open**
- Check F8 console for JavaScript errors
- Ensure `ui_page` is set in fxmanifest.lua
- Clear FiveM cache: `%localappdata%/FiveM/FiveM.app/cache/`

**❌ Job restriction not working**
- Verify job name matches: `SELECT * FROM jobs WHERE name = 'tattoo_artist'`
- Check player job: `SELECT job FROM users WHERE identifier = 'YOUR_ID'`
- Set `Config.RequireJob = false` to disable job check

**❌ Database errors**
- Import both SQL files: `tattoos.sql` and `job_tattoo_artist.sql`
- Check oxmysql connection string in server.cfg
- Verify table exists: `SHOW TABLES LIKE 'user_tattoos'`

---


## 🌟 Credits

**Developed by**: ELBaron  
**Framework**: ESX Legacy  
**UI Design**: Custom Glassmorphism Theme  
**Dependencies**: ox_lib, ox_target, oxmysql  

--- 

## 📝 Changelog

### Version 1.0.0 (December 2025)
- ✨ Initial release
- ✅ Custom modern UI with glassmorphism design
- ✅ ox_target integration
- ✅ 37 tattoos from mpbiker_overlays
- ✅ 6 body zones
- ✅ Preview system
- ✅ Payment system
- ✅ MySQL persistence
- ✅ Job-based access control

---

<div align="center">

❤️ by ELBaron

</div>

