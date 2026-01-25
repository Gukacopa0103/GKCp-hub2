-- Serviços básicos
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variáveis globais (toggles)
getgenv().FlyEnabled = false
getgenv().NoclipEnabled = false
getgenv().HitboxExtenderEnabled = false
getgenv().DesyncEnabled = false
getgenv().AutoStealEnabled = false

-- GUI simples (forçada no PlayerGui pra aparecer no Velocity)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KlausExploitGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Klaus Exploit v1 - Steal a Brainrot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

-- Função pra criar toggle botão
local function CreateToggle(name, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 18
    Button.Parent = Frame
    
    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = name .. ": " .. (state and "ON" or "OFF")
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-- Toggles
CreateToggle("Fly", 50, function(state) getgenv().FlyEnabled = state end)
CreateToggle("Noclip", 100, function(state) getgenv().NoclipEnabled = state end)
CreateToggle("Hitbox Extender", 150, function(state) getgenv().HitboxExtenderEnabled = state end)
CreateToggle("Desync", 200, function(state) getgenv().DesyncEnabled = state end)
CreateToggle("Auto Steal", 250, function(state) getgenv().AutoStealEnabled = state end)

-- Fly (BodyVelocity simples)
local FlySpeed = 50
RunService.RenderStepped:Connect(function()
    if not FlyEnabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local cam = workspace.CurrentCamera
    local moveDir = Vector3.new(0,0,0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
    
    hrp.Velocity = moveDir * FlySpeed
end)

-- Noclip (desliga colisões)
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Hitbox Extender (aumenta tamanho de hitboxes de outros players)
RunService.Heartbeat:Connect(function()
    if not HitboxExtenderEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            root.Size = Vector3.new(20, 20, 20)  -- Ajusta o tamanho (maior = mais fácil acertar)
            root.Transparency = 0.7  -- Semi-transparente pra ver
            root.CanCollide = false
        end
    end
end)

-- Desync básico (network ownership fake + simula lag)
spawn(function()
    while DesyncEnabled do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart:SetNetworkOwner(nil)  -- Desync ownership
                wait(0.1)  -- Lag simulado
                LocalPlayer.Character.HumanoidRootPart:SetNetworkOwner(LocalPlayer)
            end)
        end
        wait(0.3)  -- Anti-detect
    end
end)

-- Auto Steal genérico (exemplo - adapta com RemoteSpy)
spawn(function()
    while AutoStealEnabled do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                -- Exemplo hipotético: acha remote de steal (usa RemoteSpy pra ver nome real)
                local stealRemote = ReplicatedStorage:FindFirstChild("StealEvent") or ReplicatedStorage.Remotes:FindFirstChild("StealBrainrot")
                if stealRemote and stealRemote:IsA("RemoteEvent") then
                    stealRemote:FireServer(plr.Character)  -- Ou plr.Character.Brainrot, etc.
                end
            end
        end
        wait(0.5)  -- Delay pra evitar kick
    end
end)

-- Anti-kick básico
spawn(function()
    while true do
        wait(5)
        pcall(function()
            if LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()  -- Gambiarra anti-kick em alguns jogos
            end
        end)
    end
end)

print("Klaus Exploit carregado! GUI no meio da tela.")
