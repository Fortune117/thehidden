if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "ar2"

if CLIENT then
   SWEP.PrintName			= "SG550 Automatic"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 0

end

SWEP.Base				= "weapon_fort_base"


SWEP.Primary.Ammo       = "357" -- Type of ammo
SWEP.Primary.Recoil 	= 3
SWEP.Primary.Damage 	= 45 // Damage
SWEP.Primary.Delay 		= 0.4 //Delay between shots.
SWEP.Primary.Cone 		= 0.008 // Cone
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 40
SWEP.Primary.ClipMax = 40
SWEP.Primary.Automatic = true // Automatic?
SWEP.Primary.Tracer = false // Should we have a tracer?
SWEP.Primary.Sound = Sound( "Weapon_SG550.Single" )
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Force = 50 // Bullet Force

SWEP.InLoadoutMenu = true
SWEP.CalculateStats = true 

SWEP.CrossHairMinDistance = 2 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 3 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 30 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect

SWEP.MoveKick = 0

SWEP.KickVert = 0.1 // View punch vert effect.
SWEP.KickHoriz = 0.1 // View punch horizontal effect.
SWEP.KickMult = 0.1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 5 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.19 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 8

SWEP.KickMove = 0.4 // The divide amount for our movement.
SWEP.MaxMoveKick = 30
SWEP.JumpKick = 3 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = SWEP.KickDecrease*1.6

SWEP.HeadshotMultiplier = 2 // Headshot damage multiplier
SWEP.StomachMult = 1.25 // Stomach damage multiplier
SWEP.LegMult = 0.75 // Leg damage multiplier


SWEP.Type = "pistol" // Used to determine if the weapon is a pistol, shotgun, etc.

SWEP.DeploySpeed = 1 // The speed at which the weapon is deployed.

SWEP.IronSights = false // Don't touch this

SWEP.NextWeaponThink = CurTime() // Don't touch this

SWEP.DeployPunch = Angle(10,5,0) // The view punch when you draw your weapon.


SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70
SWEP.ViewModel			= "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_sg550.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1
