local hudVisible = false
local vehicleMileage = {} 

local function updateHud(speed, fuel, mileage)
    SendNUIMessage({
        action = "updateHUD",
        speed = math.floor(speed),
        fuel = math.floor(fuel),
        mileage = math.floor(mileage),
    })
end

local function toggleHud(state)
    hudVisible = state
    SendNUIMessage({
        action = "toggleHUD",
        state = hudVisible
    })
end

local function loadMileage(plate)
    TriggerServerEvent("getMileage", plate)
end

RegisterNetEvent("returnMileage")
AddEventHandler("returnMileage", function(plate, mileage)
    vehicleMileage[plate] = mileage
end)

local function saveMileage(plate, mileage)
    TriggerServerEvent("saveMileage", plate, mileage)
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then

            local speed = GetEntitySpeed(vehicle) * 3.6 -- 
            local fuel = GetVehicleFuelLevel(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)

            if vehicleMileage[plate] == nil then
                loadMileage(plate) 
                vehicleMileage[plate] = 0 
            end

           
            vehicleMileage[plate] = vehicleMileage[plate] + (speed / 3600) 
            local mileage = vehicleMileage[plate]

            
            updateHud(speed, fuel, mileage)

           
            if not hudVisible then
                toggleHud(true)
            end
        else
           
            if hudVisible then
                toggleHud(false)
            end
        end

        Wait(100) 
    end
end)


CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 and hudVisible then
            local lastVehicle = GetVehiclePedIsTryingToEnter(ped) or GetPlayersLastVehicle()
            if lastVehicle ~= 0 then
                local plate = GetVehicleNumberPlateText(lastVehicle)
                if vehicleMileage[plate] then
                    saveMileage(plate, vehicleMileage[plate])
                end
            end
        end

        Wait(1000) 
    end
end)
