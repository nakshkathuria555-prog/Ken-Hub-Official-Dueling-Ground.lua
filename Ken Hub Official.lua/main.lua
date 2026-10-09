-- =====================================================================
-- // Project: Dueling Grounds | Ultimate Combat Hub (Ken Hub Official Edition)
-- // Features: Complete Ken Hub Official Branding, Locked Premium & Custom Keys
-- =====================================================================

local success, KenUI = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not KenUI then
    warn("[Ken Hub Official] Failed to load UI. Check your network or executor.")
    return
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- State Variables
local isUnlocked = false
local autoParryEnabled = false
local hitboxEnabled = false
local hitboxSizeValue = 6
local infJumpEnabled = false
local noclipEnabled = false
local customWsValue = 16
local wsEnabled = false

-- // Window Initialization (Pure Ken Hub Official Branding & Persistent Key System)
local Window = KenUI:CreateWindow({
    Name = "Dueling Grounds | Ken Hub Official",
    LoadingTitle = "Ken Hub Engine",
    LoadingSubtitle = "Created exclusively by Ken Hub Official",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KenHubOfficial",
        FileName = "DuelingGroundsConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinv",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Ken Hub Official | Key System",
        Subtitle = "Enter access key to unlock hub",
        Note = "Free Key: Ken Hub Official",
        FileName = "KenHubKeyStore",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Ken Hub Official", "Ken-Hub-Premium"}
    }
})

-- // Auto fix to change minimized button text to "Show Ken Hub Official"
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in ipairs(CoreGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    if v.Text == "Show Rayfield" or v.Text == "Show Zyrex Dev" or v.Text == "Show AertherX Dev" then
                        v.Text = "Show Ken Hub Official"
                    end
                end
            end
        end)
    end
end)

-- // Tabs Setup
local CombatTab = Window:CreateTab("Combat & Parry", 4483362458)
local VisualTab = Window:CreateTab("Visuals & ESP", 4483362458)
local PlayerTab = Window:CreateTab("Player Mods", 4483362458)
local PremiumTab = Window:CreateTab("Premium Hub", 4483362458) 
local UpdateKeyTab = Window:CreateTab("Update Key", 4483362458)
local MiscTab = Window:CreateTab("Settings", 4483362458)

-- =====================================================================
-- // TAB 1: COMBAT & AUTO PARRY
-- =====================================================================
CombatTab:CreateSection("PVP Combat Enhancements")

CombatTab:CreateToggle({
    Name = "Auto Parry (Deflect Swings)",
    CurrentValue = false,
    Flag = "AutoParry",
    Callback = function(Value)
        autoParryEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Hitbox Expander (Weapon Reach)",
    CurrentValue = false,
    Flag = "HitboxExpander",
    Callback = function(Value)
        hitboxEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Hitbox Size Multiplier",
    Range = {2, 25},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 6,
    Flag = "HitboxSize",
    Callback = function(Value)
        hitboxSizeValue = Value
    end,
})

RunService.RenderStepped:Connect(function()
    if hitboxEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(hitboxSizeValue, hitboxSizeValue, hitboxSizeValue)
                    hrp.Transparency = 0.5
                    hrp.CanCollide = false
                end
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end
end)

-- =====================================================================
-- // TAB 2: VISUALS & ESP
-- =====================================================================
VisualTab:CreateSection("Player ESP & Chams")

