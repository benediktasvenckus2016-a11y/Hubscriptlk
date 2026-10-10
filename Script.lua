if _G.HUNTER_HUB_LOADED then return end _G.HUNTER_HUB_LOADED = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local LP = Players.LocalPlayer
local LOGO_ID = "rbxassetid://82731719321115"
local BANNER_ID = "rbxassetid://82731719321115"
local H_LOGO_ID = "rbxassetid://82731719321115"
task.spawn(function() pcall(function() ContentProvider:PreloadAsync({LOGO_ID, BANNER_ID, H_LOGO_ID}) end) end)

-- File functions
local _isfile = isfile or (syn and syn.isfile) or (getgenv and getgenv().isfile) or function() return false end
local _readfile = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile) or function() return nil end
local _writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or function() end

-- ============================================================
-- STATE
-- ============================================================
local State = {
    normalSpeed=60, carrySpeed=30, laggerSpeed=10.1, speedToggled=false, laggerEnabled=false,
    infJumpEnabled=false, antiRagdollEnabled=false, fpsBoostEnabled=false,
    medusaCounterEnabled=false, autoStealEnabled=false,
    batAimbotToggled=false, autoSwingEnabled=false,
    holdJumpEnabled=false,
    autoTPDownEnabled=false, autoTPDownHeight=20,
    jumpPower=55,
    guiVisible=true, stackButtonsHidden=false, uiScale=1.0,
    stealRadius=20, stealDuration=1.3,
    isStealing=false, stealStartTime=nil, lastStealTick=0,
    medusaLastUsed=0, medusaDebounce=false,
    hittingCooldown=false, dropEnabled=false,
    _tpInProgress=false, lastMoveDir=Vector3.new(0,0,0),
    _prevCarry=30, _prevSpeed=false,
    autoLeftEnabled=false, autoRightEnabled=false,
    uiPositions = { main=nil, infoBar=nil, vBtn=nil, stackButtons={} },
    antiBatEnabled = false,
}

-- KEYBINDS
local Keys = {
    speed = Enum.KeyCode.Q,
    guiHide = Enum.KeyCode.LeftControl,
    autoLeft = Enum.KeyCode.Z,
    autoRight = Enum.KeyCode.C,
    lagger = Enum.KeyCode.G,
    tpDown = Enum.KeyCode.T,
    drop = Enum.KeyCode.H,
    aimbot = Enum.KeyCode.F,
}

-- LemonHub walking positions
local LEMON_POS = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
}

-- ============================================================
-- DARK/BLACK + RED ACCENT COLOR PALETTE
-- ============================================================
local C = {
    winBg        = Color3.fromRGB(8,8,8),
    winBorder    = Color3.fromRGB(180,30,30),
    whiteBorder  = Color3.fromRGB(255,255,255),
    whiteDim     = Color3.fromRGB(200,200,200),
    topBg        = Color3.fromRGB(10,10,10),
    topTitle     = Color3.fromRGB(255,255,255),
    topSub       = Color3.fromRGB(160,40,40),
    topBtn       = Color3.fromRGB(220,60,60),
    topDivider   = Color3.fromRGB(35,10,10),
    tabBarBg     = Color3.fromRGB(10,10,10),
    tabBarDiv    = Color3.fromRGB(30,8,8),
    tabIdle      = Color3.fromRGB(140,140,140),
    tabActive    = Color3.fromRGB(255,255,255),
    tabActiveBg  = Color3.fromRGB(20,6,6),
    tabUnderline = Color3.fromRGB(200,40,40),
    sectionTxt   = Color3.fromRGB(200,200,200),
    sectionDiv   = Color3.fromRGB(35,12,12),
    rowBg        = Color3.fromRGB(8,8,8),
    rowBorder    = Color3.fromRGB(30,10,10),
    rowLabel     = Color3.fromRGB(220,220,220),
    rowSub       = Color3.fromRGB(130,130,130),
    rowValue     = Color3.fromRGB(200,200,200),
    rowHov       = Color3.fromRGB(18,6,6),
    inputBg      = Color3.fromRGB(14,14,14),
    inputBorder  = Color3.fromRGB(50,18,18),
    inputFocus   = Color3.fromRGB(200,40,40),
    inputTxt     = Color3.fromRGB(230,230,230),
    pillOff      = Color3.fromRGB(30,10,10),
    pillOn       = Color3.fromRGB(160,30,30),
    dotOff       = Color3.fromRGB(80,30,30),
    dotOn        = Color3.fromRGB(255,255,255),
    pillBorder   = Color3.fromRGB(80,25,25),
    modeBtnBg    = Color3.fromRGB(10,10,10),
    modeBtnBrd   = Color3.fromRGB(60,18,18),
    modeBtnTxt   = Color3.fromRGB(180,180,180),
    modeBtnActBg = Color3.fromRGB(160,30,30),
    modeBtnActTx = Color3.fromRGB(255,255,255),
    chipBg       = Color3.fromRGB(10,10,10),
    chipBorder   = Color3.fromRGB(60,18,18),
    chipTxt      = Color3.fromRGB(180,180,180),
    btnBg        = Color3.fromRGB(10,10,10),
    btnBorder    = Color3.fromRGB(55,18,18),
    btnTxt       = Color3.fromRGB(210,210,210),
    btnHov       = Color3.fromRGB(22,7,7),
    stackBg      = Color3.fromRGB(8,8,8),
    stackBrd     = Color3.fromRGB(80,80,80),
    stackTxt     = Color3.fromRGB(200,200,200),
    stackActBg   = Color3.fromRGB(12,12,12),
    stackActBrd  = Color3.fromRGB(255,255,255),
    stackActTxt  = Color3.fromRGB(255,255,255),
    infoBg       = Color3.fromRGB(8,8,8),
    infoBrd      = Color3.fromRGB(40,12,12),
    infoTxt      = Color3.fromRGB(180,180,180),
    infoVal      = Color3.fromRGB(220,220,220),
    infoFill     = Color3.fromRGB(180,35,35),
    accent       = Color3.fromRGB(180,35,35),
    accentDim    = Color3.fromRGB(80,22,22),
    divider      = Color3.fromRGB(40,12,12),
}

local function addWhiteStroke(obj, thickness, transparency)
    thickness = thickness or 0.8
    transparency = transparency or 0.3
    local stroke = Instance.new("UIStroke", obj)
    stroke.Color = C.whiteBorder
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

-- ============================================================
-- INTENSE ROTATING RED BORDER (same for all UI)
-- ============================================================
function addRotatingRedBorder(frame, thickness)
    thickness = thickness or 1.2
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("UIStroke") and child.Name ~= "WhiteStroke" then
            child:Destroy()
        end
    end
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(200,30,30)
    stroke.Thickness = thickness
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local grad = Instance.new("UIGradient", stroke)
    grad.Name = "RotatingRedGradient"
    grad.Rotation = 0
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(100,0,0)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(220,40,40)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(255,100,100)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(220,40,40)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(100,0,0))
    })
    local tween = TweenService:Create(grad, TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Rotation = 360})
    tween:Play()
end

