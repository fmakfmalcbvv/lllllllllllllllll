local a = "1"
local b = "1"
local c = "1"
local library = loadstring(game:HttpGet"https://pastebin.com/raw/tBpc3aSR")()
local win = library:new("道庭DT--自然灾害")
local Tab = win:Tab("主要功能", "6031075938")
local Section = Tab:section("娱乐功能")
local Section1 = Tab:section("其他功能")
local Section2 = Tab:section("飞行功能")
Section:Button("身体变大", function()
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
Section:Button("头变大", function()
for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetChildren()) do
   if string.find(v.Name,"Scale") and v.Name ~= "HeadScale" then
       repeat wait(HeadGrowSpeed) until game.Players.LocalPlayer.Character.Head:FindFirstChild("OriginalSize")
       game.Players.LocalPlayer.Character.Head.OriginalSize:Destroy()
       v:Destroy()
       game.Players.LocalPlayer.Character.Head:WaitForChild("OriginalSize")
   end
end
end)
Section:Textbox("长",'TextBoxfalg',"输入数字",function(t)
    a=t
    game.Players.LocalPlayer.Character.Head.Size = Vector3.new(b,c,a)
end)
Section:Textbox("宽",'TextBoxfalg',"输入数字",function(n)
    b=n
    game.Players.LocalPlayer.Character.Head.Size = Vector3.new(b,c,a)
end)
Section:Textbox("高",'TextBoxfalg',"输入数字",function(q)
    c=q
    game.Players.LocalPlayer.Character.Head.Size = Vector3.new(b,c,a)
end)

Section1:Textbox("调整速度",'TextBoxfalg',"输入数字",function(t)
    game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = t
end)

Section1:Textbox("调整跳跃力量",'TextBoxfalg',"输入数字",function(ty)
    game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = ty
end)

Section:Button("复制别人物品", function()
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
Section1:Toggle("免费选地图",'Toggleflag',false,function(bool)
    getgenv().trink545ets = bool
    if getgenv().trink545ets then
        TextLabel = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MapVotePage
    TextLabel.Visible = true
    else
        TextLabel = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MapVotePage
    TextLabel.Visible = false
    end
    end)



Section1:Toggle("灾难预测",'Toggleflag',false,function(bool)
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
Section:Button("传送回出生点", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-243, 194, 331)
end)
Section:Button("传送到地图", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-117, 47, 5)
end)
Section2:Textbox("飞行速度",'TextBoxfalg',"输入飞行速度",function(x)
    while( true )
    do
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro"):Destroy()
            wait()
            local BV = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.HumanoidRootPart)
            local BG = Instance.new("BodyGyro",game.Players.LocalPlayer.Character.HumanoidRootPart)
            BG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
            BG.D = 5000
            BG.P = 50000
            BG.CFrame = game.Workspace.CurrentCamera.CFrame
            BV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            BV.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * x
            end
end)
Section2:Toggle("飞行开关",'Toggleflag',false,function(bool)
    if bool then
        local BV = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.HumanoidRootPart)
		local BG = Instance.new("BodyGyro",game.Players.LocalPlayer.Character.HumanoidRootPart)
		BG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
		BG.D = 5000
		BG.P = 50000
		BG.CFrame = game.Workspace.CurrentCamera.CFrame
		BV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    else
        game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
		game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro"):Destroy()
    end
end)
Section2:Button("飞行使用说明", function()
    game:GetService("StarterGui"):SetCore("SendNotification",{     
        Title = "说明",     
        Text =   "1，飞行速度不能超过50超过就会白给2，要先输入飞行速度再开启飞行",
        Button1 = "知道了", Duration = 30, })
end)
   