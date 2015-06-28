/*
	/------------------------------------------------------------------------------\
   / 	This is where you can edit almost all of the settings for The Hidden.		\	
   \																			 	/
	\------------------------------------------------------------------------------/
*/


//Round/Time settings.
GM.RoundTime = 300 //Default: 300.
GM.RoundLimit = 10  //How many rounds before a map change. Default: 10.
GM.RoundEndTime = 15 //Default: 15. 
GM.RoundPrepTimeCustom = 25 --Prep time if custom mode is enabled. This is high so the Hidden has time to select his stats. Default: 25.
GM.RoundPrepTime = 15 --The round prep time if custom mode is disabled. Default: 15.

GM.SlowAmount = 0 //What the host timeframe is set to when the round ends. Set to 0 to disable. Default: 0.


GM.Hidden = {}
GM.Hidden.Name = "The Hidden" //The name displayed on the scoreboard. Default: "The Hidden".
GM.Hidden.Strength = 10
GM.Hidden.Agility = 10
GM.Hidden.Endurance = 10


--Note: These are the base stats of the hidden. You only need to change these if you disable Custom Mode.
GM.Hidden.Health = 100 // The Hiddens max hp. Default: 100.
GM.Hidden.Speed = 400 // Hiddens move speed. Default: 400.
GM.Hidden.PounceForce = 550 // The velocity of the Hiddens pounce. Default: 550.
GM.Hidden.Stamina = 100 // Max stamina. Default: 100.
GM.Hidden.RegenTime = 7 //Time it takes for stamina to reach max. Default: 10.
GM.Hidden.JumpPower = 250 // Power of the Hiddens jump. Default: 300.
GM.Hidden.Armor = 0 //Armor that the Hidden starts with. Default: 0.
GM.Hidden.Alpha = 8 // Alpha channel for the Hiddens colour. Default: 8.
GM.Hidden.PounceDelay = 0.2 // Delay between pounces in seconds. Default: 0.2.
GM.Hidden.PounceCost = 25 // How much stamina it takes to pounce. Default: 25.
GM.Hidden.StaminaDelay = 0.8 // Delay before stamina starts to recharge (after using an ability, e.g. pouncing) in seconds. Default: 0.8.
GM.Hidden.HangDrain = true // Should hanging onto walls drain stamina? Default: true.
GM.Hidden.HangDrainSpeed = 1 // Speed at which stamina is drained/sec. Default: 1.
GM.Hidden.MaxBodyHeal = 4 // Max amount of times the Hidden can heal from a body. Default: 4.
GM.Hidden.BodyHealAmount = 12 // How much health the Hidden gets for hitting a body. Default: 8.
GM.Hidden.DamageReduction = 0 //What percentage of damage is reduced. Default: 0.
GM.Hidden.DamageMult = 0.33 //How much extra damage the hidden does (% based). Default: 0.33.
GM.Hidden.AttackDelay = 0.6 //Default delay between attacks. Default: 0.6.
GM.Hidden.Model = "models/player/hidden.mdl"
GM.Hidden.Material = "" //The material of the Hidden. The default material is usually "sprites/heatwave", but I'm testing alpha for now.

//Damage reduction options.
//These are here to balance things out when there are lots of players.
GM.Hidden.DamageReductionScaleWithPlayers = true //Determines whether or not damage dealt to the hidden should scale with playercount. Default: true.
GM.Hidden.DamageReductionScaleMax = 0.75 //The maximum damage reduction. 0 = 0%, 1 = 100%. Default: 0.75.
GM.Hidden.DamageReductionScaleMin = 0 //Minimum damge reduction. Default: 0.
GM.Hidden.DamageReductionScaleRatio = 0.03 //How much less damage the hidden takes per player. Default: 0.03.

GM.Hidden.DamageScaleWithPlayers = true //Determines wether or not the Hiddens damage should scale with players.
GM.Hidden.DamageScaleMax =  0.35 //The max percentage of extra damage that the Hidden deals. Default: 0.35.
GM.Hidden.DamageScaleRatio =  0.015 //How much % extra damage the hidden gets per player. Default: 0.015.

//Hud selection options.
// legacy - HUD created faithfully from the original Hidden game.
// new - My version of the HUD.
GM.Hidden.HUD = "new" //Default: legacy.

//Pig Stick Mode
//1 = Normal pig stick. (High damage attack, with a delay and a sound.)
//2 = "Charges Mode", acts like a regular Pig Stick attack but it has a limited number of uses.
//3 = "Push Stick", deals regular damage but sends players flying.
//4 = Disabled.
//5 = "Charges Mode 2", acts like a regular Pig Stick attack but it has a limited number of uses scaled with the number of players.
//6 = "Strength Mode", acts like a regular Pig Stick but you need to meet a strength requirement first.
GM.Hidden.PigStickMode = 1 //Default: 1.
GM.Hidden.PigStickDamage = 150 //Damage that the "Pig Stick" does. Default: 150.
GM.Hidden.PigStickForce = 150 //Damage that the "Pig Stick" does. Default: 150.
GM.Hidden.PickStickCharges = 3 //Max amount of Pig Sticks while in charges mode. Default: 3.
GM.Hidden.PigStickChargesRatio = 0.34 //How many pig sticks per player while charges mode is enabled. Always rounds down. Default: 0.34.
GM.Hidden.PigStickStrengthCap = 15 //How much strength the Hidden has to have to be able to Pig Stick if strength mode is enabled. Default: 15.

