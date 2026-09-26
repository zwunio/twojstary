if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.PlaceId ~= 17625359962 then
    return
end

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bananalyze/bAC-bananalyze-AntiCheat/refs/heads/main/anticheat%20destroyer%206000.luau"))()
    end)
end)

task.wait(3)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zwunio/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zwunio/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zwunio/Obsidian/main/addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorageSVC = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
	Title = " ",
	Footer = "Euphoria",
	Icon = nil,
	NotifySide = "Right",
	ShowCustomCursor = true,
	SidebarCompacted = true,
	GlobalSearch = true,
	EnableSidebarResize = false,
	Resizable = false,
	Size = UDim2.fromOffset(420, 310),
	CornerRadius = 12,
})

local Tabs = {
	Combat = Window:AddTab("Combat", "sword"),
	Player = Window:AddTab("Player", "user"),
	Visuals = Window:AddTab("Visuals", "eye"),
	World = Window:AddTab("World", "globe"),
	Misc = Window:AddTab("Misc", "package"),
	Settings = Window:AddTab("Settings", "settings"),
}

local RagebotBox = Tabs.Combat:AddGroupbox({
	Side = "Left",
	Name = "Ragebot",
})

local Ragebot = RagebotBox:AddToggle("Ragebot", {
	Text = "Enabled",
	Default = false,
})

local WeaponSlot = RagebotBox:AddDropdown("WeaponSlot", {
	Text = "Weapon Slot",
	Values = { "Primary", "Secondary", "Melee" },
	Default = 1,
	Multi = false,
})

local OnEmpty = RagebotBox:AddDropdown("OnEmpty", {
	Text = "On Empty",
	Values = { "Reload", "Swap" },
	Default = 1,
	Multi = false,
})

RagebotBox:AddSlider("XOffset", { Text = "X Offset", Default = 0, Min = -15, Max = 15, Rounding = 1 })
RagebotBox:AddSlider("ZOffset", { Text = "Z Offset", Default = 0, Min = -15, Max = 15, Rounding = 1 })

local ModsBox = Tabs.Combat:AddGroupbox({
	Side = "Right",
	Name = "Mods",
})

ModsBox:AddToggle("RapidFire", {
	Text = "Rapid Fire",
	Default = false,
})

ModsBox:AddToggle("RapidMelee", {
	Text = "Rapid Melee",
	Default = false,
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({"MenuKeybind",})
SaveManager:SetFolder("Euphoria")
SaveManager:SetSubFolder("Rivals")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

local FighterController = nil
task.spawn(function()
	while not FighterController do
		local ok, mod = pcall(function()
			return require(LocalPlayer.PlayerScripts:WaitForChild("Controllers", 10):WaitForChild("FighterController", 10))
		end)
		if ok and mod then
			FighterController = mod
		else
			task.wait(1)
		end
	end
end)

local RageUtility = nil
local RageEnums = nil
task.spawn(function()
	while not (RageUtility and RageEnums) do
		if not RageUtility then
			local ok, u = pcall(function()
				return require(ReplicatedStorageSVC:WaitForChild("Modules", 10):WaitForChild("Utility", 10))
			end)
			if ok then RageUtility = u end
		end
		if not RageEnums then
			local ok, e = pcall(function()
				return require(ReplicatedStorageSVC:WaitForChild("Modules", 10):WaitForChild("EnumLibrary", 10))
			end)
			if ok then RageEnums = e end
		end
		task.wait(0.5)
	end
end)

local MechanicsController = nil
task.spawn(function()
	while not MechanicsController do
		local ok, mod = pcall(function()
			return require(LocalPlayer.PlayerScripts:WaitForChild("Controllers", 10):WaitForChild("MechanicsController", 10))
		end)
		if ok and mod then
			MechanicsController = mod
		else
			task.wait(1)
		end
	end
end)

local GunModule = nil
task.spawn(function()
	while not GunModule do
		local ok, mod = pcall(function()
			return require(LocalPlayer.PlayerScripts:WaitForChild("Modules", 10):WaitForChild("ItemTypes", 10):WaitForChild("Gun", 10))
		end)
		if ok and mod then
			GunModule = mod
		else
			task.wait(1)
		end
	end
end)

local isReloading = false

task.spawn(function()
	while not GunModule do
		task.wait(0.5)
	end

	pcall(function()
		local oldStartReloading = GunModule.StartReloading
		if typeof(oldStartReloading) == "function" then
			GunModule.StartReloading = function(self, ...)
				isReloading = true

				local reloadTime = 1
				pcall(function()
					if self and self.Info and typeof(self.Info.ReloadLength) == "number" then
						reloadTime = self.Info.ReloadLength
					end
				end)

				task.delay(reloadTime + 0.25, function()
					isReloading = false
				end)

				return oldStartReloading(self, ...)
			end
		end
	end)
end)

task.spawn(function()
	local ok_oob, oob_machine = pcall(function()
		return require(ReplicatedStorageSVC:WaitForChild("Modules", 10):WaitForChild("OutOfBoundsMachine", 10))
	end)
	if ok_oob and oob_machine then
		pcall(function()
			oob_machine.IsOutOfBounds = function()
				return false
			end
		end)
		pcall(function()
			oob_machine.Update = function()
				return
			end
		end)
	end

	local ok_gu, gameplay_util = pcall(function()
		return require(ReplicatedStorageSVC:WaitForChild("Modules", 10):WaitForChild("GameplayUtility", 10))
	end)
	if ok_gu and gameplay_util then
		pcall(function()
			gameplay_util.GetOOBWarnDelay = function()
				return 9999
			end
		end)
		pcall(function()
			gameplay_util.GetOOBKillDelay = function()
				return 9999
			end
		end)
		pcall(function()
			gameplay_util.IsWithinOOBPart = function()
				return nil
			end
		end)
	end
end)

pcall(function()
	local old_namecall
	old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
		if not checkcaller() and getnamecallmethod() == "FireServer" then
			if typeof(self) == "Instance" and self.Name == "OutOfBounds" then
				return nil
			end
		end
		return old_namecall(self, ...)
	end))
end)

