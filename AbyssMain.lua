loadstring(game:HttpGet(("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))()

       local Window = MakeWindow({
         Hub = {
         Title = "Abyss Hub",
         Animation = "Abyss Hub"
         },
        Key = {
        KeySystem = false,
        Title = "Key System",
        Description = "",
        KeyLink = "",
        Keys = {"1234"},
        Notifi = {
        Notifications = true,
        CorrectKey = "Running the Script...",
       Incorrectkey = "The key is incorrect",
       CopyKeyLink = "Copied to Clipboard"
      }
    }
  })

       MinimizeButton({
       Image = "rbxassetid://131758183503639",
       Size = {60, 60},
       Color = Color3.fromRGB(10, 10, 10),
       Corner = true,
       Stroke = false,
       StrokeColor = Color3.fromRGB(255, 0, 0)
      })
      
------ Tab
     local Tab1o = MakeTab({Name = "Blox Fruits Hub"})
     local Tab2o = MakeTab({Name = "Kaitun [BF]"})
     local Tab3o = MakeTab({Name = "Dead Rails"})
     local Tab4o = MakeTab({Name = "JailBreak"})
     local Tab5o = MakeTab({Name = "Blue Lock"})
     local Tab6o = MakeTab({Name= "Rivals"})
     
------- Hub Scripts
    
    AddButton(Tab1o, {
     Name = "W-Azure",
    Callback = function()
        getgenv().Team = "Pirates"
        getgenv().AutoLoad = false --Will Load Script On Server Hop
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))() 
  end
  })
     AddButton(Tab1o, {
     Name = "Astral Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Overgustx2/Main/refs/heads/main/BloxFruits_25.html"))()
  end
  })   AddButton(Tab1o, {
     Name = "Xero Hub",
    Callback = function()
        getgenv().Team = "Marines"
        getgenv().Hide_Menu = false
        getgenv().Auto_Execute = false
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua"))()
  end
  })   AddButton(Tab1o, {
     Name = "HoHo Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
  end
  })   AddButton(Tab1o, {
     Name = "Redz Hub",
    Callback = function()
        local Settings = {
            JoinTeam = "Pirates"; -- Pirates/Marines
            Translator = true; -- true/false
          }
          
          loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings) 
  end
  })   AddButton(Tab1o, {
     Name = "Vzexe Hub[Auto Find Boss]",
    Callback = function()
        getgenv().Team = "Marines"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/VxezeHubHopBoss/refs/heads/main/VxezeHubHopDough.txt"))()
  end
  })   AddButton(Tab1o, {
    Name = "Cuttay Hub [Auto Pull Lever]",
   Callback = function()
       getgenv().Team = "Marines"
       loadstring(game:HttpGet('https://github.com/diemquy/CutTayHub/blob/main/Cuttayhubreal.lua'))() 
 end
 })   AddButton(Tab1o, {
    Name = "BapRed Hub [Vietnamese Version]",
   Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/BapRed/main/BapRedHub"))()
 end
 })

------ Kaitun Scripts

