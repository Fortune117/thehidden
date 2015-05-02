The Hidden was orignially a source mod, it was released a long time ago and has pretty much died. This is a recreation of the gamemode in Garrys Mod. Thanks for takeing the time to download it, I hope you enjoy :D.

Thanks to: Mr. Gash - The round system I used was largely based on the one from his Deathrun gamemode. The Original Hidden Creators - Models for the hidden and his weapons. twoski - Numerous small amounts of code from his "The Stalker" gamemode.

To install, just drag into your servers gamemodes folder. You may need to Copy the files from thehidde/content into your garrysmod/garrysmod directory for fastdl to work.

Configuration: The gamemode comes with its own config file. Just edit config.lua to make any changes you'd like. I recommend checking this file before asking any questions about making changes or additions to the gamemode - it might already be there! If you have any requests for additional settings feel free to make a request.

Adding new weapons: If you want to add a new weapon to the humans loadout menu, there's a simple way to do it. Simply put the weapon you wish to add into thehidden/entities/weapons. Inside the weapons shared or cl_init lua files (doesn't matter which one) put this one line in: SWEP.InLoadoutMenu = true

Your weapon will now appear in the humans loadout menu! However, if you do not want your weapon to be considered when calculating weapon stats (this is important, you can break the weapon stats otherwise), add this line: SWEP.DontCalculateStats = true

Adding New Equipment: Go into the sh_loadout.lua file and you'll find a huge table filled with all the equipment. If you're proficient with lua, go right ahead and add your own stuff, it's not that complicated. Otherwise, you might not want to mess around with it.

Hooks:

Format HookName( args ) -Description

HDN_OnHiddenDeath( The Hidden, Killer, Damage Info ) Called when the hidden dies.

HDN_GetScoreValue( Victim, Killer ) Called when a player is killed by another player. Returns how many points the player earns.

HDN_OnPlayerHealed( Player, amount ) Called when a player is healed by a medkit.

HDN_OnHumanSpawn( Player ) Called when a human spawns.

HDN_OnHiddenSpawn( Player ) Called when the hidden spawns.

HDN_OnPounce( Player ) Called when the hidden pounces.

HDN_OnBecomeCaptain( Player ) Called when a player becomes a captain.

HDN_OnStaminaChange( Player, Old Stamina, New Stamina ) Called when the Hiddens stamina changes for any reason.

HDN_OnBlind( Player, Duration, Intensity ) Called when a player is "blinded". e.g. When the Hidden is shot by a tranquilizer.

HDN_OnTaunt( Player, Taunt Table ) Called when the Hidden taunts. The table is a table of sounds.

HDN_OnApplyStats( Player, Strength, Agility, Endurance ) Called when The Hidden confirms his choice of stats while in custom mode.

HDN_OnRoundChange( State ) Called whenver the round changes state. State can be one of 4 things: ROUND_WAITING ROUND_PREPARING ROUND_ACTIVE ROUND_ENDED

HDN_OnWin( Winning Team ) Called when the round is won.

OnLoadoutGiven( Player, Weapon Classname ) Called when a player is given their primary weapon.

My Steam: http://steamcommunity.com/profiles/76561198042278484/
