local DTlib = loadstring(game:HttpGet('https://pastebin.com/raw/SYBbcX4C'))()

--<<  游戏功能部分 >>
		local players, gs = game:GetService("Players"), function(service)
			return game:GetService(service);
		end
		local player, repstorage, wkspc, runservice = players.LocalPlayer, gs("ReplicatedStorage"), gs("Workspace");
		local Mouse = player:GetMouse();
		local function getBase(owner)
			for _, v in next, wkspc.Plots:GetChildren() do
				if v:FindFirstChild("Owner") then
					if v.Owner.Value == owner then
						return v;
					end
				end
			end
			return nil
		end
		local function getSaw(player) --> 获取加工机功能
			local maxFurnace;
			local t = {}
			for i, v in next, getBase(player).Objects:GetChildren() do
				if v.Name:find("Furnace") then
					table.insert(t, v);
				end
			end
			maxFurnace = t[1];
			for i, v in next, t do
				if v.Hitbox.Size.z > maxFurnace.Hitbox.Size.z then
					maxFurnace = v;
				end
			end
			return maxFurnace;
		end
		local function grabObj(part) --> 拖拽矿石功能
			if part:IsA("Part") then
				repstorage.Events.Grab:InvokeServer(part, {})
			end
		end
		local function unGrab(part) --> 取消拖拽矿石功能
			if part:IsA("Part") then
				repstorage.Events.Ungrab:FireServer(part, {})
			end
		end
		function dragModel(model, cframe)  --> 移动游戏模型功能
			if not model.PrimaryPart then
				model.PrimaryPart = model:FindFirstChildOfClass("Part");
			end
			model.SetPrimaryPartCFrame(model, cframe);
		end
		local function sitCar()  --> 判断人物是否坐在车上的功能
			local character = player.Character or player.CharacterAdded:Wait();
			local car;
			local humanoid = character:WaitForChild("Humanoid", 10);
			if humanoid.SeatPart then
				car = humanoid.SeatPart.Parent;
			end
			return car
		end
		local function teleport(cframe)  --> 人物(汽车)传送功能
			if sitCar() then
				dragModel(sitCar(), cframe);
			else
				local character = player.Character or player.CharacterAdded:Wait();
				dragModel(character, cframe);
			end
		end

