local DTlib = loadstring(game:HttpGet('https://pastebin.com/raw/SYBbcX4C'))()

    local _CONFIGS = {  --> 游戏配置列表, 如果不懂请勿修改, 可以改数字
	   ["UI_NAME"] = define,
	   ["总开关"] = nil,
	   ["防误触开关"] = true,
	   ["cutPlankByDT"] = nil,
	   ["无限跳"] = false,
	   ["穿墙开关"] = false,
	   ["飞行开关"] = false,
	   ["isBuying"] = false,
	   ["取消购买"] = false,
	   ["处理木头"] = false,
	   ["处理木头并加工"] = false,
	   ["点击砍树"] = false,
	   ["填充工具"] = false,
	   ["刷粉车"] = false,
	   ["粉车器"] = nil,
	   ["自动砍树"] = nil,
	   ["UI长"] = 250,
	   ["UI宽"] = 300,
	   ["传送模式"] = 2,
	   ["飞行速度"] = 4,
	   ["步行速度"] = 16,
	   ["跳跃力"] = 50,  --> 比如这个50  代表加载脚本初始的跳跃力是50, 可以改 100或者150等等
	   ["悬浮高度"] = 0,
	   ["重力"] = 198,
	   ["相机焦距"] = 100,
	   ["广角"] = 70,
	};
	
	local function ClearConfig()  --> 清除游戏配置功能
		if _CONFIGS["总开关"] ~= nil then
			_CONFIGS["总开关"]:Disconnect()
			_CONFIGS["总开关"] = nil;
			_CONFIGS["防误触开关"] = nil;
			_CONFIGS["无限跳"] = false;
			_CONFIGS["穿墙开关"] = false;
			_CONFIGS["UI长"] = 250;
			_CONFIGS["UI宽"] = 300;
			_CONFIGS["飞行速度"] = 4
			_CONFIGS["飞行开关"] = false
			_CONFIGS["isBuying"] = false;
			getgenv()["点击出售木头"] = false;
			_CONFIGS["取消购买"] = false;
			_CONFIGS["传送模式"] = 2;
			_CONFIGS["处理木头"] = false;
			_CONFIGS["处理木头并加工"] = false
			_CONFIGS["点击砍树"] = false;
			_CONFIGS["填充工具"] = false
			_CONFIGS["刷粉车"] = false
			if getgenv().Test then
				getgenv().Test:Disconnect();
				getgenv().Test = nil;
			end
		

			if _CONFIGS["cutPlankByDT"] then
				_CONFIGS["cutPlankByDT"]:Disconnect();
				_CONFIGS["cutPlankByDT"] = nil;
			end
			if _G.OrigDrag then
				_G.OrigDrag = nil
			end
			if clickSellLog then
				clickSellLog:Disconnect();
				clickSellLog = nil;
			end
			if mod then
				mod:Disconnect();
				mod = nil;
			end
			if _CONFIGS["自动砍树"] then
				_CONFIGS["自动砍树"]:Disconnect();
				_CONFIGS["自动砍树"] = nil;
			end
			if DayOfNight then
			    DayOfNight:Disconnect()
			    DayOfNight = nil
			end
			if getgenv().PlankToBp then
			    getgenv().PlankToBp:Disconnect()
			    getgenv().PlankToBp = nil
			end
			if _CONFIGS["粉车器"] then
				_CONFIGS["粉车器"]:Disconnect();
				_CONFIGS["粉车器"] = nil;
			end
		end
	end
	ClearConfig()
	
	function ifError(msg)
		warn("脚本出问题辣!")
		writefile(string.format("道庭DT错误日志%s.txt", os.date():sub(11):gsub(" ", "-")), string.format("具体错误原因为:\n %s", msg))
	end
	
	local DT = {
		GS = function(...)
			return game.GetService(game, ...);
		end;
	}
	
	
	DT.RS = DT.GS"RunService"
	DT.RES = DT.GS"ReplicatedStorage"
	DT.LIGHT = DT.GS"Lighting"
	DT.TPS = DT.GS"TeleportService"
	DT.LP = DT.GS"Players".LocalPlayer
	DT.WKSPC = DT.GS"Workspace"
	DT.COREGUI = DT.GS "CoreGui";
	local Mouse = DT.LP:GetMouse()
	
	
	function DT:printf(...)
		print(string.format(...));
	end
	
	function DT:SelectNotify(...)
		local Args = {
			...
		}
		local NotificationBindable = Instance.new("BindableFunction")
		NotificationBindable.OnInvoke = Args[6]
		game.StarterGui:SetCore("SendNotification", {
			Title = Args[1],
			Text = Args[2],
			Icon = nil,
			Duration = Args[5],
			Button1 = Args[3],
			Button2 = Args[4],
			Callback = NotificationBindable
		})
		return Args
	end
	
	
	function DT:DragModel(...)  --> 移动模型功能
		local Args = {
			...
		};
		assert(Args[1]:IsA("Model") == true, "参数1必须是模型!");
		if _CONFIGS["传送模式"] == 1 then
			pcall(function()
				self.RES.Interaction.ClientIsDragging:FireServer(Args[1])
			end);
			Args[1]:PivotTo(Args[2]);
		elseif _CONFIGS["传送模式"] == 2 then
			pcall(function()
				self.RES.Interaction.ClientIsDragging:FireServer(Args[1])
			end);
			if not Args[1].PrimaryPart then
				Args[1].PrimaryPart = Args[1]:FindFirstChildOfClass("Part")
			end
			Args[1]:SetPrimaryPartCFrame(Args[2])
		end
	end
	
	function DT:Teleport(...)  --> 传送功能
		local Args = {
			...
		};
		if self.LP.Character.Humanoid.SeatPart then
			spawn(function()
				for i = 1, 15 do
					self:DragModel(self.LP.Character.Humanoid.SeatPart.Parent, Args[1]);
				end
			end)
			return;
		end
		for i = 1, 3 do
			self:DragModel(self.LP.Character, Args[1]);
			task.wait();
		end
	end
	
	function DT:TP(x, y, z)
		self:Teleport(CFrame.new(x, y, z));
	end
	
	function DT:ServiceTP(ID)  --> 跳转服务器功能, 用于重进服务器
		DT.TPS:Teleport(ID, DT.LP)
    end

				--↓ 以下请勿修改
	    _CONFIGS["总开关"] = DT.RS.RenderStepped:Connect(function()
		pcall(function()
			DT.LP.Character.Humanoid.WalkSpeed = _CONFIGS["步行速度"]
			DT.LP.Character.Humanoid.JumpPower = _CONFIGS["跳跃力"]
			DT.LP.Character.Humanoid.HipHeight = _CONFIGS["悬浮高度"]
			DT.WKSPC.Gravity = _CONFIGS["重力"]
			DT.LP.CameraMaxZoomDistance = _CONFIGS["相机焦距"]
			DT.WKSPC.Camera.FieldOfView = _CONFIGS["广角"]
		end)
	end)
	
	
	function DT:NOTIFY(title, text, duration) --> 通知功能
	    return library:Notify({
	           Title = title, 
	           Text = text,
	           Duration = duration
	       })
	end
	
	--↓ 双引号里面的中文可以修改, 对应的是脚本UI的菜单名字
	local DTwin1 = library:CreateTab("设置菜单");
	local DTwin2 = library:CreateTab("玩家菜单");
	local DTwin3 = library:CreateTab("购买菜单");
	local DTwin4 = library:CreateTab("木材菜单");
	local DTwin5 = library:CreateTab("传送菜单");
	local DTwin6 = library:CreateTab("环境菜单");
	local DTwin7 = library:CreateTab("基地菜单");
	local DTwin8 = library:CreateTab("汽车菜单");
	
	
	DTwin1:NewToggle("防误触", "Mistouch", true, function(v)
	    _CONFIGS["防误触开关"] = v;
	end)
	
	DTwin1:NewButton("关闭脚本", function()
	    	if _CONFIGS["防误触开关"] == true then
			DT:SelectNotify("防误触", "确定要关闭脚本吗?", "确定", "取消", 5, function(text) --> 双引号里面的中文可以改
				if text == "确定" then
					xpcall(function()
						for i, v in next, DT.COREGUI:GetDescendants() do
							if v.Name == _CONFIGS.UI_NAME then
								v:Destroy()
								ClearConfig()
							end
						end
					end, function(err)
						return DT:printf("错误是:  %s", err)
					end)
					return
				end
				DT:NOTIFY("通知", "已取消", 4) --> 双引号里面的中文可以改
			end)
			return
		end
		xpcall(function()
			for i, v in next, DT.COREGUI:GetDescendants() do
				if v.Name == _CONFIGS.UI_NAME then
					v:Destroy()
					ClearConfig()
				end
			end
		end, function(err)
			return DT:printf("错误是:  %s", err)
		end)
	end)
	
	DTwin1:NewButton("重进服务器", function()
		if _CONFIGS["防误触开关"] == true then
			DT:SelectNotify("防误触", "确定要重进服务器吗?", "确定", "取消", 5, function(text) --> 双引号里面的中文可以改
				if text == "确定" then
					xpcall(function()
						DT:ServiceTP(game.PlaceId)
					end, function(err)
						return DT:printf("错误是:  %s", err)
					end)
					return
				end
				DT:NOTIFY("通知", "已取消", 4) --> 双引号里面的中文可以改
			end)
			return
		end
		xpcall(function()
			DT:ServiceTP(game.PlaceId)
		end, function(err)
			return DT:printf("错误是:  %s", err)
		end)
	end)
	
	DTwin1:NewSeparator()
	
	
	DTwin1:NewButton("脚本作者  锋芒阿康", function()
		print("感谢 锋芒阿康")
	end)
	
	DTwin1:NewButton("脚本合作者  猫猫", function()
		print("感谢 猫猫")
	end)
	
	DTwin1:NewButton("Woof UI Library  平民", function()
		print("感谢 Step")
	end)
	
	DTwin1:NewButton("UI提供 紅", function()
		print("感谢 紅")
	end)
	
	DTwin1:NewButton("部分功能来源 紅", function()
		print("感谢 紅")
	end)
	
	DTwin1:NewButton("感谢粉丝们的支持", function()
		print("感谢粉丝")
	end)
	
	
	DTwin1:NewButton("最大支持  你们", function()
		print("感谢 你们")
	end)
	
	
	DTwin2:NewSlider("步行速度", "步行速度slider", 50, 16, 300, false, function(v)
		_CONFIGS["步行速度"] = v;
	end)
	
	DTwin2:NewSlider("跳跃力", "跳跃力slider", 50, 50, 300, false, function(v)
		_CONFIGS["跳跃力"] = v;
	end)
	
	DTwin2:NewSlider("飞行速度","飞行速度slider", 4, 1, 100, false, function(v)
		_CONFIGS["飞行速度"] = tonumber(v)
	end)
	
	DTwin2:NewToggle("飞行", "fly", false, function(bool)
	    _CONFIGS["飞行开关"] = bool
		speeds = _CONFIGS["飞行速度"]
		if _CONFIGS["飞行开关"] == false then
			_CONFIGS["飞行开关"] = true
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
			DT.LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		else
			_CONFIGS["飞行开关"] = false
			for i = 1, speeds do
				spawn(
	                function()
					local hb = game:GetService("RunService").Heartbeat
					tpwalking = true
					local chr = DT.LP.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
			DT.LP.Character.Animate.Disabled = true
			local Char = DT.LP.Character
			local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
			for i, v in next, Hum:GetPlayingAnimationTracks() do
				v:AdjustSpeed(0)
			end
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
			DT.LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		end
		if DT.LP.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			local torso = DT.LP.Character.Torso
			local flying = true
			local deb = true
			local ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local maxspeed = 50
			local speed = 0
			local bg = Instance.new("BodyGyro", torso)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.cframe = torso.CFrame
			local bv = Instance.new("BodyVelocity", torso)
			bv.velocity = Vector3.new(0, 0.1, 0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			if _CONFIGS["飞行开关"] == false then
				DT.LP.Character.Humanoid.PlatformStand = true
			end
			while _CONFIGS["飞行开关"] == false or DT.LP.Character.Humanoid.Health == 0 do
				game:GetService("RunService").RenderStepped:Wait()
				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed + .5 + (speed / maxspeed)
					if speed > maxspeed then
						speed = maxspeed
					end
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
					speed = speed - 1
					if speed < 0 then
						speed = 0
					end
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
					lastctrl = {
						f = ctrl.f,
						b = ctrl.b,
						l = ctrl.l,
						r = ctrl.r
					}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
				else
					bv.velocity = Vector3.new(0, 0, 0)
				end
				bg.cframe = DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.Angles(- math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
			end
			ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			speed = 0
			bg:Destroy()
			bv:Destroy()
			DT.LP.Character.Humanoid.PlatformStand = false
			DT.LP.Character.Animate.Disabled = false
			tpwalking = false
		else
			local UpperTorso = DT.LP.Character.UpperTorso
			local flying = true
			local deb = true
			local ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local maxspeed = 50
			local speed = 0
			local bg = Instance.new("BodyGyro", UpperTorso)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.cframe = UpperTorso.CFrame
			local bv = Instance.new("BodyVelocity", UpperTorso)
			bv.velocity = Vector3.new(0, 0.1, 0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			if _CONFIGS["飞行开关"] == false then
				DT.LP.Character.Humanoid.PlatformStand = true
			end
			while _CONFIGS["飞行开关"] == false or DT.LP.Character.Humanoid.Health == 0 do
				wait()
				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed + .5 + (speed / maxspeed)
					if speed > maxspeed then
						speed = maxspeed
					end
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
					speed = speed - 1
					if speed < 0 then
						speed = 0
					end
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
					lastctrl = {
						f = ctrl.f,
						b = ctrl.b,
						l = ctrl.l,
						r = ctrl.r
					}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
				else
					bv.velocity = Vector3.new(0, 0, 0)
				end
				bg.cframe = DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.Angles(- math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
			end
			ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			speed = 0
			bg:Destroy()
			bv:Destroy()
			DT.LP.Charactder.Humanoid.PlatformStand = false
			DT.LP.Character.Animate.Disabled = false
			tpwalking = false
		end
	end)
	
	function togggleInvisible(num)
		for i, v in pairs(DT.LP.Character:children()) do
			if v:IsA("Accessory") then
				for i, k in pairs(v:children()) do
					if k:IsA("Part") then
						k.Transparency = num
					end
				end
			end
			if v:IsA("Part") and v.Name ~= "HumanoidRootPart" then
				v.Transparency = num;
				if v.Name == "Head" then
					v:FindFirstChild"face".Transparency = num;
				end
			end
		end
	end
	
	DTwin2:NewSlider("悬浮高度", "悬浮slider", 0, 0, 300, false, function(v)
		_CONFIGS["悬浮高度"] = v;
	end)
	
	DTwin2:NewSlider("重力", "重力slider", 198, 0, 300, false, function(v)
		_CONFIGS["重力"] = v;
	end)
	
	DTwin2:NewToggle("无限跳", "toggleInfJump", false, function(bool)
	    _CONFIGS["无限跳"] = bool;
		DT.GS("UserInputService").JumpRequest:Connect(function()
			if _CONFIGS["无限跳"] == true then
			 --   DT.WKSPC.Gravity = 198; -- 防止两个都开造成卡顿
				DT.LP.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
			end
		end)
	end)
	
	DTwin2:NewToggle("穿墙", "toggleNoclip", false, function(bool)
	    _CONFIGS["穿墙开关"] = bool;
		local IsNoclip = DT.RS.Stepped:Connect(function()
			for i, v in next, DT.LP.Character:GetDescendants() do
				if _CONFIGS["穿墙开关"] then
					if v:IsA"BasePart" then
						v.CanCollide = false
					else
						pcall(
	                            function()
							IsNoclip:Disconnect()
							IsNoclip = nil;
						end)
					end
				end
			end
		end)
	end)
	
	DTwin2:NewButton("安全自杀--旧(会掉斧头)", function()
	    if not DT.LP.Character then
			return
		end
		DT.LP.Character.Head:Destroy()
		_CONFIGS["isBuying"] = false; --> 如果卡在了正在购买, 可以通过自杀来解决
	end)
	
	DTwin2:NewButton("安全自杀--新(不会掉斧头)", function()
	    DT:TP(273, -350, -98)
	end)
	
	DTwin2:NewButton("点击传送 [工具]", function()
	    if DT.LP.Backpack:FindFirstChild"点击传送" or DT.LP.Character:FindFirstChild"点击传送" then
			DT.LP.Backpack["点击传送"]:Destroy()
		end
		local ClickToTeleport = Instance.new("Tool", DT.LP.Backpack)
		ClickToTeleport.Name = "点击传送"
		ClickToTeleport.RequiresHandle = false
		ClickToTeleport.Activated:Connect(function()
			local x = Mouse.hit.x
			local y = Mouse.hit.y
			local z = Mouse.hit.z
			DT:Teleport(CFrame.new(x, y, z) + Vector3.new(0, 3, 0))
		end)
	end)
	
	
	DTwin2:NewToggle("灯光", "light", false, function(bool)
	    if bool then
			local MIXI_Light = Instance.new("PointLight", DT.LP.Character.Head)
			MIXI_Light.Name = "MIXI_Light"
			MIXI_Light.Range = 35
			MIXI_Light.Brightness = 5
		else
			DT.LP.Character.Head:FindFirstChild"MIXI_Light":Destroy()
		end
	end)
	
	DTwin2:NewToggle("水上行走", "waterWalk", false, function(bool)
		for i, v in next, DT.WKSPC.Water:GetDescendants() do
			if v:IsA("Part") then
				v.CanCollide = bool;
			end
		end
	end)
	
	DTwin2:NewSeparator()
	
	DTwin2:NewSlider("相机焦距", "焦距slider", 2000, 100, 2000, false, function(v)
	    _CONFIGS["相机焦距"] = v;
	end)
	
	
	DTwin2:NewSlider("广角", "广角slider", 70, 70, 120, false, function(v)
	    _CONFIGS["广角"] = v;
	end)
	
	local cameraType = {  --> 游戏相机视角类型
		"Fixed";-- 静止
		"Follow";-- 跟随
	    "Attach"; -- 固定
		"Track";-- 不会自动旋转
		"Watch";-- 静止状态, 旋转保持
		"Custom";-- 默认
		"Scriptable";
	}
	
	DTwin2:NewDropdown("选择相机模式", "相机模式", cameraType, function(v)
	    cameraType = v;
	end)
	
	DTwin2:NewButton("确认选择", function()
	    if type(cameraType) == "table" then return end
		DT.WKSPC.CurrentCamera.CameraType = Enum.CameraType[cameraType]
	end)
	
	DTwin2:NewButton("修复卡视角问题", function()
		DT.WKSPC.CurrentCamera.CameraType = Enum.CameraType["Watch"]
		task.wait()
		DT.WKSPC.CurrentCamera.CameraType = Enum.CameraType["Custom"]
	end)
	
	DTwin2:NewButton("锁定视角脚本", function()
		xpcall(function()
			if DT.LP.PlayerGui:FindFirstChild("Shiftlock (StarterGui)") then
				return
			end
			local a = Instance.new("ScreenGui")
			local b = Instance.new("ImageButton")
			a.Name = "Shiftlock (StarterGui)"
			a.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			a.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
			b.Parent = a;
			b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			b.BackgroundTransparency = 1.000;
			b.Position = UDim2.new(0.921914339, 0, 0.552375436, 0)
			b.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0)
			b.SizeConstraint = Enum.SizeConstraint.RelativeXX;
			b.Image = "http://www.roblox.com/asset/?id=182223762"
			local function c()
				local a = Instance.new('LocalScript', b)
				local b = {}
				local c = game:GetService("Players")
				local d = game:GetService("RunService")
				local e = game:GetService("ContextActionService")
				local c = c.LocalPlayer;
				local c = c.Character or c.CharacterAdded:Wait()
				local f = c:WaitForChild("HumanoidRootPart")
				local c = c.Humanoid;
				local g = workspace.CurrentCamera;
				local a = a.Parent;
				uis = game:GetService("UserInputService")
				ismobile = uis.TouchEnabled;
				a.Visible = ismobile;
				local h = {
					OFF = "rbxasset://textures/ui/mouseLock_off@2x.png",
					ON = "rbxasset://textures/ui/mouseLock_on@2x.png"
				}
				local i = 900000;
				local j = false;
				local k = CFrame.new(1.7, 0, 0)
				local l = CFrame.new(- 1.7, 0, 0)
				local function m(b)
					a.Image = h[b]
				end;
				local function h(a)
					c.AutoRotate = a
				end;
				local function c(a, a)
					return CFrame.new(f.Position, Vector3.new(a.CFrame.LookVector.X * i, f.Position.Y, a.CFrame.LookVector.Z * i))
				end;
				local function i()
					h(false)
					m("ON")
					f.CFrame = c(f, g)
					g.CFrame = g.CFrame * k
				end;
				local function c()
					h(true)
					m("OFF")
					g.CFrame = g.CFrame * l;
					pcall(function()
						j:Disconnect()
						j = nil
					end)
				end;
				m("OFF")
				j = false;
				function ShiftLock()
					if not j then
						j = d.RenderStepped:Connect(function()
							i()
						end)
					else
						c()
					end
				end;
				local f = e:BindAction("ShiftLOCK", ShiftLock, false, "On")
				e:SetPosition("ShiftLOCK", UDim2.new(0.8, 0, 0.8, 0))
				a.MouseButton1Click:Connect(function()
					if not j then
						j = d.RenderStepped:Connect(function()
							i()
						end)
					else
						c()
					end
				end)
				return b
			end;
			coroutine.wrap(c)()
			local function b()
				local a = Instance.new('LocalScript', a)
				local a = game:GetService("Players")
				local b = game:GetService("UserInputService")
				local c = UserSettings()
				local c = c.GameSettings;
				local d = {}
				while not a.LocalPlayer do
					wait()
				end;
				local a = a.LocalPlayer;
				local e = a:GetMouse()
				local f = a:WaitForChild("PlayerGui")
				local g, h, h;
				local i = true;
				local j = true;
				local k = false;
				local l = false;
				d.OnShiftLockToggled = Instance.new("BindableEvent")
				local function m()
					return a.DevEnableMouseLock and c.ControlMode == Enum.ControlMode.MouseLockSwitch and a.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and c.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and a.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable
				end;
				if not b.TouchEnabled then
					i = m()
				end;
				local function n()
					j = not j;
					d.OnShiftLockToggled:Fire()
				end;
				local o = function()
					
				end;
				function d:IsShiftLocked()
					return i and j
				end;
				function d:SetIsInFirstPerson(a)
					l = a
				end;
				local function l(a, a, a)
					if i then
						n()
					end
				end;
				local function l()
					if g then
						g.Parent = nil
					end;
					i = false;
					e.Icon = ""
					if h then
						h:disconnect()
						h = nil
					end;
					k = false;
					d.OnShiftLockToggled:Fire()
				end;
				local e = function(a, b)
					if b then
						return
					end;
					if a.UserInputType ~= Enum.UserInputType.Keyboard or a.KeyCode == Enum.KeyCode.LeftShift or a.KeyCode == Enum.KeyCode.RightShift then
					end
				end;
				local function n()
					i = m()
					if i then
						if g then
							g.Parent = f
						end;
						if j then
							d.OnShiftLockToggled:Fire()
						end;
						if not k then
							h = b.InputBegan:connect(e)
							k = true
						end
					end
				end;
				c.Changed:connect(function(a)
					if a == "ControlMode" then
						if c.ControlMode == Enum.ControlMode.MouseLockSwitch then
							n()
						else
							l()
						end
					elseif a == "ComputerMovementMode" then
						if c.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
							l()
						else
							n()
						end
					end
				end)
				a.Changed:connect(function(b)
					if b == "DevEnableMouseLock" then
						if a.DevEnableMouseLock then
							n()
						else
							l()
						end
					elseif b == "DevComputerMovementMode" then
						if a.DevComputerMovementMode == Enum.DevComputerMovementMode.ClickToMove or a.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
							l()
						else
							n()
						end
					end
				end)
				a.CharacterAdded:connect(function(a)
					if not b.TouchEnabled then
						o()
					end
				end)
				if not b.TouchEnabled then
					o()
					if m() then
						h = b.InputBegan:connect(e)
						k = true
					end
				end;
				n()
				return d
			end;
			coroutine.wrap(b)()
		end, ifError)
	end)
	
	getgenv()["物品总数"] = 1;
	
	DTwin3:NewSlider("物品数量", "buycountslider", 1, 1, 25, false, function(v)
	    getgenv()["物品总数"] = v;
	end)
	
	getgenv()["不想购买"] = false;
	
	DTwin3:NewButton("停止购买", function()
	    getgenv()["不想购买"] = true;
	    wait(1)
	    getgenv()["不想购买"] = false;
	end)
	
	DTwin3:NewSeparator();
	
	local WoodRus_Store = {
		"基础斧头 12$",
		"普通斧头 90$",
		"钢斧 190$",
		"硬化斧 550$",
		"银斧头 2040$",
		"破旧锯木厂 130$",
		"普通锯木厂 1600$",
		"锯木机01 11000$",
		"锯木机02 22500$",
		"锯木机02L 86500$",
		"多用途运载车 400$",
		"工作灯 80$",
		"沙子袋 1600$",
		"劈锯 12200$",
		"铁丝 205$",
		"按钮 320$",
		"控制杆 520$",
		"压力板 640$",
		"急弯传送带 100$",
		"直式传送带 80$",
		"漏斗式传送带 60$",
		"倾斜传送带 95$",
		"左转直式传送带 480$",
		"右转直式传送带 480$",
		"切换传送器 320$",
		"木头清扫机 430$",
		"传送带支架 12$",
	}
	
	local function newDragModel(model, cframe)
	    if not model.PrimaryPart then
	        model.PrimaryPart = model:FindFirstChildOfClass("Part")
	    end
	    DT.RES.Interaction.ClientIsDragging:FireServer(model)
	    model.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
	    model:PivotTo(cframe)
	end
	
	local function getShopId(c, n, i)
		return {
			["Character"] = c,
			["Name"] = n,
			["ID"] = tonumber(i)
		}
	end
	
	local Stores = {
		["WoodRUs"] = getShopId(DT.WKSPC.Stores.WoodRUs.Thom, "Thom", 7);
		["FurnitureStore"] = getShopId(DT.WKSPC.Stores.FurnitureStore.Corey, "Corey", 8);
		["CarStore"] = getShopId(DT.WKSPC.Stores.CarStore.Jenny, "Jenny", 9);
		["ShackShop"] = getShopId(DT.WKSPC.Stores.ShackShop.Bob, "Bob", 10);
		["LandStore"] = getShopId(DT.WKSPC.Stores.LandStore.Ruhven, "Ruhven", 1);
		["FineArt"] = getShopId(DT.WKSPC.Stores.FineArt.Timothy, "Timothy", 11);
		["LogicStore"] = getShopId(DT.WKSPC.Stores.LogicStore.Lincoln, "Lincoln", 12);
		["TollBooth0"] = getShopId(DT.WKSPC.Bridge.TollBooth0.Seranok, "Seranok", 14);
		["Ferry"] = getShopId(DT.WKSPC.Ferry.Ferry.Hoover, "Hoover", 15);
		["Region_Main"] = getShopId(DT.WKSPC.Region_Main:FindFirstChild("Strange Man"), "Strange Man", 3);
	};
	
	
	local function buyItem(count, store, item, name)
		if type(item) == "table" then
			DT:NOTIFY("错误", "请先选择商品!", 4)
			return
		end
		count = count or 1
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame;
		local sum = 0;
		while sum < count  do
		    if getgenv()["不想购买"] == true then
		        DT:Teleport(oldpos)
				return
		    end
		    
			local Item
			for i, v in next, DT.WKSPC.Stores:children() do
				if v.Name == "ShopItems" and v:FindFirstChild"Box" then
					for j, k in next, v:children() do
						if k.BoxItemName.Value == item then
							ltem = k
						end
					end
				end
			end
			repeat
				DT.RS.Heartbeat:wait()
			until ltem ~= nil
			DT:Teleport(ltem.Main.CFrame + Vector3.new(0, 1, 5))
			task.wait(0.5)
			repeat
			    if getgenv()["不想购买"] == true then
		            DT:Teleport(oldpos)
				    return
		        end
				newDragModel(ltem, DT.WKSPC.Stores[name].Counter.CFrame + Vector3.new(0, .6, 0))
				DT:Teleport(ltem.Main.CFrame + Vector3.new(0, 1, 5))
				task.wait(0.2)
	            --print((ltem.Main.Position - DT.WKSPC.Stores[name].Counter.Position).Magnitude)
			until (ltem.Main.Position - DT.WKSPC.Stores[name].Counter.Position).Magnitude < 5;
			task.wait(0.4)
			DT:Teleport(DT.WKSPC.Stores[name].Counter.CFrame + Vector3.new(0, 5, 5))
			DT.RS.Heartbeat:wait()
			repeat
				DT.RS.Heartbeat:wait()
				if getgenv()["不想购买"] == true then
		            DT:Teleport(oldpos)
				    return
		        end
				DT.RES.Interaction.ClientIsDragging:FireServer(ltem)
				DT.RES.NPCDialog.PlayerChatted:InvokeServer(store, "ConfirmPurchase")
			until ltem.Owner.Value == DT.LP or ltem.Owner.Value ~= nil
			for i = 1, 30 do
				newDragModel(ltem, oldpos)
				task.wait(0.01)
			end
			task.wait(0.5)
			sum = sum + 1
		end
		DT:Teleport(oldpos)
	end
	
	DTwin3:NewDropdown("反斗城商品", "shop_woodrus", WoodRus_Store, function(WShop)
	    if WShop == "基础斧头 12$" then
			WoodRus_Store = "BasicHatchet"
		end
		if WShop == "普通斧头 90$" then
			WoodRus_Store = "Axe1"
		end
		if WShop == "钢斧 190$" then
			WoodRus_Store = "Axe2"
		end
		if WShop == "硬化斧 550$" then
			WoodRus_Store = "Axe3"
		end
		if WShop == "银斧头 2040$" then
			WoodRus_Store = "SilverAxe"
		end
		if WShop == "破旧锯木厂 130$" then
			WoodRus_Store = "Sawmill"
		end
		if WShop == "普通锯木厂 1600$" then
			WoodRus_Store = "Sawmill2"
		end
		if WShop == "锯木机01 11000$" then
			WoodRus_Store = "Sawmill3"
		end
		if WShop == "锯木机02 22500$" then
			WoodRus_Store = "Sawmill4"
		end
		if WShop == "锯木机02L 86500$" then
			WoodRus_Store = "Sawmill4L"
		end
		if WShop == "多用途运载车 400$" then
			WoodRus_Store = "UtilityTruck"
		end
		if WShop == "工作灯 80$" then
			WoodRus_Store = "WorkLight"
		end
		if WShop == "沙子袋 1600$" then
			WoodRus_Store = "BagOfSand"
		end
		if WShop == "劈锯 12200$" then
			WoodRus_Store = "ChopSaw"
		end
		if WShop == "铁丝 205$" then
			WoodRus_Store = "Wire"
		end
		if WShop == "按钮 320$" then
			WoodRus_Store = "Button0"
		end
		if WShop == "控制杆 520$" then
			WoodRus_Store = "Lever0"
		end
		if WShop == "压力板 640$" then
			WoodRus_Store = "PressurePlate"
		end
		if WShop == "急弯传送带 100$" then
			WoodRus_Store = "TightTurnConveyor"
		end
		if WShop == "直式传送带 80$" then
			WoodRus_Store = "StraightConveyor"
		end
		if WShop == "漏斗式传送带 60$" then
			WoodRus_Store = "ConveyorFunnel"
		end
		if WShop == "倾斜传送带 95$" then
			WoodRus_Store = "TiltConveyor"
		end
		if WShop == "左转直式传送带 480$" then
			WoodRus_Store = "StraightSwitchConveyorLeft"
		end
		if WShop == "右转直式传送带 480$" then
			WoodRus_Store = "StraightSwitchConveyorRight"
		end
		if WShop == "切换传送器 320$" then
			WoodRus_Store = "ConveyorSwitch"
		end
		if WShop == "木头清扫机 430$" then
			WoodRus_Store = "LogSweeper"
		end
		if WShop == "传送带支架 12$" then
			WoodRus_Store = "ConveyorSupports"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["WoodRUs"], WoodRus_Store, "WoodRUs"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local BluePrintStore = {
		"篱笆[宽] 80$",
		"篱笆[窄] 80$",
		"篱笆角 80$",
		"矮篱笆[宽] 80$",
		"矮篱笆[窄] 80$",
		"矮篱笆角 80$",
		"光滑的墙[宽] 80$",
		"光滑的墙[窄] 80$",
		"光滑墙角 80$",
		"矮光滑墙[宽] 80$",
		"矮光滑墙[窄] 80$",
		"又矮又光滑的墙角 80$",
		"光滑墙立柱[宽] 80$",
		"光滑墙立柱[窄] 80$",
		"光滑墙角立柱 80$",
		"波纹墙[宽] 80$",
		"波纹墙[窄] 80$",
		"波纹墙角 80$",
		"矮波纹墙[宽] 80$",
		"矮波纹墙[窄] 80$",
		"矮波纹墙角 80$",
		"波纹墙立柱[宽] 80$",
		"波纹墙立柱[窄] 80$",
		"波纹墙角立柱 80$",
		"微型瓷砖 80$",
		"小型瓷砖 80$",
		"瓷砖 80$",
		"大型瓷砖 80$",
		"微型地板 80$",
		"小型地板 80$",
		"地板 80$",
		"大型地板 80$",
		"方桌 80$",
		"长桌 80$",
		"普通椅子 80$",
		"陡峭楼梯 80$",
		"楼梯 80$",
		"梯子 80$",
		"标志杆 80$",
		"普通门 80$",
		"半截门 80$",
		"宽敞门 80$",
		"4/4木楔 80$",
		"4/4x1 木楔 80$",
		"3/4木楔 80$",
		"3/4x1 木楔 80$",
		"2/4木楔 80$",
		"2/4x1木楔 80$",
		"1/4木楔 80$",
		"1/4x1木楔 80$",
		"3/3木楔 80$",
		"3/3x1 木楔 80$",
		"2/3木楔 80$",
		"2/3x1木楔 80$",
		"1/3木楔 80$",
		"1/3x1木楔 80$",
		"2/2木楔 80$",
		"2/2x1木楔 80$",
		"1/2木楔 80$",
		"1/2x1木楔 80$",
		"1/1木楔 80$",
		"1/1x1木楔 80$"
	}
	
	DTwin3:NewDropdown("蓝图商品", "shop_blueprint", BluePrintStore, function(item)
	    if item == "篱笆[宽] 80$" then
			BluePrintStore = "Wall3Tall"
		end
		if item == "篱笆[窄] 80$" then
			BluePrintStore = "Wall3TallThin"
		end
		if item == "篱笆角 80$" then
			BluePrintStore = "Wall3TallCorner"
		end
		if item == "矮篱笆[宽] 80$" then
			BluePrintStore = "Wall3"
		end
		if item == "矮篱笆[窄] 80$" then
			BluePrintStore = "Wall3Thin"
		end
		if item == "矮篱笆角 80$" then
			BluePrintStore = "Wall3Corner"
		end
		if item == "光滑的墙[宽] 80$" then
			BluePrintStore = "Wall2Tall"
		end
		if item == "光滑的墙[窄] 80$" then
			BluePrintStore = "Wall2TallThin"
		end
		if item == "光滑墙角 80$" then
			BluePrintStore = "Wall2TallCorner"
		end
		if item == "矮光滑墙[宽] 80$" then
			BluePrintStore = "Wall2"
		end
		if item == "矮光滑墙[窄] 80$" then
			BluePrintStore = "Wall2Thin"
		end
		if item == "又矮又光滑的墙角 80$" then
			BluePrintStore = "Wall2Corner"
		end
		if item == "光滑墙立柱[宽] 80$" then
			BluePrintStore = "Wall2Short"
		end
		if item == "光滑墙立柱[窄] 80$" then
			BluePrintStore = "Wall2ShortThin"
		end
		if item == "光滑墙角立柱 80$" then
			BluePrintStore = "Wall2ShortCorner"
		end
		if item == "波纹墙[宽] 80$" then
			BluePrintStore = "Wall1Tall"
		end
		if item == "波纹墙[窄] 80$" then
			BluePrintStore = "Wall1TallThin"
		end
		if item == "波纹墙角 80$" then
			BluePrintStore = "Wall1TallCorner"
		end
		if item == "矮波纹墙[宽] 80$" then
			BluePrintStore = "Wall1"
		end
		if item == "矮波纹墙[窄] 80$" then
			BluePrintStore = "Wall1Thin"
		end
		if item == "矮波纹墙角 80$" then
			BluePrintStore = "Wall1Corner"
		end
		if item == "波纹墙立柱[宽] 80$" then
			BluePrintStore = "Wall1Short"
		end
		if item == "波纹墙立柱[窄] 80$" then
			BluePrintStore = "Wall1ShortThin"
		end
		if item == "波纹墙角立柱 80$" then
			BluePrintStore = "Wall1ShortCorner"
		end
		if item == "微型瓷砖 80$" then
			BluePrintStore = "Floor2Tiny"
		end
		if item == "小型瓷砖 80$" then
			BluePrintStore = "Floor2Small"
		end
		if item == "瓷砖 80$" then
			BluePrintStore = "Floor2"
		end
		if item == "大型瓷砖 80$" then
			BluePrintStore = "Floor2Large"
		end
		if item == "微型地板 80$" then
			BluePrintStore = "Floor1Tiny"
		end
		if item == "小型地板 80$" then
			BluePrintStore = "Floor1Small"
		end
		if item == "地板" then
			BluePrintStore = "Floor1"
		end
		if item == "大型地板 80$" then
			BluePrintStore = "Floor1Large"
		end
		if item == "方桌 80$" then
			BluePrintStore = "Table1"
		end
		if item == "长桌 80$" then
			BluePrintStore = "Table2"
		end
		if item == "普通椅子 80$" then
			BluePrintStore = "Chair1"
		end
		if item == "陡峭楼梯 80$" then
			BluePrintStore = "Stair1"
		end
		if item == "楼梯 80$" then
			BluePrintStore = "Stair2"
		end
		if item == "梯子 80$" then
			BluePrintStore = "Ladder1"
		end
		if item == "标志杆 80$" then
			BluePrintStore = "Post"
		end
		if item == "普通门 80$" then
			BluePrintStore = "Door1"
		end
		if item == "半截门 80$" then
			BluePrintStore = "Door2"
		end
		if item == "宽敞门 80$" then
			BluePrintStore = "Door3"
		end
		if item == "4/4木楔 80$" then
			BluePrintStore = "Wedge1"
		end
		if item == "4/4x1 木楔 80$" then
			BluePrintStore = "Wedge1_Thin"
		end
		if item == "4/4木楔 80$" then
			BluePrintStore = "Wedge1"
		end
		if item == "4/4x1 木楔 80$" then
			BluePrintStore = "Wedge1_Thin"
		end
		if item == "3/4木楔 80$" then
			BluePrintStore = "Wedge2"
		end
		if item == "3/4x1 木楔 80$" then
			BluePrintStore = "Wedge2_Thin"
		end
		if item == "2/4木楔 80$" then
			BluePrintStore = "Wedge3"
		end
		if item == "2/4x1 木楔 80$" then
			BluePrintStore = "Wedge3_Thin"
		end
		if item == "1/4木楔 80$" then
			BluePrintStore = "Wedge4"
		end
		if item == "1/4x1 木楔 80$" then
			BluePrintStore = "Wedge4_Thin"
		end
		if item == "3/3木楔 80$" then
			BluePrintStore = "Wedge5"
		end
		if item == "3/3x1 木楔 80$" then
			BluePrintStore = "Wedge5_Thin"
		end
		if item == "2/3木楔 80$" then
			BluePrintStore = "Wedge6"
		end
		if item == "2/3x1 木楔 80$" then
			BluePrintStore = "Wedge6_Thin"
		end
		if item == "1/3木楔 80$" then
			BluePrintStore = "Wedge7"
		end
		if item == "1/3x1 木楔 80$" then
			BluePrintStore = "Wedge7_Thin"
		end
		if item == "2/2木楔 80$" then
			BluePrintStore = "Wedge8"
		end
		if item == "2/2x1 木楔 80$" then
			BluePrintStore = "Wedge8_Thin"
		end
		if item == "1/2木楔 80$" then
			BluePrintStore = "Wedge9"
		end
		if item == "1/2x1 木楔 80$" then
			BluePrintStore = "Wedge9_Thin"
		end
		if item == "1/1木楔 80$" then
			BluePrintStore = "Wedge10"
		end
		if item == "1/1x1 木楔 80$" then
			BluePrintStore = "Wedge10_Thin"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["WoodRUs"], BluePrintStore, "WoodRUs"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	DTwin3:NewButton("购买土地", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores.LandStore, "EnterPurchase")
	end)
	
	DTwin3:NewSeparator();
	
	local Car_Store = {
		"小型拖车 1800$",
		"531式拖车 13000$",
		"多用途运载车XL 5000$",
		"瓦尔的全功能拖车 19000$"
	}
	
	DTwin3:NewDropdown("盒子车行", "shop_woodrus", Car_Store, function(item)
	    if item == "小型拖车 1800$" then
			Car_Store = "SmallTrailer"
		end
		if item == "531式拖车 13000$" then
			Car_Store = "Trailer2"
		end
		if item == "多用途运载车XL 5000$" then
			Car_Store = "UtilityTruck2"
		end
		if item == "瓦尔的全功能拖车 19000$" then
			Car_Store = "Pickup1"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["CarStore"], Car_Store, "CarStore"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local Furniture_Store = {
		"洗碗机 380$",
		"火炉 340$",
		"冰箱 310$",
		"马桶 90$",
		"床2 350$",
		"床1 250$",
		"大型玻璃板 550$",
		"玻璃板 220$",
		"小型玻璃板 50$",
		"微型玻璃板 12$",
		"普通玻璃门 720$",
		"灯泡 2600$",
		"照明灯 90$",
		"墙灯 90$",
		"台灯 90$",
		"落地灯 110$",
		"长沙发 320$",
		"双人沙发 200$",
		"扶手椅 140$",
		"惊悚冰柱灯串 910$",
		"琥珀色冰柱灯串 750$",
		"蓝色冰柱灯串 750$",
		"绿色冰柱灯串 750$",
		"红色冰柱灯串 750$",
		"烟花发射器 7500$",
		"薄柜子 80$",
		"橱柜 80$",
		"橱柜角 80$",
		"宽橱柜角 80$",
		"薄工作台面 80$",
		"工作台面 80$",
		"带水槽的工作台面 80$"
	}
	
	DTwin3:NewDropdown("家具店商品", "shop_f", Furniture_Store, function(item)
	    if item == "洗碗机 380$" then
			Furniture_Store = "Dishwasher"
		end
		if item == "火炉 340$" then
			Furniture_Store = "Stove"
		end
		if item == "冰箱 310$" then
			Furniture_Store = "Refridgerator"
		end
		if item == "马桶 90$" then
			Furniture_Store = "Toilet"
		end
		if item == "床2 350$" then
			Furniture_Store = "Bed2"
		end
		if item == "床1 250$" then
			Furniture_Store = "Bed1"
		end
		if item == "大型玻璃板 550$" then
			Furniture_Store = "GlassPane4"
		end
		if item == "玻璃板 220$" then
			Furniture_Store = "GlassPane3"
		end
		if item == "小型玻璃板 50$" then
			Furniture_Store = "GlassPane2"
		end
		if item == "微型玻璃板 12$" then
			Furniture_Store = "GlassPane1"
		end
		if item == "普通玻璃门 720$" then
			Furniture_Store = "GlassDoor1"
		end
		if item == "灯泡 2600$" then
			Furniture_Store = "LightBulb"
		end
		if item == "照明灯 90$" then
			Furniture_Store = "WallLight2"
		end
		if item == "墙灯 90$" then
			Furniture_Store = "WallLight1"
		end
		if item == "台灯 90$" then
			Furniture_Store = "Lamp1"
		end
		if item == "落地灯 110$" then
			Furniture_Store = "FloorLamp1"
		end
		if item == "长沙发 320$" then
			Furniture_Store = "Seat_Couch"
		end
		if item == "双人沙发 200$" then
			Furniture_Store = "Seat_Loveseat"
		end
		if item == "扶手椅 140$" then
			Furniture_Store = "Seat_Armchair"
		end
		if item == "惊悚冰柱灯串 910$" then
			Furniture_Store = "IcicleWireHalloween"
		end
		if item == "琥珀色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireAmber"
		end
		if item == "蓝色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireBlue"
		end
		if item == "绿色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireGreen"
		end
		if item == "红色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireRed"
		end
		if item == "烟花发射器 7500$" then
			Furniture_Store = "FireworkLauncher"
		end
		if item == "薄柜子 80$" then
			Furniture_Store = "Cabinet1Thin"
		end
		if item == "橱柜 80$" then
			Furniture_Store = "Cabinet1"
		end
		if item == "橱柜角 80$" then
			Furniture_Store = "Cabinet1CornerTight"
		end
		if item == "宽橱柜角 80$" then
			Furniture_Store = "Cabinet1CornerWide"
		end
		if item == "薄工作台面 80$" then
			Furniture_Store = "CounterTop1Thin"
		end
		if item == "工作台面 80$" then
			Furniture_Store = "CounterTop1"
		end
		if item == "带水槽的工作台面 80$" then
			Furniture_Store = "CounterTop1Sink"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["FurnitureStore"], Furniture_Store, "FurnitureStore"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local Shack_Shop = {
		"炸药 220$",
		"毛毛虫软糖罐 3200$",
	}
	
	DTwin3:NewDropdown("鲍勃小屋", "shop_shack", Shack_Shop, function(item)
		if item == "炸药 220$" then
			Shack_Shop = "Dynamite"
		end
		if item == "毛毛虫软糖罐 3200$" then
			Shack_Shop = "CanOfWorms"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["ShackShop"], Shack_Shop, "ShackShop"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local FineArts = {
		"北极灯串 16000$",
		"孤独的长颈鹿 26800$",
		"未知标题 5980$",
		"户外水彩素描 6$",
		"困扰装饰画 2006$",
		"阴郁的黄昏海景 16800$",
		"菠萝 2406000$"
	}
	
	DTwin3:NewDropdown("艺术品商店", "shop_fineart", FineArts, function(item)
	    if item == "北极灯串 16000$" then
			FineArts = "Painting7"
		end
		if item == "孤独的长颈鹿 26800$" then
			FineArts = "Painting9"
		end
		if item == "未知标题 5980$" then
			FineArts = "Painting1"
		end
		if item == "户外水彩素描 6$" then
			FineArts = "Painting3"
		end
		if item == "困扰装饰画 2006$" then
			FineArts = "Painting2"
		end
		if item == "阴郁的黄昏海景 16800$" then
			FineArts = "Painting6"
		end
		if item == "菠萝 2406000$" then
			FineArts = "Painting8"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["FineArt"], FineArts, "FineArt"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local Logic_Store = {
		"铁丝 205$",
		"按钮 320$",
		"控制杆 520$",
		"压力板 640$",
		"激光探测器 3200$",
		"激光 11300$",
		"木材探测器 11300$",
		"定时开关 902$",
		"异或门 260$",
		"或门 260$",
		"与门 260$",
		"信号变换器 200$",
		"白色霓虹灯线 720$",
		"紫罗兰色霓虹灯线 720$",
		"蓝色霓虹灯线 720$",
		"蓝绿色霓虹灯线 720$",
		"绿色霓虹灯线 720$",
		"黄色霓虹灯线 720$",
		"橙色霓虹灯线 720$",
		"红色霓虹灯线 720$",
		"舱门 830$",
		"信号延迟 520$",
		"信号维持 520$"
	}
	
	DTwin3:NewDropdown("连接逻辑店", "shop_logic", Logic_Store, function(item)
		if item == "铁丝 205$" then
			Logic_Store = "Wire"
		end
		if item == "按钮 320$" then
			Logic_Store = "Button0"
		end
		if item == "控制杆 520$" then
			Logic_Store = "Lever0"
		end
		if item == "压力板 640$" then
			Logic_Store = "PressurePlate"
		end
		if item == "激光探测器 3200$" then
			Logic_Store = "LaserReceiver"
		end
		if item == "激光 11300$" then
			Logic_Store = "Laser"
		end
		if item == "木材探测器 11300$" then
			Logic_Store = "WoodChecker"
		end
		if item == "定时开关 902$" then
			Logic_Store = "ClockSwitch"
		end
		if item == "异或门 260$" then
			Logic_Store = "GateXOR"
		end
		if item == "或门 260$" then
			Logic_Store = "GateOR"
		end
		if item == "与门 260$" then
			Logic_Store = "GateAND"
		end
		if item == "信号变换器 200$" then
			Logic_Store = "GateNOT"
		end
		if item == "白色霓虹灯线 720$" then
			Logic_Store = "NeonWireWhite"
		end
		if item == "紫罗兰色霓虹灯线 720$" then
			Logic_Store = "NeonWireViolet"
		end
		if item == "蓝色霓虹灯线 720$" then
			Logic_Store = "NeonWireBlue"
		end
		if item == "蓝绿色霓虹灯线 720$" then
			Logic_Store = "NeonWireCyan"
		end
		if item == "绿色霓虹灯线 720$" then
			Logic_Store = "NeonWireGreen"
		end
		if item == "黄色霓虹灯线 720$" then
			Logic_Store = "NeonWireYellow"
		end
		if item == "橙色霓虹灯线 720$" then
			Logic_Store = "NeonWireOrange"
		end
		if item == "红色霓虹灯线 720$" then
			Logic_Store = "NeonWireRed"
		end
		if item == "舱门 830$" then
			Logic_Store = "Hatch"
		end
		if item == "信号延迟 520$" then
			Logic_Store = "SignalDelay"
		end
		if item == "信号维持 520$" then
			Logic_Store = "SignalSustain"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["LogicStore"], Logic_Store, "LogicStore"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	DTwin3:NewButton("购买桥票 $100", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores["TollBooth0"], "ConfirmPurchase")
	end)
	
	DTwin3:NewButton("购买船票 $400", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores["Ferry"], "ConfirmPurchase")
	end)
	
	
	DTwin3:NewButton("购买超级蓝图 $10009000", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores["Region_Main"], "ConfirmPurchase")
	end)
	
	
	local players = game:GetService("Players");
	local player = players.LocalPlayer;
	getgenv()["不想砍树"] = false;
	
	local function getDamage(tool)
		local modTool = require(game:GetService("ReplicatedStorage").AxeClasses[("AxeClass_%s"):format(tool.ToolName.Value)])
		local t = modTool.new()
		return t.Damage
	end
	
	local function getCurrentAxe()
		local tool = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Tool")
		if tool and tool.Name ~= "BlueprintTool" then
			return tool
		end
		return false;
	end
	
	local MIXI_ENDTIME_PART = function()
		if DT.WKSPC:FindFirstChild"MIXI_EndTimeTree_OfPart" then
			return
		end
		local part = Instance.new("Part", DT.WKSPC)
		part.Size = Vector3.new(300, 1, 300)
		part.CFrame = CFrame.new(- 45.1, - 216.15, - 1341.15)
		part.Anchored = true
		part.BrickColor = BrickColor.new("Bright red")
		part.Material = Enum.Material.DiamondPlate
		part.Name = "MIXI_EndTimeTree_OfPart"
	end
	
	
	local function cutTree(config)
		local config = config or {};
		config.Cutevent = config.Cutevent or nil; --> 砍树事件是必须要的!
		config.Tool = config.Tool or nil; --> 斧头是必须要的!
		config.Height = config.Height or 0.3;
		config.SectionId = config.SectionId or 1;
		config.FaceVector = config.FaceVector or Vector3.new(1, 0, 0);
		local damage
		if config.Tool.ToolName.Value == "EndTimesAxe" and config.Cutevent.Parent.TreeClass.Value == "LoneCave" then
			damage = 10000000;
			MIXI_ENDTIME_PART()
		elseif config.Tool.ToolName.Value == "OvergrownAxe" and config.Cutevent.Parent.TreeClass.Value == "GreenSwampy" then
			damage = 7;
		elseif config.Tool.ToolName.Value == "OvergrownAxe" and config.Cutevent.Parent.TreeClass.Value == "GoldSwampy" then
			damage = 5.35;
		elseif config.Tool.ToolName.Value == "FireAxe" and config.Cutevent.Parent.TreeClass.Value == "Volcano" then
			damage = 6.35;
		elseif config.Tool.ToolName.Value == "CaveAxe" and config.Cutevent.Parent.TreeClass.Value == "CaveCrawler" then
			damage = 7.2;
		elseif config.Tool.ToolName.Value == "IceAxe" and config.Cutevent.Parent.TreeClass.Value == "Frost" then
	        damage = 6;
		else
			damage = getDamage(config.Tool);
		end
		game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(
	    config.Cutevent, {
			["tool"] = config.Tool;
			["faceVector"] = config.FaceVector;
			["height"] = config.Height;
			["sectionId"] = config.SectionId;
			["hitPoints"] = tonumber(damage);
			["cooldown"] = 0.01;
			["cuttingClass"] = "Axe";
		})
	end
	
	local getNo1Axe = function(tree)
		local axes = {};
		local bestTool
		for _, v in next, DT.LP.Character:GetChildren() do
			if v:IsA("Tool") and v.Name ~= "BlueprintTool" then
				if v:FindFirstChild("CuttingTool") then
				    table.insert(axes, v)
				end
			end
		end
		for _, v in next, DT.LP.Backpack:GetChildren() do
			if v:IsA("Tool") and v.Name ~= "BlueprintTool" then
			    if v:FindFirstChild("CuttingTool") then
				    table.insert(axes, v)
				end
			end
		end
		local bbb = {}
		for i, v in next, axes do
		 --   print("iv=", i,v)
			local damage
		--	print(tree)
			if v.ToolName.Value == "EndTimesAxe" and tree == "LoneCave" then
				damage = 10000000;
				return v
			elseif v.ToolName.Value == "OvergrownAxe" and tree == "GreenSwampy" then
				damage = 7;
				return v
			elseif v.ToolName.Value == "OvergrownAxe" and tree == "GoldSwampy" then
				damage = 5.35;
				return v
		    elseif v.ToolName.Value == "IceAxe" and tree == "Frost" then
		        damage = 6;
		        return v
			elseif v.ToolName.Value == "FireAxe" and tree == "Volcano" then
				damage = 6.35;
				return v
			elseif v.ToolName.Value == "CaveAxe" and tree == "CaveCrawler" then
				damage = 7.2;
				return v
			else
				table.insert(bbb, v)
			end
		end
		for i, v in next, bbb do
			if math.max(getDamage(v)) then
				bestTool = v;
			end
		end
		return bestTool
	end
	
	
	local getAxe = function(tree)
		local Axe = getNo1Axe(tree);
		if not Axe then
			return DT:NOTIFY("错误!", "没有找到斧头!", 4)
		end
		return Axe
	end
	   
	
	local function bringTree(config)
		local config = config or {};
		config.TreeValue = config.TreeValue or "Generic"; --> 树是必须要的!
		config.Quantity = config.Quantity or 1; --> 带来树的数量
		local oldpos = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame;
		
		if not getAxe(config.TreeValue) then 
		    DT:Teleport(oldpos)
		    return DT:NOTIFY("错误!", "没有找到斧头!", 3)
		end
		
		    
		local woods = {}
		local sum = 0;
		while sum < config.Quantity  do
		    if getgenv()["不想砍树"] == true then
		        DT:Teleport(oldpos)
		        DT.WKSPC.Camera.CameraSubject = DT.LP.Character
	         	togggleInvisible(0)
				return
		    end
			local wood, treeToCut;
			local checkWoodSize = {};
			for _, v in next, game:GetService("Workspace"):GetDescendants() do
				if v.Name == "TreeRegion" then
					for _, model in next, v:children() do
						if model:FindFirstChild("CutEvent") then
							if model:FindFirstChild("WoodSection") then
								table.insert(woods, model.WoodSection)
								if # woods >= 3 then --> 判断树大小
									if model.Owner.Value == nil or model.Owner.Value == DT.LP then
										if not model:FindFirstChild("RootCut") then
											if model.TreeClass.Value == config.TreeValue then
												wood = model;
											end
										end
									end
								end
							end
						end
					end
				end
			end
			if wood == nil then
				DT:NOTIFY("错误!", "没有找到树!", 4)
				DT:Teleport(oldpos)
				return
			end
	       
	        
	        --> 检查树大小 和 定位传送part
			local woodPart;
			for _, v in next, wood:GetDescendants() do
				if v.Name == "WoodSection" then
					treeToCut = wood.CutEvent
					table.insert(woods, v)
					if v:FindFirstChild("ID") and v.ID.Value == 1 then
						woodPart = v
					end
				end
			end
			togggleInvisible(1)
			repeat
			    if getgenv()["不想砍树"] == true then
		            DT:Teleport(oldpos)
		            DT.WKSPC.Camera.CameraSubject = DT.LP.Character
	             	togggleInvisible(0)
				    return
		        end
				DT.WKSPC.Camera.CameraSubject = woodPart;
				DT:Teleport(woodPart.CFrame + Vector3.new(0, 2.5, 3.5));
				task.wait()
				cutTree({
					Cutevent = treeToCut;
					Tool = getAxe(config.TreeValue);
					Height = 0.3;
				})
			until wood:FindFirstChild("RootCut")
			local Log
			for s, b in next, DT.WKSPC.LogModels:GetDescendants() do
				if b:FindFirstChild"Owner" and b.Owner.Value == DT.LP then
					Log = b
				end
			end
			for i = 1, 20 do
				newDragModel(Log, oldpos)
				task.wait(0.1)
			end
			task.wait()
			sum = sum + 1;
		end
		DT:Teleport(oldpos)
		DT.WKSPC.Camera.CameraSubject = DT.LP.Character
		togggleInvisible(0)    
	end
	
	getgenv()["带来树数量"] = 1;
	
	DTwin4:NewSlider("砍树数量", "砍树slider", 1, 1, 30, false, function(v)
	   getgenv()["带来树数量"] = v;
	end)
	
	local tree_list = {
		"原始木",
		"金木",
		"蓝木",
		"樱桃木",
		"冰木",
		"火山木",
		"橡树",
		"胡桃木",
		"白桦木",
		"雪光木",
		"雪松",
		"僵尸木",
		"棕树",
		"椰子树",
		"幻影木"
	}
	local select_tree = "Generic";
	
	DTwin4:NewDropdown("选择树", "select_tree", tree_list, function(list)
		if list == "火山木" then
			select_tree = ("Volcano")
		end
		if list == "蓝木" then
			select_tree = ("CaveCrawler")
		end
		if list == "原始木" then
			select_tree = ("Generic")
		end
		if list == "樱桃木" then
			select_tree = ("Cherry")
		end
		if list == "僵尸木" then
			select_tree = ("GreenSwampy")
		end
		if list == "椰子树" then
			select_tree = ("Palm")
		end
		if list == "金木" then
			select_tree = ("GoldSwampy")
		end
		if list == "冰木" then
			select_tree = ("Frost")
		end
		if list == "胡桃木" then
			select_tree = ("Walnut")
		end
		if list == "雪光木" then
			select_tree = ("SnowGlow")
		end
		if list == "橡树" then
			select_tree = ("Oak")
		end
		if list == "白桦木" then
			select_tree = ("Birch")
		end
		if list == "棕树" then
			select_tree = ("Koa")
		end
		if list == "雪松" then
			select_tree = ("Pine")
		end
		if list == "幻影木" then
			select_tree = ("LoneCave")
		end
	end)
	
	DTwin4:NewButton("带来树", function()
		bringTree({
			TreeValue = select_tree;
			Quantity = tonumber(getgenv()["带来树数量"]);
		})
	end)
	
	DTwin4:NewButton("停止", function()
	    getgenv()["不想砍树"] = true;
	    wait(1)
	    getgenv()["不想砍树"] = false;
	end)
	
	DTwin4:NewSeparator();
	
	DTwin4:NewToggle("点击出售木材", "clicksell", false, function(v)
	    getgenv()["点击出售木头"] = v;
		local UserInputService = game:GetService("UserInputService")
		clickSellLog = UserInputService.TouchTap:Connect(function()
			if getgenv()["点击出售木头"] == false then
				if clickSellLog then
					clickSellLog:Disconnect();
					clickSellLog = nil;
					return
				end
				return
			end
			pcall(function()
				spawn(function()
					local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
					local wood = Mouse.Target.Parent;
					local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
					if wood:FindFirstChild("WoodSection") and (wood:FindFirstChild("Owner") and (wood.Owner.Value == DT.LP) or (wood.Owner.Value == nil)) then
						if not wood:FindFirstChild"RootCut" and wood.Parent.Name == "TreeRegion" then
							return library:Notify({
							           Title = "错误!", 
							           Text = "这棵树还没有砍!",
							           Duration = 4
							       })
						end
						DT.LP.Character:MoveTo(wood.WoodSection.CFrame.p);
						for i = 1, 20 do
							DT:DragModel(wood, sell)
							task.wait(0.1)
						end
					end
				end)
			end)
		end)
	end)
	
	local sellAllLog = true;
	
	DTwin4:NewToggle("出售全部木头", "sellallwood", false, function(v)
	    sellAllLog = v;
		local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		for _, v in next, DT.WKSPC.LogModels:GetDescendants() do
			if sellAllLog == false then --> 如果不想买了, 就中断且传送到原来的位置
				DT:Teleport(oldpos);
				return
			end
			if v:FindFirstChild"Owner" then
				if v.Owner.Value == DT.LP or v.Owner.Value == nil then
					pcall(function()
						DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
						for i = 1, 20 do
							DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
							DT:DragModel(v, sell)
							task.wait(0.1)
						end
					end)
				end
			end
		end
		DT:Teleport(oldpos);
	end)
	
	local function teleport(config)
		local config = config or {};
		config.CFrame = config.CFrame or CFrame.new(0, 0, 0);
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = config.CFrame;
	end
	
	DTwin4:NewToggle("点击自动砍树", "clickautocut", false, function(v)
	    _CONFIGS["点击砍树"] = v;
		local Mouse = DT.LP:GetMouse()
		
		local UserInputService = game:GetService("UserInputService")
		_CONFIGS["自动砍树"] = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if _CONFIGS["点击砍树"] == false then
					_CONFIGS["自动砍树"]:Disconnect();
					_CONFIGS["自动砍树"] = nil;
				end
				local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
				local wood = Mouse.Target		
				local height = wood.CFrame:pointToObjectSpace(Mouse.Hit.p).Y + wood.Size.Y/2			
		
				if wood.Name == "WoodSection" then				
					repeat
						cutTree({
							Cutevent = wood.Parent.CutEvent;
							Tool = getAxe(wood.Parent.TreeClass.Value);
							Height = height;
						})
						task.wait()
					until wood:FindFirstChild("Tree Weld") == nil
				end
			end)
		end)
	end)
	
	
	_CONFIGS["处理木头"] = false
	
	
	DTwin4:NewButton("处理木材", function()
	    if getgenv()["点击出售木头"] == true then
	        _CONFIGS["处理木头"] = false
	        return library:Notify({
			           Title = "错误!", 
			           Text = "请先关闭点击出售木头!",
			           Duration = 4
			       })
	    end
		_CONFIGS["处理木头"] = true
		
		local UserInputService = game:GetService("UserInputService")
		library:Notify({
	       Title = "处理树", 
	       Text = "请点击一颗已砍的树, 自动分解",
	       Duration = 4
	   })		      
		getgenv().Test = UserInputService.TouchTap:Connect(function()
			if _CONFIGS["处理木头"] == false then
				if getgenv().Test then
					getgenv().Test:Disconnect();
					getgenv().Test = nil;
				end
				return
			end
			pcall(function()
				local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
				local wood = Mouse.Target.Parent;
				if wood:FindFirstChild("WoodSection") and (wood:FindFirstChild("Owner") and (wood.Owner.Value == DT.LP) or (wood.Owner.Value == nil)) then
					if not wood:FindFirstChild"RootCut" and wood.Parent.Name == "TreeRegion" then
						return library:Notify({
	    		           Title = "错误!", 
	    		           Text = "这棵树还没有砍!",
	    		           Duration = 4
	    		       })
					end
					
					local index = 0;
					_CONFIGS["处理木头"] = false;
					for i, v in pairs(wood:GetDescendants()) do
						if v:FindFirstChild("SelectionBox") then
							v:FindFirstChild("SelectionBox"):Destroy()
						end
						if v.Name == "WoodSection" then
							index = index + 1
							local selection = Instance.new("SelectionBox")
							selection.Parent = v
							selection.Adornee = selection.Parent
							if v:WaitForChild("ID") then
								if v.ID.Value == index then
									DT.LP.Character:MoveTo(v.CFrame.p)
									repeat
										cutTree({
											Cutevent = v.Parent.CutEvent;
											SectionId = v.ID.Value;
											Tool = getAxe(v.Parent.TreeClass.Value);
											Height = v.Size.y;
										})         
										task.wait()
									until v:FindFirstChild("Tree Weld") == nil
									--> warn("砍完", index)
									task.wait()
									if v:FindFirstChild("SelectionBox") then
										v:FindFirstChild("SelectionBox"):Destroy()
									end
								else
									index = index + 1
								end
							end
						end
					end
					task.wait()
					DT:Teleport(oldpos)
				end
			end)
		end)
	end)
	_CONFIGS["处理木头并加工"] = false
	
	DTwin4:NewButton("处理木材并加工", function()
	    if getgenv()["点击出售木头"] == true then
	        return library:Notify({
			           Title = "错误!", 
			           Text = "请先关闭点击出售木头!",
			           Duration = 4
			       })
	    end
		_CONFIGS["处理木头并加工"] = true
		
		local UserInputService = game:GetService("UserInputService")
		library:Notify({
	       Title = "处理树!", 
	       Text = "请点击一颗已砍的树和加工机, 自动分解并加工",
	       Duration = 4
	   })
			       
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		local sawmill = nil;
		local wood = nil;
		getgenv().CutWoodToSawmill = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if _CONFIGS["处理木头并加工"] == false then
					if getgenv().CutWoodToSawmill then
						getgenv().CutWoodToSawmill:Disconnect();
						getgenv().CutWoodToSawmill = nil;
					end
					return
				end
				local model = Mouse.Target.Parent;
				if model:FindFirstChild("Owner") then
					if model.Owner.Value == DT.LP or model.Owner.Value == nil then
						if model:FindFirstChild("WoodSection") then
							if not model:FindFirstChild"RootCut" and model.Parent.Name == "TreeRegion" then
								return DT:NOTIFY("错误!", "这棵树还没有砍!", 4)
							end
							wood = model;
							DT:NOTIFY("处理树", "已选择树", 4)
						end
					end
					if model:FindFirstChild("ItemName") then
						if model.Name:sub(1, 7) == "Sawmill" or model.ItemName.Value:sub(1, 7) == "Sawmill" then
							sawmill = model;
							DT:NOTIFY("处理树", "已选择加工机", 4)
						end
					end
				end
			end)
		end)
		
	-- local UserInputService = game:GetService("UserInputService")
		-- local delta = UserInputService:GetMouseDelta()
		
	
	
		repeat
			task.wait()
		until wood ~= nil and sawmill ~= nil;
		getgenv().CutWoodToSawmill:Disconnect()
		getgenv().CutWoodToSawmill = nil
		local sawCF = sawmill.Particles.CFrame;
		local index = 0;
	
		for i, v in pairs(wood:GetDescendants()) do
			if v:FindFirstChild("SelectionBox") then
				v:FindFirstChild("SelectionBox"):Destroy()
			end
			if v.Name == "WoodSection" then
				index = index + 1
				local selection = Instance.new("SelectionBox")
	                  -->selection.Color3=Color3.new(95,95,95)
				selection.Parent = v
				selection.Adornee = selection.Parent
				if v:WaitForChild("ID") then
					if v.ID.Value == index then
	                     --    DT:Teleport(v.CFrame + Vector3.new(0, 5, 5))
						DT.LP.Character:MoveTo(v.CFrame.p)
						repeat
							cutTree({
								Cutevent = v.Parent.CutEvent;
								SectionId = v.ID.Value;
								Tool = getAxe(v.Parent.TreeClass.Value);
								Height = v.Size.y;
							})         
	                            -- DT.RS.Heartbeat:wait()
							task.wait()
						until v:FindFirstChild("Tree Weld") == nil
	                        --warn("砍完", index)
						task.wait()
						if v:FindFirstChild("SelectionBox") then
							v:FindFirstChild("SelectionBox"):Destroy()
						end
						task.wait(1)
						for i = 1, 20 do
							DT.RS.Heartbeat:wait()
							DT:DragModel(v.Parent, sawCF)
						end
					else
						index = index + 1
					end
				end
			end
			task.wait()
		end
		DT.RS.Heartbeat:wait()
		for _, v in next, DT.WKSPC.LogModels:GetDescendants() do
			if v.Name == wood.Name then
				local ws = {}
				for _, c in next, v:GetChildren() do
					if c.Name == "WoodSection" then
						table.insert(ws, c)
					end
				end
				if # ws == 1 then
					for i = 1, 20 do
						DT.RS.Heartbeat:wait()
						DT:DragModel(v, sawCF)
					end
				end
			end
		end
		DT:NOTIFY("处理树","已完成加工",4)
		task.wait()
		DT:Teleport(oldpos)
	end)
	
	DTwin4:NewSeparator();
	
	plank1x1ByBark = function(v1)
		local v2 = {};
		v2[1] = v1;
		v2[2] = 1 / (v1.Size.x * v1.Size.z);
		if v2[2] < 0.2 then
			v2[2] = 0.3;
		end
		v2[3] = math.floor(v1.Size.y / v2[2]);
		if v2[3] < 1 then
			v2[3] = 0;
		end
		v2[4] = v1.Size.y;
		return v2;
	end
	
	DTwin4:NewButton("木板1x1 测试", function()
	    if getgenv()["点击出售木头"] == true then
	        return DT:NOTIFY("错误","请先关闭点击出售木头",4)
	    end
		getgenv()["木板1x1"] = true	
		local UserInputService = game:GetService("UserInputService")
		DT:NOTIFY("木板1x1", "请点击一块木板, 自动切割一单位", 4)
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		local plank = nil;
		_CONFIGS["cutPlankByDT"] = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if getgenv()["木板1x1"] == false then
					if _CONFIGS["cutPlankByDT"] then
						_CONFIGS["cutPlankByDT"]:Disconnect();
						_CONFIGS["cutPlankByDT"] = nil;
					end
					return
				end
				local model = Mouse.Target.Parent;
				if model.Name == "Plank" then
					if model:FindFirstChild("Owner") then
						if model.Owner.Value == DT.LP or model.Owner.Value == nil then
							if model:FindFirstChild("WoodSection") then
								plank = model.WoodSection;
								DT:NOTIFY("木板1x1", "已选择木板", 4)
							end
						end
					end
				end
			end)
		end)
		
		repeat
			task.wait()
		until plank ~= nil
		_CONFIGS["cutPlankByDT"]:Disconnect();
		_CONFIGS["cutPlankByDT"] = nil;
		local v0 = plank1x1ByBark(plank)
		local v1 = {}
		local v2 = v0[3]
		local v3 = false;
		if v2 == 0 then
			return
		end;
		local v4 = DT.WKSPC.PlayerModels.ChildAdded:Connect(function(model)
			if model:WaitForChild("Owner").Value == DT.LP and model:FindFirstChild'WoodSection' and math.floor(plank1x1ByBark(model.WoodSection)[4]) == math.floor(v0[4] - v0[2]) then
				v3 = true;
				v1 = plank1x1ByBark(model:FindFirstChild'WoodSection')
			end
		end)
		for i, v in pairs(plank.Parent:GetDescendants()) do
			if v:FindFirstChild("SelectionBox") then
				v:FindFirstChild("SelectionBox"):Destroy()
			end
		end
		for i = 1, v0[3] do
			local selection = Instance.new("SelectionBox")
			selection.Parent = v0[1]
			selection.Adornee = selection.Parent
			v3 = false;
			DT.LP.Character:MoveTo(v0[1].CFrame.p)
			repeat
				task.wait()
				cutTree({
					Cutevent = v0[1].Parent.CutEvent;
					Tool = getAxe(v0[1].Parent.TreeClass.Value);
					Height = v0[2];
					FaceVector = Vector3.new(- 1, - 0, - 0);
				})
			until v3 or (i == v0[3] and wait(6)) or v0[1].Size.y <= 2
			if v0[1]:FindFirstChild("SelectionBox") then
				v0[1]:FindFirstChild("SelectionBox"):Destroy()
			end
			v0 = v1
		end
		v4:Disconnect()
	end)
	
	local sellAllPlank = true;
	
	DTwin4:NewToggle("出售全部木板", "sellallplank", false, function(v)
	    sellAllPlank = v;
		local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		for _, v in next, DT.WKSPC.PlayerModels:GetDescendants() do
			if sellAllPlank == false then --> 如果不想卖了, 就中断且传送到原来的位置
				DT:Teleport(oldpos);
				return
			end
			if v:FindFirstChild"Owner" then
				if v.Owner.Value == DT.LP then
					if v.Name == "Plank" and v:FindFirstChild("WoodSection") then
						pcall(function()
							DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
							for i = 1, 25 do
	                             DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
								DT:DragModel(v, sell)
								DT.RS.Heartbeat:wait()
							end
							DT.RS.Heartbeat:wait()
						end)
					end
				end
			end
		end
		DT:Teleport(oldpos);
	end)
	
	
	DTwin4:NewSeparator();
	
	DTwin4:NewToggle("拖拽器", "dragmode", false, function(state)
	    	if state then
			_G.HardDraggerConnection = game.Workspace.ChildAdded:connect(
	            function(a)
				if a.Name == "Dragger" then
					local b = a:WaitForChild("BodyGyro")
					local c = a:WaitForChild("BodyPosition")
					local d = {
						bp_p = c.P,
						bp_d = c.D,
						bp_maxforce = c.maxForce,
						bg_p = b.P,
						bg_d = b.D,
						bg_maxtorque = b.maxTorque,
						color_backup = a.BrickColor
					}
					local e = BrickColor.new("Bright blue")
					a.BrickColor = e
					repeat
						task.wait()
						c.P = 120000
						c.D = 1000
						c.maxForce = Vector3.new(1, 1, 1) * 1000000
						b.maxTorque = Vector3.new(1, 1, 1) * 200
						b.P = 1200
						b.D = 140
					until a.Parent ~= game.Workspace
					c.maxForce = d["bp_maxforce"]
					c.D = d["bp_d"]
					c.P = d["bp_p"]
					b.maxTorque = d["bg_maxtorque"]
					b.P = d["bg_p"]
					b.D = d["bg_d"]
					a.BrickColor = d["color_backup"]
				end
			end)
			if not _G.OrigDrag then
				_G.OrigDrag = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag
				getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag = function(f)
					if _G.OrigDrag(f) == true then
						return true
					end
					local g = game.Players.LocalPlayer.Character
					if not g then
						return
					end
					if g:FindFirstChildOfClass("Tool") then
						return
					end
					if f then
						if f.Parent then
							if 0 <= g.Humanoid.Health and f.Name == "LeafPart" then
								return false
							else
								local h = f
								repeat
									h = h.Parent
								until h.Parent.Name == "PlayerModels" or h.Parent == game.Workspace or h.Parent == game or h.Parent.Name == "LogModels"
								if h.Parent.Name == "PlayerModels" or h.Parent.Name == "LogModels" then
								end
							end
						end
					end
					return false
				end
			end
		else
			_G.HardDraggerConnection:Disconnect()
			_G.HardDraggerConnection = nil
			getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag = _G.OrigDrag
			_G.OrigDrag = nil
		end
	end)
	
	DTwin4:NewToggle("查看幻影木", "viewendtimetree", false, function(state)
	    	if state then
			local wood
			for i, v in next, DT.WKSPC:children() do
				if v.Name == "TreeRegion" then
					for l, k in next, v:children() do
						if k:FindFirstChild"TreeClass" then
							if k.TreeClass.Value == "LoneCave" then
								wood = k
							end
						end
					end
				end
			end
			if wood == nil then
				return DT:NOTIFY("错误!", "幻影木已被别人摧毁(其他外挂)", 4)
			end
			local woodpart
			for i, v in next, wood:children() do
				if v.Name == "WoodSection" and v:FindFirstChild"ID" and v:FindFirstChild"ID".Value == tonumber(1) then
					woodpart = v
				end
			end
			DT.WKSPC.Camera.CameraSubject = woodpart
		else
			DT.WKSPC.Camera.CameraSubject = DT.LP.Character
		end
	end)
	
	function hahafunnygod()
	  local rootjoint = DT.LP.Character.HumanoidRootPart.RootJoint
	  rootjoint:Clone().Parent = rootjoint.Parent
	  rootjoint:Destroy()
	  task.wait()
	end
	
	
	
	
	
	DTwin4:NewButton("无眼球砍幻影", function(bool)
		local wood = nil
		local oldpos = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame;
		
		for i, v in next, DT.WKSPC:children() do
			if v.Name == "TreeRegion" then
				for l, k in next, v:children() do
					if k:FindFirstChild"TreeClass" then
						if k.TreeClass.Value == "LoneCave" then
							wood = k
						end
					end
				end
			end
		end
		
		
		if wood == nil then
			return DT:NOTIFY("错误!", "幻影木没有了", 4)
		end
		togggleInvisible(1)
		hahafunnygod()
			
	    	local woodPart;
	    	for _, v in next, wood:GetDescendants() do
	    		if v.Name == "WoodSection" then
	    			if v:FindFirstChild("ID") and v.ID.Value == 1 then
	    				woodPart = v
	    			end
	    		end
	    	end
	    	repeat
	    		task.wait()
	    		DT:Teleport(woodPart.CFrame + Vector3.new(0, 3, 3));
	    		cutTree({
	    			Cutevent = wood.CutEvent;
	    			Tool = getAxe(wood.TreeClass.Value);
	    			Height = 0.3;
	    		})
	    	until wood:FindFirstChild("RootCut")
	    	local Log
	    	for s, b in next, DT.WKSPC.LogModels:GetDescendants() do
	    		if b:FindFirstChild"Owner" and b.Owner.Value == DT.LP then
	    			Log = b
	    		end
	    	end
	    	task.wait(0.15)
	        task.spawn(function()
	            for cooper=1, 60 do
	                DT.RES.Interaction.ClientIsDragging:FireServer(Log)
	                task.wait()
	            end
	        end)
	      task.wait(0.1)
	      Log.PrimaryPart = Log.WoodSection
	      for i=1, 60 do
	        Log.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
	        Log:PivotTo(oldpos)
	        task.wait()
	      end
	      task.wait()
	      DT.LP.Character.Head:Destroy()
	      DT.LP.CharacterAdded:Wait()
	      task.wait(1.5)
	      DT.LP.Character.HumanoidRootPart.CFrame = Log.WoodSection.CFrame
	end)
	
	
	
	local WoodTP = {
	    "火山",
	    "蓝木",
	    "雪光木",
	    "冰木",
	    "僵尸木",
	    "橡木",
	    "樱桃木",
	    "白桦木",
	    "棕树",
	    "雪松",
	    "幻影木",
	    "椰子树",
	    "胡桃木"
	}
	local StoreTP = {
	    "木材反斗城",
	    "土地商店",
	    "盒子车行",
	    "家具店",
	    "鲍勃沙克",
	    "艺术品商店",
	    "连接逻辑店",
	    "建筑大师"
	}
	local OtherTP = {
	    "生成地",
	    "汽车杀人",
	    "小绿盒",
	    "小鸟斧",
	    "桥",
	    "幻影木出口",
	    "木材出售地",
	    "鲨鱼斧",
	    "灯塔",
	    "英灵神殿",
	    "火山秘密基地"
	}
	
	DTwin5:NewDropdown("商店地点", "shop_tp", StoreTP, function(new)
	    StoreTP = new;
	end)
	
	DTwin5:NewButton("传送!", function()
	    if type(StoreTP) == "table" then
	        DT:NOTIFY("错误!", "请先选择地点!", 4)
	        return
	    end
	    if StoreTP == "木材反斗城" then
	        DT:TP(273, 3, 56)
	    end
	    if StoreTP == "土地商店" then
	        DT:TP(294, 3, -100)
	    end
	    if StoreTP == "盒子车行" then
	        DT:TP(510, 3, -1445)
	    end
	    if StoreTP == "家具店" then
	        DT:TP(497, 3, -1747)
	    end
	    if StoreTP == "鲍勃沙克" then
	        DT:TP(260, 8, -2542)
	    end
	    if StoreTP == "艺术品商店" then
	        DT:TP(5251, -166, 719)
	    end
	    if StoreTP == "连接逻辑店" then
	        DT:TP(4608, 7, -809)
	    end
	    if StoreTP == "建筑大师" then
	        DT:TP(1060, 17, 1131)
	    end
	end)
	
	DTwin5:NewSeparator();
	
	DTwin5:NewDropdown("木材地点", "wood_tp", WoodTP, function(new)
	    WoodTP = new;
	end)
	
	DTwin5:NewButton("传送!", function()
	    if type(WoodTP) == "table" then
	        DT:NOTIFY("错误!", "请先选择地点!", 4)
	        return
	    end
	    if WoodTP == "火山" then
	        DT:TP(-1613, 623, 1082)
	    end
	    if WoodTP == "蓝木" then
	        DT:TP(3515, -195, 426)
	    end
	    if WoodTP == "雪光木" then
	        DT:TP(-1135, 1, -945)
	    end
	    if WoodTP == "冰木" then
	        DT:TP(1461, 412, 3228)
	    end
	    if WoodTP == "僵尸木" then
	        DT:TP(-1054, 132, -1177)
	    end
	    if WoodTP == "橡木" then
	        DT:TP(-126, 3, -1702)
	    end
	    if WoodTP == "白桦木" then
	        DT:TP(-601, 275, 1174)
	    end
	    if WoodTP == "棕树" then
	        DT:TP(4782, 4, -682)
	    end
	    if WoodTP == "雪松" then
	        DT:TP(1263, 81, 1985)
	    end
	    if WoodTP == "幻影木" then
	        DT:TP(-59, -207, -1334)
	    end
	    if WoodTP == "椰子树" then
	        DT:TP(4330, -6, -1841)
	    end
	    if WoodTP == "胡桃木" then
	        DT:TP(348, 3, -1536)
	    end
	    if WoodTP == "樱桃木" then
	        DT:TP(111, 60, 1233)
	    end
	end)
	
	DTwin5:NewSeparator();
	
	DTwin5:NewDropdown("其他地点", "other_tp", OtherTP, function(new)
	    OtherTP = new;
	end)
	
	DTwin5:NewButton("传送!", function()
	    if type(OtherTP) == "table" then
	        DT:NOTIFY("错误!", "请先选择地点!", 4)
	        return
	    end
	    if OtherTP == "生成地" then
	        DT:TP(155, 3, 74)
	    end
	    if OtherTP == "小绿盒" then
	        DT:TP(-1668, 350, 1475)
	    end
	    if OtherTP == "小鸟斧" then
	        DT:TP(4797, 19, -983)
	    end
	    if OtherTP == "桥" then
	        DT:TP(134, 5, -608)
	    end
	    if OtherTP == "幻影木出口" then
	        DT:TP(-586, 74, -1414)
	    end
	    if OtherTP == "木材出售地" then
	        DT:TP(307, -3, 105)
	    end
	    if OtherTP == "鲨鱼斧" then
	        DT:TP(324, 46, 1923)
	    end
	    if OtherTP == "灯塔" then
	        DT:TP(1454, 375, 3257)
	    end
	    if OtherTP == "英灵神殿" then
	        DT:TP(-1618, 195, 938)
	    end
	    if OtherTP == "火山秘密基地" then
	        DT:TP(-1432, 444, 1185)
	    end
	    if OtherTP == "汽车杀人" then
	        DT:TP(-1636, 198, 1296)
	    end
	end)
	
	DTwin5:NewSeparator();
	
	getgenv()["玩家们"] = {}
	
	for _, v in next, DT.GS("Players"):GetPlayers() do
	    table.insert(getgenv()["玩家们"], v.Name)
	end
	
	DTwin5:NewDropdown("选择玩家", "player_tp", getgenv()["玩家们"], function(plr)
	    getgenv()["玩家们"] = plr;
	end)
	
	DTwin5:NewButton("传送到玩家身边!", function() 
	    if type(getgenv()["玩家们"]) == "table" then
	        return DT:NOTIFY("错误", "请先选择玩家", 4)
	    end
	    DT:Teleport(DT.GS("Players")[tostring(getgenv()["玩家们"])].Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
	end)
	
	DTwin5:NewButton("传送到玩家基地!", function() 
	    if type(getgenv()["玩家们"]) == "table" then
	        return DT:NOTIFY("错误", "请先选择玩家", 4)
	    end
	    
	    for i, v in next, DT.WKSPC.Properties:GetChildren() do
	        if v:FindFirstChild("Owner") and v.Owner.Value == DT.GS("Players")[tostring(getgenv()["玩家们"])] then
	            DT:Teleport(v.OriginSquare.CFrame + Vector3.new(0, 5, 0))
	        end
	    end
	end)
	
	DTwin5:NewToggle("查看玩家", "viewPlayer", false, function(state)
	    if state then
	        if type(getgenv()["玩家们"]) == "table" then
	            return DT:NOTIFY("错误", "请先选择玩家", 4)
	        end
	        DT:NOTIFY("正在观察", tostring(DT.GS("Players")[tostring(getgenv()["玩家们"])].Name), 4)
	        DT.WKSPC.Camera.CameraSubject = DT.GS("Players")[tostring(getgenv()["玩家们"])].Character
	    else
	        DT.WKSPC.Camera.CameraSubject = DT.LP.Character
	    end
	end)
	
	DTwin5:NewToggle("查看玩家基地", "viewPlayerBase", false, function(state)
	    if state then
	        for i, v in next, DT.WKSPC.Properties:GetChildren() do
	            if v:FindFirstChild("Owner") and v.Owner.Value == DT.GS("Players")[tostring(getgenv()["玩家们"])] then
	            DT.WKSPC.Camera.CameraSubject = v.OriginSquare
	            DT:NOTIFY("正在观察", tostring(DT.GS("Players")[tostring(getgenv()["玩家们"])].Name.."的基地"), 4)
	            end
	        end    
	    else
	        DT.WKSPC.Camera.CameraSubject = DT.LP.Character
	    end
	end)
	
	DT.GS("Players").PlayerRemoving:Connect(function(player)  
	    if getgenv()["玩家们"] ~= nil and #getgenv()["玩家们"] >= 1 then
	        pcall(table.remove, getgenv()["玩家们"], table.find(player.Name))
	        
	        plr:refresh(getgenv()["玩家们"])
	        library.flags["player_tp1"]:RemoveOption(player.Name)
	    end
	    DT:NOTIFY("玩家离开", ("%s离开了服务器"):format(player.Name), 4);
	end)
	
	DT.GS("Players").PlayerAdded:Connect(function(player)
	    if getgenv()["玩家们"] ~= nil and #getgenv()["玩家们"] >= 1 then
	        if not table.find(getgenv()["玩家们"], tostring(player.Name)) then
	            table.insert(getgenv()["玩家们"], player.Name);
	        end        
	        library.flags["player_tp"]:AddOption(player.Name)
	    end
	    DT:NOTIFY("玩家加入", ("%s加入了服务器"):format(player.Name), 4);
	end)
	
	DTwin5:NewSeparator();
	
	DTwin5:NewButton("设置位置!", function() 
	        if DT.WKSPC:FindFirstChild("IIIII") then
	            DT.WKSPC.IIIII:Destroy()
	        end
	        p = Instance.new("Part", DT.WKSPC)
	        p.Name = "IIIII"
	        p.Transparency = 1
	        p.Anchored = true
	        p.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	        p.CanCollide = false
	        p.Size = game.Players.LocalPlayer.Character.HumanoidRootPart.Size
	        
	    local posBox = Instance.new("SelectionBox", p)
	    posBox.Name = "posBox"
	    posBox.Color3=Color3.new(255, 255, 255)
	    posBox.Adornee = posBox.Parent
	end)
	
	DTwin5:NewButton("删除位置!", function() 
	    if DT.WKSPC:FindFirstChild("IIIII") then
	        DT.WKSPC.IIIII:Destroy()
	    end
	end)
	
	DTwin5:NewButton("传送!", function() 
	    if DT.WKSPC:FindFirstChild("IIIII") then
	        DT:Teleport(DT.WKSPC.IIIII.CFrame)
	    end
	end)
	
	
	DayOfNight = DT.LIGHT.Changed:Connect(function()
	    if Day then
	        DT.LIGHT.TimeOfDay = "11:30:00"
	    end
	
	    if Night then
	        DT.LIGHT.TimeOfDay = "24:00:00"
	    end
	
	    if NoFog then
	        DT.LIGHT.FogEnd = math.huge
	    end
	end)
	
	DTwin6:NewToggle("白天", "day", true, function(state)
	    Day = state;
	end)
	
	DTwin6:NewToggle("黑夜", "night", false, function(state)
	    Night = state;
	end)
	
	DTwin6:NewToggle("删除雾", "nofog", true, function(state)
	    NoFog = state;
	end)
	
	DTwin6:NewToggle("万圣节", "wsj", false, function(state)
	    DT.LIGHT.Spook.Value = state;
	end)
	
	DTwin6:NewToggle("阴影", "shadow", false, function(state)
	    DT.LIGHT.GlobalShadows = state;
	end)
	
	DTwin6:NewSlider("场景亮度", "bring", 2, 0, 10, false, function(v)
	    DT.LIGHT.Brightness = v
	end)
	
	DTwin6:NewSeparator();
	
	DTwin6:NewToggle("删除水", "deletewater", false, function(state)
	    local water = {}
	    if state then
	        for _, v in next, DT.WKSPC.Water:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 1
	    			v.CanCollide = false
	    		end
	        end
	        for _, v in next, DT.WKSPC.Bridge.VerticalLiftBridge.WaterModel:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 1
	    			v.CanCollide = false
	    		end
	    	end
	 
	    else
	        for _, v in next, DT.WKSPC.Water:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 0
	    			v.CanCollide = false
	    		end
	        end
	        for _, v in next, DT.WKSPC.Bridge.VerticalLiftBridge.WaterModel:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 0
	    			v.CanCollide = false
	    		end
	    	end
	    end
	end)
	
	DTwin6:NewToggle("删除岩浆", "deleteLava", false, function(state)
	    if not state then
	        for i,v in next, DT.LIGHT:GetChildren() do
	            if v.Name == "Lava" then
	                v.Parent = DT.WKSPC.Region_Volcano
	                DT.WKSPC.Region_Volcano.BasePlate:Destroy()
	            end
	        end
	    else
	        for i,v in next, DT.WKSPC.Region_Volcano:GetChildren() do
	            if v.Name == "Lava" then
	                local bp = v.BasePlate:Clone()
	                bp.Parent = DT.WKSPC.Region_Volcano
	                bp:ClearAllChildren()
	                bp.CanCollide = true
	                bp.BrickColor = DT.WKSPC.Region_Volcano.Slate.BrickColor
	                bp.Material = DT.WKSPC.Region_Volcano.Slate.Material
	                v.Parent = DT.LIGHT
	            end
	        end
	    end
	end)
	
	DTwin6:NewToggle("删除火山巨石", "deleteBoulder", false, function(state)
	    if state then
	        for i,v in next, DT.WKSPC.Region_Volcano.PartSpawner:GetChildren() do
	            if v.Name == "VolcanoBoulder" then
	                v.Parent = DT.LIGHT
	            end
	        end
	    else
	        for i,v in next, DT.LIGHT:GetChildren() do
	            if v.Name == "VolcanoBoulder" then
	                v.Parent = DT.WKSPC.Region_Volcano.PartSpawner
	            end
	        end
	    end
	end)
	
	DTwin6:NewToggle("删除雪山石头", "deleteSnow", false, function(state)
	    if state then
	        for i,v in next, DT.WKSPC.Region_Snow:GetChildren() do
	            if v.Name == "PartSpawner" then
	                v.Parent = DT.LIGHT
	            end
	        end
	    else
	        for i,v in next, DT.LIGHT:GetChildren() do
	            if v.Name == "PartSpawner" then
	                v.Parent = DT.WKSPC.Region_Snow
	            end
	        end
	    end
	end)
	
	DTwin6:NewToggle("删除鲨鱼斧入口", "deleteDenHatch", false, function(state)
	    if state then
	        for i,v in next, DT.WKSPC.Region_Snow.Den:GetChildren() do
	            if v.Name == "DenHatch" then
	                v.Parent = DT.LIGHT
	            end
	        end
	    else
	        for i,v in next, DT.LIGHT:GetChildren() do
	            if v.Name == "DenHatch" then
	                v.Parent = DT.WKSPC.Region_Snow.Den
	            end
	        end
	    end
	end)
	
	function DT:FreeLand()
	    local base
	    local oldtime = tick();
	    for _, v in next, DT.WKSPC.Properties:GetChildren() do 
	        if v:FindFirstChild("Owner") and v:FindFirstChild("OriginSquare") and v.Owner.Value == nil then 
	            DT.RES.PropertyPurchasing.ClientPurchasedProperty:FireServer(v, v.OriginSquare.OriginCFrame.Value.p + Vector3.new(0,3,0))
	       
	            wait(0.5)
	            Instance.new('RemoteEvent', DT.RES.Interaction).Name = "Ban";
	            break
	        end
	    end            
	    	for _ ,v in next, DT.WKSPC.Properties:GetChildren() do
	    		if v.Owner.Value == DT.LP then
	    		    DT:Teleport(v.OriginSquare.CFrame + Vector3.new(0,10,0));
	    		    break;
	    		end
	    	end
	    DT:NOTIFY("完成", ("耗时%.3f秒"):format(tick() - oldtime), 4);
	end
	
	
	DTwin7:NewButton("免费土地", function() 
	    DT:FreeLand()
	end)
	
	DTwin7:NewButton("出售土地牌子", function() 
	    local oldtime = tick();
	    local oldpos = DT.LP.Character.HumanoidRootPart.CFrame;
	    local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
	    
	    for _, v in next, DT.WKSPC.PlayerModels:GetChildren() do
	        if v.Name == "Model" and v:FindFirstChild("Owner") then
	            if v.Owner.Value == DT.LP then
	                DT:Teleport(v:FindFirstChildOfClass("Part").CFrame)
	                task.wait()
	                DT.RES.Interaction.ClientInteracted:FireServer(v, "Take down sold sign")
	                task.wait()
	                for i=1, 25 do
	                    DT:DragModel(v, sell)
	                    task.wait()
	                end
	                break;
	            end
	        end
	    end
	    DT:NOTIFY("完成", ("耗时%.3f秒"):format(tick() - oldtime), 4);
	    DT:Teleport(oldpos)
	end)
	
	
	maxland = function()
	    local oldtime = tick();
	    for i, v in pairs(game:GetService("Workspace").Properties:GetChildren()) do
	        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
	            base = v
	            square = v.OriginSquare
	            break;
	        end
	    end
	    function makebase(pos)
	        local Event = game:GetService("ReplicatedStorage").PropertyPurchasing.ClientExpandedProperty
	        Event:FireServer(base, pos)
	    end
	    spos = square.Position
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z - 80))
	--Corners--
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z - 80))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z - 80))
	--Corners--
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z - 80))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z - 80))
	    DT:NOTIFY("完成", ("耗时%.3f秒"):format(tick() - oldtime), 4);
	end
	
	DTwin7:NewButton("最大土地", function() 
	    maxland()
	end)
	
	DTwin7:NewSeparator();
	
	function cooperAxeDupe()
	            -- get cooper
	    local cooper = game.Players.LocalPlayer
	    
	    -- can relod functin
	    local canRelod = function()
	        -- This script was generated by coopers's RemoteSpy: https://github.com/Upbolt/Hydroxide
	    
	    local ohInstance1 = cooper
        DT:TP(273, -350, -98)
	    wait(2)
	    return 
	    game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(ohInstance1)
	    end
	    
	    -- dup ax
	    function dupAx()
	        if cooper.CurrentSaveSlot.Value == -1 then
	            return DT:NOTIFY("错误","请加载存档",4)
	        elseif cooper.CurrentSaveSlot.Value ~= -1 then
	            if not canRelod() then
	                DT:NOTIFY("复制斧头","冷却时间请等待",4)
	            end
	            repeat
	                task.wait()
	            until canRelod()
	            -- This script was generated by coopers's RemoteSpy: https://github.com/Upbolt/Hydroxide
	    local ohNumber1 = cooper.CurrentSaveSlot.Value
	    local ohInstance2 = cooper
	    
	    task.spawn(function()
	        game:GetService("ReplicatedStorage").LoadSaveRequests.RequestLoad:InvokeServer(ohNumber1, ohInstance2)
	    end)
	        task.wait()
	        DT:NOTIFY("复制斧头","复制中...",4)
	        return true
	        end
	    end
	    dupAx()
	end
	
	DTwin7:NewButton("复制斧头", function() 
	    cooperAxeDupe()
	end)
	
	
	getgenv().loopDupe = false;
	
	DTwin7:NewToggle("循环复制斧头", "loopdupeAxe", false, function(state)
	    getgenv().loopDupe = state;
	    while getgenv().loopDupe == true do
	        cooperAxeDupe()
	        task.wait()
	    end
	end)
	
	DTwin7:NewSeparator();
	
	DTwin7:NewButton("复制基地  需要朋友", function()
	    local item, c = DT.WKSPC.PlayerModels.ChildAdded:Connect(function(v)
	        if v:WaitForChild("Owner") and v.Owner.Value == DT.LP then
	            game:Shutdown();
	        end
	    end)
	    DT.RES.LoadSaveRequests.RequestLoad:InvokeServer(3, DT.LP);
	end)
	
	DTwin7:NewSeparator();
	
	_CONFIGS["填充工具"] = false;
	
	
	DTwin7:NewToggle("木板填充蓝图", "planktoblueprint", false, function(state)
	       if getgenv()["点击出售木头"] == true then
	        return DT:NOTIFY("错误","请先关闭点击出售木头",4)
	    end
		_CONFIGS["填充工具"] = state
		
		while _CONFIGS["填充工具"]  == true do
		
		local UserInputService = game:GetService("UserInputService")
		DT:NOTIFY("填充蓝图", "请点击一个蓝图和木板, 填充到蓝图", 4)
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		local bp = nil;
		local plank = nil;
		getgenv().PlankToBp = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if _CONFIGS["填充工具"] == false then
					if getgenv().PlankToBp then
						getgenv().PlankToBp:Disconnect();
						getgenv().PlankToBp = nil;
					end
					return
				end
				local model = Mouse.Target.Parent;
				if model:FindFirstChild("Owner") then
					if model.Owner.Value == DT.LP or model.Owner.Value == nil then
					    if model.Name == "Plank" then
	    					if model:FindFirstChild("WoodSection") then   					
	    						plank = model;
	    						local v1 = Instance.new("BoxHandleAdornment", plank.WoodSection)
	    						
	    						local selection = Instance.new("SelectionBox")
			                    selection.Parent = plank.WoodSection
			                    selection.Adornee = selection.Parent
			                    selection.Name = "Selection"
	                            
	    						DT:NOTIFY("填充蓝图", "已选择木板", 4)
	    					end
	    		        end
					end
					if model:FindFirstChild("Type") and model.Type.Value == "Blueprint" then
						bp = model;
						
						local selection = Instance.new("SelectionBox")
	                    selection.Parent = bp.BuildDependentWood
	                    selection.Adornee = selection.Parent
	                    selection.Name = "Selection"
			             
	                    
						DT:NOTIFY("填充蓝图", "已选择蓝图", 4)
					end
				end
			end)
		end)
		
		
		repeat
			task.wait()
		until plank ~= nil and bp ~= nil;
		getgenv().PlankToBp:Disconnect()
		getgenv().PlankToBp = nil
		
		
	    DT.LP.Character:MoveTo(plank.WoodSection.Position)
	    for i=1, 25 do
	        DT:DragModel(plank, bp.Main.CFrame)
	        task.wait()
	    end    
	    plank.WoodSection.Selection:Destroy()
	    bp.BuildDependentWood.Selection:Destroy()
	    DT:Teleport(oldpos)
	    task.wait()
	    end
	end)
	
	DTwin7:NewSeparator();
	
	DTwin7:NewButton("设置位置!", function() 
	    if DT.WKSPC:FindFirstChild("BRING") then
	        DT.WKSPC.BRING:Destroy()
	    end
	    p = Instance.new("Part", DT.WKSPC)
	    p.Name = "BRING"
	    p.Transparency = 1
	    p.Anchored = true
	    p.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	    p.CanCollide = false
	    p.Size = game.Players.LocalPlayer.Character.HumanoidRootPart.Size
	        
	    local posBox = Instance.new("SelectionBox", p)
	    posBox.Name = "BRINGBOX"
	    posBox.Color3=Color3.new(0, 255, 0)
	    posBox.Adornee = posBox.Parent
	end)
	
	DTwin7:NewButton("删除位置!", function() 
	    if DT.WKSPC:FindFirstChild("BRING") then
	        DT.WKSPC.BRING:Destroy()
	    end
	end)
	
	DTwin7:NewButton("获取传送工具!", function() 
	    if DT.LP.Backpack:FindFirstChild"点击传送任何物品" or DT.LP.Character:FindFirstChild"点击传送任何物品" then
		DT.LP.Backpack["点击传送任何物品"]:Destroy()
	    end;
	    local a = Instance.new("Tool", DT.LP.Backpack)
	    a.Name = "点击传送任何物品"
	    a.RequiresHandle = false;
	    a.Activated:Connect(function()
	    	if DT.WKSPC:FindFirstChild("BRING") then
	    		local b = DT.WKSPC.BRING.CFrame;
	    		local c = Mouse.Target.Parent;
	    		if not c:FindFirstChild"RootCut" and c.Parent.Name == "TreeRegion" then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Blueprint" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Vehicle Spot" then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Furniture" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Wire" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Structure" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("TreeClass") or c.Name == "Plank" or c:FindFirstChild("Type") then
	    			local d = DT.LP.Character.HumanoidRootPart.CFrame;
	    			if c:FindFirstChild"Owner" then
	    				local e = c:FindFirstChildOfClass("Part")
	    				pcall(function()
	    					DT.LP.Character:MoveTo(e.CFrame.p)
	    				end)
	    				c.PrimaryPart = e;
	    				for f = 1, 60 do
	    					c.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
	    					DT.RES.Interaction.ClientIsDragging:FireServer(c)
	    					c:PivotTo(b)
	    					task.wait(0.01)
	    				end
	    			end
	    		else
	    			return
	    		end
	    	end
	    end)
	end)
	
	
	DTwin8:NewSlider("汽车速度", "carSpeedSlider", 1, 0, 10, false, function(v)
	    if DT.LP.Character.Humanoid.SeatPart ~= nil then
	    	local Vehicle = DT.LP.Character.Humanoid.SeatPart.Parent
	        if not Vehicle then
	            return
	        end
	      Vehicle.Configuration:FindFirstChild'MaxSpeed'.Value = v;
	    end
	end)
	
	DTwin8:NewButton("翻转汽车", function() 
	    if DT.LP.Character.Humanoid.SeatPart ~= nil then
	        cf = DT.LP.Character.HumanoidRootPart.CFrame * CFrame.fromEulerAnglesXYZ(90, 0, 0)
	        local plr = DT.LP
	        local plrc = plr.Character
	        local mdl = plrc.Humanoid.SeatPart.Parent
	        if plrc.Humanoid.SeatPart.Name ~= "DriveSeat" then return end
	        if (cf.p-plrc.HumanoidRootPart.CFrame.p).Magnitude >= 175 then
	            local ocf = mdl.PrimaryPart.CFrame + Vector3.new(0,5,0)
	            local intensity = 20
	            if mdl.Seat:FindFirstChild'SeatWeld' then intensity = 30 end
	            local rotmag = intensity
	            for i = 1,intensity do
	                rotmag = rotmag * 1.05
	                DT.RS.RenderStepped:wait()
	                mdl:SetPrimaryPartCFrame(ocf*CFrame.Angles(0, math.rad(rotmag*i), 0))
	            end
	            for i=1,0.8*intensity do
	                DT.RS.RenderStepped:wait()
	                mdl:SetPrimaryPartCFrame(cf)
	            end
	        else
	            mdl:SetPrimaryPartCFrame(cf)
	        end
	    end
	end)
	
	DTwin8:NewSeparator();
	
	_CONFIGS["刷粉车"] = false;
	
	
	local CAR = nil
	local FP = nil
	
	DT.WKSPC.PlayerModels.ChildAdded:connect(function(v) if v:WaitForChild("Owner") then
	    if v.Owner.Value == DT.LP then
	        if v:WaitForChild("PaintParts") then
	            FP = v.PaintParts.Part
	        end
	    end
	  end
	end)
	
	
	DTwin8:NewButton("开始!", function() 
	    _CONFIGS["刷粉车"] = true
	    local UserInputService = game:GetService("UserInputService")
		DT:NOTIFY("刷粉车", "请点击一个车位, 自动刷粉车", 4)
		local carSpawn = nil
		
		_CONFIGS["粉车器"] = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if _CONFIGS["刷粉车"] == false then
					if _CONFIGS["粉车器"] then
						_CONFIGS["粉车器"]:Disconnect();
						_CONFIGS["粉车器"] = nil;
					end
					return
				end
				local model = Mouse.Target.Parent;
	             if model:FindFirstChild("Type") then
	                 if model.Type.Value == "Vehicle Spot" then
	                     carSpawn = model.ButtonRemote_SpawnButton;
	                     DT:NOTIFY("刷粉车", "车位已选择", 4)
	                     local selection = Instance.new("SelectionBox")
	                     selection.Parent = model.Main
	                     selection.Adornee = selection.Parent
	                    selection.Name = "CarSpawnS"
	                 end
	             end
	        end)
	    end)
	    repeat task.wait()
	    until carSpawn ~= nil
	    _CONFIGS["粉车器"]:Disconnect();
		_CONFIGS["粉车器"] = nil;
	    repeat
	        task.wait(0.5)
			DT.RES.Interaction.RemoteProxy:FireServer(carSpawn)
			repeat wait() until FP ~= CAR
			CAR = FP
		until  FP.BrickColor.Name == "Hot pink"
		DT:NOTIFY("刷粉车","已完成",4)
		carSpawn.Parent.Main:FindFirstChild("CarSpawnS"):Destroy()
	end)

