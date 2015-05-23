if SERVER then
   AddCSLuaFile()
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Glock 18"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 1
end

SWEP.Base				= "weapon_fort_base"


SWEP.Primary.Ammo       = "Pistol" -- Type of ammo
SWEP.Primary.Recoil 	= 2
SWEP.Primary.Damage 	= 25 // Damage
SWEP.Primary.Delay 		= 0.15 //Delay between shots.
SWEP.Primary.Cone 		= 0.005 // Cone
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Tracer = false // Should we have a tracer?
SWEP.Primary.Sound = "Weapon_Glock.Single"
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Force = 15 // Bullet Force


SWEP.CrossHairMinDistance = 2 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 3 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 40 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect

SWEP.MoveKick = 0

SWEP.KickVert = 1 // View punch vert effect.
SWEP.KickHoriz = 1 // View punch horizontal effect.
SWEP.KickMult = 1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 2 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.14 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 10

SWEP.KickMove = 0.2 // The divide amount for our movement.
SWEP.MaxMoveKick = 30
SWEP.JumpKick = 3 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = SWEP.KickDecrease*1.6

SWEP.HeadshotMultiplier = 2 // Headshot damage multiplier
SWEP.StomachMult = 1.25 // Stomach damage multiplier
SWEP.LegMult = 0.75 // Leg damage multiplier


SWEP.Type = "pistol" // Used to determine if the weapon is a pistol, shotgun, etc.
SWEP.CanSilence = false

SWEP.CanBurst = true
SWEP.BurstCount = 3
SWEP.BurstDelay = 0.08
SWEP.Primary.BurstDelay = 0.4
SWEP.BurstMode = false

SWEP.DeploySpeed = 1 // The speed at which the weapon is deployed.

SWEP.IronSights = false // Don't touch this

SWEP.NextWeaponThink = CurTime() // Don't touch this

SWEP.DeployPunch = Angle(10,5,0) // The view punch when you draw your weapon.


SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1