GM.Hidden.VisionEnable = true //Determines wether or not the Hidden can turn on "Hidden Vision". Allows the hidden to see players through walls and obstacles. Default: true.
GM.Hidden.VisionHasRange = false //Determines wether or not Hidden Vision will have a max range. Default: false.
GM.Hidden.VisionRange = 1500 //Max range for Hidden Vision if range mode is enabled. Default: 1500.
GM.Hidden.VisionDrain = 2 //Stamina Drained every half second while using Hidden Vision. Default: 2.

//Hidden Selection Mode
// 1 = Random player.
// 2 = The player who did the most damage to the Hidden.
// 3 = A player is chosen out of all those who did damage to the Hidden during the previous round. The chance of being selected is relative to damage dealt.
// 4 = The player who killed the Hidden.
// 5 = Que system. All players are systematically gone through so everyone gets a turn.
GM.Hidden.SelectMode = 3 //Default: 3. 
GM.Hidden.LimitRounds = true // If enabled, the Hidden can only remain the Hidden for a limited number of rounds. Default: true.
GM.Hidden.MaxRounds = 3 //Determines how many rounds in a row somone can remain the Hidden. Default: 3.
GM.Hidden.ChangeMapWhenQueComplete = true //Determines if the map should change only if everyone has had a turn as the Hidden (while in Select mode 5). Default: true.


--Take care editing these. It can, and will, unbalance the game if you don't edit them reasonably.
GM.Hidden.CustomMode = false //Determines wether or not the hidden can choose to edit their stats at the start of the round. Default: true. 
GM.Hidden.AttributePoints = 30 //The amount of ap that the hiddens gets when the round starts.
GM.Hidden.HealthPerStrength = 5 //How much hp the hidden gets from each point of strength. Default: 5.
GM.Hidden.BaseHealth = 50 //The base health of the Hidden with no points in strength. Default: 50.
GM.Hidden.DamageMultPerStrength = 0.033 //How much extra damage the hidden gets per point of strength. Default: 0.012.
GM.Hidden.AttackDelayIncreasePerStrength = 0.009 //How much delay is added between attacks per point of strength. Default: 0.02.
GM.Hidden.SpeedPerAgility = 15//How much extra movespeed the hidden gets per point of agility. Default: 15.
GM.Hidden.BaseSpeed = 300 //The base movespeed of the Hidden with no points in agility. Default: 300.
GM.Hidden.JumpPowerPerAgility = 5 //How much extra jump power the hidden gets per point of agility. Default: 10.
GM.Hidden.BaseJumpPower = 200 //The base jump power of the Hidden with no points into agility. Default: 200.
GM.Hidden.PounceForcePerAgility = 10 //How much extra force the Hiddens' pounce has per agility. Defalut: 10.
GM.Hidden.AttackDelayDecreasePerAgility = 0.009 //How much delay is removed between attacks per point of agility. Default: 0.02.
GM.Hidden.BasePounceForce = 450 //Base force of the Hiddens' pounce. Default: 450.
GM.Hidden.StaminaPerEndurance = 2 //How much extra stamina the hidden gets per point in endurance. Default: 2.
GM.Hidden.BaseStamina = 80 //How much stamina the hidden has without any points in endurance. Default: 50.
GM.Hidden.RegenTimePerEndurance = 0.3 //The amount taken away from the stamina regen time per point of endurance. Default: -0.25.
GM.Hidden.BaseRegenTime = 10 //The base amount of time it takes for the Hiddens' stamina to recharge without any points in endurance. Default: 12.5.
GM.Hidden.DamageReductionPerEndurance = 0.012 //Percentage of damage that is reduced per point of endurance. Default: 0.012.
GM.Hidden.BaseDamageReduction = -0.12 //Percentage of damage that is reduced without any points into endurance. Default: -12.
GM.Hidden.PounceCostPerEndurance = 1.5 //How much is taken off the cost of pouncing per point of endurance. Default: 1.
GM.Hidden.BasePounceCost = 40 //Base amount that pouncing costs with no points in endurance. Default: 35.
GM.Hidden.BaseAttackDelay = 0.6 //Base delay between attacks. Default: 0.6.

GM.Hidden.AllowSpectate = false //Allows players to spectate the Hidden while dead. Default: false.

GM.Hidden.AllowBhop = true //Determines wether or not the Hidden can bunnyhop. Default: True.

