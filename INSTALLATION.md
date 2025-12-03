# 📦 ESX Tattoo Shop - Installation Checklist

## ✅ Pre-Installation Requirements

- [ ] ESX Legacy v1.10.0+ installed
- [ ] ox_lib v3.0.0+ installed
- [ ] ox_target installed
- [ ] oxmysql v2.0.0+ installed
- [ ] MySQL/MariaDB database running

---

## 📋 Installation Steps

### 1️⃣ File Setup
- [ ] Download/clone esx_tattooshop
- [ ] Place in `resources/[standalone]/esx_tattooshop/`
- [ ] Verify all files are present:
  - [ ] fxmanifest.lua
  - [ ] config.lua
  - [ ] tattoos.sql
  - [ ] job_tattoo_artist.sql
  - [ ] README.md
  - [ ] client/ folder (main.lua, ui.lua)
  - [ ] server/ folder (main.lua)
  - [ ] shared/ folder (tattoos.lua)
  - [ ] html/ folder (index.html, style.css, script.js)

### 2️⃣ Database Setup
- [ ] Import `tattoos.sql` into your ESX database
  - Creates `user_tattoos` table
- [ ] Import `job_tattoo_artist.sql` into your ESX database
  - Creates `tattoo_artist` job with 4 grades

**Verification SQL:**
```sql
SHOW TABLES LIKE 'user_tattoos';
SELECT * FROM jobs WHERE name = 'tattoo_artist';
SELECT * FROM job_grades WHERE job_name = 'tattoo_artist';
```

### 3️⃣ Server Configuration
- [ ] Add to `server.cfg`:
```cfg
ensure oxmysql
ensure ox_lib
ensure ox_target
ensure es_extended
ensure esx_tattooshop
```

- [ ] Verify loading order (dependencies first)

### 4️⃣ Resource Configuration
- [ ] Edit `config.lua` if needed:
  - [ ] Job name: `Config.TattooJob`
  - [ ] Job requirement: `Config.RequireJob`
  - [ ] Prices: `Config.Prices`
  - [ ] Tattoo duration: `Config.TattooProcess.duration`
  - [ ] Shop locations: `Config.TattooShops`
  - [ ] Translations: `Config.Locale`

### 5️⃣ Job Assignment (Optional)
- [ ] Give yourself tattoo_artist job:

**In-game (F8 console with admin permissions):**
```
/setjob [playerid] tattoo_artist 3
```

**Or via SQL:**
```sql
UPDATE users 
SET job = 'tattoo_artist', job_grade = 3 
WHERE identifier = 'YOUR_IDENTIFIER';
```

### 6️⃣ Server Restart
- [ ] Restart your FiveM server
- [ ] Or use: `restart esx_tattooshop`

---

## 🧪 Testing Checklist

### Basic Functionality
- [ ] Resource starts without errors
- [ ] No console errors (F8)
- [ ] Blips appear on map (5 tattoo shops)

### Job System
- [ ] ox_target shows "Tattoo-Menü öffnen" when targeting player (as tattoo_artist)
- [ ] Menu does NOT show without tattoo_artist job (if RequireJob = true)
- [ ] Menu shows correctly with tattoo_artist job

### UI & Menus
- [ ] Custom UI opens when selecting target option
- [ ] 6 body zones display correctly
- [ ] Tattoo counts show for each zone
- [ ] Clicking zone shows tattoos
- [ ] Back button works
- [ ] Close button (X) works
- [ ] ESC key closes UI

### Tattoo System
- [ ] Selecting tattoo shows preview on target player
- [ ] Preview appears immediately
- [ ] Confirm button applies tattoo permanently
- [ ] Cancel/Back removes preview
- [ ] Price displays correctly

### Payment System
- [ ] Customer pays correct amount
- [ ] Artist receives payment
- [ ] "Not enough money" error if insufficient funds
- [ ] Transaction notifications appear

### Progress & Animation
- [ ] 15-second progress bar appears
- [ ] Animation plays during application
- [ ] "Tätowierung wird gestochen..." message shows
- [ ] Tattoo applied after progress completes

### Persistence
- [ ] Tattoos save to database
- [ ] Tattoos load after relog
- [ ] Tattoos persist after respawn
- [ ] Multiple tattoos can be applied

### Visual Verification
- [ ] Tattoos visible on MP Male ped
- [ ] Tattoos visible on MP Female ped
- [ ] No tattoos on non-MP peds (expected behavior)
- [ ] Tattoos don't conflict with clothing

---

## ❌ Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Resource won't start | Check dependencies are loaded first |
| Console errors | Check F8 console, verify all files exist |
| UI doesn't open | Clear FiveM cache: `%localappdata%/FiveM/` |
| Tattoos invisible | Must use MP Male/Female ped, check clothing |
| Job check fails | Verify job in database, restart ESX |
| Database errors | Import both SQL files, check oxmysql connection |
| Target not showing | Ensure ox_target installed and started |

---

## 📝 Final Checklist

- [ ] All tests passed
- [ ] No console errors
- [ ] Config customized to your server
- [ ] SQL imported successfully
- [ ] Documentation reviewed
- [ ] Backup created (recommended)

---

## 🎉 Installation Complete!

Your tattoo shop is now ready! 

**Default shop locations:**
- Vespucci Beach
- Vinewood
- Harmony
- Sandy Shores
- Paleto Bay

**Need help?** Check README.md for troubleshooting and support links.

---

**Made with ❤️ by ELBaron**