-- ============================================================
-- STACK BUTTONS DEF
-- ============================================================
local BTN_W, BTN_H, BTN_GAP, COLS, BTN_CORNER = 90, 52, 6, 2, 16
local stackDefs = {
    {key="autoLeft", label="AUTO\nL"}, {key="autoRight", label="AUTO\nR"}, {key="aimbot", label="AUTO\nBAT"},
    {key="lagger", label="LAGGER"}, {key="drop", label="DROP"}, {key="tpDown", label="TP\nDOWN"},
    {key="carrySpeed", label="CARRY"},
}
local GRID_W = COLS*(BTN_W+BTN_GAP)-BTN_GAP
local GRID_H = math.ceil(#stackDefs/COLS)*(BTN_H+BTN_GAP)-BTN_GAP
local function getDefaultStackPos(i)
    local col = (i-1)%COLS
    local row = math.floor((i-1)/COLS)
    return UDim2.new(1, -(GRID_W+10)+col*(BTN_W+BTN_GAP), 0.5, -(GRID_H/2)+row*(BTN_H+BTN_GAP))
end

-- ============================================================
-- N10 AUTO STEAL (full)
-- ============================================================
local Steal = {
    AutoStealEnabled = false,
    StealRadius = 20,
    StealDuration = 1.3,
    animalCache = {},
    promptCache = {},
    stealCache = {},
    isStealing = false,
    progressConn = nil,
    lastScanTime = 0,
    scanInterval = 2.5,
}

if not fireproximityprompt then
    fireproximityprompt = (getgenv and getgenv().fireproximityprompt) or function(p)
        pcall(function() p:InputHoldBegin(); task.wait(0.05); p:InputHoldEnd() end)
    end
end

local function isMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function scanPlot(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyPlot(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, pod in ipairs(podiums:GetChildren()) do
        if pod:IsA("Model") and pod:FindFirstChild("Base") then
            local uid = plot.Name .. "_" .. pod.Name
            for _, ex in ipairs(Steal.animalCache) do if ex.uid == uid then return end end
            table.insert(Steal.animalCache, {
                name = pod.Name, plot = plot.Name, slot = pod.Name,
                worldPosition = pod:GetPivot().Position, uid = uid,
            })
        end
    end
end

local function findPromptCached(ad)
    if not ad then return nil end
    local cp = Steal.promptCache[ad.uid]
    if cp and cp.Parent then return cp end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local plot = plots:FindFirstChild(ad.plot)
    if not plot then return nil end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local pod = pods:FindFirstChild(ad.slot)
    if not pod then return nil end
    local base = pod:FindFirstChild("Base")
    if not base then return nil end
    local sp = base:FindFirstChild("Spawn")
    if not sp then return nil end
    local att = sp:FindFirstChild("PromptAttachment")
    local prompt = nil
    if att then
        for _, p in ipairs(att:GetChildren()) do
            if p:IsA("ProximityPrompt") then prompt = p; break end
        end
    end
    if not prompt then
        for _, ch in ipairs(sp:GetDescendants()) do
            if ch:IsA("ProximityPrompt") then prompt = ch; break end
        end
    end
    if prompt then Steal.promptCache[ad.uid] = prompt end
    return prompt
end

local function buildCallbacks(prompt)
    if Steal.stealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _, conn in ipairs(c1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _, conn in ipairs(c2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        Steal.stealCache[prompt] = data
    else
        Steal.stealCache[prompt] = { ready = true, fallback = true }
    end
end

local function nearestAnimal()
    local char = LP.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestD = nil, math.huge
    for _, ad in ipairs(Steal.animalCache) do
        if not isMyPlot(ad.plot) and ad.worldPosition then
            local d = (hrp.Position - ad.worldPosition).Magnitude
            if d < bestD then bestD = d; best = ad end
        end
    end
    return best, bestD
end

local stealPctLbl = nil
local progressFill = nil

local function resetStealBar()
    if stealPctLbl then stealPctLbl.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0,0,1,0) end
end

local function execSteal(prompt, animalName)
    local data = Steal.stealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    Steal.isStealing = true
    State.isStealing = true
    State.stealStartTime = tick()
    if Steal.progressConn then Steal.progressConn:Disconnect() end
    Steal.progressConn = RunService.Heartbeat:Connect(function()
        if not Steal.isStealing then
            Steal.progressConn:Disconnect()
            Steal.progressConn = nil
            return
        end
        local prog = math.clamp((tick() - State.stealStartTime) / Steal.StealDuration, 0, 1)
        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
        if stealPctLbl then stealPctLbl.Text = math.floor(prog * 100) .. "%" end
    end)
    task.spawn(function()
        if data.holdCallbacks then
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        end
        local elapsed = 0
        while elapsed < Steal.StealDuration do elapsed = elapsed + task.wait() end
        if data.triggerCallbacks then
            for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        else
            pcall(function() fireproximityprompt(prompt) end)
        end
        task.wait(0.01)
        if Steal.progressConn then Steal.progressConn:Disconnect(); Steal.progressConn = nil end
        resetStealBar()
        task.wait(0.01)
        data.ready = true
        Steal.isStealing = false
        State.isStealing = false
    end)
    return true
end

local stealLoopConn = nil
local function startAutoSteal()
    if stealLoopConn then return end
    stealLoopConn = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or Steal.isStealing then return end
        local target, dist = nearestAnimal()
        if not target then return end
        local char = LP.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end
        if dist > Steal.StealRadius then return end
        local prompt = Steal.promptCache[target.uid]
        if not prompt or not prompt.Parent then prompt = findPromptCached(target) end
        if prompt then
            buildCallbacks(prompt)
            execSteal(prompt, target.name)
        end
    end)
end

local function stopAutoSteal()
    if stealLoopConn then stealLoopConn:Disconnect(); stealLoopConn = nil end
    Steal.isStealing = false
    State.isStealing = false
    resetStealBar()
end

task.spawn(function()
    task.wait(2)
    local plots = workspace:WaitForChild("Plots", 10)
    if not plots then return end
    local function fullScan()
        local now = tick()
        if now - Steal.lastScanTime < Steal.scanInterval then return end
        Steal.lastScanTime = now
        Steal.animalCache = {}
        Steal.promptCache = {}
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then scanPlot(plot) end
        end
    end
    fullScan()
    plots.ChildAdded:Connect(function(plot)
        if plot:IsA("Model") then task.wait(0.5); scanPlot(plot) end
    end)
    while task.wait(Steal.scanInterval) do
        fullScan()
    end
end)

-- ============================================================
-- CONFIG
-- ============================================================
local CONFIG_FILE = "HunterHubConfig.json"

local function saveConfig()
    local cfg = {
        normalSpeed=State.normalSpeed, carrySpeed=State.carrySpeed, laggerSpeed=State.laggerSpeed,
        stealRadius=Steal.StealRadius, stealDuration=Steal.StealDuration, jumpPower=State.jumpPower,
        uiScale=State.uiScale, stackButtonsHidden=State.stackButtonsHidden,
        speedKey=Keys.speed.Name, autoLeftKey=Keys.autoLeft.Name, autoRightKey=Keys.autoRight.Name,
        guiHideKey=Keys.guiHide.Name, dropKey=Keys.drop.Name, laggerKey=Keys.lagger.Name,
        tpDownKey=Keys.tpDown.Name, aimbotKey=Keys.aimbot.Name,
        infJump=State.infJumpEnabled, antiRagdoll=State.antiRagdollEnabled, fpsBoost=State.fpsBoostEnabled,
        medusaCounter=State.medusaCounterEnabled, autoStealEnabled=Steal.AutoStealEnabled,
        batAimbotToggled=State.batAimbotToggled, autoSwingEnabled=State.autoSwingEnabled,
        holdJumpEnabled=State.holdJumpEnabled,
        autoTPDownEnabled=State.autoTPDownEnabled, autoTPDownHeight=State.autoTPDownHeight,
        speedToggled=State.speedToggled, laggerEnabled=State.laggerEnabled,
        autoLeftEnabled=State.autoLeftEnabled, autoRightEnabled=State.autoRightEnabled,
        uiPositions=State.uiPositions,
        antiBatEnabled=State.antiBatEnabled,
    }
    local ok, enc = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok then pcall(function() _writefile(CONFIG_FILE, enc) end) end
end

local function loadConfig()
    if not _isfile(CONFIG_FILE) then return end
    local raw = _readfile(CONFIG_FILE)
    if not raw then return end
    local cfg
    local ok = pcall(function() cfg = HttpService:JSONDecode(raw) end)
    if not ok or not cfg then return end
    if cfg.normalSpeed then State.normalSpeed = cfg.normalSpeed end
    if cfg.carrySpeed then State.carrySpeed = cfg.carrySpeed end
    if cfg.laggerSpeed then State.laggerSpeed = cfg.laggerSpeed end
    if cfg.stealRadius then Steal.StealRadius = cfg.stealRadius end
    if cfg.stealDuration then Steal.StealDuration = cfg.stealDuration end
    if cfg.jumpPower then State.jumpPower = cfg.jumpPower end
    if cfg.uiScale then State.uiScale = cfg.uiScale end
    if cfg.stackButtonsHidden ~= nil then State.stackButtonsHidden = cfg.stackButtonsHidden end
    if cfg.autoLeftEnabled ~= nil then State.autoLeftEnabled = cfg.autoLeftEnabled end
    if cfg.autoRightEnabled ~= nil then State.autoRightEnabled = cfg.autoRightEnabled end
    if cfg.uiPositions then State.uiPositions = cfg.uiPositions end
    if cfg.autoTPDownEnabled ~= nil then State.autoTPDownEnabled = cfg.autoTPDownEnabled end
    if cfg.autoTPDownHeight ~= nil then State.autoTPDownHeight = cfg.autoTPDownHeight end
    if cfg.antiBatEnabled ~= nil then State.antiBatEnabled = cfg.antiBatEnabled end
    
    local function applyKey(f, k, def)
        if cfg[f] and Enum.KeyCode[cfg[f]] then
            Keys[k] = Enum.KeyCode[cfg[f]]
        else
            Keys[k] = def
        end
    end
    applyKey("speedKey","speed",Enum.KeyCode.Q)
    applyKey("autoLeftKey","autoLeft",Enum.KeyCode.Z)
    applyKey("autoRightKey","autoRight",Enum.KeyCode.C)
    applyKey("guiHideKey","guiHide",Enum.KeyCode.LeftControl)
    applyKey("dropKey","drop",Enum.KeyCode.H)
    applyKey("laggerKey","lagger",Enum.KeyCode.G)
    applyKey("tpDownKey","tpDown",Enum.KeyCode.T)
    applyKey("aimbotKey","aimbot",Enum.KeyCode.F)
    
    if cfg.infJump ~= nil then State.infJumpEnabled = cfg.infJump end
    if cfg.antiRagdoll ~= nil then State.antiRagdollEnabled = cfg.antiRagdoll end
    if cfg.fpsBoost ~= nil then State.fpsBoostEnabled = cfg.fpsBoost end
    if cfg.medusaCounter ~= nil then State.medusaCounterEnabled = cfg.medusaCounter end
    if cfg.autoStealEnabled ~= nil then Steal.AutoStealEnabled = cfg.autoStealEnabled end
    if cfg.batAimbotToggled ~= nil then State.batAimbotToggled = cfg.batAimbotToggled end
    if cfg.autoSwingEnabled ~= nil then State.autoSwingEnabled = cfg.autoSwingEnabled end
    if cfg.holdJumpEnabled ~= nil then State.holdJumpEnabled = cfg.holdJumpEnabled end
    if cfg.speedToggled ~= nil then State.speedToggled = cfg.speedToggled end
    if cfg.laggerEnabled ~= nil then State.laggerEnabled = cfg.laggerEnabled end
    
    if State.speedToggled and State.laggerEnabled then
        State.laggerEnabled = false
    end
    local actionTrue = 0
    for _, k in ipairs({"autoLeftEnabled","autoRightEnabled","batAimbotToggled","dropEnabled"}) do
        if State[k] then actionTrue = actionTrue + 1 end
    end
    if actionTrue > 1 then
        if State.autoLeftEnabled then
            State.autoRightEnabled = false; State.batAimbotToggled = false; State.dropEnabled = false
        elseif State.autoRightEnabled then
            State.batAimbotToggled = false; State.dropEnabled = false
        elseif State.batAimbotToggled then
            State.dropEnabled = false
        end
    end
    
    if stealDurBox then stealDurBox.Text = tostring(Steal.StealDuration) end
    if autoTPDownHeightBox then autoTPDownHeightBox.Text = tostring(State.autoTPDownHeight) end
    if normalBox then normalBox.Text = tostring(State.normalSpeed) end
    if carryBox then carryBox.Text = tostring(State.carrySpeed) end
    if laggerBox then laggerBox.Text = tostring(State.laggerSpeed) end
    if jumpPowerBox then jumpPowerBox.Text = tostring(State.jumpPower) end
    if stealRadBox then stealRadBox.Text = tostring(Steal.StealRadius) end
end

-- ============================================================
-- GLOBAL REFS
-- ============================================================
local MOVE_KEYS = {[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local DROP_AUTO_OFF_DELAY = 0.15

local Conns = {autoSteal=nil,antiRag=nil,aimbot=nil,anchor={},progress=nil,
    autoLeft=nil, autoRight=nil, holdJump=nil, antiBat=nil}
local h, hrp
local setInfJump, setAntiRag, setFps, setMedusaCounter, setAutoSwing, setInstaGrab, setHoldJump, setAutoTPDown, setAntiBat
local setupMedusaCounter, stopMedusaCounter, startAntiRagdoll, stopAntiRagdoll, applyFPSBoost
local runDropBrainrot, stopDropBrainrot, doTpDown
local startBatAimbot, stopBatAimbot
local stackBtnRefs, stackWrappers, keybindBtnRefs = {}, {}, {}
local normalBox, carryBox, laggerBox, stealRadBox, jumpPowerBox
local stealDurBox
local autoTPDownHeightBox
local setModeActiveFunc = nil

for _,name in pairs({"VyseSlottedGUI","VyseAsireGUI","VyseAsireHubV4","VyseAsireHubV5","VyseAsireHubV5_1","AsireHubV5_1","AsireHubV5_2","OpiumGGV5_2","APEXHUBV5_2","APEXHUBV5_2_PINK_WHITE_BUTTONS","N10AutoStealHub","N10StealBarGui","HunterHubV5_2"}) do
    pcall(function() game:GetService("CoreGui"):FindFirstChild(name):Destroy() end)
    pcall(function() LP:WaitForChild("PlayerGui"):FindFirstChild(name):Destroy() end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "HunterHubV5_2_RED"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")
local uiScaleObj = Instance.new("UIScale", gui)
uiScaleObj.Scale = State.uiScale

local function mkCorner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 12); return c end
local function mkStroke(p,col,th) local s=Instance.new("UIStroke",p); s.Color=col; s.Thickness=th or 0.8; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; return s end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local WIN_W,WIN_H,TITLE_H,TAB_H = 270,520,46,36
local mainOuter = Instance.new("Frame", gui)
mainOuter.Name = "MainOuter"
mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)
mainOuter.Position = UDim2.new(0.5, -135, 0.5, -260)
mainOuter.BackgroundColor3 = C.winBg
mainOuter.BorderSizePixel = 0
mainOuter.ClipsDescendants = true
mkCorner(mainOuter, 22)
addRotatingRedBorder(mainOuter, 1.5)
addWhiteStroke(mainOuter, 1.0, 0.08)

local mainWallpaper = Instance.new("Frame", mainOuter)
mainWallpaper.Name = "MainWallpaper"
mainWallpaper.Size = UDim2.new(1,0,1,0)
mainWallpaper.Position = UDim2.new(0,0,0,0)
mainWallpaper.BackgroundTransparency = 1
mainWallpaper.ZIndex = 0

local titleBar = Instance.new("Frame", mainOuter)
titleBar.Size = UDim2.new(1,0,0,TITLE_H)
titleBar.BackgroundColor3 = C.topBg
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 5

local titleGrad = Instance.new("UIGradient", titleBar)
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(14,14,14)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18,5,5)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(14,14,14)),
})
titleGrad.Rotation = 0

