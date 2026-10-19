local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Sh4rk Script ",
   LoadingTitle = "Loading Script",
   LoadingSubtitle = "by Sh4ark Scripts",
   ConfigurationSaving = { Enabled = false },
   
   -- DISCORD BOT KEY SYSTEM CONFIGURATION
   KeySystem = false,
   
   Theme = "Amethyst"
})

-- =========================================
-- 2 TABS ONLY
-- =========================================
local MainTab = Window:CreateTab("Main & Farming", 4483362458)
local MiscTab = Window:CreateTab("Misc & Utility", 4483362458)

-- =========================================
-- 1. MAIN & FARMING (Wheelie, Burnout, Recovery, Tricks)
-- =========================================
local autoWheelieActive = false
local burnoutActive = false
local stuntFarmActive = false

-- Auto Wheelie Logic
local function getScooterPitch()
   local char = player.Character
   if char and char:FindFirstChild("HumanoidRootPart") then
      local hrp = char.HumanoidRootPart
      local lookVector = hrp.CFrame.LookVector
      return math.deg(math.asin(lookVector.Y))
   end
   return 0
end

local function startAutoWheelie()
   task.spawn(function()
      while autoWheelieActive do
         task.wait(0.015)
         local pitch = getScooterPitch()
         if pitch > 42 then
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
            task.wait(0.04)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
         else
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.18)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
         end
      end
      VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
      VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
      VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
   end)
end

MainTab:CreateToggle({
   Name = "Auto Wheelie (High Speed Balance)",
   CurrentValue = false,
   Flag = "AutoWheelieToggle",
   Callback = function(Value)
      autoWheelieActive = Value
      if Value then startAutoWheelie() end
   end,
})

MainTab:CreateToggle({
   Name = "Burnout AFK (Hold W + S)",
   CurrentValue = false,
   Flag = "BurnoutToggle",
   Callback = function(Value)
      burnoutActive = Value
      if Value then
         task.spawn(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
            while burnoutActive do task.wait(0.5) end
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
         end)
      else
         VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
         VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
      end
   end,
})

-- 0-Gravity Trick Farmer Logic
local function start0GravityStunts()
   task.spawn(function()
      while stuntFarmActive do
         -- 1. Accelerate to build speed with normal gravity
         workspace.Gravity = 196.2
         VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
         
         for i = 1, 30 do -- Wait ~3 seconds
            if not stuntFarmActive then break end
            task.wait(0.1)
         end
         
         if not stuntFarmActive then break end
         
         -- 2. Drop Gravity to 0 (Scooter floats on bumps)
         workspace.Gravity = 0
         
         -- 3. Pick random direction (A or D)
         local keys = {Enum.KeyCode.A, Enum.KeyCode.D}
         local chosenKey = keys[math.random(1, 2)]
         VirtualInputManager:SendKeyEvent(true, chosenKey, false, game)
         
         -- 4. Hold spin for 20 seconds
         for i = 1, 100 do
            if not stuntFarmActive then break end
            task.wait(0.1)
         end
         
         -- 5. Release keys & restore gravity
         VirtualInputManager:SendKeyEvent(false, chosenKey, false, game)
         VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
         workspace.Gravity = 196.2
         
         -- Wait for landing
         for i = 1, 40 do
            if not stuntFarmActive then break end
            task.wait(0.1)
         end
      end
      
      -- Cleanup
      workspace.Gravity = 196.2
      VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
      VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
      VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
   end)
end

MainTab:CreateToggle({
   Name = "0-Gravity Trick Farmer (Breaks Wheelie, Rejoin to Fix)",
   CurrentValue = false,
   Flag = "StuntFarmerToggle",
   Callback = function(Value)
      stuntFarmActive = Value
      if Value then
         start0GravityStunts()
      end
   end,
})

-- =========================================
-- 2. MISC & UTILITY (ESP, TP, Gravity, Anti-AFK)
-- =========================================

MiscTab:CreateSlider({
   Name = "Workspace Gravity (Manual Override)",
   Range = {0, 196.2},
   Increment = 1,
   Suffix = "Gravity",
   CurrentValue = 196.2,
   Flag = "GravitySlider",
   Callback = function(Value)
      if not stuntFarmActive then
         workspace.Gravity = Value
      end
   end,
})

-- ESP Logic
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "KukirinESP"

local function createESP(character, name, color)
   if not character or not character:FindFirstChild("HumanoidRootPart") then return end
   
   local highlight = Instance.new("Highlight", espFolder)
   highlight.Adornee = character
   highlight.FillColor = color
   highlight.OutlineColor = Color3.new(1, 1, 1)
   highlight.FillTransparency = 0.5
   
   local billboard = Instance.new("BillboardGui", espFolder)
   billboard.Adornee = character:WaitForChild("HumanoidRootPart")
   billboard.Size = UDim2.new(0, 200, 0, 50)
   billboard.StudsOffset = Vector3.new(0, 3, 0)
   billboard.AlwaysOnTop = true
   
   local textLabel = Instance.new("TextLabel", billboard)
   textLabel.Size = UDim2.new(1, 0, 1, 0)
   textLabel.BackgroundTransparency = 1
   textLabel.Text = name
   textLabel.TextColor3 = color
   textLabel.TextScaled = true
end

local function clearESP()
   espFolder:ClearAllChildren()
end

MiscTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "PlayerESPToggle",
   Callback = function(Value)
      clearESP()
      if Value then
         for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
               createESP(v.Character, v.Name, Color3.new(1, 0, 0))
            end
         end
      end
   end,
})

MiscTab:CreateButton({
   Name = "Teleport to Safe Highway (AFK Spot)",
   Callback = function()
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(1000, 10, 1000)
         Rayfield:Notify({
            Title = "Teleported",
            Content = "Moved to an open area. Perfect for AFK Wheelies.",
            Duration = 3,
         })
      end
   end,
})

-- Anti-AFK Logic
local antiAfkConnection
MiscTab:CreateToggle({
   Name = "Anti-AFK Bypass (20 Min Kick)",
   CurrentValue = false,
   Flag = "AntiAfkToggle",
   Callback = function(Value)
      if Value then
         antiAfkConnection = player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
         end)
      else
         if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
         end
      end
   end,
})

Rayfield:LoadConfiguration()