local gs = function(service)
    return game:GetService(service)
end

local lp = gs("Players").LocalPlayer
local pos = lp.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
local ME = game.Players.LocalPlayer.Character.HumanoidRootPart
local Mouse = game:GetService('Players').LocalPlayer:GetMouse()
local CurrentSlot = game.Players.LocalPlayer:WaitForChild("CurrentSaveSlot").Value
local ScriptLoadOrSave = false
local CurrentlySavingOrLoading = game.Players.LocalPlayer:WaitForChild("CurrentlySavingOrLoading")
local mouse = game.Players.LocalPlayer:GetMouse()
local DT = {
    axedupe = false,
    soltnumber = "1",
    waterwalk = false,
    awaysday = false,
    awaysdnight = false,
    nofog = false,
    axeflying = false,
    playernamedied = "",
    tptree = "",
    moneyaoumt = 1,
    moneytoplayername = "",
    donationRecipient = tostring(game.Players.LocalPlayer),
    autodropae = false,
    farAxeEquip = nil,
    cuttreeselect = "Generic",
    autofarm = false,
    PlankToBlueprint = nil,
    plankModel = nil,
    blueprintModel = nil,
    saymege = "",
    autosay = false,
    saymount = 1,
    sayfast = false,
    autofarm1 = false,
    bringamount = 1,
    bringtree = false,
    dxmz = "",
    color = 0,
    0,
    0,
    zlwjia = "",
    mtwjia = nil,
    zix = 1,
    zlz = 3,
    axeFling = nil,
    itemtoopen = "",
    openItem = nil,
    car = nil,
    load = false,
    autobuyamount = 1,
    autopick = false,
    loaddupeaxewaittime = 3.1,
    walkspeed = 16,
    JumpPower = 50,
    pickupaxeamount = 1,
    whthmose = false,
    itemset = nil,
    LoneCaveAxeDetection = nil,
    cuttree = false,
    LoneCaveCharacterAddedDetection = nil,
    LoneCaveDeathDetection = nil,
    lovecavecutcframe = nil,
    lovecavepast = nil,
    zlmt = nil,
    shuzhe = false,
    modwood = false,
    tchonmt = nil,
    cskais = false,
    dledetree = false,
    delereeset = nil,
    treecutset = nil,
    autobuyset = nil,
    wood = 7,
    cswjia = nil,
    boxOpenConnection = nil,
    autobuystop = flase,
    dropdown = {},
    autocsdx = nil,
    kuangxiu = nil,
    xzemuban = false,
    daiwp = false,
    stopcar = false
}
spawn(function()
    while task.wait() do
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.Text = "道庭付费脚本"
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.TextColor3 =
            Color3.fromRGB(255, 0, 0)
        wait(1)
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.Text =
            "道庭脚本"
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.TextColor3 =
            Color3.fromRGB(255, 0, 0)
        wait(1)
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.Text =
            "道庭脚本"
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.TextColor3 =
            Color3.fromRGB(255, 0, 0)
        wait(1)
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.Text = "道庭脚本"
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.TextColor3 =
            Color3.fromRGB(255, 0, 0)
        wait(1)
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.Text = "作者锋芒阿康"
        game:GetService("Workspace").Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.TextColor3 =
            Color3.fromRGB(255, 0, 0)
        wait(1)
    end
end)
game:GetService("Workspace").Stores.WoodRUs.Parts.OPEN24HOURS.SurfaceGui.TextLabel.Text = "作者: 锋芒阿康";
game:GetService("Workspace").Stores.WoodRUs.Parts.OPEN24HOURS.SurfaceGui.TextLabel.TextColor3 =
    Color3.fromRGB(255, 0, 0)
