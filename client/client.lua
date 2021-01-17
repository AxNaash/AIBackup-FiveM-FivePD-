--[[ ORIGINAL UPLOADER MESSAGE :
DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!
DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!
DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!
DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!
DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!			DO NOT DELETE ANYONE OUT OF THE CREDITS JUST ADD YOUR NAME TO IT!!!		
    This is my first GTA Script/Mod i did myself. Like the Scripts/Mods i publish for other Games you can edit, reupload, fix, delete, sniff, smoke or what ever you want with this script.
    JUST DONT DELETE ANYONE OUT OF THE CREDITS AND ADD YOUR NAME TO IT!!!

    Greetings from Germany to all Capitalists around the World! What a nice Life we all have!
*********  !REMEMBER TO FIGHT AGAINST COMMUNISM! *********
]]	
--[[	
    CREDITS:
    (IceHax) - for publishing an incomplete amublance script on cfx.re which gave Mooreiche the idea and basic structure to create this script
    Mooreiche - Original Uploader, huge thanks for uploading & allowing modification !
    Mobius1 - huge thanks for fixing bugs and saving Mooreiche alot of headache!
	AxNaash & Neozander - for adding support of multiple backups & types / following ability for both peds and vehicles / adding an option menu / general improvements
	Warxander - for warmenu
	MrDaGree - for Draw3D function
	
	


************ Hello from France ! Baguette hehe ! ************

--Dependencies : mythic_notify(in /resource folder) + warmenu(in /AIBackup folder, with modified button scale)

]] 







-- variables --
idle_cops_gen = {"idle_a","idle_b","idle_c"}


police        = GetHashKey('police')
fibcar        = GetHashKey('fbi')
sheriffcar    = GetHashKey('sheriff')
swatcar       = GetHashKey('fbi2')
policeman     = GetHashKey("s_m_y_cop_01")
policewoman   = GetHashKey("s_f_y_cop_01")
fibman        = GetHashKey("s_m_m_fibsec_01")
sheriff       = GetHashKey("s_m_y_sheriff_01")
swat          = GetHashKey("s_m_y_swat_01")
bombsquad	  = GetHashKey("u_m_y_juggernaut_01")
bombsquadcar  = GetHashKey('riot')
forensics     = GetHashKey('g_m_m_chemwork_01')
forensicscar  = GetHashKey('policet')

companyName   = "Dispatch"
companyIcon   = "CHAR_CALL911"
drivingStyle  = 537133628 -- https://www.vespura.com/fivem/drivingstyle/  4457020    or 262144       old = 537133628
playerSpawned = false
isfollowing   = false
player_in_car = false
nextOnPursuit = false
deleteBool = false
playerOnDuty = false

maxnum = 5 -- max number of units that you can call -- must be > 2 !
	active 		  = {} 
	vehicle_arrived  	  = {} 
	nearplayer    = {}
	vehicle       = {}
	driver_ped    = {}
	passenger_ped = {} 
	vehBlip       = {}
	drvBlip       = {}
	pasBlip       = {}
	EndPursuit = {}
	distPursuit = {}
	list_of_pursuit_units = {} --
	
for i=1,maxnum do
	active[i] 		  = false
	vehicle_arrived[i]= false
	nearplayer[i]     = false
	vehicle[i]        = nil
	driver_ped[i]     = nil
	passenger_ped[i]  = nil
	vehBlip[i]        = nil
	drvBlip[i]        = nil
	pasBlip[i]        = nil	
	EndPursuit[i]     = true
	
end

requestLocBlip = nil

pursuitIndex = 1 --
idHUD = 1
bcount    = 1
backuptype = {car = police, ped = policeman, weapon1 = GetHashKey("WEAPON_COMBATPISTOL"), weapon2 = GetHashKey("WEAPON_PUMPSHOTGUN"), name = "LSPD"}
backuptype2 = {car = fibcar, ped = fibman, weapon1 = GetHashKey("WEAPON_COMBATPISTOL"), weapon2 = GetHashKey("WEAPON_CARABINERIFLE"), name = "FIB"}
backuptype3 = {car = swatcar, ped = swat, weapon1 = GetHashKey("WEAPON_SMG"), weapon2 = GetHashKey("WEAPON_CARABINERIFLE"), name = "SWAT"}
backuptype4 = {car = sheriffcar, ped = sheriff, weapon1 = GetHashKey("WEAPON_COMBATPISTOL"), weapon2 = GetHashKey("WEAPON_PUMPSHOTGUN"), name = "LSSD"}
backuptype5 = {car = bombsquadcar, ped = bombsquad, weapon1 = GetHashKey("WEAPON_COMBATPISTOL"), weapon2 = GetHashKey("WEAPON_CARABINERIFLE"), name = "Bombing Squad"}
backuptype6 = {car = police, ped = policeman, weapon1 = GetHashKey("WEAPON_STUNGUN"), weapon2 = GetHashKey("WEAPON_PUMPSHOTGUN"), name = "LSPD non-lethal"}  -- !!! works if you have the non-lethal shotgun replacing the pumpshotgun
backuptype7 = {car = police, ped = policewoman, weapon1 = GetHashKey("WEAPON_COMBATPISTOL"), weapon2 = GetHashKey("WEAPON_PUMPSHOTGUN"), name = "LSPD Female"}
backuptype8 = {car = forensicscar, ped = forensics, weapon1 = GetHashKey("WEAPON_COMBATPISTOL"), weapon2 = GetHashKey("WEAPON_COMBATPISTOL"), name = "Forensics"}


bcpindex = 1
backups = {backuptype, backuptype2, backuptype3,backuptype4, backuptype5, backuptype6, backuptype7, backuptype8}
slctd_backup = backups[1]
onroute = 0

polspawn = 0
lastonetrig = 0
lastoneid = 0


local showHeadDisplay = true
local ignorePlayerNameDistance = false
local disPlayerNames = 15
--Requesting dictionnaries


-- spawning events --

RegisterNetEvent('POL:Spawn')
RegisterNetEvent('POL:SpawnInVehicle')

-- AddEventHandler('playerSpawned', function(spawn)  
    playerSpawned = true
-- end)



-- On duty / Off duty on screen  - First time only
if playerOnDuty == true then
	exports['mythic_notify']:PersistentHudText('START',idHUD+3,'inform', "AI Backup : Player is ON Duty", { ['background-color'] = '#000000', ['color'] = '#39d034' })
else
	exports['mythic_notify']:PersistentHudText('START',idHUD+3,'inform', "AI Backup : Player is OFF Duty", { ['background-color'] = '#000000', ['color'] = '#d03434' })
end


 -- keybinds --
