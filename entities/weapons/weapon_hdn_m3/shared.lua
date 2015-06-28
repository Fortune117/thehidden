if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "ar2"

if CLIENT then
   SWEP.PrintName			= "Benilli M3"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 0

end

SWEP.Base				= "weapon_fort_base"

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Ammo       = "Gravity" -- Type of ammo
SWEP.Primary.Recoil 	= 2
SWEP.Primary.Damage 	= 8 // Damage
SWEP.Primary.Delay 		= 1.2 //Delay between shots.
SWEP.Primary.Cone 		= 0.06 // Cone
SWEP.Primary.ClipSize 	= 8
SWEP.Primary.DefaultClip = 16
SWEP.Primary.ClipMax 	= 16
SWEP.Primary.Bullets 	= 8 //Number of bullets
SWEP.Primary.Automatic 	= true // Automatic?
SWEP.Primary.Tracer 	= false // Should we have a tracer?
SWEP.Primary.Sound		= Sound( "Weapon_M3.Single" )
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Force = 2 // Bullet Force

SWEP.InLoadoutMenu = true
SWEP.CalculateStats = true 

SWEP.CrossHairMinDistance = 15 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 15 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 50 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect

SWEP.MoveKick = 0

SWEP.KickVert = 0.1 // View punch vert effect.
SWEP.KickHoriz = 0.1 // View punch horizontal effect.
SWEP.KickMult = 0.1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 3.3 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.14 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 9

SWEP.KickMove = 0.05 // The divide amount for our movement.
SWEP.MaxMoveKick = 1.9
SWEP.JumpKick = 3 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = SWEP.KickDecrease*1.4

SWEP.HeadshotMultiplier = 2.5 // Headshot damage multiplier
SWEP.StomachMult = 1.25 // Stomach damage multiplier
SWEP.LegMult = 0.75 // Leg damage multiplier


SWEP.Type = "shotgun" // Used to determine if the weapon is a pistol, shotgun, etc.

SWEP.DeploySpeed = 1 // The speed at which the weapon is deployed.

SWEP.IronSights = false // Don't touch this

SWEP.NextWeaponThink = CurTime() // Don't touch this

SWEP.DeployPunch = Angle(10,5,0) // The view punch when you draw your weapon.


SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 64
SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1