game:GetService("Workspace").Stores.WoodRUs.Parts.SELLWOOD.SurfaceGui.TextLabel.Text = "作者: 锋芒阿康";
game:GetService("Workspace").Stores.WoodRUs.Parts.SELLWOOD.SurfaceGui.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
game:GetService("Workspace").Stores.WoodRUs.Parts.WOODDROPOFF.SurfaceGui.TextLabel.Text = "感谢使用道庭";
game:GetService("Workspace").Stores.WoodRUs.Parts.WOODDROPOFF.SurfaceGui.TextLabel.TextColor3 =
    Color3.fromRGB(255, 0, 0)
    
local Player = game.Players.LocalPlayer

local function droptool(Position)
    local aQ = game.Players.LocalPlayer.Character;
    if aQ:FindFirstChildOfClass "Tool" then
        local y = aQ:FindFirstChildOfClass "Tool"
        if y:FindFirstChild("ToolName") then
            game.ReplicatedStorage.Interaction.ClientInteracted:FireServer(b, "Drop tool", Position or
                game.Players.LocalPlayer.Character.Head.CFrame)

        end
    end
    for a, b in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if b.Name == "Tool" and b.ClassName == "Tool" then
            game.ReplicatedStorage.Interaction.ClientInteracted:FireServer(b, "Drop tool", Position or
                game.Players.LocalPlayer.Character.Head.CFrame)
        end
    end
