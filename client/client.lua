local inCar, isReady, cinemaMode = false, nil, false
local hudVisible = true
local before = {pause = nil, speedometer_visible = false, fuel = nil, speed = nil, engine = nil}

RegisterCommand(Config.CommandName, function() 
    cinemaMode = not cinemaMode 
end, false)

Citizen.CreateThread(function() 
    while true do 
        if cinemaMode then
            DrawRect(0.5, 0.0, 1.0, 0.25, 0, 0, 0, 255) 
            DrawRect(0.5, 1.0, 1.0, 0.25, 0, 0, 0, 255) 
            SendNUIMessage({status = 'visible', data = false}) 
            DisplayRadar(false) 
        else
            if hudVisible then
                SendNUIMessage({status = 'visible', data = true})
            else
                SendNUIMessage({status = 'visible', data = false})
            end
        end
        Citizen.Wait(0) 
    end 
end)

RegisterCommand(Config.CommandNameHud, function()
    hudVisible = not hudVisible
    if cinemaMode == false then
        SendNUIMessage({status = 'visible', data = hudVisible})
    end
end, false)

Citizen.CreateThread(function() 
    while true do 
        local player = PlayerPedId() 
        local isPedInVehicle = IsPedInAnyVehicle(player, false) 
        DisplayRadar(isPedInVehicle) 
        DisplayHud(not isPedInVehicle) 
        Citizen.Wait(isPedInVehicle and 200 or 1000) 
    end 
end)

Citizen.CreateThread(function() 
    while true do 
        local player = PlayerPedId() 
        local health, armour = GetEntityHealth(player) - 100, GetPedArmour(player) 
        local food, water 

        TriggerEvent('esx_status:getStatus', 'hunger', function(status) food = status.val / 10000 end) 
        TriggerEvent('esx_status:getStatus', 'thirst', function(status) water = status.val / 10000 end) 

        if not food or not water then 
            Citizen.Wait(1000) 
        else 
            isReady = true 
            health = health < 0 and 0 or health 
            SendNUIMessage({status = 'info', data = {health = health, armour = armour, food = food, water = water}}) 
            Citizen.Wait(3000) 
        end 
    end 
end)

Citizen.CreateThread(function() 
    local waitTime = 1000 
    while true do 
        if before.ready ~= isReady then 
            before.ready = isReady 
            SendNUIMessage({status = 'visible', data = true}) 
        end 

        local pause = IsPauseMenuActive() 
        if pause ~= before.pause then 
            SendNUIMessage({status = 'visible', data = not pause}) 
            before.pause = pause 
        end 

        local player = PlayerPedId() 
        local isPedInVehicle = IsPedInAnyVehicle(player, false) 

        if isPedInVehicle then 
            local vehicle = GetVehiclePedIsIn(player) 
            if GetPedInVehicleSeat(vehicle, -1) == player then 
                local fuel, speed, engine = GetVehicleFuelLevel(vehicle), GetEntitySpeed(vehicle) * (is_mph and 2.236936 or 3.6), GetVehicleEngineHealth(vehicle) / 10 
                if fuel ~= before.fuel or speed ~= before.speed or engine ~= before.engine then 
                    before.fuel, before.speed, before.engine = fuel, speed, engine 
                    SendNUIMessage({status = 'speedometer', data = {visible = true, speed = speed, engine = engine, fuel = fuel, mph = is_mph}}) 
                end 
                waitTime = 200 
            end 
            before.speedometer_visible = true 
        else 
            if before.speedometer_visible then 
                SendNUIMessage({status = 'speedometer', data = {visible = false}}) 
                before.speedometer_visible = false 
            end 
            waitTime = 1000 
        end 

        Citizen.Wait(waitTime) 
    end 
end)

local posX, posY = 0.01, 0.0
local width, height = 0.200, 0.280

Citizen.CreateThread(function()
    RequestStreamedTextureDict("minimap", false)
    while not HasStreamedTextureDictLoaded("minimap") do
        Wait(100)
    end

    AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', 'squaremap', 'radarmasksm')

    SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', -0.022, -0.022, 0.380, 0.340)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.022, -0.022, 0.340, 0.280)

    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local isTalking = NetworkIsPlayerTalking(PlayerId())

        if isTalking then
            SendNUIMessage({
                action = 'showTalkingImage'
            })
        else
            SendNUIMessage({
                action = 'hideTalkingImage'
            })
        end
    end
end)
