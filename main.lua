local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Player.Character:WaitForChild("Humanoid")

local animationRun = Instance.new("Animation")
animationRun.AnimationId = "rbxassetid://136252471123500"
local animationRunLow = Instance.new("Animation")
animationRunLow.AnimationId = "rbxassetid://115946474977409" 
local run = nil
local runLow = nil

local lockingTable = {}

local camera = game.Workspace.CurrentCamera

local IsPlaying = false
local isMakeTrack = false

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "KillersMode"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = false
local BG = Instance.new("Frame", ScreenGui)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundTransparency = 0.8
BG.BackgroundColor3 = Color3.fromRGB(238, 0, 255)
BG.Name = "BG"
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "IMAGE"
Main.Size = UDim2.new(1, 0, 1, 0)
Main.BackgroundTransparency = 1
local Screen = Instance.new("ImageLabel", Main)
Screen.Position = UDim2.new(0, 0, -0.045, 0)
Screen.Size = UDim2.new(1, 0, 1, 0)
Screen.Image = "http://www.roblox.com/asset/?id=125826138405844"
Screen.BackgroundTransparency = 1

local guiElement = Main
local originalPosition = guiElement.Position

local swayAmount = 500
local smoothness = 0.1

local lastCameraCFrame = camera.CFrame
local swayX = 0
local swayY = 0

local isESP = false
local isSurESP = true
local SurESPTran = .5
local colorSurvival = Color3.fromRGB(255, 248, 54)
local isKilESP = true
local KilESPTran = .5
local colorKiller = Color3.fromRGB(205, 54, 255)
local isGenESP = true
local GenESPTran = .5
local colorGen = Color3.fromRGB(54, 255, 84)
local isMicESP = true
local MicESPTran = .5
local colorMic = Color3.fromRGB(255, 54, 54)
local KillerMode = false
local InfStaminaMode = false

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ThemeSet = {
    TextColor = Color3.fromRGB(240, 240, 240),

    Background = Color3.fromRGB(13,11,9),
    Topbar = Color3.fromRGB(13,11,9),
    Shadow = Color3.fromRGB(13,11,9),

    NotificationBackground = Color3.fromRGB(20, 20, 20),
    NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

    TabBackground = Color3.fromRGB(80, 80, 80),
    TabStroke = Color3.fromRGB(85, 85, 85),
    TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
    TabTextColor = Color3.fromRGB(240, 240, 240),
    SelectedTabTextColor = Color3.fromRGB(50, 50, 50),

    ElementBackground = Color3.fromRGB(35, 35, 35),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
    SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
    ElementStroke = Color3.fromRGB(50, 50, 50),
    SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
            
    SliderBackground = Color3.fromRGB(25, 25, 25),
    SliderProgress = Color3.fromRGB(168, 168, 168),
    SliderStroke = Color3.fromRGB(168, 168, 168),

    ToggleBackground = Color3.fromRGB(30, 30, 30),
    ToggleEnabled = Color3.fromRGB(255, 255, 255),
    ToggleDisabled = Color3.fromRGB(100, 100, 100),
    ToggleEnabledStroke = Color3.fromRGB(255, 255, 255),
    ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
    ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
    ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

    DropdownSelected = Color3.fromRGB(40, 40, 40),
    DropdownUnselected = Color3.fromRGB(30, 30, 30),

    InputBackground = Color3.fromRGB(30, 30, 30),
    InputStroke = Color3.fromRGB(65, 65, 65),
    PlaceholderColor = Color3.fromRGB(178, 178, 178)
}

local Window = Rayfield:CreateWindow({
   Name = "Forsken Hub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Forsken",
   LoadingSubtitle = "",
   Theme = ThemeSet, -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local ESPTab = Window:CreateTab("ESP", "scan-eye")
local KillerTab = Window:CreateTab("Killer Mode", "sword")
local CharacterTab = Window:CreateTab("Character", "person-standing")

local ESPToggle = ESPTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
	    isESP = Value
   end,
})

local TextESPSUR = ESPTab:CreateLabel("ESP Survival", "smile")

local ESPSurvivalToggle = ESPTab:CreateToggle({
    Name = "Survival ESP",
    CurrentValue = true,
    Flag = "SurvESP",
    Callback = function(Value)
        isSurESP = Value
    end,
 })