end
local function gplr(String)
    local Found = {}
    local strl = String:lower()
    if strl == "all" then
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            table.insert(Found, v)
        end
    elseif strl == "others" then
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= lp.Name then
                table.insert(Found, v)
            end
        end
    elseif strl == "me" then
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name == lp.Name then
                table.insert(Found, v)
            end
        end
    else
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name:lower():sub(1, #String) == String:lower() then
                table.insert(Found, v)
            end
        end
    end
    return Found
end

function tools(plr)
    if plr:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass('Tool') or
        plr.Character:FindFirstChildOfClass('Tool') then
        return true
    end
end
local a = game:GetService("Workspace")
local b = game:GetService("ReplicatedStorage")
local c = game:GetService("Players").LocalPlayer
DragModel = function(...)
    local d = {...}
    pcall(function()
        game:GetService("ReplicatedStorage")
        b.Interaction.ClientIsDragging:FireServer(d[1])
    end)
    d[1]:PivotTo(d[2])
    return d
end
DragModelmain = function(...)
    local d = {...}
    pcall(function()
        b.Interaction.ClientIsDragging:FireServer(d[1])
    end)
    d[1].Main.CFrame = d[2]
    return d
end
DragModel2 = function(...)
    local d = {...}
    pcall(function()
        b.Interaction.ClientIsDragging:FireServer(d[1])
        b.Interaction.ClientIsDragging:FireServer(d[1])
        b.Interaction.ClientIsDragging:FireServer(d[1])
        b.Interaction.ClientIsDragging:FireServer(d[1])

    end)
    d[1]:SetPrimaryPartCFrame(d[2])
    return d
end
DragModel1 = function(...)
    local d = {...}
    pcall(function()
        b.Interaction.ClientIsDragging:FireServer(d[1])
        b.Interaction.ClientIsDragging:FireServer(d[1])
    end)
    d[1]:MoveTo(d[2])
    d[1]:MoveTo(d[2])
    return d
end


repeat wait(.1) until lp.Character
local Character0 = lp.Character
Character0.Archivable = true
local IsInvis = false
local IsRunning = true
local InvisibleCharacter = Character0:Clone()
InvisibleCharacter.Parent = game:GetService'Lighting'
local Void = workspace.FallenPartsDestroyHeight
InvisibleCharacter.Name = ""
local CF

lp.CharacterAdded:Connect(function()
	if lp.Character == InvisibleCharacter then return end
	repeat wait(.1) until lp.Character:FindFirstChildWhichIsA'Humanoid'
	if IsRunning == false then
		IsInvis = false
		IsRunning = true
		Character0 = lp.Character
		Character0.Archivable = true
		InvisibleCharacter = Character0:Clone()
		InvisibleCharacter.Name = ""
		InvisibleCharacter:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
			Respawn()
		end)
		for i,v in pairs(InvisibleCharacter:GetDescendants())do
			if v:IsA("BasePart") then
				if v.Name == "HumanoidRootPart" then
					v.Transparency = 1
				else
					v.Transparency = .5
				end
			end
		end
	end
end)

