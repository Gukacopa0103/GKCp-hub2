-- Gustavo Klaus Auto Finder 100M+ v3.0 - Roube um Brainrot (sem SimpleSpy)
-- Remotes comuns: ajuste na GUI se nil

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Config inicial
local MIN_VALUE = 100000000 -- 100M+
local MAX_PLAYERS = 15
local HOP_DELAY = 8 -- Anti-ban
local DISABLE_DUELS = true

local BASE_REMOTE_PATH = "Packages.Net.RE.BaseService.GetBaseValue" -- Comum, ajusta GUI
local DUEL_REMOTE_PATH = "Packages.Net.RE.DuelService.IsInDuel" -- Comum

print("🔍 Finder 100M+ v3.0 carregado! Edit remotes na GUI.")

-- Format number
local function format_number(n)
    return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

-- Get base value (pcall safe)
local function getBaseValue()
    local remote = ReplicatedStorage:FindFirstChild(BASE_REMOTE_PATH, true)
    if remote and remote:IsA("RemoteFunction") then
        local success, value = pcall(remote.InvokeServer, remote)
        return success and (value or 0) or 0
    end
    return 0
end

-- Check duel
local function isInDuel()
    if not DISABLE_DUELS then return false end
    local remote = ReplicatedStorage:FindFirstChild(DUEL_REMOTE_PATH, true)
    if remote and remote:IsA("RemoteFunction") then
        local success, duel = pcall(remote.InvokeServer, remote)
        return success and duel or false
    end
    return false
end

-- Find rich server
local function findRichServer()
    local success, data = pcall(HttpService.JSONDecode, HttpService, game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    if success and data.data then
        for _, server in pairs(data.data) do
            if server.playing <= MAX_PLAYERS and server.id ~= game.JobId then
                print("🔎 Hop "..server.id.." ("..server.playing.." players)")
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                task.wait(HOP_DELAY + math.random(0,3)) -- Random anti-ban
                
                local value = getBaseValue()
                local duel = isInDuel()
                
                if value >= MIN_VALUE and not duel then
                    print("💎 100M+ ACHADO! Value: R$"..format_number(value).." ID: "..server.id)
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                    return true
                end
                print("❌ Value R$"..format_number(value).." (duel: "..tostring(duel)..")")
            end
        end
    end
    print("❌ Nenhum 100M+. Novo scan...")
    return false
end

-- Loop auto
spawn(function()
    while true do
        findRichServer()
        task.wait(12 + math.random(0,8))
    end
end)

-- GUI Rayfield (edit remotes/values)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Meu Finder 100M+ v3.0",
    LoadingTitle = "Carregando...",
    KeySystem = false
})

local Tab = Window:CreateTab("Finder")

Tab:CreateSlider({
    Name = "Min Value (R$)",
    Range = {50e6, 1e9},
    Increment = 10e6,
    CurrentValue = MIN_VALUE,
    Callback = function(v)
        MIN_VALUE = v
        print("Min value: R$"..format_number(v))
    end
})

Tab:CreateSlider({
    Name = "Max Players",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = MAX_PLAYERS,
    Callback = function(v)
        MAX_PLAYERS = v
    end
})

Tab:CreateToggle({
    Name = "Disable Duels",
    CurrentValue = true,
    Callback = function(v)
        DISABLE_DUELS = v
    end
})

Tab:CreateInput({
    Name = "Base Remote Path",
    PlaceholderText = "Packages.Net.RE.BaseService.GetBaseValue",
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        BASE_REMOTE_PATH = v
        print("Base remote: "..v)
    end
})

Tab:CreateInput({
    Name = "Duel Remote Path",
    PlaceholderText = "Packages.Net.RE.DuelService.IsInDuel",
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        DUEL_REMOTE_PATH = v
        print("Duel remote: "..v)
    end
})

Tab:CreateButton({
    Name = "Scan Now",
    Callback = findRichServer
})

Tab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, lp)
    end
})

print("✅ Finder rodando! GUI pronta. Ajusta remotes se nil (comum: BaseService.GetBaseValue).")