Citizen.CreateThread(function() -- Menu integration
	local items = {backuptype.name, backuptype2.name, backuptype3.name, backuptype4.name, backuptype5.name, backuptype6.name,  backuptype7.name,  backuptype8.name}
	local currentItemIndex = 1
	local selectedItemIndex = 1
	local currentUnitsIndex = 1
	local selectedUnitsIndex = 1
	local checkbox = false
	local Nunits = {}
	checkU = {}
	
	for  i =1,18 do            --number of backup units limit = 18+2 = 20
		Nunits[i] = i+2
	end

	for i=1,maxnum do
		checkU[i] = true			
	end	

	WarMenu.CreateMenu('AIBMenu', 'AI Backup Menu')
	WarMenu.SetSubTitle('AIBMenu', 'Options')
	WarMenu.CreateSubMenu('numberOfUnits', 'AIBMenu', 'Set the number of units')
	WarMenu.CreateSubMenu('clearNotifs', 'AIBMenu', 'Are you sure ?')
	WarMenu.CreateSubMenu('followingUnits','AIBMenu','Choose units to follow you')

	while true do	
		if WarMenu.IsMenuOpened('AIBMenu') then
			WarMenu.ToolTip(string.format("~r~Max number of units you can spawn : ~b~%s\n~s~Selected Backup Unit :    ~b~%s",maxnum,slctd_backup.name),0.13)
			if WarMenu.CheckBox('On Duty', checkbox) then
				checkbox = not checkbox
				playerOnDuty = not playerOnDuty
				if playerOnDuty == false then
					exports['mythic_notify']:PersistentHudText('START',idHUD+3,'inform', "AI Backup : Player is OFF Duty", { ['background-color'] = '#000000', ['color'] = '#d03434' })
				else
					exports['mythic_notify']:PersistentHudText('START',idHUD+3,'inform', "AI Backup : Player is ON Duty", { ['background-color'] = '#000000', ['color'] = '#39d034' })
				end	
			elseif WarMenu.ComboBox('Selected Backup', items, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
					currentItemIndex = currentIndex
					selectedItemIndex = selectedIndex

					
					slctd_backup = backups[selectedIndex]
					
					
				end) then
					exports['mythic_notify']:DoHudText('inform', string.format("Selected Backup Type : %s",slctd_backup.name), { ['background-color'] = '#bdc53c', ['color'] = '#000000' })
			elseif WarMenu.Button('~g~Call for backup') then
				if playerOnDuty then
					if playerSpawned and onroute == 1 then
						ShowNotification("Wait until the backup arrives, then press ~b~+")
					elseif playerSpawned and onroute == 0 and lastonetrig == 0 and IsPedInAnyVehicle(PlayerPedId(),false) then
						TriggerEvent('POL:SpawnInVehicle')
					elseif playerSpawned and onroute == 0 and lastonetrig == 0 then
						TriggerEvent('POL:Spawn')	
					elseif bcount == 1 and lastonetrig == 1 then
						ShowNotification("~r~Maximum number of backup units reached !!")
					end 
				else ShowNotification("~r~You are not On Duty !")
				end
			elseif WarMenu.Button('~b~DismissLastUnit ~s~/ ~r~Last:ClearStatScreen') then
				if playerOnDuty then
					LeaveSceneLast()
				else ShowNotification("~r~You are not On Duty !")
				end	
			elseif WarMenu.Button('~r~Dismiss All') then
				if playerOnDuty then
					if not deleteBool  then
						deleteBool = true
						LeaveScene()
						onroute = 0
						polspawn = 0
						lastonetrig = 0
						lastoneid = 0
						deleteBool = false
					else
						ShowNotification("~r~You cannot dismiss all units now, please wait and retry")
					end
				else ShowNotification("~r~You are not On Duty !")
				end
			elseif WarMenu.MenuButton('Set units that can follow you', 'followingUnits') then   --CHECKBOX FOLLOWING UNITS
			
			
			elseif WarMenu.MenuButton('Set the number of backup units', 'numberOfUnits') then
				ShowNotification("~r~Warning : too many backup units can cause problems")
				ShowNotification("Press ~g~Enter ~s~on the selected number then press ~b~Validate")
			
			elseif WarMenu.MenuButton('~r~*!!* Clear all screen notifications','clearNotifs') then
				
			elseif WarMenu.Button('~r~Exit') then
			WarMenu.CloseMenu()
			end

			WarMenu.Display()
				
			
			
		elseif WarMenu.IsMenuOpened('followingUnits') then
			if WarMenu.CheckBox('~b~Show/Hide Head Display', showHeadDisplay) then
				showHeadDisplay = not showHeadDisplay
			end 
			
			if WarMenu.MenuButton('~b~Check/Uncheck All', 'followingUnits') then
				for i=1,maxnum do
					checkU[i] = not checkU[i]
				end
			end
			
			for i=1,maxnum do 
				if WarMenu.CheckBox(string.format('Unit %s',i), checkU[i])	then
					checkU[i] = not checkU[i]
				end
			end	
			
			if WarMenu.MenuButton('~r~Reload', 'followingUnits') then
				for i=1,maxnum do
					checkU[i] = false			
				end	
				for i=1,maxnum do
					WarMenu.CheckBox(string.format('Unit %s',i), checkU[i])				
				end	
				WarMenu.Display()
			end
			WarMenu.Display()
			
			
			
			
		elseif WarMenu.IsMenuOpened('numberOfUnits') then
			WarMenu.ToolTip(string.format("~r~Max number of units you can spawn : ~b~%s",maxnum),0.135)
			if WarMenu.ComboBox('~g~Selected Backup', Nunits, currentUnitsIndex, selectedUnitsIndex, function(currentIndex, selectedIndex)
					currentUnitsIndex = currentIndex
					selectedUnitsIndex = selectedIndex
				end) then
				if lastonetrig == 0 and Nunits[selectedUnitsIndex] >= bcount - 1 then
					maxnum = Nunits[selectedUnitsIndex]
				elseif lastonetrig == 1 and Nunits[selectedUnitsIndex] >= lastoneid then
					maxnum = Nunits[selectedUnitsIndex]
				else
					ShowNotification("~r~You cannot set maximum number of units inferior than used units")
				end
			elseif WarMenu.MenuButton('~b~Validate', 'AIBMenu') then
			end

			WarMenu.Display()
			
		elseif 	WarMenu.IsMenuOpened('clearNotifs') then
			if WarMenu.MenuButton('~r~YES', 'AIBMenu') then
				exports['mythic_notify']:PersistentHudText('END',idHUD)
				exports['mythic_notify']:PersistentHudText('END',idHUD+1)			
				exports['mythic_notify']:PersistentHudText('END',idHUD+2)
				exports['mythic_notify']:PersistentHudText('END',idHUD+3)
				ShowNotification("~r~All notifications have been cleared")
			elseif  WarMenu.MenuButton('NO', 'AIBMenu') then
			end
			WarMenu.Display()
			
		elseif ((IsDisabledControlJustPressed(0, 57) or IsControlJustPressed(0, 57)) and GetLastInputMethod(0)) then -- F10 key --  IsDisabledControlJustPressed(0, 57)
			WarMenu.OpenMenu('AIBMenu')
		end

		Citizen.Wait(0)
	end
	menuOpened = false
end)


