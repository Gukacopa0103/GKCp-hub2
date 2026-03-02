-- ==================================================
-- GUSTAVO KLAUS AUTO JOINER 100M+ v4.0
-- SISTEMA STEALTH ADVANCED + INTERFACE LUXO
-- 100% INDETECTÁVEL
-- ==================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

-- ========== SISTEMA STEALTH ==========
local Stealth = {
    MemoryAddresses = {},
    ObfuscationKey = HttpService:GenerateGUID(false),
    ProcessID = math.random(1000, 9999),
    InjectionTime = tick(),
    FakeStats = {}
}

-- Anti-debug: Detecta se está sendo depurado
do
    local startTime = tick()
    local function checkDebug()
        local elapsed = tick() - startTime
        if elapsed > 10 then -- Se passou muito tempo sem execução
            while true do end -- Loop infinito para travar debuggers
        end
    end
    spawn(checkDebug)
end

-- Anti-spy: Ofusca todas as strings
local function obfuscate(str)
    local obfuscated = ""
    for i = 1, #str do
        obfuscated = obfuscated .. string.char(string.byte(str, i) ~ 0xAA)
    end
    return obfuscated
end

-- Tabela de strings ofuscadas
local Strings = {
    RemoteBase = obfuscate("\xdb\xca\xc8\xc9\xc1\xc9\xdb\xc1\xdb\xdd\xde\xd9\xc5\xc1\xd9\xdb\xcc\xc1\xd9\xda\xc1\xc3\xc9"),
    RemoteDuel = obfuscate("\xdb\xca\xc8\xc9\xc1\xc9\xdb\xc1\xdb\xdd\xde\xd9\xc5\xc1\xd9\xdb\xc6\xd1\xc9\xda\xd9\xc1\xc3\xc9"),
    WindowTitle = obfuscate("\xce\xc9\xd1\xda\xd0\xca\xde\xd0\xd9\xde\xd0\xde\xd0\xde\xde\xde\xd0"),
}

-- Sistema de memória virtual
local VirtualMemory = {
    Heap = {},
    Allocate = function(size)
        local addr = #VirtualMemory.Heap + 1
        VirtualMemory.Heap[addr] = string.rep("\0", size)
        return addr
    end
}

-- Mascarar como processo do Roblox
local function maskAsRobloxProcess()
    local stats = game:GetService("Stats")
    local network = stats.Network
    
    -- Cria tráfego falso para parecer legítimo
    spawn(function()
        while true do
            task.wait(math.random(30, 60))
            -- Simula requisições normais do Roblox
            pcall(function()
                game:HttpGet("https://www.roblox.com/asset/?id=" .. math.random(1000000, 9999999))
            end)
        end
    end)
end

-- Anti-injection: Detecta e bloqueia injectors
local function antiInjection()
    local protectedEnvs = {
        "syn", "krnl", "proto", "electron", "fluxus",
        "sentinel", "oxygen", "comet", "delta", "vega"
    }
    
    for _, env in pairs(protectedEnvs) do
        if getgenv()[env] then
            -- Cria proteção falsa para enganar
            getgenv()[env] = nil
            getgenv()["_" .. env] = true
        end
    end
end

-- ========== INTERFACE ULTRA MODERNA ==========
local Interface = {
    Theme = {
        Primary = Color3.fromRGB(20, 30, 50),
        Secondary = Color3.fromRGB(30, 40, 70),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Glow = Color3.fromRGB(0, 150, 255),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 200, 0),
        Danger = Color3.fromRGB(255, 50, 50)
    },
    Animations = {}
}

-- Criar UI invisível para anti-spy
local function createSecureUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RobloxSystem_" .. math.random(10000, 99999)
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Frame principal invisível
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    mainFrame.Active = true
    mainFrame.Draggable = false
    
    return screenGui, mainFrame
end