local titleAccent = Instance.new("Frame", titleBar)
titleAccent.Size = UDim2.new(0,3,0.7,0); titleAccent.Position = UDim2.new(0,0,0.15,0)
titleAccent.BackgroundColor3 = Color3.fromRGB(200,35,35); titleAccent.BorderSizePixel = 0
mkCorner(titleAccent,2)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(0,160,1,0); titleLbl.Position = UDim2.new(0,10,0,0)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "5s duel"
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
titleLbl.Font = Enum.Font.GothamBlack; titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
local titleStroke = Instance.new("UIStroke", titleLbl)
titleStroke.Color = Color3.fromRGB(180,30,30); titleStroke.Thickness = 0.6; titleStroke.Transparency = 0.5

local titleSub = Instance.new("TextLabel", titleBar)
titleSub.Size = UDim2.new(0,160,0,12); titleSub.Position = UDim2.new(0,10,1,-13)
titleSub.BackgroundTransparency = 1; titleSub.Text = "v5.2 - RED / BLACK"
titleSub.TextColor3 = Color3.fromRGB(140,35,35); titleSub.Font = Enum.Font.Gotham; titleSub.TextSize = 8
titleSub.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,22,0,22); closeBtn.Position = UDim2.new(1,-32,0.5,-11)
closeBtn.BackgroundColor3 = C.modeBtnBg; closeBtn.BorderSizePixel = 0
closeBtn.Text = "✖"; closeBtn.TextColor3 = C.topBtn; closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 16
closeBtn.ZIndex = 7; mkCorner(closeBtn,8); mkStroke(closeBtn,C.chipBorder,0.7); addWhiteStroke(closeBtn,0.5,0.5)
closeBtn.MouseButton1Click:Connect(function() State.guiVisible = false; mainOuter.Visible = false end)

local titleDiv = Instance.new("Frame", mainOuter)
titleDiv.Size = UDim2.new(1,0,0,1); titleDiv.Position = UDim2.new(0,0,0,TITLE_H)
titleDiv.BackgroundColor3 = C.topDivider; titleDiv.BorderSizePixel = 0

local tabBar = Instance.new("Frame", mainOuter)
tabBar.Size = UDim2.new(1,0,0,TAB_H); tabBar.Position = UDim2.new(0,0,0,TITLE_H+1)
tabBar.BackgroundColor3 = C.tabBarBg; tabBar.BorderSizePixel = 0
local tabBarLL = Instance.new("UIListLayout", tabBar)
tabBarLL.FillDirection = Enum.FillDirection.Horizontal; tabBarLL.SortOrder = Enum.SortOrder.LayoutOrder; tabBarLL.Padding = UDim.new(0,0)

local tabDiv = Instance.new("Frame", mainOuter)
tabDiv.Size = UDim2.new(1,0,0,1); tabDiv.Position = UDim2.new(0,0,0,TITLE_H+1+TAB_H)
tabDiv.BackgroundColor3 = C.tabBarDiv; tabDiv.BorderSizePixel = 0

local CONTENT_Y = TITLE_H+1+TAB_H+1
local contentBg = Instance.new("Frame", mainOuter)
contentBg.Size = UDim2.new(1,0,1,-CONTENT_Y); contentBg.Position = UDim2.new(0,0,0,CONTENT_Y)
contentBg.BackgroundColor3 = C.winBg; contentBg.BorderSizePixel = 0; contentBg.ClipsDescendants = true

-- ============================================================
-- DRAG FUNCTIONS
-- ============================================================
local function saveUIPositions()
    if not mainOuter or not mainOuter.Parent then return end
    local data = {
        main = {sx=mainOuter.Position.X.Scale, ox=mainOuter.Position.X.Offset, sy=mainOuter.Position.Y.Scale, oy=mainOuter.Position.Y.Offset},
        infoBar = infoBar and infoBar.Parent and {sx=infoBar.Position.X.Scale, ox=infoBar.Position.X.Offset, sy=infoBar.Position.Y.Scale, oy=infoBar.Position.Y.Offset} or nil,
        vBtn = vBtnFrame and vBtnFrame.Parent and {sx=vBtnFrame.Position.X.Scale, ox=vBtnFrame.Position.X.Offset, sy=vBtnFrame.Position.Y.Scale, oy=vBtnFrame.Position.Y.Offset} or nil,
        stack = {},
    }
    for key, wrapper in pairs(stackWrappers) do
        if wrapper and wrapper.Parent then
            local p = wrapper.Position
            data.stack[key] = {sx=p.X.Scale, ox=p.X.Offset, sy=p.Y.Scale, oy=p.Y.Offset}
        end
    end
    local ok, enc = pcall(function() return HttpService:JSONEncode(data) end)
    if ok then pcall(function() _writefile("HunterHub_UIPositions.json", enc) end) end
end

local function loadUIPositions()
    if not _isfile("HunterHub_UIPositions.json") then return end
    local raw = _readfile("HunterHub_UIPositions.json")
    if not raw or raw == "" then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(data) ~= "table" then return end
    if data.main then
        mainOuter.Position = UDim2.new(data.main.sx or 0.5, data.main.ox or -130, data.main.sy or 0.5, data.main.oy or -220)
    end
    if data.infoBar and infoBar then
        infoBar.Position = UDim2.new(data.infoBar.sx or 0.5, data.infoBar.ox or -105, data.infoBar.sy or 1, data.infoBar.oy or -70)
    end
    if data.vBtn and vBtnFrame then
        vBtnFrame.Position = UDim2.new(data.vBtn.sx or 1, data.vBtn.ox or -55, data.vBtn.sy or 0, data.vBtn.oy or 14)
    end
    if data.stack then
        for key, wrapper in pairs(stackWrappers) do
            local d = data.stack[key]
            if d then
                wrapper.Position = UDim2.new(d.sx or 1, d.ox or 0, d.sy or 0.5, d.oy or 0)
            else
                for i, def in ipairs(stackDefs) do
                    if def.key == key then wrapper.Position = getDefaultStackPos(i); break end
                end
            end
        end
    end
end

local function makeDraggable(frame, handle)
    local src = handle or frame
    local dragging, dragStart, startPos = false
    src.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = inp.Position; startPos = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    pcall(saveUIPositions)
                end
            end)
        end
    end)
    local dragInput
    src.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end end)
    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function makeStackDraggable(frame, onTap)
    local dragging, moved, dragStart, startPos = false, false
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true; moved = false; dragStart = inp.Position; startPos = frame.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                if not moved and onTap then onTap() end
                dragging = false
                pcall(saveUIPositions)
            end
        end)
    end)
    local dragInput
    frame.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end end)
    UIS.InputChanged:Connect(function(inp)
        if inp ~= dragInput or not dragging then return end
        local delta = inp.Position - dragStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
        if moved then
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainOuter)

-- ============================================================
-- TABS (Speed, Keybinds, Settings)
-- ============================================================
local TABS = {"Speed","Keybinds","Settings"}
local currentTab = "Speed"
local tabBtns, tabPages = {}, {}
local TAB_COUNT = #TABS
for i, name in ipairs(TABS) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1/TAB_COUNT,0,1,0)
    btn.BackgroundColor3 = (name==currentTab) and C.tabActiveBg or C.tabBarBg
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    local displayName = name:upper()
    btn.Text = displayName
    btn.TextColor3 = (name==currentTab) and C.tabActive or C.tabIdle
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.ZIndex = 6
    btn.LayoutOrder = i
    local underline = Instance.new("Frame", btn)
    underline.Size = UDim2.new(0.65,0,0,2); underline.Position = UDim2.new(0.175,0,1,-2)
    underline.BackgroundColor3 = C.tabUnderline; underline.BorderSizePixel = 0
    underline.Visible = (name==currentTab); underline.ZIndex = 7
    tabBtns[name] = {btn=btn, underline=underline}
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for _, n in ipairs(TABS) do
            local t = tabBtns[n]; local active = (n==name)
            TweenService:Create(t.btn, TweenInfo.new(0.14), {TextColor3=active and C.tabActive or C.tabIdle, BackgroundColor3=active and C.tabActiveBg or C.tabBarBg}):Play()
            t.underline.Visible = active
            if tabPages[n] then tabPages[n].Visible = active end
        end
    end)
end

-- ============================================================
-- PAGE BUILDERS
-- ============================================================
local currentPage = nil; local lo = 0
local function LO() lo=lo+1; return lo end
local function makeGap(px) local f=Instance.new("Frame",currentPage) f.Size=UDim2.new(1,0,0,px or 6) f.BackgroundTransparency=1 f.BorderSizePixel=0 f.LayoutOrder=LO() end
local function makeSectionHeader(label, extraWidget)
    local wrap=Instance.new("Frame",currentPage) wrap.Size=UDim2.new(1,0,0,28) wrap.BackgroundTransparency=1 wrap.BorderSizePixel=0 wrap.LayoutOrder=LO()
    local lbl=Instance.new("TextLabel",wrap) lbl.Size=UDim2.new(1,-28,1,0) lbl.Position=UDim2.new(0,14,0,0) lbl.BackgroundTransparency=1 lbl.Text=label and label:upper() or "" lbl.TextColor3=C.sectionTxt lbl.Font=Enum.Font.GothamBold lbl.TextSize=10 lbl.TextXAlignment=Enum.TextXAlignment.Left
    if extraWidget then
        extraWidget.Parent=wrap; extraWidget.Size=UDim2.new(0,24,0,24); extraWidget.Position=UDim2.new(1,-38,0.5,-12)
        extraWidget.BackgroundColor3=C.modeBtnBg; extraWidget.BorderSizePixel=0; extraWidget.Text="⚙️"; extraWidget.TextColor3=C.modeBtnTxt
        extraWidget.Font=Enum.Font.GothamBold; extraWidget.TextSize=16; extraWidget.ZIndex=8; mkCorner(extraWidget,8)
        mkStroke(extraWidget,C.modeBtnBrd,0.7); addWhiteStroke(extraWidget,0.5,0.4)
        extraWidget.MouseEnter:Connect(function() TweenService:Create(extraWidget,TweenInfo.new(0.1),{BackgroundColor3=C.modeBtnActBg,TextColor3=C.modeBtnActTx}):Play() end)
        extraWidget.MouseLeave:Connect(function() TweenService:Create(extraWidget,TweenInfo.new(0.1),{BackgroundColor3=C.modeBtnBg,TextColor3=C.modeBtnTxt}):Play() end)
    end
