return function(Players, LocalPlayer, ReplicatedStorage, Library)
    
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
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error", 
                Content = "No player selected", 
                Delay = 3
            })
            return false
        end
        
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if not targetPlayer then
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error", 
                Content = "Player not found", 
                Delay = 3
            })
            return false
        end
        
        local success, err = pcall(function()
            Module.RFInitiateTrade:InvokeServer(targetPlayer.UserId, Module.Config.TradeItemId)
        end)
        
        if success then
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Success", 
                Content = "Trade request sent to " .. targetPlayerName, 
                Delay = 3
            })
            return true
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error", 
                Content = "Auto Trade Error: " .. tostring(err), 
                Delay = 3
            })
            return false
        end
    end
    
    function Module.SetAutoAccept(enabled)
        Module.State.AutoAcceptEnabled = enabled
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "| Auto Accept", 
            Content = enabled and "ON" or "OFF", 
            Delay = 3
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
