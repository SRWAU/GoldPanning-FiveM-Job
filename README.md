# FiveM Gold Panning Script

A feature-rich gold panning script for FiveM servers running ESX Legacy. Players can pan for resources in a designated river zone using a gold pan, with interactive `ox_target` zones, a progress bar, a skill check minigame, and a looping `dpemotes` "mechanic3" animation. The script supports item-based panning, a fallback keybind (F key), and a test command (`/use_goldpan`). Rewards include gold nuggets, stones, diamonds, and rubber, with configurable probabilities.

## Features
- **Static Panning Zone**: One configurable zone (default: `vector3(-180.3673, 3060.1082, 18.3487)`) for gold panning.
- **ox_target Integration**: Interactive "Pan for Gold" prompt within the zone.
- **Progress Bar**: 5-second panning process with `progressBars`.
- **Skill Check Minigame**: Press a random key (E, F, or G) within 1.5 seconds to succeed.
- **dpemotes Animation**: Uses the "mechanic3" emote (`anim@amb@clubhouse@tutorial@bkr_tut_ig3@`, `machinic_loop_mechandplayer`) for a realistic panning motion.
- **Loot System**: Configurable loot table with `gold_nugget`, `stone`, `diamond`, and `rubber`.
- **Item Requirement**: Requires a `goldpan` item (configurable).
- **Keybind**: Press **F** to pan if the `goldpan` item fails (fallback).
- **Command**: `/use_goldpan` for testing or admin use.
- **Notification Cooldown**: Prevents spamming "You need a gold pan" messages (5-second cooldown).
- **Database Integration**: Automatically ensures all items (`goldpan`, rewards) are in the `items` table.
- **Debug Logging**: Extensive client and server logs for troubleshooting.

## Requirements
- **FiveM Server** with ESX Legacy (`ESXLegacy_2C03ED` or compatible).
- **Dependencies**:
  - `ox_target`
  - `es_extended`
  - `progressBars`
  - `mysql-async`
  - `dpemotes`

## Installation
1. **Download the Script**:
   - Clone or download this repository to your server’s resources folder:
     ```bash
     git clone https://github.com/yourusername/goldpanning.git
     ```

2. **Place Files**:
   - Copy the `goldpanning` folder to:
     ```
     C:/Users/Seth/Desktop/DEV/txData/ESXLegacy_2C03ED.base/resources/
     ```

3. **Update Database**:
   - Add required items to the `items` table:
     ```sql
     INSERT INTO items (name, label, weight, usable) VALUES
     ('goldpan', 'Gold Pan', 1, 1),
     ('gold_nugget', 'Gold Nugget', 1, 0),
     ('stone', 'Stone', 1, 0),
     ('diamond', 'Diamond', 1, 0),
     ('rubber', 'Rubber', 1, 0);
     ```

4. **Configure `server.cfg`**:
   - Add to `C:/Users/Seth/Desktop/DEV/txData/ESXLegacy_2C03ED.base/server.cfg`:
     ```cfg
     ensure mysql-async
     ensure ox_target
     ensure es_extended
     ensure progressBars
     ensure dpemotes
     ensure goldpanning
     ```

5. **Clear Cache**:
   - Delete the `cache/` folder in:
     ```
     C:/Users/Seth/Desktop/DEV/txData/ESXLegacy_2C03ED.base/
     ```

6. **Restart Server**:
   - Run in the server console:
     ```
     refresh
     ensure mysql-async
     ensure ox_target
     ensure es_extended
     ensure progressBars
     ensure dpemotes
     ensure goldpanning
     ```

## Configuration
All settings are in `config.lua`. Below are the available options:

### Panning Zones
- **`Config.PanningZones`**:
  - Defines static panning zones.
  - **Default**:
    ```lua
    Config.PanningZones = {
        {
            coords = vector3(-180.3673, 3060.1082, 18.3487), -- Near a river
            radius = 20.0,
            name = 'panning_zone_1'
        }
    }
    ```
  - **Options**:
    - `coords`: Zone center (use river coordinates).
    - `radius`: Zone size (meters).
    - `name`: Unique identifier for `ox_target`.

### Item Requirement
- **`Config.RequiredItem`**:
  - Item needed to pan (set to `nil` to disable).
  - **Default**: `'goldpan'`.

- **`Config.ItemUseZoneRadius`**:
  - Radius for item use and keybind checks (must match zone radius).
  - **Default**: `20`.

