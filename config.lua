Config = {}

-- Panning zones (coordinates and radius)
Config.PanningZones = {
    {
        coords = vector3(-180.3673, 3060.1082, 18.3487), -- Example coords (near a river)
        radius = 20.0,
        name = 'panning_zone_1'
    }
}

-- Required item to start panning via ox_target (set to nil to disable)
Config.RequiredItem = 'goldpan'

-- Radius for item use zone check
Config.ItemUseZoneRadius = 20

-- Loot table with probabilities
Config.LootTable = {
    { item = 'gold_nugget', chance = 0.3, min = 1, max = 3 },
    { item = 'stone', chance = 0.4, min = 1, max = 5 },
    { item = 'diamond', chance = 0.1, min = 1, max = 1 },
    { item = 'rubber', chance = 0.2, min = 1, max = 2 }
}

-- Panning settings
Config.PanningDuration = 5000
Config.PanningAnimation = {
    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 
    anim = 'machinic_loop_mechandplayer'
}

-- Blip settings
Config.Blip = {
    sprite = 605,
    color = 0,
    scale = 0.8,
    name = 'Gold Panning'
}

-- Skill check settings
Config.SkillCheck = {
    Keys = {'E', 'F', 'G'}, -- Possible keys to press
    KeyMap = { -- Map keys to control IDs
        ['E'] = 38,
        ['F'] = 23,
        ['G'] = 47
    },
    TimeWindow = 1500 -- Time to press the key (in milliseconds)
}