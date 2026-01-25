--[[
    BrainRot Ultimate Steal Script
    Feito pelo kablooey
    V3rmillion leaks never die
]]--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

locaL game:GetService("RunService").RenderStepped:Connect(function()
    for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and not gui.Enabled then
            gui.Enabled = true
        end
    end
end)

getgenv().ForceGuiVisible = true

-- Cria ou força parent da GUI principal
local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Se o script já tem uma ScreenGui chamada "AlgoAqui", força ela
local function fixGui()
    for _, gui in ipairs(pgui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui.Parent = pgui  -- redundante mas ajuda
            gui.Enabled = true
            gui.ResetOnSpawn = false
            for _, child in ipairs(gui:GetDescendants()) do
                if child:IsA("GuiObject") then
                    child.Visible = true
                end
            end
        end
    end
end

fixGui()  -- roda uma vez
-- Roda todo frame pra evitar reset (gambiarra mas funciona em jogos anti-GUI)
game:GetService("RunService").RenderStepped:Connect(fixGui)
-- Configurações
local settings = {
    autoSteal = true,
    instantSteal = false,
    brainhotInstant = true,
    desyncEnabled = false,
    hitboxExtender = false,
    hitboxSize = 10,
    flyEnabled = false,
    flySpeed = 50,
    noclipEnabled = false,
    invisible = false
}

-- Variáveis globais
local brainRotConnections = {}
local flyConnection = nil
local noclipConnection = nil
local desyncParts = {}
local originalTransparency = {}
local stolenCount = 0
local stealCooldown = false

-- Função de logging
local function log(msg)
    print("[BrainRot] " .. msg)
end

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainRotStealer"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Title.Text = "BRAINROT STEALER v3.0"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Categorias
local categories = {}
local buttons = {}

local function createCategory(name, ypos)
    local category = Instance.new("TextLabel")
    category.Size = UDim2.new(1, -10, 0, 25)
    category.Position = UDim2.new(0, 5, 0, ypos)
    category.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    category.Text = "  " .. name
    category.TextColor3 = Color3.fromRGB(200, 200, 200)
    category.Font = Enum.Font.Gotham
    category.TextXAlignment = Enum.TextXAlignment.Left
    category.Parent = MainFrame
    
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 0)
    holder.Position = UDim2.new(0, 5, 0, ypos + 25)
    holder.BackgroundTransparency = 1
    holder.Parent = MainFrame
    
    categories[name] = holder
    return holder
end

-- Criar botão
local function createButton(text, parent, callback, ypos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 25)
    button.Position = UDim2.new(0, 0, 0, ypos)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = text
    button.TextColor3 = Color3.white
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    button.MouseButton1Click:Connect(callback)
    table.insert(buttons, button)
    return button
end

-- Criar toggle
local function createToggle(text, parent, ypos, settingName)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 25)
    toggleFrame.Position = UDim2.new(0, 0, 0, ypos)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.7, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = text
    button.TextColor3 = Color3.white
    button.Font = Enum.Font.Gotham
    button.Parent = toggleFrame
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(0.75, 5, 0.5, -10)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    indicator.Parent = toggleFrame
    
    local function updateToggle()
        indicator.BackgroundColor3 = settings[settingName] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end
    
    button.MouseButton1Click:Connect(function()
        settings[settingName] = not settings[settingName]
        updateToggle()
        log(text .. ": " .. tostring(settings[settingName]))
    end)
    
    updateToggle()
    table.insert(buttons, button)
end

-- Criar categorias
local autoStealCat = createCategory("Auto Steal", 35)
local combatCat = createCategory("Combat", 130)
local movementCat = createCategory("Movement", 225)
local visualCat = createCategory("Visual", 320)

-- Botões Auto Steal
createToggle("Auto Steal Instant", autoStealCat, 0, "autoSteal")
createToggle("Instant Steal", autoStealCat, 30, "instantSteal")
createToggle("Brainhot Instant", autoStealCat, 60, "brainhotInstant")

-- Botões Combat
createToggle("Desync", combatCat, 0, "desyncEnabled")
createToggle("Hitbox Extender", combatCat, 30, "hitboxExtender")

-- Botões Movement
createToggle("Fly", movementCat, 0, "flyEnabled")
createToggle("Noclip", movementCat, 30, "noclipEnabled")

-- Botões Visual
createToggle("Invisible", visualCat, 0, "invisible")

-- Contador
local counter = Instance.new("TextLabel")
counter.Size = UDim2.new(1, 0, 0, 30)
counter.Position = UDim2.new(0, 0, 1, -30)
counter.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
counter.Text = "Stolen: 0"
counter.TextColor3 = Color3.fromRGB(0, 255, 0)
counter.Font = Enum.Font.GothamBold
counter.Parent = MainFrame

