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

local Window = Library:CreateWindow({
	Title = " ",
	Footer = "Euphoria",
	Icon = nil,
	NotifySide = "Right",
	ShowCustomCursor = true,
	SidebarCompacted = true,
	GlobalSearch = true,
	EnableSidebarResize = false,
	Resizable = true,
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

local DraggableLabel = Library:AddDraggableLabel("Euphoria | 0 fps | 0 ms")

local MenuBox = Tabs.Settings:AddLeftGroupbox("Menu")

MenuBox:AddToggle("Watermark", {
    Text = "Watermark",
    Default = false,
    Callback = function(Value)
        DraggableLabel:SetVisible(Value)
    end
})

MenuBox:AddButton({
    Text = "Unload",
    Func = function()
        Library:Unload()
    end
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({"MenuKeybind",})
SaveManager:SetFolder("Euphoria")
SaveManager:SetSubFolder("Rivals")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

DraggableLabel:SetVisible(Toggles.Watermark.Value)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    local ping = 0
    pcall(function()
        ping = math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    end)
    
    if ping == 0 then
        pcall(function()
            ping = math.floor(game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000)
        end)
    end

    DraggableLabel:SetText(('Euphoria | %s fps | %s ms'):format(
        math.floor(FPS),
        ping
    ))
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
end)