local DeflectingPlayers = {}
task.spawn(function()
	local ok, katana = pcall(function()
		return require(LocalPlayer.PlayerScripts.Modules.Items:WaitForChild("Katana", true))
	end)
	if ok and katana and katana.StartAiming then
		local old = katana.StartAiming
		katana.StartAiming = function(self, force)
			local fighter = self.ClientFighter
			local player = fighter and fighter.Player
			if player then
				DeflectingPlayers[player.Name] = true
				local dur = self.Info.DeflectDuration or 0.6
				task.delay(dur, function()
					DeflectingPlayers[player.Name] = nil
				end)
			end
			return old(self, force)
		end
	end
end)

local function IsImmune(char)
	if not char then return false end
	if char:FindFirstChildOfClass("ForceField") then return true end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root and root:FindFirstChild("Attachment") then return true end
	return false
end

local function IsTeammate(tp)
	if not tp then return true end

	local myTeam = LocalPlayer:GetAttribute("TeamID")
	local theirTeam = tp:GetAttribute("TeamID")

	if myTeam == nil or theirTeam == nil then return true end

	return myTeam == theirTeam
end

local function ValidTarget(char)
	if not char or not char.Parent then return false end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end

	if not char:FindFirstChild("HumanoidRootPart") then return false end

	local tp = Players:GetPlayerFromCharacter(char)
	if not tp or tp == LocalPlayer then return false end

	if IsTeammate(tp) then return false end

	return true
end

local function IsLocalPlayerAlive()
	local char = LocalPlayer.Character
	if not char then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	return hum and hum.Health > 0
end

local function FindNearestEnemy()
	local myChar = LocalPlayer.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end

	local best, bestD = nil, math.huge

	for _, tp in ipairs(Players:GetPlayers()) do
		if tp ~= LocalPlayer and tp.Character and ValidTarget(tp.Character) then
			local root = tp.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local d = (root.Position - myRoot.Position).Magnitude
				if d < bestD then
					bestD = d
					best = tp.Character
				end
			end
		end
	end

	return best
end

local function AtkCfg()
	return {
		x = Options.XOffset and Options.XOffset.Value or 0,
		z = Options.ZOffset and Options.ZOffset.Value or 0,
	}
end

local function GetFaceCFrame(fromPos, targetPos, fallbackLook)
	local dir = Vector3.new(targetPos.X - fromPos.X, 0, targetPos.Z - fromPos.Z)

	if dir.Magnitude < 0.01 then
		local fb = fallbackLook or Vector3.new(0, 0, 1)
		dir = Vector3.new(fb.X, 0, fb.Z)
		if dir.Magnitude < 0.01 then
			dir = Vector3.new(0, 0, 1)
		end
	end

	return CFrame.new(fromPos, fromPos + dir.Unit)