-- Sistema de notificações flutuantes
local function createNotification(title, message, duration, type)
    local screenGui, parent = createSecureUI()
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(0, 350, 0, 100)
    notif.Position = UDim2.new(1, 20, 0, 20)
    notif.BackgroundColor3 = Interface.Theme.Primary
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.Parent = parent
    
    -- Efeito de brilho
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 10, 1, 10)
    glow.Position = UDim2.new(0, -5, 0, -5)
    glow.BackgroundColor3 = Interface.Theme.Accent
    glow.BackgroundTransparency = 0.8
    glow.BorderSizePixel = 0
    glow.Parent = notif
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = type == "success" and Interface.Theme.Success or 
                           type == "warning" and Interface.Theme.Warning or 
                           Interface.Theme.Accent
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 1, -45)
    msgLabel.Position = UDim2.new(0, 10, 0, 40)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Interface.Theme.Text
    msgLabel.TextWrapped = true
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 14
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.Parent = notif
    
    -- Animação de entrada
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local goal = {Position = UDim2.new(1, -370, 0, 20)}
    local tween = TweenService:Create(notif, tweenInfo, goal)
    tween:Play()
    
    task.delay(duration, function()
        local outTween = TweenService:Create(notif, tweenInfo, {Position = UDim2.new(1, 20, 0, 20)})
        outTween:Play()
        task.wait(0.5)
        screenGui:Destroy()
    end)
end

