local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local EzHook = loadstring(game:HttpGetAsync("https://pastebin.com/raw/3cCyS6GF"))()

local tp = nil
function RbxThumb(Id, ThumbnailType, Size)
    local SupportedTypes = {
        "Asset",
        "Avatar",
        "AvatarHeadShot",
        "BadgeIcon",
        "BundleThumbnail",
        "GameIcon",
        "GamePass",
        "GroupIcon",
        "Outfit"
    }
    
    local SupportedSizes = {
        ["Asset"] = {"150x150", "420x420"},
        ["Avatar"] = {"100x100", "352x352", "720x720"},
        ["AvatarHeadShot"] = {"48x48", "60x60", "150x150"},
        ["BadgeIcon"] = {"150x150"},
        ["BundleThumbnail"] = {"150x150", "420x420"},
        ["GameIcon"] = {"50x50", "150x150"},
        ["GamePass"] = {"150x150"},
        ["GroupIcon"] = {"150x150", "420x420"},
        ["Outfit"] = {"150x150", "420x420"}
    }
    
    assert(type(Id) == "number", "Id is not a number, please input the id as a number, not a string")
    assert(table.find(SupportedTypes, ThumbnailType), "Thumbnail type not supported, supported types are:\n" .. table.concat(SupportedTypes, "\n"))
    assert(table.find(SupportedSizes[ThumbnailType], Size), "Thumbnail size not supported, supported sizes are:\n" .. table.concat(SupportedSizes[ThumbnailType], "\n"))
    
    local URL = "rbxthumb://id=%d&type=%s&w=%d&h=%d"
    local Width = tonumber(Size:split("x")[1])
    local Height = tonumber(Size:split("x")[2])
    URL = URL:format(Id, ThumbnailType, Width, Height)
    
    return URL
end

print(RbxThumb(41231, "Asset", "420x420"))

if game.PlaceId == 3956818381 then

local Window = OrionLib:MakeWindow({
	Name = "SimpliX | Ninja Legends",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "PolarEx",
	IntroText = "SimpliX",
	IntroIcon = RbxThumb(7072723389, "Asset", "420x420")
})

local noclip = nil

local dx = false
local cmdx = false
local reload = false
local dex = false

local FLYING = nil

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local toRemove

function anchor (parent)
    local BodyVelocity = Instance.new('BodyVelocity', parent)
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.P = math.huge
    BodyVelocity.Velocity = Vector3.new()
    return BodyVelocity
end

defOffset = 5
local controls = {
    Q = CFrame.new(0, -defOffset, 0),
    E = CFrame.new(0, defOffset, 0),
    S = CFrame.new(0, 0, defOffset),
    W = CFrame.new(0, 0, -defOffset),
    D = CFrame.new(defOffset, 0, 0),
    A = CFrame.new(-defOffset, 0, 0),
}
local cd = 0.01


local Tab = Window:MakeTab({
	Name = "LocalPlayer",
	Icon = "rbxassetid://7072724538",
	PremiumOnly = false
})

Tab:AddParagraph("README","Do not forget Exploiting can get you banned on roblox, any suggestions contact the dev simpli.#3101")

local ws = Tab:AddSlider({
	Name = "Walkspeed Toggle",
	Min = 16,
	Max = 235,
	Default = 16,
	Color = Color3.fromRGB(230, 230, 230),
	Increment = 1,
	ValueName = "Walkspeed",
	Callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
	end 
})

Tab:AddSlider({
	Name = "Jump Power Toggle",
	Min = 50,
	Max = 350,
	Default = 50,
	Color = Color3.fromRGB(230, 230, 230),
	Increment = 1,
	ValueName = "Jump Power",
	Callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
	end    
})

Tab:AddSlider({
	Name = "FOV Toggle",
	Min = 70,
	Max = 120,
	Default = 70,
	Color = Color3.fromRGB(230, 230, 230),
	Increment = 1,
	ValueName = "Field of View",
	Callback = function(vfov)
		game.Workspace.CurrentCamera.FieldOfView = vfov
	end    
})

Tab:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 14,
    Default = 1,
	Color = Color3.fromRGB(230, 230, 230),
    Increment = 1,
    ValueName = "Fly Speed",
    Callback = function(v3)
        defOffset = v3
        controls = {
            Q = CFrame.new(0, -defOffset, 0),
            E = CFrame.new(0, defOffset, 0),
            S = CFrame.new(0, 0, defOffset),
            W = CFrame.new(0, 0, -defOffset),
            D = CFrame.new(defOffset, 0, 0),
            A = CFrame.new(-defOffset, 0, 0),
        }
    end
})

