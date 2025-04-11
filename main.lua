local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local map = workspace:WaitForChild("Map")
local Ingame = map:WaitForChild("Ingame")
local Map = Ingame:WaitForChild("Map")

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
local BG = Instance.new("Frame", ScreenGui)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundTransparency = 0.5
BG.Name = "BG"
BG.Visible = false
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(1, 0, 1, 0)
Main.Visible = false
local Screen = Instance.new("ImageLabel", Main)
Screen.Position = UDim2.new(0, 0, -0.045, 0)
Screen.Size = UDim2.new(1, 0, 1, 0)
Screen.Image = "http://www.roblox.com/asset/?id=125826138405844"

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

local ESPTab = Window:CreateTab("ESP", "scan-eye") -- Title, Image

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

Rayfield:Notify({
   Title = "Loading Success",
   Content = "Have Fun",
   Duration = 1,
   Image = 4483362458,
})

RunService.RenderStepped:Connect(function(deltaTime)
    if Character.Parent == "Killers" then
        Main.Visible = true
        Screen.Visible = true
    else
        Main.Visible = false
        Screen.Visible = false
    end

    for _, plr in game.Players:GetChildren() do
        local char = plr.Character
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
                if char.Parent.Name == "Survivors" then
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

    for _, Generator in ipairs(Map:GetChildren()) do
        if Generator.Name == "Generator" then
            if not Generator:FindFirstChild("ESP") then
                local ESP = Instance.new("Highlight", Generator)
                ESP.Name = "ESP"
                ESP.FillTransparency = GenESPTran
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

    if Character.Parent.Name == "Killers" then
        
    end
end)