Citizen.CreateThread(function() -- show head display 
    while true do
		for id = 1,maxnum do
			if  active[id] and showHeadDisplay then
				
 
				local x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed(-1), true ) )
				local x2, y2, z2 = table.unpack( GetEntityCoords( driver_ped[id], true ) )				
				local x3, y3, z3 = table.unpack( GetEntityCoords( passenger_ped[id], true ) )
				local distance1 = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
				local distance2 = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x3,  y3,  z3,  true))
				
				if(ignorePlayerNameDistance) then
					if checkU[id] then
						DrawText3D(x2, y2, z2+1, string.format("( %s )",id),41, 177, 255)  --blue
						DrawText3D(x3, y3, z3+1, string.format("( %s )",id),41, 177, 255)  --blue
					else
						DrawText3D(x2, y2, z2+1, string.format("( %s )",id),255,255,255)  --white
						DrawText3D(x3, y3, z3+1, string.format("( %s )",id),255,255,255)  --white
					end
				end

				if ((distance1 < disPlayerNames)) then
					if not (ignorePlayerNameDistance) then
						if checkU[id] then
							DrawText3D(x2, y2, z2+1, string.format("( %s )",id),41, 177, 255)  --blue
						else
							DrawText3D(x2, y2, z2+1, string.format("( %s )",id),255,255,255)  --white
						end
					end
				end

				if ((distance2 < disPlayerNames)) then
					if not (ignorePlayerNameDistance) then
						if checkU[id] then
							DrawText3D(x3, y3, z3+1, string.format("( %s )",id),41, 177, 255)  --blue
						else
							DrawText3D(x3, y3, z3+1, string.format("( %s )",id),255,255,255)  --white
						end

					end
				end 
				
			end
		end
		Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function() --Aiming / shooting function 
local player = PlayerId(-1)


	while true do 
		Citizen.Wait(0)
		local AimBool, AimTarget = GetEntityPlayerIsFreeAimingAt(player)	
		local isTargetingUnit = false

		
		if AimBool and not isfollowing then	
			if DoesEntityExist(AimTarget) and IsEntityAPed(AimTarget) then
				
				for i=1,maxnum do      --is it a cop ?
					if driver_ped[i] == AimTarget or passenger_ped[i] == AimTarget then
						isTargetingUnit = true
					end
				end	
				
				
				if not isTargetingUnit then
					for i=1,maxnum do

						if nearplayer[i] then	
							StopAnimTask(driver_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[1],1.0)
							StopAnimTask(passenger_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[1],1.0)
							StopAnimTask(driver_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[2],1.0)
							StopAnimTask(passenger_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[2],1.0)
							StopAnimTask(driver_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[3],1.0)
							StopAnimTask(passenger_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[3],1.0)


							
							TaskAimGunAtEntity(driver_ped[i],AimTarget,-1,true)    --they will aim at entity for 10 sec
							TaskAimGunAtEntity(passenger_ped[i],AimTarget,-1,true)
							

							

						end
					end
					if IsControlJustPressed(1, 24) then   --LEFT MOUSE BUTTON
						for j=1,maxnum do 
							local randWait = math.random(200,1000)
							local decay = math.random(200,400)
							if nearplayer[j] then
								Wait(randWait)
								TaskShootAtEntity(driver_ped[j],AimTarget,1000,'FIRING_PATTERN_SINGLE_SHOT')
								Wait(decay)
								TaskShootAtEntity(passenger_ped[j],AimTarget,1000,'FIRING_PATTERN_SINGLE_SHOT')

							end
						end
						Wait(500)
					end	
	
				end
				if IsControlJustPressed(1, 317) --[[ PageDown ]] then
					for k = 1,maxnum  do 
						if nearplayer[k] then
							ClearPedTasksImmediately(driver_ped[k])
							ClearPedTasksImmediately(passenger_ped[k])	
						end								
					end
					Wait(1000)
				end
			end
		end	

	end
end)



Citizen.CreateThread(function()             --Stop backup from Pursuing you if called in a vehicle 
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 316) --[[ PageUp ]] then
			if bcount > 1 then
				for i=1,bcount-1 do
					EndPursuit[i] = true
				end
			elseif bcount == 1 then
				for i=1,bcount-1+maxnum do
					EndPursuit[i] = true
				end
			end
			ShowAdvancedNotification(companyIcon, companyName, "Info", "~r~Backup is not following you anymore")
			
		end				
	end
end)


Citizen.CreateThread(function()             --Launch
    while true do
        Citizen.Wait(0)
		if ((IsDisabledControlJustPressed(0, 314) or IsControlJustPressed(0, 314)) and GetLastInputMethod(0))--[[ Num+ ]] then
			if playerOnDuty then
				if playerSpawned and onroute == 1 then
					ShowNotification("Wait until the backup arrives, then press ~b~+")
				elseif playerSpawned and onroute == 0 and lastonetrig == 0 and IsPedInAnyVehicle(PlayerPedId(),false)  then
					TriggerEvent('POL:SpawnInVehicle')
				elseif playerSpawned and onroute == 0 and lastonetrig == 0 then
					TriggerEvent('POL:Spawn')	
				elseif bcount == 1 and lastonetrig == 1 then
					ShowNotification("~r~Maximum number of backup units reached !!")
				end
			else ShowNotification("~r~You are not On Duty !")
			end
        end
    end
end)

Citizen.CreateThread(function()				--All Dispatch leaves scene
    while true do
        Citizen.Wait(0)
        if playerSpawned then
            if ((IsDisabledControlJustPressed(0, 296) or IsControlJustPressed(0, 296)) and GetLastInputMethod(0)) --[[ Delete ]] and not deleteBool  then
                deleteBool = true
				LeaveScene()
				onroute = 0
				polspawn = 0
				lastonetrig = 0
				lastoneid = 0
            end
        end
		deleteBool = false
    end
end)

Citizen.CreateThread(function()				--Last Dispatch leaves scene
    while true do
        Citizen.Wait(0)
        if playerSpawned then
            if ((IsDisabledControlJustPressed(0, 315) or IsControlJustPressed(0, 315)) and GetLastInputMethod(0)) --[[ Num- ]] then
                LeaveSceneLast()

            end
        end
    end
end)