### Loot Table
- **`Config.LootTable`**:
  - Defines rewards and probabilities (must sum to 1.0).
  - **Default**:
    ```lua
    Config.LootTable = {
        { item = 'gold_nugget', chance = 0.3, min = 1, max = 3 },
        { item = 'stone', chance = 0.4, min = 1, max = 5 },
        { item = 'diamond', chance = 0.1, min = 1, max = 1 },
        { item = 'rubber', chance = 0.2, min = 1, max = 2 }
    }
    ```
  - **Options**:
    - `item`: Item name in `items` table.
    - `chance`: Probability (0.0 to 1.0).
    - `min`, `max`: Quantity range.

### Panning Settings
- **`Config.PanningDuration`**:
  - Panning duration in milliseconds.
  - **Default**: `5000` (5 seconds).

- **`Config.PanningAnimation`**:
  - Animation for panning (uses `dpemotes` "mechanic3").
  - **Default**:
    ```lua
    Config.PanningAnimation = {
        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        anim = 'machinic_loop_mechandplayer'
    }
    ```

### Blip Settings
- **`Config.Blip`**:
  - Blip for the panning zone.
  - **Default**:
    ```lua
    Config.Blip = {
        sprite = 605,
        color = 0,
        scale = 0.8,
        name = 'Gold Panning'
    }
    ```
  - **Options**:
    - `sprite`: Blip icon ID.
    - `color`: Blip color ID.
    - `scale`: Blip size.
    - `name`: Blip label.

### Skill Check Settings
- **`Config.SkillCheck`**:
  - Configures the skill check minigame.
  - **Default**:
    ```lua
    Config.SkillCheck = {
        Keys = {'E', 'F', 'G'},
        KeyMap = {
            ['E'] = 38,
            ['F'] = 23,
            ['G'] = 47
        },
        TimeWindow = 1500
    }
    ```
  - **Options**:
    - `Keys`: Possible keys to press.
    - `KeyMap`: Control IDs for keys.
    - `TimeWindow`: Time to press the key (ms).

## Keybinds
- **F Key** (Control ID 23):
  - Triggers panning in the zone if the player has a `goldpan`.
  - Fallback for inventory item issues.
- **Skill Check Keys**:
  - **E** (Control ID 38), **F** (Control ID 23), **G** (Control ID 47).
  - Press the prompted key during the skill check to succeed.

## Commands
- **`/use_goldpan`**:
  - Triggers panning in the zone (requires `goldpan`).
  - Useful for testing or admin use.
  - No permissions required.

## Usage
1. **Obtain a Gold Pan**:
   - **Admin Command**:
     ```bash
     /giveitem [player_id] goldpan 1
     ```
   - **Shop** (add to `esx_shops`):
     ```sql
     INSERT INTO shop_items (shop_id, item, price) VALUES
     ((SELECT id FROM shops WHERE name = 'TwentyFourSeven'), 'goldpan', 100);
     ```
   - **Player Spawn** (add to `es_extended/server/main.lua`):
     ```lua
     RegisterNetEvent('esx:playerLoaded')
     AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
         xPlayer.addInventoryItem('goldpan', 1)
     end)
     ```

2. **Go to the Panning Zone**:
   - Find the blip at `vector3(-180.3673, 3060.1082, 18.3487)`.
   - Ensure it’s near a river (adjust `Config.PanningZones` if needed).

3. **Pan for Gold**:
   - **ox_target**: Interact with the "Pan for Gold" prompt (requires `goldpan`).
   - **Item**: Use the `goldpan` item from inventory.
   - **Keybind**: Press **F** in the zone.
   - **Command**: Run `/use_goldpan`.

4. **Complete the Skill Check**:
   - Watch for a prompt (e.g., "Press [E]!").
   - Press the correct key (E, F, or G) within 1.5 seconds.
   - Success grants a random reward; failure shows a notification.

## Troubleshooting
- **Item Use Issues**:
  - Check server console for `[DEBUG] Player X used goldpan item`.
  - Use `/use_goldpan` or F key as fallbacks.
  - Share your inventory system (e.g., `esx_inventoryhud`).
- **Animation Issues**:
  - Ensure `dpemotes` is running (`ensure dpemotes`).
  - Test with `/e mechanic3` to verify the animation.
- **Zone Issues**:
  - Confirm the zone is accessible and not underground.
  - Adjust `coords` in `Config.PanningZones` if needed.
- **Logs**:
  - Enable debug prints in `client.lua` and `server.lua` for detailed logs.
- **Dependencies**:
  - Verify all dependencies are running (`mysql-async`, `ox_target`, `es_extended`, `progressBars`, `dpemotes`).

## Contributing
Feel free to submit issues or pull requests on GitHub. Please include:
- Server logs (client and server).
- Inventory system details.
- FiveM artifact version.

## License
MIT License. See `LICENSE` for details.

## Credits
- Built for ESX Legacy with `ox_target` and `dpemotes`.
- Animation: `dpemotes` "mechanic3".ading README.markdown…]()
