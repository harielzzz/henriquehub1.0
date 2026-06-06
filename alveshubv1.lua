-- Serviços do Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ParentGui = LocalPlayer:WaitForChild("PlayerGui") 

-- Lista de Cores do Seletor
local CoresPredefinidas = {
    Color3.fromRGB(0, 255, 170), -- Neon Mint
    Color3.fromRGB(255, 75, 75),   -- Pastel Red
    Color3.fromRGB(0, 162, 255), -- Deep Blue
    Color3.fromRGB(255, 215, 0), -- Gold
    Color3.fromRGB(160, 32, 240)  -- Purple
}

-- Configurações Globais
local Config = {
    Enabled = false,
    Range = 1000,
    MinRange = 5,
    MaxRange = 5000,
    EspBox = false,
    EspLine = false,
    EspName = false,
    EspHealth = false,
    EspDistance = false,
    EspColorIndex = 1,
    Chams = false,
    ChamsColorIndex = 2,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    AntiAFK = false,
    Aimbot = false,
    AimbotFov = 150,
    HitboxExpander = false,
    HitboxSize = 5,
    KillAura = false,
    AutoClicker = false,
    MagicBullet = false,
    MagicChance = 100,
    Wallbang = false,
    InfAmmo = false
}

local EspScreenGui = Instance.new("ScreenGui")
EspScreenGui.Name = "BlockspinEspSystem"
EspScreenGui.ResetOnSpawn = false
EspScreenGui.IgnoreGuiInset = true
EspScreenGui.Parent = ParentGui

local PlayerEspCache = {}

-- ====================================================================
-- INTERFACE PRINCIPAL (DESIGN REFORMULADO)
-- ====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockspinAdvancedHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1
MainStroke.Color = Color3.fromRGB(45, 45, 45)
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
TitleBar.Text = "   BLOCKSPIN ULTRA HUB V3"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 14
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Active = true
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 12
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 100, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = Sidebar
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Size = UDim2.new(1, -115, 1, -50)
PagesContainer.Position = UDim2.new(0, 110, 0, 45)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local Pages = {}

local function CriarAba(nome, ordem)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = nome .. "Tab"
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.Position = UDim2.new(0, 5, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = nome
    TabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    TabBtn.LayoutOrder = ordem
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame")
    Page.Name = nome .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = false
    Page.Parent = PagesContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 15)
    end)

    Pages[nome] = {Btn = TabBtn, Frame = Page}

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do
            v.Frame.Visible = false
            v.Btn.TextColor3 = Color3.fromRGB(140, 140, 140)
            v.Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)
end

CriarAba("PVP", 1)
CriarAba("Blatant", 2)
CriarAba("Visual", 3)
CriarAba("Misc", 4)
CriarAba("Config", 5)

Pages["PVP"].Frame.Visible = true
Pages["PVP"].Btn.TextColor3 = Color3.fromRGB(0, 255, 170)
Pages["PVP"].Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

-- ====================================================================
-- COMPONENTES VISUAIS REFORMULADOS (COM SLIDER MOBILE-FRIENDLY)
-- ====================================================================
local function AdicionarToggle(abaFrame, texto, estadoInicial, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    Frame.BorderSizePixel = 0
    Frame.Parent = abaFrame
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = texto
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 44, 0, 22)
    Btn.Position = UDim2.new(1, -50, 0.5, -11)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    local status = estadoInicial
    local function atualizar()
        if status then
            Btn.Text = "ON"
            Btn.TextColor3 = Color3.fromRGB(20, 20, 20)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        else
            Btn.Text = "OFF"
            Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        callback(status)
    end
    
    Btn.MouseButton1Click:Connect(function() status = not status atualizar() end)
    atualizar()
end

