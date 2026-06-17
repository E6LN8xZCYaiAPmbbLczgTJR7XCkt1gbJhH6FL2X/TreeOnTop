local Services = {
	Players = game:GetService("Players"),
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	VirtualUser = game:GetService("VirtualUser"),
	Workspace = workspace,
	Lighting = game:GetService("Lighting"),
	UserInputService = game:GetService("UserInputService"),
	RunService = game:GetService("RunService")
}

local PlayerData = {
	Player = Services.Players.LocalPlayer,
	DisplayName = Services.Players.LocalPlayer.DisplayName,
	Character = Services.Players.LocalPlayer.Character,
	Humanoid = nil,
	Camera = Services.Workspace.CurrentCamera,
	Backpack = Services.Players.LocalPlayer:WaitForChild("Backpack")
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local muscleEvent = Player:WaitForChild("muscleEvent")
local LocalPlayer = Players.LocalPlayer
local players = game:GetService("Players")
local player = players.LocalPlayer

PlayerData.Humanoid = PlayerData.Character and PlayerData.Character:FindFirstChildOfClass("Humanoid")

local Remotes = {
	ChangeSpeedSize = Services.ReplicatedStorage.rEvents.changeSpeedSizeRemote,
	MuscleEvent = PlayerData.Player.muscleEvent
}

local Utils = {}

function Utils.formatNumber(n)
	if n >= 1e15 then return string.format("%.1fqa", n / 1e15)
	elseif n >= 1e12 then return string.format("%.1ft", n / 1e12)
	elseif n >= 1e9 then return string.format("%.1fb", n / 1e9)
	elseif n >= 1e6 then return string.format("%.1fm", n / 1e6)
	elseif n >= 1e3 then return string.format("%.1fk", n / 1e3)
	else return tostring(n) end
end

function Utils.formatWithCommas(n)
	local formatted = tostring(math.floor(n))
	while true do
		formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then break end
	end
	return formatted
end

function Utils.greeting()
	return "Hello " .. PlayerData.DisplayName
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/E6LN8xZCYaiAPmbbLczgTJR7XCkt1gbJhH6FL2X/TreeOnTop/refs/heads/main/Ui.lua", true))()

local window = library:AddWindow("TREE | Private Killing |" .. Utils.greeting(), {
	main_color = Color3.fromRGB(0, 0, 0),
	min_size = Vector2.new(500, 750)
})

Main = window:AddTab("     Main     ")
Main:Show()
Killing = window:AddTab("     Killing     ")
Stats = window:AddTab("     Stats     ")
Godmode = window:AddTab("     Godmode     ")
Inventory = window:AddTab("     Inventory     ")

local cr = Main:AddLabel("Credits: Tree")
cr.TextColor3 = Color3.fromRGB(255, 255, 255)
cr.Font = Enum.Font.PermanentMarker
cr.TextSize = 50
Main:AddLabel("———————————————————————————————")
local es = Main:AddLabel("Essentials:")
es.TextColor3 = Color3.fromRGB(255, 255, 255)
es.Font = Enum.Font.PermanentMarker
es.TextSize = 35

local function deleteAds()
	for _, portal in pairs(game:GetDescendants()) do
		if portal.Name == "RobloxForwardPortals" then
			portal:Destroy()
		end
	end
	if _G.ads then
		_G.ads:Disconnect()
	end
	_G.ads = game.DescendantAdded:Connect(function(descendant)
		if descendant.Name == "RobloxForwardPortals" then
			descendant:Destroy()
		end
	end)
end
deleteAds()

Main:AddButton("Load Anti Lag", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/juywvm/-Roblox-Projects-/main/____Anti_Afk_Remastered_______"))()
end)

local Protection = {
    AntiFling = {Enabled = false},
    PositionLock = {Enabled = false, Position = nil}
}

local function eAntiFling()
	if not Protection.AntiFling.Enabled or not PlayerData.Player.Character then return end
	if not PlayerData.Player.Character:FindFirstChild("HumanoidRootPart") then return end
	if PlayerData.Player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") and 
	   PlayerData.Player.Character.HumanoidRootPart.BodyVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
		PlayerData.Player.Character.HumanoidRootPart.BodyVelocity:Destroy()
	end
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(100000, 0, 100000)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.P = 1250
	bv.Parent = PlayerData.Player.Character.HumanoidRootPart
end

local function dAntiFling()
	if not PlayerData.Player.Character or not PlayerData.Player.Character:FindFirstChild("HumanoidRootPart") then return end
	if PlayerData.Player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") and 
	   PlayerData.Player.Character.HumanoidRootPart.BodyVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
		PlayerData.Player.Character.HumanoidRootPart.BodyVelocity:Destroy()
	end
end

Main:AddSwitch("Anti Fling", function(bool)
	Protection.AntiFling.Enabled = bool
	if bool then eAntiFling() else dAntiFling() end
end):Set(false)

PlayerData.Player.CharacterAdded:Connect(function(newChar)
	newChar:WaitForChild("HumanoidRootPart", 5)
	if Protection.AntiFling.Enabled then eAntiFling() end
end)

local WaterParts = {
	Parts = {},
	PartSize = 2048,
	TotalDistance = 50000,
	StartPosition = Vector3.new(-2, -9.5, -2)
}

task.spawn(function()
	for x = 0, math.ceil(WaterParts.TotalDistance / WaterParts.PartSize) - 1 do
		for z = 0, math.ceil(WaterParts.TotalDistance / WaterParts.PartSize) - 1 do
			for i, offset in ipairs({
				{x * WaterParts.PartSize, z * WaterParts.PartSize, "Side_" .. x .. "_" .. z},
				{-x * WaterParts.PartSize, z * WaterParts.PartSize, "LeftRight_" .. x .. "_" .. z},
				{-x * WaterParts.PartSize, -z * WaterParts.PartSize, "UpLeft_" .. x .. "_" .. z},
				{x * WaterParts.PartSize, -z * WaterParts.PartSize, "UpRight_" .. x .. "_" .. z}
			}) do
				local part = Instance.new("Part")
				part.Size = Vector3.new(WaterParts.PartSize, 1, WaterParts.PartSize)
				part.Position = WaterParts.StartPosition + Vector3.new(offset[1], 0, offset[2])
				part.Anchored = true
				part.Transparency = 1
				part.CanCollide = true
				part.Name = "Part_" .. offset[3]
				part.Parent = Services.Workspace
				table.insert(WaterParts.Parts, part)
			end
		end
	end
end)

local WalkonWater = Main:AddSwitch("Walk on Water", function(bool)
	for _, part in ipairs(WaterParts.Parts) do
		if part and part.Parent then part.CanCollide = bool end
	end
end)
WalkonWater:Set(false)

Main:AddButton("Load Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

local HideFrames = Main:AddSwitch("Hide Frames", function(bool)
    for _, obj in pairs(ReplicatedStorage:GetChildren()) do
        if obj.Name:match("Frame$") then
            obj.Visible = not bool
        end
    end
end)
HideFrames:Set(true)

local ShowPets = Main:AddSwitch("Show Pets", function(bool)
    if PlayerData.Player:FindFirstChild("hidePets") then
        PlayerData.Player.hidePets.Value = bool
    end
end)
ShowPets:Set(false)

local ShowotherPets = Main:AddSwitch("Show other Pets", function(bool)
	if PlayerData.Player:FindFirstChild("showOtherPetsOn") then
		PlayerData.Player.showOtherPetsOn.Value = bool
	end
end)
ShowotherPets:Set(false)

Main:AddButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
end)

local function checkCharacter()
	if not Services.Players.LocalPlayer.Character then
		repeat task.wait() until Services.Players.LocalPlayer.Character
	end
	return Services.Players.LocalPlayer.Character
end

local function gettool()
	for _, v in pairs(Services.Players.LocalPlayer.Backpack:GetChildren()) do
		if v.Name == "Punch" and Services.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			Services.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
		end
	end
	Services.Players.LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
	Services.Players.LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

local function isPlayerAlive(player)
	return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
	player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function killPlayer(target)
	if not isPlayerAlive(target) or not checkCharacter():FindFirstChild("LeftHand") then return end
	pcall(function()
		firetouchinterest(target.Character.HumanoidRootPart, checkCharacter().LeftHand, 0)
		firetouchinterest(target.Character.HumanoidRootPart, checkCharacter().LeftHand, 1)
		gettool()
	end)
end

mi = Killing:AddLabel("Miscellaneous:")
mi.TextColor3 = Color3.fromRGB(255, 255, 255)
mi.Font = Enum.Font.PermanentMarker
mi.TextSize = 35

local SelectPet = Killing:AddDropdown("Select Pet", function(text)
	for _, folder in pairs(Services.Players.LocalPlayer.petsFolder:GetChildren()) do
		if folder:IsA("Folder") then
			for _, pet in pairs(folder:GetChildren()) do
				Services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
			end
		end
	end
	task.wait(0.1)
	local petsToEquip = {}
	for _, pet in pairs(Services.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
		if pet.Name == text then table.insert(petsToEquip, pet) end
	end
	for i = 1, math.min(8, #petsToEquip) do
		Services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", petsToEquip[i])
		task.wait(0.1)
	end
end)

for _, petName in ipairs({"Wild Wizard", "Mighty Monster"}) do
	SelectPet:Add(petName)
end

Killing:AddSwitch("Remove Attack Animations", function(bool)
	if bool then
		local blockedAnimations = {
			["rbxassetid://3638729053"] = true,
			["rbxassetid://3638767427"] = true,
		}
		local function setupAnimationBlocking()
			local char = Services.Players.LocalPlayer.Character
			if not char or not char:FindFirstChild("Humanoid") then
				return
			end
			for _, track in pairs(PlayerData.Humanoid:GetPlayingAnimationTracks()) do
				if track.Animation then
					local animId = track.Animation.AnimationId
					local animName = track.Name:lower()
					if
						blockedAnimations[animId]
						or animName:match("punch")
						or animName:match("attack")
						or animName:match("right")
					then
						track:Stop()
					end
				end
			end
			_G.AnimBlockConnection = PlayerData.Humanoid.AnimationPlayed:Connect(function(track)
				if track.Animation then
					local animId = track.Animation.AnimationId
					local animName = track.Name:lower()
					if
						blockedAnimations[animId]
						or animName:match("punch")
						or animName:match("attack")
						or animName:match("right")
					then
						track:Stop()
					end
				end
			end)
		end
		local function processTool(tool)
			if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) then
				if not tool:GetAttribute("ActivatedOverride") then
					tool:SetAttribute("ActivatedOverride", true)
					_G.ToolConnections = _G.ToolConnections or {}
					_G.ToolConnections[tool] = tool.Activated:Connect(function()
						task.wait(0.01)
						local char = Services.Players.LocalPlayer.Character
						if char and char:FindFirstChild("Humanoid") then
							for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
								if track.Animation then
									local animId = track.Animation.AnimationId
									local animName = track.Name:lower()
									if
										blockedAnimations[animId]
										or animName:match("punch")
										or animName:match("attack")
										or animName:match("right")
									then
										track:Stop()
									end
								end
							end
						end
					end)
				end
			end
		end
		local function overrideToolActivation()
			for _, tool in pairs(Services.Players.LocalPlayer.Backpack:GetChildren()) do
				processTool(tool)
			end
			local char = Services.Players.LocalPlayer.Character
			if char then
				for _, tool in pairs(char:GetChildren()) do
					if tool:IsA("Tool") then
						processTool(tool)
					end
				end
			end
			_G.BackpackAddedConnection = Services.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
				if child:IsA("Tool") then
					task.wait(0.1)
					processTool(child)
				end
			end)
			if char then
				_G.CharacterToolAddedConnection = char.ChildAdded:Connect(function(child)
					if child:IsA("Tool") then
						task.wait(0.1)
						processTool(child)
					end
				end)
			end
		end
		_G.AnimMonitorConnection = Services.RunService.Heartbeat:Connect(function()
			if tick() % 0.5 < 0.01 then
				local char = Services.Players.LocalPlayer.Character
				if char and char:FindFirstChild("Humanoid") then
					for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
						if track.Animation then
							local animId = track.Animation.AnimationId
							local animName = track.Name:lower()
							if
								blockedAnimations[animId]
								or animName:match("punch")
								or animName:match("attack")
								or animName:match("right")
							then
								track:Stop()
							end
						end
					end
				end
			end
		end)
		_G.CharacterAddedConnection = Services.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
			task.wait(1)
			setupAnimationBlocking()
			overrideToolActivation()
			if _G.CharacterToolAddedConnection then
				_G.CharacterToolAddedConnection:Disconnect()
			end
			_G.CharacterToolAddedConnection = newChar.ChildAdded:Connect(function(child)
				if child:IsA("Tool") then
					task.wait(0.1)
					processTool(child)
				end
			end)
		end)
		setupAnimationBlocking()
		overrideToolActivation()
	else
		if _G.AnimBlockConnection then
			_G.AnimBlockConnection:Disconnect()
			_G.AnimBlockConnection = nil
		end
		if _G.AnimMonitorConnection then
			_G.AnimMonitorConnection:Disconnect()
			_G.AnimMonitorConnection = nil
		end
		if _G.CharacterAddedConnection then
			_G.CharacterAddedConnection:Disconnect()
			_G.CharacterAddedConnection = nil
		end
		if _G.BackpackAddedConnection then
			_G.BackpackAddedConnection:Disconnect()
			_G.BackpackAddedConnection = nil
		end
		if _G.CharacterToolAddedConnection then
			_G.CharacterToolAddedConnection:Disconnect()
			_G.CharacterToolAddedConnection = nil
		end
		if _G.ToolConnections then
			for tool, connection in pairs(_G.ToolConnections) do
				if connection then
					connection:Disconnect()
				end
				if tool and tool:GetAttribute("ActivatedOverride") then
					tool:SetAttribute("ActivatedOverride", nil)
				end
			end
			_G.ToolConnections = nil
		end
	end
end)

