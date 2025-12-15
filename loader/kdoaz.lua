local gs = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/Aiko-Hub/refs/heads/main/loader/gamelist.lua"))()

for PlaceID, Execute in pairs(gs) do
    if PlaceID == game.PlaceId then
        loadstring(game:HttpGet(Execute))()
    end
end