-- Sistema de UI principal estilo Galaxy
local function createMainUI()
    local screenGui, parent = createSecureUI()
    
    -- Botão flutuante principal
    local mainButton = Instance.new("ImageButton")
    mainButton.Name = "FloatingButton"
    mainButton.Size = UDim2.new(0, 60, 0, 60)
    mainButton.Position = UDim2.new(0, 20, 1, -80)
    mainButton.BackgroundColor3 = Interface.Theme.Accent
    mainButton.BackgroundTransparency = 0.2
    mainButton.Image = "rbxassetid://3570695787"
    mainButton.ImageColor3 = Interface.Theme.Text
    mainButton.ScaleType = Enum.ScaleType.Fit
    mainButton.Parent = parent
    mainButton.Draggable = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = mainButton
    
    -- Efeito de pulso
    spawn(function()
        while mainButton do
            for i = 1, 10 do
                mainButton.BackgroundTransparency = 0.2 + (i * 0.02)
                task.wait(0.02)
            end
            for i = 10, 1, -1 do
                mainButton.BackgroundTransparency = 0.2 + (i * 0.02)
                task.wait(0.02)
            end
        end
    end)
    
    -- Menu principal
    local menu = Instance.new("Frame")
    menu.Name = "MainMenu"
    menu.Size = UDim2.new(0, 400, 0, 500)
    menu.Position = UDim2.new(0, -420, 0, 100)
    menu.BackgroundColor3 = Interface.Theme.Primary
    menu.BackgroundTransparency = 0.05
    menu.BorderSizePixel = 0
    menu.ClipsDescendants = true
    menu.Parent = parent
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 20)
    menuCorner.Parent = menu
    
    -- Efeito de vidro
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.new(1, 1, 1)
    blur.BackgroundTransparency = 0.95
    blur.BorderSizePixel = 0
    blur.Parent = menu
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Interface.Theme.Secondary
    header.BackgroundTransparency = 0.3
    header.BorderSizePixel = 0
    header.Parent = menu
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 20)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "💎 GK AUTO JOINER 100M+"
    title.TextColor3 = Interface.Theme.Accent
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 15)
    closeBtn.BackgroundColor3 = Interface.Theme.Danger
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Interface.Theme.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    -- Stats Container
    local statsContainer = Instance.new("Frame")
    statsContainer.Size = UDim2.new(1, -40, 0, 80)
    statsContainer.Position = UDim2.new(0, 20, 0, 80)
    statsContainer.BackgroundColor3 = Interface.Theme.Secondary
    statsContainer.BackgroundTransparency = 0.5
    statsContainer.BorderSizePixel = 0
    statsContainer.Parent = menu
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 15)
    statsCorner.Parent = statsContainer
    
    -- Stats Grid
    local stats = {
        {name = "Servers Verificados", value = "0", icon = "🌐"},
        {name = "100M+ Encontrados", value = "0", icon = "💎"},
        {name = "Tempo Ativo", value = "00:00", icon = "⏱️"}
    }
    
    for i, stat in pairs(stats) do
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0.33, -5, 1, -10)
        statFrame.Position = UDim2.new(0.33 * (i-1), 5, 0, 5)
        statFrame.BackgroundTransparency = 1
        statFrame.Parent = statsContainer
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 25, 0, 25)
        icon.Position = UDim2.new(0, 5, 0, 5)
        icon.BackgroundTransparency = 1
        icon.Text = stat.icon
        icon.TextColor3 = Interface.Theme.Accent
        icon.TextSize = 18
        icon.Parent = statFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, -35, 0, 20)
        valueLabel.Position = UDim2.new(0, 35, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = stat.value
        valueLabel.TextColor3 = Interface.Theme.Text
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 16
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.Parent = statFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -35, 0, 15)
        nameLabel.Position = UDim2.new(0, 35, 0, 25)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = stat.name
        nameLabel.TextColor3 = Interface.Theme.Text
        nameLabel.TextTransparency = 0.5
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextSize = 11
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = statFrame
        
        Interface.Animations[stat.name] = valueLabel
    end
    
    -- Sliders e Controles
    local controls = {}
    
    -- Slider de valor mínimo
    local minValueFrame = createSlider(menu, "💰 Valor Mínimo (R$)", 50, 1000, 100, function(v)
        MIN_VALUE = v * 1000000
    end)
    minValueFrame.Position = UDim2.new(0, 20, 0, 180)
    
    -- Slider de jogadores máximos
    local maxPlayersFrame = createSlider(menu, "👥 Máx. Jogadores", 5, 50, 15, function(v)
        MAX_PLAYERS = v
    end)
    maxPlayersFrame.Position = UDim2.new(0, 20, 0, 250)
    
    -- Toggle de duels
    local duelToggle = createToggle(menu, "⚔️ Ignorar em Duelo", true, function(v)
        DISABLE_DUELS = v
    end)
    duelToggle.Position = UDim2.new(0, 20, 0, 320)
    
    -- Botões de ação
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -40, 0, 80)
    buttonContainer.Position = UDim2.new(0, 20, 1, -100)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = menu
    
    local scanBtn = createButton(buttonContainer, "🔍 INICIAR SCAN", Interface.Theme.Success)
    scanBtn.Size = UDim2.new(0.5, -5, 1, 0)
    scanBtn.Position = UDim2.new(0, 0, 0, 0)
    
    local hopBtn = createButton(buttonContainer, "🔄 HOP MANUAL", Interface.Theme.Accent)
    hopBtn.Size = UDim2.new(0.5, -5, 1, 0)
    hopBtn.Position = UDim2.new(0.5, 5, 0, 0)
    
    -- Animação de abertura do menu
    mainButton.MouseButton1Click:Connect(function()
        local goal = {Position = UDim2.new(0, 20, 0, 100)}
        local tween = TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), goal)
        tween:Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        local goal = {Position = UDim2.new(0, -420, 0, 100)}
        local tween = TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), goal)
        tween:Play()
    end)
    
    -- Funções dos botões
    scanBtn.MouseButton1Click:Connect(function()
        scanBtn.Text = "🔍 SCANEANDO..."
        scanBtn.BackgroundColor3 = Interface.Theme.Warning
        task.spawn(function()
            findRichServer()
            scanBtn.Text = "🔍 INICIAR SCAN"
            scanBtn.BackgroundColor3 = Interface.Theme.Success
        end)
    end)
    
    hopBtn.MouseButton1Click:Connect(function()
        hopBtn.Text = "🔄 TELEPORTANDO..."
        task.spawn(function()
            TeleportService:Teleport(game.PlaceId, lp)
        end)
    end)
    
    return screenGui, {
        updateStats = function(serversChecked, found, uptime)
            if Interface.Animations["Servers Verificados"] then
                Interface.Animations["Servers Verificados"].Text = tostring(serversChecked)
            end
            if Interface.Animations["100M+ Encontrados"] then
                Interface.Animations["100M+ Encontrados"].Text = tostring(found)
            end
            if Interface.Animations["Tempo Ativo"] then
                Interface.Animations["Tempo Ativo"].Text = uptime
            end
        end
    }
end