end
local function makeInputRow(label, default, onChange)
    local row=Instance.new("Frame",currentPage) row.Size=UDim2.new(1,0,0,44) row.BackgroundTransparency=1 row.BorderSizePixel=0 row.LayoutOrder=LO()
    local div=Instance.new("Frame",row) div.Size=UDim2.new(1,-28,0,1) div.Position=UDim2.new(0,14,1,-1) div.BackgroundColor3=C.rowBorder div.BorderSizePixel=0
    local lbl=Instance.new("TextLabel",row) lbl.Size=UDim2.new(1,-100,1,0) lbl.Position=UDim2.new(0,14,0,0) lbl.BackgroundTransparency=1 lbl.Text=label lbl.TextColor3=C.rowLabel lbl.Font=Enum.Font.GothamBold lbl.TextSize=13 lbl.TextXAlignment=Enum.TextXAlignment.Left
    local boxWrap=Instance.new("Frame",row) boxWrap.Size=UDim2.new(0,70,0,28) boxWrap.Position=UDim2.new(1,-84,0.5,-14) boxWrap.BackgroundColor3=C.inputBg boxWrap.BorderSizePixel=0 mkCorner(boxWrap,8) local bs=mkStroke(boxWrap,C.inputBorder,0.7) addWhiteStroke(boxWrap,0.5,0.3)
    local box=Instance.new("TextBox",boxWrap) box.Size=UDim2.new(1,-8,1,0) box.Position=UDim2.new(0,4,0,0) box.BackgroundTransparency=1 box.Text=tostring(default) box.TextColor3=C.inputTxt box.Font=Enum.Font.GothamBold box.TextSize=13 box.ClearTextOnFocus=false box.ZIndex=8 box.TextXAlignment=Enum.TextXAlignment.Center
    box.Focused:Connect(function() TweenService:Create(bs,TweenInfo.new(0.15),{Color=C.inputFocus}):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(bs,TweenInfo.new(0.15),{Color=C.inputBorder}):Play()
        if onChange then local n=tonumber(box.Text) if n then onChange(n) else box.Text=tostring(default) end end
    end)
    return box,row
end

local function styleButton(btn, hoverColor, normalColor, cornerRadius)
    cornerRadius = cornerRadius or 8
    mkCorner(btn, cornerRadius)
    local stroke = mkStroke(btn, C.btnBorder, 0.7)
    addWhiteStroke(btn, 0.5, 0.4)
    if normalColor then btn.BackgroundColor3 = normalColor end
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor or C.btnHov}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), {Color = C.whiteBorder, Thickness = 0.9}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = normalColor or C.btnBg}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), {Color = C.btnBorder, Thickness = 0.7}):Play()
    end)
end

local function makeToggleRow(label, defaultOn, onToggle)
    local row=Instance.new("Frame",currentPage) row.Size=UDim2.new(1,0,0,44) row.BackgroundTransparency=1 row.BorderSizePixel=0 row.LayoutOrder=LO()
    local div=Instance.new("Frame",row) div.Size=UDim2.new(1,-28,0,1) div.Position=UDim2.new(0,14,1,-1) div.BackgroundColor3=C.rowBorder div.BorderSizePixel=0
    local lbl=Instance.new("TextLabel",row) lbl.Size=UDim2.new(1,-70,1,0) lbl.Position=UDim2.new(0,14,0,0) lbl.BackgroundTransparency=1 lbl.Text=label lbl.TextColor3=C.rowLabel lbl.Font=Enum.Font.GothamBold lbl.TextSize=13 lbl.TextXAlignment=Enum.TextXAlignment.Left
    local pillBg=Instance.new("Frame",row) pillBg.Size=UDim2.new(0,40,0,20) pillBg.Position=UDim2.new(1,-54,0.5,-10) pillBg.BackgroundColor3=defaultOn and C.pillOn or C.pillOff pillBg.BorderSizePixel=0 pillBg.ZIndex=7 mkCorner(pillBg,12) mkStroke(pillBg,C.pillBorder,0.6) addWhiteStroke(pillBg,0.5,0.4)
    local dot=Instance.new("Frame",pillBg) dot.Size=UDim2.new(0,14,0,14) dot.Position=defaultOn and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) dot.BackgroundColor3=defaultOn and C.dotOn or C.dotOff dot.BorderSizePixel=0 dot.ZIndex=8 mkCorner(dot,9)
    local isOn = defaultOn or false
    local function setV(on)
        isOn=on
        TweenService:Create(pillBg,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and C.pillOn or C.pillOff}):Play()
        TweenService:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7), BackgroundColor3=on and C.dotOn or C.dotOff}):Play()
    end
    local function toggle()
        isOn = not isOn
        setV(isOn)
        if onToggle then pcall(onToggle, isOn) end
        pcall(saveConfig)
    end
    local clk=Instance.new("TextButton",row) clk.Size=UDim2.new(1,-58,1,0) clk.BackgroundTransparency=1 clk.Text="" clk.ZIndex=5 clk.BorderSizePixel=0 clk.MouseButton1Click:Connect(toggle)
    local pClk=Instance.new("TextButton",pillBg) pClk.Size=UDim2.new(1,0,1,0) pClk.BackgroundTransparency=1 pClk.Text="" pClk.ZIndex=9 pClk.BorderSizePixel=0 pClk.MouseButton1Click:Connect(toggle)
    return setV
end

local function getKeyDisplayName(kc)
    local n=kc.Name
    local gp={ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonL1="LB",ButtonL2="LT",ButtonL3="LS",ButtonR1="RB",ButtonR2="RT",ButtonR3="RS",ButtonSelect="SEL",ButtonStart="STA",DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",Thumbstick1="LS",Thumbstick2="RS"}
    return gp[n] or n:sub(1,5)
end

local function makeKeybindRow(label, currentKey, onChanged, keyName)
    local row=Instance.new("Frame",currentPage) row.Size=UDim2.new(1,0,0,44) row.BackgroundTransparency=1 row.BorderSizePixel=0 row.LayoutOrder=LO()
    local div=Instance.new("Frame",row) div.Size=UDim2.new(1,-28,0,1) div.Position=UDim2.new(0,14,1,-1) div.BackgroundColor3=C.rowBorder div.BorderSizePixel=0
    local lbl=Instance.new("TextLabel",row) lbl.Size=UDim2.new(1,-80,1,0) lbl.Position=UDim2.new(0,14,0,0) lbl.BackgroundTransparency=1 lbl.Text=label lbl.TextColor3=C.rowLabel lbl.Font=Enum.Font.GothamBold lbl.TextSize=13 lbl.TextXAlignment=Enum.TextXAlignment.Left
    local kbtn=Instance.new("TextButton",row) kbtn.Size=UDim2.new(0,52,0,26) kbtn.Position=UDim2.new(1,-64,0.5,-13) kbtn.BackgroundColor3=C.chipBg kbtn.BorderSizePixel=0 kbtn.Text=getKeyDisplayName(currentKey) kbtn.TextColor3=C.chipTxt kbtn.Font=Enum.Font.GothamBold kbtn.TextSize=11 kbtn.ZIndex=8
    styleButton(kbtn, C.btnHov, C.chipBg, 8)
    local listening=false
    local function stopL(key)
        listening=false
        if key then
            kbtn.Text=getKeyDisplayName(key)
            if onChanged then onChanged(key) end
            pcall(saveConfig)
        end
    end
    kbtn.MouseButton1Click:Connect(function()
        if listening then stopL(nil) return end
        listening=true; kbtn.Text="..."; kbtn.TextColor3=C.inputTxt
        local conn
        conn = UIS.InputBegan:Connect(function(inp)
            if not listening then conn:Disconnect(); return end
            if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if inp.KeyCode == Enum.KeyCode.Escape then stopL(nil) conn:Disconnect(); return end
            stopL(inp.KeyCode); conn:Disconnect()
        end)
    end)
    if keyName then keybindBtnRefs[keyName]=kbtn end
    return kbtn
end

local speedPopup = nil
local function createSpeedCustomizer()
    if speedPopup and speedPopup.Parent then speedPopup:Destroy() end
    local popup = Instance.new("Frame", gui)
    popup.Name = "SpeedCustomizerPopup"
    popup.Size = UDim2.new(0,340,0,110); popup.Position = UDim2.new(0.5,-170,0.5,-55)
    popup.BackgroundColor3 = C.winBg; popup.BackgroundTransparency = 0
    popup.BorderSizePixel = 0; popup.ZIndex = 50
    mkCorner(popup,14); mkStroke(popup,C.winBorder,0.8); addWhiteStroke(popup,0.6,0.4)
    makeDraggable(popup)
    local titleBar = Instance.new("Frame", popup)
    titleBar.Size = UDim2.new(1,0,0,28); titleBar.BackgroundColor3 = C.topBg
    titleBar.BackgroundTransparency = 0; titleBar.BorderSizePixel = 0; mkCorner(titleBar,14)
    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1,-50,1,0); title.Position = UDim2.new(0,10,0,0)
    title.BackgroundTransparency = 1; title.Text = "SPEED CUSTOMIZER ⚙️"
    title.TextColor3 = C.topTitle; title.Font = Enum.Font.GothamBold; title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0,20,0,20); closeBtn.Position = UDim2.new(1,-26,0.5,-10)
    styleButton(closeBtn, C.btnHov, C.modeBtnBg, 8)
    closeBtn.Text = "✖"; closeBtn.TextColor3 = C.topBtn; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 12
    closeBtn.MouseButton1Click:Connect(function() popup:Destroy() end)
    local content = Instance.new("Frame", popup)
    content.Size = UDim2.new(1,-16,1,-40); content.Position = UDim2.new(0,8,0,34)
    content.BackgroundTransparency = 1
    local function addRow(y, leftLabel, leftGetter, leftSetter)
        local wrap = Instance.new("Frame", content)
        wrap.Size = UDim2.new(0.9,0,0,28); wrap.Position = UDim2.new(0.05,0,0,y)
        wrap.BackgroundColor3 = C.inputBg; wrap.BorderSizePixel = 0; mkCorner(wrap,8)
        mkStroke(wrap,C.inputBorder,0.6); addWhiteStroke(wrap,0.5,0.4)
        local lbl = Instance.new("TextLabel", wrap)
        lbl.Size = UDim2.new(0.4,0,1,0); lbl.Position = UDim2.new(0,5,0,0)
        lbl.BackgroundTransparency = 1; lbl.Text = leftLabel
        lbl.TextColor3 = C.rowLabel; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local box = Instance.new("TextBox", wrap)
        box.Size = UDim2.new(0.55,-5,1,0); box.Position = UDim2.new(0.45,0,0,0)
        box.BackgroundTransparency = 1; box.Text = tostring(leftGetter())
        box.TextColor3 = C.inputTxt; box.Font = Enum.Font.GothamBold; box.TextSize = 11
        box.TextXAlignment = Enum.TextXAlignment.Center; box.ClearTextOnFocus = false
        box.FocusLost:Connect(function()
            local n = tonumber(box.Text)
            if n and n>=1 and n<=500 then leftSetter(n); box.Text = tostring(leftGetter()); pcall(saveConfig)
            else box.Text = tostring(leftGetter()) end
        end)
    end
    addRow(32, "NORMAL SPEED", function() return State.normalSpeed end, function(v) State.normalSpeed = v; if normalBox then normalBox.Text = tostring(v) end end)
    addRow(66, "CARRY SPEED", function() return State.carrySpeed end, function(v) State.carrySpeed = v; if carryBox then carryBox.Text = tostring(v) end end)
    local hint = Instance.new("TextLabel", content)
    hint.Size = UDim2.new(1,0,0,18); hint.Position = UDim2.new(0,0,1,-22)
    hint.BackgroundTransparency = 1; hint.Text = "⟳ auto-save"
    hint.TextColor3 = C.rowSub; hint.Font = Enum.Font.Gotham; hint.TextSize = 9
    hint.TextXAlignment = Enum.TextXAlignment.Center
    speedPopup = popup
