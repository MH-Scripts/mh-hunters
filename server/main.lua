--[[ ===================================================== ]] --
--[[           MH AI Hunters Script by MaDHouSe            ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local isbusy = false

local function CountCops()
    local online = 0
    for k, id in pairs(QBCore.Functions.GetPlayers()) do
        local target = QBCore.Functions.GetPlayer(id)
        if target.PlayerData.job.name == "police" and target.PlayerData.job.onduty then
            online = online + 1
        end
    end
    return online
end

RegisterServerEvent('mh-hunters:server:start', function(amount)
    local src = source
    if amount > Config.MaxVehicleSpawn then amount = Config.MaxVehicleSpawn end
    local countCops = CountCops()
    if Config.UseHunters then
        if Config.EnableIfNoCopsOnline then
            if countCops == 0 then TriggerClientEvent("mh-hunters:client:startHunt", src, amount) end
        else
            TriggerClientEvent("mh-hunters:client:startHunt", src, amount)
        end
    end
end)

RegisterServerEvent('mh-hunters:server:stop', function()
    local src = source
    TriggerClientEvent("mh-hunters:client:stopHunt", src)
end)

RegisterNetEvent('police:server:policeAlert', function(text)
    local src = source
    local count = CountCops()
    if Config.EnableIfNoCopsOnline and Config.UseHunters and count == 0 then
        TriggerClientEvent("mh-hunters:client:startHunt", src, math.random(Config.MinHunters, Config.MaxHunters), count)
    end
end)

CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `player_hunters` (
            `id` int(10) NOT NULL AUTO_INCREMENT,
            `name` varchar(50) NOT NULL,
            `license` varchar(50) NOT NULL,
            `amount` int(10) NOT NULL,
            PRIMARY KEY (`id`) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;    
    ]])
end)