local DisableEggState = {
	enabled = false,
	connections = {}
}

local function noEgg(tool)
	for _, desc in ipairs(tool:GetDescendants()) do
		if desc:IsA("Script") or desc:IsA("LocalScript") then
			if desc:IsA("LocalScript") then desc.Disabled = true else desc:Destroy() end
		end
		if desc:IsA("RemoteEvent") then pcall(function() desc.FireServer = function() end end) end
	end
end

local function setupEggDisable()
	for _, container in ipairs({PlayerData.Player.Backpack, PlayerData.Player.Character}) do
		if container then
			for _, tool in ipairs(container:GetChildren()) do
				if tool:IsA("Tool") and tool.Name == "Protein Egg" then noEgg(tool) end
			end
			local conn = container.ChildAdded:Connect(function(child)
				if DisableEggState.enabled and child:IsA("Tool") and child.Name == "Protein Egg" then 
					task.defer(noEgg, child) 
				end
			end)
			table.insert(DisableEggState.connections, conn)
		end
	end
end

local function cleanupEggDisable()
	for _, conn in ipairs(DisableEggState.connections) do
		conn:Disconnect()
	end
	DisableEggState.connections = {}
end

Killing:AddSwitch("Block Eating Eggs", function(bool)
	DisableEggState.enabled = bool
	if bool then
		setupEggDisable()
	else
		cleanupEggDisable()
	end
end)

local NanData = {Enabled = false}

Killing:AddSwitch("NaN + Egg", function(bool)
	NanData.Enabled = bool
	if bool then
		Remotes.ChangeSpeedSize:InvokeServer("changeSize", 0 / 0)
		task.spawn(function()
			while NanData.Enabled do
				if PlayerData.Player.Character then
					local eggsInHand = 0
					for _, item in ipairs(PlayerData.Player.Character:GetChildren()) do
						if item.Name == "Protein Egg" then
							eggsInHand = eggsInHand + 1
							if eggsInHand > 1 then item.Parent = PlayerData.Player.Backpack end
						end
					end
					if eggsInHand == 0 and PlayerData.Player.Backpack:FindFirstChild("Protein Egg") then
						PlayerData.Player.Backpack["Protein Egg"].Parent = PlayerData.Player.Character
					end
				end
				task.wait(0.1)
			end
		end)
	end
end)

Killing:AddLabel("———————————————————————————————")
ki = Killing:AddLabel("Kill All:")
ki.TextColor3 = Color3.fromRGB(255, 255, 255)
ki.Font = Enum.Font.PermanentMarker
ki.TextSize = 35

