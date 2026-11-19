-- [[ Elma Hub V1 - Rivals (Custom 350x300 Left-Tab Linoria UI + Full Features) ]]
local repo = "https://raw.githubusercontent.com/Haazfftrfcc/ELISBEST/main/[span_0](start_span)[span_1](start_span)"[span_0](end_span)[span_1](end_span)

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()[span_2](start_span)[span_2](end_span)[span_3](start_span)[span_3](end_span)
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()[span_4](start_span)[span_4](end_span)[span_5](start_span)[span_5](end_span)
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()[span_6](start_span)[span_6](end_span)[span_7](start_span)[span_7](end_span)

local Window = Library:CreateWindow({
	Title = "Elma Hub V1 | Rivals",
})

local Tabs = {
	Main = Window:AddTab("Main"),
	Visuals = Window:AddTab("Visuals"),
	Movement = Window:AddTab("Movement"),
	Misc = Window:AddTab("Misc"),
}

-- Main 탭 그룹박스 순서: 1(좌) Ragebot & Movement / 2(우) Aimbot & FOV Controls / 3(좌) Desync / Orbit Settings
local MainGroup = Tabs.Main:AddGroupbox("Ragebot & Movement")
local AimbotGroup = Tabs.Main:AddGroupbox("Aimbot & FOV Controls")
local MobileGroup = Tabs.Main:AddGroupbox("Desync / Orbit Settings")

-- Visuals 탭 그룹박스: 1(좌) ESP Controls
local EspGroup = Tabs.Visuals:AddGroupbox("ESP Controls")

-- Movement 탭 그룹박스: 1(좌) Fly Settings / 2(우) Noclip Settings
local FlyGroup = Tabs.Movement:AddGroupbox("Fly Settings")
local NoclipGroup = Tabs.Movement:AddGroupbox("Noclip Settings")

-- Misc 탭 그룹박스: 1(좌) Misc Controls
local MiscGroup = Tabs.Misc:AddGroupbox("Misc Controls")

-- ==========================================
-- [서비스 및 모듈 초기화]
-- ==========================================

local repS = cloneref(game:GetService("ReplicatedStorage"))
local plrs = cloneref(game:GetService("Players"))
local runS = cloneref(game:GetService("RunService"))
local ws = cloneref(game:GetService("Workspace"))
local UIS = cloneref(game:GetService("UserInputService"))
local lplr = plrs.LocalPlayer
local camera = ws.CurrentCamera

local util = require(repS.Modules.Utility)
local enum = require(repS.Modules.EnumLibrary)
local FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
local SpectateController = require(lplr.PlayerScripts.Controllers:WaitForChild("SpectateController"))

local PlayerModule = require(lplr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local ControlModule = PlayerModule:GetControls()

getgenv().Config = {
	Enabled = true,
	FireRate = 0.000001, -- 요청하신 기본값 0.000001 적용
	WeaponSlot = "Primary",
	EmoteID = 83194012641579,
	StopOnMove = false,
	FadeIn = 0.1,
	FadeOut = 0.1,
	Weight = 1,
	Speed = 1,
	AllowInvisible = true,

	-- 이동 모드 설정 ('RandomTeleport', 'VoidSpam', 'Orbit', 'Behind')
	MoveMode = "RandomTeleport",

	-- Random Teleport Settings & Bounds Protection:
	RandomTeleport = true,
	MinTeleportRadius = 3,
	MaxTeleportRadius = 8,
	HeightOffsetMin = -1,
	HeightOffsetMax = 3,
	BehindDistance = 5,
	DeathDropThreshold = -5.5,

	-- VoidSpam Settings (Y좌표 흔들기)
	VoidMinY = -45,
	VoidMaxY = 12,
	VoidJitterXZ = 4,

	-- Orbit Settings
	OrbitSpeed = 30,
	OrbitRadius = 7.1,
	OrbitHeight = 15,

	-- Aimbot Settings
	AimbotEnabled = false,
	FovRadius = 150,
	TeamCheck = false,
	KillCheck = false,
	WallCheck = false,
	TargetPartName = "Head",
	CustomColor = Color3.fromRGB(255, 255, 255),
	RainbowColor = false,
	FovFilled = true,
	FovFillTransparency = 0.15,
	CrosshairVisible = true,

	-- ESP Settings
	EspEnabled = false,
	EspMaxRange = 500,
	EspFillColor = Color3.fromRGB(255, 0, 255),
	EspOutlineColor = Color3.fromRGB(255, 255, 255),
	EspFillTrans = 0.6,

	-- Fly Settings
	FlyEnabled = false,
	FlySpeed = 50,

	-- Noclip Settings
	NoclipEnabled = false,

	-- Rivals Arena Bounds Limits
	MinBoundsY = 0,
	MaxBoundsY = 200,
	MaxDistanceFromTarget = 25,
}

-- Anti-Kill / Hazard / Chainsaw & SubSpace Tripmine Void Cleaner
local function handleDangerousItems()
	for _, obj in ipairs(ws:GetDescendants()) do
		local name = obj.Name:lower()
		if name:find("kill") or name:find("lava") or name:find("death") or name:find("hazard") or name:find("damage") or name:find("chainsaw") or name:find("subspace tripmine") then
			pcall(function()
				if obj:IsA("BasePart") then
					obj.CFrame = CFrame.new(obj.Position.X, -500, obj.Position.Z)
					obj.AssemblyLinearVelocity = Vector3.zero
					obj.AssemblyAngularVelocity = Vector3.zero
					obj.Anchored = true
				elseif obj:IsA("Model") then
					local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
					if primary then
						primary.CFrame = CFrame.new(primary.Position.X, -500, primary.Position.Z)
						primary.Anchored = true
					end
				end
			end)
		end
	end
end

task.spawn(function()
	while true do
		handleDangerousItems()
		task.wait(0.5)
	end
end)

ws.DescendantAdded:Connect(function(obj)
	local name = obj.Name:lower()
	if name:find("kill") or name:find("lava") or name:find("death") or name:find("hazard") or name:find("damage") or name:find("chainsaw") or name:find("subspace tripmine") then
		pcall(function()
			if obj:IsA("BasePart") then
				obj.CFrame = CFrame.new(obj.Position.X, -500, obj.Position.Z)
				obj.AssemblyLinearVelocity = Vector3.zero
				obj.AssemblyAngularVelocity = Vector3.zero
				obj.Anchored = true
			elseif obj:IsA("Model") then
				local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
				if primary then
					primary.CFrame = CFrame.new(primary.Position.X, -500, primary.Position.Z)
					primary.Anchored = true
				end
			end
		end)
	end
end)

local slots = {
	Primary = 1,
	Secondary = 2,
	Melee = 3,
}

local function getSlotNumber()
	return slots[getgenv().Config.WeaponSlot] or 1
end

task.spawn(function()
	local localFighter = FighterController.LocalFighter
	while not localFighter do
		task.wait(0.1)
		localFighter = FighterController.LocalFighter
	end
	pcall(function() localFighter:EquipItem(getSlotNumber()) end)
end)

task.spawn(function()
	while true do
		task.wait(1)
		if not getgenv().Config.Enabled then continue end
		local localFighter = FighterController.LocalFighter
		if localFighter then
			pcall(function() localFighter:EquipItem(getSlotNumber()) end)
		end
	end
end)

-- Emote Player Logic
local CurrentTrack
local character = lplr.Character or lplr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local lastPosition = character.PrimaryPart and character.PrimaryPart.Position or Vector3.new()

lplr.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	lastPosition = character.PrimaryPart and character.PrimaryPart.Position or Vector3.new()
end)