end

local function CalcPosition(root)
	if not root then return Vector3.zero end

	local s = AtkCfg()
	local pos = root.Position
	local forward = root.CFrame.LookVector * s.x
	local up = Vector3.new(0, s.z, 0)

	return pos + forward + up
end

local swappedToSlot = nil
local lastEmptyAction = 0
local lastReloadAttempt = 0
local lastFinishShooting = 0

local shotgunReloadLock = false
local SHOTGUN_REQUIRED_AMMO = 7

local function GetDesiredSlot()
	local weapon = Options.WeaponSlot and Options.WeaponSlot.Value or "Primary"
	if weapon == "Melee" then return 3 end
	if weapon == "Primary" then return 1 end
	if weapon == "Secondary" then return 2 end
	return 1
end

local function GetSlotAmmo(slotIdx)
	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.Items then return nil end

	local item = fighter.Items[slotIdx]
	if not item then return nil end

	local keys = {
		"CurrentAmmo",
		"Ammo",
		"Bullets",
		"MagazineAmmo",
		"ClipAmmo",
		"AmmoInClip",
		"AmmoInMagazine",
		"Magazine",
	}

	for _, key in ipairs(keys) do
		local ok, val = pcall(function()
			return item:Get(key)
		end)

		if ok and typeof(val) == "number" then
			return val
		end
	end

	return nil
end

local function GetCurrentSlot()
	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.EquippedItem then return nil end

	local item = fighter.EquippedItem
	local slot = item:Get("Slot") or item:Get("Index")

	return tonumber(slot)
end

local function HasSlot(slotIdx)
	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.Items then return false end
	return fighter.Items[slotIdx] ~= nil
end

local function EquipSlot(slotIdx)
	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.Items then return end

	local item = fighter.Items[slotIdx]
	if item and not item.IsEquipped then
		pcall(function()
			fighter:EquipItem(slotIdx)
		end)
	end
end

local function GetItemName(item)
	if not item then return "" end

	local name

	pcall(function()
		name = item.Name
	end)

	if typeof(name) ~= "string" then
		pcall(function()
			name = item:Get("Name")
		end)
	end

	if typeof(name) ~= "string" then
		pcall(function()
			name = item:Get("WeaponName")
		end)
	end

	return typeof(name) == "string" and name or ""
end

local function IsShotgunItem(item)
	local name = GetItemName(item)
	return name:lower():find("shotgun") ~= nil
end

local function IsSlotShotgun(slotIdx)
	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.Items then return false end
	return IsShotgunItem(fighter.Items[slotIdx])
end

local function IsEquippedShotgun()
	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.EquippedItem then return false end
	return IsShotgunItem(fighter.EquippedItem)
end

local function GetActiveSlot()
	local desired = GetDesiredSlot()
	if desired == 3 then return 3 end

	if not swappedToSlot then
		return desired
	end

	local desiredAmmo = GetSlotAmmo(desired)
	if desiredAmmo and desiredAmmo > 0 then
		swappedToSlot = nil
		return desired
	end

	return swappedToSlot
end

local function CanShootTarget(char)
	if not char or not char.Parent then return false end
	local tp = Players:GetPlayerFromCharacter(char)
	if not tp then return false end

	if DeflectingPlayers[tp.Name] then
		local slot = GetActiveSlot()
		if slot == 3 then
			return true
		else
			return false
		end
	end
	return true
end