_G.whitelistedPlayers = _G.whitelistedPlayers or {}

_G.blacklistedPlayers = _G.blacklistedPlayers or {}

local function isWhitelisted(player)
	for _, name in ipairs(_G.whitelistedPlayers) do
		if name:lower() == player.Name:lower() then return true end
	end
	return false
end

local function isBlacklisted(player)
	for _, name in ipairs(_G.blacklistedPlayers) do
		if name:lower() == player.Name:lower() then return true end
	end
	return false
end

local ad = Killing:AddDropdown("Add to Whitelist", function(selectedText)
	local playerName = selectedText:match("| (.+)$")
	if playerName then
		playerName = playerName:gsub("^%s*(.-)%s*$", "%1")
		for _, name in ipairs(_G.whitelistedPlayers) do
			if name:lower() == playerName:lower() then return end
		end
		table.insert(_G.whitelistedPlayers, playerName)
	end
end)

Killing:AddSwitch("Whitelist Friends", function(bool)
	_G.whitelistFriends = bool
	if bool then
		for _, player in pairs(Services.Players:GetPlayers()) do
			if player ~= Services.Players.LocalPlayer and player:IsFriendsWith(Services.Players.LocalPlayer.UserId) then
				if not isWhitelisted(player) then 
					table.insert(_G.whitelistedPlayers, player.Name) 
				end
			end
		end
		_G.friendWhitelistConnection = Services.Players.PlayerAdded:Connect(function(player)
			if _G.whitelistFriends and player:IsFriendsWith(Services.Players.LocalPlayer.UserId) then
				if not isWhitelisted(player) then
					table.insert(_G.whitelistedPlayers, player.Name)
				end
			end
		end)
		_G.friendCheckLoop = task.spawn(function()
			while _G.whitelistFriends do
				task.wait(3)
				for _, player in pairs(Services.Players:GetPlayers()) do
					if player ~= Services.Players.LocalPlayer and player:IsFriendsWith(Services.Players.LocalPlayer.UserId) then
						if not isWhitelisted(player) then
							table.insert(_G.whitelistedPlayers, player.Name)
							print("EAT MY PUSSY BITCH:", player.Name)
						end
					end
				end
			end
		end)
	else
		if _G.friendWhitelistConnection then
			_G.friendWhitelistConnection:Disconnect()
			_G.friendWhitelistConnection = nil
		end
		if _G.friendCheckLoop then
			task.cancel(_G.friendCheckLoop)
			_G.friendCheckLoop = nil
		end
	end
end)

Killing:AddSwitch("Kill All", function(bool)
	_G.killAll = bool
	if bool then
		if not _G.killAllConnection then
			_G.killAllConnection = Services.RunService.Heartbeat:Connect(function()
				if _G.killAll then
					for _, player in ipairs(Services.Players:GetPlayers()) do
						if player ~= Services.Players.LocalPlayer and not isWhitelisted(player) then killPlayer(player) end
					end
				end
			end)
		end
	else
		if _G.killAllConnection then _G.killAllConnection:Disconnect() _G.killAllConnection = nil end
	end
end)

Killing:AddLabel("———————————————————————————————")
ta = Killing:AddLabel("Targeting:")
ta.TextColor3 = Color3.fromRGB(255, 255, 255)
ta.Font = Enum.Font.PermanentMarker
ta.TextSize = 35

local add = Killing:AddDropdown("Add to Blacklist", function(selectedText)
	local playerName = selectedText:match("| (.+)$")
	if playerName then
		playerName = playerName:gsub("^%s*(.-)%s*$", "%1")
		if not isBlacklisted({Name = playerName}) then table.insert(_G.blacklistedPlayers, playerName) end
	end
end)

for _, player in ipairs(Services.Players:GetPlayers()) do
	if player ~= Services.Players.LocalPlayer then
		ad:Add(player.DisplayName .. " | " .. player.Name)
		add:Add(player.DisplayName .. " | " .. player.Name)
	end
end

Services.Players.PlayerAdded:Connect(function(player)
	if player ~= Services.Players.LocalPlayer then
		ad:Add(player.DisplayName .. " | " .. player.Name)
		add:Add(player.DisplayName .. " | " .. player.Name)
	end
end)

local autoBringEnabled = false
local autoBringConnection

local Players = Services.Players
local RunService = Services.RunService
local LocalPlayer = PlayerData.Player

local function getCharacter()
	PlayerData.Character = LocalPlayer.Character
	return PlayerData.Character
end

local function getRootPart(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function isBlacklistedPlayer(player)
	return _G.blacklistedPlayers and table.find(_G.blacklistedPlayers, player.Name)
end

local function isAlive(player)
	return player
		and player.Character
		and player.Character:FindFirstChildOfClass("Humanoid")
		and player.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

local function zeroVelocity(rootPart)
	if not rootPart then return end

	rootPart.Velocity = Vector3.zero

	if typeof(rootPart.AssemblyLinearVelocity) == "Vector3" then
		rootPart.AssemblyLinearVelocity = Vector3.zero
		rootPart.AssemblyAngularVelocity = Vector3.zero
	end
end

Killing:AddSwitch("Kill [Bring]", function(state)
	autoBringEnabled = state
	if autoBringConnection then
		autoBringConnection:Disconnect()
		autoBringConnection = nil
	end
	if not state then return end
	autoBringConnection = RunService.Heartbeat:Connect(function()
		if not autoBringEnabled then return end
		local character = getCharacter()
		local rootPart = getRootPart(character)
		if not rootPart then return end
		local targetCFrame = rootPart.CFrame * CFrame.new(0, 0, -4)
		local players = Players:GetPlayers()
		for i = 1, #players do
			local player = players[i]
			if player ~= LocalPlayer then
				if isBlacklistedPlayer(player) and isAlive(player) then
					local targetRoot = getRootPart(player.Character)
					if targetRoot then
						pcall(function()
							targetRoot.CFrame = targetCFrame
							zeroVelocity(targetRoot)
						end)
						killPlayer(player)
					end
				end
			end
		end
	end)
end)

Killing:AddSwitch("Kill [No Bring]", function(bool)
	_G.killBlacklistedOnly = bool
	if bool then
		if not _G.blacklistKillConnection then
			_G.blacklistKillConnection = Services.RunService.Heartbeat:Connect(function()
				if _G.killBlacklistedOnly then
					for _, player in ipairs(Services.Players:GetPlayers()) do
						if player ~= Services.Players.LocalPlayer and isBlacklisted(player) then killPlayer(player) end
					end
				end
			end)
		end
	else
		if _G.blacklistKillConnection then _G.blacklistKillConnection:Disconnect() _G.blacklistKillConnection = nil end
	end
end)

local isEnabled = false
local characterAddedConnection = nil
local savedCFrame = nil

local Players = Services.Players
local LocalPlayer = PlayerData.Player

_G.blacklistedPlayers = _G.blacklistedPlayers or {}

local function isBlacklisted(player)
	if not player then return false end
	return table.find(_G.blacklistedPlayers, player.Name) ~= nil
end

local function isAlive(player)
	if not player or not player.Character then return false end
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
	return humanoid and rootPart and humanoid.Health > 0
end

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getTargets()
	local targets = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and isBlacklisted(player) and isAlive(player) then
			table.insert(targets, player)
		end
	end
	return targets
end

local function performKill()
	local character = getCharacter()
	local myRoot = getRoot(character)
	if not myRoot then return end
	for _, target in ipairs(getTargets()) do
		local targetRoot = getRoot(target.Character)
		if targetRoot then
			savedCFrame = myRoot.CFrame
			pcall(function()
				myRoot.CFrame = targetRoot.CFrame
				killPlayer(target)
			end)
			task.wait(0.05)
			if savedCFrame then
				myRoot.CFrame = savedCFrame
			end
			savedCFrame = nil
		end
	end
end

local function startKillTeleport()
	if isEnabled then return end
	isEnabled = true
	if characterAddedConnection then
		characterAddedConnection:Disconnect()
	end
	characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function()
		if isEnabled then
			task.wait(0.15)
			performKill()
		end
	end)
	task.spawn(function()
		while isEnabled do
			performKill()
			task.wait(0.2)
		end
	end)
end

local function stopKillTeleport()
	isEnabled = false
	savedCFrame = nil
	if characterAddedConnection then
		characterAddedConnection:Disconnect()
		characterAddedConnection = nil
	end
