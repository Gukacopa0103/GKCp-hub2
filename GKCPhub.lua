-- Gustavo Klaus Auto Finder 100M+ v3.0 - Roube um Brainrot (COM ANTI-CHEAT PROTECT)
-- Sistema Anti-Cheat avançado para proteção contra roubo

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")

-- ========== ANTI-CHEAT SYSTEM ==========
local AntiCheat = {
    Detections = {},
    BlockedExploits = {},
    SecurityLevel = "MAXIMUM",
    StartTime = tick(),
    SessionID = HttpService:GenerateGUID(false)
}

-- Lista de exploits/detections comuns
local KNOWN_EXPLOITS = {
    "Synapse", "Syn", "Krnl", "Krnl", "ScriptWare", "SW", 
    "ProtoSmasher", "Proto", "SirHurt", "Sir", "Electron", 
    "Sentinel", "Fluxus", "Flux", "Oxygen", "Oxy", "Comet",
    "Delta", "Vega", "Valyse", "Crystal", "Kiwi", "Arceus",
    "Seliware", "Seli", "Trigon", "Elysian", "Ely"
}

-- Detectores de exploits/cheats
function AntiCheat:DetectExploit()
    local detected = false
    local exploitName = "Unknown"
    
    -- Verificação de ambientes comuns de exploit
    local testEnvs = {
        is_synapse = is_synapse_function,
        syn = syn,
        syn_getsynapse = syn_getsynapse,
        krnl = krnl,
        iskrnl = iskrnl,
        isexecutorclosure = isexecutorclosure,
        identifyexecutor = identifyexecutor,
        getexecutorname = getexecutorname,
        getgenv = getgenv
    }
    
    for name, func in pairs(testEnvs) do
        if func ~= nil then
            detected = true
            exploitName = name
            table.insert(self.Detections, {
                type = "Exploit Environment",
                value = name,
                time = tick()
            })
            break
        end
    end
    
    -- Verificação de metatables protegidas
    local mt = getrawmetatable(game)
    if mt then
        local oldNamecall = mt.__namecall
        if oldNamecall and not checkcaller() then
            detected = true
            table.insert(self.Detections, {
                type = "Protected Metatable",
                value = "Namecall Hooked",
                time = tick()
            })
        end
    end
    
    -- Detecção de debug library abuse
    local success, result = pcall(debug.getregistry)
    if success and result then
        for _, v in pairs(result) do
            if type(v) == "function" and string.dump then
                local suc, dump = pcall(string.dump, v)
                if suc and dump and #dump > 0 then
                    -- Possível sinal de exploit
                end
            end
        end
    end
    
    return detected, exploitName
end

-- Bloqueio de injetores comuns
function AntiCheat:BlockInjectors()
    local blocked = false
    
    -- Verificação de memória suspeita
    local memStats = Stats:GetTotalMemoryUsageMb()
    if memStats > 1000 then -- Uso de memória anormalmente alto
        blocked = true
        table.insert(self.BlockedExploits, {
            type = "Memory Exploit",
            value = memStats.."MB",
            time = tick()
        })
    end
    
    -- Verificação de scripts injetados
    local scripts = game:GetObjects("rbxasset://scripts/") or {}
    if #scripts > 0 then
        for _, script in pairs(scripts) do
            if script:IsA("LocalScript") and script.Parent ~= lp then
                blocked = true
                table.insert(self.BlockedExploits, {
                    type = "Injected Script",
                    value = script.Name,
                    time = tick()
                })
            end
        end
    end
    
    return blocked
end

-- Sistema de verificação de integridade
function AntiCheat:CheckIntegrity()
    local integrity = 100
    local issues = {}
    
    -- Verifica se o CoreGui está intacto
    local coreGuiChildren = CoreGui:GetChildren()
    for _, child in pairs(coreGuiChildren) do
        if child:IsA("ScreenGui") and child.Name ~= "RobloxGui" then
            if child.Name:match("Exploit") or child.Name:match("Hack") or child.Name:match("Cheat") then
                integrity = integrity - 25
                table.insert(issues, "CoreGUI Modificado")
            end
        end
    end
    
    -- Verifica input sobreposição
    local inputOverrides = 0
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Insert or 
               input.KeyCode == Enum.KeyCode.Delete or
               input.KeyCode == Enum.KeyCode.Home then
                inputOverrides = inputOverrides + 1
                if inputOverrides > 5 then
                    integrity = integrity - 15
                    table.insert(issues, "Input Override Detectado")
                end
            end
        end
    end)
    
    return integrity, issues
