return function(Players, LocalPlayer, ReplicatedStorage, WindUI)
    
    local Module = {}
    
    Module.Config = {
        RefreshInterval = 1, -- seconds
        TradeItemId = "36a63fb5-df50-4d51-9b05-9d226ccd3ce7"
    }
    
    Module.RFInitiateTrade = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/InitiateTrade"]
    Module.RFAwaitTradeResponse = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/AwaitTradeResponse"]
    
    Module.State = {
        AutoAcceptEnabled = false,
        SelectedTradePlayer = nil
    }
    
    function Module.GetPlayerNames()
        local playerNames = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(playerNames, plr.Name)
            end
        end
        table.sort(playerNames)
        return playerNames
    end
    
    function Module.SendTradeRequest(targetPlayerName)
        if not targetPlayerName then
            WindUI:Notify({
                Title = "Error", 
                Content = "No player selected", 
                Duration = 3
            })
            return false
        end
        
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if not targetPlayer then
            WindUI:Notify({
                Title = "Error", 
                Content = "Player not found", 
                Duration = 3
            })
            return false
        end
        
        local success, err = pcall(function()
            Module.RFInitiateTrade:InvokeServer(targetPlayer.UserId, Module.Config.TradeItemId)
        end)
        
        if success then
            WindUI:Notify({
                Title = "Success", 
                Content = "Trade request sent to " .. targetPlayerName, 
                Duration = 3
            })
            return true
        else
            WindUI:Notify({
                Title = "Error", 
                Content = "Auto Trade Error: " .. tostring(err), 
                Duration = 3
            })
            return false
        end
    end
    
    function Module.SetAutoAccept(enabled)
        Module.State.AutoAcceptEnabled = enabled
        WindUI:Notify({
            Title = "Auto Accept", 
            Content = enabled and "ON" or "OFF", 
            Duration = 3
        })
    end
    
    function Module.GetAutoAcceptState()
        return Module.State.AutoAcceptEnabled
    end
    
    Module.RFAwaitTradeResponse.OnClientInvoke = newcclosure(function(itemData, fromPlayer, serverTime)
        return Module.State.AutoAcceptEnabled
    end)
    
    return Module
end