--Ores
		local function getOres(owner)  --> 获取矿石功能
			local oreList = {};
			for _, v in next, wkspc.Grabable:GetChildren() do
				if v.Name:find("MaterialPart") then
					if v:FindFirstChild("Owner") and v.Owner.Value == owner then  --> 判断
						if not table.find(oreList, v) then
							table.insert(oreList, v);
						end
					end
				end
			end
			return oreList;
		end
		local function dragOres(ore, cframe)  --> 传送矿石功能
			if ((ore.Part.Position - player.Character.HumanoidRootPart.Position).Magnitude >= 20) then
				teleport(ore.Part.CFrame + Vector3.new(0, 10, 0));
				task.wait();
			end
			grabObj(ore.Part); --> 抓住矿石
			for i = 1, 3 do
				dragModel(ore, cframe); --> 传送矿石到家
				task.wait()
			end
			unGrab(ore.Part); --> 取消抓取
		end
		
		local function notify(title, text, duration) --> 游戏通知功能
			return library:Notify({
					Title = tostring(title),
					Text = tostring(text),
					Duration = tonumber(duration) or 4;
				})
		end
		
		local DTwin1 = library:CreateTab("其他菜单"); -->双引号里面的内容可改
		local DTwin2 = library:CreateTab("传送菜单"); -->双引号里面的内容可改
		local DTwin3 = library:CreateTab("矿石菜单"); -->双引号里面的内容可改
		local DTwin4 = library:CreateTab("工具菜单"); -->双引号里面的内容可改
		
		DTwin1:NewButton("飞行脚本", function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/4v5n7n/lllllllllllllllllllll/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%ACV3"))();  --> 加载飞行脚本
		end)
		
		DTwin1:NewSeparator() --> 线条隔开
		local CarSpeed = 50;  --> 汽车飞行初始速度
		--> 一下只要有中文的, 在双(单)引号里面的都能改
		DTwin1:NewSlider("汽车飞行速度", "carFlySpeed", CarSpeed, 1, 200, false, function(Value)
			CarSpeed = Value;
		end)
		
		DTwin1:NewToggle("汽车飞行脚本", "cfly", false, function(v)
			if v == true then
				local HumanoidRP = player.Character.HumanoidRootPart
				local ScreenGui = Instance.new("ScreenGui")
				local W = Instance.new("TextButton")
				local S = Instance.new("TextButton")
				local A = Instance.new("TextButton")
				local D = Instance.new("TextButton")
				local Fly = Instance.new("TextButton")
				local unfly = Instance.new("TextButton")
				local StopFly = Instance.new("TextButton")
				ScreenGui.Parent = game.CoreGui
				ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				ScreenGui.Name = "汽车飞行脚本"
				unfly.Name = "unfly"
				unfly.Parent = ScreenGui
				unfly.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				unfly.Transparency = 0.5
				unfly.Position = UDim2.new(0.694387913, 0, 0.181818187, 0)
				unfly.Size = UDim2.new(0, 72, 0, 50)
				unfly.Font = Enum.Font.SourceSans
				unfly.Text = "停止飞行"
				unfly.TextColor3 = Color3.fromRGB(255, 255, 255)
				unfly.TextScaled = true
				unfly.TextSize = 14.000
				unfly.TextWrapped = unfly.MouseButton1Down:Connect(function()
					HumanoidRP:FindFirstChildOfClass("BodyVelocity"):Destroy()
					HumanoidRP:FindFirstChildOfClass("BodyGyro"):Destroy()
				end)
				StopFly.Name = "Stop Fly"
				StopFly.Parent = ScreenGui
				StopFly.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				StopFly.Transparency = 0.5
				StopFly.Position = UDim2.new(0.695689976, 0, 0.0213903747, 0)
				StopFly.Size = UDim2.new(0, 71, 0, 50)
				StopFly.Font = Enum.Font.SourceSans
				StopFly.Text = "暂停飞行"
				StopFly.TextColor3 = Color3.fromRGB(255, 255, 255)
				StopFly.TextScaled = true
				StopFly.TextSize = 14.000
				StopFly.TextWrapped = true
				StopFly.MouseButton1Down:Connect(function()
					HumanoidRP.Anchored = true
				end)
				Fly.Name = "Fly"
				Fly.Parent = ScreenGui
				Fly.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Fly.Transparency = 0.5
				Fly.Position = UDim2.new(0.588797748, 0, 0.0213903747, 0)
				Fly.Size = UDim2.new(0, 66, 0, 50)
				Fly.Font = Enum.Font.SourceSans
				Fly.Text = "飞行"
				Fly.TextColor3 = Color3.fromRGB(255, 255, 255)
				Fly.TextScaled = true
				Fly.TextSize = 14.000
				Fly.TextWrapped = true
				Fly.MouseButton1Down:Connect(function()
					local BV = Instance.new("BodyVelocity", HumanoidRP)
					local BG = Instance.new("BodyGyro", HumanoidRP)
					BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
					BG.D = 5000
					BG.P = 50000
					BG.CFrame = wkspc.CurrentCamera.CFrame
					BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				end)
				W.Name = "W"
				W.Parent = ScreenGui
				W.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				W.Transparency = 0.5
				W.Position = UDim2.new(0.161668837, 0, 0.601604283, 0)
				W.Size = UDim2.new(0, 58, 0, 50)
				W.Font = Enum.Font.SourceSans
				W.Text = "↑"
				W.TextColor3 = Color3.fromRGB(255, 255, 255)
				W.TextScaled = true
				W.TextSize = 5.000
				W.TextWrapped = true
				W.MouseButton1Down:Connect(function()
					HumanoidRP.Anchored = false
					HumanoidRP:FindFirstChildOfClass("BodyVelocity"):Destroy()
					HumanoidRP:FindFirstChildOfClass("BodyGyro"):Destroy()
					wait(.1)
					local BV = Instance.new("BodyVelocity", HumanoidRP)
					local BG = Instance.new("BodyGyro", HumanoidRP)
					BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
					BG.D = 5000
					BG.P = 50000
					BG.CFrame = wkspc.CurrentCamera.CFrame
					BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					BV.Velocity = wkspc.CurrentCamera.CFrame.LookVector * CarSpeed
				end)
				S.Name = "S"
				S.Parent = ScreenGui
				S.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				S.Transparency = 0.5
				S.Position = UDim2.new(0.161668837, 0, 0.755294104, 0)
				S.Size = UDim2.new(0, 58, 0, 50)
				S.Font = Enum.Font.SourceSans
				S.Text = "↓"
				S.TextColor3 = Color3.fromRGB(255, 255, 255)
				S.TextScaled = true
				S.TextSize = 14.000
				S.TextWrapped = true
				S.MouseButton1Down:Connect(function()
					HumanoidRP.Anchored = false
					HumanoidRP:FindFirstChildOfClass("BodyVelocity"):Destroy()
					HumanoidRP:FindFirstChildOfClass("BodyGyro"):Destroy()
					wait(.1)
					local BV = Instance.new("BodyVelocity", HumanoidRP)
					local BG = Instance.new("BodyGyro", HumanoidRP)
					BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
					BG.D = 5000
					BG.P = 50000
					BG.CFrame = wkspc.CurrentCamera.CFrame
					BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					BV.Velocity = wkspc.CurrentCamera.CFrame.LookVector * - CarSpeed
				end)
			else
				if game.CoreGui:FindFirstChild("汽车飞行脚本") then
					game.CoreGui["汽车飞行脚本"]:Destroy();
				end
			end
		end)
		run = gs("Lighting").Changed:Connect(function()
			if NoFog then
				gs("Lighting").FogEnd = math.huge
			end
		end)
		DTwin1:NewToggle("删除雾", "nofog", false, function(v)
			NoFog = v;
		end)
		DTwin1:NewToggle("全亮", "full", false, function(v)
			local full;
			if v == true then
				full = gs("Lighting").Changed:connect(function()
					gs("Lighting").TimeOfDay = "14:00:00"
					gs("Lighting").FogEnd = 99999999
					gs("Lighting").Brightness = 7
				end)
			else
				if full then
					full:Disconnect();
					full = nil;
				end
			end
		end)
		DTwin1:NewButton("寻找紫树", function()
			local tree;
			for _, v in pairs(wkspc:GetDescendants()) do
				if v.Name == "Interact" and v.Parent.Name == "Leaf" then
					tree = v;
					break;
				end
			end
			if not tree then
				return notify("道庭DT", "没有找到紫树!");
			end
			teleport(tree:FindFirstChildOfClass("Part").CFrame);
		end)
		DTwin1:NewButton("修复卡视角问题", function()
			local v2 = wkspc.CurrentCamera;
			v2.CameraType = Enum.CameraType["Watch"];
			task.wait();
			v2.CameraType = Enum.CameraType["Custom"];
		end)
		DTwin2:NewButton("传送到基地", function()
			local base = getBase(player);
			teleport(base.Base.CFrame + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到矿石商店", function()
			local cf = CFrame.new(- 426.023804, 6.49999571, - 72.7279129);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到商店 [UCS]", function()
			local cf = CFrame.new(- 990.3114013671875, 4.250003814697266, - 621.46630859375);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到镐子商店", function()
			local cf = CFrame.new(729.5538330078125, 2.25, 63.709720611572266);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到土地商店", function()
			local cf = CFrame.new(- 1008.6192626953125, 4.250002384185791, - 724.2153930664062);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到水电商店", function()
			local cf = CFrame.new(- 450.24755859375, 5.749998569488525, 21.00583267211914);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到汽车经销店", function()
			local cf = CFrame.new(711.9130249023438, 8.250000953674316, - 962.6895751953125);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到打折商店", function()
			local cf = CFrame.new(- 3199.43164, 17.7500019, 605.6922);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到逻辑店", function()
			local cf = CFrame.new(- 109.674004, 239.999969, 1127.81946);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到家具店", function()
			local cf = CFrame.new(- 1018.10181, 4.25000238, 690.901855);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到云矿", function()
			local cf = CFrame.new(503.980682, 431.749725, 1261.18567);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到冰矿石", function()
			local cf = CFrame.new(1993.668701171875, - 82.11865997314453, - 2280.691162109375);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到金矿", function()
			local cf = CFrame.new(676.4124755859375, 18.304752349853516, - 1503.1123046875);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到铀矿", function()
			local cf = CFrame.new(19, -70, 4545);
			teleport(cf + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewSeparator();
		getgenv().PLAYERS = {};
		for _, v in next, players:GetPlayers() do
			if not table.find(PLAYERS, v.Name) then
				table.insert(PLAYERS, v.Name);
			end
		end
		players.PlayerAdded:Connect(function(v)
			if not table.find(PLAYERS, v.Name) then
				table.insert(PLAYERS, v.Name);
				library.flags["玩家列表"]:AddOption(tostring(v.Name));
			end
		end)
		players.PlayerRemoving:Connect(function(v)
			if table.find(PLAYERS, v.Name) then
				table.remove(PLAYERS, table.find(PLAYERS, v.Name))
				library.flags["玩家列表"]:RemoveOption(tostring(v.Name))
			end
		end)
		DTwin2:NewDropdown("选择玩家", "玩家列表", PLAYERS, function(plr)
			PLAYERS = plr;
		end)
		DTwin2:NewButton("传送到玩家身边", function()
			if type(PLAYERS) == "table" then
				return notify("错误", "没有选择玩家!");
			end
			teleport(players[PLAYERS].Character.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0));
		end)
		DTwin2:NewButton("传送到玩家基地", function()
			if type(PLAYERS) == "table" then
				return notify("错误", "没有选择玩家!");
			end
			local base = getBase(players[PLAYERS]);
			if not base then
				return notify("错误", "这个玩家没有基地!");
			end
			teleport(base.Base.CFrame + Vector3.new(0, 10, 0));
		end)
		
		DTwin3:NewButton("传送全部矿石到身边", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local pos = player.Character.HumanoidRootPart.CFrame;
			local base = getBase(player);
			for _, v in next, getOres(player) do
				dragOres(v, pos); --> 传送矿石到家
				task.wait();
			end
			teleport(pos + Vector3.new(0, 10, 0)); --> 传送到旧位置
		end)
		DTwin3:NewButton("传送附近矿石到家", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local base = getBase(player);
			for _, v in next, getOres(player) do
				if ((v.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 50) then
					dragOres(v, base.Base.CFrame + Vector3.new(0, 10, 0));
					task.wait();
				end
			end
		end)
		
		DTwin3:NewSeparator() --> 线条隔开
		DTwin3:NewButton("出售全部矿石", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local cf = CFrame.new(- 421.5615234375, 6.499995708465576, - 65.09494018554688);
			local oldPos = player.Character.HumanoidRootPart.CFrame;
			for _, v in next, getOres(player) do
				dragOres(v, cf + Vector3.new(0, 5, 0));
				task.wait();
			end
			wkspc.Map.Sellary.Keeper.IPart.Interact:FireServer();
			teleport(oldPos); --> 传送到旧位置
		end)
		DTwin3:NewButton("出售附近矿石", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local cf = CFrame.new(- 421.5615234375, 6.499995708465576, - 65.09494018554688);
			for _, v in next, getOres(player) do
				if ((v.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 50) then
					dragOres(v, cf + Vector3.new(0, 5, 0));
					task.wait();
				end
			end
		end)
				

		local connectSaw;
	
		local function test()
			local selected;
			notify("道庭DT", "请选择加工机");
			connectSaw = Mouse.Button1Up:connect(function()
			    local Saw = Mouse.Target.Parent;
			    if Saw and Saw.Parent and Saw.Parent.Hitbox then
				    Saw = Saw.Parent;
				    selected = Saw;				    
				end
			end)
			repeat task.wait(.1)
			until selected ~= nil;
		    notify("道庭DT", "已选择加工机");
		    local selection = Instance.new("SelectionBox")
			selection.Parent = selected.Hitbox;
			selection.Adornee = selection.Parent
						
		    if connectSaw then
		    	connectSaw:Disconnect();
		    	connectSaw=nil;
		    end
		    for i,v in next, selected:GetDescendants() do
		    	if v.Name == "SelectionBox" then
		    		v:Destroy();
		    		break;
		    	end
		    end
		    return selected;
	    end
	    
		local customize = nil;		
		DTwin3:NewSeparator() --> 线条隔开
		DTwin3:NewButton("点击选择加工机", function()
		    customize = test();		   
		end)
		
		DTwin3:NewButton("加工全部矿石", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local saw = customize ~= nil and customize or getSaw(player);
			if not saw then
			    print("没有加工机")
				return
			end
			local sawPart = saw.Refine.Part.CFrame;
			local oldPos = player.Character.HumanoidRootPart.CFrame;
			for _, v in next, getOres(player) do
				local value = v.Configuration.Data.MatInd.Value;
				if value:find("Raw") then --> 判断矿石是否已经加工
					dragOres(v, sawPart);
					task.wait()
					local isJiaGong = false;
					local connection = wkspc.Grabable.ChildAdded:Connect(function(child)
						child:WaitForChild("Owner", 10);
						if child.Owner.Value == player then
							isJiaGong = true;
							connection:Disconnect();
							connection = nil
						end
					end)
					repeat
						task.wait()
					until isJiaGong == true or task.wait(3)
					if connection then
						connection:Disconnect()
						connection = nil;
					end
				end
			end
			teleport(oldPos);
		end)
		DTwin3:NewButton("加工附近矿石", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local saw = customize ~= nil and customize or getSaw(player);
			if not saw then
				return
			end
			local sawPart = saw.Refine.Part.CFrame;
			for _, v in next, getOres(player) do
				if ((v.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 50) then
					local value = v.Configuration.Data.MatInd.Value;
					if value:find("Raw") then
						dragOres(v, sawPart);
						task.wait()
						local isJiaGong = false;
						local connection = wkspc.Grabable.ChildAdded:Connect(function(child)
							child:WaitForChild("Owner", 10);
							if child.Owner.Value == player then
								isJiaGong = true;
								connection:Disconnect();
								connection = nil
							end
						end)
						repeat
							task.wait()
						until isJiaGong == true or task.wait(3)
						if connection then
							connection:Disconnect()
							connection = nil;
						end
					end
				end
			end
		end)
		
		DTwin3:NewButton("点击加工矿石 [工具]", function()
			if player.Backpack:FindFirstChild("点击加工矿石") or player.Character:FindFirstChild("点击加工矿石") then
				player.Backpack["点击加工矿石"]:Destroy()
			end
			local clickToDragMod = Instance.new("Tool", player.Backpack)
			clickToDragMod.Name = "点击加工矿石"
			clickToDragMod.RequiresHandle = false
			clickToDragMod.Activated:Connect(function()			
				if sitCar() then
					return notify("错误", "请不要坐在车上!");
				end
			    local saw = customize ~= nil and customize or getSaw(player);
		        if not saw then
		            print("没有加工机")
			        return
	     	    end
				local ore = Mouse.Target.Parent;
				local sawPart = saw.Refine.Part.CFrame;
				if ore.Parent == wkspc.Grabable then
					if ore:FindFirstChild("Owner") and ore.Owner.Value == player then
						dragOres(ore, sawPart);
						task.wait();
					end
				end
			end)
		end)
		
		DTwin3:NewSeparator() --> 线条隔开
		DTwin3:NewButton("设置位置", function()
			if wkspc:FindFirstChild("IIIII") then
				wkspc.IIIII:Destroy()
			end
			p = Instance.new("Part", wkspc)
			p.Name = "IIIII"
			p.Transparency = 1
			p.Anchored = true
			p.CFrame = player.Character.HumanoidRootPart.CFrame
			p.CanCollide = false
			p.Size = player.Character.HumanoidRootPart.Size
			local posBox = Instance.new("SelectionBox", p)
			posBox.Name = "posBox"
			posBox.Color3 = Color3.new(200, 200, 200)
			posBox.Adornee = posBox.Parent
		end)
		DTwin3:NewButton("删除位置", function()
			if wkspc:FindFirstChild("IIIII") then
				wkspc.IIIII:Destroy()
			end
		end)
		DTwin3:NewButton("传送全部矿石", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local cf;
			if wkspc:FindFirstChild("IIIII") then
				cf = wkspc.IIIII.CFrame;
			end
			if not cf then
				return notify("错误", "请不要坐在车上!");
			end
			local pos = player.Character.HumanoidRootPart.CFrame;
			for _, v in next, getOres(player) do
				dragOres(v, cf); --> 传送矿石到家
				task.wait();
			end
			teleport(pos + Vector3.new(0, 5, 0)); --> 传送到旧位置
		end)
		DTwin3:NewButton("传送附近矿石", function()
			if sitCar() then
				return notify("错误", "请不要坐在车上!");
			end
			local cf;
			if wkspc:FindFirstChild("IIIII") then
				cf = wkspc.IIIII.CFrame;
			end
			if not cf then
				return notify("错误", "没有设置位置!");
			end
			for _, v in next, getOres(player) do
				if ((v.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 50) then
					dragOres(v, cf);
					task.wait();
				end
			end
		end)
		DTwin3:NewButton("点击传送矿石 [工具]", function()
			if player.Backpack:FindFirstChild("点击传送矿石") or player.Character:FindFirstChild("点击传送矿石") then
				player.Backpack["点击传送矿石"]:Destroy()
			end
			local clickToDragOre = Instance.new("Tool", player.Backpack)
			clickToDragOre.Name = "点击传送矿石"
			clickToDragOre.RequiresHandle = false
			clickToDragOre.Activated:Connect(function()
				local cf;
				if wkspc:FindFirstChild("IIIII") then
					cf = wkspc.IIIII.CFrame;
				end
				if not cf then
					return notify("错误", "没有设置位置!");
				end
				if sitCar() then
					return notify("错误", "请不要坐在车上!");
				end
				local ore = Mouse.Target.Parent;
				if ore.Parent == wkspc.Grabable then
					if ore:FindFirstChild("Owner") and ore.Owner.Value == player then
						dragOres(ore, cf);
						task.wait();
					end
				end
			end)
		end)
		
        local parts = {}
        local part_parents = {}
        local part_cframes = {}
     
     
		DTwin4:NewButton("两个小工具", function()
			local delete = Instance.new("Tool", player.Backpack);
			local undo = Instance.new("Tool", player.Backpack);
			
		    delete.Name = "点击删除";
            delete.RequiresHandle = false;
            delete.CanBeDropped = false;
           
            delete.Activated:Connect(function()
                notify("道庭DT", "你删除了 "..Mouse.Target.Name);
         
                table.insert(parts, Mouse.Target);
                table.insert(part_parents, Mouse.Target.Parent);
                table.insert(part_cframes, Mouse.Target.CFrame);
                Mouse.Target.Parent = nil;
            end)
           
            undo.Name = "点击撤销";
            undo.RequiresHandle = false;
            undo.CanBeDropped = false;
           
            undo.Activated:Connect(function()
                notify("道庭DT", "撤销 "..parts[#parts].Name .. " 的删除");
        
                parts[#parts].Parent = part_parents[#part_parents]
                parts[#parts].CFrame = part_cframes[#part_cframes]
		        table.remove(part_cframes, #part_cframes)
		        table.remove(parts, #parts)
		        table.remove(part_parents, #part_parents)
            end)
		end)

