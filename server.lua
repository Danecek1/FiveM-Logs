Config = {}
Config = setmetatable({}, { __index = function(t, k) return rawget(t, k) or error("Config key '"..k.."' not found", 2) end })
load(LoadResourceFile(GetCurrentResourceName(), 'config.lua'))()

function sendToDiscord(webhook, name, message, color)
    local connect = {
        {
            ["color"] = color,
            ["title"] = name,
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Splash RolePlay",
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Server Logs", embeds = connect}), { ['Content-Type'] = 'application/json' })
end

-- Logování smrti hráče
AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
    local _source = source
    local playerName = GetPlayerName(_source)
    local message = ("Hráč %s zemřel na pozici: %s, %s, %s"):format(playerName, coords.x, coords.y, coords.z)
    sendToDiscord(Config.Webhooks.death, "Hráč zemřel", message, 16711680) -- Červená barva pro smrt
end)

-- Logování odpojení hráče
AddEventHandler('playerDropped', function(reason)
    local _source = source
    local playerName = GetPlayerName(_source)
    local message = ("Hráč %s se odpojil (Důvod: %s)"):format(playerName, reason)
    sendToDiscord(Config.Webhooks.disconnect, "Hráč se odpojil", message, 16776960) -- Žlutá barva pro odpojení
end)

-- Logování připojení hráče
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local _source = source
    local message = ("Hráč %s se připojuje na server"):format(playerName)
    sendToDiscord(Config.Webhooks.connect, "Hráč se připojuje", message, 65280) -- Zelená barva pro připojení
end)

-- Logování při zabití jiným hráčem
AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
    local victimName = GetPlayerName(source)
    local killerName = GetPlayerName(killerId)
    local message = ("Hráč %s byl zabit hráčem %s"):format(victimName, killerName)
    sendToDiscord(Config.Webhooks.kill, "Hráč zabit", message, 16711680) -- Červená barva pro zabití
end)
