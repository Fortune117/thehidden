if SERVER then
   AddCSLuaFile()
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Deagle"			
   SWEP.Author				= "Fortune"

   SWEP.Slot	= 1

end

SWEP.Base				= "weapon_fort_base"


SWEP.Primary.Ammo       = "AlyxGun" -- Type of ammo
SWEP.Primary.Recoil 	= 1.2
SWEP.Primary.Damage 	= 25 // Damage
SWEP.Primary.Delay 		= 0.5 //Delay between shots.
SWEP.Primary.Cone 		= 0.005 // Cone
SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 14
SWEP.Primary.ClipMax = 14
SWEP.Primary.Automatic = false // Automatic?
SWEP.Primary.Tracer = false // Should we have a tracer?
SWEP.Primary.Sound = "Weapon_Deagle.Single"
SWEP.Primary.DryFireSound = "Weapon_Pistol.Empty" //Empty Clip Sound
SWEP.Primary.Force = 15 // Bullet Force

SWEP.CrossHairMinDistance = 4 // Minimun distance the crosshairs can spread.
SWEP.CrossHairDeltaDistance = 8 // The distance the crosshair rests at while standing.
SWEP.CrossHairMaxDistance = 50 // Maximum

SWEP.TraceNum = 1 // Trace every number of bullets.
SWEP.TraceName = "Tracer" // Trace Effect

SWEP.MoveKick = 0

SWEP.KickVert = 0.5 // View punch vert effect.
SWEP.KickHoriz = 0.5 // View punch horizontal effect.
SWEP.KickMult = 1 // Kick multiplier. Effects your accuracy.
SWEP.Kick = 2 // How much kick is added to the kick mult upon firing.
SWEP.KickDecrease = 0.18 // How much is decreased from the kick mult when not firing?
SWEP.KickDelay = 1 
SWEP.MaxKick = 10

SWEP.KickMove = 0.2 // The divide amount for our movement.
SWEP.MaxMoveKick = 40
SWEP.JumpKick = 3 // How much is added to the kick mult upon jumping.
SWEP.CrouchKick = 0.8 // How much our kick is multiplied by when crouching.
SWEP.CrouchMult = 1 //Don't touch this.
SWEP.CrouchDecrease = SWEP.KickDecrease*1.6

SWEP.HeadshotMultiplier = 2 // Headshot damage multiplier
SWEP.StomachMult = 1.25 // Stomach damage multiplier
SWEP.LegMult = 0.75 // Leg damage multiplier


SWEP.Type = "pistol" // Used to determine if the weapon is a pistol, shotgun, etc.
SWEP.CanSilence = false

SWEP.DeploySpeed = 1 // The speed at which the weapon is deployed.

SWEP.IronSights = false // Don't touch this

SWEP.NextWeaponThink = CurTime() // Don't touch this

SWEP.DeployPunch = Angle(10,5,0) // The view punch when you draw your weapon.


SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.SwayScale = 1
SWEP.BobScale = 1