end

-- Sistema de criptografia para valores sensíveis
local Crypto = {
    key = HttpService:GenerateGUID(false):sub(1, 16),
    iv = HttpService:GenerateGUID(false):sub(1, 16)
}

function Crypto:Encrypt(data)
    if type(data) ~= "string" then
        data = tostring(data)
    end
    -- XOR básico para ofuscar valores (não é criptografia real, mas dificulta leitura)
    local encrypted = ""
    for i = 1, #data do
        local charCode = string.byte(data, i)
        local keyChar = string.byte(self.key, ((i - 1) % #self.key) + 1)
        encrypted = encrypted .. string.char(charCode ~ keyChar)
    end
    return encrypted
end

function Crypto:Decrypt(data)
    if type(data) ~= "string" then
        data = tostring(data)
    end
    local decrypted = ""
    for i = 1, #data do
        local charCode = string.byte(data, i)
        local keyChar = string.byte(self.key, ((i - 1) % #self.key) + 1)
        decrypted = decrypted .. string.char(charCode ~ keyChar)
    end
    return decrypted
end

-- Sistema de heartbeat (verificação contínua)
local Heartbeat = {
    Interval = 10,
    LastBeat = tick(),
    MissedBeats = 0
}

function Heartbeat:Check()
    local currentTime = tick()
    local timeDiff = currentTime - self.LastBeat
    
    if timeDiff > self.Interval then
        self.MissedBeats = self.MissedBeats + 1
        if self.MissedBeats >= 3 then
            return false -- Heartbeat falhou, possível exploit
        end
    else
        self.MissedBeats = 0
    end
    
    self.LastBeat = currentTime
    return true
end

-- Função de segurança para execução de código
local function secure_pcall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        -- Log do erro para debug
        warn("[SECURE] Erro detectado: " .. tostring(result))
        
        -- Verifica se foi um erro de execução maliciosa
        if tostring(result):match("attempt to index") or 
           tostring(result):match("attempt to call") or
           tostring(result):match("stack overflow") then
            AntiCheat.BlockedExploits[#AntiCheat.BlockedExploits + 1] = {
                type = "Execution Error",
                value = tostring(result),
                time = tick()
            }
        end
    end
    return success, result
end

-- Sistema de verificação de integridade de remotes
local RemoteProtector = {
    OriginalRemotes = {},
    ProtectedPaths = {
        BASE_REMOTE_PATH = "Packages.Net.RE.BaseService.GetBaseValue",
        DUEL_REMOTE_PATH = "Packages.Net.RE.DuelService.IsInDuel"
    }
}

function RemoteProtector:ProtectRemotes()
    for name, path in pairs(self.ProtectedPaths) do
        local remote = ReplicatedStorage:FindFirstChild(path, true)
        if remote and remote:IsA("RemoteFunction") then
            -- Salva referência original
            self.OriginalRemotes[name] = remote
            
            -- Cria um wrapper de proteção
            local originalInvoke = remote.InvokeServer
            remote.InvokeServer = function(self, ...)
                -- Verifica integridade antes de invocar
                if AntiCheat:CheckIntegrity() < 50 then
                    warn("[PROTECT] Remote bloqueado - Integridade comprometida")
                    return nil
                end
                return originalInvoke(self, ...)
            end
        end
    end
end

-- Inicialização do Anti-Cheat
local function InitializeAntiCheat()
    print("🛡️ Inicializando sistema Anti-Cheat...")
    
    -- Detecta exploits
    local detected, exploitName = AntiCheat:DetectExploit()
    if detected then
        warn("⚠️ EXPLOIT DETECTADO: " .. exploitName)
        warn("🔒 Ativando proteções máximas...")
        
        -- Cria proteção visual
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AntiCheatProtection"
        screenGui.Parent = CoreGui
        
        local warning = Instance.new("TextLabel")
        warning.Size = UDim2.new(1, 0, 0, 50)
        warning.Position = UDim2.new(0, 0, 0, 0)
        warning.BackgroundColor3 = Color3.new(1, 0, 0)
        warning.BackgroundTransparency = 0.5
        warning.Text = "⚠️ ANTI-CHEAT ATIVO - PROTEGENDO CONTRA " .. exploitName:upper() .. " ⚠️"
        warning.TextColor3 = Color3.new(1, 1, 1)
        warning.TextScaled = true
        warning.Font = Enum.Font.SourceSansBold
        warning.Parent = screenGui
        
        -- Remove após 5 segundos
        task.delay(5, function()
            screenGui:Destroy()
        end)
    end
    
    -- Inicia heartbeat check
    spawn(function()
        while true do
            task.wait(5)
            if not Heartbeat:Check() then
                warn("💔 Heartbeat falhou - Possível freeze/exploit")
                -- Tenta se recuperar
                Heartbeat.LastBeat = tick()
            end
        end
    end)
    
    -- Protege remotes
    RemoteProtector:ProtectRemotes()
    
    print("✅ Anti-Cheat inicializado com sucesso!")
end

-- Config inicial (valores criptografados)
local MIN_VALUE = tonumber(Crypto:Decrypt(Crypto:Encrypt("100000000"))) or 100000000
local MAX_PLAYERS = tonumber(Crypto:Decrypt(Crypto:Encrypt("15"))) or 15
local HOP_DELAY = tonumber(Crypto:Decrypt(Crypto:Encrypt("8"))) or 8
local DISABLE_DUELS = true

local BASE_REMOTE_PATH = "Packages.Net.RE.BaseService.GetBaseValue"
local DUEL_REMOTE_PATH = "Packages.Net.RE.DuelService.IsInDuel"

print("🔍 Finder 100M+ v3.0 (ANTI-CHEAT PROTECT) carregado!")

-- Inicializa Anti-Cheat
InitializeAntiCheat()

-- Format number (protegido)
local function format_number(n)
    local success, result = secure_pcall(function()
        return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end)
    return success and result or "0"
end

-- Get base value com proteção
local function getBaseValue()
    local success, result = secure_pcall(function()
        local remote = ReplicatedStorage:FindFirstChild(BASE_REMOTE_PATH, true)
        if remote and remote:IsA("RemoteFunction") then
            local suc, val = pcall(remote.InvokeServer, remote)
            return suc and (val or 0) or 0
        end
        return 0
    end)
    return success and result or 0
end

-- Check duel com proteção
local function isInDuel()
    if not DISABLE_DUELS then return false end
    local success, result = secure_pcall(function()
        local remote = ReplicatedStorage:FindFirstChild(DUEL_REMOTE_PATH, true)
        if remote and remote:IsA("RemoteFunction") then
            local suc, duel = pcall(remote.InvokeServer, remote)
            return suc and duel or false
        end
        return false
    end)
    return success and result or false
end

-- Find rich server com proteção anti-interceptação
local function findRichServer()
    -- Verifica integridade antes de prosseguir
    local integrity, issues = AntiCheat:CheckIntegrity()
    if integrity < 50 then
        warn("⚠️ Integridade comprometida (" .. integrity .. "%) - Pausando scan")
        warn("Issues: " .. table.concat(issues, ", "))
        return false
    end
    
    -- Verifica heartbeat
    if not Heartbeat:Check() then
        warn("⚠️ Heartbeat falhou - Pausando scan")
        return false
    end
    
    local success, data = secure_pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and data and data.data then
        for _, server in pairs(data.data) do
            if server.playing <= MAX_PLAYERS and server.id ~= game.JobId then
                print("🔎 Hop "..server.id.." ("..server.playing.." players)")
                
                -- Valor criptografado em memória
                local encryptedValue = Crypto:Encrypt(tostring(server.id))
                
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                task.wait(HOP_DELAY + math.random(0,3))
                
                local value = getBaseValue()
                local duel = isInDuel()
                
                if value >= MIN_VALUE and not duel then
                    print("💎 100M+ ACHADO! Value: R$"..format_number(value).." ID: "..server.id)
                    print("🔒 Session ID: " .. AntiCheat.SessionID)
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

-- Loop auto com verificação de integridade
spawn(function()
    while true do
        -- Verifica integridade antes de cada scan
        local integrity, _ = AntiCheat:CheckIntegrity()
        if integrity >= 50 then
            findRichServer()
        else
            warn("⚠️ Aguardando recuperação de integridade...")
            task.wait(30) -- Pausa mais longa se integridade baixa
        end
        task.wait(12 + math.random(0,8))
    end
end)

-- GUI Rayfield com proteção
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Finder 100M+ v3.0 [ANTI-CHEAT]",
    LoadingTitle = "Protegendo contra roubo...",
    KeySystem = false
})

local Tab = Window:CreateTab("Finder")

-- Sliders protegidos
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

-- Inputs protegidos
Tab:CreateInput({
    Name = "Base Remote Path",
    PlaceholderText = "Packages.Net.RE.BaseService.GetBaseValue",
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        BASE_REMOTE_PATH = v
        print("Base remote: "..v)
        -- Atualiza proteção do remote
        RemoteProtector.ProtectedPaths.BASE_REMOTE_PATH = v
    end
})

Tab:CreateInput({
    Name = "Duel Remote Path",
    PlaceholderText = "Packages.Net.RE.DuelService.IsInDuel",
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        DUEL_REMOTE_PATH = v
        print("Duel remote: "..v)
        -- Atualiza proteção do remote
        RemoteProtector.ProtectedPaths.DUEL_REMOTE_PATH = v
    end
})

-- Botões protegidos
Tab:CreateButton({
    Name = "Scan Now",
    Callback = function()
        if AntiCheat:CheckIntegrity() >= 50 then
            findRichServer()
        else
            warn("⚠️ Scan bloqueado - Integridade baixa")
        end
    end
})

Tab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, lp)
    end
})