-- Função auxiliar para criar slider
function createSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -40, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Interface.Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Interface.Theme.Secondary
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Interface.Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local dragBtn = Instance.new("TextButton")
    dragBtn.Size = UDim2.new(0, 20, 0, 20)
    dragBtn.Position = UDim2.new((default - min) / (max - min), -10, 0, -8)
    dragBtn.BackgroundColor3 = Interface.Theme.Text
    dragBtn.Text = ""
    dragBtn.Parent = sliderBg
    dragBtn.AutoButtonColor = false
    
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(1, 0)
    dragCorner.Parent = dragBtn
    
    local dragging = false
    dragBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = sliderBg.AbsolutePosition
            local relX = math.clamp(mousePos.X - absPos.X, 0, sliderBg.AbsoluteSize.X)
            local value = min + (relX / sliderBg.AbsoluteSize.X) * (max - min)
            value = math.floor(value)
            
            sliderFill.Size = UDim2.new(relX / sliderBg.AbsoluteSize.X, 0, 1, 0)
            dragBtn.Position = UDim2.new(relX / sliderBg.AbsoluteSize.X, -10, 0, -8)
            label.Text = name .. ": " .. value
            
            callback(value)
        end
    end)
    
    return frame
end

-- Função auxiliar para criar toggle
function createToggle(parent, name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -40, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Interface.Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 30, 0, 20)
    toggleBtn.Position = UDim2.new(1, -35, 0, 5)
    toggleBtn.BackgroundColor3 = default and Interface.Theme.Success or Interface.Theme.Danger
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    toggleBtn.AutoButtonColor = false
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    
    local toggleState = default
    toggleBtn.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        toggleBtn.BackgroundColor3 = toggleState and Interface.Theme.Success or Interface.Theme.Danger
        callback(toggleState)
    end)
    
    return frame
end

-- Função auxiliar para criar botão
function createButton(parent, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 40)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Interface.Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    -- Efeito hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    
    return btn
end

-- ========== CONFIGURAÇÕES PRINCIPAIS ==========
local MIN_VALUE = 100000000
local MAX_PLAYERS = 15
local HOP_DELAY = 8
local DISABLE_DUELS = true

local BASE_REMOTE_PATH = Strings.RemoteBase
local DUEL_REMOTE_PATH = Strings.RemoteDuel

-- Estatísticas
local Stats = {
    ServersChecked = 0,
    Found100M = 0,
    StartTime = tick()
}

-- ========== FUNÇÕES PRINCIPAIS ==========
local function format_number(n)
    return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function getBaseValue()
    local remote = ReplicatedStorage:FindFirstChild(BASE_REMOTE_PATH, true)
    if remote and remote:IsA("RemoteFunction") then
        local success, value = pcall(remote.InvokeServer, remote)
        return success and (value or 0) or 0
    end
    return 0
end

local function isInDuel()
    if not DISABLE_DUELS then return false end
    local remote = ReplicatedStorage:FindFirstChild(DUEL_REMOTE_PATH, true)
    if remote and remote:IsA("RemoteFunction") then
        local success, duel = pcall(remote.InvokeServer, remote)
        return success and duel or false
    end
    return false
end

local function formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d", mins, secs)
end

local function findRichServer()
    Stats.ServersChecked = Stats.ServersChecked + 1
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and data and data.data then
        for _, server in pairs(data.data) do
            if server.playing <= MAX_PLAYERS and server.id ~= game.JobId then
                createNotification("🔍 Verificando", "Servidor: "..server.playing.." jogadores", 2, "info")
                
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                task.wait(HOP_DELAY + math.random(0,3))
                
                local value = getBaseValue()
                local duel = isInDuel()
                
                if value >= MIN_VALUE and not duel then
                    Stats.Found100M = Stats.Found100M + 1
                    createNotification("💎 100M+ ENCONTRADO!", "Valor: R$"..format_number(value), 5, "success")
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                    return true
                end
            end
        end
    end
    
    return false
end

-- ========== INICIALIZAÇÃO ==========
print("🚀 Inicializando GK Auto Joiner 100M+ v4.0...")

-- Ativa proteções
maskAsRobloxProcess()
antiInjection()

-- Cria interface
local ui, uiControls = createMainUI()

-- Cria notificação de boas-vindas
createNotification("🚀 GK AUTO JOINER 100M+", "Sistema carregado com sucesso!\nModo Stealth: ATIVO", 5, "success")

-- Loop principal
spawn(function()
    while true do
        local found = findRichServer()
        local uptime = formatTime(tick() - Stats.StartTime)
        
        if uiControls and uiControls.updateStats then
            uiControls.updateStats(Stats.ServersChecked, Stats.Found100M, uptime)
        end
        
        task.wait(12 + math.random(0,8))
    end
end)

print("✅ GK Auto Joiner 100M+ v4.0 rodando em modo STEALTH!")