local Fix = game:GetService("RunService").Stepped:Connect(function()
	pcall(function()
		local IsInteger
		if tostring(Void):find'-' then
			IsInteger = true
		else
			IsInteger = false
		end
		local Pos = lp.Character.HumanoidRootPart.Position
		local Pos_String = tostring(Pos)
		local Pos_Seperate = Pos_String:split(', ')
		local X = tonumber(Pos_Seperate[1])
		local Y = tonumber(Pos_Seperate[2])
		local Z = tonumber(Pos_Seperate[3])
		if IsInteger == true then
			if Y <= Void then
				Respawn()
			end
		elseif IsInteger == false then
			if Y >= Void then
				Respawn()
			end
		end
	end)
end)

for i,v in pairs(InvisibleCharacter:GetDescendants())do
	if v:IsA("BasePart") then
		if v.Name == "HumanoidRootPart" then
			v.Transparency = 1
		else
			v.Transparency = .5
		end
	end
end

function Respawn()
	IsRunning = false
	if IsInvis == true then
		pcall(function()
			lp.Character = Character0
			wait()
			Character0.Parent = workspace
			Character0:FindFirstChildWhichIsA'Humanoid':Destroy()
			IsInvis = false
			InvisibleCharacter.Parent = nil
		end)
	elseif IsInvis == false then
		pcall(function()
			lp.Character = Character0
			wait()
			Character0.Parent = workspace
			Character0:FindFirstChildWhichIsA'Humanoid':Destroy()
			IsInvis = false
		end)
	end
end

InvisibleCharacter:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
	Respawn()
end)

function FixCam()
	workspace.CurrentCamera.CameraSubject = lp.Character:FindFirstChildWhichIsA'Humanoid'
	workspace.CurrentCamera.CFrame = CF
end

function freezecam(arg)
	if arg == true then
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	else
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	end
end

function TurnInvisible()
	if IsInvis == true then return end
	IsInvis = true
	CF = workspace.CurrentCamera.CFrame
	local CF_1 = lp.Character.HumanoidRootPart.CFrame
	lp.Character.HumanoidRootPart.CFrame=CFrame.new(9e9, 9e9, 9e9)
	freezecam(true)
	wait(.6)
	freezecam(false)
	InvisibleCharacter = InvisibleCharacter
	Character0.Parent = game:GetService'Lighting'
	InvisibleCharacter.Parent = workspace
	InvisibleCharacter.HumanoidRootPart.CFrame = CF_1
	lp.Character = InvisibleCharacter
	FixCam()
	lp.Character.Animate.Disabled = true
	lp.Character.Animate.Disabled = false
end

function TurnVisible()
	if IsInvis == false then return end
	CF = workspace.CurrentCamera.CFrame
	Character0 = Character0
	local CF_1 = lp.Character.HumanoidRootPart.CFrame
	Character0.HumanoidRootPart.CFrame = CF_1
	InvisibleCharacter.Parent = game:GetService'Lighting'
	lp.Character = Character0
	Character0.Parent = workspace
	IsInvis = false
	FixCam()
	lp.Character.Animate.Disabled = true
	lp.Character.Animate.Disabled = false
end
for i, v in next, game:GetService("Players").LocalPlayer.PlayerGui:GetChildren() do
    if v.Name ~= "Chat" and v.Name ~= "TargetGui" then
        for i, v in next, v:GetDescendants() do
            local UC = Instance.new("UICorner", v)
            UC.CornerRadius = UDim.new(0, 5)
            if v.Name == "DropShadow" then
                v:Destroy()
            end
            if v:IsA("TextButton") or v:IsA("Frame") or v:IsA("ScrollingFrame") then
                v.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            end
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                v.TextColor3 = Color3.fromRGB(225, 225, 225)
                v.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            end
        end
    end
end
notify = function(...)
    local GUI = game:GetService("CoreGui"):FindFirstChild("STX_Nofitication")
    if not GUI then
        local STX_Nofitication = Instance.new("ScreenGui")
        local STX_NofiticationUIListLayout = Instance.new("UIListLayout")
        STX_Nofitication.Name = "STX_Nofitication"
        STX_Nofitication.Parent = game.CoreGui
        STX_Nofitication.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        STX_Nofitication.ResetOnSpawn = false

        STX_NofiticationUIListLayout.Name = "STX_NofiticationUIListLayout"
        STX_NofiticationUIListLayout.Parent = STX_Nofitication
        STX_NofiticationUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        STX_NofiticationUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        STX_NofiticationUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end
    local Args = {...}
    local Nofitication = {}
    local GUI = game:GetService("CoreGui"):FindFirstChild("STX_Nofitication")
    function Nofitication:Notify(nofdebug, middledebug, all)
        local SelectedType = string.lower(tostring(middledebug.Type))
        local ambientShadow = Instance.new("ImageLabel")
        local Window = Instance.new("Frame")
        local Outline_A = Instance.new("Frame")
        local WindowTitle = Instance.new("TextLabel")
        local WindowDescription = Instance.new("TextLabel")

        ambientShadow.Name = "ambientShadow"
        ambientShadow.Parent = GUI
        ambientShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        ambientShadow.BackgroundTransparency = 1.000
        ambientShadow.BorderSizePixel = 0
        ambientShadow.Position = UDim2.new(0.91525954, 0, 0.936809778, 0)
        ambientShadow.Size = UDim2.new(0, 0, 0, 0)
        ambientShadow.Image = "rbxassetid://1316045217"
        ambientShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        ambientShadow.ImageTransparency = 0.400
        ambientShadow.ScaleType = Enum.ScaleType.Slice
        ambientShadow.SliceCenter = Rect.new(10, 10, 118, 118)

        Window.Name = "Window"
        Window.Parent = ambientShadow
        Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Window.BorderSizePixel = 0
        Window.Position = UDim2.new(0, 5, 0, 5)
        Window.Size = UDim2.new(0, 230, 0, 80)
        Window.ZIndex = 2

        Outline_A.Name = "Outline_A"
        Outline_A.Parent = Window
        Outline_A.BackgroundColor3 = middledebug.OutlineColor
        Outline_A.BorderSizePixel = 0
        Outline_A.Position = UDim2.new(0, 0, 0, 25)
        Outline_A.Size = UDim2.new(0, 230, 0, 2)
        Outline_A.ZIndex = 5

        WindowTitle.Name = "WindowTitle"
        WindowTitle.Parent = Window
        WindowTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        WindowTitle.BackgroundTransparency = 1.000
        WindowTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
        WindowTitle.BorderSizePixel = 0
        WindowTitle.Position = UDim2.new(0, 8, 0, 2)
        WindowTitle.Size = UDim2.new(0, 222, 0, 22)
        WindowTitle.ZIndex = 4
        WindowTitle.Font = Enum.Font.GothamSemibold
        WindowTitle.Text = nofdebug.Title
        WindowTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
        WindowTitle.TextSize = 12.000
        WindowTitle.TextXAlignment = Enum.TextXAlignment.Left

        WindowDescription.Name = "WindowDescription"
        WindowDescription.Parent = Window
        WindowDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        WindowDescription.BackgroundTransparency = 1.000
        WindowDescription.BorderColor3 = Color3.fromRGB(27, 42, 53)
        WindowDescription.BorderSizePixel = 0
        WindowDescription.Position = UDim2.new(0, 8, 0, 34)
        WindowDescription.Size = UDim2.new(0, 216, 0, 40)
        WindowDescription.ZIndex = 4
        WindowDescription.Font = Enum.Font.GothamSemibold
        WindowDescription.Text = nofdebug.Description
        WindowDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
        WindowDescription.TextSize = 12.000
        WindowDescription.TextWrapped = true
        WindowDescription.TextXAlignment = Enum.TextXAlignment.Left
        WindowDescription.TextYAlignment = Enum.TextYAlignment.Top

        if SelectedType == "default" then
            local function ORBHB_fake_script()
                local script = Instance.new("LocalScript", ambientShadow)

                ambientShadow:TweenSize(UDim2.new(0, 240, 0, 90), "Out", "Linear", 0.2)
                Window.Size = UDim2.new(0, 230, 0, 80)
                Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)

                wait(middledebug.Time)

                ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)

                wait(0.2)
                ambientShadow:Destroy()
            end
            coroutine.wrap(ORBHB_fake_script)()
        elseif SelectedType == "image" then
            ambientShadow:TweenSize(UDim2.new(0, 240, 0, 90), "Out", "Linear", 0.2)
            Window.Size = UDim2.new(0, 230, 0, 80)
            WindowTitle.Position = UDim2.new(0, 24, 0, 2)
            local ImageButton = Instance.new("ImageButton")
            ImageButton.Parent = Window
            ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageButton.BackgroundTransparency = 1.000
            ImageButton.BorderSizePixel = 0
            ImageButton.Position = UDim2.new(0, 4, 0, 4)
            ImageButton.Size = UDim2.new(0, 18, 0, 18)
            ImageButton.ZIndex = 5
            ImageButton.AutoButtonColor = false
            ImageButton.Image = all.Image
            ImageButton.ImageColor3 = all.ImageColor

            local function ORBHB_fake_script()
                local script = Instance.new("LocalScript", ambientShadow)

                Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)

                wait(middledebug.Time)

                ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)

                wait(0.2)
                ambientShadow:Destroy()
            end
            coroutine.wrap(ORBHB_fake_script)()
        elseif SelectedType == "option" then
            ambientShadow:TweenSize(UDim2.new(0, 240, 0, 110), "Out", "Linear", 0.2)
            Window.Size = UDim2.new(0, 230, 0, 100)
            local Uncheck = Instance.new("ImageButton")
            local Check = Instance.new("ImageButton")

            Uncheck.Name = "Uncheck"
            Uncheck.Parent = Window
            Uncheck.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Uncheck.BackgroundTransparency = 1.000
            Uncheck.BorderSizePixel = 0
            Uncheck.Position = UDim2.new(0, 7, 0, 76)
            Uncheck.Size = UDim2.new(0, 18, 0, 18)
            Uncheck.ZIndex = 5
            Uncheck.AutoButtonColor = false
            Uncheck.Image = "http://www.roblox.com/asset/?id=6031094678"
            Uncheck.ImageColor3 = Color3.fromRGB(255, 84, 84)

            Check.Name = "Check"
            Check.Parent = Window
            Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Check.BackgroundTransparency = 1.000
            Check.BorderSizePixel = 0
            Check.Position = UDim2.new(0, 28, 0, 76)
            Check.Size = UDim2.new(0, 18, 0, 18)
            Check.ZIndex = 5
            Check.AutoButtonColor = false
            Check.Image = "http://www.roblox.com/asset/?id=6031094667"
            Check.ImageColor3 = Color3.fromRGB(83, 230, 50)

            local function ORBHB_fake_script()
                local script = Instance.new("LocalScript", ambientShadow)

                local Stilthere = true
                local function Unchecked()
                    pcall(function()
                        all.Callback(false)
                    end)
                    ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)

                    wait(0.2)
                    ambientShadow:Destroy()
                    Stilthere = false
                end
                local function Checked()
                    pcall(function()
                        all.Callback(true)
                    end)
                    ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)

                    wait(0.2)
                    ambientShadow:Destroy()
                    Stilthere = false
                end
                Uncheck.MouseButton1Click:Connect(Unchecked)
                Check.MouseButton1Click:Connect(Checked)

                Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)

                wait(middledebug.Time)

                if Stilthere == true then
                    ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)

                    wait(0.2)
                    ambientShadow:Destroy()
                end
            end
            coroutine.wrap(ORBHB_fake_script)()
        end
    end
    Nofitication:Notify({
        Title = Args[1],
        Description = Args[2]
    }, {
        OutlineColor = Color3.fromRGB(80, 80, 80),
        Time = Args[3],
        Type = "image"
    }, {
        Image = "http://www.roblox.com/asset/?id=6023426923",
        ImageColor = Color3.fromRGB(255, 84, 84)
    })
end
function getTieredAxe()
    return {
        ['Beesaxe'] = 13,
        ['AxeAmber'] = 12,
        ['ManyAxe'] = 15,
        ['BasicHatchet'] = 0,
        ['RustyAxe'] = -1,
        ['Axe1'] = 2,
        ['Axe2'] = 3,
        ['AxeAlphaTesters'] = 9,
        ['Rukiryaxe'] = 8,
        ['Axe3'] = 4,
        ['AxeBetaTesters'] = 10,
        ['FireAxe'] = 11,
        ['SilverAxe'] = 5,
        ['EndTimesAxe'] = 16,
        ['AxeChicken'] = 6,
        ['CandyCaneAxe'] = 1,
        ['AxeTwitter'] = 7,
        ['CandyCornAxe'] = 14
    }
end
function getAxeList()
    local aP = {}
    for J, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        table.insert(aP, v)
    end
    local aQ = game.Players.LocalPlayer.Character;
    if aQ:FindFirstChildOfClass "Tool" then
        table.insert(aP, aQ:FindFirstChildOfClass("Tool"))
    end
    return aP
end
function getWorstAxe()
    local aQ = game.Players.LocalPlayer.Character;
    if aQ:FindFirstChildOfClass "Tool" then
        local y = aQ:FindFirstChildOfClass "Tool"
        if y:FindFirstChild("ToolName") then
            return y
        end
    end
    local aR = 9999;
    local aS = nil;
    local aT = getTieredAxe()
    for J, v in pairs(getAxeList()) do
        if v:FindFirstChild("ToolName") then
            if aT[v.ToolName.Value] < aR then
                aS = v;
                aR = aT[v.ToolName.Value]
            end
        end
    end
    return aS
end

local function barkgetBestAxe()
    local aQ = game.Players.LocalPlayer.Character;
    if aQ:FindFirstChildOfClass "Tool" then
        local y = aQ:FindFirstChildOfClass "Tool"
        if y:FindFirstChild("ToolName") then
            return y
        end
    end
    local aU = -1;
    local aV = nil;
    local aT = getTieredAxe()
    for J, v in pairs(getAxeList()) do
        if v:FindFirstChild("ToolName") then
            if aT[v.ToolName.Value] > aU then
                aV = v;
                aU = aT[v.ToolName.Value]
            end
        end
    end
    return aV
end
function getHitPointsTbl()
    return {
        ['Beesaxe'] = 1.4,
        ['AxeAmber'] = 3.39,
        ['ManyAxe'] = 10.2,
        ['BasicHatchet'] = 0.2,
        ['Axe1'] = 0.55,
        ['Axe2'] = 0.93,
        ['AxeAlphaTesters'] = 1.5,
        ['Rukiryaxe'] = 1.68,
        ['Axe3'] = 1.45,
        ['AxeBetaTesters'] = 1.45,
        ['FireAxe'] = 0.6,
        ['SilverAxe'] = 1.6,
        ['EndTimesAxe'] = 1.58,
        ['AxeChicken'] = 0.9,
        ['CandyCaneAxe'] = 0,
        ['AxeTwitter'] = 1.65,
        ['CandyCornAxe'] = 1.75,
        ["CaveAxe"] = 0.4
    }
end
local function getMouseTarget()
    local b2 = game:GetService("UserInputService"):GetMouseLocation()
    return workspace:FindPartOnRayWithIgnoreList(Ray.new(workspace.CurrentCamera.CFrame.p,
        workspace.CurrentCamera:ViewportPointToRay(b2.x, b2.y, 0).Direction * 1000),
        game.Players.LocalPlayer.Character:GetDescendants())
end
local Pos = game:service 'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)

local function table_foreach(table, callback)
    for i = 1, #table do
        callback(i, table[i])
    end
end

local function getCFrame(part)
    local part = part or (lp.Character and lp.Character.HumanoidRootPart)
    if not part then
        return
    end
    return part.CFrame
end

local function tp(pos)
    local pos = pos or lp:GetMouse().Hit + Vector3.new(0, lp.Character.HumanoidRootPart.Size.Y, 0)
    if typeof(pos) == "CFrame" then
        lp.Character:SetPrimaryPartCFrame(pos)
    elseif typeof(pos) == "Vector3" then
        lp.Character:MoveTo(pos)
    end
end

require = getgenv().require -- for pebc and sentinel

function get_axe_damage(tool, tree)
    -- totally not skidded from lumbsmasher
    local axe_class = require(game.ReplicatedStorage.AxeClasses['AxeClass_' .. tool.ToolName.Value])
    local axe_table = axe_class.new()
    if axe_table["SpecialTrees"] then
        if axe_table["SpecialTrees"][tree] then
            return axe_table["SpecialTrees"][tree].Damage
        else
            return axe_table.Damage
        end
    else
        return axe_table.Damage
    end
end
function get_axe_cooldown(tool)
    local success, return_value = pcall(function()
        local axe_class = require(game.ReplicatedStorage.AxeClasses['AxeClass_' .. tool.ToolName.Value])
        local axe_table = axe_class.new()

        return axe_table.SwingCooldown
    end)
    if success then
        return return_value
    else
        warn("ERROR WHILE REQUIRING MODULE: " .. return_value)
        return 1
    end
end
function get_axe_swingdelay(tool)
    local axe_cooldown = get_axe_cooldown(tool)
    local start = tick()
    game.ReplicatedStorage.TestPing:InvokeServer()
    local ping = (tick() - start) / 2
    local swing_delay = 0.65 * axe_cooldown - ping
    return swing_delay
end
local override_sawmill = nil
function getBestSawmill()
    local best = nil
    for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
        if v:FindFirstChild("Owner") and v:FindFirstChild("ItemName") and v.Owner.Value == game.Players.LocalPlayer and
            v.ItemName.Value:sub(1, 7) == "Sawmill" then
            if not best then
                best = v
            else
                if #v.ItemName.Value > #best.ItemName.Value then
                    best = v
                elseif tonumber(v.ItemName.Value:sub(8, 8)) > tonumber(best.ItemName.Value:sub(8, 8)) then
                    best = v
                end
            end
        end
    end
    return best
end
function barkgetBestAxe2()
    -- changing it to my own method ~applebee#3071
    local pc = game.Players.LocalPlayer.Character
    local axe_damage
    local best_axe
    for i, v in pairs(getAxeList()) do
        if v.name == "Tool" then
            local damage = get_axe_damage(v, "Generic")
            if best_axe == nil then
                best_axe = v
                axe_damage = damage
            elseif get_axe_damage(best_axe, "Generic") < damage then
                best_axe = v
                axe_damage = damage
            end
        end
    end
    return best_axe
end
local function lumbsmasher_legitpaint(wood_class, blueprint, tpback)

    local old = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local remote = game.ReplicatedStorage.PlaceStructure.ClientPlacedStructure
    local bp_type = blueprint.ItemName.Value

    local Player = game.Players.LocalPlayer
    local wood
    for i, v in pairs(game:GetService("ReplicatedStorage").ClientItemInfo:GetChildren()) do
        if v.Name == bp_type then
            for i, s in pairs(v:GetChildren()) do
                if s.Name == "WoodCost" then
                    wood = s.Value
                end
            end
        end

    end
    if lp.SuperBlueprint.Value then
        wood = 1
    end
    local required_wood = wood

    -- getting the axe
    local tool = barkgetBestAxe2()
    local sawmill = getBestSawmill()
    if tool == nil then
        notify("道庭DT", "请你装备斧头", 4)
        return
    end

    if wood_class == "LoneCave" then
        if tool.ToolName.Value ~= "EndTimesAxe" then
            notify("道庭DT", "请你装备末日斧头", 4)
            return
        end
    end

    local WoodSection
    local Min = 9e99

    for i, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == 'TreeRegion' then
            for j, Tree in pairs(v:GetChildren()) do
                if Tree:FindFirstChild('Leaves') and Tree:FindFirstChild('WoodSection') and
                    Tree:FindFirstChild('TreeClass') then
                    if Tree:FindFirstChild('TreeClass').Value == wood_class then

                        for k, TreeSection in pairs(Tree:GetChildren()) do
                            if TreeSection.Name == 'WoodSection' then
                                local Size = TreeSection.Size.X * TreeSection.Size.Y * TreeSection.Size.Z
                                if (Size > required_wood) and (#TreeSection.ChildIDs:GetChildren() == 0) then
                                    if Min > TreeSection.Size.X then
                                        Min = TreeSection.Size.X
                                        WoodSection = TreeSection
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if not WoodSection then
        notify("道庭DT", "没有找到树", 4)
        return
    end

    local Chopped = false
    local treecon = game.Workspace.LogModels.ChildAdded:connect(function(add)
        local Owner = add:WaitForChild('Owner')
        if (add.Owner.Value == Player) and (add.TreeClass.Value == wood_class) and add:FindFirstChild("WoodSection") then
            Chopped = add
            treecon:Disconnect()
        end
    end)

    local CutSize = required_wood / (WoodSection.Size.X * WoodSection.Size.X) + 0.01
    local swing_delay = get_axe_swingdelay(tool)
    local function axe(v, id, h)
        local hps = get_axe_damage(tool, Wood)
        local table = {
            ["tool"] = tool,
            ["faceVector"] = Vector3.new(0, 0, -1),
            ["height"] = h,
            ["sectionId"] = id,
            ["hitPoints"] = hps,
            ["cooldown"] = 0.112,
            ["cuttingClass"] = "Axe"
        }
        game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v.CutEvent, table)
        task.wait()
    end
    local iterations = 0
    _G.GetTreeNC = game:GetService 'RunService'.Stepped:connect(oldnocliprun)
    while Chopped == false do
        iterations = iterations + 1
        if iterations > 1000 then
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(WoodSection.Parent)
            game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(WoodSection.Parent)
            Chopped = true
        end
        tp(WoodSection.CFrame + Vector3.new(4, 2, 2))
        axe(WoodSection.Parent, WoodSection.ID.Value, WoodSection.Size.Y - CutSize)
    end
    _G.GetTreeNC:Disconnect()
    _G.GetTreeNC = nil
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)

    local target_cframe
    if blueprint:FindFirstChild("MainCFrame") then
        target_cframe = blueprint.MainCFrame.Value
    else
        target_cframe = blueprint.PrimaryPart.CFrame
    end

    -- local fill_target_cframe = sawmill.Particles.CFrame + Vector3.new((sawmill.Main.Size.X/2)-2, 0, 0)
    local fill_target_cframe = sawmill.Particles.CFrame + Vector3.new(0, 1, 0)
    -- teleport bp to sawmill --ignore as teleporting to wood directly
    -- game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(blueprint.ItemName.Value, fill_target_cframe, game.Players.LocalPlayer, blueprint, true)

    iterations = 0
    local Sawed = false
    sawconn = game.Workspace.PlayerModels.ChildAdded:connect(function(add)
        local Owner = add:WaitForChild('Owner')
        if (add.Owner.Value == Player) and add:FindFirstChild("WoodSection") then
            if not add:FindFirstChild('TreeClass') then
                repeat
                    wait()
                until add:FindFirstChild('TreeClass')
            end
            if add.TreeClass.Value == wood_class then
                Sawed = add
                sawconn:Disconnect()
            end
        end
    end)
    iterations = 0
    while Chopped.Parent ~= nil do
        if Sawed then
            break
        end
        iterations = iterations + 1
        if iterations > 300 then
            notify("道庭DT", "没有成功处理树", 4)
        end
        tp(CFrame.new(Chopped.WoodSection.Position) + Vector3.new(0, 4, 0))
        -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Chopped.WoodSection)
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped)
        Chopped.PrimaryPart = Chopped.WoodSection
        Chopped:SetPrimaryPartCFrame(sawmill.Particles.CFrame)
        -- Chopped.WoodSection.CFrame = sawmill.Particles.CFrame
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped)
        wait(2)
    end
    repeat
        wait()
    until Sawed
    iterations = 0

    local placed = false
    local new_structure_connection
    new_structure_connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
        local owner = child:WaitForChild("Owner")
        if owner.Value == game.Players.LocalPlayer and child:FindFirstChild("Type") and child.Type.Value == "Structure" then
            if not child:FindFirstChild("BuildDependentWood") then
                notify("道庭DT", "没有成功", 4)
                return
            end
            new_structure_connection:Disconnect()
            local wood_type
            if child:FindFirstChild("BlueprintWoodClass") then
                wood_type = child.BlueprintWoodClass.Value
            end
            remote:FireServer(child.ItemName.Value, target_cframe, game.Players.LocalPlayer, wood_type, child, true, nil)
            placed = true
            -- pcall(rconsoleprint, "Moved and Placed Structure!\n")
        end
    end)
    while Sawed.Parent ~= nil do
        -- pcall(rconsoleprint, "Plank Exists! Filling Blueprint...\n")
        if iterations > 50 then
            -- if blueprint.Parent then
            game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(Sawed)
            game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(blueprint)
            -- pcall(rconsoleprint, "Way too many attempts to teleport blueprint to wood!\n")
            notify("道庭DT", "尝试太多次蓝图填充了", 4)
            -- end
        end
        iterations = iterations + 1
        if Sawed.Parent == nil then
            break
        end
        local connection, blueprint_made
        connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
            if child:WaitForChild("Owner") and child.Owner.Value == game.Players.LocalPlayer and
                child:FindFirstChild("Type") and child.Type.Value == "Blueprint" then
                connection:Disconnect()
                blueprint = child
                blueprint_made = true
            end
        end)
        game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(bp_type, Sawed.WoodSection.CFrame,
            game.Players.LocalPlayer, blueprint, blueprint.Parent ~= nil)
        -- pcall(rconsoleprint, "Waiting for BP Move...\n")
        local bp_wait_iter = 0
        repeat
            if bp_wait_iter > 500 then
                notify("道庭DT", "没有找到蓝图", 4)
                -- game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(blueprint)
                -- game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(bp_type, Sawed.WoodSection.CFrame, game.Players.LocalPlayer, nil, false)
                -- bp_wait_iter = 0
            end
            wait()
            bp_wait_iter = bp_wait_iter + 1
        until blueprint_made or placed
        if placed then
            pcall(connection.Disconnect, connection)
        end

    end
    iterations = 0
    -- pcall(rconsoleprint, "Waiting for placement...\n")
    repeat
        wait()
    until placed
    -- pcall(rconsoleprint, "Placed!\n")
    if tpback then
        tp(old)
        notify("道庭DT", "完成", 4)
    end
end

local function getPosition(part)
    return getCFrame(part).Position
end