local function TriggerReload()
	local now = tick()
	if now - lastReloadAttempt < 0.45 then return end
	lastReloadAttempt = now

	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.Items then return end

	local activeSlot = GetActiveSlot()

	if IsEquippedShotgun() or IsSlotShotgun(activeSlot) then
		shotgunReloadLock = true
	end

	if activeSlot and fighter.Items[activeSlot] and not fighter.Items[activeSlot].IsEquipped then
		pcall(function()
			fighter:EquipItem(activeSlot)
		end)
	end

	local equipped = fighter.EquippedItem
	if not equipped then return end

	if MechanicsController and typeof(MechanicsController.EquippedItemInput) == "function" then
		pcall(function()
			MechanicsController:EquippedItemInput("Reload")
		end)

		if isReloading then return end
	end

	local itemMethods = {
		"Reload",
		"StartReloading",
		"StartReload",
		"ReloadWeapon",
		"PlayReload",
	}

	for _, methodName in ipairs(itemMethods) do
		local called = false

		pcall(function()
			local fn = equipped[methodName]
			if typeof(fn) == "function" then
				fn(equipped)
				called = true
			end
		end)

		if called then return end
	end

	local fighterMethods = {
		"Reload",
		"ReloadEquippedItem",
		"StartReloading",
	}

	for _, methodName in ipairs(fighterMethods) do
		local called = false

		pcall(function()
			local fn = fighter[methodName]
			if typeof(fn) == "function" then
				fn(fighter)
				called = true
			end
		end)

		if called then return end
	end

	if GunModule and typeof(GunModule.StartReloading) == "function" then
		pcall(function()
			GunModule.StartReloading(equipped)
		end)

		if isReloading then return end
	end

	pcall(function()
		local oid = equipped:Get("ObjectID")
		if not oid then return end

		local reloadEnums = {
			"Reload",
			"StartReloading",
			"StartReload",
		}

		for _, enumName in ipairs(reloadEnums) do
			local ok, enumValue = pcall(function()
				return RageEnums:ToEnum(enumName)
			end)

			if ok and enumValue then
				ReplicatedStorageSVC.Remotes.Replication.Fighter.UseItem:FireServer(
					oid,
					enumValue,
					nil,
					nil
				)
				break
			end
		end
	end)
end

local function HandleOnEmpty()
	local activeSlot = GetActiveSlot()
	if activeSlot == 3 then return end

	local currentAmmo = GetSlotAmmo(activeSlot)
	if currentAmmo == nil then return end

	if currentAmmo > 0 then
		isReloading = false
		lastEmptyAction = 0
		return
	end

	local now = tick()
	if now - lastEmptyAction < 0.25 then return end

	local onEmptyMode = Options.OnEmpty and Options.OnEmpty.Value or "Reload"

	if onEmptyMode == "Reload" then
		TriggerReload()
		lastEmptyAction = now
	elseif onEmptyMode == "Swap" then
		if swappedToSlot == activeSlot then
			TriggerReload()
			lastEmptyAction = now
			return
		end

		local otherSlot = (activeSlot == 1) and 2 or 1

		if HasSlot(otherSlot) then
			local otherAmmo = GetSlotAmmo(otherSlot)
			if otherAmmo and otherAmmo > 0 then
				EquipSlot(otherSlot)
				swappedToSlot = otherSlot
				lastEmptyAction = now
				return
			end
		end

		TriggerReload()
		lastEmptyAction = now
	end
end

local function LockWeapon()
	local fighter = FighterController and FighterController.LocalFighter
	if not fighter or not fighter.Items then return end

	local targetSlot = GetActiveSlot()
	local item = fighter.Items[targetSlot]

	if item and not item.IsEquipped then
		pcall(function()
			fighter:EquipItem(targetSlot)
		end)
	end
end

local function TryFinishShooting()
	local now = tick()
	if now - lastFinishShooting < 0.25 then return end
	lastFinishShooting = now

	if MechanicsController and typeof(MechanicsController.EquippedItemInput) == "function" then
		pcall(function()
			MechanicsController:EquippedItemInput("FinishShooting")
		end)
	end
end

Options.WeaponSlot:OnChanged(function()
	swappedToSlot = nil
	shotgunReloadLock = false
	lastEmptyAction = 0
	lastReloadAttempt = 0
end)

LocalPlayer.CharacterAdded:Connect(function()
	swappedToSlot = nil
	shotgunReloadLock = false
	isReloading = false
	lastEmptyAction = 0
	lastReloadAttempt = 0
	lastFinishShooting = 0
end)

local rageState = {
	target = nil,
	serverpos = nil,
	serverCFrame = nil,
	active = false,
}

local function StopRage()
	rageState.active = false
	rageState.target = nil
	rageState.serverpos = nil
	rageState.serverCFrame = nil
end

local function StartRage(targetChar)
	if not targetChar or not ValidTarget(targetChar) then return end

	if not rageState.active then
		rageState.active = true
	end

	rageState.target = targetChar
end