end

Killing:AddSwitch("Kill [Teleport] {Size 2} (Choose ONE Player)", function(enabled)
	if enabled then
		startKillTeleport()
	else
		stopKillTeleport()
	end
end):Set(false)

local SpectateData = {
	SelectedPlayer = nil,
	SelectedPlayerUserId = nil,
	Spectating = false,
	CurrentTargetConnection = nil,
	LocalPlayerRespawnConnection = nil,
	CameraMonitorLoop = nil
}

getgenv().SpectateState = getgenv().SpectateState or {
	SavedUserId = nil,
	IsSpectating = false
}

local function stopSpectating()
	if SpectateData.CurrentTargetConnection then
		SpectateData.CurrentTargetConnection:Disconnect()
		SpectateData.CurrentTargetConnection = nil
	end
	if SpectateData.CameraMonitorLoop then
		SpectateData.CameraMonitorLoop = false
	end
	local localPlayer = Services.Players.LocalPlayer
	if localPlayer.Character then
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			PlayerData.Camera.CameraSubject = humanoid
			PlayerData.Camera.CameraType = Enum.CameraType.Custom
		end
	end
	if PlayerData.Humanoid then
		PlayerData.Camera.CameraSubject = PlayerData.Humanoid
	end
end

local function startCameraMonitor()
	if SpectateData.CameraMonitorLoop then
		SpectateData.CameraMonitorLoop = false
		task.wait(0.1)
	end
	SpectateData.CameraMonitorLoop = true
	task.spawn(function()
		while SpectateData.CameraMonitorLoop do
			task.wait(0.1)
			if SpectateData.Spectating and SpectateData.SelectedPlayer then
				local targetChar = SpectateData.SelectedPlayer.Character
				if targetChar then
					local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
					if targetHumanoid then
						if PlayerData.Camera.CameraSubject ~= targetHumanoid then
							PlayerData.Camera.CameraSubject = targetHumanoid
						end
					end
				end
			else
				break
			end
		end
	end)
end

local function updateSpectateTarget(player)
	if not player then
		if SpectateData.SelectedPlayerUserId then
			for _, p in ipairs(Services.Players:GetPlayers()) do
				if p.UserId == SpectateData.SelectedPlayerUserId then
					player = p
					SpectateData.SelectedPlayer = player
					break
				end
			end
		end
		if not player and getgenv().SpectateState.SavedUserId then
			for _, p in ipairs(Services.Players:GetPlayers()) do
				if p.UserId == getgenv().SpectateState.SavedUserId then
					player = p
					SpectateData.SelectedPlayer = player
					SpectateData.SelectedPlayerUserId = p.UserId
					break
				end
			end
		end
		if not player then
			stopSpectating()
			return
		end
	end
	SpectateData.SelectedPlayerUserId = player.UserId
	SpectateData.SelectedPlayer = player
	if SpectateData.CurrentTargetConnection then
		SpectateData.CurrentTargetConnection:Disconnect()
		SpectateData.CurrentTargetConnection = nil
	end
	local function setCamera(char)
		if not SpectateData.Spectating or SpectateData.SelectedPlayerUserId ~= player.UserId then
			return
		end
		local humanoid = char:WaitForChild("Humanoid", 3)
		if humanoid and SpectateData.Spectating and SpectateData.SelectedPlayerUserId == player.UserId then
			PlayerData.Camera.CameraSubject = humanoid
		end
	end
	if player.Character then
		setCamera(player.Character)
	end
	SpectateData.CurrentTargetConnection = player.CharacterAdded:Connect(function(newChar)
		if SpectateData.Spectating and SpectateData.SelectedPlayerUserId == player.UserId then
			setCamera(newChar)
		end
	end)
end

local function updatePlayerList()
	return Services.Players:GetPlayers()
end

local ch = Killing:AddDropdown("Choose Player", function(text)
	for _, player in ipairs(updatePlayerList()) do
		local optionText = player.DisplayName .. " | " .. player.Name
		if text == optionText then
			SpectateData.SelectedPlayer = player
			SpectateData.SelectedPlayerUserId = player.UserId
			getgenv().SpectateState.SavedUserId = player.UserId
			if SpectateData.Spectating then
				updateSpectateTarget(player)
			end
			break
		end
	end
end)

Killing:AddSwitch("Spectate", function(bool)
	SpectateData.Spectating = bool
	getgenv().SpectateState.IsSpectating = bool
	if SpectateData.Spectating then
		if SpectateData.SelectedPlayerUserId then
			getgenv().SpectateState.SavedUserId = SpectateData.SelectedPlayerUserId
		end
		updateSpectateTarget()
		startCameraMonitor()
	else
		stopSpectating()
		task.wait(0.1)
		local localPlayer = Services.Players.LocalPlayer
		if localPlayer.Character then
			local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				PlayerData.Camera.CameraSubject = humanoid
			end
		end
		getgenv().SpectateState.IsSpectating = false
	end
end)

for _, player in ipairs(updatePlayerList()) do
	ch:Add(player.DisplayName .. " | " .. player.Name)
end

Services.Players.PlayerAdded:Connect(function(player)
	ch:Add(player.DisplayName .. " | " .. player.Name)
	if getgenv().SpectateState.IsSpectating and getgenv().SpectateState.SavedUserId == player.UserId then
		SpectateData.Spectating = true
		SpectateData.SelectedPlayer = player
		SpectateData.SelectedPlayerUserId = player.UserId
		updateSpectateTarget(player)
	end
end)

Services.Players.PlayerRemoving:Connect(function(player)
	if player.UserId == SpectateData.SelectedPlayerUserId then
		if SpectateData.Spectating then
			stopSpectating()
			SpectateData.SelectedPlayer = nil
			SpectateData.CurrentTargetConnection = nil
			local localPlayer = Services.Players.LocalPlayer
			if localPlayer.Character and PlayerData.Humanoid then
				PlayerData.Camera.CameraSubject = PlayerData.Humanoid
			end
		end
	end
end)

if SpectateData.LocalPlayerRespawnConnection then
	SpectateData.LocalPlayerRespawnConnection:Disconnect()
end

SpectateData.LocalPlayerRespawnConnection = Services.Players.LocalPlayer.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid", 3)
	if humanoid then
		PlayerData.Humanoid = humanoid
	end
	task.wait(0.1)
	if getgenv().SpectateState.IsSpectating then
		SpectateData.Spectating = true
		updateSpectateTarget()
		startCameraMonitor()
	else
		if PlayerData.Humanoid then
			PlayerData.Camera.CameraSubject = PlayerData.Humanoid
		end
	end
end)

Killing:AddLabel("———————————————————————————————")

local wh = Killing:AddLabel("Whitelist: None")

wh.TextColor3 = Color3.fromRGB(0, 255, 0)
wh.Font = Enum.Font.PermanentMarker
wh.TextSize = 35

Killing:AddButton("Clear Whitelist", function() _G.whitelistedPlayers = {} end)

local bl = Killing:AddLabel("Blacklist: None")

bl.TextColor3 = Color3.fromRGB(255, 0, 0)
bl.Font = Enum.Font.PermanentMarker
bl.TextSize = 35

Killing:AddButton("Clear Blacklist", function() _G.blacklistedPlayers = {} end)

task.spawn(function()
	while true do
		wh.Text = #_G.whitelistedPlayers == 0 and "Whitelist: None" or "Whitelist: " .. table.concat(_G.whitelistedPlayers, ", ")
		bl.Text = #_G.blacklistedPlayers == 0 and "Blacklist: None" or "Blacklist: " .. table.concat(_G.blacklistedPlayers, ", ")
		task.wait(0.01)
	end
end)

local fileName = "Blacklist"..LocalPlayer.Name..".txt"
local blacklistWords = {}
local active = {}
local attackDelay = 0.01
local characterLoaded = false
local autoPunchActive = false

local function trim(s) 
	return s:match("^%s*(.-)%s*$") 
end

local function parseList(text)
	blacklistWords = {}
	if not text or text == "" then return end
	for w in string.gmatch(text, "[^,]+") do
		local t = trim(w):lower()
		if t ~= "" then table.insert(blacklistWords, t) end
	end
end

if isfile(fileName) then
	parseList(readfile(fileName))