local function AdicionarSliderCustom(abaFrame, texto, min, max, inicial, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = abaFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.BackgroundTransparency = 1
    Label.Text = texto .. ": " .. inicial
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local TouchArea = Instance.new("TextButton")
    TouchArea.Size = UDim2.new(1, 0, 0, 24)
    TouchArea.Position = UDim2.new(0, 0, 0, 22)
    TouchArea.BackgroundTransparency = 1
    TouchArea.Text = ""
    TouchArea.Parent = Frame

    local FundoSlider = Instance.new("Frame")
    FundoSlider.Size = UDim2.new(1, 0, 0, 6)
    FundoSlider.Position = UDim2.new(0, 0, 0.5, -3)
    FundoSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    FundoSlider.BorderSizePixel = 0
    FundoSlider.Parent = TouchArea
    Instance.new("UICorner", FundoSlider).CornerRadius = UDim.new(1, 0)

    local BarraProgresso = Instance.new("Frame")
    local peso = (inicial - min) / (max - min)
    BarraProgresso.Size = UDim2.new(peso, 0, 1, 0)
    BarraProgresso.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    BarraProgresso.BorderSizePixel = 0
    BarraProgresso.Parent = FundoSlider
    Instance.new("UICorner", BarraProgresso).CornerRadius = UDim.new(1, 0)

    local BotaoArrastar = Instance.new("Frame")
    local arrastarSize = 20
    BotaoArrastar.Size = UDim2.new(0, arrastarSize, 0, arrastarSize)
    BotaoArrastar.Position = UDim2.new(peso, -(arrastarSize/2), 0.5, -(arrastarSize/2))
    BotaoArrastar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BotaoArrastar.Parent = FundoSlider
    Instance.new("UICorner", BotaoArrastar).CornerRadius = UDim.new(1, 0)
    
    local BotaoStroke = Instance.new("UIStroke")
    BotaoStroke.Thickness = 1.5
    BotaoStroke.Color = Color3.fromRGB(20, 20, 20)
    BotaoStroke.Parent = BotaoArrastar

    local ativo = false
    local function update()
        local mousePos = UserInputService:GetMouseLocation()
        local percent = math.clamp((mousePos.X - FundoSlider.AbsolutePosition.X) / FundoSlider.AbsoluteSize.X, 0, 1)
        BotaoArrastar.Position = UDim2.new(percent, -(arrastarSize/2), 0.5, -(arrastarSize/2))
        BarraProgresso.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.round(min + (percent * (max - min)))
        Label.Text = texto .. ": " .. val
        callback(val)
    end

    TouchArea.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            ativo = true
            update()
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            ativo = false
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if ativo and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update()
        end
    end)
end

local function AdicionarToggleComCor(abaFrame, texto, estadoInicial, corIndexInicial, callbackToggle, callbackCor)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    Frame.BorderSizePixel = 0
    Frame.Parent = abaFrame
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = texto
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ColorSquare = Instance.new("TextButton")
    ColorSquare.Size = UDim2.new(0, 16, 0, 16)
    ColorSquare.Position = UDim2.new(1, -75, 0.5, -8)
    ColorSquare.Text = ""
    ColorSquare.BackgroundColor3 = CoresPredefinidas[corIndexInicial]
    ColorSquare.Parent = Frame
    Instance.new("UICorner", ColorSquare).CornerRadius = UDim.new(0, 4)

    local indexCor = corIndexInicial
    ColorSquare.MouseButton1Click:Connect(function()
        indexCor = indexCor + 1
        if indexCor > #CoresPredefinidas then indexCor = 1 end
        ColorSquare.BackgroundColor3 = CoresPredefinidas[indexCor]
        callbackCor(indexCor)
    end)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 44, 0, 22)
    Btn.Position = UDim2.new(1, -50, 0.5, -11)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    local status = estadoInicial
    local function atualizar()
        if status then
            Btn.Text = "ON"
            Btn.TextColor3 = Color3.fromRGB(20, 20, 20)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        else
            Btn.Text = "OFF"
            Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        callbackToggle(status)
    end
    Btn.MouseButton1Click:Connect(function() status = not status atualizar() end)
    atualizar()
end

-- ====================================================================
-- CONFIGURAÇÃO DAS ABAS
-- ====================================================================
local PvpPage = Pages["PVP"].Frame
AdicionarToggle(PvpPage, "Ativar Knife Track", Config.Enabled, function(v) Config.Enabled = v end)
AdicionarSliderCustom(PvpPage, "Distância Máxima (Range)", Config.MinRange, Config.MaxRange, Config.Range, function(v) Config.Range = v end)
AdicionarToggle(PvpPage, "Ativar Kill Aura", Config.KillAura, function(v) Config.KillAura = v end)
AdicionarToggle(PvpPage, "Ativar Aimbot", Config.Aimbot, function(v) Config.Aimbot = v end)
AdicionarSliderCustom(PvpPage, "Aimbot FOV", 50, 500, Config.AimbotFov, function(v) Config.AimbotFov = v end)
AdicionarToggle(PvpPage, "Hitbox Expander (Cabeça)", Config.HitboxExpander, function(v) Config.HitboxExpander = v end)
AdicionarSliderCustom(PvpPage, "Tamanho da Hitbox", 2, 20, Config.HitboxSize, function(v) Config.HitboxSize = v end)
AdicionarToggle(PvpPage, "Auto Clicker", Config.AutoClicker, function(v) Config.AutoClicker = v end)