local function getTools()
    lp.Character.Humanoid:UnequipTools()
    local tools = {}
    table_foreach(lp.Backpack:GetChildren(), function(_, v)
        if v.Name ~= "BlueprintTool" then
            tools[#tools + 1] = v
        end
    end)
    return tools
end
local function getToolStats(toolName)
    if typeof(toolName) ~= "string" then

        toolName = toolName.ToolName.Value
    end
    return require(gs("ReplicatedStorage").AxeClasses['AxeClass_' .. toolName]).new()
end
local getTool = function()
    return lp.Character:FindFirstChild("Tool") or lp.Backpack:FindFirstChild("Tool")
end
local function getBestAxe(treeClass)
    local tools = getTools()
    if #tools == 0 then
        return notify("道庭DT", "你需要斧头", 4)
    end
    local toolStats = {}
    local tool
    for _, v in next, tools do
        if treeClass == "LoneCave" and v.ToolName.Value == "EndTimesAxe" then
            tool = v
            break
        end
        local axeStats = getToolStats(v)
        if axeStats.SpecialTrees and axeStats.SpecialTrees[treeClass] then
            for i, v in next, axeStats.SpecialTrees[treeClass] do
                axeStats[i] = v
            end
        end
        table.insert(toolStats, {
            tool = v,
            damage = axeStats.Damage
        })
    end
    if not tool and treeClass == "LoneCave" then
        return notify("道庭DT", "你需要末日斧头", 4)
    end
    table.sort(toolStats, function(a, b)
        return a.damage > b.damage
    end)
    return true, tool or toolStats[1].tool
end

local function cutPart(event, section, height, tool, treeClass)
    local axeStats = getToolStats(tool)
    if axeStats.SpecialTrees and axeStats.SpecialTrees[treeClass] then
        for i, v in next, axeStats.SpecialTrees[treeClass] do
            axeStats[i] = v
        end
    end
    game:GetService 'ReplicatedStorage'.Interaction.RemoteProxy:FireServer(event, {
        tool = tool,
        faceVector = Vector3.new(-1, 0, 0),
        height = height or 0.3,
        sectionId = section or 1,
        hitPoints = axeStats.Damage,
        cooldown = axeStats.SwingCooldown,
        cuttingClass = "Axe"
    })
end
local treeListener = function(treeClass, callback)
    local childAdded
    childAdded = workspace.LogModels.ChildAdded:Connect(function(child)
        local owner = child:WaitForChild("Owner")
        if owner.Value == lp and child.TreeClass.Value == treeClass then
            childAdded:Disconnect()
            callback(child)
        end
    end)
end

local getBiggestTree = function(treeClass)
    for _, v in next, workspace:children() do
        if tostring(v) == "TreeRegion" then
            for _, g in next, v:children() do
                if g:FindFirstChild("TreeClass") and tostring(g.TreeClass.Value) == treeClass and
                    g:FindFirstChild("Owner") then
                    if g.Owner.Value == nil or tostring(g.Owner.Value) == tostring(game.Players.LocalPlayer) then
                        if #g:children() > 5 and g:FindFirstChild("WoodSection") then
                            for h, j in next, g:children() do
                                if j:FindFirstChild("ID") and j.ID.Value == 1 and j.Size.Y > .5 then
                                    return j;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false;
end

local function bringTree(treeClass)

    local success, data = getBestAxe(treeClass)

    local axeStats = getToolStats(data)

    local treeCut = false

    treeListener(treeClass, function(tree)
        tree:WaitForChild('Owner', 60)

        tree.PrimaryPart = tree:FindFirstChild("WoodSection")
        treeCut = true

        task.spawn(function()
            for i = 1, 60 do
                game:GetService("ReplicatedStorage")
                b.Interaction.ClientIsDragging:FireServer(tree)
                game["Run Service"].Heartbeat:wait()
            end
        end)
        task.wait(0.1)
        tree.PrimaryPart = tree.WoodSection
        spawn(function()
            for i = 1, 60 do
                tree.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                tree:PivotTo(DT.treecutset)
                game["Run Service"].Heartbeat:wait()
            end
        end)

        wait(0.5)
        if treeClass == "LoneCave" then
            lp.Character.Head:Destroy()
            lp.CharacterAdded:Wait()
            wait(2)
        end

        tp(DT.treecutset)
    end)

    if treeClass == "LoneCave" then
        local GM = game.Players.LocalPlayer.Character.HumanoidRootPart.RootJoint
        GM:Clone().Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        GM:Destroy()
    end
    local tree = getBiggestTree(treeClass)
    if not tree then
        return notify("道庭DT", "没有找到树", 3)
    end

    spawn(function()
        repeat
            tp(tree.CFrame + Vector3.new(3, 3, 0))
            cutPart(tree.Parent.CutEvent, 1, 0.3, data, treeClass)
            game["Run Service"].Heartbeat:wait()
        until treeCut
    end)

end

local function autofarm(treeClass)
    local oldpos = lp.Character.HumanoidRootPart.CFrame
    local success, data = getBestAxe(treeClass)

    local axeStats = getToolStats(data)

    local tree = getBiggestTree(treeClass)

    if not tree then
        return notify("道庭DT", "没有找到树", 3)
    end

    local treeCut = false

    treeListener(treeClass, function(tree)
        tree.PrimaryPart = tree:FindFirstChild("WoodSection")
        treeCut = true

        for i = 1, 70 do

            game:GetService 'ReplicatedStorage'.Interaction.ClientIsDragging:FireServer(tree.WoodSection)
            tree:MoveTo(oldPosition)
            task.wait()
        end

    end)
    task.wait(0.15)

    task.spawn(function()
        repeat
            tp(tree.trunk.CFrame * CFrame.new(4, 3, 4))
            task.wait()
        until treeCut
    end)

    task.wait()

    repeat
        cutPart(tree.tree.CutEvent, 1, 0.3, data, treeClass)
        task.wait(axeStats.SwingCooldown - 14)
    until treeCut
    if DT.autofarm1 == false then
        notify("道庭DT", "完成", 3)
    end
    tp(oldPosition)
end

local function lowerBridge(value)

    if value == 'Higher' then
        for _, v in pairs(game.workspace.Bridge.VerticalLiftBridge.Lift:GetChildren()) do
            v.CFrame = v.CFrame + Vector3.new(0, 26, 0)
        end

    elseif value == 'Lower' then
        for _, v in pairs(game.workspace.Bridge.VerticalLiftBridge.Lift:GetChildren()) do
            v.CFrame = v.CFrame + Vector3.new(0, -26, 0)
        end
    end
end

local function OpenSelectedItem(item)
    local itemBox = item:FindFirstChild('BoxItemName') or item:FindFirstChild('PurchasedBoxItemName');
    if itemBox and item:FindFirstChild('Type') and item.Type.Value ~= 'Structure' then
        game:GetService('ReplicatedStorage').Interaction.ClientInteracted:FireServer(item, 'Open box');
        notify('道庭DT', '成功打开', 4)
    end
end

local function donate(plr, amount)
    local spawnf = function(func, ...)
        return coroutine.wrap(func)(...)
    end
    if tostring(plr) == tostring(lp) then
        notify('错误', '请选择玩家', 4);
        return;
    end
    if DT.donationRecipient == nil or not game:GetService('Players'):FindFirstChild(plr) then
        notify('错误', '没有找到玩家', 4);
        return;
    end
    if tonumber(DT.moneyaoumt) >= 60000000 then
        notify('错误', '数字太高', 4);
        return;
    end
    if tonumber(DT.moneyaoumt) <= 0 then
        notify('错误', '数字太高', 4);
        return;
    end
    if lp.CurrentSaveSlot.Value <= 0 then
        notify('错误', '基地没有加载', 4);
        return;
    end
    if not lp:FindFirstChild('CurrentlySavingOrLoading') then
        notify('错误', '正在保存', 4);
        return;
    end
    if tonumber(DT.moneyaoumt) > lp.leaderstats.Money.Value then
        notify('错误', '你没有足够的钱', 4);
        return;
    end

    local scr = getsenv(lp.PlayerGui.DonateGUI.DonateClient)
    local scr2 = getsenv(lp.PlayerGui.NoticeGUI.NoticeClient)
    scr.setPlatformControls = function()
    end
    scr.openWindow();
    game:GetService 'RunService'.Heartbeat:wait();
    local oldAmount = DT.Players:FindFirstChild(plr).leaderstats.Money.Value;
    local success, errormsg = spawnf(function()
        game:GetService 'ReplicatedStorage'.Transactions.ClientToServer.Donate:InvokeServer(game:GetService('Players')
            :FindFirstChild(plr), tonumber(amount), tonumber(lp.CurrentSaveSlot.Value))
    end);
    game:GetService 'RunService'.Heartbeat:wait();
    for i, v in next, getupvalues(scr.sendDonation) do
        if i == 1 then
            debug.setupvalue(scr.sendDonation, i, game.Players:FindFirstChild(plr));
        end
    end
    scr.sendDonation();
    game:GetService 'RunService'.Heartbeat:wait();
    scr2.exitNotice();
    notify('道庭DT', '正在尝试转钱', 2);
    wait(6)
    if game:GetService('Players'):FindFirstChild(plr).leaderstats.Money.Value ~= oldAmount + amount then
        notify('错误', '错误可能需要冷却', 4);
        scr2.exitNotice();
        return;
    end
    notify('道庭DT', '转钱' .. tostring(amount) .. ' 给 ' .. tostring(plr), 4);
    scr2.exitNotice();
end
local function OwnerCheck(item)
    if item:FindFirstChild('Owner') then
        return tostring(item.Owner.Value);
    end
end

local function WhitelistCheck(player)
    return game:GetService('ReplicatedStorage').Interaction.ClientIsWhitelisted:InvokeServer(player) == true;
end
local function farAxeEquip()

    local done = false;
    if DT.farAxeEquip == nil then
        notify('道庭DT', '选择一把斧头', 4);
        DT.farAxeEquip = Mouse.Button1Down:connect(function()
            local target = Mouse.Target;
            if target.Parent:IsA('Model') and target.Parent:FindFirstChild('ToolName') then
                if OwnerCheck(target.Parent) == tostring(lp) or WhitelistCheck(target.Parent.Owner.Value) then
                    game:GetService('ReplicatedStorage').Interaction.ClientInteracted:FireServer(target.Parent,
                        'Pick up tool');
                    done = true;
                end
            end
        end);
        repeat
            wait()
        until done;
        notify('道庭DT', '已装备', 4);
        if DT.farAxeEquip then
            DT.farAxeEquip:Disconnect();
            DT.farAxeEquip = nil;
        end
    else
        notify('错误', '已经激活', 4);
    end
end
local function applyLight(value)
    if value then
        local light = Instance.new('PointLight', lp.Character.Head)
        light.Name = 'DT'
        light.Range = 150
        light.Brightness = 1.7
    else
        pcall(function()
            lp.Character.Head.DT:remove();
        end);
    end
end

local function carTeleport(cframe)
    if game.Players.LocalPlayer.Character then
        Character = game.Players.LocalPlayer.Character
        if Character.Humanoid.SeatPart ~= nil then
            Car = Character.Humanoid.SeatPart.Parent
            spawn(function()
                for i = 1, 5 do
                    wait()
                    Car:SetPrimaryPartCFrame(cframe *
                                                 CFrame.Angles(math.rad(Character.HumanoidRootPart.Orientation.x),
                            math.rad(Character.HumanoidRootPart.Orientation.y), 0))
                    game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Car.Main)
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Car.Main)
                end
            end)
        end
    end

end
local function CheckIfSlotAvailable(Slot)
    for a, b in pairs(game.ReplicatedStorage.LoadSaveRequests.GetMetaData:InvokeServer(game.Players.LocalPlayer)) do
        if a == Slot then
            for c, d in pairs(b) do
                if c == "NumSaves" and d ~= 0 then
                    return true
                else
                    return false
                end
            end
        end
    end
end

local function CheckSlotNumber() -- Checks if the slot number is right
    if DT.soltnumber == "1" or DT.soltnumber == "2" or DT.soltnumber == "3" or DT.soltnumber == "4" or
        DT.soltnumber == "5" or DT.soltnumber == "6" then
        local SlotNumber = tonumber(DT.soltnumber)
        return SlotNumber
    else
        return false
    end
end

local function getPlanks()
    local plankList = {};
    for _, plank in next, game:GetService('Workspace').PlayerModels:children() do
        if plank:FindFirstChild('WoodSection') and plank:FindFirstChild('Owner') and plank.Owner.Value ==
            game:GetService('Players').LocalPlayer and not table.find(plankList, plank) then
            table.insert(plankList, plank)
        end
    end
    return plankList;
end

local function sellwood()
    local oldpos = lp.Character.HumanoidRootPart.CFrame
    for i, v in next, game:GetService("Workspace").LogModels:GetChildren() do
        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
            tp(v.WoodSection.CFrame)
            spawn(function()
                for i2, v2 in next, v:GetChildren() do
                    if v2.Name == "WoodSection" then
                        local FreezeWood = Instance.new("BodyVelocity", v2)
                        FreezeWood.Velocity = Vector3.new(0, 0, 0)
                        FreezeWood.P = 100000
                        spawn(function()

                            for i = 1, 50 do
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                                v:PivotTo(CFrame.new(314.54, -0.5, 86.823))
                                v2.CFrame = CFrame.new(314.54, -0.5, 86.823)
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                                game:GetService 'RunService'.Heartbeat:wait();
                            end
                        end)
                        task.wait(1)
                    end
                end
            end)
            task.wait(2)
        end
    end
    tp(oldpos)
end

local function PlankToBlueprint()

    local target;
    notify('道庭DT', '选择一个木头和蓝图', 2);
    DT.PlankToBlueprint = game:GetService('Players').LocalPlayer:GetMouse().Button1Down:Connect(function()
        if game:GetService('Players').LocalPlayer:GetMouse().Target then
            target = game:GetService('Players').LocalPlayer:GetMouse().Target;
        end
        if target.Parent:FindFirstChild('Type') and target.Parent.Type.Value == 'Blueprint' then
            DT.blueprintModel = game:GetService('Players').LocalPlayer:GetMouse().Parent;
            notify('道庭DT', '蓝图已选择', 2);
        end
        if tostring(target.Parent) == 'Plank' and target.Parent:FindFirstChild('Owner') and
            tostring(target.Parent.Owner.Value) == tostring(lp) then
            DT.plankModel = target.Parent;
            notify('道庭DT', '木头已选择', 2);
        end
    end);
    repeat
        wait()
    until DT.plankModel and DT.blueprintModel;
    DT.PlankToBlueprint:Disconnect();
    DT.PlankToBlueprint = nil;
    tp(CFrame.new(DT.plankModel:FindFirstChildOfClass 'Part'.CFrame.p + Vector3.new(0, 3, 4)))
    wait(.2)
    for i = 1, 30 do
        pcall(function()
            game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(DT.plankModel)
            DT.plankModel.WoodSection.CFrame = CFrame.new(DT.blueprintModel.Main.CFrame.p + Vector3.new(0, 1.5, 0));
            game:GetService 'RunService'.Stepped:wait();
        end);
    end

    notify('道庭DT', '完成', 2);
    DT.blueprintModel = nil;
    DT.plankModel = nil;
end

local function burnAllShopItems()
    local found = false;
    for _, PressurePlate in pairs(game.Workspace.PlayerModels:children()) do
        if PressurePlate:FindFirstChild 'ItemName' and PressurePlate.ItemName.Value == 'PressurePlate' then
            if PressurePlate.Output.BrickColor ~= BrickColor.new 'Electric blue' then
                repeat
                    wait()
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(
                        PressurePlate.Plate.CFrame.p + Vector3.new(0, .3, 0));
                until PressurePlate.Output.BrickColor == BrickColor.new 'Electric blue' or not PressurePlate;
                found = true;
            end
        end
    end
    if not found then
        notify('道庭DT', '没有找到压力板', 4);
        return;
    end
end

function axefily()

    DT.axeFling = mouse.Button1Down:Connect(function()
        local axe = nil
        local axeConnection = workspace.PlayerModels.ChildAdded:connect(function(v)
            v:WaitForChild('Owner', 60)
            if v.Owner.Value == lp then
                print(v)
                axe = v;
                wait(2);
                game.ReplicatedStorage.Interaction.ClientInteracted:FireServer(axe, 'Pick up tool');
            end
        end);

        local oldpos = lp.Character.HumanoidRootPart.CFrame
        droptool(oldpos)

        repeat
            task.wait(0.1)
        until axe ~= nil
        axeConnection:Disconnect();
        axeConnection = nil;
        local fling = Instance.new('BodyPosition', axe.Main);
        fling.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
        fling.P = 650000;
        fling.Position = lp:GetMouse().Hit.p;

        spawn(function()
            while DT.whthmose == true do
                task.wait(0.1)
                fling.Position = lp:GetMouse().Hit.p;
            end
        end)
        local flingPower = 9e9;
        axe.Main.CanCollide = false;
        repeat
            task.wait();
            axe.Main.RotVelocity = Vector3.new(5, 5, 5) * flingPower;
        until (axe.Main.CFrame.p - fling.Position).Magnitude < 1;
        wait(7);
        fling:Destroy();
        axe.Main.CanCollide = true;

    end)
end

local function Press(Button)
    game.ReplicatedStorage.Interaction.RemoteProxy:FireServer(Button)
end
function CanClientLoad()
    if not game:GetService "ReplicatedStorage".LoadSaveRequests.ClientMayLoad:InvokeServer(lp) then
        notify("道庭DT", "等待加载时间,请耐心的等待", 4)
        repeat
            game:GetService "RunService".Stepped:wait()
        until game:GetService "ReplicatedStorage".LoadSaveRequests.ClientMayLoad:InvokeServer(lp)
    end
    return true
end
function GetLoadedSlot()
    return lp.CurrentSaveSlot.Value
end
function LoadSlot(slot)
    local CheckLoad
    spawn(function()
        CheckLoad = game:GetService('ReplicatedStorage').LoadSaveRequests.ClientMayLoad:InvokeServer(lp)
        if not CheckLoad then
            repeat
                wait()
            until CheckLoad
        end
        game:GetService('ReplicatedStorage').LoadSaveRequests.RequestLoad:InvokeServer(slot, lp)
        return slot
    end)
end

Teleport = function(...)
    local d = {...}
    for e = 1, 3 do
        task.wait()
        c.Character.HumanoidRootPart.CFrame = d[1]
    end
    return d
end

local k = tonumber(1)
local l = {}
GetShopID = {
    ["WoodRus"] = {
        ["Character"] = a.Stores.WoodRUs.Thom,
        ["Name"] = "Thom",
        ["ID"] = tonumber(7)
    },
    ["FurnitureStore"] = {
        ["Character"] = a.Stores.FurnitureStore.Corey,
        ["Name"] = "Corey",
        ["ID"] = tonumber(8)
    },
    ["CarStore"] = {
        ["Character"] = a.Stores.CarStore.Jenny,
        ["Name"] = "Jenny",
        ["ID"] = tonumber(9)
    },
    ["ShackShop"] = {
        ["Character"] = a.Stores.ShackShop.Bob,
        ["Name"] = "Bob",
        ["ID"] = tonumber(10)
    },
    ["FineArt"] = {
        ["Character"] = a.Stores.FineArt.Timothy,
        ["Name"] = "Timothy",
        ["ID"] = tonumber(11)
    },
    ["LogicStore"] = {
        ["Character"] = a.Stores.LogicStore.Lincoln,
        ["Name"] = "Lincoln",
        ["ID"] = tonumber(12)
    }
}
BuyItem = function(m)
    return b.NPCDialog.PlayerChatted:InvokeServer(m, "ConfirmPurchase")
end

function finditem(o)
    for e, h in next, a.Stores:children() do
        if h.Name == "ShopItems" and h:FindFirstChild "Box" then
            for i, j in next, h:children() do

                if j.BoxItemName.Value == o then
                    for i, w in next, h:children() do

                        if w.BoxItemName.Value == "Bed1" or w.BoxItemName.Value == "Seat_Couch" then
                            ID = GetShopID.FurnitureStore
                            Cashier = game.Workspace.Stores.FurnitureStore.Corey.HumanoidRootPart.CFrame
                            Counter = game.Workspace.Stores.FurnitureStore.Counter.CFrame + Vector3.new(0, .4, 0)
                        elseif w.BoxItemName.Value == "Sawmill" or w.BoxItemName.Value == "Sawmill2" then
                            ID = GetShopID.WoodRus
                            Cashier = game.Workspace.Stores.WoodRUs.Thom.HumanoidRootPart.CFrame
                            Counter = game.Workspace.Stores.WoodRUs.Counter.CFrame + Vector3.new(0, .4, 0)
                        elseif w.BoxItemName.Value == "Trailer2" or w.BoxItemName.Value == "UtilityTruck2" then
                            ID = GetShopID.CarStore
                            Cashier = game.Workspace.Stores.CarStore.Jenny.HumanoidRootPart.CFrame
                            Counter = game.Workspace.Stores.CarStore.Counter.CFrame + Vector3.new(0, .4, 0)
                        elseif w.BoxItemName.Value == "CanOfWorms" or w.BoxItemName.Value == "Dynamite" then
                            ID = GetShopID.ShackShop
                            Cashier = game.Workspace.Stores.ShackShop.Bob.HumanoidRootPart.CFrame
                            Counter = game.Workspace.Stores.ShackShop.Counter.CFrame + Vector3.new(0, .4, 0)
                        elseif w.BoxItemName.Value == "Painting1" or w.BoxItemName.Value == "Painting2" then
                            ID = GetShopID.FineArt
                            Cashier = game.Workspace.Stores.FineArt.Timothy.HumanoidRootPart.CFrame
                            Counter = game.Workspace.Stores.FineArt.Counter.CFrame + Vector3.new(0, .4, 0)
                        elseif w.BoxItemName.Value == "GateXOR" or w.BoxItemName.Value == "NeonWireOrange" then
                            ID = GetShopID.LogicStore
                            Cashier = game.Workspace.Stores.LogicStore.Lincoln.HumanoidRootPart.CFrame
                            Counter = game.Workspace.Stores.LogicStore.Counter.CFrame + Vector3.new(0, .4, 0)

                        end
                    end
                    return {j, Cashier, ID, Counter}
                end
            end
        end
    end
end
function autobuyv2(o)

    local item = nil
    local ltem = nil

    item = finditem(o)

    if item == nil then
        notify("道庭DT", "没有找到商品或者没有刷新，请你等待", 4)
        repeat
            task.wait()
            item = finditem(o)
        until item ~= nil

    end

    ltem = item[1]

    Teleport(ltem.Main.CFrame)
    task.wait()

    game:GetService('RunService').Stepped:wait();
    for e = 1, 15 do
        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(ltem)
        ltem:PivotTo(item[4])
        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(ltem)
        game:GetService('RunService').Stepped:wait();
    end
    Teleport(item[4] + Vector3.new(5, 0, 5))

    repeat

        BuyItem(item[3])
        game:GetService('RunService').Stepped:wait()

    until tostring(ltem.Parent) ~= "ShopItems"

    return o
end

function autobuy(o, r)
    DT.autocsdx = game.Workspace.PlayerModels.ChildAdded:connect(function(v)
        v:WaitForChild('Owner', 60)
        if v.Owner.Value == lp then
            for i = 1, 20 do
                game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                v:PivotTo(DT.autobuyset)
                game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                game:GetService('RunService').Stepped:wait();
            end
        end
    end)
    for e = 1, r do
        if DT.autobuystop == false then
            autobuyv2(o)
            task.wait()
        end
    end
    spawn(function()
        wait(1)
        DT.autocsdx:Disconnect();
        DT.autocsdx = nil;
    end)
    return o, r
end

local cashierIds = {};
spawn(function()
    local connection = game.ReplicatedStorage.NPCDialog.PromptChat.OnClientEvent:connect(function(ba, data)
        if cashierIds[data.Name] == nil then
            cashierIds[data.Name] = data.ID;
        end
    end);
    game.ReplicatedStorage.NPCDialog.SetChattingValue:InvokeServer(1);
    wait(2)
    connection:Disconnect();
    connection = nil;
    game.ReplicatedStorage.NPCDialog.SetChattingValue:InvokeServer(0);
end);

local function getSpecialID(Shop)
    return cashierIds[Shop];
end

function shuaxinlb(zji)
    DT.dropdown = {}
    if zji == true then
        for p, I in next, game.Players:GetChildren() do
            table.insert(DT.dropdown, I.Name)
        end
    else
        for p, I in next, game.Players:GetChildren() do
            if I ~= lp then
                table.insert(DT.dropdown, I.Name)
            end
        end
    end
end
shuaxinlb(true)
local win1 = library:CreateTab("斧头＆土地");
win1:NewToggle("自动扔斧头", "id随便", false, function(state)
    DT.autodropae = true
    if state then

        while wait() do

            if DT.autodropae == true then
                local oldpos = lp.Character.HumanoidRootPart.CFrame
                droptool(oldpos)
            end
        end
    else
        DT.autodropae = false
    end
    print(state)
end)
win1:NewToggle("自动捡斧头", "id", false, function(state)
    print(bool)
    if state then
        DT.autopick = true
        while DT.autopick == true do

            task.wait(0.1)
            for a, b in pairs(workspace.PlayerModels:GetChildren()) do
                if b:FindFirstChild("Owner") and b.Owner.Value == game.Players.LocalPlayer then
                    if b:FindFirstChild("Type") and b.Type.Value == "Tool" then

                        game:GetService('ReplicatedStorage').Interaction.ClientInteracted:FireServer(b, 'Pick up tool')

                    end
                end

            end
        end
    else
        DT.autopick = false
    end
	end)
win1:NewButton("远程装备斧头", function()
    farAxeEquip()
    print("btn3");
end)
win1:NewToggle("斧头炸家(电脑)", "i123", false, function(state)
    print(bool)
    if state then
        DT.whthmose = true
    else
        DT.whthmose = false
    end
	end)
win1:NewToggle("斧头炸家", "izane便", false, function(state)
    print(bool)
    if state then
        axefily()
    else
        if DT.axeFling then
            DT.axeFling:Disconnect(0.1);
            DT.axeFling = nil;
        end
    end
	end)
	win1:NewButton("土地区", function()
    print("btn3");
end)
win1:NewButton("点击获得土地", function()
    freeland=nil
    notify("道庭DT","请你点击一个空的土地",4)
    ClickToSelectClick = Mouse.Button1Up:Connect(function()
    Clicked = Mouse.Target
   
        if  tostring(Clicked.Parent.Name) == "Property" then
            local v =Clicked.Parent
        
            if v:FindFirstChild("Owner") and v.Owner.Value==nil then
                game.ReplicatedStorage.PropertyPurchasing.ClientPurchasedProperty:FireServer(v, v.OriginSquare.OriginCFrame.Value.p + Vector3.new(0, 3, 0))
                wait(0.5)
                freeland=true
                Instance.new('RemoteEvent', game:service 'ReplicatedStorage'.Interaction).Name = "Ban"
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.OriginSquare.CFrame +Vector3.new(0, 10, 0)
            else
                notify("道庭DT","这个土地有主人了",4)
       end
    end
    end)
repeat
    task.wait()
until freeland~=nil
    ClickToSelectClick:Disconnect()
    ClickToSelectClick=nil
    print("btn3");
end)
win1:NewButton("免费获得土地", function()
    for a, b in pairs(workspace.Properties:GetChildren()) do
        if b:FindFirstChild("Owner") and b:FindFirstChild("OriginSquare") and b.Owner.Value == nil then
            game.ReplicatedStorage.PropertyPurchasing.ClientPurchasedProperty:FireServer(b, b.OriginSquare.OriginCFrame
                .Value.p + Vector3.new(0, 3, 0))
            wait(0.5)
            Instance.new('RemoteEvent', game:service 'ReplicatedStorage'.Interaction).Name = "Ban"
            for i, v in pairs(game.Workspace.Properties:GetChildren()) do
                if v.Owner.Value == game.Players.LocalPlayer then
                    game.Players.LocalPlayer.Character.Humanoid.Jump = true
                    wait(0.1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.OriginSquare.CFrame +
                                                                                     Vector3.new(0, 10, 0)
                    game.Players.LocalPlayer.Character.Humanoid.Jump = true
                    wait(0.1)
                end
            end
        end
    end
    print("btn3");
end)
win1:NewButton("最大土地", function()
    for i, v in pairs(game:GetService("Workspace").Properties:GetChildren()) do
        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
            base = v
            square = v.OriginSquare
        end
    end
    function makebase(pos)
        local Event = game:GetService("ReplicatedStorage").PropertyPurchasing.ClientExpandedProperty
        Event:FireServer(base, pos)
    end
    spos = square.Position
    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z))
    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z))
    makebase(CFrame.new(spos.X, spos.Y, spos.Z + 40))
    makebase(CFrame.new(spos.X, spos.Y, spos.Z - 40))
    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z + 40))
    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z - 40))
    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z + 40))
    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z - 40))
    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z))
    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z))
    makebase(CFrame.new(spos.X, spos.Y, spos.Z + 80))
    makebase(CFrame.new(spos.X, spos.Y, spos.Z - 80))
    -- Corners--
    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z + 80))
    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z - 80))
    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z + 80))
    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z - 80))
    -- Corners--
    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z + 80))
    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z + 80))
    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z + 40))
    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z - 40))
    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z + 40))
    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z - 40))
    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z - 80))
    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z - 80))

    print("btn3");