local function LoadTrack(id)
	if CurrentTrack then CurrentTrack:Stop(0) end
	local animId = "rbxassetid://" .. tostring(id)
	local ok, result = pcall(function() return game:GetObjects(animId) end)
	if ok and result and #result > 0 then
		local anim = result[1]
		if anim:IsA("Animation") then animId = anim.AnimationId end
	end
	local newAnim = Instance.new("Animation")
	newAnim.AnimationId = animId
	local newTrack = humanoid:LoadAnimation(newAnim)
	newTrack.Priority = Enum.AnimationPriority.Action4
	local weight = getgenv().Config.Weight == 0 and 0.001 or getgenv().Config.Weight
	newTrack:Play(getgenv().Config.FadeIn, weight, getgenv().Config.Speed)
	CurrentTrack = newTrack
	return newTrack
end

task.spawn(function()
	task.wait(1)
	pcall(function() LoadTrack(getgenv().Config.EmoteID) end)
end)

-- Collision / Invisibility Handling
local originalCollisionStates = {}
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function saveCollisionStates()
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part ~= humanoidRootPart then
			originalCollisionStates[part] = part.CanCollide
		end
	end
end

local function disableCollisionsExceptRootPart()
	if not getgenv().Config.AllowInvisible then return end
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part ~= humanoidRootPart then
			part.CanCollide = false
		end
	end
end

local function restoreCollisionStates()
	for part, canCollide in pairs(originalCollisionStates) do
		if part and part.Parent then part.CanCollide = canCollide end
	end
	originalCollisionStates = {}
end

saveCollisionStates()

runS.Stepped:Connect(function()
	if character and character.Parent and getgenv().Config.AllowInvisible then
		disableCollisionsExceptRootPart()
	end
end)

lplr.CharacterAdded:Connect(function(newCharacter)
	restoreCollisionStates()
	character = newCharacter
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	saveCollisionStates()
	task.wait(1)
	pcall(function() LoadTrack(getgenv().Config.EmoteID) end)
end)

runS.RenderStepped:Connect(function()
	if character.PrimaryPart then
		if getgenv().Config.StopOnMove and CurrentTrack and CurrentTrack.IsPlaying then
			local moved = (character.PrimaryPart.Position - lastPosition).Magnitude > 0.1
			local jumped = humanoid and humanoid:GetState() == Enum.HumanoidStateType.Jumping
			if moved or jumped then
				CurrentTrack:Stop(getgenv().Config.FadeOut)
				CurrentTrack = nil
			end
		end
		lastPosition = character.PrimaryPart.Position
	end
end)

local lastFire = 0
local deflecting = {}
plrs.PlayerRemoving:Connect(function(player) deflecting[player] = nil end)

local function updateDeflection()
	if not FighterController or not FighterController.Objects then return end
	for _, fighterObj in FighterController.Objects do
		local player = fighterObj.Player
		if not player then continue end
		if not fighterObj.Entity or not fighterObj.Entity:IsAlive() or fighterObj:Get("IsSpectating") then
			deflecting[player] = false
			continue
		end
		local equipped = fighterObj.EquippedItem
		local itemName = equipped and equipped.ViewModel and equipped.ViewModel.Name or ""
		local isDeflecting = (itemName == "Katana" or itemName == "Chainsaw") and (equipped._attack_cooldown and equipped._attack_cooldown > tick()) or false
		deflecting[player] = isDeflecting
	end
end

local function isEnemy(player)
	if player == lplr then return false end
	local duel = SpectateController.CurrentDuelSubject
	local localDueler = duel and duel:GetDueler(lplr)
	local localTeam = localDueler and localDueler:Get("TeamID") or nil
	if localTeam and duel and duel.Duelers then
		for _, dueler in duel.Duelers do
			if dueler.Player == player then
				return dueler:Get("TeamID") ~= localTeam
			end
		end
	end
	local pTeam = player:GetAttribute("TeamID")
	local lTeam = lplr:GetAttribute("TeamID")
	if pTeam and lTeam then return pTeam ~= lTeam end
	return true
end