AddButton(Tab2o, {
    Name = "Xero Hub [Kaitun]",
   Callback = function()
    script_key = "" -- premium only, u can leave it blank if ur not
    getgenv().Shutdown = false -- Turn on if u are farming bulk accounts
    getgenv().Configs = {
        ["Team"] = "Marines",
        ["FPS Boost"] = {
            ["Enable"] = false,
            ["FPS Cap"] = 30,
        },
        ["Farm Boss Drops"] = {
            ["Enable"] = false,
            ["When x2 Exp Expired"] = false
        },
        ["Hop"] = { -- premium only
            ["Enable"] = true,
            ["Hop Find Tushita"] = true,
            ["Hop Find Valkyrie Helm"] = true,
            ["Hop Find Mirror Fractal"] = true,
            ["Hop Find Darkbeard"] = true, -- For skull guitar
            ["Hop Find Soul Reaper"] = true, -- For CDK
            ["Hop Find Mirage"] = true, -- For pull lever
            ["Find Fruit"] = true, -- Will find 1m+ fruit to unlock swan door to access third sea
        },
        ["Farm Mastery"] = {
            ["Enable"] = true,
            ["Farm Mastery Weapons"] = {"Sword", "Gun", "Blox Fruit"}, -- Blox Fruit, Gun (left -> right: High -> Low Priority)
            ["Swords To Farm"] = {"Cursed Dual Katana"},
            ["Guns To Farm"] = {"Skull Guitar"},
            ["Mastery Health (%)"] = 40 -- For Blox Fruit, Gun
        },
        ["Farm Config"] = {
            ["First Farm At Sky"] = true,
            ["Farm Bone Get x2 Exp"] = true
        },
        ["Trackstat"] = {
            ["Enable"] = false,
            ["Key"] = "", -- Get from xerohub.click
            ["Device"] = "Skid" -- u can put any name here
        },
        ["Auto Spawn rip_indra"] = true,
        ["Auto Spawn Dough King"] = true,
        ["Auto Pull Lever"] = true,
        ["Auto Collect Berry"] = true,
        ["Auto Evo Race"] = true,
        ["Awaken Fruit"] = true,
        ["Rainbow Haki"] = true,
        ["Hop Player Near"] = true,
        ["Skull Guitar"] = true,
        ["Cursed Dual Katana"] = true,
        ["Switch Melee"] = true,
        ["Eat Fruit"] = "",
        ["Snipe Fruit"] = "",
        ["Lock Fragment"] = 30000,
        ["Buy Stuffs"] = true 
    }
    repeat task.wait() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/kaitun.lua"))() end) until getgenv().Check_Execute
 end
 })   AddButton(Tab2o, {
    Name = "Simple Hub [Kaitun]",
   Callback = function()
    getgenv().simple_settings = {

        ["MASTERY"] = { -- Settings related to leveling up weapon or skill mastery
    
            ["ACTIVE"] = true, -- Enable or disable mastery leveling (true = enabled, false = disabled)
    
            ["METHOD"] = "Half", -- Method for gaining mastery, "Half"[300] or "Full"[600]
    
        },
    
     
    
        ["OBJECTIVE"] = { -- Goals for farming and unlocking features
    
            ["GODHUMAN"] = true, -- Automatically unlock the "Godhuman" fighting style
    
            ["RACE-V3"] = true, -- Automatically upgrade character race to V3 if possible Human, Mink, (Fishman, Ghoul, Cyborg) soon
    
            ["FRAGMENT"] = 100000, -- Limit number of fragments to collect
    
     
    
            -- SWORD
    
            ["CANVANDER"] = true,
    
            ["BUDDY-SWORD"] = true,
    
            ["CURSED-DUAL-KATANA"] = true,
    
            ["SHARK-ANCHOR"] = true, -- soon..
    
     
    
            --GUN
    
            ["ACIDUM-RIFLE"] = true,
    
            ["VENOM-BOW"] = true,
    
            ["SOUL-GUITAR"] = true,
    
        },
    
     
    
        ["FRUITPURCHASE"] = true, -- Automatically purchase fruits based on priority list
    
        ["PRIORITYFRUIT"] = { -- List of preferred fruits to purchase or eat in order of priority
    
            [1] = "Dragon-Dragon",
    
            [2] = "Yeti-Yeti",
    
            [3] = "Leopard-Leopard",
    
            [4] = "Gas-Gas",
    
            [5] = "Kitsune-Kitsune",
    
        },
    
     
    
        ["FPSCAP"] = 144, -- Limit the frame rate to optimize performance
    
        ["LOWTEXTURE"] = true -- Reduce graphic quality for better performance
    
    }
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/simple-hubs/contents/refs/heads/main/bloxfruit-kaitan-main.lua"))()
 end
 })
 ------ Dead Rails

 AddButton(Tab3o, {
    Name = "Skull Hub",
   Callback = function()
    loadstring(game:HttpGet('https://skullhub.xyz/loader.lua'))()
 end
 })   AddButton(Tab3o, {
    Name = "Kagu Hub",
   Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaguya11/KaguHubRework/refs/heads/main/Scripts/Loader.lua", true))()
 end
 })   AddButton(Tab3o, {
    Name = "TBao Hub",
   Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/refs/heads/main/TbaoHubDeadRails"))()
 end
 })
 ------ JailBreak 

 AddButton(Tab4o, {
    Name = "Solix Hub",
   Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua"))()
 end
 })   AddButton(Tab4o, {
    Name = "Auto Rob",
   Callback = function()
    loadstring(game:HttpGet('http://scripts.projectauto.xyz/AutoRobV5'))()
 end
 })   AddButton(Tab4o, {
    Name = "Auto Arrest",
   Callback = function()
    loadstring(game:HttpGet('http://scripts.projectauto.xyz/AutoArrestV3'))()
 end
 })
 ------ Blue Lock

 AddButton(Tab5o, {
    Name = "Ather Hub",
   Callback = function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2529a5f9dfddd5523ca4e22f21cceffa.lua"))()
 end
 })   AddButton(Tab5o, {
    Name = "Nicuse Hub",
   Callback = function()
    loadstring(game:HttpGet("https://nicuse.xyz/MainHub.lua"))()
 end
 })   AddButton(Tab5o, {
    Name = "Pillar Hub",
   Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bhusant/Pillar-chase/refs/heads/main/KeySystem"))()
 end
 })   AddButton(Tab5o, {
    Name = "Express Hub",
   Callback = function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/d8824b23a4d9f2e0d62b4e69397d206b.lua"))() 
 end
 })
 ------ Rivals

 AddButton(Tab6o, {
    Name = "Zenon Hub",
   Callback = function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/241f48b1fc63b8e5c641df2af4b39d0c.lua"))()
 end
 })   AddButton(Tab6o, {
    Name = "Duck Hub",
   Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/HexFG/duckhub/refs/heads/main/loader.lua'))()
 end
 })
