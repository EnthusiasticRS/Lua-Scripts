-- Setup link: https://github.com/EnthusiasticRS/Lua-Scripts/
-- in progress, do not leave on over night

-- only tested with wilderness sword 3 and Explorer's ring 3 - make sure to have quick tp charges (vis wax)

local API = require("api")
local player = API.GetLocalPlayerName()
local startTime, afk = os.time(), os.time()
local location = 1

local IDS = {
    BANK_CHEST = {114750},
    HERB = {12172},
    HERB_PATCH_ALL = {8139, 8140, 8141, 8142, 8132, 7840, 18818},
    PICK_HERB = {8143, 18826},
    READY_HERB = {1882, 8139, 8140, 8141, 8142},
    DISEASED_HERB = {8144, 8145, 8146, 8147},
    PICK_SHROOM = {17795, 17796, 17797, 17798, 17799, 17800, 17801, 17802, 17803},
    PATCH_HERB = {7840, 8139, 8140, 8141, 8142, 18822, 18823, 18824, 18825},
    SHROOM_PATCH = {8311},
    PATCH_WEED = {8134, 8135, 8136, 8312, 8313, 8314, 8133, 8138, 18818, 18819, 18820, 18821},
    PLANT_CURE = {6036},
    HERB_SEED = {5296, 5293, 5292, 5294, 5295, 12176, 5297, 5298, 5299, 5300, 5301, 5302, 5303, 14870, 5304, 21621, 48201},
    BLOODWEED_SEED = {37952},
    MUSHROOOM_SEED = {21620, 5282},
    LEPRECHAUN = {3021, 3343, 4965, 7557, 7569, 8000, 20110},
    GRIMY = {199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 2485, 3049, 3051, 12174, 14836, 21626, 37975, 48243},
    TROLLHEIM_CAVE = {34395},
    TROLLHEIM_LADDER = {18834},
    WILDERNESS_SWORD = {37904, 37905, 37906, 37907}
}

local herbID = {
    GUAM = 199,
    MARRENTILL = 201,
    TARROMIN = 203,
    HARRALANDER = 205,
    RANARR = 207,
    IRIT = 209,
    AVANTOE = 211,
    KWUARM = 213,
    CADANTINE = 215,
    DWARF_WEED = 217,
    TORSTOL = 219,
    LANTADYME = 2485,
    TOADFLAX = 3049,
    SNAPDRAGON = 3051,
    SPIRIT_WEED = 12174,
    BLOODWEED = 37975,
}

local seedID = {
    GUAM = 5291,
    MARRENTILL = 5292,
    TARROMIN = 5293,
    HARRALANDER = 5294,
    RANARR = 5295,
    IRIT = 5297,
    AVANTOE = 5298,
    KWUARM = 5299,
    CADANTINE = 5301,
    DWARF_WEED = 5303,
    TORSTOL = 5304,
    LANTADYME = 5302,
    TOADFLAX = 5296,
    SNAPDRAGON = 5300,
    SPIRIT_WEED = 12176,
    BLOODWEED = 37952,
}

local compostID = {
    COMPOST = 6032,
    SUPERCOMPOST = 6034,
    ULTRACOMPOST = 43966,
}