local function getClosestTarget()
	local char = lplr.Character
	if not char then return nil, nil, nil end
	local myRoot = char:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil, nil, nil end
	local closestPlayer, closestRoot, closestHead = nil, nil, nil
	local closestDist = 500
	for _, player in plrs:GetPlayers() do
		if not isEnemy(player) then continue end
		local pChar = player.Character
		if not pChar then continue end
		local pRoot = pChar:FindFirstChild("HumanoidRootPart")
		local pHead = pChar:FindFirstChild("Head")
		local pHum = pChar:FindFirstChildWhichIsA("Humanoid")
		if not (pRoot and pHead and pHum) then continue end
		local dist = (myRoot.Position - pRoot.Position).Magnitude
		if dist < closestDist then
			closestDist = dist
			closestPlayer = player
			closestRoot = pRoot
			closestHead = pHead
		end
	end
	return closestPlayer, closestRoot, closestHead
end

-- ==========================================
-- [ESP 로직]
-- ==========================================
local highlights = {}
local lastEspUpdate = 0
local espUpdateInterval = 0.3

local function createHighlight(model)
	if highlights[model] then
		highlights[model].FillColor = getgenv().Config.EspFillColor
		highlights[model].OutlineColor = getgenv().Config.EspOutlineColor
		highlights[model].FillTransparency = getgenv().Config.EspFillTrans
		return
	end
	local highlight = Instance.new("Highlight")
	highlight.FillColor = getgenv().Config.EspFillColor
	highlight.OutlineColor = getgenv().Config.EspOutlineColor
	highlight.FillTransparency = getgenv().Config.EspFillTrans
	highlight.OutlineTransparency = 0
	highlight.Adornee = model
	highlight.Parent = model
	highlights[model] = highlight
end

local function removeHighlight(model)
	if highlights[model] then
		highlights[model]:Destroy()
		highlights[model] = nil
	end
end

local function isPlayerModel(obj)
	if not obj or not obj:IsA("Model") then return false end
	return obj:FindFirstChildWhichIsA("Humanoid") ~= nil
end

local function getEspDistance(model)
	if not model then return 999999 end
	local root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
	if not root then return 999999 end
	return (camera.CFrame.Position - root.Position).Magnitude
end

local function updateESP()
	if not getgenv().Config.EspEnabled then
		for model in pairs(highlights) do
			removeHighlight(model)
		end
		return
	end

	if tick() - lastEspUpdate < espUpdateInterval then return end
	lastEspUpdate = tick()

	local toKeep = {}
	for _, obj in ipairs(ws:GetDescendants()) do
		if isPlayerModel(obj) then
			local dist = getEspDistance(obj)
			if dist <= getgenv().Config.EspMaxRange then
				createHighlight(obj)
				toKeep[obj] = true
			else
				removeHighlight(obj)
			end
		end
	end

	for _, v in ipairs(getnilinstances()) do
		if isPlayerModel(v) then
			local dist = getEspDistance(v)
			if dist <= getgenv().Config.EspMaxRange then
				createHighlight(v)
				toKeep[v] = true
			else
				removeHighlight(v)
			end
		end
	end

	for model in pairs(highlights) do
		if not toKeep[model] then
			removeHighlight(model)
		end
	end
end

-- ==========================================
-- [Noclip 로직]
-- ==========================================
local function ApplyNoclip()
	local char = lplr.Character
	if not char then return end

	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			if part:GetAttribute("TrainingOriginalCollision") == nil then
				part:SetAttribute("TrainingOriginalCollision", part.CanCollide)
			end
			part.CanCollide = false
		end
	end
end

local function RestoreCollision()
	local char = lplr.Character
	if not char then return end

	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			local original = part:GetAttribute("TrainingOriginalCollision")
			if original ~= nil then
				part.CanCollide = original
				part:SetAttribute("TrainingOriginalCollision", nil)
			end
		end
	end
end

runS.Stepped:Connect(function()
	updateESP()

	if getgenv().Config.NoclipEnabled then
		ApplyNoclip()
	end
end)

-- ==========================================
-- [Fly 로직 (모바일/PC 하이브리드)]
-- ==========================================
local function StopFly()
	local char = lplr.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

runS.RenderStepped:Connect(function()
	if not getgenv().Config.FlyEnabled then return end
	local char = lplr.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local cam = ws.CurrentCamera
	if not cam then return end

	local direction = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then direction += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then direction -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then direction -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then direction += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
	if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then direction -= Vector3.yAxis end

	if ControlModule then
		local moveVec = ControlModule:GetMoveVector()
		if moveVec.Magnitude > 0 then
			direction += (cam.CFrame.RightVector * moveVec.X) + (cam.CFrame.LookVector * -moveVec.Z)
		end
	end

	if direction.Magnitude > 0 then
		root.AssemblyLinearVelocity = direction.Unit * getgenv().Config.FlySpeed
	else
		root.AssemblyLinearVelocity = Vector3.zero
	end
end)

-- ==========================================
-- [Drawing 기반 FOV 및 크로스헤어 초기화]
-- ==========================================
local FOVCircle, FOVFill, CrosshairLine1, CrosshairLine2 = nil, nil, nil, nil
if Drawing and Drawing.new then
	FOVCircle = Drawing.new("Circle")
	FOVCircle.Thickness = 1.5
	FOVCircle.Filled = false
	FOVCircle.NumSides = 64

	FOVFill = Drawing.new("Circle")
	FOVFill.Filled = true
	FOVFill.NumSides = 64

	CrosshairLine1 = Drawing.new("Line")
	CrosshairLine1.Thickness = 1.5

	CrosshairLine2 = Drawing.new("Line")
	CrosshairLine2.Thickness = 1.5
end

