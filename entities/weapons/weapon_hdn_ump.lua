if SERVER then
   AddCSLuaFile()
end
   
SWEP.HoldType			= "ar2"

if CLIENT then
   SWEP.PrintName			= "UMP-45"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 0
end

SWEP.Base				= "weapon_fort_base"

SWEP.Primary.Ammo       = "smg1" -- Type of ammo
SWEP.Primary.Recoil 	= 1
SWEP.Primary.Damage 	= 22 // Damage
SWEP.Primary.Delay 		= 0.14 //Delay between shots.
SWEP.Primary.Cone 		= 0.0125 // Cone
SWEP.Primary.ClipSize 	= 25
SWEP.Primary.Automatic	= true
SWEP.Primary.DefaultClip = 75
SWEP.Primary.ClipMax 	= 75
SWEP.Primary.Tracer = false // Should we have a tracer?
SWEP.Primary.Sound = Sound( "Weapon_UMP45.Single" )
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Force = 10 // Bullet Force

SWEP.InLoadoutMenu = true
SWEP.CalculateStats = true 

SWEP.CrossHairMinDistance = 3 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 4 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 40 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect

SWEP.MoveKick = 0

SWEP.KickVert = 0.1 // View punch vert effect.
SWEP.KickHoriz = 0.1 // View punch horizontal effect.
SWEP.KickMult = 0.1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 1.8 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.18 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 7

SWEP.KickMove = 0.08 // The divide amount for our movement.
SWEP.MaxMoveKick = 25
SWEP.JumpKick = 3 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = SWEP.KickDecrease*1.6

SWEP.HeadshotMultiplier = 2.7 // Headshot damage multiplier
SWEP.StomachMult = 1.25 // Stomach damage multiplier
SWEP.LegMult = 0.75 // Leg damage multiplier


SWEP.Type = "pistol" // Used to determine if the weapon is a pistol, shotgun, etc.

SWEP.DeploySpeed = 1 // The speed at which the weapon is deployed.

SWEP.IronSights = false // Don't touch this

SWEP.NextWeaponThink = CurTime() // Don't touch this

SWEP.DeployPunch = Angle(10,5,0) // The view punch when you draw your weapon.


SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1
