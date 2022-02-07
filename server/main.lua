ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('rorp_farmer:GiveCrop')
AddEventHandler('rorp_farmer:GiveCrop', function(crop)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.canCarryItem(crop, 1) then
        xPlayer.addInventoryItem(crop, 1)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Inventory penuh')
    end
end)

RegisterServerEvent('rorp_farmer:ProcessSV')
AddEventHandler('rorp_farmer:ProcessSV', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if item == 'botol_sambal' then
        if xPlayer.getInventoryItem('botol').count >= 1 then
            if xPlayer.getInventoryItem('chili').count >= 4 then
                if xPlayer.canCarryItem(item, 1) then
                    xPlayer.removeInventoryItem('botol', 1)
                    xPlayer.removeInventoryItem('chili', 4)

                    TriggerClientEvent('rorp_farmer:ProcessCL', xPlayer.source, item)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Inventory penuh')
                end
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
        end
    elseif item == 'botol_cocoa' then
        if xPlayer.getInventoryItem('botol').count >= 1 then
            if xPlayer.getInventoryItem('cocoa').count >= 4 then
                if xPlayer.canCarryItem(item, 1) then
                    xPlayer.removeInventoryItem('botol', 1)
                    xPlayer.removeInventoryItem('cocoa', 4)

                    TriggerClientEvent('rorp_farmer:ProcessCL', xPlayer.source, item)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Inventory penuh')
                end
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
            end
        else
            TriggerClientEvent('esx:showNotification', source, 'Tidak memiliki cukup bahan')
        end
    elseif item == 'botol_kopi' then
        if xPlayer.getInventoryItem('botol').count >= 1 then
            if xPlayer.getInventoryItem('biji_kopi').count >= 4 then
                if xPlayer.canCarryItem(item, 1) then
                    xPlayer.removeInventoryItem('botol', 1)
                    xPlayer.removeInventoryItem('biji_kopi', 4)

                    TriggerClientEvent('rorp_farmer:ProcessCL', xPlayer.source, item)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Inventory penuh')
                end
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
        end
    elseif item == 'teh_celup' then
        if xPlayer.getInventoryItem('fabric').count >= 1 then
            if xPlayer.getInventoryItem('daun_teh').count >= 4 then
                if xPlayer.canCarryItem(item, 1) then
                    xPlayer.removeInventoryItem('fabric', 1)
                    xPlayer.removeInventoryItem('daun_teh', 4)

                    TriggerClientEvent('rorp_farmer:ProcessCL', xPlayer.source, item)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Inventory penuh')
                end
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
        end
    elseif item == 'gula' then
        if xPlayer.getInventoryItem('fabric').count >= 1 then
            if xPlayer.getInventoryItem('sugarcane').count >= 4 then
                if xPlayer.canCarryItem(item, 1) then
                    xPlayer.removeInventoryItem('fabric', 1)
                    xPlayer.removeInventoryItem('sugarcane', 4)

                    TriggerClientEvent('rorp_farmer:ProcessCL', xPlayer.source, item)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Inventory penuh')
                end
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
        end
    elseif item == 'beras' then
        if xPlayer.getInventoryItem('fabric').count >= 1 then
            if xPlayer.getInventoryItem('rice').count >= 4 then
                if xPlayer.canCarryItem(item, 1) then
                    xPlayer.removeInventoryItem('fabric', 1)
                    xPlayer.removeInventoryItem('rice', 4)

                    TriggerClientEvent('rorp_farmer:ProcessCL', xPlayer.source, item)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Inventory penuh')
                end
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Tidak memiliki cukup bahan')
        end
    end
end)