else
	writefile(fileName, "")
end

local function saveList()
	writefile(fileName, table.concat(blacklistWords, ","))
end

local function nameMatchesAny(player)
	if not player then return false end
	local dn = (player.DisplayName or ""):lower()
	for _, w in ipairs(blacklistWords) do
		if w ~= "" and string.find(dn, w, 1, true) then
			return true
		end
	end
	return false
end

local function refreshActive()
	for k in pairs(active) do active[k] = nil end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and nameMatchesAny(plr) then
			active[plr] = true
		end
	end
end

function isAnyActive()
	for _ in pairs(active) do
		return true
	end
	return false
end

local function getHands(char)
	repeat task.wait() until char and char:FindFirstChild("RightHand")
	local right = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
	local left = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
	return right, left
end

local function ensurePunchEquipped()
	if not isAnyActive() then return nil end
	local char = LocalPlayer.Character
	if not char then return nil end
	local punch = char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")
	if punch and punch.Parent ~= char then
		punch.Parent = char
	end
	if not punch then
		task.defer(function()
			for i = 1, 40 do
				if not isAnyActive() then return end
				local p = LocalPlayer.Backpack:FindFirstChild("Punch")
				if p then
					p.Parent = LocalPlayer.Character
					break
				end
				task.wait(0.1)
			end
		end)
	end
	return char:FindFirstChild("Punch")
end

local function waitForCharacter()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	characterLoaded = true
	task.spawn(function()
		repeat task.wait() until LocalPlayer:FindFirstChild("Backpack")
		if isAnyActive() then
			for i = 1, 60 do
				local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
				if punch then
					punch.Parent = char
					break
				end
				task.wait(0.1)
			end
		end
	end)
	return char
end

cl = Killing:AddLabel("")