end

-- ============================================================
-- AUTO LEFT / RIGHT
-- ============================================================
local autoLeftPhase, autoRightPhase = 1, 1
local function faceSouth() pcall(function() local r=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if r then r.CFrame=CFrame.new(r.Position)*CFrame.Angles(0,0,0) end end) end
local function faceNorth() pcall(function() local r=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if r then r.CFrame=CFrame.new(r.Position)*CFrame.Angles(0,math.rad(180),0) end end) end

local function startAutoLeft()
    if State.autoRightEnabled then stopAutoRight() end
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end
    State.autoLeftEnabled=true; autoLeftPhase=1
    Conns.autoLeft = RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd=State.normalSpeed
        if autoLeftPhase==1 then
            local tgt=Vector3.new(LEMON_POS.L1.X,root.Position.Y,LEMON_POS.L1.Z)
            if (tgt-root.Position).Magnitude<1 then autoLeftPhase=2; local d=(LEMON_POS.L2-root.Position).Unit; hum:Move(d,false); root.AssemblyLinearVelocity=Vector3.new(d.X*spd,root.AssemblyLinearVelocity.Y,d.Z*spd); return end
            local d=(LEMON_POS.L1-root.Position).Unit; hum:Move(d,false); root.AssemblyLinearVelocity=Vector3.new(d.X*spd,root.AssemblyLinearVelocity.Y,d.Z*spd)
        else
            local tgt=Vector3.new(LEMON_POS.L2.X,root.Position.Y,LEMON_POS.L2.Z)
            if (tgt-root.Position).Magnitude<1 then hum:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; autoLeftPhase=1; faceSouth(); if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end; return end
            local d=(LEMON_POS.L2-root.Position).Unit; hum:Move(d,false); root.AssemblyLinearVelocity=Vector3.new(d.X*spd,root.AssemblyLinearVelocity.Y,d.Z*spd)
        end
    end)
    if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(true) end
end

local function stopAutoLeft()
    State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; autoLeftPhase=1
    local char=LP.Character; if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero,false) end end
    if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end
end

local function startAutoRight()
    if State.autoLeftEnabled then stopAutoLeft() end
    if Conns.autoRight then Conns.autoRight:Disconnect() end
    State.autoRightEnabled=true; autoRightPhase=1
    Conns.autoRight = RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd=State.normalSpeed
        if autoRightPhase==1 then
            local tgt=Vector3.new(LEMON_POS.R1.X,root.Position.Y,LEMON_POS.R1.Z)
            if (tgt-root.Position).Magnitude<1 then autoRightPhase=2; local d=(LEMON_POS.R2-root.Position).Unit; hum:Move(d,false); root.AssemblyLinearVelocity=Vector3.new(d.X*spd,root.AssemblyLinearVelocity.Y,d.Z*spd); return end
            local d=(LEMON_POS.R1-root.Position).Unit; hum:Move(d,false); root.AssemblyLinearVelocity=Vector3.new(d.X*spd,root.AssemblyLinearVelocity.Y,d.Z*spd)
        else
            local tgt=Vector3.new(LEMON_POS.R2.X,root.Position.Y,LEMON_POS.R2.Z)
            if (tgt-root.Position).Magnitude<1 then hum:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; autoRightPhase=1; faceNorth(); if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end; return end
            local d=(LEMON_POS.R2-root.Position).Unit; hum:Move(d,false); root.AssemblyLinearVelocity=Vector3.new(d.X*spd,root.AssemblyLinearVelocity.Y,d.Z*spd)
        end
    end)
    if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(true) end
end

local function stopAutoRight()
    State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; autoRightPhase=1
    local char=LP.Character; if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero,false) end end
    if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end
end

-- ============================================================
-- AUTO TP DOWN LOOP
-- ============================================================
local function autoTPDownLoop()
    task.spawn(function()
        while true do
            task.wait(0.1)
            if State.autoTPDownEnabled and hrp and hrp.Parent then
                local yPos = hrp.Position.Y
                local threshold = State.autoTPDownHeight
                if yPos >= threshold then
                    hrp.CFrame = CFrame.new(hrp.Position.X, -8.80, hrp.Position.Z)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
    end)
end

-- ============================================================
-- ANTI BAT FUNCTIONALITY
-- ============================================================
local function isBatTool(tool)
    if not tool then return false end
    local name = tool.Name:lower()
    return name:find("bat") or name:find("stick") or name:find("club") or name:find("weapon")
end

local function getEnemyWithBat()
    if not hrp then return nil, nil end
    local closestDist = 7  -- range kung saan magre-react
    local closestEnemy = nil
    local closestTool = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local enemyRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local dist = (hrp.Position - enemyRoot.Position).Magnitude
                if dist <= closestDist then
                    -- tingnan kung may hawak na bat
                    local tool = p.Character:FindFirstChildOfClass("Tool")
                    if tool and isBatTool(tool) then
                        closestDist = dist
                        closestEnemy = p
                        closestTool = tool
                    end
                end
            end
        end
    end
    return closestEnemy, closestTool
end

local function antiBatSwing()
    if not State.antiBatEnabled then return end
    if State.hittingCooldown then return end
    local enemy, batTool = getEnemyWithBat()
    if enemy and batTool then
        State.hittingCooldown = true
        pcall(function()
            local c = LP.Character
            if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            local myTool = c:FindFirstChildOfClass("Tool")
            if not myTool then
                -- subukan kumuha ng tool mula sa backpack
                local bp = LP:FindFirstChildOfClass("Backpack")
                if bp then
                    myTool = bp:FindFirstChildOfClass("Tool")
                    if myTool and hum then
                        hum:EquipTool(myTool)
                    end
                end
            end
            if myTool then
                local remote = myTool:FindFirstChildOfClass("RemoteEvent")
                if remote then
                    remote:FireServer()
                else
                    myTool:Activate()
                end
            end
        end)
        task.delay(0.15, function() State.hittingCooldown = false end)
    end
end

-- Start/Stop anti bat loop
local antiBatConn = nil
local function startAntiBat()
    if antiBatConn then return end
    antiBatConn = RunService.Heartbeat:Connect(antiBatSwing)
end

local function stopAntiBat()
    if antiBatConn then antiBatConn:Disconnect(); antiBatConn = nil end
end

-- ============================================================
-- BUILD PAGES
-- ============================================================
local function buildPage(tabName, buildFn)
    local page=Instance.new("ScrollingFrame",contentBg)
    page.Name=tabName; page.Visible=(tabName=="Settings")
    page.Size=UDim2.new(1,0,1,0); page.Position=UDim2.new(0,0,0,0)
    page.BackgroundTransparency=1; page.BorderSizePixel=0
    page.ScrollBarThickness=3; page.ScrollBarImageColor3=C.accent; page.ScrollBarImageTransparency=0.4
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y; page.CanvasSize=UDim2.new(0,0,0,0)
    local ll=Instance.new("UIListLayout",page); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Padding=UDim.new(0,0)
    tabPages[tabName]=page; currentPage=page; lo=0; buildFn(); currentPage=nil
end