local BlatantPage = Pages["Blatant"].Frame
AdicionarToggle(BlatantPage, "Bala Mágica (Silent Aim)", Config.MagicBullet, function(v) Config.MagicBullet = v end)
AdicionarSliderCustom(BlatantPage, "Regulagem / Chance (%)", 1, 100, Config.MagicChance, function(v) Config.MagicChance = v end)
AdicionarToggle(BlatantPage, "Matar Atrás das Paredes", Config.Wallbang, function(v) Config.Wallbang = v end)
AdicionarToggle(BlatantPage, "Munição Infinita (Universal)", Config.InfAmmo, function(v) Config.InfAmmo = v end)

local VisualPage = Pages["Visual"].Frame
AdicionarToggleComCor(VisualPage, "ESP Geral (Boxes)", Config.EspBox, Config.EspColorIndex, function(v) Config.EspBox = v end, function(c) Config.EspColorIndex = c end)
AdicionarToggle(VisualPage, "  ↳ Exibir Linhas", Config.EspLine, function(v) Config.EspLine = v end)
AdicionarToggle(VisualPage, "  ↳ Exibir Nomes", Config.EspName, function(v) Config.EspName = v end)
AdicionarToggle(VisualPage, "  ↳ Exibir Vida", Config.EspHealth, function(v) Config.EspHealth = v end)
AdicionarToggle(VisualPage, "  ↳ Exibir Distância", Config.EspDistance, function(v) Config.EspDistance = v end)
AdicionarToggleComCor(VisualPage, "Chams (Paredes)", Config.Chams, Config.ChamsColorIndex, function(v) Config.Chams = v end, function(c) Config.ChamsColorIndex = c end)

local MiscPage = Pages["Misc"].Frame
AdicionarSliderCustom(MiscPage, "Mudar Velocidade (Speed)", 16, 120, Config.WalkSpeed, function(v) Config.WalkSpeed = v end)
AdicionarSliderCustom(MiscPage, "Mudar Força do Pulo", 50, 200, Config.JumpPower, function(v) Config.JumpPower = v end)
AdicionarToggle(MiscPage, "Pulo Infinito", Config.InfJump, function(v) Config.InfJump = v end)
AdicionarToggle(MiscPage, "Anti-AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)

local ConfigPage = Pages["Config"].Frame

local InfoCard = Instance.new("Frame")
InfoCard.Size = UDim2.new(1, -10, 0, 70)
InfoCard.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InfoCard.BorderSizePixel = 0
InfoCard.Parent = ConfigPage
Instance.new("UICorner", InfoCard).CornerRadius = UDim.new(0, 6)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 50, 0, 50)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -25)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
AvatarImg.Parent = InfoCard
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local TxNome = Instance.new("TextLabel")
TxNome.Size = UDim2.new(1, -75, 0, 18)
TxNome.Position = UDim2.new(0, 70, 0, 10)
TxNome.BackgroundTransparency = 1
TxNome.Text = "User: " .. LocalPlayer.Name
TxNome.TextColor3 = Color3.fromRGB(255, 255, 255)
TxNome.Font = Enum.Font.GothamBold
TxNome.TextSize = 12
TxNome.TextXAlignment = Enum.TextXAlignment.Left
TxNome.Parent = InfoCard

local TxDisplay = Instance.new("TextLabel")
TxDisplay.Size = UDim2.new(1, -75, 0, 15)
TxDisplay.Position = UDim2.new(0, 70, 0, 28)
TxDisplay.BackgroundTransparency = 1
TxDisplay.Text = "Nick: " .. LocalPlayer.DisplayName
TxDisplay.TextColor3 = Color3.fromRGB(160, 160, 160)
TxDisplay.Font = Enum.Font.Gotham
TxDisplay.TextSize = 11
TxDisplay.TextXAlignment = Enum.TextXAlignment.Left
TxDisplay.Parent = InfoCard

local function CriarBotaoConfig(texto, cor, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 32)
    Btn.BackgroundColor3 = cor
    Btn.Text = texto
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.Parent = ConfigPage
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