Citizen.CreateThread(function()    --function to assign a key to activate the function that allows backup units (all) to follow/unfollow the player. 
    while true do
        Citizen.Wait(0)
		if playerSpawned and nearplayer[1] then
		
			if ((IsDisabledControlJustPressed(0, 74) or IsControlJustPressed(0, 74)) and GetLastInputMethod(0)) and isfollowing == false --[[ H key ]] then
				isfollowing = true
				ShowNotification("~b~Backup is following you")
				ShowNotification("Press ~r~H ~s~to stop following you")


				
			elseif ((IsDisabledControlJustPressed(0, 74) or IsControlJustPressed(0, 74)) and GetLastInputMethod(0)) and isfollowing == true --[[ H key ]] then
				isfollowing = false
				ShowNotification("~r~Backup is not following you anymore")
				for idx = 1,maxnum do
					if active[idx] and checkU[idx] then
						if 	not IsPedInAnyVehicle(driver_ped[idx],false) or not IsPedInAnyVehicle(passenger_ped[idx],false) then
							RequestAnimDict("amb@code_human_police_investigate@idle_a")
							while (not HasAnimDictLoaded("amb@code_human_police_investigate@idle_a")) do 
								Citizen.Wait(0) 
							end

							RequestAnimDict("amb@code_human_police_investigate@idle_b")
							while (not HasAnimDictLoaded("amb@code_human_police_investigate@idle_b")) do 
								Citizen.Wait(0) 
							end
							TaskPlayAnim(driver_ped[idx],"amb@code_human_police_investigate@idle_b","idle_d",1.0,-1.0, -1, 46, 1, true, true, true)
							TaskPlayAnim(passenger_ped[idx],"amb@code_human_police_investigate@idle_a",idle_cops_gen[math.random(1,3)],1.0,-1.0, -1, 46, 1, true, true, true)
						end	
					end
				end
			end
			
			
		end
    end
end)

Citizen.CreateThread(function() --function to make backup units (all) follow the player  ON FOOT after arriving at scene, with a waiting time of 2 sec
    while true do
        Citizen.Wait(3000)
			if playerSpawned then
				if isfollowing then 
					FollowMe()
				end
			end
	end
end)



-- spawning events handlers --
AddEventHandler('POL:Spawn', function(player)
    if not active[bcount] and playerOnDuty then
		polspawn = 1
		onroute = 1
		
		local fcount = bcount
		bcount = bcount %maxnum +1 
		
        if player == nil then
            player = PlayerPedId()
        end

		
        Citizen.CreateThread(function()
            active[fcount] = true
            local pc = GetEntityCoords(player)

			requestLocBlip = AddBlipForCoord( pc.x, pc.y, pc.z)
			SetBlipSprite(requestLocBlip,487)
			SetBlipScale(requestLocBlip,0.8)
			SetBlipColour(requestLocBlip,5)
			
            RequestModel(slctd_backup.ped)
            while not HasModelLoaded(slctd_backup.ped) do
                RequestModel(slctd_backup.ped)
                Citizen.Wait(2)
            end

            RequestModel(slctd_backup.car)
            while not HasModelLoaded(slctd_backup.car) do
                RequestModel(slctd_backup.car)
                Citizen.Wait(2)
            end            

			
            local offset = GetOffsetFromEntityInWorldCoords(player, 0, 50, 50)
            local heading, spawn = GetNthClosestVehicleNodeFavourDirection(offset.x, offset.y, offset.z, pc.x, pc.y, pc.z, math.random(100,150), 0, 0x40400000, 0)

            vehicle[fcount]         = CreateVehicle(slctd_backup.car, spawn.x, spawn.y, spawn.z, heading, true, true)
            driver_ped[fcount]      = CreatePedInsideVehicle(vehicle[fcount], 6, slctd_backup.ped, -1, true, true)
            passenger_ped[fcount]   = CreatePedInsideVehicle(vehicle[fcount], 6, slctd_backup.ped, 0, true, true)

            SetEntityAsMissionEntity(vehicle[fcount])
            SetEntityAsMissionEntity(driver_ped[fcount])
            SetEntityAsMissionEntity(passenger_ped[fcount])     
            
            SetModelAsNoLongerNeeded(slctd_backup.car)
            SetModelAsNoLongerNeeded(slctd_backup.ped)            

            GiveWeaponToPed(driver_ped[fcount], slctd_backup.weapon1, math.random(20, 100), false, true) -- Fahrer/Driver/YYY
            GiveWeaponToPed(passenger_ped[fcount], slctd_backup.weapon2, math.random(20, 100), false, true) -- Beifahrer/Passenger/XXX

            LoadAllPathNodes(true)
            while not AreAllNavmeshRegionsLoaded() do
                Wait(1)
            end   

            -- AI BACKUP Settings --
            local playerGroupId = GetPedGroupIndex(player)
            SetPedAsGroupMember(driver_ped[fcount], playerGroupId) -- Fahrer/Driver/YYY
            SetPedAsGroupMember(passenger_ped[fcount], playerGroupId) -- Beifahrer/Passenger/XXX

            NetworkRequestControlOfEntity(driver_ped[fcount]) -- Fahrer/Driver/YYY
            NetworkRequestControlOfEntity(passenger_ped[fcount]) -- Beifahrer/Passenger/XXX
            ClearPedTasksImmediately(driver_ped[fcount]) -- Fahrer/Driver/YYY
            ClearPedTasksImmediately(passenger_ped[fcount]) -- Beifahrer/Passenger/XXX
            
            local _, relHash = AddRelationshipGroup("POL8")
            SetPedRelationshipGroupHash(driver_ped[fcount], relHash)
            SetPedRelationshipGroupHash(passenger_ped[fcount], relHash)            
            SetRelationshipBetweenGroups(0, relHash, GetHashKey("PLAYER"))
            SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), relHash)



			
            vehBlip[fcount] = AddBlipForEntity(vehicle[fcount])
            SetBlipSprite(vehBlip[fcount],3)
			SetBlipScale(vehBlip[fcount],0.6)
			
			drvBlip[fcount] = AddBlipForEntity(driver_ped[fcount])
            SetBlipSprite(drvBlip[fcount],42)
			SetBlipScale(drvBlip[fcount],0.4)
			
			pasBlip[fcount] = AddBlipForEntity(passenger_ped[fcount])
            SetBlipSprite(pasBlip[fcount],42)
			SetBlipScale(pasBlip[fcount],0.4)

            SetVehicleSiren(vehicle[fcount], true)
            EnterVehicle(driver_ped[fcount],passenger_ped[fcount],vehicle[fcount])
			
			while not IsPedInAnyVehicle(driver_ped[fcount],false) or not IsPedInAnyVehicle(passenger_ped[fcount],false) do
				EnterVehicle(driver_ped[fcount],passenger_ped[fcount],vehicle[fcount])
				Wait(200)
			end
			
			TaskVehicleDriveToCoordLongrange(driver_ped[fcount], vehicle[fcount], pc.x, pc.y, pc.z, 60.0, drivingStyle, 15.0)
            ShowAdvancedNotification(companyIcon, companyName, "Panic Button", "Your Panic Button was triggered. A CODE3 Unit has been dispatched to your location.")
			
			
            vehicle_arrived[fcount] = false
            while not vehicle_arrived[fcount] do
                Citizen.Wait(0)
                local coords = GetEntityCoords(vehicle[fcount])
                local distance = #(coords - pc) -- faster than Vdist
                if distance < 25.0 then
                    vehicle_arrived[fcount] = true
                end
            end
            while GetEntitySpeed(vehicle[fcount]) > 0 do
                Wait(1)
            end
			
			Citizen.Wait(500) 
			if fcount > 1 and (fcount < maxnum) then

				
				exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",fcount), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
				exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - fcount ), { ['background-color'] = '#2f892c', ['color'] = '#afebad' })
			
				
			elseif fcount == maxnum then 

				
				exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",fcount), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
				exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - fcount), { ['background-color'] = '#862323', ['color'] = '#afebad' })

			else

			
				exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",fcount), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
				exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - fcount), { ['background-color'] = '#2f892c', ['color'] = '#afebad' })

				
			end
			
			Citizen.Wait(500)
			
			if active[fcount] then
				
				LeaveVehicle(driver_ped[fcount],passenger_ped[fcount],vehicle[fcount])  
				TaskGoToEntity(driver_ped[fcount],GetPlayerPed(-1), -1, 6.0, 10.0, 1073741824.0, 0)
				TaskGoToEntity(passenger_ped[fcount],GetPlayerPed(-1), -1, 5.0, 10.0, 1073741824.0, 0)
				
				--*-----------------------for pursuit
				
				ped_arrived = false
				while not ped_arrived do
					Citizen.Wait(0)

					local coords0 = GetEntityCoords(driver_ped[fcount])
					local coords1 = GetEntityCoords(passenger_ped[fcount])
					local dist1 = #(coords0 - GetEntityCoords(player))	
					local dist2 = #(coords1 - GetEntityCoords(player))					
					if dist1 < 5.0 and dist2 < 7.0 then
						ped_arrived = true
						ShowAdvancedNotification(companyIcon, companyName, "Your backup has arrived !")
					end
				end
			
			
				nearplayer[fcount] = true  --backup vehicle_arrived at your position
				RemoveBlip(requestLocBlip)
				ShowNotification("Press ~g~H ~s~key to make backup follow you.")
				onroute = 0
				
				local i_random = math.random(1,3)
				RequestAnimDict("amb@code_human_police_investigate@idle_a")
				while (not HasAnimDictLoaded("amb@code_human_police_investigate@idle_a")) do 
					Citizen.Wait(0) 
				end

				RequestAnimDict("amb@code_human_police_investigate@idle_b")
				while (not HasAnimDictLoaded("amb@code_human_police_investigate@idle_b")) do 
					Citizen.Wait(0) 
				end
				TaskPlayAnim(driver_ped[fcount],"amb@code_human_police_investigate@idle_a",idle_cops_gen[i_random],1.0,-1.0, -1, 46, 1, true, true, true)
				TaskPlayAnim(passenger_ped[fcount],"amb@code_human_police_investigate@idle_a",idle_cops_gen[i_random %3 +1],1.0,-1.0, -1, 46, 1, true, true, true)

			end
			
			polspawn = 0
			
			if bcount == 1 then
				lastonetrig = 1
				lastoneid = maxnum
			else
				--ShowNotification("You can press + to spawn another unit.")			
			end	

        end)
		
    end
	