local function RageAttack()
	if not rageState.target or not rageState.target.Parent then return end

	local hum = rageState.target:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end
	if not rageState.target:FindFirstChild("HumanoidRootPart") then return end

	local targetPlayer = Players:GetPlayerFromCharacter(rageState.target)
	if not targetPlayer or targetPlayer == LocalPlayer then return end
	if IsTeammate(targetPlayer) then return end

	if IsImmune(rageState.target) then return end

	if not RageUtility or not RageEnums then return end

	local lf = FighterController and FighterController.LocalFighter
	if not lf or not lf.EquippedItem then return end

	local equipped = lf.EquippedItem
	local oid = equipped:Get("ObjectID")
	if not oid then return end

	local targetChar = rageState.target
	local hitPart = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
	if not hitPart then return end

	local shootPos = rageState.serverpos
		or (
			LocalPlayer.Character
			and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			and LocalPlayer.Character.HumanoidRootPart.Position
			or Vector3.new()
		)

	local targetPos = hitPart.Position

	local data = {
		[utf8.char(1)] = {
			[utf8.char(0)] = RageUtility:EncodeCFrame(CFrame.new(shootPos, targetPos)),
			[utf8.char(1)] = RageUtility:EncodeCFrame(CFrame.new(shootPos, targetPos)),
			[utf8.char(2)] = hitPart,
			[utf8.char(3)] = RageUtility:EncodeCFrame(CFrame.new(0.43, 0.25, 0.42)),
		},
	}

	pcall(function()
		ReplicatedStorageSVC.Remotes.Replication.Fighter.UseItem:FireServer(
			oid,
			RageEnums:ToEnum("StartShooting"),
			data,
			nil
		)
	end)
end

RunService.Heartbeat:Connect(function()
	if not IsLocalPlayerAlive() then
		if rageState.active then StopRage() end
		return
	end

	if not (Toggles.Ragebot and Toggles.Ragebot.Value) then
		if rageState.active then StopRage() end
		return
	end

	HandleOnEmpty()
	LockWeapon()

	local lf = FighterController and FighterController.LocalFighter
	local item = lf and lf.EquippedItem
	if item then
		if Toggles.RapidFire and Toggles.RapidFire.Value then
			pcall(function()
				item._shoot_cooldown = 0
				item._shoot_cooldown_no_ammo = 0
				item._last_shot = tick() - 1
				if item.Info then
					item.Info.ShootCooldown = 0
					item.Info.QuickShotCooldown = 0
					item.Info.ShootBurstCooldown = 0
				end
			end)
		end

		if Toggles.RapidMelee and Toggles.RapidMelee.Value then
			pcall(function()
				item._attack_cooldown = 0
				item._last_attack = tick() - 1
				if item.Info then
					item.Info.AttackCooldown = 0
					item.Info.HeavyAttackCooldown = 0
					item.Info.Cooldown = 0
				end
			end)
		end
	end

	local targetValid = rageState.target
		and rageState.target.Parent
		and ValidTarget(rageState.target)

	if not targetValid then
		local newTarget = FindNearestEnemy()
		if newTarget then
			StartRage(newTarget)
		else
			if rageState.active then StopRage() end
			return
		end
	end

	if rageState.active and rageState.target and rageState.target.Parent and ValidTarget(rageState.target) then
		local lf = FighterController and FighterController.LocalFighter
		local root = rageState.target:FindFirstChild("HumanoidRootPart")

		if lf and lf.Entity and lf.Entity.RootPart and root then
			local serverPos = CalcPosition(root)
			rageState.serverpos = serverPos
			rageState.serverCFrame = GetFaceCFrame(serverPos, root.Position, root.CFrame.LookVector)

			lf.Entity.RootPart.CFrame = rageState.serverCFrame
			lf.Entity.RootPart.AssemblyLinearVelocity = Vector3.zero
		end

		if CanShootTarget(rageState.target) then
			local attackSlot = GetCurrentSlot() or GetActiveSlot()
			local canAttack = true
			local ammo = nil
			local isShotgun = false

			if attackSlot ~= 3 then
				ammo = GetSlotAmmo(attackSlot)
				isShotgun = IsSlotShotgun(attackSlot) or IsEquippedShotgun()

				if ammo ~= nil and ammo <= 0 then
					canAttack = false
				end
			end

			if isShotgun then
				if ammo ~= nil and ammo >= SHOTGUN_REQUIRED_AMMO then
					shotgunReloadLock = false
					isReloading = false
				else
					if isReloading then
						shotgunReloadLock = true
					end

					if shotgunReloadLock then
						canAttack = false
					end
				end
			else
				shotgunReloadLock = false
			end

			if isReloading then
				canAttack = false
			end

			if canAttack then
				RageAttack()
			else
				TryFinishShooting()
			end
		else
			TryFinishShooting()
		end
	end
end)