CriarBotaoConfig("Salvar Configurações", Color3.fromRGB(34, 139, 34), function()
    if writefile then
        pcall(function() writefile("Blockspin_Blatant_Config.json", HttpService:JSONEncode(Config)) end)
    end
end)

CriarBotaoConfig("Carregar Configurações", Color3.fromRGB(45, 45, 45), function()
    if isfile and isfile("Blockspin_Blatant_Config.json") then
        pcall(function()
            local dados = HttpService:JSONDecode(readfile("Blockspin_Blatant_Config.json"))
            for k, v in pairs(dados) do Config[k] = v end
        end)
    end
end)

local function CriarArrastavel(frame, gatilho)
    gatilho = gatilho or frame
    local dragging, dragInput, dragStart, startPos
    gatilho.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gatilho.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
CriarArrastavel(MainFrame, TitleBar)

local SmallFrame = Instance.new("TextButton")
SmallFrame.Size = UDim2.new(0, 60, 0, 30)
SmallFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
SmallFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SmallFrame.Text = "OPEN"
SmallFrame.TextColor3 = Color3.fromRGB(0, 255, 170)
SmallFrame.Font = Enum.Font.GothamBold
SmallFrame.TextSize = 11
SmallFrame.Visible = false
SmallFrame.Active = true
SmallFrame.Parent = ScreenGui
Instance.new("UICorner", SmallFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", SmallFrame).Color = Color3.fromRGB(45, 45, 45)
CriarArrastavel(SmallFrame)

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false SmallFrame.Position = MainFrame.Position SmallFrame.Visible = true end)
SmallFrame.MouseButton1Click:Connect(function() SmallFrame.Visible = false MainFrame.Visible = true end)

-- ====================================================================
-- SISTEMA DE INTERNALS E CACHE (ESP E REMOÇÃO)
-- ====================================================================
local function ObterOuCriarEsp(player)
    if PlayerEspCache[player] then return PlayerEspCache[player] end
    local Box = Instance.new("Frame")
    Box.BackgroundTransparency = 1; Box.Visible = false; Box.Parent = EspScreenGui
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5; Stroke.Parent = Box

    local Line = Instance.new("Frame")
    Line.BorderSizePixel = 0; Line.AnchorPoint = Vector2.new(0.5, 0.5); Line.Visible = false; Line.Parent = EspScreenGui

    local Tag = Instance.new("TextLabel")
    Tag.BackgroundTransparency = 1; Tag.Font = Enum.Font.GothamBold; Tag.TextSize = 11
    Tag.TextStrokeTransparency = 0; Tag.TextStrokeColor3 = Color3.new(0,0,0); Tag.Visible = false; Tag.Parent = EspScreenGui

    local Highlight = Instance.new("Highlight")
    Highlight.Enabled = false

    PlayerEspCache[player] = {Box = Box, Stroke = Stroke, Line = Line, Tag = Tag, Highlight = Highlight}
    return PlayerEspCache[player]
end

Players.PlayerRemoving:Connect(function(player)
    if PlayerEspCache[player] then
        pcall(function()
            PlayerEspCache[player].Box:Destroy()
            PlayerEspCache[player].Line:Destroy()
            PlayerEspCache[player].Tag:Destroy()
            if PlayerEspCache[player].Highlight then PlayerEspCache[player].Highlight:Destroy() end
        end)
        PlayerEspCache[player] = nil
    end
end)

local function ObterInimigoMaisProximo()
    local MenorDistancia = math.huge
    local AlvoProximo = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local TargetHead = player.Character.Head
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local Distancia = (LocalPlayer.Character.HumanoidRootPart.Position - TargetHead.Position).Magnitude
                if Distancia < MenorDistancia and Distancia <= Config.Range then
                    MenorDistancia = Distancia
                    AlvoProximo = player
                end
            end
        end
    end
    return AlvoProximo, MenorDistancia
end

local function ChecarParede(AlvoChar)
    if not AlvoChar or not AlvoChar:FindFirstChild("Head") then return false end
    local RayParam = RaycastParams.new()
    RayParam.FilterDescendantsInstances = {LocalPlayer.Character, AlvoChar}
    RayParam.FilterType = Enum.RaycastFilterType.Exclude
    local Hit = workspace:Raycast(Camera.CFrame.Position, (AlvoChar.Head.Position - Camera.CFrame.Position).Unit * 1000, RayParam)
    return Hit ~= nil
end