local LOCATIONS = {
    WARS_RETREAT = {x1 = 3292, x2 = 3305, y1 = 10124, y2 = 10134},
    CABBAGE_FIELD = {x1 = 3043, x2 = 3068, y1 = 3283, y2 = 3315},
    ECTOPHUNTUS = {x1 = 3595, x2 = 3666, y1 = 3514, y2 = 3536},
    CAMELOT = {x1 = 2751, x2 = 2794, y1 = 3457, y2 = 3481},
    MANOR_FARM = {x1 = 2631, x2 = 2670, y1 = 3346, y2 = 3382},
    TROLLHEIM_1 = {x1 = 2852, x2 = 2893, y1 = 3661, y2 = 3689},
    TROLLHEIM_2 = {x1 = 2844, x2 = 2851, y1 = 3662, y2 = 3689},
    TROLLHEIM_3 = {x1 = 2821, x2 = 2840, y1 = 10050, y2 = 10095},
    TROLLHEIM_4 = {x1 = 2805, x2 = 2820, y1 = 3664, y2 = 3684},
    PRIFDDINAS = {x1 = 2204, x2 = 2254, y1 = 3356, y2 = 3389},
    AL_KHARID_1 = {x1 = 3288, x2 = 3308, y1 = 3180, y2 = 3222},
    AL_KHARID_2 = {x1 = 3300, x2 = 3324, y1 = 3222, y2 = 3286},
    AL_KHARID_3 = {x1 = 3310, x2 = 3321, y1 = 3286, y2 = 3314},
    WILDERNESS = {x1 = 3137, x2 = 3149, y1 = 3813, y2 = 3828},

    PATCHES = {
        DRAYNOR = {x1 = 3047, x2 = 3062, y1 = 3300, y2 = 3314},
        PHASMATYS = {x1 = 3603, x2 = 3616, y1 = 3525, y2 = 3535},
        CATHERBY = {x1 = 2770, x2 = 2797, y1 = 3459, y2 = 3466},
        ARDOUGNE = {x1 = 2656, x2 = 2671, y1 = 3365, y2 = 3380},
        TROLLHEIM = {x1 = 2805, x2 = 2820, y1 = 3664, y2 = 3684},
        PRIFDDINAS = {x1 = 2244, x2 = 2253, y1 = 3373, y2 = 3390},
        KHARID = {x1 = 3310, x2 = 3321, y1 = 3286, y2 = 3314},
        WILDERNESS = {x1 = 3137, x2 = 3149, y1 = 3813, y2 = 3828},
    }
}

-- script dialog
local function getDictKeys(dict)
    local herbNames = {}
    for i, v in pairs(dict) do
        table.insert(herbNames, i)
    end
    return herbNames
end

local selectedSeed = API.ScriptDialogWindow2(
    "Choose seed", getDictKeys(seedID), "Start", "Close").Name

local selectedCompost = API.ScriptDialogWindow2(
    "Which compost?", getDictKeys(compostID), "Start", "Close").Name

local seedAmount = API.ScriptDialogWindow2(
    "How many seeds per patch?", ({"1", "2", "4", "7", "10"}), "Start", "Close").Name
    local plantOption = ""
    if seedAmount == "1" then
        plantOption = 0x31
    elseif seedAmount == "2" then
        plantOption = 0x32
    elseif seedAmount == "4" then
        plantOption = 0x33
    elseif seedAmount == "7" then
        plantOption = 0x34
    elseif seedAmount == "10" then
        plantOption = 0x35
    end
-- end

-- functions
local function gotoTile(x, y, z) --random coord selection
    if x and y and z then
        math.randomseed(os.time())
        local offsetRange = 2

        local offsetX = math.random(-offsetRange, offsetRange)
        local offsetY = math.random(-offsetRange, offsetRange)

        local newX = x + offsetX
        local newY = y + offsetY

        API.DoAction_Tile(WPOINT.new(newX, newY, z))
    end
end

local function atLocation(loc) 
    return API.PInArea21(loc.x1, loc.x2, loc.y1, loc.y2)
end