end)




-- spawning events handlers for pursuits --
AddEventHandler('POL:SpawnInVehicle', function(player)
    if not active[bcount] and playerOnDuty then
		polspawn = 1
		onroute = 1
        if player == nil then
            player = PlayerPedId()
        end

        Citizen.CreateThread(function()
            active[bcount] = true
            local pc = GetEntityCoords(player)

            RequestModel(slctd_backup.ped)
            while not HasModelLoaded(slctd_backup.ped) do
                RequestModel(slctd_backup.ped)
                Citizen.Wait(2)
            end

            RequestModel(slctd_backup.car)
            while not HasModelLoaded(slctd_backup.car) do
                RequestModel(slctd_backup.car)
                Citizen.Wait(2)
            end            

			
            local offset = GetOffsetFromEntityInWorldCoords(player, 0, 50, 50)
            local heading, spawn = GetNthClosestVehicleNodeFavourDirection(offset.x, offset.y, offset.z, pc.x, pc.y, pc.z, math.random(100,150), 0, 0x40400000, 0)
			
            vehicle[bcount]         = CreateVehicle(slctd_backup.car, spawn.x, spawn.y, spawn.z, heading, true, true)
            driver_ped[bcount]      = CreatePedInsideVehicle(vehicle[bcount], 6, slctd_backup.ped, -1, true, true)
            passenger_ped[bcount]   = CreatePedInsideVehicle(vehicle[bcount], 6, slctd_backup.ped, 0, true, true)

            SetEntityAsMissionEntity(vehicle[bcount])
            SetEntityAsMissionEntity(driver_ped[bcount])
            SetEntityAsMissionEntity(passenger_ped[bcount])     
            
            SetModelAsNoLongerNeeded(slctd_backup.car)
            SetModelAsNoLongerNeeded(slctd_backup.ped)            

            GiveWeaponToPed(driver_ped[bcount], slctd_backup.weapon1, math.random(20, 100), false, true) -- Fahrer/Driver/YYY
            GiveWeaponToPed(passenger_ped[bcount], slctd_backup.weapon2, math.random(20, 100), false, true) -- Beifahrer/Passenger/XXX

            LoadAllPathNodes(true)
            while not AreAllNavmeshRegionsLoaded() do
                Wait(1)
            end   

            -- AI BACKUP Settings --
            local playerGroupId = GetPedGroupIndex(player)
            SetPedAsGroupMember(driver_ped[bcount], playerGroupId) -- Fahrer/Driver/YYY
            SetPedAsGroupMember(passenger_ped[bcount], playerGroupId) -- Beifahrer/Passenger/XXX

            NetworkRequestControlOfEntity(driver_ped[bcount]) -- Fahrer/Driver/YYY
            NetworkRequestControlOfEntity(passenger_ped[bcount]) -- Beifahrer/Passenger/XXX
            ClearPedTasksImmediately(driver_ped[bcount]) -- Fahrer/Driver/YYY
            ClearPedTasksImmediately(passenger_ped[bcount]) -- Beifahrer/Passenger/XXX
            
            local _, relHash = AddRelationshipGroup("POL8")
            SetPedRelationshipGroupHash(driver_ped[bcount], relHash)
            SetPedRelationshipGroupHash(passenger_ped[bcount], relHash)            
            SetRelationshipBetweenGroups(0, relHash, GetHashKey("PLAYER"))
            SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), relHash)

            vehBlip[bcount] = AddBlipForEntity(vehicle[bcount])
            SetBlipSprite(vehBlip[bcount],3)
			SetBlipScale(vehBlip[bcount],0.6)
			
			drvBlip[bcount] = AddBlipForEntity(driver_ped[bcount])
            SetBlipSprite(drvBlip[bcount],42)
			SetBlipScale(drvBlip[bcount],0.4)
			
			pasBlip[bcount] = AddBlipForEntity(passenger_ped[bcount])
            SetBlipSprite(pasBlip[bcount],42)
			SetBlipScale(pasBlip[bcount],0.4)

            SetVehicleSiren(vehicle[bcount], true)
            EnterVehicle(driver_ped[bcount],passenger_ped[bcount],vehicle[bcount])
			TaskVehicleDriveToCoordLongrange(driver_ped[bcount], vehicle[bcount], pc.x, pc.y, pc.z, 60.0, drivingStyle, 25.0)
            ShowAdvancedNotification(companyIcon, companyName, "Panic Button", "Your Panic Button was triggered. A CODE3 Unit has been dispatched to your location.")
			
			
			while not IsPedInAnyVehicle(driver_ped[bcount],false) and not IsPedInAnyVehicle(passenger_ped[bcount],false) do
			Citizen.Wait(5000)
			end

			if active[bcount] then	
				ShowAdvancedNotification(companyIcon, companyName, "Info", "Press ~b~PageUp ~s~to stop the unit from following you in a vehicle")
				
				Citizen.Wait(0) 
				if bcount > 1 and (bcount < maxnum) then
					
					exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",bcount), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
					exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - bcount ), { ['background-color'] = '#2f892c', ['color'] = '#afebad' })
					
				elseif bcount == maxnum then 
					
					exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",bcount), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
					exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - bcount), { ['background-color'] = '#862323', ['color'] = '#afebad' })
				else
				
					exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",bcount), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
					exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - bcount), { ['background-color'] = '#2f892c', ['color'] = '#afebad' })
					
				end
			

				EndPursuit[bcount] = false
				
				
				list_of_pursuit_units[pursuitIndex] = bcount
				
				
				pursuitIndex = pursuitIndex +1

				bcount = bcount %maxnum +1 
				onroute = 0
			

				PursuitScript()
			end
        end)
    end