Tab:AddToggle({
    Name = "NoClip",
    Default = false,
	Color = Color3.fromRGB(230, 230, 230),
    Callback = function(v)
        if noclip == nil then return end
        if v then
            noclip = game:GetService'RunService'.Stepped:Connect(function()
                if not(game.Players.LocalPlayer.Character) then return end
                for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then --Detects if the part the player touches is a part
                        v.CanCollide = false  --Turns off the parts collisions
                    end
                end 
            end)
        elseif not v then
            noclip:Disconnect()
            noclip = false
        end
    end
})
noclip = false

Tab:AddToggle({
	Name = "Fly",
	Default = false,
	Color = Color3.fromRGB(230, 230, 230),
	Callback = function(Value)
        if not(scriptloaded) then return end
		if Value then
            local Char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
            local hrp = Char:WaitForChild'HumanoidRootPart'

            local x = anchor(hrp)

            local c = UserInputService.InputBegan:Connect(function(key, pe)
                if controls[key.KeyCode.Name] then
                    repeat
                        hrp.CFrame *= controls[key.KeyCode.Name]
                        task.wait(cd)
                    until not(UserInputService:IsKeyDown(Enum.KeyCode[key.KeyCode.Name]))
                end
            end)

            toRemove = function()
                x:Destroy()
                c:Disconnect()
            end
        elseif not(Value) and toRemove then
            toRemove()
            toRemove = nil
        end
	end    
})

Tab:AddParagraph("README","Note, this is not the best fly system. Use E & Q to go up and down!")

Tab:AddToggle({
	Name = "GodMode",
	Default = false,
	Color = Color3.fromRGB(230, 230, 230),
	Callback = function()
		game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
		game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
	end
})

Tab:AddButton({
	Name = "Reset User",
	Callback = function()
      		game.Players.LocalPlayer.Character.Humanoid.Health = 0

			  OrionLib:MakeNotification({
				Name = "Reseting Your Character",
				Content = "Your character will be reseted shortly.",
				Image = "rbxassetid://7072718307",
				Time = 4
			})
  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

local Tab2 = Window:MakeTab({
	Name = "Multiplayer",
	Icon = "rbxassetid://7072988037",
	PremiumOnly = false
})

function ReturnNames()
    local Table = {}
    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(Table, Player.Name)
    end
    return Table
end

local plrlist = Tab2:AddDropdown({
	Name = "PlayerList",
	Default = "",
	Options = ReturnNames(),
	Callback = function(plrv)
        PlayerChosen = plrv
	end    
})

game.Players.PlayerAdded:Connect(function()
    plrlist:Refresh(ReturnNames(),true)
end)

game.Players.PlayerRemoving:Connect(function()
    plrlist:Refresh(ReturnNames(),true)
end)

Tab2:AddButton({
	Name = "Teleport",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[PlayerChosen].Character.HumanoidRootPart.CFrame
	end
})

local NLT = Window:MakeTab({
	Name = "Ninja Legends",
	Icon = "rbxassetid://7072719929",
	PremiumOnly = false
})

NLT:AddToggle({
	Name = "AutoSwing",
	Default = false,
	Color = Color3.fromRGB(230, 230, 230),
	Callback = function(vas)
		getgenv().autoswing = vas
		while true do
			for _,vas in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
				if vas:FindFirstChild("ninjitsuGain") then
					game.Players.LocalPlayer.Character.Humanoid:EquipTool(vas)
					break
				end
			end
			if not getgenv().autoswing then return end
				local A_1 = "swingKatana"
				local Event = game:GetService("Players").LocalPlayer.ninjaEvent
				Event:FireServer(A_1)
			wait(0.1)
		end
	end    
})

NLT:AddToggle({
	Name = "AutoSell x35 Coins",
	Default = false,
	Color = Color3.fromRGB(230, 230, 230),
	Callback = function(sell)
		getgenv().autosell = sell
		while true do
			if not getgenv().autosell then return end

			game:GetService("Workspace").sellAreaCircles["sellAreaCircle16"].circleInner.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			wait(0.1)
			game:GetService("Workspace").sellAreaCircles["sellAreaCircle16"].circleInner.CFrame = CFrame.new(0,0,0)
			wait(0.1)
		end
	end    
})

NLT:AddButton({
	Name = "Unlock All Islands",
	Callback = function()
		local old = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
      	for _,v in pairs(game:GetService("Workspace").islandUnlockParts:GetChildren()) do
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
			wait(0.2)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = old
		end
  	end    
})

NLT:AddToggle({
	Name = "Purchase all Swords",
	Default = false,
	Color = Color3.fromRGB(230, 230, 230),
	Callback = function(buy)
		getgenv().buyswords = buy
		while true do
		if not getgenv().buyswords then return end

		local A_1 = "buyAllSwords"
		local A_2 = "Blazing Vortex Island"
		local Event = game:GetService("Players").LocalPlayer.ninjaEvent
		Event:FireServer(A_1, A_2)
		wait(0.5)
		end
	end    
})

NLT:AddToggle({
	Name = "Purchase all Belts",
	Default = false,
	Color = Color3.fromRGB(230, 230, 230),
	Callback = function(buy)
		getgenv().buybelts = buy
		while true do
		if not getgenv().buybelts then return end

		local A_1 = "buyAllBelts"
		local A_2 = "Blazing Vortex Island"
		local Event = game:GetService("Players").LocalPlayer.ninjaEvent
		Event:FireServer(A_1, A_2)
		wait(0.5)
		end
	end    
})

local Tab4 = Window:MakeTab({
	Name = "Exploit Hubs",
	Icon = "rbxassetid://7072977798",
	PremiumOnly = false
})

Tab4:AddParagraph("README","When you load one of these script hubs you may be very laggy for a moment. Also you may not be able to access SimpliX when you excecute a script hub, so please keep that in mind that. You can re-exceute the loadstring if you must.")

Tab4:AddButton({
	Name = "DomainX",
	Callback = function()
		if dx == false then
			dx = true
		end

if dx == true then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/DomainX/main/source',true))()

	else

end
	end
})

Tab4:AddButton({
	Name = "DevExplorer",
	Callback = function()
		if dex == false then
			dex = true
		end

if dex == true then
	loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()

	else

end
	end
})


Tab4:AddButton({
	Name = "CmdX",
	Callback = function()
		if cmdx == false then
			cmdx = true
		end

if cmdx == true then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))()

	else

end
	end
})