local function teleportCabbageField()
    local tp = API.GetABs_name1("Explorer's ring 3")
    local tp2 = API.GetABs_name1("Explorer's ring 4")

    if tp.enabled then
        API.Log("Teleported to Cabbage Field")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(6000, 100, 600)
    elseif tp2.enabled then
        API.Log("Teleported to Cabbage Field")
        API.DoAction_Ability_Direct(tp2, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(6000, 100, 600)
    else
        API.ErrorLog("Could not find Explorer's ring 3 or 4")
    end
end

local function teleportEctophuntus()
    local tp = API.GetABs_name1("Ectophial")
    if tp.enabled then
        API.Log("Teleported to Ectophuntus")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(7500, 100, 600)
    else
        API.ErrorLog("Could not find Ectophial")
    end
end

local function teleportCamelot()
    local tp = API.GetABs_name1("Camelot Teleport")
    if tp.enabled then
        API.Log("Teleported to Camelot")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(4500, 100, 600)
    else
        API.ErrorLog("Could not find Camelot Teleport")
    end
end

local function teleportArdougne()
    local tp = API.GetABs_name1("Ardougne Lodestone")
    if tp.enabled then
        API.Log("Teleported to Ardougne")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(6000, 100, 600)
    else
        API.ErrorLog("Could not find Camelot Teleport")
    end
end

local function teleportTrollheim()
    local tp = API.GetABs_name1("Trollheim Teleport")
    if tp.enabled then
        API.Log("Teleported to Trollheim")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(4500, 100, 600)
    else
        API.ErrorLog("Could not find Camelot Teleport")
    end
end

local function teleportPrifddinas()
    local tp = API.GetABs_name1("Prifddinas Lodestone")
    if tp.enabled then
        API.Log("Teleported to Prifddinas")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(6000, 100, 600)
    else
        API.ErrorLog("Could not find Prifddinas Teleport")
    end
end

local function teleportAl_Kharid()
    local tp = API.GetABs_name1("Al Kharid Lodestone")
    if tp.enabled then
        API.Log("Teleported to Al Kharid")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(6000, 100, 600)
    else
        API.ErrorLog("Could not find Al Kharid teleport")
    end
end

local function teleportWilderness()
    if API.Compare2874Status(13, true) then
        API.KeyboardPress2(0x31, 60, 100)
        API.RandomSleep2(500, 100, 400)
        API.KeyboardPress2(0x32, 60, 100)
        API.RandomSleep2(3500, 100, 200)
    else 
        API.DoAction_Inventory1(IDS.WILDERNESS_SWORD, 0, 2, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 100, 200)
    end
end

local function teleportWars()
    local tp = API.GetABs_name1("War's Retreat Teleport")
    if tp.enabled then
        API.Log("Teleported to War's Retreat")
        API.DoAction_Ability_Direct(tp, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(5000, 100, 600)
    else
        API.ErrorLog("Could not find War's Teleport")
    end
end

local function bank()
    if atLocation(LOCATIONS.WARS_RETREAT) then
        if not API.ReadPlayerMovin2() then
            API.DoAction_Object1(0x33, API.OFF_ACT_GeneralObject_route3, IDS.BANK_CHEST, 50);
            API.RandomSleep2(3000, 100, 400)
        end
    elseif not atLocation(LOCATIONS.WARS_RETREAT) then
        teleportWars()
    end
end

local function atPatch()
    if atLocation(LOCATIONS.PATCHES.DRAYNOR) or
    atLocation(LOCATIONS.PATCHES.PHASMATYS) or
    atLocation(LOCATIONS.PATCHES.CATHERBY) or
    atLocation(LOCATIONS.PATCHES.ARDOUGNE) or
    atLocation(LOCATIONS.PATCHES.TROLLHEIM) or
    atLocation(LOCATIONS.PATCHES.PRIFDDINAS) or
    atLocation(LOCATIONS.PATCHES.WILDERNESS) or
    atLocation(LOCATIONS.PATCHES.KHARID) then
        return true
    end
    return false
end

local function foundCompost()
    if API.ChatFind("You treat the herb patch with supercompost.", 2).pos_found > 0 or
    API.ChatFind("You treat the farming patch with supercompost.", 2).pos_found > 0 or
    API.ChatFind("This herb patch has already been treated with supercompost.", 2).pos_found > 0 or
    API.ChatFind("This farming patch has already been treated with supercompost.", 2).pos_found > 0
    then
        return true

    elseif API.ChatFind("You treat the herb patch with ultracompost.", 2).pos_found > 0 or
    API.ChatFind("You treat the farming patch with ultracompost.", 2).pos_found > 0 or
    API.ChatFind("This herb patch has already been treated with ultracompost.", 2).pos_found > 0 or
    API.ChatFind("This farming patch has already been treated with ultracompost.", 2).pos_found > 0
    then
        return true

    elseif API.ChatFind("You treat the herb patch with compost.", 2).pos_found > 0 or
    API.ChatFind("You treat the farming patch with compost.", 2).pos_found > 0 or
    API.ChatFind("This herb patch has already been treated with compost.", 2).pos_found > 0 or
    API.ChatFind("This farming patch has already been treated with compost.", 2).pos_found > 0
    then
        return true

    else
        return false
    end
end

local function foundWeeds()
    local distance = 20
    local weeds = API.GetAllObjArray1(IDS.PATCH_WEED, distance, {0})
    if #weeds > 0 then
        for _, v in ipairs(weeds) do
            if v.Action == "Rake" then
                return true
            end
        end
    end
    return false
end

local function foundHerbs()
    local distance = 20
    local herbs = API.GetAllObjArray1(IDS.PATCH_HERB, distance, {0})
    if #herbs > 0 then
        for _, v in ipairs(herbs) do
            return true
        end
    end
    return false
end

local function foundReadyHerbs()
    local distance = 25
    local herbs = API.GetAllObjArray1(IDS.PICK_HERB, distance, {0})
    if #herbs > 0 then
        for _, v in ipairs(herbs) do
            return true
        end
    end
    return false
end

local function foundDiseasedHerbs()
    local distance = 20
    local herbs = API.GetAllObjArray1(IDS.DISEASED_HERB, distance, {0})
    if #herbs > 0 then
        for _, v in ipairs(herbs) do
            return true
        end
    end
    return false
end

local function shouldPlant()
    if foundCompost() and not foundWeeds() and not foundHerbs() then
        return true
    end
    return false
end

local function shouldCompost()
    if not foundWeeds() and not foundCompost() and not foundReadyHerbs() and not foundHerbs() then
        return true
    end 
    return false
end

local function clearWeeds()
    if not API.IsPlayerAnimating_(player, 10) then
        API.Log("Clearing weeds")
        API.DoAction_Object1(0x29,API.OFF_ACT_GeneralObject_route0, IDS.PATCH_WEED, 50);
        API.RandomSleep2(5000, 100, 400)
    end
end

local function clearDiseased()
    local chatOption = 8

    if API.Check_Dialog_Open() and not API.ReadPlayerMovin2() then
        API.KeyboardPress2(0x31, 60, 100)
        API.RandomSleep2(3000, 200, 600)
    else
        API.Log("Clearing diseased herbs")
        API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route2, IDS.DISEASED_HERB, 50);
        API.RandomSleep2(4500, 200, 600)
    end
end

local function harvestHerbs()
    if not API.IsPlayerAnimating_(player, 25) then
        API.Log("Harvesting herbs")
        API.DoAction_Object1(0x2d, API.OFF_ACT_GeneralObject_route0, IDS.PICK_HERB, 50);
        API.RandomSleep2(5000, 100, 400)
    end
end

local function useCompost()
    local compost = compostID[selectedCompost]
    if not foundCompost() and not API.ReadPlayerMovin2() then
        API.Log("Used compost")
        API.DoAction_Inventory1(compost, 0, 0, API.OFF_ACT_Bladed_interface_route)
        API.RandomSleep2(500, 100, 200)
        API.DoAction_Object1(0x24, API.OFF_ACT_GeneralObject_route00, IDS.HERB_PATCH_ALL, 50);
        API.RandomSleep2(3000, 100, 400)
    end
end

local function plantSeeds()
    local seed = seedID[selectedSeed]
    local seedStackSize = API.InvStackSize(seed)

    if location == 8 then
        seed = IDS.BLOODWEED_SEED
    end
    
    if API.Compare2874Status(13, true) then
        location = location + 1
        API.RandomSleep2(1000, 100, 400)
        API.KeyboardPress2(plantOption, 60, 100)
        API.Log("Planted seeds")
        API.RandomSleep2(3000, 100, 400)
    else
        API.DoAction_Inventory1(seed, 0, 0, API.OFF_ACT_Bladed_interface_route)
        API.RandomSleep2(800, 200, 400)
        API.DoAction_Object1(0x24, API.OFF_ACT_GeneralObject_route00, IDS.HERB_PATCH_ALL, 50);
    end
end

local function noteHerbs()
    local herbs = API.InvItemcount_2(IDS.GRIMY)
    if #herbs > 0 and not API.ReadPlayerMovin2() then
        API.DoAction_Inventory1(IDS.GRIMY, 0, 0, API.OFF_ACT_Bladed_interface_route)
        API.RandomSleep2(1000, 100, 400)
        API.DoAction_NPC(0x24, API.OFF_ACT_BladedDiveNPC_route, IDS.LEPRECHAUN, 50)
        API.RandomSleep2(1500, 100, 400)
    end
end

local function walk()
    local compid = compostID[selectedCompost]
    local compost = API.InvItemcount_2(compid)

    if compost < 1 and not atPatch() then
        bank()
        goto continue
    elseif location == 9 and compost < 8 then
        bank()
        goto continue
    elseif location == 9 and compost >= 8 then
        location = 1
    end

    if location == 1 then
        if atLocation(LOCATIONS.CABBAGE_FIELD) and not API.ReadPlayerMovin2() and not atPatch() then
            gotoTile(3057, 3310, 0)
            API.RandomSleep2(1000, 100, 400)

        elseif not atLocation(LOCATIONS.CABBAGE_FIELD) then
            teleportCabbageField()
        end

    elseif location == 2 then
        if atLocation(LOCATIONS.ECTOPHUNTUS) and not API.ReadPlayerMovin2() and not atPatch() then
            gotoTile(3607, 3531, 0)
            API.RandomSleep2(1000, 100, 400)

        elseif not atLocation(LOCATIONS.ECTOPHUNTUS) then
            teleportEctophuntus()
        end

    elseif location == 3 then
        if atLocation(LOCATIONS.CAMELOT) and not API.ReadPlayerMovin2() and not atPatch() then
            gotoTile(2790, 3463, 0)
            API.RandomSleep2(1000, 100, 400)

        elseif not atLocation(LOCATIONS.CAMELOT) then
            teleportCamelot()
        end

    elseif location == 4 then
        if atLocation(LOCATIONS.MANOR_FARM) and not API.ReadPlayerMovin2() and not atPatch() then
            gotoTile(2665, 3374, 0)
            API.RandomSleep2(1000, 100, 400)

        elseif not atLocation(LOCATIONS.MANOR_FARM) then
            teleportArdougne()
        end

    elseif location == 5 then
        if atLocation(LOCATIONS.TROLLHEIM_1) and not API.ReadPlayerMovin2() then
            gotoTile(2846, 3667, 0)
            API.RandomSleep2(1000, 100, 400)

        elseif atLocation(LOCATIONS.TROLLHEIM_2) and not API.ReadPlayerMovin2() then
            API.DoAction_Object1(0x39, API.OFF_ACT_GeneralObject_route0, IDS.TROLLHEIM_CAVE, 50);
            API.RandomSleep2(8500, 100, 600)

        elseif atLocation(LOCATIONS.TROLLHEIM_3) and not API.ReadPlayerMovin2() then
            API.DoAction_Object1(0x34, API.OFF_ACT_GeneralObject_route0, IDS.TROLLHEIM_LADDER, 50);
            API.RandomSleep2(1000, 100, 400)

        elseif not atLocation(LOCATIONS.TROLLHEIM_1) and not atLocation(LOCATIONS.TROLLHEIM_2) and not atLocation(LOCATIONS.TROLLHEIM_3) and not atLocation(LOCATIONS.TROLLHEIM_4) then
            teleportTrollheim()
        end

    elseif location == 6 then
        if atLocation(LOCATIONS.PRIFDDINAS) and not API.ReadPlayerMovin2() and not atPatch() then
            gotoTile(2247, 3379, 0)
            API.RandomSleep2(1000, 100, 400)

        elseif not atLocation(LOCATIONS.PRIFDDINAS) then
            teleportPrifddinas()
        end

    elseif location == 7 then
        if atLocation(LOCATIONS.AL_KHARID_1) and not API.ReadPlayerMovin2() then
            gotoTile(3305, 3230, 0)
            API.RandomSleep2(1000, 100, 400)

        elseif atLocation(LOCATIONS.AL_KHARID_2) and not API.ReadPlayerMovin2() then
            gotoTile(3318, 3295, 0)
            API.RandomSleep2(3000, 100, 400)

        elseif not atLocation(LOCATIONS.AL_KHARID_1) and not atLocation(LOCATIONS.AL_KHARID_2) and not atLocation(LOCATIONS.AL_KHARID_3) then
            teleportAl_Kharid()
        end
    
    elseif location == 8 then
        if not atLocation(LOCATIONS.WILDERNESS) then
            teleportWilderness()
        end
    end
    ::continue::
end
--

API.SetDrawLogs(true)
API.SetDrawTrackedSkills(true)

while API.Read_LoopyLoop() do
    walk()

    if atPatch() then
        if not API.InvFull_() then
            if foundReadyHerbs() then
                harvestHerbs()
            elseif foundDiseasedHerbs() then
                clearDiseased()
            elseif foundWeeds() then
                clearWeeds()
            elseif shouldCompost() then
                useCompost()
            elseif shouldPlant() then
                plantSeeds()
            end
        else
            noteHerbs()
        end
    end

    API.RandomSleep2(400, 100, 200)
end

API.SetDrawLogs(false)
API.SetDrawTrackedSkills(false)
