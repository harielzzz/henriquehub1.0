local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SilvaHub"

local function getChar() return Player.Character or Player.CharacterAdded:Wait() end
local function getHum() return getChar():WaitForChild("Humanoid") end
local function round(obj, r) local c = Instance.new("UICorner", obj) c.CornerRadius = UDim.new(0, r) end

-- Toggle do Hub
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,30,0,30)
toggleBtn.Position = UDim2.new(0,10,0,10)
toggleBtn.Text = "-"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Draggable = true
round(toggleBtn,6)

-- Frame principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,390)
frame.Position = UDim2.new(0,100,0,100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,50)
frame.Active = true
frame.Draggable = true
round(frame,10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(40,40,60)
title.Text = "SILVA HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
round(title,10)

-- Abas
local function makeTab(t,pos)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0,80,0,30)
    b.Position = pos
    b.Text = t
    b.BackgroundColor3 = Color3.fromRGB(50,50,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    round(b,6)
    return b
end
local tPrinc = makeTab("Principal",UDim2.new(0,10,0,45))
local tVisu = makeTab("Visual",UDim2.new(0,105,0,45))
local tOutros = makeTab("Outros",UDim2.new(0,200,0,45))

-- Conteúdo
local cont = Instance.new("Frame",frame)
cont.Size = UDim2.new(1,-20,0,310)
cont.Position = UDim2.new(0,10,0,85)
cont.BackgroundTransparency = 1

local function clear()
    for _,v in pairs(cont:GetChildren()) do v:Destroy() end
end

-- Botões públicos
local function makeBtn(txt,y,cb)
    local b = Instance.new("TextButton",cont)
    b.Size = UDim2.new(1,0,0,35)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50,50,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    round(b,8)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- Estados
local infJump = false
local speedOn = false
local speedValue = 70
local spDef = 16
local espOn = false
local tpOn = false
local tpBtn = nil
local speedBtn = nil

-- Inicialização
Player.CharacterAdded:Connect(function()
    spDef = getHum().WalkSpeed
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump then
        getHum():ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed com força constante
RunService.RenderStepped:Connect(function()
    if speedOn then
        local hum = getHum()
        if hum and hum.WalkSpeed ~= speedValue then
            hum.WalkSpeed = speedValue
        end
    end
end)

local function toggleSpeed()
    speedOn = not speedOn
    local hum = getHum()
    if speedOn then
        hum.WalkSpeed = speedValue
        speedBtn.Text = "Speed [ON]"
    else
        hum.WalkSpeed = spDef
        speedBtn.Text = "Speed [OFF]"
    end
end

-- Teleport
local oldY = 0
local function createTP()
    if tpBtn then tpBtn.Visible = true return end
    tpBtn = Instance.new("TextButton", gui)
    tpBtn.Size = UDim2.new(0,120,0,40)
    tpBtn.Position = UDim2.new(0,420,0,150)
    tpBtn.Text = "Teleport [OFF]"
    tpBtn.BackgroundColor3 = Color3.fromRGB(80,100,140)
    tpBtn.TextColor3 = Color3.new(1,1,1)
    tpBtn.Font = Enum.Font.SourceSansBold
    tpBtn.TextSize = 14
    tpBtn.Draggable = true
    round(tpBtn,8)
    tpBtn.MouseButton1Click:Connect(function()
        local hrp = getChar():FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        tpOn = not tpOn
        if tpOn then
            oldY = hrp.Position.Y
            hrp.CFrame = CFrame.new(hrp.Position.X, 173, hrp.Position.Z)
            tpBtn.Text = "Teleport [ON]"
        else
            hrp.CFrame = CFrame.new(hrp.Position.X, oldY, hrp.Position.Z)
            tpBtn.Text = "Teleport [OFF]"
        end
    end)
end

-- ESP
local function toggleESP()
    espOn = not espOn
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            if espOn and not p.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight", p.Character)
                hl.FillColor = Color3.fromRGB(255, 0, 255)
                hl.OutlineColor = hl.FillColor
            elseif not espOn then
                local hl = p.Character:FindFirstChild("Highlight")
                if hl then hl:Destroy() end
            end
        end
    end
end

-- Funções de compra
local function buy(itemName)
    local evt = Replicated:FindFirstChild(itemName) or (Replicated:FindFirstChild("Packages") and Replicated.Packages:FindFirstChild("Net") and Replicated.Packages.Net:FindFirstChild(itemName))
    if evt and evt:IsA("RemoteEvent") then
        evt:FireServer()
    else
        warn("Evento de compra '" .. itemName .. "' não encontrado.")
    end
end

-- Comprar todos itens 300K
local function buy300k()
    local found = 0
    for _, v in pairs(Replicated:GetDescendants()) do
        if v:IsA("RemoteEvent") and (tostring(v.Name):lower():find("cloak") or tostring(v.Name):lower():find("300")) then
            warn("Tentando comprar (300K):", v:GetFullName())
            pcall(function() v:FireServer() end)
            found += 1
        end
    end
    if found == 0 then
        warn("Nenhum RemoteEvent de item 300K encontrado.")
    end
end

-- Configuração das abas
tPrinc.MouseButton1Click:Connect(function()
    clear()
    makeBtn("Infinite Jump", 0, function() infJump = not infJump end)
    speedBtn = makeBtn("Speed [OFF]", 45, toggleSpeed)
    makeBtn("Teleport Toggle", 90, function()
        if not tpBtn then
            createTP()
        else
            tpBtn.Visible = not tpBtn.Visible
        end
    end)
end)

tVisu.MouseButton1Click:Connect(function()
    clear()
    makeBtn("ESP Toggle", 0, toggleESP)
end)

tOutros.MouseButton1Click:Connect(function()
    clear()
    makeBtn("Comprar Cabeça da Medusa", 0, function() buy("BuyMedusaHead") end)
    makeBtn("Comprar Clonador Quântico", 45, function() buy("BuyQuantumClone") end)
    makeBtn("Comprar Capa da Invisibilidade", 90, function() buy("BuyInvisibilityCloak") end)
    makeBtn("Comprar todos os itens de 300K", 135, buy300k)
end)

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

tPrinc:MouseButton1Click()
