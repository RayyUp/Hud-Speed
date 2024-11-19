local vehicleData = {}

RegisterServerEvent("saveMileage")
AddEventHandler("saveMileage", function(plate, mileage)
    vehicleData[plate] = mileage
end)

RegisterServerEvent("getMileage")
AddEventHandler("getMileage", function(plate)
    local source = source
    local mileage = vehicleData[plate] or 0
    TriggerClientEvent("returnMileage", source, plate, mileage)
end)