-- Speed Tab
buildPage("Speed", function()
    makeGap(2)
    local modeStatusRow=Instance.new("Frame",currentPage) modeStatusRow.Size=UDim2.new(1,0,0,24) modeStatusRow.BackgroundTransparency=1 modeStatusRow.BorderSizePixel=0 modeStatusRow.LayoutOrder=LO()
    local modeStatusLbl=Instance.new("TextLabel",modeStatusRow) modeStatusLbl.Size=UDim2.new(1,-28,1,0) modeStatusLbl.Position=UDim2.new(0,14,0,0) modeStatusLbl.BackgroundTransparency=1 modeStatusLbl.Text=State.speedToggled and "Mode: Carry" or (State.laggerEnabled and "Mode: Lagger" or "Mode: Normal") modeStatusLbl.TextColor3=C.rowSub modeStatusLbl.Font=Enum.Font.Gotham modeStatusLbl.TextSize=11 modeStatusLbl.TextXAlignment=Enum.TextXAlignment.Left
    local function setModeActive(active)
        if active=="Normal" then State.speedToggled=false; State.laggerEnabled=false
        elseif active=="Carry" then State.speedToggled=true; State.laggerEnabled=false
        elseif active=="Lagger" then State.speedToggled=false; State.laggerEnabled=true end
        modeStatusLbl.Text="Mode: "..active
        if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
        if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(State.laggerEnabled) end
        pcall(saveConfig)
    end
    setModeActiveFunc = setModeActive
    makeGap(10)
    makeSectionHeader("Aimbot"); makeGap(2)
    setAutoSwing=makeToggleRow("Auto Swing",State.autoSwingEnabled,function(on) State.autoSwingEnabled=on; pcall(saveConfig) end)
    makeGap(10)
    makeSectionHeader("Stealing"); makeGap(2)
    setInstaGrab=makeToggleRow("Insta Grab",Steal.AutoStealEnabled,function(on)
        Steal.AutoStealEnabled=on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        pcall(saveConfig)
    end)
    stealRadBox=makeInputRow("Steal Radius",Steal.StealRadius,function(n) if n>=5 and n<=300 then Steal.StealRadius=math.floor(n); pcall(saveConfig) end end)
    stealDurBox = makeInputRow("Steal Duration",Steal.StealDuration,function(n) if n>=0.05 and n<=2 then Steal.StealDuration=n; pcall(saveConfig) end end)
    makeGap(10)
    makeSectionHeader("Combat / Defense"); makeGap(2)
    setInfJump=makeToggleRow("Infinite Jump",State.infJumpEnabled,function(on) State.infJumpEnabled=on; pcall(saveConfig) end)
    jumpPowerBox=makeInputRow("Jump Power",State.jumpPower,function(n) if n and n>=30 and n<=200 then State.jumpPower=n; local c=LP.Character; if c then local hum=c:FindFirstChildOfClass("Humanoid"); if hum then hum.JumpPower=n end end; pcall(saveConfig) elseif n then jumpPowerBox.Text=tostring(State.jumpPower) end end)
    setHoldJump=makeToggleRow("Hold Jump",State.holdJumpEnabled,function(on) State.holdJumpEnabled=on; pcall(saveConfig) end)
    setAntiRag=makeToggleRow("Anti Ragdoll",State.antiRagdollEnabled,function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end; pcall(saveConfig) end)
    setFps=makeToggleRow("FPS Boost",State.fpsBoostEnabled,function(on) State.fpsBoostEnabled=on; if on then pcall(applyFPSBoost) end; pcall(saveConfig) end)
    setMedusaCounter=makeToggleRow("Medusa Counter",State.medusaCounterEnabled,function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end; pcall(saveConfig) end)
    -- Anti Bat toggle
    setAntiBat = makeToggleRow("Anti Bat", State.antiBatEnabled, function(on)
        State.antiBatEnabled = on
        if on then startAntiBat() else stopAntiBat() end
        pcall(saveConfig)
    end)
    makeGap(10)
    makeSectionHeader("Movement"); makeGap(4)
    local infoRow=Instance.new("Frame",currentPage) infoRow.Size=UDim2.new(1,0,0,36) infoRow.BackgroundTransparency=1 infoRow.BorderSizePixel=0 infoRow.LayoutOrder=LO()
    local infoLbl=Instance.new("TextLabel",infoRow) infoLbl.Size=UDim2.new(1,-28,1,0) infoLbl.Position=UDim2.new(0,14,0,0) infoLbl.BackgroundTransparency=1 infoLbl.Text="Z = Auto Left  |  C = Auto Right" infoLbl.TextColor3=C.rowSub infoLbl.Font=Enum.Font.Gotham infoLbl.TextSize=11 infoLbl.TextXAlignment=Enum.TextXAlignment.Left
    makeGap(8)
    makeSectionHeader("Auto TP Down"); makeGap(2)
    setAutoTPDown = makeToggleRow("Auto TP Down",State.autoTPDownEnabled,function(on) State.autoTPDownEnabled=on; pcall(saveConfig) end)
    autoTPDownHeightBox = makeInputRow("Height Threshold",State.autoTPDownHeight,function(n) if n and n>=5 and n<=500 then State.autoTPDownHeight=n; pcall(saveConfig) end end)
end)

local function applyStackButtonsVisible(visible)
    State.stackButtonsHidden = not visible
    for _, w in pairs(stackWrappers) do w.Visible = visible end
    pcall(saveConfig)
end

-- Settings Tab (speed inputs + save/reset)
buildPage("Settings", function()
    makeGap(2)
    makeSectionHeader("Speed Settings")
    makeGap(2)
    local gearBtn = Instance.new("TextButton")
    makeSectionHeader("Speed Customizer", gearBtn)
    gearBtn.MouseButton1Click:Connect(createSpeedCustomizer)
    makeGap(2)
    normalBox = makeInputRow("Normal Speed", State.normalSpeed, function(n) if n>0 and n<=500 then State.normalSpeed=n end; pcall(saveConfig) end)
    carryBox = makeInputRow("Carry Speed", State.carrySpeed, function(n) if n>0 and n<=500 then State.carrySpeed=n end; pcall(saveConfig) end)
    laggerBox = makeInputRow("Lagger Speed", State.laggerSpeed, function(n) if n>0 and n<=500 then State.laggerSpeed=n end; pcall(saveConfig) end)
    makeGap(8)
    
    makeSectionHeader("Config")
    makeGap(2)
    local saveAllBtn = Instance.new("TextButton", currentPage)
    saveAllBtn.Size = UDim2.new(1,-28,0,38); saveAllBtn.BorderSizePixel = 0
    saveAllBtn.Text = "💾  SAVE CONFIG"
    saveAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
    saveAllBtn.Font = Enum.Font.GothamBlack; saveAllBtn.TextSize = 12
    saveAllBtn.ZIndex = 5; saveAllBtn.LayoutOrder = LO()
    styleButton(saveAllBtn, Color3.fromRGB(30,8,8), C.btnBg, 10)
    saveAllBtn.MouseButton1Click:Connect(function()
        local ok1 = pcall(saveConfig)
        local ok2 = pcall(saveUIPositions)
        if ok1 then
            saveAllBtn.Text = "✓  SAVED!"
            saveAllBtn.TextColor3 = Color3.fromRGB(180,255,180)
        else
            saveAllBtn.Text = "✗  ERROR"
            saveAllBtn.TextColor3 = Color3.fromRGB(255,100,100)
        end
        task.delay(1.5, function()
            if saveAllBtn and saveAllBtn.Parent then
                saveAllBtn.Text = "💾  SAVE CONFIG"
                saveAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end)
    end)
    makeGap(4)

    local resetUIBtn = Instance.new("TextButton", currentPage)
    resetUIBtn.Size = UDim2.new(1,-28,0,38); resetUIBtn.BorderSizePixel = 0
    resetUIBtn.Text = "⟳  RESET UI POSITIONS"
    resetUIBtn.TextColor3 = C.btnTxt; resetUIBtn.Font = Enum.Font.GothamBold; resetUIBtn.TextSize = 11
    resetUIBtn.ZIndex = 5; resetUIBtn.LayoutOrder = LO()
    styleButton(resetUIBtn, C.btnHov, C.btnBg, 10)
    resetUIBtn.MouseButton1Click:Connect(function()
        mainOuter.Position = UDim2.new(0.5,-135,0.5,-260)
        infoBar.Position = UDim2.new(0.5,-130,1,-80)  -- adjust for bigger bar
        vBtnFrame.Position = UDim2.new(1,-50,0,14)
        for i,def in ipairs(stackDefs) do if stackWrappers[def.key] then stackWrappers[def.key].Position = getDefaultStackPos(i) end end
        pcall(function() if _writefile then _writefile("HunterHub_UIPositions.json", "{}") end end)
        resetUIBtn.Text = "✓  RESET!"
        task.delay(1.5, function() if resetUIBtn and resetUIBtn.Parent then resetUIBtn.Text = "⟳  RESET UI POSITIONS" end end)
    end)
end)

buildPage("Keybinds", function()
    makeGap(2); makeSectionHeader("Speed & Mode Keys"); makeGap(2)
    makeKeybindRow("Speed Key",Keys.speed,function(k) Keys.speed=k end,"speed")
    makeKeybindRow("Lagger Key",Keys.lagger,function(k) Keys.lagger=k end,"lagger")
    makeGap(8); makeSectionHeader("Action Keys"); makeGap(2)
    makeKeybindRow("Aimbot Key",Keys.aimbot,function(k) Keys.aimbot=k end,"aimbot")
    makeKeybindRow("Drop Key",Keys.drop,function(k) Keys.drop=k end,"drop")
    makeKeybindRow("TP Down Key",Keys.tpDown,function(k) Keys.tpDown=k end,"tpDown")
    makeGap(8); makeSectionHeader("Movement Keys"); makeGap(2)
    makeKeybindRow("Auto Left (Walk)",Keys.autoLeft,function(k) Keys.autoLeft=k end,"autoLeft")
    makeKeybindRow("Auto Right (Walk)",Keys.autoRight,function(k) Keys.autoRight=k end,"autoRight")
    makeGap(8); makeSectionHeader("Interface Keys"); makeGap(2)
    makeKeybindRow("Hide GUI",Keys.guiHide,function(k) Keys.guiHide=k end,"guiHide")
    makeGap(10)
    local infoRow=Instance.new("Frame",currentPage) infoRow.Size=UDim2.new(1,0,0,44) infoRow.BackgroundTransparency=1 infoRow.BorderSizePixel=0 infoRow.LayoutOrder=LO()
    local infoLbl=Instance.new("TextLabel",infoRow) infoLbl.Size=UDim2.new(1,-28,1,0) infoLbl.Position=UDim2.new(0,14,0,0) infoLbl.BackgroundTransparency=1
    infoLbl.Text="Click any key button then press a new key to rebind. Press ESC to cancel." infoLbl.TextColor3=C.rowSub infoLbl.Font=Enum.Font.Gotham infoLbl.TextSize=10 infoLbl.TextXAlignment=Enum.TextXAlignment.Left infoLbl.TextWrapped=true
end)

for _,n in ipairs(TABS) do
    local t=tabBtns[n]; local active=(n=="Settings")
    t.btn.TextColor3=active and C.tabActive or C.tabIdle
    t.btn.BackgroundColor3=active and C.tabActiveBg or C.tabBarBg
    t.underline.Visible=active
    if tabPages[n] then tabPages[n].Visible=active end
end

-- ============================================================
-- FLOATING BUTTON (45x45, circle, not draggable)
-- ============================================================
local vBtnFrame = Instance.new("Frame", gui)
vBtnFrame.Name = "HUNTERHUBVBtn"
vBtnFrame.Size = UDim2.new(0,45,0,45)
vBtnFrame.Position = UDim2.new(1,-55,0,14)
vBtnFrame.BackgroundColor3 = Color3.fromRGB(8,8,8)
vBtnFrame.BorderSizePixel = 0; vBtnFrame.Active = true; vBtnFrame.ZIndex = 20
mkCorner(vBtnFrame, 22.5)
addRotatingRedBorder(vBtnFrame, 1.2)
addWhiteStroke(vBtnFrame, 0.6, 0.4)

local vBtnText = Instance.new("TextLabel", vBtnFrame)
vBtnText.Size = UDim2.new(1,0,1,0); vBtnText.BackgroundTransparency = 1
vBtnText.Text = "5s\nduel"
vBtnText.TextColor3 = Color3.fromRGB(255,255,255)
vBtnText.Font = Enum.Font.GothamBlack; vBtnText.TextSize = 9
vBtnText.TextScaled = true; vBtnText.TextWrapped = true; vBtnText.ZIndex = 21

vBtnFrame.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        State.guiVisible = not State.guiVisible
        mainOuter.Visible = State.guiVisible
    end
end)