GM.Hidden.PropKillDamageScale = 1.5 //How much prop damage from the Hidden is scaled. 1 = 100%. Default: 1.5.

//Before editing this stuff:
//Grenades are important. These allow the Hidden to handle higher amounts of players,
//which is necessary for larger servers. Before you go getting rid of grenades, realise
//that the game is already in favour of the Humans.
//The way this works is this: Number of players / Grenade Ratio. 
//The number is then rounded down. The result is how many grenades the Hidden starts with, set to 0 to disable.
GM.Hidden.GrenadeRatio = 3 //Default: 3.
GM.Hidden.MinimumGrenades = 0 //What the minimum amount of grenades for the Hidden is. Default: 0.
GM.Hidden.MaximumGrenades = 5 //Maximum number of grenades for the Hidden. Default: 5.
GM.Hidden.GrenadeDamage = 70 //Grenades maximun damage.
GM.Hidden.GrenadeBlastRadius = 450 //Radius of the grenades explosion.
GM.Hidden.GrenadeCanDamageSelf = true //Can the Hidden damage himself with grenades? Default: true.
GM.Hidden.GrenadeBlurVision = true //Should the grenade blur the vision of the people it hits? Default: true.
GM.Hidden.GrenadeBlindDuration = 8 //Duration of the blind. Default: 8.
GM.Hidden.GrenadeBlindIntensity = 0.97 //Intensity of the blind. Default: 0.97.

 
 --Human Settings
GM.Jericho = {}
GM.Jericho.Name = "I.R.I.S" //The name that is displayed on the human side of the scoreboard. Default: Jericho.
GM.Jericho.Health = 100 // Humans hp. Default: 100.
GM.Jericho.Speed = 265 // Human move speed. Default: 265.
GM.Jericho.Stamina = 100 // Human stamina. Default: 100.
GM.Jericho.JumpPower = 180 // Power of the humans jump. Default: 180.
GM.Jericho.Armor = 0 // Human armour. Default: 0.
GM.Jericho.Models =  //The models that humans get.
{
	"models/player/riot.mdl",
	"models/player/urban.mdl",
	"models/player/gasmask.mdl",
	"models/player/police.mdl",
	"models/player/police_fem.mdl"
}
GM.Jericho.AllowFlashlight = true //Determines wether or not players can use their flashlight. Default: true.
GM.Jericho.AllowCrosshair = false //Determines wether or not humans have a crosshair. Default: false.


// Captains are randomly selected each round. They have increased, hp, speed, armor, stamina, etc.
GM.Captain = {}
GM.Captain.Enabled = true // Determines whether or not captains are enabled. Default: true.   
GM.Captain.Health = 130 // Captains max hp. Default: 130.
GM.Captain.Speed = 300 // Captains move speed. Default: 300.
GM.Captain.Stamina = 125 // Captains max stamina. Default:: 125.
GM.Captain.JumpPower = 200 // Power of the Captains jump. Default: 200.
GM.Captain.Armor = 0 // Captains starting armor. Default: 30.
GM.Captain.Percentage = 0.1 //What percentage of the humans become captains. There is always at least one. Default: 0.1.
GM.Captain.Models =  //The models that humans get.
{
	"models/player/combine_super_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/combine_soldier.mdl"
}

//Everything to do with radio chatter for Jericho squad.
GM.Radio = {}
GM.Radio.Enabled = true // Determines whether or not Radio Chatter is enabled. Defaukt: true.
GM.Radio.ReplyRange = 900 //The max range a combine can be from another and still reply to radio chatter. Default: 900.

//Misc Settings.
GM.MedpackHeal = 40 //The amount that a player is healed for when a medpack is used on them by an ally. Default: 40.
GM.MedpackHealSelf = 20 //The amount that a player is healed when they used a medpack on themselves. Default: 20.
GM.MedpackRechargeTime = 35 //The amount of time (seconds) that it takes for the medpack to recharge. Default: 35.
GM.MedpackUses = 2 //How many times a medpack can be used in one full charge.
GM.TranqBlindDuration = 12 //How long a tranq dart affects the hiddens vision. Default: 12.
GM.TranqBlindIntensity = 0.96 //How intense the blind effect is. Default: 0.96. Note: Don't put this above 0.98, it'll do some odd stuff.

GM.Admin = {}
GM.Admin.bShowOnScoreboard = true 
GM.Admin.cScoreboardColor = Color( 255, 162, 0, 60 ) 
GM.Admin.cScoreboardColor2 = { Color( 255, 255, 255, 255 ), Color( 255, 162, 0, 255 ), Color( 255, 162, 0, 255 ) }


GM.InfoText = [[

Welcome to The Hidden.

In this gamemode there is one player who is invisible, it is their job to try and eliminate every human.

The humans job is to try and defeat the Hidden, but be careful. He is strong, fast and hungry. 

The Humans have a variety of gadgets to try and defeat the Hidden, hit F2 (by default) to bring up the load out menu. You can select your guns and equipment there.

]]