end)

local win2 = library:CreateTab("存档＆木头");
win2:NewBox("选择存档", "请输入!", function(s)
    DT.soltnumber = s
    print(text);
end)
win2:NewButton("加载存档", function()
    ScriptLoadOrSave = true
    local CheckSlot = CheckSlotNumber()
    if CheckSlot ~= false then
        if CheckIfSlotAvailable(CheckSlot) == true then
            local LoadSlot = game.ReplicatedStorage.LoadSaveRequests.RequestLoad:InvokeServer(CheckSlot)
            if LoadSlot == false then
                notify("道庭DT", "有冷却现在不能加载!", 1)
            end
            if LoadSlot == true then
                notify("道庭DT", "已加载!", 2)
                CurrentSlot = CheckSlot
            end
        else
            notify("道庭DT", "貌似不工作了", 2)
        end
    else
        notify("道庭DT", "请你填数字☹️", 2)
    end
    ScriptLoadOrSave = false
    print("btn3");
end)
win2:NewButton("传送木板", function()
    local logFolder = getPlanks();
    local oldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame;
    for _, log in next, logFolder do
        if log:FindFirstChild('WoodSection') then

            spawn(function()
                for i = 1, 20 do

                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(log);
                    task.wait();
                end
            end)
            wait(0.18)
            if not log.PrimaryPart then
                log.PrimaryPart = log.WoodSection;
            end
            log:SetPrimaryPartCFrame(oldPos);
        end
    end
    print("btn3");
end)
win2:NewButton("传送木头", function()
    OldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    for i, v in next, game:GetService("Workspace").LogModels:GetChildren() do
        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
            if not v.PrimaryPart then
                v.PrimaryPart = v:FindFirstChild("WoodSection")
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                v:FindFirstChild("WoodSection").CFrame.p)
            spawn(function()
                for i = 1, 50 do
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                    task.wait()
                end
            end)
            for i = 1, 50 do
                task.wait()
                v:PivotTo(OldPos)
            end
            task.wait()
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
    print("btn3");
end)
win2:NewButton("卖木板", function()
    for _, Plank in pairs(game.Workspace.PlayerModels:GetChildren()) do
        if Plank.Name == "Plank" and Plank:findFirstChild("Owner") then
            if Plank.Owner.Value == game.Players.LocalPlayer then
                for i, v in pairs(Plank:GetChildren()) do
                    if v.Name == "WoodSection" then
                        spawn(function()
                            for i = 1, 100 do
                                wait()
                                v.CFrame = CFrame.new(Vector3.new(315, -0.296, 85.791)) *
                                               CFrame.Angles(math.rad(90), 0, 0)
                            end
                        end)
                    end
                end
                spawn(function()
                    for i = 1, 100 do
                        wait()
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Plank)
                    end
                end)
            end
        end
    end
    print("btn3");
end)
win2:NewButton("卖木头", function()
    sellwood()
    print("btn3");
end)
win2:NewToggle("自动卖木板", "id傻逼", false, function(state)
    print(bool)
    if win2.Text == "关1" then
        win2.Text = "开1"
    else
        win2.Text = "关1"
    end

    if state then
        while wait() do

            if win2.Text == "关1" then
                for _, Plank in pairs(game.Workspace.PlayerModels:GetChildren()) do
                    if Plank.Name == "Plank" and Plank:findFirstChild("Owner") then
                        if Plank.Owner.Value == game.Players.LocalPlayer then
                            for i, v in pairs(Plank:GetChildren()) do
                                if v.Name == "WoodSection" then
                                    spawn(function()
                                        for i = 1, 10 do
                                            wait()
                                            v.CFrame = CFrame.new(Vector3.new(315, -0.296, 85.791)) *
                                                           CFrame.Angles(math.rad(90), 0, 0)
                                        end
                                    end)
                                end
                            end
                            spawn(function()
                                for i = 1, 20 do
                                    wait()
                                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Plank)
                                end
                            end)
                        end

                    end
                end
            end
        end
    end
	end)
	win2:NewToggle("自动卖木头", "id114514", false, function(state)
	    if win2.Text == "关" then
        win2.Text = "开"
    else
        win2.Text = "关"
    end

    local oldpos = lp.Character.HumanoidRootPart.CFrame
    while wait() do
        if state then
            if win2.Text == "关" then
                sellwood()
            end
        end
    end
    print(bool)

	end)
	win1:NewToggle("拖拽器", "134567", false, function(state)
    if state then
        workspace.ChildAdded:connect(function(Dragger)
            if tostring(Dragger) == 'Dragger' then
                local BodyGyro = Dragger:WaitForChild 'BodyGyro';
                local BodyPosition = Dragger:WaitForChild 'BodyPosition';
                repeat
                    game:GetService 'RunService'.Stepped:wait()
                until workspace:FindFirstChild 'Dragger';

                BodyPosition.P = 120000;
                BodyPosition.D = 1000;
                BodyPosition.maxForce = Vector3.new(1, 1, 1) * 1000000;
                BodyGyro.maxTorque = Vector3.new(1, 1, 1) * 200;
                BodyGyro.P = 1200;
                BodyGyro.D = 140;

            end
        end)
    else

        workspace.ChildAdded:connect(function(Dragger)
            if tostring(Dragger) == 'Dragger' then
                local BodyGyro = Dragger:WaitForChild 'BodyGyro';
                local BodyPosition = Dragger:WaitForChild 'BodyPosition';
                repeat
                    game:GetService 'RunService'.Stepped:wait()
                until workspace:FindFirstChild 'Dragger';

                BodyPosition.P = 10000;
                BodyPosition.D = 800;
                BodyPosition.maxForce = Vector3.new(17000, 17000, 17000);
                BodyGyro.maxTorque = Vector3.new(200, 200, 200);
                BodyGyro.P = 1200;
                BodyGyro.D = 140;
            end
        end)

    end
    print(bool)

	end)
local win3 = library:CreateTab("处理木头＆带来树");
win3:NewButton("半自动处理树1", function()
    wait(0.5)
    local oldPosition = getPosition()
    local oldpos = lp.Character.HumanoidRootPart.CFrame
    local wood
    local sell = CFrame.new(314.943634, -6, 82.8602905, -0.999041438, -0.00970918871, 0.0426843949, -0.00323261251,
        0.988793433, 0.149255186, -0.0436551981, 0.148974136, -0.987876952)

    notify("半自动加工", "请点击一颗树", 4)

    local ModTree = Mouse.Button1Up:Connect(function()
        local obj = Mouse.Target.Parent
        if not obj:FindFirstChild "RootCut" and obj.Parent.Name == "TreeRegion" then
            return notify("错误!", "这棵树还没有砍!", 3)
        end
        if obj:FindFirstChild "Owner" and obj.Owner.Value == lp and obj:FindFirstChild "WoodSection" then
            wood = obj
            notify("半自动加工", "已选择树!", 3)
        end

    end)
    repeat
        task.wait(.01)
    until wood ~= nil
    ModTree:Disconnect()
    ModTree = nil

    tp(wood.WoodSection.CFrame)
    spawn(function()
        for i = 1, 20 do

            wood:PivotTo(sell)
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(wood)
            game:GetService('RunService').Stepped:wait();

        end
    end)
    task.wait(0.1)
    tp(wood.WoodSection.CFrame)
    task.wait(1.2)

    for i = 1, 20 do
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(wood)
        wood:MoveTo(oldPosition)
        game:GetService('RunService').Stepped:wait();

    end
    tp(oldpos)
    print("btn3");
end)
win3:NewButton("半自动处理树2", function()
    local oldpos = lp.Character.HumanoidRootPart.CFrame
    DT.modwood = true

    for _, Log in pairs(workspace.LogModels:GetChildren()) do
        if Log.Name:sub(1, 6) == "Loose_" and Log:findFirstChild("Owner") then
            if Log.Owner.Value == game.Players.LocalPlayer then
                for i, v in pairs(Log:GetChildren()) do
                    if v.Name == "WoodSection" then
                        if DT.modwood == true then
                            tp(v.CFrame)
                        end
                        wait(0.2)

                        spawn(function()
                            for i = 1, 20 do
                                if DT.modwood == true then
                                    task.wait()
                                    v.CFrame = CFrame.new(330.98587, -0.574430406, 79.0872726, -6, 0.000781620154,
                                        -0.0201439466, 0.000569172669, 0.99994421, 0.0105500417, 0.0201510694,
                                        0.0105364323, -0.999741435)
                                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Log)
                                end
                            end

                            wait(1)

                            for i = 1, 10 do
                                task.wait()
                                v.CFrame = oldpos
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Log)
                            end
                            DT.modwood = false
                        end)

                    end
                end

            end
        end
    end
    tp(oldpos)
    print("btn3");
end)
local this_table = {
"普通树",
"幻影木",
"沼泽黄金",
"樱花",
"蓝木",
"冰木",
"火山木",
"橡木",
"巧克力木",
"白桦木",
"黄金木",
"雪地松",
"僵尸木",
"大巧克力树",
"椰子树",
"南瓜木",
"幽灵木",
}
win3:NewDropdown("选择树", "这个有用", this_table, function(b)
        if b == '普通树' then
            DT.cuttreeselect = "Generic"
        elseif b == '沼泽黄金' then
            DT.cuttreeselect = "GoldSwampy"
        elseif b == '樱花' then
            DT.cuttreeselect = "Cherry"
        elseif b == '蓝木' then
            DT.cuttreeselect = "CaveCrawler"
        elseif b == '冰木' then
            DT.cuttreeselect = "Frost"
        elseif b == '火山木' then
            DT.cuttreeselect = "Volcano"
        elseif b == '橡木' then
            DT.cuttreeselect = "Oak"
        elseif b == '巧克力木' then
            DT.cuttreeselect = "Walnut"
        elseif b == '白桦木' then
            DT.cuttreeselect = "Birch"
        elseif b == '黄金木' then
            DT.cuttreeselect = "SnowGlow"
        elseif b == '雪地松' then
            DT.cuttreeselect = "Pine"
        elseif b == '僵尸木' then
            DT.cuttreeselect = "GreenSwampy"
        elseif b == '大巧克力树' then
            DT.cuttreeselect = "Koa"
        elseif b == '椰子树' then
            DT.cuttreeselect = "Palm"
        elseif b == '幽灵木' then
            DT.cuttreeselect = "Spooky"
        elseif b == '南瓜木' then
            DT.cuttreeselect = "SpookyNeon"
        elseif b == '幻影木' then
            DT.cuttreeselect = "LoneCave"
        end
	print(item);
end)
win3:NewBox("带来树的数量", "请输入!", function(txt)
    DT.bringamount = txt
    print(text);
end)
win3:NewButton("带来树", function()
    DT.bringtree = true
    DT.treecutset = lp.Character.HumanoidRootPart.CFrame
    task.wait(0.2)
    for i = 1, DT.bringamount do
        if DT.bringtree == true then
            task.wait()
            bringTree(DT.cuttreeselect)
        end

    end
    task.wait()

    print("btn3");
end)
win3:NewButton("停止带来树", function()
    DT.bringtree = false
    print("btn3");
end)
win3:NewToggle("自动砍树", "1145146随便", false, function(state)
    if state then
        DT.autofarm = true
        task.spawn(function()
            while task.wait(0.3) do

                if DT.autofarm == true then

                    bringTree(DT.cuttreeselect)

                end
            end
        end)
    else
        DT.autofarm = false

    end
    print(bool)

	end)
	win1:NewToggle("自动赚钱", "id随便", false, function(state)
	  local oldpos = lp.Character.HumanoidRootPart.CFrame

    if state then
        DT.autofarm1 = true
        local function callback(Text)
            if Text == "确定" then
                pcall(function()

                    while task.wait() do
                        if DT.autofarm1 == true then
                            game:GetService("Players").LocalPlayer.Character:MoveTo(Vector3.new(315, -0.296, 102.791));

                            autofarm(DT.cuttreeselect)

                            wait(1)
                            game:GetService("Players").LocalPlayer.Character:MoveTo(Vector3.new(315, -0.296, 102.791));

                            wait(20)
                        end
                    end
                end)

            elseif Text == "取消" then

            end
        end

        local NotificationBindable = Instance.new("BindableFunction")
        NotificationBindable.OnInvoke = callback
        --
        game.StarterGui:SetCore("SendNotification", {
            Title = "道庭DT",
            Text = "使用此功能前请你打开自动卖木头",
            Icon = "",
            Duration = 6,
            Button1 = "确定",
            Button2 = "取消",
            Callback = NotificationBindable
        })
    else
        DT.autofarm1 = false
        for i, v in pairs(game.Workspace.Properties:GetChildren()) do
            if v.Owner.Value == game.Players.LocalPlayer then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.OriginSquare.CFrame +
                                                                                 Vector3.new(0, 10, 0)
            end
        end
    end
    print(bool)

	end)
	win3:NewButton("用木板填充蓝图", function()
	    PlankToBlueprint()
    print("btn3");
end)

win3:NewToggle("查看幻影木", "id9999", false, function(state)
    print(bool)
    if state then

        for i, v in pairs(game.workspace:GetChildren()) do
            if v.Name == "TreeRegion" and v:FindFirstChildOfClass("Model") then
                if v.Model.TreeClass.Value == "LoneCave" then
                    workspace.Camera.CameraSubject = v.Model.WoodSection
                    task.wait()
                end
            end
        end

    else
        workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character

    end
	end)
	win3:NewButton("锯木机最大体型", function()
	    local connection, sawmillModel;
    notify('道庭DT', '选择一个剧木机', 4)
    connection = mouse.Button1Down:Connect(function(b)
        local target = mouse.Target;
        if target then
            sawmill = target.Parent;
            if sawmill.Name:find('Sawmill') then
                sawmillModel = sawmill;
                notify('道庭DT', '剧木机已选择', 4)
            elseif sawmill.Parent.Name:find('Sawmill') or sawmill.Parent:FindFirstChild 'BlockageAlert' then
                sawmillModel = sawmill.Parent
                notify('道庭DT', '剧木机已选择', 4)
            end
        end
    end);
    repeat
        wait()
    until sawmillModel ~= nil;
    if connection then
        connection:Disconnect();
        connection = nil;
    end
    spawn(function()
        for i = 1, 50 do
            game:GetService('ReplicatedStorage').Interaction.RemoteProxy:FireServer(
                sawmillModel:FindFirstChild 'ButtonRemote_XUp');
            task.wait(0.5)
            game:GetService('ReplicatedStorage').Interaction.RemoteProxy:FireServer(
                sawmillModel:FindFirstChild 'ButtonRemote_YUp');

        end
    end);
    print("btn3");
end)
win3:NewToggle("把木头切割成一个单位长度", "id0000", false, function(state)
     local oldpos = lp.Character.HumanoidRootPart.CFrame

    if state then
        PlankReAdded = game:GetService("Workspace").PlayerModels.ChildAdded:Connect(function(v)
            if v:WaitForChild("TreeClass") and v:WaitForChild("WoodSection") then
                SelTree = v
                task.wait()
            end
        end)
        UnitCutterClick = Mouse.Button1Up:Connect(function()
            Clicked = Mouse.Target

            if Clicked.Name == "WoodSection" then
                SelTree = Clicked.Parent
                game.Players.LocalPlayer.Character:MoveTo(Clicked.Position + Vector3.new(0, 3, -3))
                local success, data = getBestAxe(SelTree.TreeClass.Value)
                repeat
                    if state == false then
                        break
                    end
                    cutPart(SelTree.CutEvent, 1, 1, data, SelTree.TreeClass.Value)
                    if SelTree:FindFirstChild("Cut") then
                        game.Players.LocalPlayer.Character:MoveTo(
                            SelTree:FindFirstChild("Cut").Position + Vector3.new(0, 3, -3))
                    end
                    task.wait()
                until SelTree.WoodSection.Size.X <= 1.88 and SelTree.WoodSection.Size.Y <= 1.88 and
                    SelTree.WoodSection.Size.Z <= 1.88 or state == false
            end
        end)

    else
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
        UnitCutterClick:Disconnect()
        UnitCutterClick = nil
        PlankReAdded:Disconnect()
        PlankReAdded = nil
    end
       print(bool)

	end)
	win3:NewButton("分解树", function()
	    OldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local LogChopped = false
    branchadded = game:GetService("Workspace").LogModels.ChildAdded:Connect(function(v)
        if v:WaitForChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
            if v:WaitForChild("WoodSection") then
                LogChopped = true
            end
        end
    end)
    notify("道庭DT", "请你点击一棵树", 4)

    DismemberTreeC = Mouse.Button1Up:Connect(function()
        Clicked = Mouse.Target
        if Clicked.Parent:FindFirstAncestor("LogModels") then
            if Clicked.Parent:FindFirstChild("Owner") and Clicked.Parent.Owner.Value == game.Players.LocalPlayer then
                TreeToJointCut = Clicked.Parent
            end
        end
    end)
    repeat
        task.wait()
    until tostring(TreeToJointCut) ~= "nil"

    for i, v in next, TreeToJointCut:GetChildren() do
        if v.Name == "WoodSection" then
            if v:FindFirstChild("ID") and v.ID.Value ~= 1 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.CFrame.p)
                local success, data = getBestAxe(v.Parent:FindFirstChild("TreeClass").Value)
                repeat
                    cutPart(v.Parent:FindFirstChild("CutEvent"), v.ID.Value, 0.2, data,
                        v.Parent:FindFirstChild("TreeClass").Value)
                    task.wait()
                until LogChopped == true
                LogChopped = false
                task.wait(1)
            end
        end
    end
    TreeToJointCut = nil
    branchadded:Disconnect()
    DismemberTreeC:Disconnect()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
    print("btn3");
end)
win3:NewButton("处理树(自动)", function()
    local wood
    local Saw
    local sell = CFrame.new(315, -4, 84)
    notify("一键加工", "请点击一颗树,再点击一个锯木机", 4)
    wait(0.5)
    local oldPosition = getPosition()
    local oldpos = lp.Character.HumanoidRootPart.CFrame
    local ModTree = Mouse.Button1Up:Connect(function()
        local obj = Mouse.Target.Parent
        if not obj:FindFirstChild "RootCut" and obj.Parent.Name == "TreeRegion" then
            return notify("错误!", "这棵树还没有砍!", 3)
        end
        if obj:FindFirstChild "Owner" and obj.Owner.Value == lp and obj:FindFirstChild "WoodSection" then
            wood = obj
            notify("一键加工", "已选择树!", 3)
        end

        if obj.Name:find('Sawmill') then
            Saw = sawmill;
            notify('道庭DT', '剧木机已选择', 4)
        elseif obj.Parent.Name:find('Sawmill') or obj.Parent:FindFirstChild 'BlockageAlert' then
            Saw = obj.Parent
            notify('道庭DT', '剧木机已选择', 4)
        end

    end)
    repeat
        task.wait(.01)
    until wood and Saw ~= nil
    ModTree:Disconnect()
    ModTree = nil
    local SawC = Saw.Particles.CFrame + Vector3.new(0.7, 0)
    tp(wood.WoodSection.CFrame)
    spawn(function()
        for i = 1, 20 do

            wood:SetPrimaryPartCFrame(sell)
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(wood)
            game:GetService('RunService').Stepped:wait();

        end
    end)
    task.wait(0.3)
    tp(wood.WoodSection.CFrame)
    task.wait(1)
    for i = 1, 20 do
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(wood)
        wood:MoveTo(oldPosition)
        game:GetService('RunService').Stepped:wait();

    end
    tp(oldpos)
    pcall(function()
        spawn(function()
            for i = 1, 200 do
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(wood)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(wood)

                wood:SetPrimaryPartCFrame(SawC)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(wood)

                task.wait()

            end
        end)
    end)

    Teleport(oldpos)
    print("btn3");
end)
win3:NewButton("删除树/木板", function()
    local a = game:GetService("ReplicatedStorage")
    local b = game:GetService("Players").LocalPlayer
    local c = b:GetMouse()
    local f = Instance.new("Tool", b.Backpack)
    f.Name = "点击你要删除的树或木板"
    f.RequiresHandle = false
    f.Activated:Connect(function()
        local g = c.Target.Parent
        local h = b.Character.HumanoidRootPart.CFrame
        if not g:FindFirstChild "WoodSection" then
            return
        end
        local i
        if g:FindFirstChild "Owner" and g.Owner.Value == b or g.Owner.Value == nil then
            if not g:FindFirstChild "RootCut" and g.Parent.Name == "TreeRegion" then
                for e, j in next, g:children() do
                    if j.Name == "WoodSection" and j:FindFirstChild "ID" and j:FindFirstChild "ID".Value == tonumber(1) then
                        i = j
                    end
                end
            else
                i = g.WoodSection
            end
            tp(i.CFrame)
            for e = 1, 3 do
                spawn(function()
                    for e = 1, 20 do

                        a.Interaction.ClientIsDragging:FireServer(g)
                        a.Interaction.DestroyStructure:FireServer(g)
                        game:GetService('RunService').Stepped:wait();

                    end
                end)
                task.wait(.1)
            end
        else
            return
        end
        task.wait()
        tp(h)
    end)
    f.Parent = game.Players.LocalPlayer.Backpack
    print("btn3");
end)
local win4 = library:CreateTab("娱乐");
win4:NewBox("你要说的话", "请输入!", function(txt)
    DT.saymege = txt
    print(text);
end)
win4:NewBox("说话次数", "请输入!", function(txt)
    DT.saymount = txt
    print(text);
end)
win4:NewButton("开始说话", function()
    DT.sayfast = true
    for i = 1, DT.saymount do
        if DT.sayfast == true then
            game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer(DT.saymege,
                'All')
        end
    end
    print("btn3");
end)
win4:NewButton("停止说话", function()
    DT.sayfast = false
    print("btn3");
end)
win4:NewToggle("全自动说话", "id19784", false, function(state)
    if state then
        DT.autosay = true
        while task.wait() do
            if DT.autosay == true then
                game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                    DT.saymege, 'All')

            end
        end
    else
        DT.autosay = false
    end
    print(bool)

	end)
	win4:NewDropdown("选择玩家", "用", DT.dropdown, function(v)
	    DT.moneytoplayername = v
	print(item);
end)
win4:NewButton("刷新列表", function()
    shuaxinlb(true)
    dropdown:SetOptions(DT.dropdown)
    print("btn3");
end)
win4:NewBox("给玩家转钱的数量", "请输入!", function(txt)
    DT.moneyaoumt = txt
    print(text);
end)
win4:NewButton("开始转钱", function()
    donate(DT.moneytoplayername, DT.moneyaoumt)
    print("btn3");
end)
win4:NewButton("小工具", function()
    if lp.Backpack:FindFirstChildOfClass 'HopperBin' then
        return
    end
    for index = 1, 4 do
        Instance.new('HopperBin', lp.Backpack).BinType = index
    end
    print("btn3");
end)
win4:NewToggle("远程打开东西", "77646便", false, function(state)
    if state then
        notify('道庭DT', '选择一个东西去打开', 4)
        DT.openItem = mouse.Button1Down:Connect(function()
            if mouse.Target then
                DT.itemtoopen = mouse.Target;
            end
            OpenSelectedItem(DT.itemtoopen.Parent);
        end)
    else
        if DT.openItem then
            DT.openItem:Disconnect();
            DT.openItem = nil;
        end
        notify('道庭DT', '打开东西已关闭', 4)
        DT.itemToOpen = nil;
    end
    print(bool)

	end)

local win5= library:CreateTab("整理木头");
win5:NewDropdown("选择玩家", "这个用", DT.dropdown, function(v)
    DT.mtwjia = v
	print(item);
end)
	win5:NewButton("重置名称", function()
	    shuaxinlb(true)
    Players:SetOptions(DT.dropdown)
    print("btn3");
end)
local this_table = {
"普通树", "沼泽黄金", "樱花", "蓝木", "冰木", "火山木", "橡木", "巧克力木", "白桦木",
     "黄金木", "雪地松", "僵尸木", "大巧克力树", "椰子树", '幻影', '幽灵木', '南瓜木'}
win5:NewDropdown("选择木头", "这个有用", this_table, function(b)
        if b == '普通树' then
            DT.zlmt = "Generic"
        elseif b == '沼泽黄金' then
            DT.zlmt = "GoldSwampy"
        elseif b == '樱花' then
            DT.zlmt = "Cherry"
        elseif b == '蓝木' then
            DT.zlmt = "CaveCrawler"
        elseif b == '冰木' then
            DT.zlmt = "Frost"
        elseif b == '火山木' then
            DT.zlmt = "Volcano"
        elseif b == '橡木' then
            DT.zlmt = "Oak"
        elseif b == '巧克力木' then
            DT.zlmt = "Walnut"
        elseif b == '白桦木' then
            DT.zlmt = "Birch"
        elseif b == '黄金木' then
            DT.zlmt = "SnowGlow"
        elseif b == '雪地松' then
            DT.zlmt = "Pine"
        elseif b == '僵尸木' then
            DT.zlmt = "GreenSwampy"
        elseif b == '大巧克力树' then
            DT.zlmt = "Koa"
        elseif b == '椰子树' then
            DT.zlmt = "Palm"
        elseif b == '幻影' then
            DT.zlmt = "LoneCave"
        elseif b == '幽灵木' then
            DT.zlmt = "Spooky"
        elseif b == '南瓜木' then
            DT.zlmt = "SpookyNeon"
        end
	print(item);
end)
win5:NewToggle("竖着整理木头", "id46769457376", false, function(state)
    print(bool)
        if state then

        DT.shuzhe = true
    else
        DT.shuzhe = false

    end

	end)
		win5:NewButton("开始整理", function()
		    if DT.zlmt == nil then
        return notify("道庭DT", "你没有选择木头", 4)
    end
    if DT.shuzhe == false then
        local oldpos = lp.Character.HumanoidRootPart.Position

        for _, Plank in pairs(game.Workspace.PlayerModels:GetChildren()) do
            if Plank.Name == "Plank" and Plank:findFirstChild("Owner") then
                if Plank:FindFirstChild("Owner") and tostring(Plank.Owner.Value) == DT.mtwjia then
                    if Plank.TreeClass.Value == DT.zlmt then
                        tp(Plank.WoodSection.CFrame)
                        for i = 1, 50 do
                            game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(Plank)
                            Plank.WoodSection.Position = oldpos
                            game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(Plank)

                            game:GetService('RunService').Stepped:wait();
                        end
                    end
                end
            end
        end
    else
        local oldpos = lp.Character.HumanoidRootPart.CFrame

        for _, Plank in pairs(game.Workspace.PlayerModels:GetChildren()) do
            if Plank.Name == "Plank" and Plank:findFirstChild("Owner") then
                if Plank:FindFirstChild("Owner") and tostring(Plank.Owner.Value) == DT.mtwjia then
                    if Plank.TreeClass.Value == DT.zlmt then
                        tp(Plank.WoodSection.CFrame)
                        for i = 1, 50 do
                            game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(Plank)
                            Plank.WoodSection.CFrame = oldpos
                            game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(Plank)

                            game:GetService('RunService').Stepped:wait();
                        end
                    end
                end
            end
        end
    end
    print("btn3");
end)
local this_table = {
"普通树", "沼泽黄金", "樱花", "蓝木", "冰木", "火山木", "橡木", "巧克力木", "白桦木",
     "黄金木", "雪地松", "僵尸木", "大巧克力树", "椰子树", '幻影'}