local function EquiparArma()
    if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local ferramenta = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if ferramenta then ferramenta.Parent = LocalPlayer.Character end
    end
end

local PlayerMouse = LocalPlayer:GetMouse()
local OldIndex
OldIndex = hookmetamethod(game, "__index", function(Self, Key)
    if Config.MagicBullet and not checkcaller() and Self == PlayerMouse then
        if Key == "Hit" or Key == "hit" then
            local Alvo = ObterInimigoMaisProximo()
            if Alvo and Alvo.Character and Alvo.Character:FindFirstChild("Head") then
                if math.random(1, 100) <= Config.MagicChance and (Config.Wallbang or not ChecarParede(Alvo.Character)) then
                    return CFrame.new(Alvo.Character.Head.Position)
                end
            end
        elseif Key == "Target" or Key == "target" then
            local Alvo = ObterInimigoMaisProximo()
            if Alvo and Alvo.Character and Alvo.Character:FindFirstChild("Head") then
                if math.random(1, 100) <= Config.MagicChance and (Config.Wallbang or not ChecarParede(Alvo.Character)) then
                    return Alvo.Character.Head
                end
            end
        end
    end
    return OldIndex(Self, Key)
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    if not checkcaller() and Config.MagicBullet then
        if Method == "Raycast" then
            local Alvo = ObterInimigoMaisProximo()
            if Alvo and Alvo.Character and Alvo.Character:FindFirstChild("Head") then
                if math.random(1, 100) <= Config.MagicChance and (Config.Wallbang or not ChecarParede(Alvo.Character)) then
                    local Head = Alvo.Character.Head
                    Args[1] = Head.Position - Vector3.new(0, 0.2, 0)
                    Args[2] = Vector3.new(0, 0.5, 0)
                    return OldNamecall(Self, unpack(Args))
                end
            end
        elseif Method == "FindPartOnRay" or Method == "FindPartOnRayWithIgnoreList" then
            local Alvo = ObterInimigoMaisProximo()
            if Alvo and Alvo.Character and Alvo.Character:FindFirstChild("Head") then
                if math.random(1, 100) <= Config.MagicChance and (Config.Wallbang or not ChecarParede(Alvo.Character)) then
                    local Head = Alvo.Character.Head
                    Args[1] = Ray.new(Head.Position - Vector3.new(0, 0.2, 0), Vector3.new(0, 0.5, 0))
                    return OldNamecall(Self, unpack(Args))
                end
            end
        elseif Method == "FireServer" then
            local nameLower = Self.Name:lower()
            if nameLower:find("hit") or nameLower:find("shoot") or nameLower:find("fire") or nameLower:find("bullet") or nameLower:find("dmg") or nameLower:find("damage") or nameLower:find("attack") then
                local Alvo = ObterInimigoMaisProximo()
                if Alvo and Alvo.Character and Alvo.Character:FindFirstChild("Head") then
                    if Config.Wallbang or not ChecarParede(Alvo.Character) then
                        for i = 1, #Args do
                            if typeof(Args[i]) == "Instance" then
                                if Args[i]:IsA("BasePart") or Args[i]:IsA("Humanoid") or Args[i] == workspace or Args[i].Parent == workspace then
                                    Args[i] = Alvo.Character.Head
                                end
                            elseif typeof(Args[i]) == "Vector3" then
                                Args[i] = Alvo.Character.Head.Position
                            elseif typeof(Args[i]) == "CFrame" then
                                Args[i] = CFrame.new(Alvo.Character.Head.Position)
                            end
                        end
                        return OldNamecall(Self, unpack(Args))
                    end
                end
            end
        end
    end
    return OldNamecall(Self, ...)
end)

-- ====================================================================
-- OTIMIZAÇÃO GLOBAL DO GC (MUNIÇÃO INFINITA)
-- ====================================================================
local WeaponTablesCache = {}