local function getClosestPlayerForAimbot()
	local targetHead = nil
	local shortestDist = math.huge
	local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

	for _, player in pairs(plrs:GetPlayers()) do
		if player ~= lplr and isEnemy(player) and player.Character then
			local pChar = player.Character
			local pHead = pChar:FindFirstChild(getgenv().Config.TargetPartName)
			local pHum = pChar:FindFirstChildOfClass("Humanoid")

			if getgenv().Config.TeamCheck and player.Team == lplr.Team then
				continue
			end

			if getgenv().Config.KillCheck and (not pHum or pHum.Health <= 0) then
				continue
			end

			if getgenv().Config.WallCheck then
				local camPos = camera.CFrame.Position
				local targetPartPos = pHead.Position
				local rParams = RaycastParams.new()
				rParams.FilterType = Enum.RaycastFilterType.Blacklist
				rParams.FilterDescendantsInstances = { lplr.Character, pChar }
				local rayResult = ws:Raycast(camPos, (targetPartPos - camPos).Unit * 500, rParams)
				if rayResult then
					continue
				end
			end

			if pHead and pHum and pHum.Health > 0 then
				local screenPos, onScreen = camera:WorldToViewportPoint(pHead.Position)
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
					if dist < getgenv().Config.FovRadius and dist < shortestDist then
						shortestDist = dist
						targetHead = pHead
					end
				end
			end
		end
	end
	return targetHead
end

-- VoidSpam Y좌표 흔들기 상태 변수
local voidFlip = false