cl.Text = (#blacklistWords == 0 and "Clan Blacklist: None" or "Clan Blacklist: "..table.concat(blacklistWords, ","))

cl.TextColor3 = Color3.fromRGB(255, 0, 0)
cl.Font = Enum.Font.PermanentMarker
cl.TextSize = 35

local addt = Killing:AddTextBox("Add to Blacklist", function(txt)
	parseList((table.concat(blacklistWords, ",")..","..txt))
	saveList()
	cl.Text = (#blacklistWords == 0 and "Clan Blacklist: None" or "Clan Blacklist: "..table.concat(blacklistWords, ","))
	refreshActive()
	if not isAnyActive() then autoPunchActive = false end
end, {["placeholder"] = "ER: KTA, ZTX, ZE"})

addt.Font = Enum.Font.PermanentMarker

local re = Killing:AddTextBox("Remove from Clan Blacklist", function(txt)
	local toRemove = {}
	for w in string.gmatch(txt, "[^,]+") do
		local t = trim(w):lower()
		if t ~= "" then table.insert(toRemove, t) end
	end
	for _, word in ipairs(toRemove) do
		for i = #blacklistWords, 1, -1 do
			if blacklistWords[i] == word then
				table.remove(blacklistWords, i)
			end
		end
	end
	saveList()
	cl.Text = (#blacklistWords == 0 and "Clan Blacklist: None" or "Clan Blacklist: "..table.concat(blacklistWords, ","))
	refreshActive()
	if not isAnyActive() then autoPunchActive = false end
end)

re.Font = Enum.Font.PermanentMarker

RunService.Heartbeat:Connect(function()
	refreshActive()
end)

task.spawn(function()
	while true do
		task.wait(attackDelay)
		if not isAnyActive() then
			continue
		end
		if not LocalPlayer.Character then continue end
		if not characterLoaded then continue end
		local punch = ensurePunchEquipped()
		if not punch then continue end
		local char = LocalPlayer.Character
		local rightHand, leftHand = getHands(char)
		for plr in pairs(active) do
			if plr and plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local hum = plr.Character:FindFirstChild("Humanoid")
				if hrp and hum and hum.Health > 0 then
					pcall(function()
						LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
						LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
					end)
					pcall(function()
						firetouchinterest(rightHand, hrp, 1)
						firetouchinterest(leftHand, hrp, 1)
						firetouchinterest(rightHand, hrp, 0)
						firetouchinterest(leftHand, hrp, 0)
					end)
				end
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr:GetPropertyChangedSignal("DisplayName"):Connect(function()
		refreshActive()
	end)
end)

LocalPlayer.CharacterAdded:Connect(function()
	characterLoaded = false
	task.wait(0.1)
	waitForCharacter()
	refreshActive()
	if isAnyActive() then
		task.defer(function()
			for i = 1, 50 do
				if not isAnyActive() then break end
				ensurePunchEquipped()
				task.wait(0.1)
			end
		end)
	end
end)
waitForCharacter()
refreshActive()

local PlayerStatsLabel = Stats:AddLabel("Stats:")

PlayerStatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerStatsLabel.Font = Enum.Font.PermanentMarker
PlayerStatsLabel.TextSize = 35

local StatsLabel = Enum.Font.PermanentMarker

local SpecsData = {
	PlayerToInspect = nil,
	EmojiMap = {
		["Strength"] = utf8.char(0x1F4AA),
		["Durability"] = utf8.char(0x1F4AA),
	},
	StatDefinitions = {
		{name = "Strength", statName = "Strength"},
		{name = "Durability", statName = "Durability"},
	},
	StatLabels = {}
}

local cho = Stats:AddDropdown("Choose Player", function(text)
	for _, player in ipairs(Services.Players:GetPlayers()) do
		if text == player.DisplayName .. " | " .. player.Name then
			SpecsData.PlayerToInspect = player
			break
		end
	end
end)

for _, player in ipairs(Services.Players:GetPlayers()) do
	cho:Add(player.DisplayName .. " | " .. player.Name)
end

Services.Players.PlayerAdded:Connect(function(player)
	cho:Add(player.DisplayName .. " | " .. player.Name)
end)

Services.Players.PlayerRemoving:Connect(function()
	cho:Clear()
	for _, p in ipairs(Services.Players:GetPlayers()) do
		cho:Add(p.DisplayName .. " | " .. p.Name)
	end
end)

for _, info in ipairs(SpecsData.StatDefinitions) do
	local label = Stats:AddLabel(
		SpecsData.EmojiMap[info.name] .. " " .. info.name .. ": N/A"
	)
	label.Font = StatsLabel
	label.TextColor3 = Color3.fromRGB(255, 255, 0)
	SpecsData.StatLabels[info.name] = label
end

local function updateStatLabels(targetPlayer)
	if not targetPlayer then return end
	if not targetPlayer:FindFirstChild("leaderstats") then return end
	for _, info in ipairs(SpecsData.StatDefinitions) do
		local statObject =
			targetPlayer.leaderstats:FindFirstChild(info.statName)
			or targetPlayer:FindFirstChild(info.statName)
		if statObject then
			SpecsData.StatLabels[info.name].Text =
				string.format(
					"%s %s: %s (%s)",
					SpecsData.EmojiMap[info.name] or "",
					info.name,
					Utils.formatNumber(statObject.Value),
					Utils.formatWithCommas(statObject.Value)
				)
		else
			SpecsData.StatLabels[info.name].Text =
				SpecsData.EmojiMap[info.name] .. " " .. info.name .. ": 0 (0)"
		end
	end
end

task.spawn(function()
	while true do
		if SpecsData.PlayerToInspect then
			updateStatLabels(SpecsData.PlayerToInspect)
		end
		task.wait(0.1)
	end
end)

Stats:AddLabel("———————————————————————————————")

local adv = Stats:AddLabel("Advanced Stats:")
adv.Font = StatsLabel
adv.TextColor3 = Color3.fromRGB(255, 255, 255)
adv.TextSize = 35

local function createStatLabel(text)
	local label = Stats:AddLabel(text)
	label.Font = StatsLabel
	return label
end

local AdvancedStats = {
	HealthLabel = createStatLabel("Enemy Health: N/A"),
	EnemyDamageLabel = createStatLabel("Enemy Damage: N/A"),
	PlayerHealthLabel = createStatLabel("Your Health: N/A"),
	PlayerDamageLabel = createStatLabel("Your Damage: N/A"),
	HitsToKillLabel = createStatLabel("Hits to Kill: N/A")
}

AdvancedStats.HealthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
AdvancedStats.EnemyDamageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

AdvancedStats.PlayerHealthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
AdvancedStats.PlayerDamageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
AdvancedStats.HitsToKillLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local StatsCache = {
	health = 0,
	enemyDamage = 0,
	playerHealth = 0,
	playerDamage = 0,
	hitsToKill = "N/A"
}

local function calculatePlayerHealth(targetPlayer)
	if not targetPlayer then return 0 end
	local durabilityStat =
		targetPlayer:FindFirstChild("Durability")
		or (targetPlayer:FindFirstChild("leaderstats") and targetPlayer.leaderstats:FindFirstChild("Durability"))

	if not durabilityStat then return 0 end
	local totalMultiplier = 1
	if targetPlayer:FindFirstChild("ultimatesFolder")
		and targetPlayer.ultimatesFolder:FindFirstChild("Infernal Health") then
		totalMultiplier += 0.15 * (targetPlayer.ultimatesFolder["Infernal Health"].Value or 0)
	end
	if targetPlayer:FindFirstChild("equippedPets") then
		for _, petValue in ipairs(targetPlayer.equippedPets:GetChildren()) do
			if petValue:IsA("ObjectValue") and petValue.Value then
				local name = string.lower(petValue.Value.Name)
				if name:match("mighty") and name:match("monster") then
					totalMultiplier += 0.5
				end
				if name:match("small") and name:match("fry") then
					totalMultiplier += 0.25
				end
			end
		end
	end
	return durabilityStat.Value * totalMultiplier
end

local function calculatePlayerDamage(targetPlayer)
	if not targetPlayer then return 0 end
	if not targetPlayer:FindFirstChild("leaderstats") then return 0 end
	if not targetPlayer.leaderstats:FindFirstChild("Strength") then return 0 end
	local baseDamage = targetPlayer.leaderstats.Strength.Value * 0.0666666666667
	local totalMultiplier = 1
	if targetPlayer:FindFirstChild("ultimatesFolder")
		and targetPlayer.ultimatesFolder:FindFirstChild("Demon Damage") then
		totalMultiplier += 0.1 * (targetPlayer.ultimatesFolder["Demon Damage"].Value or 0)
	end
	if targetPlayer:FindFirstChild("equippedPets") then
		for _, petValue in ipairs(targetPlayer.equippedPets:GetChildren()) do
			if petValue:IsA("ObjectValue") and petValue.Value then
				local name = string.lower(petValue.Value.Name)
				if name:match("wild") and name:match("wizard") then
					totalMultiplier += 0.5
				end
				if name:match("chaos") and name:match("sorcerer") then
					totalMultiplier += 0.25
				end
			end
		end
	end
	return baseDamage * totalMultiplier
end

local function updateAdvancedStats(targetPlayer)
	if not targetPlayer then return end
	StatsCache.health = calculatePlayerHealth(targetPlayer)
	StatsCache.enemyDamage = calculatePlayerDamage(targetPlayer)
	StatsCache.playerHealth = calculatePlayerHealth(PlayerData.Player)
	StatsCache.playerDamage = calculatePlayerDamage(PlayerData.Player)
	StatsCache.hitsToKill =
		StatsCache.playerDamage <= 0 and "∞"
		or (math.ceil(StatsCache.health / StatsCache.playerDamage) > 200 and "∞"
		or (math.ceil(StatsCache.health / StatsCache.playerDamage) < 1 and "instant"
		or math.ceil(StatsCache.health / StatsCache.playerDamage)))
	AdvancedStats.HealthLabel.Text =
		string.format("Enemy Health: %s (%s)",
			Utils.formatNumber(StatsCache.health),
			Utils.formatWithCommas(StatsCache.health)
		)
	AdvancedStats.EnemyDamageLabel.Text =
		string.format("Enemy Damage: %s (%s)",
			Utils.formatNumber(StatsCache.enemyDamage),
			Utils.formatWithCommas(StatsCache.enemyDamage)
		)
	AdvancedStats.PlayerHealthLabel.Text =
		string.format("Your Health: %s (%s)",
			Utils.formatNumber(StatsCache.playerHealth),
			Utils.formatWithCommas(StatsCache.playerHealth)
		)
	AdvancedStats.PlayerDamageLabel.Text =
		string.format("Your Damage: %s (%s)",
			Utils.formatNumber(StatsCache.playerDamage),
			Utils.formatWithCommas(StatsCache.playerDamage)
		)
	AdvancedStats.HitsToKillLabel.Text =
		string.format("Hits to Kill: %s", tostring(StatsCache.hitsToKill))
end

task.spawn(function()
	while true do
		updateAdvancedStats(SpecsData.PlayerToInspect)
		task.wait(0.1)
	end
end)

mis = Godmode:AddLabel("Misc:")
mis.TextColor3 = Color3.fromRGB(255, 255, 255)
mis.Font = Enum.Font.PermanentMarker
mis.TextSize = 35

local pa = Godmode:AddLabel("Pack Delay: 0.35s")
pa.TextColor3 = Color3.fromRGB(255, 165, 0)
pa.Font = Enum.Font.PermanentMarker
pa.TextSize = 20

local equipEvent = ReplicatedStorage.rEvents.equipPetEvent

local min = math.min
local pcall = pcall

local cache = {
	WildWizard = {},
	MightyMonster = {}
}

local active = false
local loopRunning = false
local spamDelay = 0.35

local function cachePets()
	local wild = cache.WildWizard
	local mighty = cache.MightyMonster
	table.clear(wild)
	table.clear(mighty)
	local petsFolder = player:FindFirstChild("petsFolder")
	if not petsFolder then return end
	local unique = petsFolder:FindFirstChild("Unique")
	if not unique then return end
	local children = unique:GetChildren()
	for i = 1, #children do
		local p = children[i]
		local name = p.Name
		if name == "Wild Wizard" then
			wild[#wild + 1] = p
		elseif name == "Mighty Monster" then
			mighty[#mighty + 1] = p
		end
	end
end

local function fire(action, pet)
	pcall(equipEvent.FireServer, equipEvent, action, pet)
end

local function swap(unequipList, equipList)
	for i = 1, #unequipList do
		fire("unequipPet", unequipList[i])
	end
	local limit = min(8, #equipList)
	for i = 1, limit do
		fire("equipPet", equipList[i])
	end
end

local function unequipAll()
	for i = 1, #cache.WildWizard do
		fire("unequipPet", cache.WildWizard[i])
	end
	for i = 1, #cache.MightyMonster do
		fire("unequipPet", cache.MightyMonster[i])
	end
end

local function runLoop()
	if loopRunning then return end
	loopRunning = true
	task.spawn(function()
		while active do
			swap(cache.MightyMonster, cache.WildWizard)
			task.wait(spamDelay)
			if not active then break end
			swap(cache.WildWizard, cache.MightyMonster)
			task.wait(spamDelay)
		end
		loopRunning = false
	end)
end

local se = Godmode:AddDropdown("Select Delay", function(text)
	if text == "0.7s" then
		spamDelay = 0.7
	elseif text == "0.35s" then
		spamDelay = 0.35
	elseif text == "0.175s" then
		spamDelay = 0.175
	elseif text == "0.0875s" then
		spamDelay = 0.0875
	end

	pa.Text = "Pack Delay: " .. text
end)

se:Add("0.7s")
se:Add("0.35s")
se:Add("0.175s")
se:Add("0.0875s")

Godmode:AddSwitch("Pack Spam", function(enabled)
	if active == enabled then return end
	active = enabled
	if enabled then
		cachePets()
		runLoop()
	else
		unequipAll()
	end
end)

local rEvents = ReplicatedStorage:WaitForChild("rEvents", 5)
local equipPetEvent = rEvents and rEvents:WaitForChild("equipPetEvent", 5)

local petsFolder = player:WaitForChild("petsFolder", 10)
local uniqueFolder = petsFolder and petsFolder:WaitForChild("Unique", 10)
local mightyMonsters = {}

local function rebuildMightyList()
    table.clear(mightyMonsters)
    if not uniqueFolder then return end
    for _, pet in ipairs(uniqueFolder:GetChildren()) do
        if pet.Name == "Mighty Monster" then
            mightyMonsters[#mightyMonsters + 1] = pet
        end
    end
end

if uniqueFolder then
    rebuildMightyList()
    uniqueFolder.ChildAdded:Connect(function(child)
        if child.Name == "Mighty Monster" then
            mightyMonsters[#mightyMonsters + 1] = child
        end
    end)
    uniqueFolder.ChildRemoved:Connect(function(child)
        for i = #mightyMonsters, 1, -1 do
            if mightyMonsters[i] == child then
                mightyMonsters[i] = mightyMonsters[#mightyMonsters]
                mightyMonsters[#mightyMonsters] = nil
                break
            end
        end
    end)
end

local function equipCycle()
    if not petsFolder or not equipPetEvent then return end
    local folders = petsFolder:GetChildren()
    for i = 1, #folders do
        local folder = folders[i]
        if folder:IsA("Folder") then
            local pets = folder:GetChildren()
            for j = 1, #pets do
                equipPetEvent:FireServer("unequipPet", pets[j])
            end
        end
    end
    local limit = (#mightyMonsters < 8) and #mightyMonsters or 8
    for i = 1, limit do
        local pet = mightyMonsters[i]
        if pet and pet.Parent then
            equipPetEvent:FireServer("equipPet", pet)
        end
    end
end

local lastRespawnTime = os.clock()
local currentHum = nil

player.CharacterAdded:Connect(function(char)
    lastRespawnTime = os.clock()
    currentHum = char:WaitForChild("Humanoid", 5)
end)

if player.Character then 
    currentHum = player.Character:FindFirstChild("Humanoid") 
end

local isSpamming = false

Godmode:AddSwitch("Spawn With Pack HP", function(b)
    isSpamming = b
    if b then
        task.spawn(function()
            while isSpamming do
                local isDead = not currentHum or currentHum.Health <= 0
                local recentlySpawned = (os.clock() - lastRespawnTime) <= 3
                if isDead or recentlySpawned then
                    equipCycle()
                end
                task.wait(0.1)
            end
        end)
    end
end):Set(false)

local GymLocations = {
	{name = "Tiny Island", pos = CFrame.new(-37.1, 9.2, 1919)},
	{name = "Main Island", pos = CFrame.new(16.07, 9.08, 133.8)},
	{name = "Beach", pos = CFrame.new(-8, 9, -169.2)},
	{name = "Muscle king Gym", pos = CFrame.new(-8665.4, 17.21, -5792.9)},
	{name = "Jungle Gym", pos = CFrame.new(-8543, 6.8, 2400)},
	{name = "Legends Gym", pos = CFrame.new(4516, 991.5, -3856)},
	{name = "Infernal Gym", pos = CFrame.new(-6759, 7.36, -1284)},
	{name = "Mythical Gym", pos = CFrame.new(2250, 7.37, 1073.2)},
	{name = "Frost Gym", pos = CFrame.new(-2623, 7.36, -409)}
}

local isGymTeleportEnabled = false

local gymLocationCount = #GymLocations
local localPlayer = PlayerData.Player
local stepWait = task.wait

local function getHumanoidRootPart()
	local character = localPlayer.Character
	if not character then return nil end
	return character:FindFirstChild("HumanoidRootPart")
end

Godmode:AddSwitch("Gym Teleport", function(enabled)
	isGymTeleportEnabled = enabled
	if enabled then
		task.spawn(function()
			local currentIndex = 1
			while isGymTeleportEnabled do
				local hrp = getHumanoidRootPart()
				if hrp then
					local location = GymLocations[currentIndex]
					hrp.CFrame = location.pos
					currentIndex = (currentIndex % gymLocationCount) + 1
				end
				stepWait(0.01)
			end
		end)
	end
end)

local autoTeleportEnabled = false

local humanoidRootPart
local targetPositionCFrame = CFrame.new(-8, 0, -1000)

local function onCharacterAdded(character)
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)
if localPlayer.Character then
    onCharacterAdded(localPlayer.Character)
end

Godmode:AddSwitch("Auto TP to Water", function(enabled)
    autoTeleportEnabled = enabled
end)

RunService.Heartbeat:Connect(function()
    if not autoTeleportEnabled then return end
    if not humanoidRootPart or not humanoidRootPart.Parent then return end
    humanoidRootPart.CFrame = targetPositionCFrame
end)

local changeSizeRemote = game:GetService("ReplicatedStorage")
.rEvents.changeSpeedSizeRemote

for _, size in ipairs({1, 2, 15, 30}) do
    Godmode:AddButton("Size " .. size, function()
        changeSizeRemote:InvokeServer("changeSize", size)
    end)
end

Godmode:AddLabel("———————————————————————————————")
go = Godmode:AddLabel("Godmode Kill:")
go.TextColor3 = Color3.fromRGB(255, 255, 255)
go.Font = Enum.Font.PermanentMarker
go.TextSize = 35

local brawlRemote = ReplicatedStorage.rEvents.brawlEvent

local brawlModeEnabled = false

Godmode:AddSwitch("Brawl Mode", function(state)
    brawlModeEnabled = state
    if state then
        task.spawn(function()
            while brawlModeEnabled do
                brawlRemote:FireServer("joinBrawl")
                task.wait()
            end
        end)
    end
end)

local isBrawlEnabled = false

local isFollowing = false
local currentTargetName = nil

local playerLookup = {}

local function formatPlayerLabel(player)
    return string.format("%s | %s", player.DisplayName, player.Name)
end

local function updatePlayerLookup()
    table.clear(playerLookup)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            playerLookup[formatPlayerLabel(player)] = player
        end
    end
end

local function moveBehindTarget(targetPlayer)
    local myCharacter = LocalPlayer.Character
    local targetCharacter = targetPlayer.Character
    if not (myCharacter and targetCharacter) then return end
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if myRoot and targetRoot then
        local behindPosition = targetRoot.Position - (targetRoot.CFrame.LookVector * 3)
        myRoot.CFrame = CFrame.new(behindPosition, targetRoot.Position)
    end
end

local sel = Godmode:AddDropdown("Select Player", function(selectedLabel)
    local selectedPlayer = playerLookup[selectedLabel]
    if selectedPlayer then
        currentTargetName = selectedPlayer.Name
        isFollowing = true
        print("Now following:", selectedPlayer.Name)
        moveBehindTarget(selectedPlayer)
    end
end)

updatePlayerLookup()
for label in pairs(playerLookup) do
    sel:Add(label)
end

local function refreshDropdown()
    sel:Clear()
    updatePlayerLookup()
    for label in pairs(playerLookup) do
        sel:Add(label)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        refreshDropdown()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    refreshDropdown()
    if currentTargetName == player.Name then
        currentTargetName = nil
        isFollowing = false
    end
end)

Godmode:AddButton("Stop Following", function()
    isFollowing = false
    currentTargetName = nil
    print("Stopped following")
end)

task.spawn(function()
    while task.wait(0.03) do
        if isFollowing and currentTargetName then
            local targetPlayer = Players:FindFirstChild(currentTargetName)
            if targetPlayer then
                moveBehindTarget(targetPlayer)
            else
                isFollowing = false
                currentTargetName = nil
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if isFollowing and currentTargetName then
        local targetPlayer = Players:FindFirstChild(currentTargetName)
        if targetPlayer then
            moveBehindTarget(targetPlayer)
        end
    end
end)

Godmode:AddSwitch("Brawl Mode [Auto Slam]", function(enabled)
    isBrawlEnabled = enabled
    if enabled then
        task.spawn(function()
            local player = LocalPlayer
            while isBrawlEnabled do
                brawlRemote:FireServer("joinBrawl")

                local character = player.Character
                local slamTool =
                    player.Backpack:FindFirstChild("Ground Slam")
                    or (character and character:FindFirstChild("Ground Slam"))
                if slamTool then
                    if slamTool.Parent == player.Backpack and character then
                        slamTool.Parent = character
                    end
                    local attackCooldown = slamTool:FindFirstChild("attackTime")
                    if attackCooldown then
                        attackCooldown.Value = 0
                    end
                    player.muscleEvent:FireServer("slam")
                    slamTool:Activate()
                end
                task.wait(0.1)
            end
        end)
    end
end)

local autoSlamEnabled = false

Godmode:AddSwitch("Auto Slam", function(state)
    autoSlamEnabled = state
    if state then
        task.spawn(function()
            local player = LocalPlayer
            while autoSlamEnabled do
                local character = player.Character
                local groundSlam =
                    player.Backpack:FindFirstChild("Ground Slam")
                    or (character and character:FindFirstChild("Ground Slam"))
                if groundSlam then
                    if groundSlam.Parent == player.Backpack then
                        groundSlam.Parent = character
                    end
                    local cooldown = groundSlam:FindFirstChild("attackTime")
                    if cooldown then
                        cooldown.Value = 0
                    end
                    player.muscleEvent:FireServer("slam")
                    groundSlam:Activate()
                end
                task.wait(0.1)
            end
        end)
    end
end)

local isBrawlEnabled = false

local autoStompEnabled = false

Godmode:AddSwitch("Auto Stomp", function(state)
    autoStompEnabled = state
    if state then
        task.spawn(function()
            local player = LocalPlayer
            while autoStompEnabled do
                local character = player.Character
                local stompTool =
                    player.Backpack:FindFirstChild("Stomp")
                    or (character and character:FindFirstChild("Stomp"))
                if stompTool then
                    if stompTool.Parent == player.Backpack then
                        stompTool.Parent = character
                    end
                    local cooldown = stompTool:FindFirstChild("attackTime")
                    if cooldown then
                        cooldown.Value = 0
                    end
                    player.muscleEvent:FireServer("stomp")
                    stompTool:Activate()
                end
                task.wait(0.1)
            end
        end)
    end
end)

local inventoryLabel = Inventory:AddLabel("Inventory:")

inventoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryLabel.Font = Enum.Font.PermanentMarker
inventoryLabel.TextSize = 35

local eggEaterState = { running = false }

task.spawn(function()
	while true do
		if eggEaterState.running then
			local tool =
				PlayerData.Player.Character:FindFirstChild("Protein Egg")
				or PlayerData.Player.Backpack:FindFirstChild("Protein Egg")
			if tool then
				PlayerData.Player.muscleEvent:FireServer("proteinEgg", tool)
			end
			task.wait(0.1)
		else
			task.wait(1)
		end
	end
end)

Inventory:AddSwitch("Eat All Eggs", function(state)
	eggEaterState.running = state
end):Set(false)

local boostState = {
	itemList = {
		"Tropical Shake",
		"Energy Shake",
		"Protein Bar",
		"TOUGH Bar",
		"Protein Shake",
		"ULTRA Shake",
		"Energy Bar",
	},
	running = false,
}

task.spawn(function()
	while true do
		if boostState.running then
			for _, itemName in ipairs(boostState.itemList) do
				local tool =
					PlayerData.Player.Character:FindFirstChild(itemName)
					or PlayerData.Player.Backpack:FindFirstChild(itemName)
				if tool then
					local parts = {}
					for word in itemName:gmatch("%S+") do
						table.insert(parts, word:lower())
					end
					for i = 2, #parts do
						parts[i] = parts[i]:sub(1, 1):upper() .. parts[i]:sub(2)
					end
					for _ = 1, 10 do
						PlayerData.Player.muscleEvent:FireServer(table.concat(parts), tool)
					end
				end
			end
		end
		task.wait(0.1)
	end
end)

Inventory:AddSwitch("Eat Everything Except Eggs", function(state)
	boostState.running = state
end)

Inventory:AddLabel("———————————————————————————————")

local eggGiftingLabel = Inventory:AddLabel("Egg Gifting:")

eggGiftingLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
eggGiftingLabel.Font = Enum.Font.PermanentMarker
eggGiftingLabel.TextSize = 35

local eggGifterState = {
	eggCountLabel = Inventory:AddLabel("Eggs: 0"),
	selectedPlayer = nil,
	eggAmount = 0,
}

eggGifterState.eggCountLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
eggGifterState.eggCountLabel.Font = Enum.Font.PermanentMarker
eggGifterState.eggCountLabel.TextSize = 25

local eggPlayerDropdown = Inventory:AddDropdown("Choose Player", function(name)
	local username = name:match(" | (.+)") or name
	eggGifterState.selectedPlayer = Services.Players:FindFirstChild(username)
end)

for _, player in ipairs(Services.Players:GetPlayers()) do
	if player ~= Services.Players.LocalPlayer then
		eggPlayerDropdown:Add(player.DisplayName .. " | " .. player.Name)
	end
end

Services.Players.PlayerAdded:Connect(function(player)
	if player ~= Services.Players.LocalPlayer then
		eggPlayerDropdown:Add(player.DisplayName .. " | " .. player.Name)
	end
end)

Services.Players.PlayerRemoving:Connect(function(player)
	eggPlayerDropdown:Remove(player.DisplayName .. " | " .. player.Name)

	if eggGifterState.selectedPlayer == player then
		eggGifterState.selectedPlayer = nil
	end
end)

local eggAmountInput = Inventory:AddTextBox("Amount:", function(text)
	eggGifterState.eggAmount = tonumber(text)
end)

eggAmountInput.Font = Enum.Font.PermanentMarker

Inventory:AddButton("Start Gifting", function()
	if eggGifterState.selectedPlayer and eggGifterState.eggAmount and eggGifterState.eggAmount > 0 then
		local egg =
			Services.Players.LocalPlayer.consumablesFolder:FindFirstChild("Protein Egg")
		if egg then
			for _ = 1, eggGifterState.eggAmount do
				pcall(function()
					Services.ReplicatedStorage.rEvents.giftRemote:InvokeServer(
						"giftRequest",
						eggGifterState.selectedPlayer,
						egg
					)
				end)
				task.wait(0.1)
			end
		end
	end
end)

Inventory:AddLabel("———————————————————————————————")

local shakeGiftingLabel = Inventory:AddLabel("Shake Gifting:")

shakeGiftingLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
shakeGiftingLabel.Font = Enum.Font.PermanentMarker
shakeGiftingLabel.TextSize = 35

local shakeGifterState = {
	shakeCountLabel = Inventory:AddLabel("Tropical Shakes: 0"),
	selectedPlayer = nil,
	shakeAmount = 0,
}

shakeGifterState.shakeCountLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
shakeGifterState.shakeCountLabel.Font = Enum.Font.PermanentMarker
shakeGifterState.shakeCountLabel.TextSize = 25

local shakePlayerDropdown = Inventory:AddDropdown("Choose Player", function(name)
	local username = name:match(" | (.+)") or name
	shakeGifterState.selectedPlayer = Services.Players:FindFirstChild(username)
end)

for _, player in ipairs(Services.Players:GetPlayers()) do
	if player ~= Services.Players.LocalPlayer then
		shakePlayerDropdown:Add(player.DisplayName .. " | " .. player.Name)
	end
end

Services.Players.PlayerAdded:Connect(function(player)
	if player ~= Services.Players.LocalPlayer then
		shakePlayerDropdown:Add(player.DisplayName .. " | " .. player.Name)
	end
end)

Services.Players.PlayerRemoving:Connect(function(player)
	shakePlayerDropdown:Remove(player.DisplayName .. " | " .. player.Name)

	if shakeGifterState.selectedPlayer == player then
		shakeGifterState.selectedPlayer = nil
	end
end)

local shakeAmountInput = Inventory:AddTextBox("Amount:", function(text)
	shakeGifterState.shakeAmount = tonumber(text)
end)

shakeAmountInput.Font = Enum.Font.PermanentMarker

Inventory:AddButton("Start Gifting", function()
	if shakeGifterState.selectedPlayer and shakeGifterState.shakeAmount and shakeGifterState.shakeAmount > 0 then
		for _ = 1, shakeGifterState.shakeAmount do
			Services.ReplicatedStorage.rEvents.giftRemote:InvokeServer(
				"giftRequest",
				shakeGifterState.selectedPlayer,
				Services.Players.LocalPlayer.consumablesFolder:FindFirstChild("Tropical Shake")
			)
		end
	end
end)

task.spawn(function()
	while true do
		local eggCount = 0
		local shakeCount = 0
		if PlayerData.Backpack then
			for _, item in ipairs(PlayerData.Backpack:GetChildren()) do
				if item.Name == "Protein Egg" then
					eggCount += 1
				elseif item.Name == "Tropical Shake" then
					shakeCount += 1
				end
			end
		end
		eggGifterState.eggCountLabel.Text = "Protein Eggs: " .. eggCount
		shakeGifterState.shakeCountLabel.Text = "Tropical Shakes: " .. shakeCount
		task.wait(7.5)
	end
end)