task.spawn(function()
    while true do
        if Config.InfAmmo then
            pcall(function()
                local gc = getgc(true)
                for i = 1, #gc do
                    local v = gc[i]
                    if typeof(v) == "table" then
                        if rawget(v, "Ammo") or rawget(v, "Clip") or rawget(v, "Mag") or rawget(v, "AmmoLeft") then
                            if not table.find(WeaponTablesCache, v) then
                                table.insert(WeaponTablesCache, v)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(5)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.InfAmmo and #WeaponTablesCache > 0 then
            for i = 1, #WeaponTablesCache do
                local v = WeaponTablesCache[i]
                pcall(function()
                    if v.Ammo then v.Ammo = 999 end
                    if v.Clip then v.Clip = 999 end
                    if v.Mag then v.Mag = 999 end
                    if v.AmmoLeft then v.AmmoLeft = 999 end
                end)
            end
        end
    end
end)

-- ====================================================================
-- LOOPS SECUNDÁRIOS E RENDERIZAÇÃO
-- ====================================================================
task.spawn(function()
    while task.wait(0.3) do 
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if Config.HitboxExpander then
                    head.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    head.Transparency = 0.6
                    head.BrickColor = BrickColor.new("Really red")
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                    head.Massless = true
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                    head.Material = Enum.Material.Plastic
                end
            end
        end
    end
end)

RunService.PreSimulation:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.WalkSpeed = Config.WalkSpeed
        hum.JumpPower = Config.JumpPower
    end
    if Config.Aimbot then
        local Alvo = ObterInimigoMaisProximo()
        if Alvo and Alvo.Character and Alvo.Character:FindFirstChild("Head") then
            local HeadPos, OnScreen = Camera:WorldToViewportPoint(Alvo.Character.Head.Position)
            if OnScreen then
                local MousePos = UserInputService:GetMouseLocation()
                local DistanciaDoMouse = (Vector2.new(HeadPos.X, HeadPos.Y) - MousePos).Magnitude
                if DistanciaDoMouse <= Config.AimbotFov then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Alvo.Character.Head.Position), 0.2)
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = ObterOuCriarEsp(player)
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if char and hrp and hum and hum.Health > 0 then
                local corEsp = CoresPredefinidas[Config.EspColorIndex]
                if Config.Chams then
                    esp.Highlight.Parent = char; esp.Highlight.Enabled = true
                    esp.Highlight.FillColor = CoresPredefinidas[Config.ChamsColorIndex]
                else esp.Highlight.Enabled = false end

                local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local tamanhoY = math.clamp((Camera.ViewportSize.Y / hrpPos.Z) * 4.5, 5, 400)
                    local tamanhoX = tamanhoY * 0.6

                    if Config.EspBox then
                        esp.Box.Visible = true
                        esp.Box.Position = UDim2.new(0, hrpPos.X - (tamanhoX/2), 0, hrpPos.Y - (tamanhoY/2))
                        esp.Box.Size = UDim2.new(0, tamanhoX, 0, tamanhoY)
                        esp.Stroke.Color = corEsp
                    else esp.Box.Visible = false end

                    if Config.EspLine then
                        local startPt = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        local endPt = Vector2.new(hrpPos.X, hrpPos.Y + (tamanhoY/2))
                        local midpoint = (startPt + endPt) / 2
                        local diff = endPt - startPt
                        esp.Line.Visible = true; esp.Line.Position = UDim2.new(0, midpoint.X, 0, midpoint.Y)
                        esp.Line.Size = UDim2.new(0, diff.Magnitude, 0, 1.5); esp.Line.Rotation = math.deg(math.atan2(diff.Y, diff.X))
                        esp.Line.BackgroundColor3 = corEsp
                    else esp.Line.Visible = false end

                    local textStr = ""
                    if Config.EspName then textStr = textStr .. player.DisplayName .. "\n" end
                    if Config.EspHealth then textStr = textStr .. "HP: " .. math.round(hum.Health) .. "\n" end
                    if textStr ~= "" then
                        esp.Tag.Visible = true; esp.Tag.Text = textStr; esp.Tag.TextColor3 = corEsp
                        esp.Tag.Position = UDim2.new(0, hrpPos.X - 100, 0, hrpPos.Y - (tamanhoY/2) - 30)
                        esp.Tag.Size = UDim2.new(0, 200, 0, 30)
                    else esp.Tag.Visible = false end
                else
                    esp.Box.Visible = false; esp.Line.Visible = false; esp.Tag.Visible = false
                end
            else
                esp.Box.Visible = false; esp.Line.Visible = false; esp.Tag.Visible = false; esp.Highlight.Enabled = false
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        if Config.AutoClicker then
            EquiparArma()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
        if (Config.Enabled or Config.KillAura) then
            local alvo, distancia = ObterInimigoMaisProximo()
            if alvo and distancia <= Config.Range then
                EquiparArma()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Config.JumpPower, hrp.AssemblyLinearVelocity.Z)
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end
end)