local Tab3 = Window:MakeTab({
	Name = "Configurations",
	Icon = "rbxassetid://7072723389",
	PremiumOnly = false
})

Tab3:AddParagraph("README","I just wanna say, thanks so much for using SimpliX. I have worked on it alot actually, and I want to thank all the other developers who worked on this and my testers.")

Tab3:AddButton({
	Name = "Reload SimpliX",
	Callback = function()
		if reload == false then
			reload = true
		end

if reload == true then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/rainnfx/cloudy/main/clouds.lua',true))()
	else

end
	end
})

OrionLib:Init()

scriptloaded = true

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

elseif game.PlaceId == 155615604 then
	local Window = OrionLib:MakeWindow({
		Name = "SimpliX | Prison Life",
		HidePremium = false,
		SaveConfig = true,
		ConfigFolder = "PolarEx",
		IntroText = "SimpliX",
		IntroIcon = RbxThumb(7072723389, "Asset", "420x420")
	})
	
	local noclip = nil
	
	local dx = false
	local cmdx = false
	local reload = false
	local dex = false
	
	local FLYING = nil
	
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	
	local toRemove
	
	function anchor (parent)
		local BodyVelocity = Instance.new('BodyVelocity', parent)
		BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BodyVelocity.P = math.huge
		BodyVelocity.Velocity = Vector3.new()
		return BodyVelocity
	end
	
	defOffset = 5
	local controls = {
		Q = CFrame.new(0, -defOffset, 0),
		E = CFrame.new(0, defOffset, 0),
		S = CFrame.new(0, 0, defOffset),
		W = CFrame.new(0, 0, -defOffset),
		D = CFrame.new(defOffset, 0, 0),
		A = CFrame.new(-defOffset, 0, 0),
	}
	local cd = 0.01
	
	
	local Tab = Window:MakeTab({
		Name = "LocalPlayer",
		Icon = "rbxassetid://7072724538",
		PremiumOnly = false
	})
	
	Tab:AddParagraph("README","Do not forget Exploiting can get you banned on roblox, any suggestions contact the dev simpli.#3101")
	
	local ws = Tab:AddSlider({
		Name = "Walkspeed Toggle",
		Min = 16,
		Max = 235,
		Default = 16,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Walkspeed",
		Callback = function(value)
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
		end 
	})
	
	Tab:AddSlider({
		Name = "Jump Power Toggle",
		Min = 50,
		Max = 350,
		Default = 50,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Jump Power",
		Callback = function(value)
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
		end    
	})
	
	Tab:AddSlider({
		Name = "FOV Toggle",
		Min = 70,
		Max = 120,
		Default = 70,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Field of View",
		Callback = function(vfov)
			game.Workspace.CurrentCamera.FieldOfView = vfov
		end    
	})
	
	Tab:AddSlider({
		Name = "Fly Speed",
		Min = 1,
		Max = 14,
		Default = 1,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Fly Speed",
		Callback = function(v3)
			defOffset = v3
			controls = {
				Q = CFrame.new(0, -defOffset, 0),
				E = CFrame.new(0, defOffset, 0),
				S = CFrame.new(0, 0, defOffset),
				W = CFrame.new(0, 0, -defOffset),
				D = CFrame.new(defOffset, 0, 0),
				A = CFrame.new(-defOffset, 0, 0),
			}
		end
	})
	
	Tab:AddToggle({
		Name = "NoClip",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function(v)
			if noclip == nil then return end
			if v then
				noclip = game:GetService'RunService'.Stepped:Connect(function()
					if not(game.Players.LocalPlayer.Character) then return end
					for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") then --Detects if the part the player touches is a part
							v.CanCollide = false  --Turns off the parts collisions
						end
					end 
				end)
			elseif not v then
				noclip:Disconnect()
				noclip = false
			end
		end
	})
	noclip = false
	
	Tab:AddToggle({
		Name = "Fly",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function(Value)
			if not(scriptloaded) then return end
			if Value then
				local Char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
				local hrp = Char:WaitForChild'HumanoidRootPart'
	
				local x = anchor(hrp)
	
				local c = UserInputService.InputBegan:Connect(function(key, pe)
					if controls[key.KeyCode.Name] then
						repeat
							hrp.CFrame *= controls[key.KeyCode.Name]
							task.wait(cd)
						until not(UserInputService:IsKeyDown(Enum.KeyCode[key.KeyCode.Name]))
					end
				end)
	
				toRemove = function()
					x:Destroy()
					c:Disconnect()
				end
			elseif not(Value) and toRemove then
				toRemove()
				toRemove = nil
			end
		end    
	})
	
	Tab:AddParagraph("README","Note, this is not the best fly system. Use E & Q to go up and down!")
	
	Tab:AddToggle({
		Name = "GodMode",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function()
			game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
			game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
		end
	})
	
	Tab:AddButton({
		Name = "Reset User",
		Callback = function()
				  game.Players.LocalPlayer.Character.Humanoid.Health = 0
	
				  OrionLib:MakeNotification({
					Name = "Reseting Your Character",
					Content = "Your character will be reseted shortly.",
					Image = "rbxassetid://7072718307",
					Time = 4
				})
		  end    
	})
	
	local Tab2 = Window:MakeTab({
		Name = "Multiplayer",
		Icon = "rbxassetid://7072988037",
		PremiumOnly = false
	})
	
	function ReturnNames()
		local Table = {}
		for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
			table.insert(Table, Player.Name)
		end
		return Table
	end
	
	local plrlist = Tab2:AddDropdown({
		Name = "PlayerList",
		Default = "",
		Options = ReturnNames(),
		Callback = function(plrv)
			PlayerChosen = plrv
		end    
	})
	
	game.Players.PlayerAdded:Connect(function()
		plrlist:Refresh(ReturnNames(),true)
	end)
	
	game.Players.PlayerRemoving:Connect(function()
		plrlist:Refresh(ReturnNames(),true)
	end)
	
	Tab2:AddButton({
		Name = "Teleport",
		Callback = function()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[PlayerChosen].Character.HumanoidRootPart.CFrame
		end
	})
	
	Tab2:AddButton({
		Name = "Bring",
		Callback = function()
			game.Players[PlayerChosen].Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		end
	})

	local ALT = Window:MakeTab({
		Name = "Prison Life",
		Icon = "rbxassetid://7072719929",
		PremiumOnly = false
	})

	ALT:AddDropdown({
		Name = "Recieve a Gun",
		Default = "1",
		Options = {"AK-47", "Remington 870", "M9"},
		Callback = function(Value)
			
			local A_1 = game:GetService("Workspace")["Prison_ITEMS"].giver[Value].ITEMPICKUP
			local Event = game:GetService("Workspace").Remote.ItemHandler
			Event:InvokeServer(A_1)
		end    
	})

	ALT:AddParagraph("README","Please get a gun from the dropdown above before choosing whichever gun to mod.")

	ALT:AddDropdown({
		Name = "Recieve a Modded Gun",
		Default = "1",
		Options = {"AK-47", "Remington 870", "M9"},
		Callback = function(yessir)
			local module = nil
			if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(yessir) then
				module = require(game:GetService("Players").LocalPlayer.Backpack[yessir].GunStates)
			elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild(yessir) then
				module = require(game:GetService("Players").LocalPlayer.Character[yessir].GunStates)
			end

			if module ~= nil then
				module["MaxAmmo"] = math.huge
				module["CurrentAmmo"] = math.huge
				module["StoredAmmo"] = math.huge
				module["FireRate"] = 0.1
				module["Spread"] = 0
				module["Range"] = math.huge
				module["Bullets"] = 3
				module["ReloadTime"] = 0.0001
				module["AutoFire"] = true
			end
		end    
	})

	
	local Tab4 = Window:MakeTab({
		Name = "Exploit Hubs",
		Icon = "rbxassetid://7072977798",
		PremiumOnly = false
	})
	
	Tab4:AddParagraph("README","When you load one of these script hubs you may be very laggy for a moment. Also you may not be able to access SimpliX when you excecute a script hub, so please keep that in mind that. You can re-exceute the loadstring if you must.")
	
	Tab4:AddButton({
		Name = "DomainX",
		Callback = function()
			if dx == false then
				dx = true
			end
	
	if dx == true then
		loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/DomainX/main/source',true))()
	
		else
	
	end
		end
	})
	
	Tab4:AddButton({
		Name = "DevExplorer",
		Callback = function()
			if dex == false then
				dex = true
			end
	
	if dex == true then
		loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
	
		else
	
	end
		end
	})
	
	
	Tab4:AddButton({
		Name = "CmdX",
		Callback = function()
			if cmdx == false then
				cmdx = true
			end
	
	if cmdx == true then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))()
	
		else
	
	end
		end
	})
	
	
	
	local Tab3 = Window:MakeTab({
		Name = "Configurations",
		Icon = "rbxassetid://7072723389",
		PremiumOnly = false
	})
	
	Tab3:AddParagraph("README","I just wanna say, thanks so much for using SimpliX. I have worked on it alot actually, and I want to thank all the other developers who worked on this and my testers.")
	
	Tab3:AddButton({
		Name = "Reload SimpliX",
		Callback = function()
			if reload == false then
				reload = true
			end
	
	if reload == true then
		loadstring(game:HttpGet('https://raw.githubusercontent.com/rainnfx/cloudy/main/clouds.lua',true))()
		else
	
	end
		end
	})
	
	OrionLib:Init()
	
	scriptloaded = true

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