win1:NewDropdown("选择木头填充蓝图", "这个11", this_table, function(b)
        if b == '普通树' then
            DT.tchonmt = "Generic"
        elseif b == '沼泽黄金' then
            DT.tchonmt = "GoldSwampy"
        elseif b == '樱花' then
            DT.tchonmt = "Cherry"
        elseif b == '蓝木' then
            DT.tchonmt = "CaveCrawler"
        elseif b == '冰木' then
            DT.tchonmt = "Frost"
        elseif b == '火山木' then
            DT.tchonmt = "Volcano"
        elseif b == '橡木' then
            DT.tchonmt = "Oak"
        elseif b == '巧克力木' then
            DT.tchonmt = "Walnut"
        elseif b == '白桦木' then
            DT.tchonmt = "Birch"
        elseif b == '黄金木' then
            DT.tchonmt = "SnowGlow"
        elseif b == '雪地松' then
            DT.tchonmt = "Pine"
        elseif b == '僵尸木' then
            DT.tchonmt = "GreenSwampy"
        elseif b == '大巧克力树' then
            DT.tchonmt = "Koa"
        elseif b == '椰子树' then
            DT.tchonmt = "Palm"
        elseif b == '幻影' then
            DT.tchonmt = "LoneCave"
        end
	print(item);
end)
	win5:NewButton("填充蓝图(木头)", function()
	    local plr = game:GetService("Players").LocalPlayer
    local tool = Instance.new("Tool", plr.Backpack)
    tool.RequiresHandle = false
    tool.Name = "点击一块蓝图"
    tool.Activated:Connect(function()
        local str = getMouseTarget().Parent
        if str:FindFirstChild("Type") and str.Type.Value == "Blueprint" and str:FindFirstChild("Owner") then
            lumbsmasher_legitpaint(DT.tchonmt, str, true)
        end
    end)
    print("btn3");
end)
	win5:NewButton("填充蓝图(全部)", function()
	    for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do

        if v:FindFirstChild("Type") and v.Type.Value == "Blueprint" and v:FindFirstChild("Owner") then
            if v.Owner.Value == lp then

                lumbsmasher_legitpaint(DT.tchonmt, v, true)

                task.wait()
            end

        end

    end
    print("btn3");
end)

	local this_table = {
'出生点', '木材反斗城', '土地商店', '桥', '码头', '椰子岛', '洞穴', '鲨鱼斧合成',
     '火山', '沼泽', '家具店', '盒子车行', '连锁逻辑店', '鲍勃的小店', '画廊', '雪山',
     '灵视神殿', '怪人', '小绿盒', '滑雪小屋', '黄金木洞穴', '小鸟斧头', "灯塔", '回家'}
win5:NewDropdown("选择传送地点", "这个有用", this_table, function(b)
        if b == '木材反斗城' then
            carTeleport(CFrame.new(270, 4, 60));
        elseif b == '出生点' then
            carTeleport(CFrame.new(174, 10.5, 66));
        elseif b == '土地商店' then
            carTeleport(CFrame.new(270, 3, -98));
        elseif b == '桥' then
            carTeleport(CFrame.new(112, 37, -892));
        elseif b == '码头' then
            carTeleport(CFrame.new(1136, 0, -206));
        elseif b == '椰子岛' then
            carTeleport(CFrame.new(2614, -4, -34));
        elseif b == '洞穴' then
            carTeleport(CFrame.new(3590, -177, 415));
        elseif b == '火山' then
            carTeleport(CFrame.new(-1588, 623, 1069));
        elseif b == '沼泽' then
            carTeleport(CFrame.new(-1216, 131, -822));
        elseif b == '家具店' then
            carTeleport(CFrame.new(486, 3, -1722));
        elseif b == '盒子车行' then
            carTeleport(CFrame.new(509, 3, -1458));
        elseif b == '雪山' then
            carTeleport(CFrame.new(1487, 415, 3259));
        elseif b == '连锁逻辑店' then
            carTeleport(CFrame.new(4615, 7, -794));
        elseif b == '鲍勃的小店' then
            carTeleport(CFrame.new(292, 8, -2544));
        elseif b == '画廊' then
            carTeleport(CFrame.new(5217, -166, 721));
        elseif b == '灵视神殿' then
            carTeleport(CFrame.new(-1608, 195, 928));
        elseif b == '怪人' then
            carTeleport(CFrame.new(1071, 16, 1141));
        elseif b == '小绿盒' then
            carTeleport(CFrame.new(-1667, 349, 1474));
        elseif b == '滑雪小屋' then
            carTeleport(CFrame.new(1244, 59, 2290));
        elseif b == '黄金木洞穴' then
            carTeleport(CFrame.new(-1080, -5, -942));
        elseif b == '鲨鱼斧合成' then
            carTeleport(CFrame.new(330.259735, 45.7998505, 1943.30823, 0.972010553, -8.07546598e-08, 0.234937176,
                7.63610259e-08, 1, 2.77986647e-08, -0.234937176, -9.08055142e-09, 0.972010553))
        elseif b == '小鸟斧头' then
            carTeleport(CFrame.new(4813.1, 33.5, -978.8));
        elseif b == '灯塔' then
            carTeleport(CFrame.new(1464.8, 356.3, 3257.2));
        else
            if b == '回家' then
                for i, v in pairs(game.Workspace.Properties:GetChildren()) do
                    if v.Owner.Value == game.Players.LocalPlayer then
                        carTeleport(v.OriginSquare.CFrame + Vector3.new(0, 10, 0))
                    end
                end
            end
        end
	print(item);
end)

local this_table = {
"普通树", "沼泽黄金", "樱花", "蓝木", "冰木", "火山木", "橡木", "巧克力木", "白桦木",
     "黄金木", "雪地松", "僵尸木", "大巧克力树", "椰子树", "幻影木"}
win5:NewDropdown("传送到树", "这个有用", this_table, function(b)
        if b == '普通树' then
            DT.tptree = "Generic"
        elseif b == '沼泽黄金' then
            DT.tptree = "GoldSwampy"
        elseif b == '樱花' then
            DT.tptree = "Cherry"
        elseif b == '蓝木' then
            DT.tptree = "CaveCrawler"
        elseif b == '冰木' then
            DT.tptree = "Frost"
        elseif b == '火山木' then
            DT.tptree = "Volcano"
        elseif b == '橡木' then
            DT.tptree = "Oak"
        elseif b == '巧克力木' then
            DT.tptree = "Walnut"
        elseif b == '白桦木' then
            DT.tptree = "Birch"
        elseif b == '黄金木' then
            DT.tptree = "SnowGlow"
        elseif b == '雪地松' then
            DT.tptree = "Pine"
        elseif b == '僵尸木' then
            DT.tptree = "GreenSwampy"
        elseif b == '大巧克力树' then
            DT.tptree = "Koa"
        elseif b == '椰子树' then
            DT.tptree = "Palm"
        elseif b == '幻影木' then
            DT.tptree = "LoneCave"
        end
        for i, v in pairs(game.Workspace:GetChildren()) do
            if v.Name == "TreeRegion" then
                for j, k in ipairs(v:GetChildren()) do
                    if k:FindFirstChild("TreeClass") and k.TreeClass.Value == DT.tptree then
                        game.Players.LocalPlayer.Character:MoveTo(k.WoodSection.Position)
                        break
                    end
                end
            end
        end
	print(item);
end)
local win6= library:CreateTab("整理物品＆传送物品");
win6:NewDropdown("选择玩家", "这个有用", DT.dropdown, function(v)
    DT.zlwjia = v
	print(item);
end)
	win6:NewButton("重置名称", function()
	    shuaxinlb(true)
    Players:SetOptions(DT.dropdown)
    print("btn3");
end)
win6:NewBox("x轴", "请输入!", function(txt)
    DT.zix = txt
    print(text);
end)
win6:NewBox("z轴", "请输入!", function(txt)
    DT.zlz = txt

    print(text);
end)
	win6:NewButton("整理工具", function()
	    Identify = Instance.new("Tool")
    Identify.RequiresHandle = false;
    Identify.Name = "点击要整理的物品"
    Identify.Activated:connect(function()
        local Player = game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 4, 0)
        local Items = {}
        if mouse.Target.Parent:FindFirstChild("PurchasedBoxItemName") then
            DT.dxmz = (mouse.Target.Parent.PurchasedBoxItemName.Value)

            function ItemStacker(ItemType, XAxis, ZAxis)
                for i, v in pairs(game:GetService("Workspace").PlayerModels:GetChildren()) do
                    if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == DT.zlwjia then
                        if v:FindFirstChild("PurchasedBoxItemName") and tostring(v.PurchasedBoxItemName.Value) ==
                            ItemType then
                            table.insert(Items, v)

                        end
                    end
                end
                local Count = 0
                for Y = 1, math.ceil(#Items / (XAxis * ZAxis)) do
                    for X = 1, XAxis do
                        for Z = 1, ZAxis do
                            Count = Count + 1
                            tp(Items[Count].Main.CFrame + Vector3.new(3, 0, 3))
                            for e = 1, 40 do

                                game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(
                                    Items[Count])
                                Items[Count].Main.CFrame = CFrame.new(X * Items[1].Main.Size.X,
                                    Y * Items[1].Main.Size.Y, Z * Items[1].Main.Size.Z) + Player
                                game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(
                                    Items[Count])
                                game:GetService('RunService').Stepped:wait();
                            end

                        end
                    end
                end
            end

            ItemStacker(DT.dxmz, DT.zlz, DT.zix)
            notify('', '' .. mouse.Target.Parent.PurchasedBoxItemName.Value, 5)

        elseif mouse.Target.Parent:FindFirstChild("ItemName") then

            DT.dxmz = (mouse.Target.Parent.ItemName.Value)
            local Player = game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 5.5, 0)

            function ItemStackerft(ItemType, XAxis, ZAxis)
                for i, v in pairs(game:GetService("Workspace").PlayerModels:GetChildren()) do

                    if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == DT.zlwjia then
                        if (v:FindFirstChild 'DraggableItem' and tostring(v.DraggableItem.Parent) == ItemType) then
                            table.insert(Items, v)
                        end
                    end
                end
                local Count = 0
                for Y = 1, math.ceil(#Items / (XAxis * ZAxis)) do
                    for X = 1, XAxis do
                        for Z = 1, ZAxis do
                            Count = Count + 1
                            tp(Items[Count].Main.CFrame + Vector3.new(3, 0, 3))

                            for e = 1, 40 do

                                game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(
                                    Items[Count])
                                Items[Count].Main.CFrame = CFrame.new(X * Items[1].Main.Size.X,
                                    Y * Items[1].Main.Size.Y, Z * Items[1].Main.Size.Z) + Player
                                game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(
                                    Items[Count])
                                game:GetService('RunService').Stepped:wait();
                            end

                        end
                    end
                end
            end
            ItemStackerft(DT.dxmz, DT.zlz, DT.zix)
            notify('', '' .. mouse.Target.Parent.ItemName.Value, 5)
        end
    end)
    Identify.Parent = game.Players.LocalPlayer.Backpack
    print("btn3");
end)
win6:NewDropdown("选择玩家", "这个1", DT.dropdown, function(v)
    DT.cswjia = v
	print(item);
	
end)
win6:NewButton("重置玩家名称", function()
     shuaxinlb(true)
    Players:SetOptions(DT.dropdown)
       print("btn3");
    
end)
win6:NewButton("设置传送点", function()
    pcall(function()
        game.Workspace.DTBasedropCord:Destroy();
        DT.itemset = nil
    end)
    local DTBasedropCord = Instance.new("Part", game.Workspace)
    DTBasedropCord.CanCollide = false
    DTBasedropCord.Anchored = true
    DTBasedropCord.Shape = Enum.PartType.Ball
    DTBasedropCord.Color = Color3.fromRGB(0, 217, 255);
    DTBasedropCord.Transparency = 0
    DTBasedropCord.Size = Vector3.new(2, 2, 2)
    DTBasedropCord.CFrame = lp.Character.HumanoidRootPart.CFrame
    DTBasedropCord.Material = Enum.Material.Marble
    DTBasedropCord.Name = "DTBasedropCord"

    DT.itemset = lp.Character.HumanoidRootPart.CFrame
    print("btn3");
end)win6:NewButton("删除传送点", function()
    pcall(function()
        game.Workspace.DTBasedropCord:Destroy();
        DT.itemset = nil
    end)

    print("btn3");
end)win6:NewButton("获得传送工具", function()
      if DT.itemset == nil then
        return notify("道庭DT", "请你放传送点", 4)
    end
    local Tool = Instance.new("Tool", game:GetService("Players").LocalPlayer.Backpack)
    Tool.Name = "点击你想要传送的物品"
    Tool.RequiresHandle = false;

    Tool.Activated:connect(function()

        DT.cskais = true
        if mouse.Target.Parent:FindFirstChild("PurchasedBoxItemName") then

            DT.dxmz = (mouse.Target.Parent.PurchasedBoxItemName.Value)

        elseif mouse.Target.Parent:FindFirstChild("ItemName") then
            DT.dxmz = (mouse.Target.Parent.ItemName.Value)

        end

        for _, v in next, workspace.PlayerModels:children() do
            local check = v:FindFirstChild('ItemName') or v:FindFirstChild('PurchasedBoxItemName');
            local check2 = v:FindFirstChild 'Type'
            local main
            if DT.cskais == true then

                if check and check.Value == DT.dxmz and v:FindFirstChild('Owner') and tostring(v.Owner.Value) ==
                    DT.cswjia or check2 and check2.Value == DT.dxmz and v:FindFirstChild('Owner') and
                    tostring(v.Owner.Value) == DT.cswjia then
                    local main = v:FindFirstChild 'Main';
                    if (lp.Character.HumanoidRootPart.CFrame.p - main.CFrame.p).magnitude > 5 then
                        tp(v.Main.CFrame + Vector3.new(4, 0, 4))
                    end

                    for e = 1, 20 do

                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                        v.Main.CFrame = DT.itemset
                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                        game:GetService('RunService').Stepped:wait();
                    end

                end
            end
        end

    end)
    Tool.Parent = game.Players.LocalPlayer.Backpack
      print("btn3");
end)
win6:NewToggle("选择传送物品", "64518976734随便", false, function(state)
    print(bool)
    if state then
        ClickToSelectClick = Mouse.Button1Up:Connect(function()
            Clicked = Mouse.Target
            if Clicked.Parent:FindFirstChild("Owner") and tostring(Clicked.Parent.Owner.Value) == DT.cswjia then
                if Clicked.Parent:FindFirstAncestor("PlayerModels") then
                    if not Clicked.Parent:FindFirstChild("SelectionBox") then
                        local SB = Instance.new("SelectionBox", Clicked.Parent)
                        SB.Adornee = Clicked.Parent
                    else
                        Clicked.Parent:FindFirstChild("SelectionBox"):Destroy()
                    end
                end
            end
        end)
    else
        ClickToSelectClick:Disconnect()
    end
	end)
win6:NewButton("取消选择", function()
    for i, v in next, game:GetService("Workspace").PlayerModels:GetChildren() do
        if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == DT.cswjia then
            if v:FindFirstChild("SelectionBox") then
                v.SelectionBox:Destroy()
            end
        end
    end
    print("btn3");
    
end)
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(4, 0, 255)
Frame.BackgroundTransparency = 0.8
Frame.BorderColor3 = Color3.new(0.09, 0.137, 0.776)
Frame.BorderSizePixel = 2
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.Size = UDim2.new(0, 0, 0, 0)
function is_in_frame(screenpos, frame)
    local xPos = frame.AbsolutePosition.X
    local yPos = frame.AbsolutePosition.Y

    local xSize = frame.AbsoluteSize.X
    local ySize = frame.AbsoluteSize.Y

    local check1 = screenpos.X >= xPos and screenpos.X <= xPos + xSize
    local check2 = screenpos.X <= xPos and screenpos.X >= xPos + xSize

    local check3 = screenpos.Y >= yPos and screenpos.Y <= yPos + ySize
    local check4 = screenpos.Y <= yPos and screenpos.Y >= yPos + ySize

    local finale = (check1 and check3) or (check2 and check3) or (check1 and check4) or (check2 and check4)

    return finale
end

win6:NewToggle("框选物品", "64664346199随便", false, function(state)
    if state then
        DT.kuangxiu = game:GetService("UserInputService").InputBegan:Connect(function(cilk)

            if cilk.UserInputType == Enum.UserInputType.MouseButton1 then
                Frame.Visible = true
                Frame.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)

                while game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    game:GetService("RunService").RenderStepped:wait()
                    Frame.Size = UDim2.new(0, Mouse.X, 0, Mouse.Y) - Frame.Position

                    for i, v in pairs(workspace.PlayerModels:GetChildren()) do
                        if DT.xzemuban == true and v:FindFirstChild("Owner") and tostring(v.Owner.Value) == DT.cswjia and
                            v:FindFirstChild("WoodSection") then
                            local screenpos, visible = game.Workspace.CurrentCamera:WorldToScreenPoint(v.WoodSection
                                                                                                           .CFrame.p)
                            if visible then
                                if is_in_frame(screenpos, Frame) then
                                    if not v:FindFirstChild("SelectionBox") then
                                        local SB = Instance.new("SelectionBox", v)
                                        SB.Adornee = v
                                    end
                                end
                            end
                        end
                        if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == DT.cswjia and
                            v:FindFirstChild("Main") then
                            local screenpos, visible = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Main.CFrame.p)
                            if visible then
                                if is_in_frame(screenpos, Frame) then
                                    if not v:FindFirstChild("SelectionBox") then
                                        local SB = Instance.new("SelectionBox", v)
                                        SB.Adornee = v
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Frame.Size = UDim2.new(0, 1, 0, 1)
            Frame.Visible = false

        end)
    else
        Frame.Visible = false
        DT.kuangxiu:Disconnect()
        DT.kuangxiu = nil
    end
    print(bool)

	end)
win6:NewToggle("带木板", "id随便", false, function(state)
    DT.xzemuban = state

    print(bool)

	end)
	win6:NewButton("开始传送物品", function()
	    if DT.itemset == nil then
        return notify("道庭DT", "请你放传送点", 4)
    end
    DT.cskais = true
    OldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    for i, v in next, game:GetService("Workspace").PlayerModels:GetChildren() do
        if DT.cskais == false then
            break
        end
        if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == DT.cswjia then
            if v:FindFirstChild("SelectionBox") then
                if v:FindFirstChild("Main") then
                    if (lp.Character.HumanoidRootPart.CFrame.p - v.Main.CFrame.p).magnitude > 5 then
                        tp(v.Main.CFrame + Vector3.new(4, 0, 4))
                    end
                    for e = 1, 30 do
                        if DT.cskais == false then
                            break
                        end
                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                        v:PivotTo(DT.itemset)
                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                        game:GetService('RunService').Stepped:wait();
                    end
                    v.SelectionBox:Destroy()
                    game:GetService('RunService').Stepped:wait();
                elseif v:FindFirstChild("WoodSection") then
                    tp(v.WoodSection.CFrame + Vector3.new(4, 0, 4))
                    for e = 1, 70 do
                        if DT.cskais == false then
                            break
                        end
                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                        v.WoodSection.CFrame = DT.itemset * CFrame.Angles(math.rad(90), 0, 90)
                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(v)
                        game:GetService('RunService').Stepped:wait();
                    end
                    v.SelectionBox:Destroy()
                    game:GetService('RunService').Stepped:wait();
                end

            end

        end
    end
    tp(OldPos)
    print("btn3");
end)
win6:NewButton("停止", function()
    DT.cskais = false
    print("btn3");
end)

local win8 = library:CreateTab("复仇玩家");
win8:NewDropdown("选择玩家", "这个有用", DT.dropdown, function(v)
    DT.playernamedied = v
	print(item);
end)
win8:NewButton("刷新玩家", function()
    shuaxinlb(true)
    dropdown:SetOptions(DT.dropdown)
    print("btn3");
end)
win8:NewButton("传送玩家身边", function()
    local HumRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
    local tp_player = game:GetService("Players")[DT.playernamedied]
    if tp_player then
        for i = 1, 5 do
            wait()
            HumRoot.CFrame = tp_player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
    print("btn3");
end)win8:NewButton("传送到玩家基地", function()
     local ME = game.Players.LocalPlayer.Character.HumanoidRootPart
    for i, v in pairs(game.Workspace.Properties:GetChildren()) do
        if v.Owner.Value == game.Players[DT.playernamedied] then
            ME.CFrame = v.OriginSquare.CFrame + Vector3.new(0, 10, 0)
        end
    end
       print("btn3");
end)win8:NewButton("汽车传送到到玩家基地", function()
    for i, v in pairs(game.Workspace.Properties:GetChildren()) do
        if v.Owner.Value == game.Players[DT.playernamedied] then

            carTeleport(v.OriginSquare.CFrame + Vector3.new(0, 10, 0))
        end
    end
    print("btn3");
end)win8:NewButton("汽车踢玩家", function()
    local ME = game.Players.LocalPlayer.Character.HumanoidRootPart

    local function callback(Text)
        if Text == "确定" then
            for i, v in pairs(game:GetService("Workspace").PlayerModels:GetChildren()) do
                if v.Name == "Model" and v:FindFirstChild("DriveSeat") and v:FindFirstChild("ItemName") then
                    if v.ItemName.Value == "UtilityTruck_Vehicle" then
                        if v.Owner.OwnerString.Value == tostring(game.Players.LocalPlayer) then
                            Car = v
                            Car.DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                            wait(0.5)
                            Car.PrimaryPart = v.Seat
                        end
                    end
                end
            end

            spawn(function()

                if not lp.Character.Humanoid.SeatPart then
                    print('错误,你需要坐在车上')
                    return
                end
                if not game.Players[DT.playernamedied].Character.Humanoid.SeatPart then
                    repeat
                        task.wait()
                        carTeleport(game.Players[DT.playernamedied].Character.HumanoidRootPart.CFrame +
                                        Vector3.new(0, -2, 0))
                    until game.Players[DT.playernamedied].Character.Humanoid.SeatPart
                end
                while task.wait() do
                    for i, v in pairs(game.Workspace.Properties:GetChildren()) do
                        if v.Owner.Value == game.Players.LocalPlayer then
                            carTeleport(v.OriginSquare.CFrame + Vector3.new(0, 10, 0))
                        end
                    end
                end

            end)
        elseif Text == "取消" then

        end
    end

    local NotificationBindable = Instance.new("BindableFunction")
    NotificationBindable.OnInvoke = callback
    --
    game.StarterGui:SetCore("SendNotification", {
        Title = "道庭DT",
        Text = "使用此功能前请自己拉黑他,然后再打开让他可以坐副驾驶的功能",
        Icon = "",
        Duration = 5,
        Button1 = "确定",
        Button2 = "取消",
        Callback = NotificationBindable
    })
    print("btn3");
end)win8:NewButton("斧头杀玩家", function()
    local tool = getTool()
    if not tool then
        return notify("道庭DT", "你需要斧头", 4)
    end
    local KillPlayer = DT.playernamedied

    local Player = gplr(KillPlayer)

    if Player[1] then
        Player = Player[1]
        local LocalPlayer = game.Players.LocalPlayer

        if LocalPlayer.Character.PrimaryPart ~= nil then
            local Character = LocalPlayer.Character
            local previous = LocalPlayer.Character.PrimaryPart.CFrame

            Character.Archivable = true
            local Clone = Character:Clone()
            LocalPlayer.Character = Clone
            wait(0.5)
            LocalPlayer.Character = Character
            wait(0.2)

            if LocalPlayer.Character and Player.Character and Player.Character.PrimaryPart ~= nil then
                if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):Destroy()
                end

                local Humanoid = Instance.new("Humanoid")
                Humanoid.Parent = LocalPlayer.Character

                local Tool = nil

                if LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                elseif LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChildOfClass("Tool") then
                    Tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                end

                if Tool ~= nil then
                    Tool.Parent = LocalPlayer.Backpack

                    Player.Character.HumanoidRootPart.Anchored = true

                    local Arm = game.Players.LocalPlayer.Character['Right Arm'].CFrame *
                                    CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
                    Tool.Grip = Arm:ToObjectSpace(Player.Character.PrimaryPart.CFrame):Inverse()

                    Tool.Parent = LocalPlayer.Character
                    Workspace.CurrentCamera.CameraSubject = Tool.Handle

                    repeat
                        wait()
                    until not Tool or Tool and (Tool.Parent == Workspace or Tool.Parent == Player.Character)
                    Player.Character.HumanoidRootPart.Anchored = false
                    wait(0.1)
                    Humanoid.Health = 0
                    LocalPlayer.Character = nil
                end
            end

            spawn(function()
                LocalPlayer.CharacterAdded:Wait()
                Player.Character.HumanoidRootPart.Anchored = false
                if Player.Character.Humanoid.Health <= 15 then
                    notify("道庭DT", "成功", 4)
                    repeat
                        wait()
                    until LocalPlayer.Character.PrimaryPart ~= nil
                    wait(0.4)
                    LocalPlayer.Character:SetPrimaryPartCFrame(previous)
                end
            end)
        end
    end
    print("btn3");
end)win8:NewButton("斧头带人", function()
    Target = DT.playernamedied
    local tool = getTool()
    if not tool then
        return notify("道庭DT", "你需要斧头", 4)
    end

    NOW = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

    game.Players.LocalPlayer.Character.Humanoid.Name = 1
    local l = game.Players.LocalPlayer.Character["1"]:Clone()
    l.Parent = game.Players.LocalPlayer.Character
    l.Name = "Humanoid"

    wait(0.1)
    game.Players.LocalPlayer.Character["1"]:Destroy()
    game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Character.Animate.Disabled = true
    wait(1.1)
    game.Players.LocalPlayer.Character.Animate.Disabled = false
    game.Players.LocalPlayer.Character.Humanoid.DisplayDistanceType = "None"
    for i, v in pairs(game:GetService 'Players'.LocalPlayer.Backpack:GetChildren()) do
        if v.Name:sub(1, 4) == "Tool" then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    local function tp(player, player2)
        local char1, char2 = player.Character, player2.Character
        if char1 and char2 then
            char1.HumanoidRootPart.CFrame = char2.HumanoidRootPart.CFrame
        end
    end
    local function getout(player, player2)
        local char1, char2 = player.Character, player2.Character
        if char1 and char2 then
            char1:MoveTo(char2.Head.Position)
        end
    end
    tp(game.Players[Target], game.Players.LocalPlayer)
    wait(0.1)
    tp(game.Players[Target], game.Players.LocalPlayer)
    wait(0.3)
    tp(game.Players[Target], game.Players.LocalPlayer)
    wait(0.3)
    fori = 1, 60
    do
        getout(game.Players.LocalPlayer, game.Players[Target])

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = NOW
        task.wait(.1)
    end
    print("btn3");
end)win8:NewButton("岩浆杀人", function()
    local tool = getTool()
    if not tool then
        return notify("道庭DT", "你需要斧头", 4)
    end

    Target = DT.playernamedied
    NOW = CFrame.new(-1685, 200, 1216)

    game.Players.LocalPlayer.Character.Humanoid.Name = 1
    local l = game.Players.LocalPlayer.Character["1"]:Clone()
    l.Parent = game.Players.LocalPlayer.Character
    l.Name = "Humanoid"

    wait(0.1)
    game.Players.LocalPlayer.Character["1"]:Destroy()
    game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Character.Animate.Disabled = true
    wait(1.1)
    game.Players.LocalPlayer.Character.Animate.Disabled = false
    game.Players.LocalPlayer.Character.Humanoid.DisplayDistanceType = "None"
    for i, v in pairs(game:GetService 'Players'.LocalPlayer.Backpack:GetChildren()) do
        if v.Name:sub(1, 4) == "Tool" then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    local function tp(player, player2)
        local char1, char2 = player.Character, player2.Character
        if char1 and char2 then
            char1.HumanoidRootPart.CFrame = char2.HumanoidRootPart.CFrame
        end
    end
    local function getout(player, player2)
        local char1, char2 = player.Character, player2.Character
        if char1 and char2 then
            char1:MoveTo(char2.Head.Position)
        end
    end
    wait(0.1)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = NOW
    tp(game.Players[Target], game.Players.LocalPlayer)
    wait(0.1)
    tp(game.Players[Target], game.Players.LocalPlayer)
    wait(0.3)
    tp(game.Players[Target], game.Players.LocalPlayer)
    fori = 1, 20
    do
        getout(game.Players.LocalPlayer, game.Players[Target])

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = NOW
    end
    print("btn3");
end)