local ESPSURTRA = ESPTab:CreateSlider({
    Name = "Survival Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ESPSURTRA",
    Callback = function(Value)
        SurESPTran = Value
    end,
})

local SurvivalColorPick = ESPTab:CreateColorPicker({
    Name = "Survival Color",
    Color = Color3.fromRGB(255, 248, 54),
    Flag = "SurvivalColorPick",
    Callback = function(Value)
        colorSurvival = Value
    end
})

local TextESPKIL = ESPTab:CreateLabel("ESP Killer", "sword")

local ESPKillerToggle = ESPTab:CreateToggle({
    Name = "Killer ESP",
    CurrentValue = true,
    Flag = "KillESP",
    Callback = function(Value)
        isKilESP = Value
    end,
})

local ESPKILTRA = ESPTab:CreateSlider({
    Name = "Killer Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ESPKILTRA",
    Callback = function(Value)
        KilESPTran = Value
    end,
})

local KillerColorPick = ESPTab:CreateColorPicker({
    Name = "Killer Color",
    Color = Color3.fromRGB(205, 54, 255),
    Flag = "KillerColorPick",
    Callback = function(Value)
        colorKiller = Value
    end
})

local TextESPGEN = ESPTab:CreateLabel("ESP Generator", "flame")

local ESPGeneratorToggle = ESPTab:CreateToggle({
    Name = "Generator ESP",
    CurrentValue = true,
    Flag = "GENESP",
    Callback = function(Value)
        isGenESP = Value
    end,
})

local ESPGENTRA = ESPTab:CreateSlider({
    Name = "Generator Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ESPGENTRA",
    Callback = function(Value)
        GenESPTran = Value
    end,
})

local GeneratorColorPick = ESPTab:CreateColorPicker({
    Name = "Generator Color",
    Color = Color3.fromRGB(54, 255, 84),
    Flag = "GeneratorColorPick",
    Callback = function(Value)
        colorGen = Value
    end
})

local TextESPMice = ESPTab:CreateLabel("ESP Others", "hash")

local ESPMiceToggle = ESPTab:CreateToggle({
    Name = "Others ESP",
    CurrentValue = true,
    Flag = "MiceESP",
    Callback = function(Value)
        isMicESP = Value
    end,
})

local ESPMiceTRA = ESPTab:CreateSlider({
    Name = "Others Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ESPMiceTRA",
    Callback = function(Value)
        MicESPTran = Value
    end,
})

local MiceColorPick = ESPTab:CreateColorPicker({
    Name = "Others Color",
    Color = Color3.fromRGB(255, 54, 54),
    Flag = "MiceColorPick",
    Callback = function(Value)
        colorMic = Value
    end
})
--killer tab
local KillerModeToggle = KillerTab:CreateToggle({
    Name = "Killer Mode",
    CurrentValue = false,
    Flag = "KillerMode",
    Callback = function(Value)
        KillerMode = Value
    end,
})

--Charcater tab
local InfStaminaToggle = CharacterTab:CreateToggle({
    Name = "Inf Stamina Mode",
    CurrentValue = false,
    Flag = "InfStaminaToggle",
    Callback = function(Value)
        InfStaminaMode = Value
    end,
})
CharacterTab:CreateLabel("Infstamina is still have bug. Rejoin to fix.", "bug")

Rayfield:Notify({
   Title = "Loading Success",
   Content = "Have Fun",
   Duration = 1,
   Image = 4483362458,
})