elseif game.PlaceId == 286090429 then
	local Window = OrionLib:MakeWindow({
		Name = "SimpliX | Arsenal",
		HidePremium = false,
		SaveConfig = true,
		ConfigFolder = "PolarEx",
		IntroText = "SimpliX",
		IntroIcon = RbxThumb(7072723389, "Asset", "420x420")
	})
	
	local noclip = nil
	
	local dx = false
	local cmdx = false
	local reload = false
	local dex = false
	
	local FLYING = nil
	
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	
	local toRemove
	
	function anchor (parent)
		local BodyVelocity = Instance.new('BodyVelocity', parent)
		BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BodyVelocity.P = math.huge
		BodyVelocity.Velocity = Vector3.new()
		return BodyVelocity
	end
	
	defOffset = 5
	local controls = {
		Q = CFrame.new(0, -defOffset, 0),
		E = CFrame.new(0, defOffset, 0),
		S = CFrame.new(0, 0, defOffset),
		W = CFrame.new(0, 0, -defOffset),
		D = CFrame.new(defOffset, 0, 0),
		A = CFrame.new(-defOffset, 0, 0),
	}
	local cd = 0.01
	
	
	local Tab = Window:MakeTab({
		Name = "LocalPlayer",
		Icon = "rbxassetid://7072724538",
		PremiumOnly = false
	})
	
	Tab:AddParagraph("README","Do not forget Exploiting can get you banned on roblox, any suggestions contact the dev simpli.#3101")
	
	local ws = Tab:AddSlider({
		Name = "Walkspeed Toggle",
		Min = 16,
		Max = 235,
		Default = 16,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Walkspeed",
		Callback = function(value)
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
		end 
	})
	
	Tab:AddSlider({
		Name = "Jump Power Toggle",
		Min = 50,
		Max = 350,
		Default = 50,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Jump Power",
		Callback = function(value)
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
		end    
	})
	
	Tab:AddSlider({
		Name = "FOV Toggle",
		Min = 70,
		Max = 120,
		Default = 70,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Field of View",
		Callback = function(vfov)
			game.Workspace.CurrentCamera.FieldOfView = vfov
		end    
	})
	
	Tab:AddSlider({
		Name = "Fly Speed",
		Min = 1,
		Max = 14,
		Default = 1,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Fly Speed",
		Callback = function(v3)
			defOffset = v3
			controls = {
				Q = CFrame.new(0, -defOffset, 0),
				E = CFrame.new(0, defOffset, 0),
				S = CFrame.new(0, 0, defOffset),
				W = CFrame.new(0, 0, -defOffset),
				D = CFrame.new(defOffset, 0, 0),
				A = CFrame.new(-defOffset, 0, 0),
			}
		end
	})
	
	Tab:AddToggle({
		Name = "NoClip",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function(v)
			if noclip == nil then return end
			if v then
				noclip = game:GetService'RunService'.Stepped:Connect(function()
					if not(game.Players.LocalPlayer.Character) then return end
					for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") then --Detects if the part the player touches is a part
							v.CanCollide = false  --Turns off the parts collisions
						end
					end 
				end)
			elseif not v then
				noclip:Disconnect()
				noclip = false
			end
		end
	})
	noclip = false
	
	Tab:AddToggle({
		Name = "Fly",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function(Value)
			if not(scriptloaded) then return end
			if Value then
				local Char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
				local hrp = Char:WaitForChild'HumanoidRootPart'
	
				local x = anchor(hrp)
	
				local c = UserInputService.InputBegan:Connect(function(key, pe)
					if controls[key.KeyCode.Name] then
						repeat
							hrp.CFrame *= controls[key.KeyCode.Name]
							task.wait(cd)
						until not(UserInputService:IsKeyDown(Enum.KeyCode[key.KeyCode.Name]))
					end
				end)
	
				toRemove = function()
					x:Destroy()
					c:Disconnect()
				end
			elseif not(Value) and toRemove then
				toRemove()
				toRemove = nil
			end
		end    
	})
	
	Tab:AddParagraph("README","Note, this is not the best fly system. Use E & Q to go up and down!")
	
	Tab:AddToggle({
		Name = "GodMode",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function()
			game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
			game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
		end
	})
	
	Tab:AddButton({
		Name = "Reset User",
		Callback = function()
				  game.Players.LocalPlayer.Character.Humanoid.Health = 0
	
				  OrionLib:MakeNotification({
					Name = "Reseting Your Character",
					Content = "Your character will be reseted shortly.",
					Image = "rbxassetid://7072718307",
					Time = 4
				})
		  end    
	})
	
	local Tab2 = Window:MakeTab({
		Name = "Multiplayer",
		Icon = "rbxassetid://7072988037",
		PremiumOnly = false
	})
	
	function ReturnNames()
		local Table = {}
		for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
			table.insert(Table, Player.Name)
		end
		return Table
	end
	
	local plrlist = Tab2:AddDropdown({
		Name = "PlayerList",
		Default = "",
		Options = ReturnNames(),
		Callback = function(plrv)
			PlayerChosen = plrv
		end    
	})
	
	game.Players.PlayerAdded:Connect(function()
		plrlist:Refresh(ReturnNames(),true)
	end)
	
	game.Players.PlayerRemoving:Connect(function()
		plrlist:Refresh(ReturnNames(),true)
	end)
	
	Tab2:AddButton({
		Name = "Teleport",
		Callback = function()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[PlayerChosen].Character.HumanoidRootPart.CFrame
		end
	})
	
	Tab2:AddButton({
		Name = "Bring",
		Callback = function()
			game.Players[PlayerChosen].Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		end
	})

	local ALT = Window:MakeTab({
		Name = "Arsenal",
		Icon = "rbxassetid://7072719929",
		PremiumOnly = false
	})

	local AimbotValue = false