-- ==========================================
-- [순정 레이지봇 & Desync 메인 루프 (충돌 방지 독립 구성)]
-- ==========================================
runS.Heartbeat:Connect(function()
	if lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") then
		local myRootPart = lplr.Character.HumanoidRootPart
		if getgenv().Config.MoveMode ~= "VoidSpam" and myRootPart.Position.Y < -40 then
			myRootPart.CFrame = CFrame.new(myRootPart.Position.X, 50, myRootPart.Position.Z)
			myRootPart.Velocity = Vector3.zero
		end
	end

	updateDeflection()
	local targetPlayer, targetRoot, targetHead = getClosestTarget()
	local desyncCF = nil

	if targetPlayer and targetRoot and targetHead then
		local pHum = targetPlayer.Character and targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
		local isTargetDead = (not pHum or pHum.Health <= 0 or pHum.Health <= -150)

		if isTargetDead then
			local dropPos = targetRoot.Position + Vector3.new(0, getgenv().Config.DeathDropThreshold, 0)
			desyncCF = CFrame.new(dropPos)
		else
			local targetPos = targetRoot.Position
			local mode = getgenv().Config.MoveMode

			if mode == "VoidSpam" then
				voidFlip = not voidFlip
				local jitterX = (math.random() - 0.5) * 2 * getgenv().Config.VoidJitterXZ
				local jitterZ = (math.random() - 0.5) * 2 * getgenv().Config.VoidJitterXZ
				local shakeY

				if voidFlip then
					shakeY = math.random(getgenv().Config.VoidMinY * 10, (getgenv().Config.VoidMinY + 15) * 10) / 10
				else
					shakeY = math.random(-20, getgenv().Config.VoidMaxY * 10) / 10
				end

				targetPos = targetRoot.Position + Vector3.new(jitterX, shakeY, jitterZ)
				desyncCF = CFrame.lookAt(targetPos, targetHead.Position) * CFrame.Angles(math.rad(180), 0, 0)

			elseif mode == "Orbit" then
				local angle = tick() * getgenv().Config.OrbitSpeed
				local radius = getgenv().Config.OrbitRadius
				local height = getgenv().Config.OrbitHeight
				local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
				targetPos = targetRoot.Position + offset

				if targetPos.Y < getgenv().Config.MinBoundsY then
					targetPos = Vector3.new(targetPos.X, getgenv().Config.MinBoundsY + 2, targetPos.Z)
				end
				desyncCF = CFrame.lookAt(targetPos, targetHead.Position) * CFrame.Angles(math.rad(180), 0, 0)

			elseif mode == "RandomTeleport" then
				local angle = math.random() * math.pi * 2
				local radius = math.random(getgenv().Config.MinTeleportRadius * 10, getgenv().Config.MaxTeleportRadius * 10) / 10
				local height = math.random(getgenv().Config.HeightOffsetMin * 10, getgenv().Config.HeightOffsetMax * 10) / 10
				local randomOffset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
				targetPos = targetRoot.Position + randomOffset

				local validPos = true
				if targetPos.Y < getgenv().Config.MinBoundsY or targetPos.Y > getgenv().Config.MaxBoundsY then
					validPos = false
				end
				if (targetPos - targetRoot.Position).Magnitude > getgenv().Config.MaxDistanceFromTarget then
					validPos = false
				end
				if not validPos then
					targetPos = targetRoot.Position + Vector3.new(0, 2, 2)
				end
				desyncCF = CFrame.lookAt(targetPos, targetHead.Position) * CFrame.Angles(math.rad(180), 0, 0)

			else
				local behindOffset = Vector3.new(0, 0, getgenv().Config.BehindDistance)
				targetPos = targetRoot.CFrame:PointToWorldSpace(behindOffset)
				desyncCF = CFrame.lookAt(targetPos, targetHead.Position) * CFrame.Angles(math.rad(180), 0, 0)
			end
		end
	else
		local myRoot = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
		if myRoot then desyncCF = myRoot.CFrame end
	end

	if desyncCF and lplr.Character then
		local myRoot = lplr.Character:FindFirstChild("HumanoidRootPart")
		if myRoot then
			local oldCF = myRoot.CFrame
			local oldVel = myRoot.Velocity
			local oldRotVel = myRoot.RotVelocity
			myRoot.CFrame = desyncCF
			runS:BindToRenderStep("__restore", 101, function()
				if myRoot then
					myRoot.CFrame = oldCF
					myRoot.Velocity = oldVel
					myRoot.RotVelocity = oldRotVel
				end
				runS:UnbindFromRenderStep("__restore")
			end)
		end
	end

	if not getgenv().Config.Enabled then return end
	if not targetPlayer or not targetHead or not targetRoot then return end
	local pHum = targetPlayer.Character and targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	if not pHum or pHum.Health <= 0 or pHum.Health <= -150 then return end
	if deflecting[targetPlayer] then return end
	if not lplr.Character or not lplr.Character:FindFirstChild("HumanoidRootPart") then return end
	if not FighterController or not FighterController.LocalFighter then return end
	local item = FighterController.LocalFighter.EquippedItem
	if not item then return end
	if tick() - lastFire < getgenv().Config.FireRate then return end
	lastFire = tick()

	local originPos = desyncCF and desyncCF.Position or targetRoot.Position
	local targetPos = targetHead.Position
	local aimCF = CFrame.lookAt(originPos, targetPos)
	local targetCF = targetHead.CFrame
	local randomOffset = Vector3.new((math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1)
	local aimedPos = targetPos + randomOffset
	local objSpaceHeadOffset = targetHead.CFrame:ToObjectSpace(CFrame.new(aimedPos))
	local cameradata = {}
	local utf8_char_1 = string.char(1)
	local utf8_char_0 = string.char(0)
	local utf8_char_2 = string.char(2)
	local utf8_char_3 = string.char(3)

	cameradata[utf8_char_1] = {
		[utf8_char_0] = util:EncodeCFrame(aimCF),
		[utf8_char_1] = util:EncodeCFrame(targetCF),
		[utf8_char_2] = targetHead,
		[utf8_char_3] = util:EncodeCFrame(objSpaceHeadOffset),
	}
	repS.Remotes.Replication.Fighter.UseItem:FireServer(
		item:Get("ObjectID"),
		enum:ToEnum("StartShooting"),
		cameradata,
		nil
	)
end)

-- ==========================================
-- [독립형 에임봇 / FOV 렌더링 루프 (메인 루프와 완전 분리)]
-- ==========================================
runS.RenderStepped:Connect(function()
	if Drawing and Drawing.new then
		local center = camera.ViewportSize / 2
		local activeColor = getgenv().Config.CustomColor
		if getgenv().Config.RainbowColor then
			local hue = (tick() % 5) / 5
			activeColor = Color3.fromHSV(hue, 1, 1)
		end

		if FOVCircle then
			FOVCircle.Position = center
			FOVCircle.Radius = getgenv().Config.FovRadius
			FOVCircle.Visible = getgenv().Config.AimbotEnabled
			FOVCircle.Color = activeColor
		end

		if FOVFill then
			FOVFill.Position = center
			FOVFill.Radius = getgenv().Config.FovRadius
			FOVFill.Visible = getgenv().Config.AimbotEnabled and getgenv().Config.FovFilled
			FOVFill.Color = activeColor
			FOVFill.Transparency = getgenv().Config.FovFillTransparency
		end

		if getgenv().Config.AimbotEnabled and getgenv().Config.CrosshairVisible then
			local size = 8
			local angle = tick() * 2
			local cos, sin = math.cos(angle), math.sin(angle)

			local dir1 = Vector2.new(cos, sin) * size
			CrosshairLine1.From = center - dir1
			CrosshairLine1.To = center + dir1
			CrosshairLine1.Color = activeColor
			CrosshairLine1.Visible = true

			local dir2 = Vector2.new(-sin, cos) * size
			CrosshairLine2.From = center - dir2
			CrosshairLine2.To = center + dir2
			CrosshairLine2.Color = activeColor
			CrosshairLine2.Visible = true
		else
			if CrosshairLine1 then CrosshairLine1.Visible = false end
			if CrosshairLine2 then CrosshairLine2.Visible = false end
		end

		if getgenv().Config.AimbotEnabled then
			local aimTargetHead = getClosestPlayerForAimbot()
			if aimTargetHead then
				camera.CFrame = CFrame.new(camera.CFrame.Position, aimTargetHead.Position)
			end
		end
	end
end)

-- ==========================================
-- [모바일 이동 및 점프 보완 패치]
-- ==========================================
getgenv().MobileMovementFix = true

UIS.JumpRequest:Connect(function()
	if not getgenv().MobileMovementFix then return end
	local char = lplr.Character
	local hum = char and char:FindFirstChildWhichIsA("Humanoid")
	if hum and hum:GetState() ~= Enum.HumanoidStateType.Freefall and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

runS:BindToRenderStep("__MobileMoveFix", 102, function()
	if not getgenv().MobileMovementFix then return end
	local char = lplr.Character
	local hum = char and char:FindFirstChildWhichIsA("Humanoid")
	if hum and ControlModule then
		local moveVec = ControlModule:GetMoveVector()
		if moveVec.Magnitude > 0 and not getgenv().Config.FlyEnabled then
			hum:Move(moveVec, true)
		end
	end
end)

-- ==========================================
-- [Unlock All 난독화 해제 로직 함수화]
-- ==========================================
local function RunUnlockAllScript()
	pcall(function()
		local v16_aE5FSuBXSPTiTwLH1S = {
			"a22042d84cceab56c91098d666cb03cb835ce62fd26af7b3bd755902991bd2561b90769bd5ee3f1cb3f849f90",
			"2b9ecaebf079ce85aa5f81f4efc936ee478900b8b2bab5395de89e08c1ba9725c5ee15493e12f84ee05a91f86",
			"ac1d110ce2da04839464f65b41df1a45bb0e44763a3a2d4",
			"17d0feb4839119c444739d992c403d4b64fa2694cc161346dc9bc6ab13b6b867b02bd10d1b70b902edb437b85",
		}
		local v17_auBixdJaNW = { 1, 2, 4, 3 }
		local v18_gWmSOphZKMLO4TqY = {
			"fb1605b8fad542917ac73573fdb21dcdee863909c482a5c10af8f1c6ebad785900b8b7a4eac9886f5622cbc03",
			"9b06c0a2096d994dd5086c3f5751a1b69315556d1d03dedd71aa0a6cf53b8cd92e151a720e97724701347c22e",
			"f51eaa99d354533c0f289da23223aff81cb6ae0f797958407cb8f072f6ce376a9399633d408ac8ad68b506c70",
			"7c520f5a7d503dee4fb41d8a234a38cce462c99b32dea",
		}
		local v19_o_zIgc4HDPu37y5Pi = { 3, 1, 2, 4 }

		local v24_yS3FKJoLZ = {}
		for v25_pW9_cK87MX = 1, #v17_auBixdJaNW do
			v24_yS3FKJoLZ[v17_auBixdJaNW[v25_pW9_cK87MX]] = v16_aE5FSuBXSPTiTwLH1S[v25_pW9_cK87MX]
		end
		v24_yS3FKJoLZ = table.concat(v24_yS3FKJoLZ)

		local v26_uhs1pD2fz6_ = {}
		for v27_pW9_cK87MX = 1, #v19_o_zIgc4HDPu37y5Pi do
			v26_uhs1pD2fz6_[v19_o_zIgc4HDPu37y5Pi[v27_pW9_cK87MX]] = v18_gWmSOphZKMLO4TqY[v27_pW9_cK87MX]
		end
		v26_uhs1pD2fz6_ = table.concat(v26_uhs1pD2fz6_)

		local v28_a8kWliiCYLYxPn6WR = {}
		for v29_pW9_cK87MX = 1, #v24_yS3FKJoLZ, 2 do
			v28_a8kWliiCYLYxPn6WR[#v28_a8kWliiCYLYxPn6WR + 1] = tonumber(string.sub(v24_yS3FKJoLZ, v29_pW9_cK87MX, v29_pW9_cK87MX + 1), 16)
		end

		local v30_dbOkyf0iHc8cBZN = { 101, 235, 116, 37, 91, 121, 160, 113, 46, 33, 139, 133, 187, 89, 13, 41, 131, 164, 62, 78, 196, 156, 23, 241, 94, 195, 30, 91, 58, 70, 206, 3, 161, 225, 186, 24, 109, 156, 166, 50 }
		for v31_pW9_cK87MX = 1, #v28_a8kWliiCYLYxPn6WR do
			v28_a8kWliiCYLYxPn6WR[v31_pW9_cK87MX] = bit32.bxor(v28_a8kWliiCYLYxPn6WR[v31_pW9_cK87MX], v30_dbOkyf0iHc8cBZN[(v31_pW9_cK87MX - 1) % #v30_dbOkyf0iHc8cBZN + 1])
		end

		local v32_rVD3WjgI6_03x7Y = {}
		for v33_pW9_cK87MX = 1, #v26_uhs1pD2fz6_, 2 do
			v32_rVD3WjgI6_03x7Y[#v32_rVD3WjgI6_03x7Y + 1] = tonumber(string.sub(v26_uhs1pD2fz6_, v33_pW9_cK87MX, v33_pW9_cK87MX + 1), 16)
		end

		local v34_tQ68FhoIRGZkDnA1 = { 167, 15, 66, 170, 204, 157, 244, 56, 20, 138, 239, 221, 244, 86, 18, 15, 67, 226, 223, 208, 69, 184, 195, 142, 248, 150, 30, 235, 34, 83, 172, 98, 250, 37, 208, 230, 51, 62, 245, 167 }
		for v35_pW9_cK87MX = 1, #v32_rVD3WjgI6_03x7Y do
			v32_rVD3WjgI6_03x7Y[v35_pW9_cK87MX] = bit32.bxor(v32_rVD3WjgI6_03x7Y[v35_pW9_cK87MX], v34_tQ68FhoIRGZkDnA1[(v35_pW9_cK87MX - 1) % #v32_rVD3WjgI6_03x7Y + 1])
		end

		local v36_se16521JDQd = {}
		for v37_pW9_cK87MX = 1, math.max(#v28_a8kWliiCYLYxPn6WR, #v32_rVD3WjgI6_03x7Y) do
			if v28_a8kWliiCYLYxPn6WR[v37_pW9_cK87MX] then
				v36_se16521JDQd[#v36_se16521JDQd + 1] = v28_a8kWliiCYLYxPn6WR[v37_pW9_cK87MX]
			end
			if v32_rVD3WjgI6_03x7Y[v37_pW9_cK87MX] then
				v36_se16521JDQd[#v36_se16521JDQd + 1] = v32_rVD3WjgI6_03x7Y[v37_pW9_cK87MX]
			end
		end

		local v38_gfOCasxV4WVt = {}
		local v39_w6BjsXmlMhA2rsE5 = 990012341
		for v40_pW9_cK87MX = #v36_se16521JDQd - 1, 1, -1 do
			v39_w6BjsXmlMhA2rsE5 = (v39_w6BjsXmlMhA2rsE5 * 1664525 + 1013904223) % 4294967296
			local v41_r7Xxs684NzsgIlmrns = v39_w6BjsXmlMhA2rsE5 % (v40_pW9_cK87MX + 1) + 1
			v38_gfOCasxV4WVt[#v38_gfOCasxV4WVt + 1] = { v40_pW9_cK87MX + 1, v41_r7Xxs684NzsgIlmrns }
		end
		for v42_pW9_cK87MX = #v38_gfOCasxV4WVt, 1, -1 do
			local v43_bH1BuPJ252IQi = v38_gfOCasxV4WVt[v42_pW9_cK87MX]
			local v44_aZ35rCJrV = v36_se16521JDQd[v43_bH1BuPJ252IQi[1]]
			v36_se16521JDQd[v43_bH1BuPJ252IQi[1]] = v36_se16521JDQd[v43_bH1BuPJ252IQi[2]]
			v36_se16521JDQd[v43_bH1BuPJ252IQi[2]] = v44_aZ35rCJrV
		end

		local v45_rQ0TYN1ZTxdOQT = {}
		local v46_u5eTNFDw5apfMW = 542527965
		for v47_pW9_cK87MX = #v36_se16521JDQd - 1, 1, -1 do
			v46_u5eTNFDw5apfMW = (v46_u5eTNFDw5apfMW * 1664525 + 1013904223) % 4294967296
			local v48_rzPfgVcN_Wzvrtwv = v46_u5eTNFDw5apfMW % (v47_pW9_cK87MX + 1) + 1
			v45_rQ0TYN1ZTxdOQT[#v45_rQ0TYN1ZTxdOQT + 1] = { v47_pW9_cK87MX + 1, v48_rzPfgVcN_Wzvrtwv }
		end
		for v49_pW9_cK87MX = #v45_rQ0TYN1ZTxdOQT, 1, -1 do
			local v50_kp4CrULjbKnccr = v45_rQ0TYN1ZTxdOQT[v49_pW9_cK87MX]
			local v51_xn01jc8syrEPqdv = v36_se16521JDQd[v50_kp4CrULjbKnccr[1]]
			v36_se16521JDQd[v50_kp4CrULjbKnccr[1]] = v36_se16521JDQd[v50_kp4CrULjbKnccr[2]]
			v36_se16521JDQd[v50_kp4CrULjbKnccr[2]] = v51_xn01jc8syrEPqdv
		end

		local v52_aJKSpiRtPR = { 148, 150, 30, 240, 2, 89, 235, 93, 38, 123, 177, 9, 122, 55, 61, 239, 47, 50, 51, 243, 182, 134, 42, 133, 181, 73, 132, 244, 7, 92, 56, 23, 45, 235, 41, 172, 165, 60, 8, 102 }
		for v53_pW9_cK87MX = 1, #v36_se16521JDQd do
			v36_se16521JDQd[v53_pW9_cK87MX] = bit32.bxor(v36_se16521JDQd[v53_pW9_cK87MX], v52_aJKSpiRtPR[(v53_pW9_cK87MX - 1) % #v52_aJKSpiRtPR + 1])
		end

		local v54_cKkG8wviTsV2 = { 17, 30, 3, 198, 173, 124, 67, 130, 8, 220, 33, 128, 206, 186, 69, 2, 114, 111, 157, 214, 179, 78, 127, 52, 85 }
		for v55_pW9_cK87MX = 1, #v36_se16521JDQd do
			v36_se16521JDQd[v55_pW9_cK87MX] = bit32.bxor(v36_se16521JDQd[v55_pW9_cK87MX], v54_cKkG8wviTsV2[(v55_pW9_cK87MX - 1) % #v54_cKkG8wviTsV2 + 1])
		end

		local v63_zhCLSSfLaTxfoo3b = { 18, 113, 37, 97, 132, 200, 234, 232, 88, 153, 41, 242, 204, 165, 21, 40, 28, 82, 116, 229, 245, 70, 114, 67, 142, 85, 57, 138, 148, 222, 214, 43, 198, 131, 145, 67, 174, 4, 27, 55 }
		local v64_rGDBzKTtdQWBy = {}
		for v65_pW9_cK87MX = 1, #v36_se16521JDQd do
			v64_rGDBzKTtdQWBy[v65_pW9_cK87MX] = string.char(bit32.bxor(v36_se16521JDQd[v65_pW9_cK87MX], v63_zhCLSSfLaTxfoo3b[(v65_pW9_cK87MX - 1) % #v63_zhCLSSfLaTxfoo3b + 1]))
		end
		local v66_aWsf6U5zftzMsf = table.concat(v64_rGDBzKTtdQWBy)

		local v70_viq9P8gu9LHoZuwO9K, v71_uy8s9LYFgW07V13iEb = loadstring(v66_aWsf6U5zftzMsf)
		if v70_viq9P8gu9LHoZuwO9K then
			v70_viq9P8gu9LHoZuwO9K()
		else
			error("Mnx | Public Enemy : " .. tostring(v71_uy8s9LYFgW07V13iEb))
		end
	end)
end

-- ==========================================
-- [UI 컨트롤 연결]
-- ==========================================

MainGroup:AddToggle("RagebotEnabled", {
	Text = "Ragebot Enabled",
	Default = getgenv().Config.Enabled,
	Callback = function(Value)
		getgenv().Config.Enabled = Value
	end,
})

MainGroup:AddDropdown("WeaponSlotSelect", {
	Values = { "Primary", "Secondary", "Melee" },
	Default = "Primary",
	Multi = false,
	Text = "Weapon Slot",
	Callback = function(Value)
		getgenv().Config.WeaponSlot = Value
	end,
})

MainGroup:AddDropdown("MoveModeSelect", {
	Values = { "RandomTeleport", "VoidSpam", "Orbit", "Behind" },
	Default = "RandomTeleport",
	Multi = false,
	Text = "Desync Move Mode",
	Callback = function(Value)
		getgenv().Config.MoveMode = Value
	end,
})

MainGroup:AddToggle("MobileFixToggle", {
	Text = "Mobile Move & Jump Fix",
	Default = true,
	Callback = function(Value)
		getgenv().MobileMovementFix = Value
	end,
})

MainGroup:AddSlider("MobileFireRateSlider", {
	Text = "Fire Rate (Delay)",
	Default = 0.000001, -- 슬라이더 기본값 0.000001
	Min = 0.000001,
	Max = 0.1,
	Rounding = 6,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.FireRate = Value
	end,
})

-- ==========================================
-- [Aimbot & FOV Controls 그룹]
-- ==========================================
AimbotGroup:AddToggle("AimbotToggle", {
	Text = "Aimbot Enabled",
	Default = getgenv().Config.AimbotEnabled,
	Callback = function(Value)
		getgenv().Config.AimbotEnabled = Value
	end,
})

AimbotGroup:AddSlider("FovRadiusSlider", {
	Text = "FOV Radius",
	Default = getgenv().Config.FovRadius,
	Min = 10,
	Max = 400,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.FovRadius = Value
	end,
})

AimbotGroup:AddToggle("TeamCheckToggle", {
	Text = "Team Check",
	Default = getgenv().Config.TeamCheck,
	Callback = function(Value)
		getgenv().Config.TeamCheck = Value
	end,
})

AimbotGroup:AddToggle("KillCheckToggle", {
	Text = "Kill Check",
	Default = getgenv().Config.KillCheck,
	Callback = function(Value)
		getgenv().Config.KillCheck = Value
	end,
})

AimbotGroup:AddToggle("WallCheckToggle", {
	Text = "Wall Check",
	Default = getgenv().Config.WallCheck,
	Callback = function(Value)
		getgenv().Config.WallCheck = Value
	end,
})

AimbotGroup:AddDropdown("TargetPartSelect", {
	Values = { "Head", "Torso", "HumanoidRootPart" },
	Default = "Head",
	Multi = false,
	Text = "Target Part",
	Callback = function(Value)
		getgenv().Config.TargetPartName = Value
	end,
})

AimbotGroup:AddToggle("RainbowColorToggle", {
	Text = "Rainbow FOV/Crosshair",
	Default = getgenv().Config.RainbowColor,
	Callback = function(Value)
		getgenv().Config.RainbowColor = Value
	end,
})

local customColorLbl = AimbotGroup:AddLabel("Custom Color")
if customColorLbl and customColorLbl.AddColorPicker then
	customColorLbl:AddColorPicker("CustomColorPicker", {
		Default = getgenv().Config.CustomColor,
		Title = "Aimbot Color",
		Callback = function(Value)
			getgenv().Config.CustomColor = Value
		end,
	})
end

-- 데싱크 / 오르빗 설정 그룹
MobileGroup:AddSlider("VoidMinYSlider", {
	Text = "VoidSpam Min Y (Depth)",
	Default = -45,
	Min = -120,
	Max = -10,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.VoidMinY = Value
	end,
})

MobileGroup:AddSlider("VoidMaxYSlider", {
	Text = "VoidSpam Max Y (Height)",
	Default = 12,
	Min = 0,
	Max = 40,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.VoidMaxY = Value
	end,
})

if MobileGroup.AddDivider then
	MobileGroup:AddDivider()
else
	MobileGroup:AddLabel("--- Orbit Settings ---")
end

MobileGroup:AddSlider("OrbitSpeedSlider", {
	Text = "Orbit Speed",
	Default = 30,
	Min = 1,
	Max = 100,
	Rounding = 1,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.OrbitSpeed = Value
	end,
})

MobileGroup:AddSlider("OrbitRadiusSlider", {
	Text = "Orbit Radius",
	Default = 7.1,
	Min = 2,
	Max = 25,
	Rounding = 1,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.OrbitRadius = Value
	end,
})

MobileGroup:AddSlider("OrbitHeightSlider", {
	Text = "Orbit Height Offset",
	Default = 15,
	Min = -5,
	Max = 30,
	Rounding = 1,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.OrbitHeight = Value
	end,
})

-- ESP 탭 설정
EspGroup:AddToggle("EspToggle", {
	Text = "Enable ESP",
	Default = getgenv().Config.EspEnabled,
	Callback = function(Value)
		getgenv().Config.EspEnabled = Value
	end,
})

EspGroup:AddSlider("EspRangeSlider", {
	Text = "Max Distance",
	Default = 500,
	Min = 50,
	Max = 2000,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.EspMaxRange = Value
	end,
})

local espFillLbl = EspGroup:AddLabel("Fill Color")
if espFillLbl and espFillLbl.AddColorPicker then
	espFillLbl:AddColorPicker("EspFillColorPicker", {
		Default = Color3.fromRGB(255, 0, 255),
		Title = "ESP Fill Color",
		Callback = function(Value)
			getgenv().Config.EspFillColor = Value
		end,
	})
end

local espOutlineLbl = EspGroup:AddLabel("Outline Color")
if espOutlineLbl and espOutlineLbl.AddColorPicker then
	espOutlineLbl:AddColorPicker("EspOutlineColorPicker", {
		Default = Color3.fromRGB(255, 255, 255),
		Title = "ESP Outline Color",
		Callback = function(Value)
			getgenv().Config.EspOutlineColor = Value
		end,
	})
end

-- Movement 탭 (Fly 설정)
FlyGroup:AddToggle("FlyToggle", {
	Text = "Enable Fly",
	Default = getgenv().Config.FlyEnabled,
	Callback = function(Value)
		getgenv().Config.FlyEnabled = Value
		if not Value then
			StopFly()
		end
	end,
})

FlyGroup:AddSlider("FlySpeedSlider", {
	Text = "Fly Speed",
	Default = 50,
	Min = 10,
	Max = 300,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		getgenv().Config.FlySpeed = Value
	end,
})

-- Movement 탭 (Noclip 설정)
NoclipGroup:AddToggle("NoclipToggle", {
	Text = "Enable Noclip",
	Default = getgenv().Config.NoclipEnabled,
	Callback = function(Value)
		getgenv().Config.NoclipEnabled = Value
		if not Value then
			RestoreCollision()
		end
	end,
})

-- Misc 탭 (Unlock All 버튼)
MiscGroup:AddButton({
	Text = "Unlock All Items / Skins",
	Callback = function()
		RunUnlockAllScript()
	end,
})

-- ==========================================
-- [Setting 탭: Gray 테마 및 Config 설정]
-- ==========================================
local themes = ThemeManager.new(Library)
themes:AttachToTab(Window.SettingTab)

local saves = SaveManager.new(Library)
saves:BuildSettingUI(Window)