end)

-- commands --
RegisterCommand("aib", function()
    local player = PlayerPedId()
			if playerSpawned and onroute == 1 then
				ShowNotification("Wait until the backup arrives, then press ~b~+")
			elseif playerSpawned and onroute == 0 and lastonetrig == 0 and IsPedInAnyVehicle(PlayerPedId(),false) then
                TriggerEvent('POL:SpawnInVehicle')
			elseif playerSpawned and onroute == 0 and lastonetrig == 0 then
                TriggerEvent('POL:Spawn')	
			elseif bcount == 1 and lastonetrig == 1 then
				ShowNotification("~r~Maximum number of backup units reached !!")
            end
end, false)

RegisterCommand("CB", function()
    local player = PlayerPedId()
	for idx = 1,maxnum do
		if player~=nil and active[idx] then
			LeaveScene()
			onroute = 0
			polspawn = 0
			lastonetrig = 0
			lastoneid = 0
		end
	end
end, false)

RegisterCommand("getout", function(source, args)
    local player = PlayerPedId()
	if args[1] == nil then
		print("No backup unit (number) was supplied.")
		return
	end 
	
	local idx = tonumber(args[1])
	if idx < 1 or idx > maxnum then
		print(string.format("Backup unit must be a number between 1 and %s",maxnum))
		return
	end 	

	if player~=nil and active[idx] then
		LeaveVehicle(driver_ped[idx],passenger_ped[idx],vehicle[idx])
	end

	
end, false)

RegisterCommand("getin", function(source, args)
    local player = PlayerPedId()
	if args[1] == nil then
		print("No backup unit (number) was supplied.")
		return
	end 
	
	local idx = tonumber(args[1])
	if idx < 1 or idx > maxnum then
		print(string.format("Backup unit must be a number between 1 and %s",maxnum))
		return
	end 	
	
	if player~=nil and active[idx] and not IsPedInAnyVehicle(driver_ped[idx],false) or not IsPedInAnyVehicle(passenger_ped[idx],false) then
		EnterVehicle(driver_ped[idx],passenger_ped[idx],vehicle[idx])
	end
	
end, false)


RegisterCommand("onduty", function()
	playerOnDuty = true
	exports['mythic_notify']:PersistentHudText('START',idHUD+3,'inform', "AI Backup : Player is ON Duty", { ['background-color'] = '#000000', ['color'] = '#39d034' })
end, false)


RegisterCommand("offduty", function()
	playerOnDuty = false
	exports['mythic_notify']:PersistentHudText('START',idHUD+3,'inform', "AI Backup : Player is OFF Duty", { ['background-color'] = '#000000', ['color'] = '#d03434' })
end, false)


RegisterCommand("stopNotify", function()
	exports['mythic_notify']:PersistentHudText('END',idHUD+3)
end, false)

-- functions --
function EnterVehicle(drv,pas,veh)
    if veh ~= nil then
        TaskEnterVehicle(drv, veh, 2000, -1, 20, 1, 0)
        while GetIsTaskActive(drv, 160) do
            Wait(1)
        end
        TaskEnterVehicle(pas, veh, 2000, 0, 20, 1, 0)
        while GetIsTaskActive(pas, 160) do
            Wait(1)
        end      
    end
end

function LeaveVehicle(drv,pas,veh)
    if veh ~= nil then
        ClearPedTasks(drv)
        TaskLeaveVehicle(drv, veh, 0)
        while IsPedInAnyVehicle(drv, false) do
            Wait(1)
        end
        ClearPedTasks(pas)
        TaskLeaveVehicle(pas, veh, 0)
        while IsPedInAnyVehicle(pas, false) do
            Wait(1)
        end	
    end
end

