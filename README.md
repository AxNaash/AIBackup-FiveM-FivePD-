# AIBackup for FiveM-FivePD
 **PLEASE READ EVERYTHING BEFORE USING IT.**
 
 **CHANGELOG** :
 


Version 1.0.1   : Controller Button presses are no longer taken into account.
Version 1.0.1b : Bug fix : Backup Units now shoot when shooting with a Controller.


/


**INSTALL INSTRUCTIONS** : Make sure to rename the downloaded folder "AIBackup-FiveM-FivePD--main" to "AIBackup" so that you can load it easily, then paste it in your /resource folder. **To run this, you will also have to download JayMontana36/mythic_notify on GitHub and start it (‘ensure mythic_notify’) before ‘ensure AIBackup’ in your server.cfg**. 

*This has been tested on a local server with two players.

First of all, you can use the **integrated menu** or **key shortcuts**.


There is no integration with the FivePD On Duty/Off Duty state so you have to be On Duty in AIBackup **individually** to spawn AI backup units.  
Check the On Duty box to get On/Off Duty. A black notification on the top right of the screen displays your AIBackup state. 


Whether you are On Duty or Off Duty in AIBackup, you can select the backup unit type that you’d like to call. To select another unit, scroll left/right then press Enter. 
Here are the available backup units : 

    LSPD (default cop car and default cop ped model)
    FIB (FIB car and ped model)
    SWAT(GrangerFIB car and SWAT model)
    Bombing Squad (Riot car and Juggernaut model)
    LSPD non-lethal (the default one with non-lethal weapons : stun-gun + pump shotgun). 

**IMPORTANT** : for the last one to be **non-lethal** you have to download the nonlethal shotgun resource and start it in your server. Otherwise, you can change the ‘weapon 2 = WEAPON_PUMPSHOTGUN’ in backuptype6 in the client.lua to ‘WEAPON_STUNGUN’.



You can change the maximum number of units you can call by hitting ‘Set the number of backup units’. It is set to **5 by default**. 
**IMPORTANT** : If you called a number ‘A’ of backup units and then change the maximum number of units :
* if the new maximum is less than ‘A’, that won’t work !
* if the new maximum is greater or equal to ‘A’, ok cool, now you can call more units !


You can clear the top right notifications by hitting ‘*!* Clear all screen notifications’ on the menu.


Once On Duty in AIBackup, you can call units by using two types of functions :
* If you are **on foot** when hitting the call button (‘Call backup units’ in the menu or ‘+’ on the numpad), POL:Spawn function is activated. You can call an additional unit only after the current unit has arrived at its destination (they will have to drive to the yellow protection blip on the minimap - your position -, exit their vehicle and come to you). They have to be close enough to you to end the function. This happens when the notification ‘Press H to make backup follow you’ pops up.
* If you are **in a vehicle** when hitting the call button, POL:SpawnInVehicle function is activated. The spawned unit will follow you in their vehicle **until you hit ‘PageUp’**. If you hit ‘PageUp’ and the unit is far from you, they will exit their vehicle and come to the last position saved **on foot** !! *We do not advise pressing ‘PageUp’ if there are units in vehicles that are very far from you. 


If your backup units are **on scene** and are **not following you** then, if you **aim** at a ped (NPC or player excluding your backup units), all your backup units on scene will aim at it **indefinitely**. To get them to stop aiming, you will have to **aim at a ped** (cop or other peds) and **simultaneously press ‘PageDown’** while still aiming at that ped (very important).

If you shoot while aiming at a ped (excluding your backup units) they will shoot. Other players and their backup units will not take damage but stungun still has an effect on other players sometimes (without any damage).

**IMPORTANT** : As mentioned earlier backup units will not perform these actions (aim and shoot) if they are following the player, i.e if the ‘following action’ is activated (by pressing ‘H’ ) until it is deactivated (by pressing ‘H’ once again).


—— KEYBINDS ——

You can modify these in ‘client.lua’ :

Selecting on the menu is done by pressing ‘Enter’ on the **main keypad** (not on the numeric keypad).

By pressing ‘F10’, you can bring AIBackup Menu. **Press ‘Back’ (not ‘F10’)** or Exit Button in the Menu to close it.

By pressing ‘+’ on the numeric keypad or ‘Call a backup unit‘ on the menu, you can call backup units. 

By pressing ‘-’ on the numeric keypad or ‘DismissLastUnit / ClearStatScreen‘ on the menu, you can dismiss the last called backup unit BUT **you can only use it once all units are on scene** (when it tells you that you can Press H to make them follow you). If you dismiss all units one by one, the notifications on the top right of the screen won’t disappear. You’ll have « Used units = 0 ». You have to **manually hide them** by selecting ‘DismissLastUnit / ClearStatScreen‘ again on the menu.

By pressing ‘PageDown’ **AND (very important) AIMING** at a ped (cop or other peds), backup units on scene stop aiming. 

By pressing ‘PageUp’, backup units if called when being **in a vehicle** will stop their car, exit their vehicle and come to the last destination (your position) saved before pressing it. 

By pressing ‘Delete’ or ‘Dismiss All’ in the Menu, all units are dismissed. 

You can select which units do follow you by pressing the 'Set units that can follow you' button on the menu then checking each one. **If the option for Unit x is checked, unit x will follow you**. You can also show/hide their unit index above their heads (gets blue if the unit is following, it is white otherwise). If the number of options is incorrect (after changing the max number of units for instance) you can reload the available options using the 'Reload' button.
By pressing ‘H’ when backup units are **on foot** and **near you**, they follow you. If you press it another time, they will stop following you. Etc.. If the ‘following action’ is activated :
* if you are on foot, spawned backup units will follow you on foot. 
* if you are in a vehicle, spawned backup units will follow you in their vehicle.


—— CREDITS ——
* (IceHax) - for publishing an incomplete amublance script on cfx.re which gave Mooreiche the idea and basic structure to create this script
* Mooreiche - Original Uploader, huge thanks for uploading & allowing modification !
* Mobius1 - huge thanks for fixing bugs and saving Mooreiche alot of headache!
* AxNaash & Neozander - for adding support of multiple backups & types / following ability for both peds and vehicles / adding an option menu / general improvements
* Warxander - for warmenu
* MrDaGree - for Draw3D function
  
**As the orignal uploader inquired, you can edit, reupload, fix, delete, sniff, smoke or what ever you want with this script.**
   **JUST DONT DELETE ANYONE OUT OF THE CREDITS AND ADD YOUR NAME TO IT!!!**