ALT:AddToggle({
    Name = "Aimbot",
    Default = false,
    Color = Color3.fromRGB(230, 230, 230),
    Callback = function(Value)
        AimbotToggle = Value
    end             
})

local UIS = game:GetService("UserInputService")
local CCamera = game.workspace.CurrentCamera
            
function getClosest()
    local closestDistance = math.huge
    local closestPlayer = nil
    for i,v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = v
            end
        end
    end
    return closestPlayer
end
            
UIS.InputBegan:Connect(function(input)
    if AimbotToggle then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            _G.aim = true
            while wait() do
                CCamera.CFrame = CFrame.new(CCamera.CFrame.Position, getClosest().Character.Head.Position)
                if _G.aim == false then return end
            end
        end
    end
end)
 
UIS.InputEnded:Connect(function(input)
    if AimbotToggle then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            _G.aim = false
        end
    end
end)

ALT:AddToggle({
    Name = "WallBang",
    Default = false,
    Color = Color3.fromRGB(230, 230, 230),
    Callback = function(Value)
        EzHook:HookIndex("Clips",function()end,workspace.Map)
    end             
})


	
	local Tab4 = Window:MakeTab({
		Name = "Exploit Hubs",
		Icon = "rbxassetid://7072977798",
		PremiumOnly = false
	})
	
	Tab4:AddParagraph("README","When you load one of these script hubs you may be very laggy for a moment. Also you may not be able to access SimpliX when you excecute a script hub, so please keep that in mind that. You can re-exceute the loadstring if you must.")
	
	Tab4:AddButton({
		Name = "DomainX",
		Callback = function()
			if dx == false then
				dx = true
			end
	
	if dx == true then
		loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/DomainX/main/source',true))()
	
		else
	
	end
		end
	})
	
	Tab4:AddButton({
		Name = "DevExplorer",
		Callback = function()
			if dex == false then
				dex = true
			end
	
	if dex == true then
		loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
	
		else
	
	end
		end
	})
	
	
	Tab4:AddButton({
		Name = "CmdX",
		Callback = function()
			if cmdx == false then
				cmdx = true
			end
	
	if cmdx == true then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))()
	
		else
	
	end
		end
	})
	
	
	
	local Tab3 = Window:MakeTab({
		Name = "Configurations",
		Icon = "rbxassetid://7072723389",
		PremiumOnly = false
	})
	
	Tab3:AddParagraph("README","I just wanna say, thanks so much for using SimpliX. I have worked on it alot actually, and I want to thank all the other developers who worked on this and my testers.")
	
	Tab3:AddButton({
		Name = "Reload SimpliX",
		Callback = function()
			if reload == false then
				reload = true
			end
	
	if reload == true then
		loadstring(game:HttpGet('https://raw.githubusercontent.com/rainnfx/cloudy/main/clouds.lua',true))()
		else
	
	end
		end
	})
	
	OrionLib:Init()
	
	scriptloaded = true


