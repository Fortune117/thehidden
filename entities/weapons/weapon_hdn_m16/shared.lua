if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "ar2"

if CLIENT then
   SWEP.PrintName			= "Colt M4A1"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 0

end

SWEP.Base				= "weapon_fort_base"


SWEP.Primary.Ammo       = "Pistol" -- Type of ammo
SWEP.Primary.Recoil 	= 2
SWEP.Primary.Damage 	= 21 // Damage
SWEP.Primary.Delay 		= 0.09 //Delay between shots.
SWEP.Primary.Cone 		= 0.0075 // Cone
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true // Automatic?
SWEP.Primary.Tracer = false // Should we have a tracer?
SWEP.Primary.Sound = Sound( "Weapon_M4A1.Single" )
SWEP.Primary.SilencedSound = Sound( "Weapon_M4A1.Silenced" ) // Primary Fire Sound
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Force = 10 // Bullet Force

SWEP.InLoadoutMenu = true

SWEP.CrossHairMinDistance = 3 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 4 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 40 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect

SWEP.MoveKick = 0

SWEP.KickVert = 0.1 // View punch vert effect.
SWEP.KickHoriz = 0.1 // View punch horizontal effect.
SWEP.KickMult = 0.1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 1.4 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.18 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 9

SWEP.KickMove = 0.3 // The divide amount for our movement.
SWEP.MaxMoveKick = 30
SWEP.JumpKick = 3 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = SWEP.KickDecrease*1.6

SWEP.HeadshotMultiplier = 2.1 // Headshot damage multiplier
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
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1