function LeaveScene()
		for idx = 1,maxnum  do 
			if active[idx] then
				nearplayer[idx] =  false
				
				-- reset --				
				vehicle_arrived[idx]     = false
				isfollowing = false
				active[idx]      = false	
				EndPursuit[idx] = true
				
				Wait(200)
				
				StopAnimTask(driver_ped[idx],"amb@code_human_police_investigate@idle_a",idle_cops_gen[1],1.0)
				StopAnimTask(passenger_ped[idx],"amb@code_human_police_investigate@idle_a",idle_cops_gen[1],1.0)
				StopAnimTask(driver_ped[idx],"amb@code_human_police_investigate@idle_a",idle_cops_gen[2],1.0)
				StopAnimTask(passenger_ped[idx],"amb@code_human_police_investigate@idle_a",idle_cops_gen[2],1.0)
				StopAnimTask(driver_ped[idx],"amb@code_human_police_investigate@idle_a",idle_cops_gen[3],1.0)
				StopAnimTask(passenger_ped[idx],"amb@code_human_police_investigate@idle_a",idle_cops_gen[3],1.0)
				
				ClearPedTasks(driver_ped[idx]) -- Fahrer/Driver/YYY
				ClearPedTasks(passenger_ped[idx]) -- Beifahrer/Passenger/XXX		
				ShowAdvancedNotification(companyIcon, companyName, "Panic Button", "Backup Dispatch has been cancelled.")

				EnterVehicle(driver_ped[idx],passenger_ped[idx],vehicle[idx])

				TaskVehicleDriveWander(driver_ped[idx], vehicle[idx], 17.0, 262315)
				SetEntityAsNoLongerNeeded(vehicle[idx])
				SetPedAsNoLongerNeeded(driver_ped[idx])
				SetPedAsNoLongerNeeded(passenger_ped[idx])
				SetVehicleSiren(vehicle[idx], false)
				
				if DoesBlipExist(requestLocBlip) then
					RemoveBlip(requestLocBlip)
				end
				
				RemoveBlip(vehBlip[idx])
				RemoveBlip(drvBlip[idx])
				RemoveBlip(pasBlip[idx])


			end
		end
		

	--end
	Wait(1000)
	list_of_pursuit_units = {}         
	collectgarbage()
	pursuitIndex = 1
	bcount = 1
	onFootIndex = 0	exports['mythic_notify']:PersistentHudText('END',idHUD)
	exports['mythic_notify']:PersistentHudText('END',idHUD+1)
end

function LeaveSceneLast()
		if bcount == 1 and lastonetrig ==0 then
			if DoesBlipExist(requestLocBlip) then
				RemoveBlip(requestLocBlip)
			end
			ShowNotification("~b~Stat. Screen has been cleared. ~r~There is no backup to send back.")
			isfollowing = false
			exports['mythic_notify']:PersistentHudText('END',idHUD)
			exports['mythic_notify']:PersistentHudText('END',idHUD+1)
		end
		if onroute == 0 and bcount >1 and polspawn == 0 then
			bcount_2 = bcount-1 %maxnum
			if active[bcount_2] then
				nearplayer[bcount_2] =  false
				ClearPedTasks(driver_ped[bcount_2]) -- Fahrer/Driver/YYY
				ClearPedTasks(passenger_ped[bcount_2]) -- Beifahrer/Passenger/XXX		
				ShowAdvancedNotification(companyIcon, companyName, "Panic Button", string.format("Backup Dispatch number %s has been cancelled.",bcount_2))

				EnterVehicle(driver_ped[bcount_2],passenger_ped[bcount_2],vehicle[bcount_2])

				TaskVehicleDriveWander(driver_ped[bcount_2], vehicle[bcount_2], 17.0, 262315)
				SetEntityAsNoLongerNeeded(vehicle[bcount_2])
				SetPedAsNoLongerNeeded(driver_ped[bcount_2])
				SetPedAsNoLongerNeeded(passenger_ped[bcount_2])
				SetVehicleSiren(vehicle[bcount_2], false)
				RemoveBlip(vehBlip[bcount_2])
				RemoveBlip(drvBlip[bcount_2])
				RemoveBlip(pasBlip[bcount_2])
				
				bcount = bcount_2
				-- reset --
				active[bcount]      = false
				vehicle_arrived[bcount]     = false
				onroute = 0
				polspawn = 0
				isfollowing = false
				
				if DoesBlipExist(requestLocBlip) then
					RemoveBlip(requestLocBlip)
				end
				
				if list_of_pursuit_units[pursuitIndex] == bcount then
					local tmpunits = {}
					collectgarbage()
					pursuitIndex = pursuitIndex - 1
					for i = 1,pursuitIndex do
						tmpunits[i] = list_of_pursuit_units[i]
					end
					list_of_pursuit_units = tmpunits
					
				end
				
				
				
				exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",bcount-1), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
				exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - bcount +1), { ['background-color'] = '#2f892c', ['color'] = '#afebad' })
				
				
				
			end
		elseif bcount == 1 and lastonetrig == 1 then
			bcount_2 = maxnum
			if active[bcount_2] then
				nearplayer[bcount_2] =  false
				ClearPedTasks(driver_ped[bcount_2]) -- Fahrer/Driver/YYY
				ClearPedTasks(passenger_ped[bcount_2]) -- Beifahrer/Passenger/XXX		
				ShowAdvancedNotification(companyIcon, companyName, "Panic Button", string.format("Backup Dispatch number %s has been cancelled.",bcount_2))

				EnterVehicle(driver_ped[bcount_2],passenger_ped[bcount_2],vehicle[bcount_2])

				TaskVehicleDriveWander(driver_ped[bcount_2], vehicle[bcount_2], 17.0, 262315)
				SetEntityAsNoLongerNeeded(vehicle[bcount_2])
				SetPedAsNoLongerNeeded(driver_ped[bcount_2])
				SetPedAsNoLongerNeeded(passenger_ped[bcount_2])
				SetVehicleSiren(vehicle[bcount_2], false)
				RemoveBlip(vehBlip[bcount_2])
				RemoveBlip(drvBlip[bcount_2])
				RemoveBlip(pasBlip[bcount_2])
				
				bcount = bcount_2
				-- reset --
				active[bcount]      = false
				vehicle_arrived[bcount]     = false
				onroute = 0
				polspawn = 0
				lastonetrig = 0
				lastoneid = 0
				isfollowing = false


				if DoesBlipExist(requestLocBlip) then
					RemoveBlip(requestLocBlip)
				end


				if list_of_pursuit_units[pursuitIndex] == bcount then
					local tmpunits = {}
					collectgarbage()
					pursuitIndex = pursuitIndex - 1
					for i = 1,pursuitIndex do
						tmpunits[i] = list_of_pursuit_units[i]
					end
					list_of_pursuit_units = tmpunits
				end
				
				

				
				exports['mythic_notify']:PersistentHudText('START',idHUD,'inform', string.format("Used units = %s",bcount-1), { ['background-color'] = '#3d64b8', ['color'] = '#addaeb' })
				exports['mythic_notify']:PersistentHudText('START',idHUD+1,'inform', string.format("Available units = %s",maxnum - bcount +1), { ['background-color'] = '#2f892c', ['color'] = '#afebad' })
			end
		elseif onroute == 1 and polspawn ==  1 then 	--backup onroute but not vehicle_arrived yet 
			ShowAdvancedNotification(companyIcon, companyName, "Panic Button","Wait until the unit arrives to send it back.") 
		end	
end