-- Função de steal
local function stealBrainRot(target)
    if stealCooldown then return end
    stealCooldown = true
    
    local humanoid = target:FindFirstChildOfClass("Humanoid")
    local root = target:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root then
        if settings.instantSteal then
            -- Instant steal method
            firetouchinterest(root, LocalPlayer.Character.HumanoidRootPart, 0)
            firetouchinterest(root, LocalPlayer.Character.HumanoidRootPart, 1)
        else
            -- Método tradicional
            local originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame
            wait(0.1)
            LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
        end
        
        stolenCount = stolenCount + 1
        counter.Text = "Stolen: " .. stolenCount
        log("Stolen from " .. target.Name)
    end
    
    wait(0.5)
    stealCooldown = false
end

-- Função de steal automático
local function autoSteal()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hasBrainRot = player.Character:FindFirstChild("BrainRot") or player.Character:FindFirstChild("Brainhot")
            if hasBrainRot then
                stealBrainRot(player.Character)
            end
        end
    end
end

-- Fly system
local function toggleFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if settings.flyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not settings.flyEnabled or not LocalPlayer.Character then
                flyConnection:Disconnect()
                bodyVelocity:Destroy()
                return
            end
            
            local root = LocalPlayer.Character.HumanoidRootPart
            if not root then return end
            
            local newVelocity = Vector3.new(0, 0, 0)
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                newVelocity = newVelocity + (root.CFrame.LookVector * settings.flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                newVelocity = newVelocity - (root.CFrame.LookVector * settings.flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                newVelocity = newVelocity - (root.CFrame.RightVector * settings.flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                newVelocity = newVelocity + (root.CFrame.RightVector * settings.flySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                newVelocity = newVelocity + Vector3.new(0, settings.flySpeed, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                newVelocity = newVelocity - Vector3.new(0, settings.flySpeed, 0)
            end
            
            bodyVelocity.Velocity = newVelocity
        end)
    end
end

-- Noclip system
local function toggleNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if settings.noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Desync system
local function toggleDesync()
    if settings.desyncEnabled then
        local root = LocalPlayer.Character.HumanoidRootPart
        if not root then return end
        
        local fakeRoot = root:Clone()
        fakeRoot.Parent = workspace
        fakeRoot.Transparency = 0.5
        fakeRoot.BrickColor = BrickColor.new("Really red")
        fakeRoot.CanCollide = false
        
        table.insert(desyncParts, fakeRoot)
        
        RunService.Heartbeat:Connect(function()
            if not settings.desyncEnabled then
                for _, part in pairs(desyncParts) do
                    part:Destroy()
                end
                desyncParts = {}
                return
            end
            
            fakeRoot.CFrame = root.CFrame * CFrame.new(0, 0, -5)
        end)
    else
        for _, part in pairs(desyncParts) do
            part:Destroy()
        end
        desyncParts = {}
    end
end

-- Hitbox extender
local function toggleHitboxExtender()
    while settings.hitboxExtender do
        wait(0.1)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                    end
                end
            end
        end
    end
    
    -- Reset hitboxes
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Size = Vector3.new(1, 1, 1)
                end
            end
        end
    end
end

-- Invisible
local function toggleInvisible()
    if settings.invisible then
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalTransparency[part] = part.Transparency
                    part.Transparency = 1
                end
            end
        end
    else
        for part, transparency in pairs(originalTransparency) do
            if part and part.Parent then
                part.Transparency = transparency
            end
        end
        originalTransparency = {}
    end
end

-- Main loop
RunService.Heartbeat:Connect(function()
    -- Auto steal
    if settings.autoSteal then
        autoSteal()
    end
    
    -- Fly toggle
    if settings.flyEnabled and not flyConnection then
        toggleFly()
    elseif not settings.flyEnabled and flyConnection then
        toggleFly()
    end
    
    -- Noclip toggle
    if settings.noclipEnabled and not noclipConnection then
        toggleNoclip()
    elseif not settings.noclipEnabled and noclipConnection then
        toggleNoclip()
    end
    
    -- Desync
    if settings.desyncEnabled and #desyncParts == 0 then
        toggleDesync()
    elseif not settings.desyncEnabled and #desyncParts > 0 then
        toggleDesync()
    end
    
    -- Hitbox extender
    spawn(toggleHitboxExtender)
    
    -- Invisible
    toggleInvisible()
end)

-- Cleanup
LocalPlayer.CharacterAdded:Connect(function()
    if settings.invisible then
        wait(1)
        toggleInvisible()
    end
end)

log("BrainRot Stealer loaded! Stolen: " .. stolenCount)