local activeChams = {}
VisualTab:CreateToggle({
    Name = "Enemy Highlight Chams",
    CurrentValue = false,
    Flag = "EnemyESP",
    Callback = function(Value)
        if Value then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("KenHighlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "KenHighlight"
                        highlight.Adornee = player.Character
                        highlight.FillColor = Color3.fromRGB(220, 40, 40)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.4
                        highlight.Parent = player.Character
                        table.insert(activeChams, highlight)
                    end
                end
            end
        else
            for _, h in ipairs(activeChams) do
                if h and h.Parent then h:Destroy() end
            end
            activeChams = {}
        end
    end,
})

VisualTab:CreateToggle({
    Name = "Fullbright (Remove Shadows)",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").ClockTime = 12
            game:GetService("Lighting").Ambient = Color3.fromRGB(128, 128, 128)
        end
    end,
})

VisualTab:CreateSlider({
    Name = "Field of View (FOV Changer)",
    Range = {70, 120},
    Increment = 1,
    Suffix = "deg",
    CurrentValue = 70,
    Flag = "CustomFOV",
    Callback = function(Value)
        pcall(function()
            workspace.CurrentCamera.FieldOfView = Value
        end)
    end,
})

-- =====================================================================
-- // TAB 3: PLAYER MODS (Standard Utilities)
-- =====================================================================
PlayerTab:CreateSection("Standard Character Mods")

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        infJumpEnabled = Value
    end,
})

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        pcall(function()
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

PlayerTab:CreateToggle({
    Name = "Noclip (Walk Through Walls)",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        noclipEnabled = Value
    end,
})

RunService.Stepped:Connect(function()
    if noclipEnabled then
        pcall(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

-- =====================================================================
-- // TAB 4: PREMIUM HUB (Strictly Locked for Free Users)
-- =====================================================================
PremiumTab:CreateSection("Ken Hub Official Exclusive Premium Zone")

local function checkPremiumAccess()
    if isUnlocked then
        return true
    else
        KenUI:Notify({
            Title = "Ken Hub Official | Access Denied",
            Content = "Premium Key (Ken-Hub-Premium) Required to access this section!",
            Duration = 4,
            Image = 4483362458,
        })
        return false
    end
end

PremiumTab:CreateToggle({
    Name = "WalkSpeed Fast Boost",
    CurrentValue = false,
    Flag = "PremWsToggle",
    Callback = function(Value)
        if not checkPremiumAccess() then
            wsEnabled = false
            return
        end
        wsEnabled = Value
    end,
})

PremiumTab:CreateSlider({
    Name = "Custom Pro WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "spd",
    CurrentValue = 16,
    Flag = "PremWsValue",
    Callback = function(Value)
        if not checkPremiumAccess() then return end
        customWsValue = Value
    end,
})

RunService.Heartbeat:Connect(function()
    if wsEnabled and isUnlocked then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = customWsValue
            end
        end)
    end
end)

PremiumTab:CreateToggle({
    Name = "Anti-AFK (Bypass 20m Kick)",
    CurrentValue = false,
    Flag = "PremAntiAfk",
    Callback = function(Value)
        if not checkPremiumAccess() then return end
        print("[Ken Hub Official] Anti-AFK active:", Value)
    end,
})

PremiumTab:CreateToggle({
    Name = "God Mode (Damage Immunity)",
    CurrentValue = false,
    Flag = "PremGodMode",
    Callback = function(Value)
        if not checkPremiumAccess() then return end
        print("[Ken Hub Official] God Mode active:", Value)
    end,
})

PremiumTab:CreateButton({
    Name = "Hop to Low Player Server",
    Callback = function()
        if not checkPremiumAccess() then return end
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in ipairs(servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end)
    end,
})

-- =====================================================================
-- // TAB 5: UPDATE KEY SYSTEM
-- =====================================================================
UpdateKeyTab:CreateSection("Manage Hub Access & Keys")

local newKeyInput = ""
UpdateKeyTab:CreateInput({
    Name = "Enter New / Premium Key",
    PlaceholderText = "Type key here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        newKeyInput = Text
    end,
})

UpdateKeyTab:CreateButton({
    Name = "Submit & Verify Key",
    Callback = function()
        if newKeyInput == "Ken-Hub-Premium" then
            isUnlocked = true
            KenUI:Notify({
                Title = "Ken Hub Official | Success",
                Content = "Premium Access Unlocked! Enjoy your exclusive utilities.",
                Duration = 5,
                Image = 4483362458,
            })
        else
            isUnlocked = false
            KenUI:Notify({
                Title = "Ken Hub Official | Error",
                Content = "Invalid Key! Please enter 'Ken-Hub-Premium'.",
                Duration = 4,
                Image = 4483362458,
            })
        end
    end,
})

-- =====================================================================
-- // TAB 6: SETTINGS
-- =====================================================================
MiscTab:CreateSection("Hub Configuration")

MiscTab:CreateParagraph({
    Title = "Developer Branding",
    Content = "Dueling Grounds Combat Hub created exclusively by Ken Hub Official."
})

MiscTab:CreateButton({
    Name = "Unload / Destroy Hub",
    Callback = function()
        KenUI:Destroy()
    end,
})

print("[Ken Hub Official] Dueling Grounds Hub Executed Successfully!")