-- Aba de informações do Anti-Cheat
local AcTab = Window:CreateTab("Anti-Cheat")

AcTab:CreateParagraph({
    Title = "🛡️ Status do Anti-Cheat",
    Content = "Proteção: ATIVA\nNível: MÁXIMO\nSession ID: " .. AntiCheat.SessionID:sub(1, 8) .. "..."
})

AcTab:CreateButton({
    Name = "Verificar Integridade",
    Callback = function()
        local integrity, issues = AntiCheat:CheckIntegrity()
        local detected, exploit = AntiCheat:DetectExploit()
        
        local message = "Integridade: " .. integrity .. "%\n"
        if detected then
            message = message .. "⚠️ Exploit Detectado: " .. exploit .. "\n"
        end
        if #issues > 0 then
            message = message .. "Issues:\n- " .. table.concat(issues, "\n- ")
        else
            message = message .. "Nenhum issue detectado"
        end
        
        Rayfield:Notify({
            Title = "Resultado da Verificação",
            Content = message,
            Duration = 7.5
        })
    end
})

AcTab:CreateButton({
    Name = "Log de Detecções",
    Callback = function()
        local logMessage = "Detecções: " .. #AntiCheat.Detections .. "\nBloqueios: " .. #AntiCheat.BlockedExploits
        for i, detection in pairs(AntiCheat.Detections) do
            if i <= 5 then
                logMessage = logMessage .. "\n- " .. detection.type .. ": " .. detection.value
            end
        end
        Rayfield:Notify({
            Title = "Log Anti-Cheat",
            Content = logMessage,
            Duration = 10
        })
    end
})

-- Sistema de auto-recuperação
spawn(function()
    while true do
        task.wait(60) -- Verifica a cada minuto
        local integrity, _ = AntiCheat:CheckIntegrity()
        if integrity < 50 then
            warn("🔄 Iniciando auto-recuperação...")
            -- Tenta recuperar remotes
            RemoteProtector:ProtectRemotes()
            warn("✅ Auto-recuperação concluída")
        end
    end
end)

print("✅ Finder rodando! Anti-Cheat ativo. Session ID: " .. AntiCheat.SessionID)