function FollowMe()
	local player = PlayerPedId()
	local pc = GetEntityCoords(player)

	if not IsPedInAnyVehicle(PlayerPedId(),false) then
		for idx = 1,maxnum do		
			if checkU[idx] then
				local coords0 = GetEntityCoords(driver_ped[idx])
				local coords1 = GetEntityCoords(passenger_ped[idx])
				local distance0 = #((coords0+coords1)/2 - pc)
				local randomDelay  = math.random(200,500)
				
				if nearplayer[idx] then
				TaskLookAtEntity(driver_ped[idx],GetPlayerPed(-1),-1,2048,3)
				TaskLookAtEntity(passenger_ped[idx],GetPlayerPed(-1),-1,2048,3)
				end 
				
				if nearplayer[idx] and distance0 > 2.0 and distance0 <= 6.0 then
					
					TaskGoToEntity(driver_ped[idx],GetPlayerPed(-1), -1, idx+1.5, 1.0, 1073741824.0, 0)
					Wait(randomDelay)
					TaskGoToEntity(passenger_ped[idx],GetPlayerPed(-1), -1, idx+2.0, 1.0, 1073741824.0, 0)

					
				elseif nearplayer[idx] and distance0 > 6.0 then
				
					TaskGoToEntity(driver_ped[idx],GetPlayerPed(-1), -1, idx+5.0, 2.0, 1073741824.0, 0)
					Wait(randomDelay)
					TaskGoToEntity(passenger_ped[idx],GetPlayerPed(-1), -1, idx+4.0, 2.0, 1073741824.0, 0)		
			
				end
			end
		end
	else
	local pvc = GetEntityCoords(GetVehiclePedIsUsing(player))
	
		for idx = 1,maxnum do
			if checkU[idx] then
				if not IsPedInAnyVehicle(passenger_ped[idx],false) and not IsPedInAnyVehicle(driver_ped[idx],false) then
					EnterVehicle(driver_ped[idx],passenger_ped[idx],vehicle[idx])
				end
				
				TaskVehicleDriveToCoordLongrange(driver_ped[idx], vehicle[idx], pvc.x, pvc.y, pvc.z, 60.0, 4457020, 15.0) --4457020  262716
			end
		end
	end
end

function PursuitScript()
	local player = PlayerPedId()
	
	
	
	for i = 1,pursuitIndex-1 do	
		EnterVehicle(driver_ped[list_of_pursuit_units[i]],passenger_ped[list_of_pursuit_units[i]],vehicle[list_of_pursuit_units[i]])
	end
	Wait(1000)
	
	if bcount == 1 then
		lastonetrig = 1
		lastoneid = maxnum
	else
	end	
	
	while not EndPursuit[list_of_pursuit_units[pursuitIndex-1]] and not deleteBool do	
		for i = 1,pursuitIndex-1 do			

			testSpeed = GetEntitySpeed(vehicle[list_of_pursuit_units[i]])
			
			
			local pvc = GetEntityCoords(player)   --GetVehiclePedIsUsing
			distPursuit[list_of_pursuit_units[i]] = #(GetEntityCoords(driver_ped[list_of_pursuit_units[i]]) - GetEntityCoords(player))

			if (GetEntitySpeed(vehicle[list_of_pursuit_units[i]]) < 0.1) and (distPursuit[list_of_pursuit_units[i]]>40.0) then   --to unstuck vehicles if stuck before arriving at destination
				
				Citizen.Wait(100)
				TaskVehicleDriveToCoordLongrange(driver_ped[list_of_pursuit_units[i]], vehicle[list_of_pursuit_units[i]], pvc.x, pvc.y, pvc.z, 180.0, 537133628, 20.0)
				Citizen.Wait(500)
				while (GetEntitySpeed(vehicle[list_of_pursuit_units[i]]) < 10) and not EndPursuit[list_of_pursuit_units[i]] and not deleteBool do
					Wait(1000)
					
				end
			else	

				TaskVehicleDriveToCoordLongrange(driver_ped[list_of_pursuit_units[i]], vehicle[list_of_pursuit_units[i]], pvc.x, pvc.y, pvc.z, 180.0, 537133628, 20.0)  --4457020
				Citizen.Wait(500)
			end
			

			Citizen.Wait(100)
			
		end
	end
	


	for i = 1,pursuitIndex-1 do		
		if active[list_of_pursuit_units[i]] then
			LeaveVehicle(driver_ped[list_of_pursuit_units[i]],passenger_ped[list_of_pursuit_units[i]],vehicle[list_of_pursuit_units[i]])  
			TaskGoToEntity(driver_ped[list_of_pursuit_units[i]],GetPlayerPed(-1), -1, 6.0, 10.0, 1073741824.0, 0)
			TaskGoToEntity(passenger_ped[list_of_pursuit_units[i]],GetPlayerPed(-1), -1, 5.0, 10.0, 1073741824.0, 0)
			
			
			ped_arrived = false
			while not ped_arrived do
				Citizen.Wait(0)
				local coords0 = GetEntityCoords(driver_ped[list_of_pursuit_units[i]])
				local coords1 = GetEntityCoords(passenger_ped[list_of_pursuit_units[i]])
				local dist1 = #(coords0 - GetEntityCoords(player))	
				local dist2 = #(coords1 - GetEntityCoords(player))					
				if dist1 < 5.0 and dist2 < 7.0 then
					ped_arrived = true
					ShowAdvancedNotification(companyIcon, companyName, "Your backup has arrived !")
				end
			end
			
			
			nearplayer[list_of_pursuit_units[i]] = true  --backup vehicle_arrived at your position


			
			--Citizen.Wait(3000)
			local i_random = math.random(1,3)
			RequestAnimDict("amb@code_human_police_investigate@idle_a")
			while (not HasAnimDictLoaded("amb@code_human_police_investigate@idle_a")) do 
				Citizen.Wait(0) 
			end

			RequestAnimDict("amb@code_human_police_investigate@idle_b")
			while (not HasAnimDictLoaded("amb@code_human_police_investigate@idle_b")) do 
				Citizen.Wait(0) 
			end
			TaskPlayAnim(driver_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[i_random],1.0,-1.0, -1, 46, 1, true, true, true)
			TaskPlayAnim(passenger_ped[i],"amb@code_human_police_investigate@idle_a",idle_cops_gen[i_random %3 +1],1.0,-1.0, -1, 46, 1, true, true, true)
		end
	end
	
	if active[list_of_pursuit_units[1]] then          --if delete is pressed before the action is over
		ShowNotification("Press ~g~H ~s~key to make backup follow you.")

	end
	
	
	polspawn = 0

end

function DrawText3D(x,y,z, text,r,g,b) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        --SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        --SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end


-- Notifications --
function ShowAdvancedNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, 4, sender, title, text)
    DrawNotification(false, true)
end

function ShowPersistentNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, false, 4, sender, title, text)
    DrawNotification(false, true)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end


