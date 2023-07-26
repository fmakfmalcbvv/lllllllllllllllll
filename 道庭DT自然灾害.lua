local a = "1"
local b = "1"
local c = "1"

local DTlib = loadstring(game:HttpGet('https://pastebin.com/raw/SYBbcX4C'))()

local win1 = library:CreateTab("玩家菜单");

win1:NewButton("飞行", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/U27yQRxS"))()
end)

win1:NewButton("汽车飞行", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ciyHSFqY"))()
end)

win1:NewSlider("玩家速度", "玩家速度", 50, 16, 300, false, function(value)
    _default = value
    spawn(function()
        while task.wait() do
            game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
end)

win1:NewSlider("玩家跳跃", "玩家跳跃", 50, 50, 300, false, function(Jump)
    Jump_default = Jump
    spawn(function()
        while task.wait() do
            game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = Jump
        end
    end)
end)

win1:NewSlider("设置重力", "设置重力", 198, -999, 999, false, function(s)
    game.workspace.Gravity = s
end)

win1:NewToggle("夜视", "夜视", false, function(Value)
    Light = Value
    if Light then 
        while task.wait() do    
        game.Lighting.Ambient = Color3.new(1, 1, 1)
        end
    else
        while task.wait() do
        game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
end)

local win2 = library:CreateTab("主要功能");

win2:NewButton("身体变大", function()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Character = LocalPlayer.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
     
    function rm()
        for i,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                if v.Name == "Handle" or v.Name == "Head" then
                    if Character.Head:FindFirstChild("OriginalSize") then
                        Character.Head.OriginalSize:Destroy()
                    end
                else
                    for i,cav in pairs(v:GetDescendants()) do
                        if cav:IsA("Attachment") then
                            if cav:FindFirstChild("OriginalPosition") then
                                cav.OriginalPosition:Destroy()  
                            end
                        end
                    end
                    v:FindFirstChild("OriginalSize"):Destroy()
                    if v:FindFirstChild("AvatarPartScaleType") then
                        v:FindFirstChild("AvatarPartScaleType"):Destroy()
                    end
                end
            end
        end
    end
     
    rm()
    wait(0.5)
    Humanoid:FindFirstChild("BodyProportionScale"):Destroy()
    wait(1)
     
    rm()
    wait(0.5)
    Humanoid:FindFirstChild("BodyHeightScale"):Destroy()
    wait(1)
     
    rm()
    wait(0.5)
    Humanoid:FindFirstChild("BodyWidthScale"):Destroy()
    wait(1)
     
    rm()
    wait(0.5)
    Humanoid:FindFirstChild("BodyDepthScale"):Destroy()
    wait(1)
     
    rm()
    wait(0.5)
    Humanoid:FindFirstChild("HeadScale"):Destroy()
    wait(1)
end)
win2:NewButton("头变大", function()
for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetChildren()) do
   if string.find(v.Name,"Scale") and v.Name ~= "HeadScale" then
       repeat wait(HeadGrowSpeed) until game.Players.LocalPlayer.Character.Head:FindFirstChild("OriginalSize")
       game.Players.LocalPlayer.Character.Head.OriginalSize:Destroy()
       v:Destroy()
       game.Players.LocalPlayer.Character.Head:WaitForChild("OriginalSize")
   end
end
end)
win2:NewBox("长","输入数字",function(t)
    a=t
    game.Players.LocalPlayer.Character.Head.Size = Vector3.new(b,c,a)
end)
win2:NewBox("宽","输入数字",function(n)
    b=n
    game.Players.LocalPlayer.Character.Head.Size = Vector3.new(b,c,a)
end)
win2:NewBox("高","输入数字",function(q)
    c=q
    game.Players.LocalPlayer.Character.Head.Size = Vector3.new(b,c,a)
end)

win2:NewButton("复制别人物品", function()
    local player = tostring(game.Players.LocalPlayer.Name)
    while true do
    if game.Workspace:FindFirstChild("GreenBalloon") then
    if not game.Workspace[player]:FindFirstChild("GreenBalloon") and not game.Players.LocalPlayer.Backpack:FindFirstChild("GreenBalloon") then
    local workspaceClone = game.Workspace.GreenBalloon:Clone()
    workspaceClone.Parent = game.Workspace[player]
    end
    else
    local balloonCheck = game.Workspace:GetDescendants()
    local balloonClone
    for i, balloon in ipairs(balloonCheck) do
    if (tostring(balloon.Name) == "GreenBalloon") then
    balloonClone = balloon:Clone()
    wait()
    end
    end
    balloonClone.Parent = game.Workspace
    local workspaceClone = game.Workspace.GreenBalloon:Clone()
    workspaceClone.Parent = game.Workspace[player]
    end
    wait()
end
end)

win2:NewButton("传送回出生点", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-243, 194, 331)
end)
win2:NewButton("传送到地图", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-117, 47, 5)
end)

local win3 = library:CreateTab("其他功能");

win3:NewToggle("免费选地图",'Toggleflag1',false,function(bool)
    getgenv().trink545ets = bool
    if getgenv().trink545ets then
        TextLabel = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MapVotePage
    TextLabel.Visible = true
    else
        TextLabel = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MapVotePage
    TextLabel.Visible = false
    end
    end)



win3:NewToggle("灾难预测",'Toggleflag',false,function(bool)
    getgenv().trincckets = bool
        if getgenv().trincckets then
            local Character = game:GetService("Players").LocalPlayer.Character
        local Tag = Character:FindFirstChild("SurvivalTag")
        if Tag then
        game:GetService("StarterGui"):SetCore("SendNotification",{     
        Title = "灾难预测",     
        Text =   "" .. Tag.Value,
        Button1 = "知道了", Duration = 20, })
        end
        local function Repeat(R)
           R.ChildAdded:connect(
               function(Find)
                   if Find.Name == "SurvivalTag" then
        game:GetService("StarterGui"):SetCore("SendNotification",{     
        Title = "灾难预测",     
        Text =   "".. Find.Value,
        Button1 = "知道了", Duration = 20, })
                   end
               end
           )
        end
        Repeat(Character)
        game:GetService("Players").LocalPlayer.CharacterAdded:connect(
           function(R)
               Repeat(R)
           end
        )
        end 
end)