-- ============================================================
-- INFO BAR (STEAL PROGRESS) - PINALAKI (260x70)
-- ============================================================
local infoBar = Instance.new("Frame", gui)
infoBar.Size = UDim2.new(0,260,0,70)  -- dati 210x56, ngayon mas malaki
infoBar.Position = UDim2.new(0.5,-130,1,-80)
infoBar.BackgroundColor3 = C.infoBg; infoBar.BorderSizePixel = 0; infoBar.Active = true
mkCorner(infoBar,14)
addRotatingRedBorder(infoBar, 1.2)
addWhiteStroke(infoBar,0.6,0.4)
makeDraggable(infoBar)

local ibAcc = Instance.new("Frame", infoBar)
ibAcc.Size = UDim2.new(0,3,0.6,0); ibAcc.Position = UDim2.new(0,0,0.2,0)
ibAcc.BackgroundColor3 = C.accent; ibAcc.BorderSizePixel = 0; mkCorner(ibAcc,2)

local stealLbl = Instance.new("TextLabel", infoBar)
stealLbl.Size = UDim2.new(0,120,0,16); stealLbl.Position = UDim2.new(0,12,0,8)
stealLbl.BackgroundTransparency = 1; stealLbl.Text = "Steal Progress"
stealLbl.TextColor3 = C.infoTxt; stealLbl.Font = Enum.Font.GothamBold; stealLbl.TextSize = 11
stealLbl.TextXAlignment = Enum.TextXAlignment.Left

stealPctLbl = Instance.new("TextLabel", infoBar)
stealPctLbl.Size = UDim2.new(0,50,0,16); stealPctLbl.Position = UDim2.new(1,-56,0,8)
stealPctLbl.BackgroundTransparency = 1; stealPctLbl.Text = "0%"
stealPctLbl.TextColor3 = C.infoVal; stealPctLbl.Font = Enum.Font.GothamBlack; stealPctLbl.TextSize = 12
stealPctLbl.TextXAlignment = Enum.TextXAlignment.Right

local pTrack = Instance.new("Frame", infoBar)
pTrack.Size = UDim2.new(1,-24,0,6); pTrack.Position = UDim2.new(0,12,0,36)  -- mas makapal na progress bar
pTrack.BackgroundColor3 = C.infoBrd; pTrack.BorderSizePixel = 0; mkCorner(pTrack,3)

progressFill = Instance.new("Frame", pTrack)
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = C.infoFill; progressFill.BorderSizePixel = 0; mkCorner(progressFill,3)

-- ============================================================
-- STACK BUTTONS (intense red border, no dots)
-- ============================================================
local EXCLUSIVE_GROUP_SPEED = {carrySpeed=true, lagger=true}
local EXCLUSIVE_GROUP_ACTION = {autoLeft=true, autoRight=true, aimbot=true, drop=true}

local function turnOffGroup(group, exceptKey)
    for key in pairs(group) do
        if key ~= exceptKey then
            local ref = stackBtnRefs[key]
            if ref and ref.setOn then ref.setOn(false) end
            if key == "autoLeft" and State.autoLeftEnabled then pcall(stopAutoLeft) end
            if key == "autoRight" and State.autoRightEnabled then pcall(stopAutoRight) end
            if key == "aimbot" and State.batAimbotToggled then State.batAimbotToggled = false; pcall(stopBatAimbot) end
            if key == "drop" and State.dropEnabled then pcall(stopDropBrainrot) end
            if key == "carrySpeed" and State.speedToggled then State.speedToggled = false end
            if key == "lagger" and State.laggerEnabled then State.laggerEnabled = false end
        end
    end
end

for i,def in ipairs(stackDefs) do
    local btnFrame = Instance.new("Frame", gui)
    btnFrame.Name = "StackBtn_"..def.key
    btnFrame.Size = UDim2.new(0,BTN_W,0,BTN_H)
    btnFrame.Position = getDefaultStackPos(i)
    btnFrame.BackgroundColor3 = C.stackBg
    btnFrame.BorderSizePixel = 0
    btnFrame.Active = true
    btnFrame.ZIndex = 15
    mkCorner(btnFrame, BTN_CORNER)
    addRotatingRedBorder(btnFrame, 1.2)
    addWhiteStroke(btnFrame, 0.5, 0.3)
    stackWrappers[def.key] = btnFrame
    local nl = Instance.new("TextLabel", btnFrame)
    nl.Size = UDim2.new(1,-6,1,0); nl.Position = UDim2.new(0,3,0,0)
    nl.BackgroundTransparency = 1; nl.Text = def.label; nl.TextColor3 = C.stackTxt
    nl.Font = Enum.Font.GothamBlack; nl.TextSize = 10; nl.TextWrapped = true
    nl.TextXAlignment = Enum.TextXAlignment.Center; nl.ZIndex = 6
    
    local btnState = false
    local function setOn(on)
        btnState = on
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {BackgroundColor3 = on and C.stackActBg or C.stackBg}):Play()
        TweenService:Create(nl, TweenInfo.new(0.15), {TextColor3 = on and C.stackActTxt or C.stackTxt}):Play()
    end
    stackBtnRefs[def.key] = {setOn = setOn}
    btnFrame.MouseEnter:Connect(function() if not btnState then TweenService:Create(btnFrame,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(40,15,15)}):Play() end end)
    btnFrame.MouseLeave:Connect(function() TweenService:Create(btnFrame,TweenInfo.new(0.1),{BackgroundColor3=btnState and C.stackActBg or C.stackBg}):Play() end)
    
    local function onTap()
        if def.key == "autoLeft" then
            if State.autoLeftEnabled then stopAutoLeft()
            else turnOffGroup(EXCLUSIVE_GROUP_ACTION, "autoLeft"); startAutoLeft() end
            return
        end
        if def.key == "autoRight" then
            if State.autoRightEnabled then stopAutoRight()
            else turnOffGroup(EXCLUSIVE_GROUP_ACTION, "autoRight"); startAutoRight() end
            return
        end
        if def.key == "tpDown" then doTpDown(); return end
        if def.key == "carrySpeed" then
            local ns = not State.speedToggled
            if ns then turnOffGroup(EXCLUSIVE_GROUP_SPEED, "carrySpeed") end
            State.speedToggled = ns
            setOn(ns)
            if setModeActiveFunc then
                if ns then setModeActiveFunc("Carry") else setModeActiveFunc("Normal") end
            end
            pcall(saveConfig)
            return
        end
        if def.key == "aimbot" then
            local ns = not btnState
            if ns then turnOffGroup(EXCLUSIVE_GROUP_ACTION, "aimbot") end
            setOn(ns)
            State.batAimbotToggled = ns
            if ns then pcall(startBatAimbot) else stopBatAimbot() end
            pcall(saveConfig)
            return
        end
        if def.key == "lagger" then
            local ns = not btnState
            if ns then turnOffGroup(EXCLUSIVE_GROUP_SPEED, "lagger") end
            setOn(ns)
            State.laggerEnabled = ns
            if ns then
                State._prevCarry = State.carrySpeed
                State._prevSpeed = State.speedToggled
                State.speedToggled = false
                if carryBox then carryBox.Text = tostring(State.laggerSpeed) end
                if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
                if setModeActiveFunc then setModeActiveFunc("Lagger") end
            else
                State.carrySpeed = State._prevCarry or 30
                State.speedToggled = State._prevSpeed or false
                if carryBox then carryBox.Text = tostring(State.carrySpeed) end
                if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
                if setModeActiveFunc then
                    if State.speedToggled then setModeActiveFunc("Carry") else setModeActiveFunc("Normal") end
                end
            end
            pcall(saveConfig)
            return
        end
        if def.key == "drop" then
            if not State.dropEnabled then turnOffGroup(EXCLUSIVE_GROUP_ACTION, "drop"); runDropBrainrot() else stopDropBrainrot() end
            return
        end
    end
    makeStackDraggable(btnFrame, onTap)
end

-- ============================================================
-- HOLD JUMP
-- ============================================================
local spaceHeld = false
local holdJumpConn = nil

local function startHoldJump()
    if holdJumpConn then return end
    holdJumpConn = RunService.Heartbeat:Connect(function()
        if not State.holdJumpEnabled then return end
        if not spaceHeld then return end
        local char = LP.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if humanoid:GetState() == Enum.HumanoidStateType.Landed then
            humanoid.Jump = true
        end
    end)
end

local function stopHoldJump()
    if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        spaceHeld = true
        if State.holdJumpEnabled then startHoldJump() end
    end
end)
UIS.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Space then
        spaceHeld = false
        if holdJumpConn then stopHoldJump() end
    end
end)

-- ============================================================
-- OTHER FUNCTIONS (tpDown, drop, aimbot, medusa, antirag, fps)
-- ============================================================
doTpDown = function()
    pcall(function()
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local ray = RaycastParams.new(); ray.FilterDescendantsInstances = {char}; ray.FilterType = Enum.RaycastFilterType.Exclude
        local res = workspace:Raycast(root.Position, Vector3.new(0,-600,0), ray)
        if res then
            root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero
            local newY = res.Position.Y + (hum.HipHeight or 2) + (root.Size.Y/2) + 0.1
            root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

local _dropConns = {}
runDropBrainrot = function()
    if State.dropEnabled then return end; State.dropEnabled = true
    if stackBtnRefs.drop then stackBtnRefs.drop.setOn(true) end
    if State.batAimbotToggled then
        State.batAimbotToggled = false
        stopBatAimbot()
        if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end
        pcall(saveConfig)
    end
    task.spawn(function()
        local colConn = RunService.Stepped:Connect(function()
            if not State.dropEnabled then return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _,part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end)
        table.insert(_dropConns, colConn)
        task.spawn(function()
            while State.dropEnabled do
                RunService.Heartbeat:Wait()
                local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                local vel = root.Velocity
                root.Velocity = vel*10000 + Vector3.new(0,10000,0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if root and root.Parent then root.Velocity = vel + Vector3.new(0,0.1,0) end
            end
        end)
        task.wait(DROP_AUTO_OFF_DELAY); stopDropBrainrot()
    end)
end

stopDropBrainrot = function()
    State.dropEnabled = false
    for _,cn in ipairs(_dropConns) do pcall(function() cn:Disconnect() end) end
    _dropConns = {}
    if stackBtnRefs.drop then stackBtnRefs.drop.setOn(false) end
end

local VYSE_AIMBOT_SPEED = 56.5
local VYSE_HIT_DIST = 5
local SWING_COOLDOWN = 0.08
local function findAnyTool()
    local c = LP.Character; if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
    local bp = LP:FindFirstChildOfClass("Backpack"); if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
    return nil
end
local function getClosestPlayer()
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end
local function tryHitBat()
    if State.hittingCooldown then return end; State.hittingCooldown = true
    pcall(function()
        local c = LP.Character; if not c then return end
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        local tool = findAnyTool()
        if tool then
            if tool.Parent ~= c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end) else pcall(function() tool:Activate() end) end
        end
    end)
    task.delay(SWING_COOLDOWN, function() State.hittingCooldown = false end)
end
startBatAimbot = function()
    if Conns.aimbot then return end
    Conns.aimbot = RunService.Heartbeat:Connect(function()
        if not State.batAimbotToggled then return end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum2 = c:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local target, dist = getClosestPlayer()
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local fp = tr.Position + tr.CFrame.LookVector * 1.5
                local dir = (fp - root.Position).Unit
                root.AssemblyLinearVelocity = Vector3.new(dir.X*VYSE_AIMBOT_SPEED, dir.Y*VYSE_AIMBOT_SPEED, dir.Z*VYSE_AIMBOT_SPEED)
                if dist <= VYSE_HIT_DIST and State.autoSwingEnabled then tryHitBat() end
            end
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end
stopBatAimbot = function()
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
    local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero end; State.hittingCooldown = false
end

local function findMedusa()
    local c = LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp = LP:FindFirstChild("Backpack"); if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusa()
    if State.medusaDebounce then return end; if tick() - State.medusaLastUsed < 25 then return end
    local char = LP.Character; if not char then return end; State.medusaDebounce = true
    local med = findMedusa(); if not med then State.medusaDebounce = false; return end
    if med.Parent ~= char then local hum2 = char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed = tick(); State.medusaDebounce = false
end
local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 and State.medusaCounterEnabled then useMedusa() end
    end)
end
setupMedusaCounter = function(char)
    stopMedusaCounter(); if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end))