else

	---------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------


	local Window = OrionLib:MakeWindow({
		Name = "SimpliX",
		HidePremium = false,
		SaveConfig = true,
		ConfigFolder = "PolarEx",
		IntroText = "SimpliX",
		IntroIcon = RbxThumb(7072723389, "Asset", "420x420")
	})
	
	local noclip = nil
	
	local dx = false
	local cmdx = false
	local reload = false
	local dex = false
	
	local FLYING = nil
	
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	
	local toRemove
	
	function anchor (parent)
		local BodyVelocity = Instance.new('BodyVelocity', parent)
		BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BodyVelocity.P = math.huge
		BodyVelocity.Velocity = Vector3.new()
		return BodyVelocity
	end
	
	defOffset = 5
	local controls = {
		Q = CFrame.new(0, -defOffset, 0),
		E = CFrame.new(0, defOffset, 0),
		S = CFrame.new(0, 0, defOffset),
		W = CFrame.new(0, 0, -defOffset),
		D = CFrame.new(defOffset, 0, 0),
		A = CFrame.new(-defOffset, 0, 0),
	}
	local cd = 0.01
	
	
	local Tab = Window:MakeTab({
		Name = "LocalPlayer",
		Icon = "rbxassetid://7072724538",
		PremiumOnly = false
	})
	
	Tab:AddParagraph("README","Do not forget Exploiting can get you banned on roblox, any suggestions contact the dev simpli.#3101")
	
	local ws = Tab:AddSlider({
		Name = "Walkspeed Toggle",
		Min = 16,
		Max = 235,
		Default = 16,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Walkspeed",
		Callback = function(value)
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
		end 
	})
	
	Tab:AddSlider({
		Name = "Jump Power Toggle",
		Min = 50,
		Max = 350,
		Default = 50,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Jump Power",
		Callback = function(value)
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
		end    
	})
	
	Tab:AddSlider({
		Name = "FOV Toggle",
		Min = 70,
		Max = 120,
		Default = 70,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Field of View",
		Callback = function(vfov)
			game.Workspace.CurrentCamera.FieldOfView = vfov
		end    
	})
	
	Tab:AddSlider({
		Name = "Fly Speed",
		Min = 1,
		Max = 14,
		Default = 1,
		Color = Color3.fromRGB(230, 230, 230),
		Increment = 1,
		ValueName = "Fly Speed",
		Callback = function(v3)
			defOffset = v3
			controls = {
				Q = CFrame.new(0, -defOffset, 0),
				E = CFrame.new(0, defOffset, 0),
				S = CFrame.new(0, 0, defOffset),
				W = CFrame.new(0, 0, -defOffset),
				D = CFrame.new(defOffset, 0, 0),
				A = CFrame.new(-defOffset, 0, 0),
			}
		end
	})
	
	Tab:AddToggle({
		Name = "NoClip",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function(v)
			if noclip == nil then return end
			if v then
				noclip = game:GetService'RunService'.Stepped:Connect(function()
					if not(game.Players.LocalPlayer.Character) then return end
					for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") then --Detects if the part the player touches is a part
							v.CanCollide = false  --Turns off the parts collisions
						end
					end 
				end)
			elseif not v then
				noclip:Disconnect()
				noclip = false
			end
		end
	})
	noclip = false
	
	Tab:AddToggle({
		Name = "Fly",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function(Value)
			if not(scriptloaded) then return end
			if Value then
				local Char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
				local hrp = Char:WaitForChild'HumanoidRootPart'
	
				local x = anchor(hrp)
	
				local c = UserInputService.InputBegan:Connect(function(key, pe)
					if controls[key.KeyCode.Name] then
						repeat
							hrp.CFrame *= controls[key.KeyCode.Name]
							task.wait(cd)
						until not(UserInputService:IsKeyDown(Enum.KeyCode[key.KeyCode.Name]))
					end
				end)
	
				toRemove = function()
					x:Destroy()
					c:Disconnect()
				end
			elseif not(Value) and toRemove then
				toRemove()
				toRemove = nil
			end
		end    
	})
	
	Tab:AddParagraph("README","Note, this is not the best fly system. Use E & Q to go up and down!")
	
	Tab:AddToggle({
		Name = "GodMode",
		Default = false,
		Color = Color3.fromRGB(230, 230, 230),
		Callback = function()
			game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
			game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
		end
	})
	
	Tab:AddButton({
		Name = "Reset User",
		Callback = function()
				  game.Players.LocalPlayer.Character.Humanoid.Health = 0
	
				  OrionLib:MakeNotification({
					Name = "Reseting Your Character",
					Content = "Your character will be reseted shortly.",
					Image = "rbxassetid://7072718307",
					Time = 4
				})
		  end    
	})
	
	--[[
	Name = <string> - The name of the button.
	Callback = <function> - The function of the button.
	]]
	
	local Tab2 = Window:MakeTab({
		Name = "Multiplayer",
		Icon = "rbxassetid://7072988037",
		PremiumOnly = false
	})
	
	function ReturnNames()
		local Table = {}
		for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
			table.insert(Table, Player.Name)
		end
		return Table
	end
	
	local plrlist = Tab2:AddDropdown({
		Name = "PlayerList",
		Default = "",
		Options = ReturnNames(),
		Callback = function(plrv)
			PlayerChosen = plrv
		end    
	})
	
	game.Players.PlayerAdded:Connect(function()
		plrlist:Refresh(ReturnNames(),true)
	end)
	
	game.Players.PlayerRemoving:Connect(function()
		plrlist:Refresh(ReturnNames(),true)
	end)
	
	Tab2:AddButton({
		Name = "Teleport",
		Callback = function()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[PlayerChosen].Character.HumanoidRootPart.CFrame
		end
	})
	
	Tab2:AddButton({
		Name = "Bring",
		Callback = function()
			game.Players[PlayerChosen].Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		end
	})
	
	local Tab4 = Window:MakeTab({
		Name = "Exploit Hubs",
		Icon = "rbxassetid://7072977798",
		PremiumOnly = false
	})
	
	Tab4:AddParagraph("README","When you load one of these script hubs you may be very laggy for a moment. Also you may not be able to access SimpliX when you excecute a script hub, so please keep that in mind that. You can re-exceute the loadstring if you must.")
	
	Tab4:AddButton({
		Name = "DomainX",
		Callback = function()
			if dx == false then
				dx = true
			end
	
	if dx == true then
		loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/DomainX/main/source',true))()
	
		else
	
	end
		end
	})
	
	Tab4:AddButton({
		Name = "DevExplorer",
		Callback = function()
			if dex == false then
				dex = true
			end
	
	if dex == true then
		loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
	
		else
	
	end
		end
	})
	
	
	Tab4:AddButton({
		Name = "CmdX",
		Callback = function()
			if cmdx == false then
				cmdx = true
			end
	
	if cmdx == true then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))()
	
		else
	
	end
		end
	})
	
	
	
	local Tab3 = Window:MakeTab({
		Name = "Configurations",
		Icon = "rbxassetid://7072723389",
		PremiumOnly = false
	})
	
	Tab3:AddParagraph("README","I just wanna say, thanks so much for using SimpliX. I have worked on it alot actually, and I want to thank all the other developers who worked on this and my testers.")
	
	Tab3:AddButton({
		Name = "Reload SimpliX",
		Callback = function()
			if reload == false then
				reload = true
			end
	
	if reload == true then
		loadstring(game:HttpGet('https://raw.githubusercontent.com/rainnfx/cloudy/main/clouds.lua',true))()
		else
	
	end
		end
	})
	
	OrionLib:Init()
	
	scriptloaded = true

end