RunService.RenderStepped:Connect(function(deltaTime)
    Character = Player.Character
    local Humanoid = Character:WaitForChild("Humanoid")
    local animator = Humanoid:FindFirstChildOfClass("Animator")
    local map = workspace:WaitForChild("Map")
    local Ingame = map:WaitForChild("Ingame")
    local currentCFrame = camera.CFrame
	local delta = currentCFrame:ToObjectSpace(lastCameraCFrame)
	lastCameraCFrame = currentCFrame
	local _, yRot, xRot = delta:ToEulerAnglesYXZ()
	local targetX = math.clamp(-math.deg(yRot) * 0.5, -swayAmount, swayAmount)
	local targetY = math.clamp(-math.deg(xRot) * 0.5, -swayAmount, swayAmount)

	swayX = swayX + (targetX - swayX) * smoothness
	swayY = swayY + (targetY - swayY) * smoothness

	guiElement.Position = originalPosition + UDim2.new(0, swayX, 0, swayY)

    if InfStaminaMode then

        if Character.Parent.Name == "Survivors" then
            local SpeedMultipliers = Character:FindFirstChild("SpeedMultipliers")

            if SpeedMultipliers then
                if not run then
                    animator = Humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        run = animator:LoadAnimation(animationRun)
                        run.Priority = Enum.AnimationPriority.Action
                    end
                end
    
                if not runLow then
                    animator = Humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        runLow = animator:LoadAnimation(animationRunLow)
                        runLow.Priority = Enum.AnimationPriority.Action
                    end
                end
    
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    local tweenCam = TweenService:Create(Character.FOVMultipliers.Sprinting, TweenInfo.new(0.75, Enum.EasingStyle.Linear), {Value = 1.125})
                    tweenCam:Play()
                    if Humanoid.MoveDirection.Magnitude > 0 then
                        local tween = TweenService:Create(SpeedMultipliers.Sprinting, TweenInfo.new(0.75, Enum.EasingStyle.Linear), {Value = 2.167})
                        tween:Play()
    
                        if Humanoid.Health > 55 then
                            if run and not run.IsPlaying then
                                run:Play(.35)
                            end
                        else
                            if runLow and not runLow.IsPlaying then
                                runLow:Play(.35)
                            end
                        end
                    end
                elseif not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    SpeedMultipliers.Sprinting.Value = 1
                    local tweenCam = TweenService:Create(Character.FOVMultipliers.Sprinting, TweenInfo.new(0.75, Enum.EasingStyle.Linear), {Value = 1})
                    tweenCam:Play()
                    if run or runLow then
                        run:Stop(.35)
                        runLow:Stop(.35)
                    end
                end
            end
        end
        
    end

    for _, plr in game.Players:GetChildren() do
        local char = plr.Character
		if char ~= nil then
            if char.Parent ~= nil then
                if char ~= Character then
                    if not char:FindFirstChild("ESP") then
                        local ESP = Instance.new("Highlight", char)
                        ESP.Name = "ESP"
                        ESP.FillTransparency = 1
                        ESP.OutlineTransparency = 1
                    end
        
                    if char.Parent.Name == "Survivors" then
                        char.ESP.OutlineColor = colorSurvival
                        char.ESP.FillColor = colorSurvival
                    elseif char.Parent.Name == "Killers" then
                        char.ESP.OutlineColor = colorKiller
                        char.ESP.FillColor = colorKiller
                    end
                
                    if isESP == true then
                        if char.Parent.Name == "Survivors" and Character.Parent.Name ~= "Killers" then
                            if isSurESP == true then
                                local tween = TweenService:Create(char.ESP, TweenInfo.new(.3), {FillTransparency = SurESPTran})
                                local tween1 = TweenService:Create(char.ESP, TweenInfo.new(.3), {OutlineTransparency = 0})
                                tween1:Play()
                                tween:Play()
                                tween.Completed:Connect(function()
                                    char.ESP.FillTransparency = SurESPTran
                                end)
                            else
                                local tween = TweenService:Create(char.ESP, TweenInfo.new(.3), {FillTransparency = 1})
                                tween:Play()
                            end
                        elseif char.Parent.Name == "Killers" then
                            if isKilESP == true then
                                local tween = TweenService:Create(char.ESP, TweenInfo.new(.3), {FillTransparency = KilESPTran})
                                local tween1 = TweenService:Create(char.ESP, TweenInfo.new(.3), {OutlineTransparency = 0})
                                tween1:Play()
                                tween:Play()
                                tween.Completed:Connect(function()
                                    char.ESP.FillTransparency = KilESPTran
                                end)
                            else
                                local tween = TweenService:Create(char.ESP, TweenInfo.new(.3), {FillTransparency = 1})
                                tween:Play()
                            end
                        end
                    elseif isESP == false then
                        local tween = TweenService:Create(char.ESP, TweenInfo.new(.3), {OutlineTransparency = 1})
                        local tween1 = TweenService:Create(char.ESP, TweenInfo.new(.3), {FillTransparency = 1})
                        tween:Play()
                        tween1:Play()
                    end
                end
            end
        end
	end

    local Map = Ingame:FindFirstChild("Map")
    if Map then
        for _, Generator in ipairs(Map:GetChildren()) do
            if Generator.Name == "Generator" then
                if not Generator:FindFirstChild("ESP") then
                    local ESP = Instance.new("Highlight", Generator)
                    ESP.Name = "ESP"
                    ESP.FillTransparency = 1
                    ESP.OutlineTransparency = 1
                    ESP.FillColor = colorGen
                    ESP.OutlineColor = colorGen
                end
                Generator.ESP.FillColor = colorGen
                Generator.ESP.OutlineColor = colorGen
                local Progress = Generator:FindFirstChild("Progress")
                if Progress then
                    if isESP == true then
                        if isGenESP then
                            if Progress.Value == 100 then
                                local tween = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {OutlineTransparency = 1})
                                local tween1 = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {FillTransparency = 1})
                                tween:Play()
                                tween1:Play()
                            else
                                local tween = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {OutlineTransparency = 0})
                                local tween1 = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {FillTransparency = GenESPTran})
                                tween:Play()
                                tween1:Play()
                            end
                        else
                            local tween = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {OutlineTransparency = 1})
                            local tween1 = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {FillTransparency = 1})
                            tween:Play()
                            tween1:Play()
                        end
                    else
                        local tween = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {OutlineTransparency = 1})
                        local tween1 = TweenService:Create(Generator.ESP, TweenInfo.new(.3), {FillTransparency = 1})
                        tween:Play()
                        tween1:Play()
                    end
                end
            end
        end
    end

    if isESP == true then
        for _, Mic in Ingame:GetChildren() do
            if Mic.Name ~= "Map" and Mic:IsA("Model") and Mic.Name ~= "Generator" then
                if not Mic:FindFirstChild("ESP") then
                    local ESP = Instance.new("Highlight", Mic)
                    ESP.Name = "ESP"
                    ESP.FillTransparency = MicESPTran
                    ESP.OutlineTransparency = 0
                    ESP.FillColor = colorMic
                    ESP.OutlineColor = colorMic
                else
                    local ESP = Mic:WaitForChild("ESP")
                    ESP.FillTransparency = MicESPTran
                    ESP.OutlineTransparency = 0
                    ESP.FillColor = colorMic
                    ESP.OutlineColor = colorMic
                end
            end
        end
    end

    if KillerMode then
        if Character.Parent ~= nil then
            if Character.Parent.Name == "Killers" then
                ScreenGui.Enabled = true

                for _, char in workspace.Players.Survivors:GetChildren() do
                    if char ~= nil then
                        local ESP = char:FindFirstChild("ESP")
                        if ESP then
                            ESP.DepthMode = Enum.HighlightDepthMode.Occluded
                            ESP.FillTransparency = 0.6
                            ESP.FillColor = Color3.fromRGB(170, 0, 255)
                            ESP.OutlineColor = Color3.fromRGB(170, 0, 255)
                
                            Player.CameraMode = Enum.CameraMode.LockFirstPerson
                
                            local player = game.Players:GetPlayerFromCharacter(char)
                            if player then
                                
                            end
                        end
                    end
                end                
            else
                ScreenGui.Enabled = false
                Player.CameraMode = Enum.CameraMode.Classic
                for _, char in workspace.Players.Survivors:GetChildren() do
                    local ESP = char:FindFirstChild("ESP")
                    if ESP then
                        ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        ESP.FillTransparency = SurESPTran
                        ESP.FillColor = colorSurvival
                        ESP.OutlineColor = colorSurvival
                    end
                end
            end
        end
    else
        ScreenGui.Enabled = false
        Player.CameraMode = Enum.CameraMode.Classic
        for _, char in workspace.Players.Survivors:GetChildren() do
            local ESP = char:FindFirstChild("ESP")
            if ESP then
                ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ESP.FillTransparency = SurESPTran
                ESP.FillColor = colorSurvival
                ESP.OutlineColor = colorSurvival
            end
        end
    end
end)