end
stopMedusaCounter = function()
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor = {}
end

startAntiRagdoll = function()
    if Conns.antiRag then return end
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        local c = LP.Character; if not c then return end
        local hum2 = c:FindFirstChildOfClass("Humanoid"); local root = c:FindFirstChild("HumanoidRootPart")
        if not hum2 or not root then return end; if hum2.Health <= 0 then return end
        local st = hum2:GetState(); if st == Enum.HumanoidStateType.Dead then return end
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            pcall(function() hum2:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() workspace.CurrentCamera.CameraSubject = hum2 end)
            pcall(function() local PM = LP.PlayerScripts:FindFirstChild("PlayerModule"); if PM then local CM = require(PM:FindFirstChild("ControlModule")); if CM then CM:Enable() end end end)
            root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero
        end
        for _,obj in ipairs(c:GetDescendants()) do pcall(function() if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end end) end
    end)
end
stopAntiRagdoll = function() if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag = nil end end

applyFPSBoost = function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v)
        pcall(function()
            if v:IsA("MeshPart") then v.CastShadow = false; v.RenderFidelity = Enum.RenderFidelity.Performance
            elseif v:IsA("BasePart") then v.CastShadow = false; v.Material = Enum.Material.Plastic; v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled = false
            elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
            end
        end)
    end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L = game:GetService("Lighting")
        L.GlobalShadows = false; L.FogEnd = 9e9; L.Brightness = 0
        for _,v in pairs(L:GetDescendants()) do pcall(function()
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy()
            end
        end) end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end

-- ============================================================
-- CHARACTER SETUP
-- ============================================================
local function setupChar(char)
    task.wait(0.1)
    h = char:WaitForChild("Humanoid",5)
    hrp = char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end
    h.JumpPower = State.jumpPower
    local head = char:FindFirstChild("Head")
    if head then
        local old = head:FindFirstChild("HUNTERHUBBB"); if old then old:Destroy() end
        local bb = Instance.new("BillboardGui", head)
        bb.Name = "HUNTERHUBBB"; bb.Size = UDim2.new(0,160,0,52)
        bb.StudsOffset = Vector3.new(0,3,0); bb.AlwaysOnTop = true
        local sl = Instance.new("TextLabel", bb)
        sl.Name = "SpeedBillLbl"; sl.Size = UDim2.new(1,0,0,24)
        sl.BackgroundTransparency = 1; sl.Text = "0.0"
        sl.TextColor3 = Color3.fromRGB(255,180,180); sl.Font = Enum.Font.GothamBlack
        sl.TextScaled = true
        local l2 = Instance.new("TextLabel", bb)
        l2.Size = UDim2.new(1,0,0,24); l2.Position = UDim2.new(0,0,0,28)
        l2.BackgroundTransparency = 1; l2.Text = "5s duel"
        l2.TextColor3 = Color3.fromRGB(255,150,150); l2.Font = Enum.Font.GothamBold
        l2.TextScaled = true
    end
    stopAntiRagdoll(); if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
    if State.medusaCounterEnabled then setupMedusaCounter(char) end
    if State.batAimbotToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.antiBatEnabled then startAntiBat() else stopAntiBat() end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- ============================================================
-- RUNTIME LOOPS
-- ============================================================
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c = LP.Character; if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity = Vector3.new(root.Velocity.X, State.jumpPower, root.Velocity.Z) end
end)

RunService.RenderStepped:Connect(function()
    if not (h and hrp) then return end
    if not State.batAimbotToggled and not State.autoLeftEnabled and not State.autoRightEnabled then
        local md = h.MoveDirection
        local spd = State.laggerEnabled and State.laggerSpeed or (State.speedToggled and State.carrySpeed or State.normalSpeed)
        if md.Magnitude > 0 then
            State.lastMoveDir = md
            hrp.Velocity = Vector3.new(md.X*spd, hrp.Velocity.Y, md.Z*spd)
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
            local any = false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then any = true; break end end
            if any then hrp.Velocity = Vector3.new(State.lastMoveDir.X*spd, hrp.Velocity.Y, State.lastMoveDir.Z*spd) end
        end
    end
    pcall(function()
        local head2 = LP.Character and LP.Character:FindFirstChild("Head")
        if head2 then
            local bb2 = head2:FindFirstChild("HUNTERHUBBB")
            local sl = bb2 and bb2:FindFirstChild("SpeedBillLbl")
            if sl then
                local hspd = Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude
                sl.Text = string.format("%.1f", hspd)
            end
        end
    end)
end)

-- ============================================================
-- INPUT HANDLER
-- ============================================================
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local kc = inp.KeyCode; if kc == Enum.KeyCode.Unknown then return end
    if kc == Keys.speed then
        State.speedToggled = not State.speedToggled
        if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
        if setModeActiveFunc then
            if State.speedToggled then setModeActiveFunc("Carry") else setModeActiveFunc("Normal") end
        end
        pcall(saveConfig)
    elseif kc == Keys.autoLeft then
        if State.autoLeftEnabled then stopAutoLeft() else startAutoLeft() end
    elseif kc == Keys.autoRight then
        if State.autoRightEnabled then stopAutoRight() else startAutoRight() end
    elseif kc == Keys.drop then
        if not State.dropEnabled then runDropBrainrot() end
    elseif kc == Keys.lagger then
        State.laggerEnabled = not State.laggerEnabled
        if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(State.laggerEnabled) end
        if State.laggerEnabled then
            State._prevCarry = State.carrySpeed
            State._prevSpeed = State.speedToggled
            State.speedToggled = false
            if carryBox then carryBox.Text = tostring(State.laggerSpeed) end
            if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
            if setModeActiveFunc then setModeActiveFunc("Lagger") end
        else
            State.carrySpeed = State._prevCarry or 30
            State.speedToggled = State._prevSpeed or false
            if carryBox then carryBox.Text = tostring(State.carrySpeed) end
            if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
            if setModeActiveFunc then
                if State.speedToggled then setModeActiveFunc("Carry") else setModeActiveFunc("Normal") end
            end
        end
        pcall(saveConfig)
    elseif kc == Keys.tpDown then
        doTpDown()
    elseif kc == Keys.aimbot then
        State.batAimbotToggled = not State.batAimbotToggled
        if State.batAimbotToggled then pcall(startBatAimbot) else stopBatAimbot() end
        if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(State.batAimbotToggled) end
        pcall(saveConfig)
    elseif kc == Keys.guiHide then
        State.guiVisible = not State.guiVisible; mainOuter.Visible = State.guiVisible
    end
end)

-- ============================================================
-- INITIALIZATION
-- ============================================================
loadConfig()

local function applyLoadedButtonStates()
    if State.speedToggled then
        if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(true) end
    else
        if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
    end
    if State.laggerEnabled then
        if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(true) end
    else
        if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(false) end
    end
    
    if State.autoLeftEnabled then
        if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(true) end
        pcall(startAutoLeft)
    else
        if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end
        pcall(stopAutoLeft)
    end
    
    if State.autoRightEnabled then
        if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(true) end
        pcall(startAutoRight)
    else
        if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end
        pcall(stopAutoRight)
    end
    
    if State.batAimbotToggled then
        if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(true) end
        pcall(startBatAimbot)
    else
        if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end
        pcall(stopBatAimbot)
    end
    
    if State.dropEnabled then
        if stackBtnRefs.drop then stackBtnRefs.drop.setOn(true) end
        pcall(runDropBrainrot)
    else
        if stackBtnRefs.drop then stackBtnRefs.drop.setOn(false) end
        pcall(stopDropBrainrot)
    end
    
    if setModeActiveFunc then
        if State.speedToggled then
            setModeActiveFunc("Carry")
        elseif State.laggerEnabled then
            setModeActiveFunc("Lagger")
        else
            setModeActiveFunc("Normal")
        end
    end
    
    if State.antiBatEnabled then startAntiBat() else stopAntiBat() end
end

task.spawn(function()
    task.wait(0.1)
    loadUIPositions()
    applyLoadedButtonStates()
    
    if setInfJump then setInfJump(State.infJumpEnabled) end
    if setAntiRag then setAntiRag(State.antiRagdollEnabled) end
    if setFps then setFps(State.fpsBoostEnabled) end
    if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
    if setInstaGrab then setInstaGrab(Steal.AutoStealEnabled) end
    if setAutoSwing then setAutoSwing(State.autoSwingEnabled) end
    if setHoldJump then setHoldJump(State.holdJumpEnabled) end
    if setAutoTPDown then setAutoTPDown(State.autoTPDownEnabled) end
    if State.autoTPDownHeight and autoTPDownHeightBox then autoTPDownHeightBox.Text = tostring(State.autoTPDownHeight) end
    
    applyStackButtonsVisible(not State.stackButtonsHidden)
    uiScaleObj.Scale = State.uiScale
end)

autoTPDownLoop()

task.delay(1, function() pcall(saveConfig) end)
print("[5s duel] RED/BLACK + INTENSE ROTATING BORDERS + ANTI BAT + BIGGER STEAL BAR loaded.")
print("Keys: Z=AutoL | C=AutoR | Q=Speed toggle | G=Lagger | T=TP Down | H=Drop | F=Aim | Ctrl=Hide GUI")
print("Anti Bat: automatically swings when an enemy with a bat is within 7 studs.")
print("Steal bar is now larger (260x70) with thicker progress bar.")
print("Speed settings (Normal, Carry, Lagger) are in the Settings tab.")
print("Carry Speed and Lagger are mutually exclusive with each other ONLY.")
print("Auto L, Auto R, AIM, DROP are mutually exclusive among themselves.")
print("All settings are saved and restored.")

print("Hi BJ")
